```shell

docker run -it --rm \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_ADMIN \
  --device=/dev/net/tun debian:12 /bin/bash

apt install -y curl iproute2 procps iputils-ping openssh-client

curl -fsSL https://tailscale.com/install.sh | bash

tailscale up --authkey=${{ secrets.TAILSCALE_AUTH_KEY }}
tailscale status

```

```yaml
name: "tailscale client"
services:
  tailscale-authkey1:
    image: tailscale/tailscale:latest
    container_name: ts-authkey-test
    hostname: banana
    environment:
      - TS_AUTHKEY=tskey-auth-kc4MhA5vzX11CNTRL-example
      - TS_STATE_DIR=/var/lib/tailscale
      - TS_USERSPACE=false
    volumes:
      - ts-authkey-test:/var/lib/tailscale
      - /dev/net/tun:/dev/net/tun
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    restart: unless-stopped
  nginx-authkey-test:
    image: nginx
    network_mode: service:tailscale-authkey1
volumes:
  ts-authkey-test:
    driver: local


```
