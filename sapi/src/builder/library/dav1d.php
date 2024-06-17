<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $dav1d_prefix = DAV1D_PREFIX;
    $p->addLibrary(
        (new Library('dav1d'))
            ->withHomePage('https://code.videolan.org/videolan/dav1d/')
            ->withLicense('https://code.videolan.org/videolan/dav1d/-/blob/master/COPYING', Library::LICENSE_BSD)
            ->withManual('https://code.videolan.org/videolan/dav1d')
            ->withFile('dav1d-v1.3.0.tar.gz')
            ->withDownloadScript(
                'dav1d',
                <<<EOF
                git clone -b 1.3.0 --depth=1 --progress https://code.videolan.org/videolan/dav1d.git
EOF
            )
            ->withPrefix($dav1d_prefix)
            ->withPreInstallCommand(
                'alpine',
                <<<EOF
apk add ninja python3 py3-pip  nasm yasm meson
EOF
            )
            ->withPreInstallCommand(
                'macos',
                <<<EOF
export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

brew install  ninja python3  nasm yasm meson
# python3 -m pip install --upgrade pip
brew install meson

# curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

EOF
            )
            ->withBuildScript(
                <<<EOF
            meson setup  build \
            -Dprefix={$dav1d_prefix} \
            -Dlibdir={$dav1d_prefix}/lib \
            -Dincludedir={$dav1d_prefix}/include \
            -Dbackend=ninja \
            -Dbuildtype=release \
            -Ddefault_library=static \
            -Db_staticpic=true \
            -Db_pie=true \
            -Dprefer_static=true \
            -Denable_asm=true \
            -Denable_tools=true \
            -Denable_examples=false \
            -Denable_tests=false \
            -Denable_docs=false \
            -Dlogging=false \
            -Dfuzzing_engine=none

            ninja -C build
            ninja -C build install

EOF
            )
            ->withScriptAfterInstall(
                <<<EOF
            sed -i.backup "s/-ldl/  /g" {$dav1d_prefix}/lib/pkgconfig/dav1d.pc
EOF
            )
            ->withPkgName('dav1d')
            ->withBinPath($dav1d_prefix . '/bin/')
            //->withDependentLibraries('sdl2')
    );
};
