# OAuth

## OpenID well-known endpoints
- https://auth-service-hostname/.well-known/openid-configuration

## Authorization Code Grant Flow

Token request:
```
{
    "client_id": "",
    "response_type": "code",
    "scope": "<scopes>",
    "redirect_uri": "<redirect-uri>",
    "state": "<redirect-uri>"
}
```

Login request:
```
{
    "username: "",
    "password": ""
}
```

Get token request:
```
{
    "authorization_code": "",
    "client_id": "",
    "client_secret": ""
}
```

## Implicit Code Grant Flow

Login request process returns `token` instead of `authorization_code` and no further get token request process.

Token request:
```
{
    "client_id": "",
    "response_type": "token",
    "scope": "<scopes>",
    "redirect_uri": "<redirect-uri>",
    "state": "<redirect-uri>"
}
```

Login request:
```
{
    "username: "",
    "password": ""
}
```

## Client Credential Grant Flow

No token and login request process (user interaction). Service to service authorization.
Only get token request.

Get token request:
```
{
    "client_id": "",
    "client_secret": "",
    "grant_type": "token"
}
```

### Client Credential Grant Flow Examples

```
curl --location -X POST 'https://auth-service.tld/oauth/token' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data-urlencode 'client_id=<client_id>' \
    --data-urlencode 'client_secret=<client_secret>' \
    --data-urlencode 'grant_type=client_credentials'

// or 
// Microfocus Access Manager
curl -ikSs -X POST -H 'Content-Length: 0' --proxy "proxy.subdomain.tld:8888" -v "https://auth-service.tld/nidp/oauth/nam/token?client_id=<client-id>&client_secret=<client-secret>&grant_type=client_credentials"
```

## Resource Owner (Password) Grant Flow

Login request process replaced by get token request.

Token request:
```
{
    "client_id": "",
    "response_type": "code",
    "scope": "<scopes>",
    "redirect_uri": "<redirect-uri>",
    "state": "<redirect-uri>"
}
```

Get token request:
```
{
    "authorization_code": "",
    "client_id": "",
    "client_secret": "",
    "username": "",
    "password": "",
    "grant_type": "password"
}
```

## Token types

### id_token
- JWT format (non-opaque, encoded)
- Valid id_token = authenticated user
- Provides information about the session
- Contains claims for additional information for a client or app
- Contains claims about the identity of the user or resource owner
- scope = space separated string of identifiers specifying access privileges
- claims = key-value pair
- claims are grouped under scope
- id_token can be exchanged for an access_token from the token endpoint of an OAuth authorization server [RFC draft](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-token-exchange-12)

### access_token
- Bearer format (opaque)
- Valid access_token = resource access without further authentication
- Establish access to resource
- Optional JWT format [RFC draft](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-access-token-jwt-00)

```
{
    "iss": "https://authorization-server.example.com/",
    "sub": " 5ba552d67",
    "aud":   "https://rs.example.com/",
    "exp": 1544645174,
    "client_id": "s6BhdRkqt3_",
    "scope": "openid profile reademail"
   }
```

### refresh_token
- Opaque format
- long lived
- Valid refresh_token = obtain new access_token
