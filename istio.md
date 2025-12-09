# Istio

-> VirtualService -> Gateway -> Service<br />
<- VirtualService [<- DestinationRule] <- ServiceEntry

## Deployment.v1.apps

```
k -n <istio-system-namespace> get deployment/istio-ingressgateway -o yaml
k -n <istio-system-namespace> get deployment/istio-ingressgateway -o json | jq -r '.spec.template.spec.containers[].name'
```

## Gateway.v1.networking.istio.io

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
istioctl verify-install -i <istio-system-namespace>
istioctl [-n <namespace>] admin log <pod-name>
istioctl [-n <namespace>] proxy-status [type/]<name>[.<namespace>]
istioctl proxy-config all|listeners -i <istio-system-namespace> [type/]<name>[.<namespace>] [--port 8080]
```

### analyze

```
istioctl analyze --namespace <namespace>
```

### bug-report

```
istioctl bug-report
```
