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

## Middleware.v1alpha1.traefik.io
```
# htpasswd
# -n = display results on stdout, -B = bcrypt encryption
echo $(htpasswd -nB <username>)
## Type your plain-text password when prompted
## Example output: <username>:$2y$05$vI7Ea8K3XJcMToY68...
# pwgen
echo "<username>:$(pwgen -y -s 32 1)"
kubectl -n app-namespace create secret generic app-basic-auth-secret \
  --from-literal=users="<username>:$2y$05$vI7Ea8K3XJcMToY68..."
---
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: app-basic-auth
  namespace: app-namespace
spec:
  basicAuth:
    secret: app-basic-auth-secret
    removeHeader: true
---
---
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: app-api-key-auth
  namespace: app-namespace
spec:
  headers:
    customRequestHeaders:
      X-API-KEY: "<api-key>"
---
---
# symmetric
openssl rand -base64 32
## Example output: tU4vW8x/A1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p6Q7r=
kubectl -n app-namespace create secret generic app-jwt-secret \
  --from-literal=secret="tU4vW8x/A1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p6Q7r="
# asymmetric
kubectl -n app-namespace create secret generic app-jwt-rsa-secret \
  --from-file=publicKey=/path/to/your/public.pem
---
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: app-jwt-auth
  namespace: app-namespace
spec:
  jwt:
    algorithm: HS256|RS256
    signingSecret: app-jwt-secret|app-jwt-rsa-secret
    forwardAuthorization: false
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
  - matches:
    - path:
        type: PathPrefix
        value: /
    filters:
    # and filters in one rule
    - type: ExtensionRef
      extensionRef:
        group: traefik.io
        kind: Middleware
        name: app-basic-auth
    - type: ExtensionRef
      extensionRef:
        group: traefik.io
        kind: Middleware
        name: app-api-key-auth
    backendRefs:
    - group: ""
      kind: Service
      name: ollama-nonprod-ec1
      port: 11434
      weight: 1
  # or filters with multiple rules
  - matches:
    - path:
        type: PathPrefix
        value: /
    filters:
    - type: ExtensionRef
      extensionRef:
        group: traefik.io
        kind: Middleware
        name: app-jwt-auth
    backendRefs:
    - group: ""
      kind: Service
      name: ollama-nonprod-ec1
      port: 11434
      weight: 1
```
