# cert-manager

(Cluster)Issuer.cert-manager.io (privateKeySecretRef, solvers) -> Certificate.cert-manager.io -> CertificateRequest.cert-manager.io -> Order.acme.cert-manager.io (commonName, dnsNames) -> Challenge.cert-manager.io -> Secret.kubernetes.io

## cmctl
```
cmctl -n <namespace> status certificate <certificate-name>
cmctl -n <namespace> renew <certificate-name>
```
