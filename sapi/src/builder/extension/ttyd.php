<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'ttyd'
    ];
    $ext = (new Extension('ttyd'))
        ->withHomePage('https://tsl0922.github.io/ttyd')
        ->withLicense('https://github.com/tsl0922/ttyd#MIT-1-ov-file', Extension::LICENSE_MIT)
        ->withManual('https://github.com/tsl0922/ttyd/wiki');
    $p->addExtension($ext);

    $p->withReleaseArchive('ttyd', function (Preprocessor $p) {

        $workdir = $p->getWorkDir();
        $builddir = $p->getBuildDir();
        $install_dir = TTYD_PREFIX;
        $system_arch = $p->getSystemArch();
        $cmd = <<<EOF
                mkdir -p {$workdir}/bin/

                cp -f {$install_dir}/bin/ttyd {$workdir}/bin/ttyd
                strip {$workdir}/bin/ttyd
                cd {$workdir}/bin/
                APP_VERSION=\$({$workdir}/bin/ttyd -v | awk '{ print $3 }' | awk -F "-" '{ print $1 }')
                echo \${APP_VERSION} > {$workdir}/APP_VERSION

EOF;
        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
            xattr -cr {$workdir}/bin/ttyd
            otool -L {$workdir}/bin/ttyd
            tar -cJvf {$workdir}/ttyd-\${APP_VERSION}-macos-{$system_arch}.tar.xz ttyd

EOF;
        } else {
            $cmd .= <<<EOF
              file {$workdir}/bin/ttyd
              readelf -h {$workdir}/bin/ttyd
              tar -cJvf {$workdir}/ttyd-\${APP_VERSION}-linux-{$system_arch}.tar.xz ttyd

EOF;
        }
        return $cmd;
    });
};
