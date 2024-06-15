<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $libx264_prefix = LIBX264_PREFIX;

    $libs = $p->isMacos() ? '-lc++' : ' -lstdc++ ';

    $lib = new Library('libx264');
    $lib->withHomePage('https://www.videolan.org/developers/x264.html')
        ->withManual('https://code.videolan.org/videolan/x264.git')
        ->withLicense('https://code.videolan.org/videolan/x264/-/blob/master/COPYING', Library::LICENSE_LGPL)
        ->withFile('libx264-stable.tar.gz')
        ->withDownloadScript(
            'x264',
            <<<EOF
        git clone -b stable --progress --depth=1  https://code.videolan.org/videolan/x264.git
EOF
        )
        ->withPrefix($libx264_prefix)
        ->withInstallCached(false)
        ->withConfigure(
            <<<EOF
        ./configure --help

        LIBS=" {$libs} " \
        ./configure \
        --prefix={$libx264_prefix} \
        --enable-static \
        --enable-pic \
        --disable-opencl \
        --disable-avs \
        --disable-swscale \
        --disable-lavf \
        --disable-ffms \
        --disable-gpac \
        --disable-lsmash


EOF
        )
        ->withScriptAfterInstall(
            <<<EOF
            sed -i.backup "s/-ldl/  /g" {$libx264_prefix}/lib/pkgconfig/x264.pc
EOF
        )
        ->withPkgName('x264')
        ->withBinPath($libx264_prefix . '/bin/');

    $p->addLibrary($lib);
};
