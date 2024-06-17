<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $alsa_audio_prefix = ALSA_AUDIO_PREFIX;

    $lib = new Library('alsa_audio'); //The Advanced Linux Sound Architecture (ALSA)
    $lib->withHomePage('https://www.alsa-project.org/')
        ->withLicense('https://github.co/alsa-project/alsa-lib/blob/master/COPYING', Library::LICENSE_LGPL)
        ->withManual('https://github.com/alsa-project/alsa-lib.git')
        ->withManual('https://github.com/alsa-project/alsa-lib/blob/master/INSTALL')
        ->withUrl('https://github.com/alsa-project/alsa-lib/archive/refs/tags/v1.2.9.tar.gz')
        ->withFile('alsa-v1.2.9.tar.gz')
        ->withPrefix($alsa_audio_prefix)
        ->withConfigure(
            <<<EOF
            libtoolize --force --copy --automake
            aclocal
            autoheader
            automake --foreign --copy --add-missing
            autoconf
            ./configure --help
            ./configure \
            --prefix={$alsa_audio_prefix} \
            --enable-shared=no \
            --enable-static=yes \

EOF
        )
        ->withPkgName('alsa')
        ->withPkgName('alsa-topology')
        ->withBinPath($alsa_audio_prefix . '/bin/')
    ;


    $p->addLibrary($lib);
};
