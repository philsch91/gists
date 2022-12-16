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
