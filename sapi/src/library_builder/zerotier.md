docker run -it --rm \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_ADMIN \
  --device=/dev/net/tun debian:12 /bin/bash

apt install -y curl iproute2 procps iputils-ping openssh-client


curl https://install.zerotier.com/ | bash

/usr/sbin/zerotier-one -d
/usr/sbin/zerotier-cli join 8056c2e21c000001
/usr/sbin/zerotier-cli listnetworks
