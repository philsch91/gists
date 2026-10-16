# DNS

## NS

Subdomain delegation

The NS record for `<subdomain>.<domain>.<tld>` in the parent `<domain>.<tld>` zone delegates authority for `<subdomain>.<domain>.<tld>` to the name servers in the value.
```
Record name                 Record type     Value
<subdomain>.<domain>.<tld>  NS              ns-1536.awsdns-00.co.uk, ns-0.awsdns-00.com, ns-1024.awsdns-00.org, ns-512.awsdns-00.net
```
