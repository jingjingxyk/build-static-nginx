<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $masscan_prefix = MASSCAN_PREFIX;

    $tag = 'master';

    $cppflags = '';
    $cflags = $p->getOsType() == 'macos' ? "" : '-fPIE -static ';
    $ldflags = $p->getOsType() == 'macos' ? "" : '-static  -static-pie';
    $libs = $p->isMacos() ? '-lc++' : ' -lstdc++ ';

    $lib = new Library('masscan');
    $lib->withHomePage('https://github.com/robertdavidgraham/masscan.git')
        ->withLicense('https://github.com/robertdavidgraham/masscan#AGPL-3.0-1-ov-file', Library::LICENSE_LGPL)
        ->withManual('https://github.com/robertdavidgraham/masscan.git')
        ->withFile('masscan-' . $tag . '.tar.gz')
        ->withDownloadScript(
            'masscan',
            <<<EOF
            git clone -b {$tag}  --depth=1 https://github.com/robertdavidgraham/masscan.git
EOF
        )
        ->withPrefix($masscan_prefix)
        ->withBuildCached(false)
        ->withInstallCached(false)
        ->withBuildScript(<<<EOF
        mkdir -p {$masscan_prefix}/usr/bin/
        PACKAGES='libpcap'
        CFLAGS="{$cflags} " \
        CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES) " \
        LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) {$ldflags}" \
        LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
        PREFIX="{$masscan_prefix}" \
        make -j {$p->getMaxJob()}

        make install DESTDIR={$masscan_prefix}

EOF
        )
        ->withBinPath($masscan_prefix . '/usr/bin/')
        ->withDependentLibraries('libpcap');

    $p->addLibrary($lib);

};
