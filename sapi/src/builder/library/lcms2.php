<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $lcms2_prefix = LCMS2_PREFIX;
    $libjpeg_prefix = JPEG_PREFIX;
    $libtiff_prefix = LIBTIFF_PREFIX;
    $lib = new Library('lcms2');
    $lib->withHomePage('https://littlecms.com/color-engine/')
        ->withLicense('https://www.opensource.org/licenses/mit-license.php', Library::LICENSE_MIT)
        ->withUrl('https://sourceforge.net/projects/lcms/files/lcms/2.15/lcms2-2.15.tar.gz')
        ->withFileHash('sha1','b143ff29b03676119dbca30f13cbed72af15cce8')
        ->withManual('https://lfs.lug.org.cn/blfs/view/10.0/general/lcms2.html')
        ->withPrefix($lcms2_prefix)
        ->withConfigure(
            <<<EOF
            ./configure --help

            PACKAGES="zlib"
            CPPFLAGS="\$(pkg-config  --cflags-only-I --static \$PACKAGES )" \
            LDFLAGS="\$(pkg-config   --libs-only-L   --static \$PACKAGES )" \
            LIBS="\$(pkg-config      --libs-only-l   --static \$PACKAGES )" \
            ./configure \
            --prefix={$lcms2_prefix} \
            --enable-shared=no \
            --enable-static=yes \
            --with-jpeg={$libjpeg_prefix} \
            --with-tiff={$libtiff_prefix}

EOF
        )
        ->withBinPath($lcms2_prefix . '/bin/')
        ->withPkgName('lcms2')
        ->withDependentLibraries('zlib', 'libjpeg', 'libtiff');

    $p->addLibrary($lib);
};
