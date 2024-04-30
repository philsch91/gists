# cert-manager

Secret.kubernetes.io <- (Cluster)Issuer.cert-manager.io (privateKeySecretRef, solvers) <- CertificateRequest.cert-manager.io <- Order.acme.cert-manager.io (commonName, dnsNames) <- Challenge.cert-manager.io
