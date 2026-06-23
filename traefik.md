# Traefik

## Deployment
```
# --entryPoints.metrics.address=:9100/tcp
# --entryPoints.traefik.address=:8080/tcp
# --entryPoints.web.address=:8000/tcp
# --entryPoints.websecure.address=:8443/tcp
# --entryPoints.websecure.asDefault=true
# --entryPoints.web.http.redirections.entryPoint.to=:443
# --entryPoints.web.http.redirections.entryPoint.scheme=https
# --entryPoints.web.http.redirections.entryPoint.permanent=true
# --entryPoints.websecure.http.tls=true
kubectl -n traefik get deployment/traefik -o jsonpath='{.spec.template.spec.containers[0].args}'
kubectl get deployment -l app.kubernetes.io/name=traefik -A -o jsonpath='{.items[*].spec.template.spec.containers[*].args}' | jq -r . | grep entryPoints
```

## Service
```
kubectl -n traefik get svc/traefik -o go-template='{{ $ing := index .status.loadBalancer.ingress 0 }}{{ if $ing.ip }}{{ $ing.ip }}{{ else }}{{ $ing.hostname }}{{ end }}' | nslookup | awk -F': ' 'NR==6 { print $2 }'
```

## Gateway.v1.gateway.networking.k8s.io
```
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: wildcard-traefik-gateway
  namespace: traefik
spec:
  gatewayClassName: traefik
  listeners:
  - name: https
    protocol: HTTPS
    port: 8443 # 443
    hostname: "*.subdomain.org.tld"
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: traefik-tls
        namespace: traefik
    allowedRoutes:
      namespaces:
        from: All
```

## HTTPRoute.v1.gateway.networking.k8s.io
```
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  annotations:
  labels:
  name: ollama-nonprod-ec1
  namespace: ollama
spec:
  hostnames:
  - ollama.subdomain.org.tld
  parentRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: wildcard-traefik-gateway
    namespace: traefik
  rules:
  - backendRefs:
    - group: ""
      kind: Service
      name: ollama-nonprod-ec1
      port: 11434
      weight: 1
    matches:
    - path:
        type: PathPrefix
        value: /
```
