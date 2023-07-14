# openssl

## genrsa

Generate private key
```
openssl genrsa -out private.pem 2048
chmod 600 private.pem
```

## req

Create certificate signing request (CSR) with public key based on private key
```
openssl req -new -key private.pem -out signing.csr
```

## genrsa + req

```
// generate RSA encrypted private key
openssl genrsa -out subsubdomain.subdomain.domain.com.key.pem 2048

// create a v3 ext file for subject alternative name (SAN) properties
cat > subsubdomain.subdomain.domain.com.v3.ext << EOF
nsCertType = server
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = subsubdomain.subdomain.domain.com
DNS.2 = subsubdomain.subdomain2.domain.com
EOF

// create CSR with public key based on passed private key and properties
openssl req -new -key subsubdomain.subdomain.domain.com.key.pem -out subsubdomain.subdomain.domain.com.csr -subj '/C=AT/ST=Vienna/L=Vienna/O=MyOrganisation/OU=MyOrganisationalUnit' -extfile subsubdomain.subdomain.domain.com.v3.ext
```

## genrsa + req + x509

```
CA_NAME="Test-Root-CA"

// generate AES encrypted private key
openssl genrsa -aes256 -out ${CA_NAME}.cakey.pem 4096

// create self-signed root certificate, 1826 days = 5 years
openssl req -x509 -new -nodes -key ${CA_NAME}.cakey.pem -sha256 -days 1826 -out ${CA_NAME}.cert.pem -subj '/CN=MyRootCA/C=AT/ST=Vienna/L=Vienna/O=MyOrganisation'

// create certificate signing request
MY_DOMAIN="domain.com"
openssl req -new -nodes -out ${MY_DOMAIN}.csr -newkey rsa:4096 -keyout ${MY_DOMAIN}.key -subj "/CN=${MY_DOMAIN}/C=AT/ST=Vienna/L=Vienna/O=MyOrganisation"

// create a v3 ext file for subject alternative name (SAN) properties
cat > ${MY_DOMAIN}.v3.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${MY_DOMAIN}
EOF

// create certificate for service
openssl x509 -req -in ${MY_DOMAIN}.csr -CA ${CA_NAME}.cert.pem -CAkey ${CA_NAME}.cakey.pem -CAcreateserial -out ${MY_DOMAIN}.cert.pem -days 730 -sha256 -extfile ${MY_DOMAIN}.v3.ext

// create file with server/service certificate and self-signed root certificate for certificate chain
cat ${MY_DOMAIN}.cert.pem ${CA_NAME}.cert.pem >chain.crt
```

## x509

```
// convert DER (.cer, .der, .crt) file to .pem
openssl x509 -inform der -in <file.cer> -outform pem -out <file.pem>
```

## .pem

- Privacy Enhanced Mail
- [RFC 1422](https://www.rfc-editor.org/rfc/rfc1422)
- base64 encoded x509 ASN.1 keys
- container format
- public certificates
- CA certificates
- certificate chains
- public key
- private key
- root certificates

## pkcs12

- PKCS#12 keystore
- [RFC 7292](https://www.rfc-editor.org/rfc/rfc7292)
- password protected
- encrypted
- public and private certificate pairs

```
// convert .pem to .p12
// export certificate into .p12 keystore (without private key)
// Linux and macOS
openssl pkcs12 -export [-nokeys] -in certificate.pem -out certificate.p12
// Windows + Git Bash
winpty openssl pkcs12 -export -nokeys -in certificate.cer -out certificate.pfx

// export certificate and private key into pkcs12 keystore
// generate pkcs12 file with cert and key for Java keystore
openssl pkcs12 -export -in <certificate.pem> -inkey <certificate.key> -out <certificate.p12> -passout pass:<password> -name <certificate-name>

// convert .p12 to .pem (without certificates)
openssl pkcs12 -in certificate.p12 -out certificate.pem -nodes [-nocerts]
```

## s_client

// show remote SSL certificate
```
echo | openssl s_client -showcerts -servername <hostname> -connect <hostname>:443 2>/dev/null | openssl x509 -inform pem -noout -text
```
