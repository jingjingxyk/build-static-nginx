# 自签CA 证书

> https://gist.github.com/soarez/9688998

```text

CN - CommonName
L - LocalityName
ST - StateOrProvinceName
O - OrganizationName
OU - OrganizationalUnitName
C - CountryName

```

```shell

openssl req -newkey rsa:4096 -x509 -nodes -days 3650 \
  -out /etc/ldap/ssl/server.crt -keyout /etc/ldap/ssl/server.key \
  -subj "/C=US/ST=Arizona/L=Localhost/O=localhost/CN=localhost" \
  -addext "subjectAltName = `alt_names`"

openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout server.key -out server.crt

```
