<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $tcpdump_prefix = TCPDUMP_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;

    $ldflags = $p->getOsType() == 'macos' ? '' : ' -static  ';

    $tag = 'master';
    $lib = new Library('tcpdump');
    $lib->withHomePage('https://www.tcpdump.org')
        ->withLicense('https://github.com/the-tcpdump-group/tcpdump?tab=License-1-ov-file#readme', Library::LICENSE_BSD)
        ->withManual('https://github.com/the-tcpdump-group/tcpdump/blob/master/INSTALL.md')
        ->withFile('tcpdump-' . $tag . '.tar.gz')
        ->withBuildLibraryHttpProxy()
        ->withDownloadScript(
            'tcpdump',
            <<<EOF
            git clone -b {$tag}  --depth=1 https://github.com/the-tcpdump-group/tcpdump.git
EOF
        )
        ->withPrefix($tcpdump_prefix)
        ->withConfigure(
            <<<EOF
        sh ./autogen.sh
        ./configure --help

        PACKAGES='openssl  '
        PACKAGES="\$PACKAGES libpcap"

        CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)" \
        LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) {$ldflags}" \
        LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
        LIBPCAP_CFLAG=$(pkg-config            --cflags --static libpcap) \
        LIBPCAP_LIBS_STATIC=$(pkg-config      --libs   --static libpcap) \
        LIBCRYPTO_CFLAGS=$(pkg-config         --cflags --static libcrypto) \
        LIBCRYPTO_LIBS_STATIC=$(pkg-config    --libs   --static libcrypto) \
        ./configure \
        --prefix={$tcpdump_prefix}

EOF
        )
        ->withBinPath($tcpdump_prefix . '/bin/')
        ->withDependentLibraries('libpcap', 'openssl');

    $p->addLibrary($lib);

};
