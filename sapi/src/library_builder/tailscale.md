## 快速启动 tailscale

```shell

docker run -d  \
  --name tailscale \
  --hostname tailscale \
  --cap-add=NET_ADMIN \
  -v /dev/net/tun:/dev/net/tun \
  tailscale/tailscale:latest

docker exec -it tailscale sh

tailscale up --authkey=${{ secrets.TAILSCALE_AUTH_KEY }}

tailscale status

```

# 脚本 启动 tailscale

```shell
# https://github.com/tailscale/tailscale/blob/main/Dockerfile
# https://github.com/tailscale/tailscale/blob/main/scripts/installer.sh
# https://github.com/tailscale/tailscale.git
# docker pull tailscale/tailscale:latest
# docker run -d --name=tailscale --cap-add=NET_ADMIN --device=/dev/net/tun tailscale/tailscale /usr/bin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock

# 在 Linux 上，可以使用 screen、tmux 或者直接使用 nohup 和 & 来让 tailscaled 在后台运行

docker run -it --rm \
  --name tailscale \
  --hostname cloud-soft-tailscale \
  --cap-add=NET_ADMIN \
  -v /dev/net/tun:/dev/net/tun \
  --init \
  debian:12 /bin/bash

# --cap-add=SYS_ADMIN  \
# --cap-add=SYS_MODULE \


apt update -y && apt install -y curl iproute2 procps iputils-ping openssh-client

curl -fsSL https://tailscale.com/install.sh | bash

# 守护进程
tailscaled

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
