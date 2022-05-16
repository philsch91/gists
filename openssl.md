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
// export certificate without private key into .p12 keystore
// Linux and macOS
openssl pkcs12 -export -nokeys -in certificate.pem -out certificate.p12
// Windows + Git Bash
winpty openssl pkcs12 -export -nokeys -in certificate.cer -out certificate.pfx

// convert .p12 to .pem
openssl pkcs12 -in certificate.p12 -out certificate.pem -nodes
```
