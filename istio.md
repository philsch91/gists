# Istio

-> Gateway -> VirtualService [-> DestinationRule] -> Service<br />
<- VirtualService [<- DestinationRule] <- ServiceEntry

## Deployment.v1.apps

```
# nodePort = node port
# port = load balancer port
# targetPort = container port
k -n <istio-system-ns> get service -l app=istio-ingressgateway,istio=<custom>-ingressgateway -o jsonpath='{.items[*].spec.type}{"\t"}{.items[*].spec.ports}'
k -n <istio-system-ns> get deployment -l app=istio-ingressgateway,istio=<custom>-ingressgateway -o jsonpath='{.items[*].spec.template.spec.containers[0].ports[*].containerPort}'

k -n <istio-system-namespace> get deployment -l app=istio-ingressgateway,operator.istio.io/component=IngressGateways
k -n <istio-system-namespace> get deployment/istio-ingressgateway -o yaml
k -n <istio-system-namespace> get deployment/istio-ingressgateway -o json | jq -r '.spec.template.spec.containers[].name'
```

### Deployment logs
```
k -n <istio-system-ns> logs -f -l app=istio-ingressgateway,istio=<custom>-ingressgateway [| grep -iE "cert|secret|tls|ssl"]
k -n <istio-system-ns> logs -f -l app.kubernetes.io/name=istiod
```

### Deployment exe
```
# curl
k -n <istio-system-ns> exec -it $(kubectl -n <istio-system-ns> get pod -l istio=<custom>-ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- curl "http://localhost:15000/certs"
k -n <istio-system-ns> exec -it $(kubectl -n <istio-system-ns> get pod -l istio=<custom>-ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- curl -s "http://localhost:15000/config_dump?include_eds" | grep -C 10 "9093"
k -n <istio-system-ns> exec -it $(kubectl -n <istio-system-ns> get pod -l istio=<custom>-ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- curl -s "http://localhost:15000/config_dump?include_eds" | grep -A 50 "0.0.0.0_9093" | grep -E "tls_context|common_tls_context|secret_name"
kubectl -n <istio-system-ns> exec -it $(kubectl -n <istio-system-ns> get pod -l istio=<custom>-ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- curl "http://localhost:15000/listeners"
0.0.0.0_15090::0.0.0.0:15090
0.0.0.0_15021::0.0.0.0:15021
0.0.0.0_30552::0.0.0.0:30552
0.0.0.0_5440::0.0.0.0:5440
0.0.0.0_27020::0.0.0.0:27020
0.0.0.0_5432::0.0.0.0:5432
# openssl
k exec -n <istio-system-ns> -it $(kubectl -n <istio-system-ns> get pod -l istio=<custom>-ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- openssl x509 -in /etc/istio/ingressgateway-certs/tls.crt -text -noout
k exec -n <istio-system-ns> -it $(kubectl -n <istio-system-ns> get pod -l istio=<custom>-ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- curl -s localhost:15000/stats
```

## Service
```
echo "test" | nc "$(kubectl -n <istio-system-ns> get svc/istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')" 443
```

## IstioOperator.v1alpha1.install.istio.io

- `IstioOperator` creates Ingress-Gateway deployment and service
- `Service` of Ingress-Gateway deployment opens port on load balancer
- `VirtualService` opens listener in Envoy proxy

```
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: <custom>-ingressgateway
  namespace: istio-system
spec:
  namespace: istio-system
  profile: empty
  hub: 12345678910.dkr.ecr.eu-central-1.amazonaws.com/istio # Replace with value from cm resource to avoid pulling from Docker hub
  components:
    ingressGateways:
    - name: <custom>-ingressgateway
      namespace: istio-system
      enabled: true
      label:
        # Set a unique label for the gateway. This is required to ensure Gateways can select this workload
        istio: <custom>-ingressgateway # This will be used in Gateway resources as selector
      k8s:
        hpaSpec:
        nodeSelector:
          kubernetes.io/os: linux
        priorityClassName: system-cluster-critical
        replicaCount: 1
        podAnnotations:
          sidecar.istio.io/inject: "false"
        resources:
          limits:
            cpu: 200m
            memory: 512Mi
          requests:
            cpu: 200m
            memory: 512Mi
        service:
          ports:
          - name: tcp-status-port
            port: 15020 # Use this one first on EKS because Loadbalancer will use the first entry for healthcheck
            targetPort: 15020
        {{- range $tcpPort := .Values.gateway.tcp.ports }}
          - name: tcp-{{ $tcpPort.name }}
            port: {{ $tcpPort.port }}
            targetPort: {{ $tcpPort.port }}
        {{- end }}
        {{- range $port := .Values.istiooperator.ports }}
          - name: {{ $port.name }}
            port: {{ $port.port }}
            targetPort: {{ $port.targetPort }}
        {{- end }}
        serviceAnnotations:
          service.beta.kubernetes.io/aws-load-balancer-type: external
          service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags: tagkey.tagname=value,tagkey2.tagname2=value
          service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
          service.beta.kubernetes.io/aws-load-balancer-internal: "true"
          service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: instance
          service.beta.kubernetes.io/aws-load-balancer-manage-backend-security-group-rules: "true"
          service.beta.kubernetes.io/aws-load-balancer-subnets: subnet-<id>,subnet-<id2>
          service.beta.kubernetes.io/aws-load-balancer-security-groups: sg-<id>
          service.beta.kubernetes.io/aws-load-balancer-extra-security-groups: {{ .Values.gateway.tcp.eksIngressSecGroup }}
          service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: {{ .Values.gateway.tcp.timeout | default "60" | quote }}
          service.beta.kubernetes.io/aws-load-balancer-target-group-attributes: preserve_client_ip.enabled=false,proxy_protocol_v2.enabled=true
          external-dns.alpha.kubernetes.io/hostname: '*.<cluster>-gw.<r53-zone>.org.com'
  meshConfig:
    accessLogFile: /dev/stdout
    accessLogFormat: |
      [ %START_TIME% ] %REQ(:METHOD)% %PROTOCOL% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%
      %RESPONSE_CODE% %RESPONSE_FLAGS% %BYTES_RECEIVED% %BYTES_SENT% %DURATION%
      %REQ(X-FORWARDED-FOR)% %REQ(X-REQUEST-ID)% %REQ(:AUTHORITY)%
      %UPSTREAM_HOST% %UPSTREAM_TRANSPORT_FAILURE_REASON% %DOWNSTREAM_TLS_VERSION%
    defaultConfig:
      holdApplicationUntilProxyStarts: true
      tracing: {}
    rootNamespace: istio-system
  values:
    global:
      istioNamespace: istio-system
      proxy:
        logLevel: debug
        resources:
          limits:
            cpu: 500m
            memory: 512Mi
          requests:
            cpu: 100m
            memory: 128Mi
    gateways:
      istio-ingressgateway:
        injectionTemplate: gateway
```

## Gateway.v1.networking.istio.io

- Gateway defined with `.spec.servers[].tls.mode: SIMPLE` is (only) compatible with VirtualService defined with `.spec.tcp[].match[].port`
- Gateway defined with `tls.mode: SIMPLE`: SNI routing (redirection) based on `.spec.hosts` and `.spec.tcp` of VirtualService
- Gateway defined with `.spec.servers[].tls.mode: PASSTHROUGH` is compatible with VirtualService defined with `.spec.tls[].match[].sniHosts[]`

```
# Nginx-ingress equivalent: Ingress
k [-n <istio-system-namespace>] get gateway.v1.networking.istio.io [-A]
k -n <namespace> get gateway/<gateway-name> -o json | jq -r '.spec.servers[].tls.credentialName'
---
apiVersion: networking.istio.io/v1
kind: Gateway
metadata:
  annotations:
  labels:
  name: wildcard-gateway
  namespace: istio-system
spec:
  selector:
    app: istio-ingressgateway
  servers:
  - hosts:
    - '*.<cluster>-gw.<r53-zone>.org.com'
    port:
      name: HTTPS-ingress
      number: 443
      protocol: HTTPS
    tls:
      credentialName: istio-wildcard
      maxProtocolVersion: TLSV1_3
      minProtocolVersion: TLSV1_2
      mode: SIMPLE
```

## EnvoyFilter.v1alpha3.networking.istio.io
```
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: envoyfilter-remove-server-header
  namespace: istio-system
spec:
  configPatches:
    - applyTo: NETWORK_FILTER
      match:
        context: GATEWAY
        listener:
          filterChain:
            filter:
              name: envoy.filters.network.http_connection_manager
      patch:
        operation: MERGE
        value:
          typed_config:
            '@type': type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
            server_header_transformation: PASS_THROUGH
---
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: envoyfilter-proxy-protocol
  namespace: istio-system
spec:
  configPatches:
    - applyTo: LISTENER_FILTER
      match:
        context: GATEWAY
        listener:
          portNumber: 30552
      patch:
        operation: INSERT_FIRST
        value:
          name: envoy.filters.listener.proxy_protocol
          typed_config:
            '@type': type.googleapis.com/envoy.extensions.filters.listener.proxy_protocol.v3.ProxyProtocol
            allow_requests_without_proxy_protocol: true
```

## ServiceEntry.v1.networking.istio.io
```
apiVersion: networking.istio.io/v1
kind: ServiceEntry
metadata:
  name: external-svc-https
spec:
  hosts:
  - api.dropboxapi.com
  - www.googleapis.com
  - api.facebook.com
  location: MESH_EXTERNAL
  ports:
  - number: 443
    name: https
    protocol: TLS
  resolution: DNS
```

## VirtualService.v1.networking.istio.io

```
k [-n <namespace>] get VirtualService.v1.networking.istio.io [-A]
k -n <namespace> get virtualservice/<virtualservice-name> -o json | jq -r '.spec.gateways'
```

```
apiVersion: networking.istio.io/v1
kind: ServiceEntry
metadata:
  name: external-svc-redirect
spec:
  hosts:
  - wikipedia.org
  - "*.wikipedia.org"
  location: MESH_EXTERNAL
  ports:
  - number: 443
    name: https
    protocol: TLS
  resolution: NONE
```

```
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata:
  name: tls-routing
spec:
  hosts:
  - wikipedia.org
  - "*.wikipedia.org"
  tls:
  - match:
    - sniHosts:
      - wikipedia.org
      - "*.wikipedia.org"
    route:
    - destination:
        host: internal-egress-firewall.ns1.svc.cluster.local
```

## DestinationRule.v1.networking.istio.io

```
apiVersion: networking.istio.io/v1
kind: ServiceEntry
metadata:
  name: external-svc-mongocluster
spec:
  hosts:
  - mymongodb.somedomain # not used
  addresses:
  - 192.192.192.192/24 # VIPs
  ports:
  - number: 27018
    name: mongodb
    protocol: MONGO
  location: MESH_INTERNAL
  resolution: STATIC
  endpoints:
  - address: 2.2.2.2
  - address: 3.3.3.3
```

```
apiVersion: networking.istio.io/v1
kind: DestinationRule
metadata:
  name: mtls-mongocluster
spec:
  host: mymongodb.somedomain
  trafficPolicy:
    tls:
      mode: MUTUAL
      clientCertificate: /etc/certs/myclientcert.pem
      privateKey: /etc/certs/client_private_key.pem
      caCertificates: /etc/certs/rootcacerts.pem
```

## istioctl

istioctl bash
```
source <(istioctl completion bash)
```

istioctl zsh
```
echo "autoload -U compinit; compinit" >> ~/.zshrc
source <(istioctl completion zsh)
```

```
istioctl version -i <istio-system-namespace>
istioctl verify-install -i <istio-system-namespace>
istioctl [-n <namespace>] admin log <pod-name>
istioctl [-n <namespace>] proxy-status [type/]<name>[.<namespace>]
istioctl proxy-config all|listeners|route|log -i <istio-system-namespace> [type/]<name>[.<namespace>] [--port 8080]
istioctl proxy-config listener <ingress-pod-name> -n <namespace> --port 9093 -o json
istioctl proxy-config route <ingress-pod-name> -n <namespace> --port 9093
istioctl proxy-config log <ingress-pod-name> -n <namespace> --level conn_handler:debug,filter:debug
```

### analyze

```
istioctl analyze --namespace <namespace>
```

### bug-report

```
istioctl bug-report
```
