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
kubectl -n traefik get deployment/traefik -o jsonpath='{.spec.template.spec.containers[0].ports}'
kubectl get deployment -l app.kubernetes.io/name=traefik -A -o jsonpath='{.items[*].spec.template.spec.containers[*].args}' | jq -r . | grep entryPoints
```

## Service
```
# .spec.ports[*].targetPort in service must match .spec.template.spec.containers[0].ports[*].containerPort in deployment
# .spec.ports[*].port in service is exposed via LB
kubectl -n traefik get svc/traefik -o jsonpath='{.spec.ports}' | grep 443
kubectl -n traefik get svc/traefik -o go-template='{{ $ing := index .status.loadBalancer.ingress 0 }}{{ if $ing.ip }}{{ $ing.ip }}{{ else }}{{ $ing.hostname }}{{ end }}' | nslookup | awk -F': ' 'NR==6 { print $2 }'

---
apiVersion: v1
kind: Service
metadata:
  annotations:
    traefik.ingress.kubernetes.io/service.sticky.cookie: "true"
    traefik.ingress.kubernetes.io/service.sticky.cookie.name: sticky-app-session
    traefik.ingress.kubernetes.io/service.sticky.cookie.secure: "true"
  name: sticky-app
  namespace: app-namespace # ollama
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app.kubernetes.io/name: <httproute-name|ingress-name>
```

## Ingress.v1.networking.k8s.io
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
  name: sticky-app
  namespace: app-namespace # ollama
spec:
  ingressClassName: traefik
  rules:
    - host: app.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: sticky-app
                port:
                  name: http
                  # number: 80
  tls:
    - secretName: traefik-tls
      hosts:
        - app.example.com
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
---
---
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: app-ip-allowlist
  namespace: traefik|app-namespace
spec:
  ipAllowList:
    sourceRange:
      - "10.0.0.0/8"
      - "172.16.0.0/12"
      - "192.168.0.0/16"
      - "203.0.113.0/24"
---
---
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: app-oauth-auth
  namespace: app-namespace
spec:
  forwardAuth:
    address: http://oauth2-proxy.app.svc.cluster.local:4180/oauth2/auth
    trustForwardHeader: true
    authResponseHeaders:
      - "X-Auth-Request-User"
      - "X-Auth-Request-Email"
      - "Authorization"
---
---
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: app-oauth-errors
  namespace: app-namespace
spec:
  errors:
    status:
      - "401-403"
    service:
      name: oauth2-proxy
      port: 4180
    query: "/oauth2/sign_in"
```

## HTTPRoute.v1.gateway.networking.k8s.io
```
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  annotations:
  labels:
  name: ollama-nonprod-ec1
  namespace: app-namespace # ollama
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

## IngressRouteTCP.v1alpha1.traefik.io
```
apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: ldap
  namespace: app-namespace # ollama
  annotations:
    kubernetes.io/ingress.class: traefik
spec:
  entryPoints:
    - ldap # must match entryPoint in .spec.template.spec.containers[0].args of traefik deployment
  routes:
    - match: HostSNI(`*`) # use wildcard for plain TCP (no TLS SNI)
      services:
        - name: ldap-service
          port: 1389
```

## IngressRoute.v1alpha1.traefik.io
```
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: app
  namespace: app-namespace # ollama
spec:
  entryPoints:
    - web # must match entryPoint in .spec.template.spec.containers[0].args of traefik deployment
  routes:
    - match: Host(`app.example.com`)
      kind: Rule
      priority: 200
      services:
        - name: ollama
          port: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sticky-app
  namespace: app-namespace # ollama
spec:
  ingressClassName: traefik
  rules:
    - host: app.example.com
      # http:
      #   paths:
      #     - path: /
      #       pathType: Prefix
      #       backend:
      #         service:
      #           name: sticky-app
      #           port:
      #             name: http
      #             # number: 80
```
