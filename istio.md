# Istio

-> Gateway -> VirtualService [-> DestinationRule] -> Service<br />
<- VirtualService [<- DestinationRule] <- ServiceEntry

## Deployment.v1.apps

```
# nodePort = node port
# port = load balancer port
# targetPort = container port
k -n <istio-system-ns> get service -l app=istio-ingressgateway,istio=prod-ingressgateway -o jsonpath='{.items[*].spec.type}{"\t"}{.items[*].spec.ports}'
k -n <istio-system-ns> get deployment -l app=istio-ingressgateway,istio=prod-ingressgateway -o jsonpath='{.items[*].spec.template.spec.containers[0].ports[*].containerPort}'

k -n <istio-system-namespace> get deployment/istio-ingressgateway -o yaml
k -n <istio-system-namespace> get deployment/istio-ingressgateway -o json | jq -r '.spec.template.spec.containers[].name'
```

### Deployment logs
```
k -n <istio-system-ns> logs -f -l app=istio-ingressgateway,istio=nprod-trans-gw-ingressgateway [| grep -iE "cert|secret|tls|ssl"]
k -n <istio-system-ns> logs -f -l app.kubernetes.io/name=istiod
```

### Deployment exe
```
# curl
k -n <istio-system-ns> exec -it $(kubectl -n <istio-system-ns> get pod -l istio=ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- curl "http://localhost:15000/certs"
k -n <istio-system-ns> exec -it $(kubectl -n <istio-system-ns> get pod -l istio=ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- curl -s "http://localhost:15000/config_dump?include_eds" | grep -C 10 "9093"
k -n <istio-system-ns> exec -it $(kubectl -n <istio-system-ns> get pod -l istio=ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- curl -s "http://localhost:15000/config_dump?include_eds" | grep -A 50 "0.0.0.0_9093" | grep -E "tls_context|common_tls_context|secret_name"
kubectl -n <istio-system-ns> exec -it $(kubectl -n <istio-system-ns> get pod -l istio=ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- curl "http://localhost:15000/listeners"
0.0.0.0_15090::0.0.0.0:15090
0.0.0.0_15021::0.0.0.0:15021
0.0.0.0_30552::0.0.0.0:30552
0.0.0.0_5440::0.0.0.0:5440
0.0.0.0_27020::0.0.0.0:27020
0.0.0.0_5432::0.0.0.0:5432
# openssl
k exec -n <istio-system-ns> -it $(kubectl -n <istio-system-ns> get pod -l istio=ingressgateway -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- openssl x509 -in /etc/istio/ingressgateway-certs/tls.crt -text -noout
```

## Service
```
echo "test" | nc "$(kubectl -n <istio-system-ns> get svc/istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')" 443
```

## IstioOperator.v1alpha1.install.istio.io

- `IstioOperator` creates Ingress-Gateway deployment and service
- `Service` of Ingress-Gateway deployment opens port on load balancer
- `VirtualService` opens listener in Envoy proxy

## Gateway.v1.networking.istio.io

- Gateway defined with `.spec.servers[].tls.mode: SIMPLE` is (only) compatible with VirtualService defined with `.spec.tcp[].match[].port`
- Gateway defined with `tls.mode: SIMPLE`: SNI routing (redirection) based on `.spec.hosts` and `.spec.tcp` of VirtualService
- Gateway defined with `.spec.servers[].tls.mode: PASSTHROUGH` is compatible with VirtualService defined with `.spec.tls[].match[].sniHosts[]`

Nginx-ingress equivalent: Ingress

```
k [-n <istio-system-namespace>] get gateway.v1.networking.istio.io [-A]
k -n <namespace> get gateway/<gateway-name> -o json | jq -r '.spec.servers[].tls.credentialName'
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
