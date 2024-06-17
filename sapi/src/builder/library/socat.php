<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    // https://github.com/aledbf/socat-static-binary/blob/master/build.sh
    $socat_prefix = SOCAT_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $cflags = $p->getOsType() == 'macos' ? "" : '-static';
    $p->addLibrary(
        (new Library('socat'))
            ->withHomePage('http://www.dest-unreach.org/socat/')
            ->withLicense('http://www.dest-unreach.org/socat/doc/README', Library::LICENSE_GPL)
            //->withUrl('http://www.dest-unreach.org/socat/download/socat-1.7.4.4.tar.gz')
            ->withFile('socat-1.8.0.0.tar.gz')
            ->withDownloadScript(
                'socat',
                <<<EOF
                git clone -b tag-1.8.0.0	 https://repo.or.cz/socat.git
EOF
            )
            ->withBuildCached(false)
            ->withInstallCached(false)
            ->withBuildScript(
                <<<EOF
            libtoolize -ci
            autoreconf -fi

            pkg-config --cflags --static readline
            pkg-config  --libs --static readline
            ./configure --help ;
            PACKAGES='openssl readline'
            CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)" \
            LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES)" \
            LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
            CFLAGS="{$cflags} -O2 -Wall -fPIC  -DWITH_OPENSSL" \
            ./configure \
            --prefix={$socat_prefix} \
            --enable-readline \
            --enable-openssl-base={$openssl_prefix}

            make -j {$p->maxJob}
EOF
            )
            ->withBinPath($socat_prefix . '/bin/')
            ->withDependentLibraries('openssl', 'readline')
    );
};
