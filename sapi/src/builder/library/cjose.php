<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $cjose_prefix = CJOSE_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $janssion_prefix = JANSSON_PREFIX;
    $tag = 'version-0.6.2.x';
    $lib = new Library('cjose');
    $lib->withHomePage('https://github.com/OpenIDC/cjose.git')
        ->withLicense('cjose ', Library::LICENSE_MIT)
        ->withManual('https://github.com/OpenIDC/cjose.git')
        ->withFile('cjose-v' . $tag . '.tar.gz')
        ->withDownloadScript('cjose', <<<EOF
        git clone -b {$tag} --depth=1 https://github.com/OpenIDC/cjose.git
EOF
        )
        ->withPrefix($cjose_prefix)
        ->withBuildCached(false)
        ->withConfigure(
            <<<EOF
        ./configure --help

        PACKAGES='openssl  '
        PACKAGES="\$PACKAGES jansson"

        CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)" \
        LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES)" \
        LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
        ./configure \
        --prefix={$cjose_prefix} \
        --enable-shared=no \
        --enable-static=yes \
        --with-openssl={$openssl_prefix} \
        --with-jansson={$janssion_prefix} \
        --with-rsapkcs1_5 \
        --disable-shared \
        --disable-doxygen-doc \
        --disable-shared
EOF
        )
        ->withBinPath($cjose_prefix . '/bin/')
        ->withDependentLibraries(
            'openssl',
            'jansson'
        );

    $p->addLibrary($lib);
};

