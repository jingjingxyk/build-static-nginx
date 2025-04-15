<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $example_prefix = EXAMPLE_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;

    $gettext_prefix = GETTEXT_PREFIX;
    $cares_prefix = CARES_PREFIX;

    $ldflags = $p->getOsType() == 'macos' ? ' ' : ' --static ';

    $tag = 'master';
    $lib = new Library('netmap');
    $lib->withHomePage('https://opencv.org/')
        ->withLicense('https://github.com/netmap-unipi/netmap#BSD-2-Clause-1-ov-file', Library::LICENSE_BSD)
        ->withManual('https://github.com/netmap-unipi/netmap-tutorial')
        ->withFile('netmap-' . $tag . '.tar.gz')
        ->withDownloadScript(
            'netmap',
            <<<EOF
                git clone -b {$tag}  --depth=1 https://github.com/luigirizzo/netmap.git
EOF
        )
        ->withPrefix($example_prefix)
        ->withBuildCached(false)
        ->withInstallCached(false)
        ->withConfigure(
            <<<EOF
        # sh autogen.sh

        # libtoolize -ci
        # autoreconf -fi
        # example:  libdc1394.php

        ./configure --help

        # LDFLAGS="\$LDFLAGS -static"

        PACKAGES='openssl  '
        PACKAGES="\$PACKAGES libpcap"

        CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)" \
        LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) {$ldflags}" \
        LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
        ./configure \
        --prefix={$example_prefix} \
        --enable-shared=no \
        --enable-static=yes


EOF
        )
        ->withPkgName('libexample')
        ->withBinPath($example_prefix . '/bin/')
        ->withDependentLibraries('libpcap', 'openssl');

    $p->addLibrary($lib);
};
