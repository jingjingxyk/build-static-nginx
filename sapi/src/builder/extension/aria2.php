<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'aria2'
    ];
    $ext = (new Extension('aria2'))
        ->withHomePage('https://aria2.github.io/')
        ->withManual('https://aria2.github.io/') //如何选开源许可证？
        ->withLicense('https://www.jingjingxyk.com/LICENSE', Extension::LICENSE_GPL);
    call_user_func_array([$ext, 'withDependentLibraries'], $depends);
    $p->addExtension($ext);
    $p->withReleaseArchive('aria2', function (Preprocessor $p) {

        $workdir = $p->getWorkDir();
        $builddir = $p->getBuildDir();

        $cmd = <<<EOF
                mkdir -p {$workdir}/bin/
                cd {$builddir}/aria2/src
                cp -f aria2c {$workdir}/bin/
                strip {$workdir}/bin/aria2c
                cd {$workdir}/bin/
                ARIA2_VERSION=\$({$workdir}/bin/aria2c -v | head -n 1 | awk '{print $3}')

EOF;
        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
            otool -L {$workdir}/bin/aria2c
            tar -cJvf {$workdir}/aria2c-\${ARIA2_VERSION}-macos-x64.tar.xz aria2c

EOF;
        } else {
            $cmd .= <<<EOF
              file {$workdir}/bin/aria2c
              readelf -h {$workdir}/bin/aria2c
              tar -cJvf {$workdir}/aria2c-\${ARIA2_VERSION}-linux-x64.tar.xz aria2c

EOF;
        }
        return $cmd;
    });
};
