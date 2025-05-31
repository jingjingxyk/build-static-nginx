# jellyfin kodi

    kodi+nfs infuse+webdav

## kodi

    apt install -y  kodi kodi-repository-kodi kodi-eventclients-common

## jellyfin

    https://jellyfin.org/docs/general/installation/

    apt install -y lsb-release

    curl -LS https://repo.jellyfin.org/install-debuntu.sh | bash


    # visit jeffyfin url
    http://YOUR_SERVER_IP:8096/web/




    # diff <( curl -s https://repo.jellyfin.org/install-debuntu.sh -o install-debuntu.sh; sha256sum install-debuntu.sh ) <( curl -s https://repo.jellyfin.org/install-debuntu.sh.sha256sum )



