<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'masscan'
    ];
    $ext = (new Extension('masscan'))
        ->withHomePage('https://github.com/robertdavidgraham/masscan.git')
            ->withLicense('https://github.com/robertdavidgraham/masscan#AGPL-3.0-1-ov-file', Extension::LICENSE_LGPL)
            ->withManual('https://github.com/robertdavidgraham/masscan.git')
    ;
    call_user_func_array([$ext, 'withDependentLibraries'], $depends);
    $p->addExtension($ext);
    $p->withReleaseArchive('masscan', function (Preprocessor $p) {

        $workdir = $p->getWorkDir();
        $builddir = $p->getBuildDir();
        $system_arch = $p->getSystemArch();
        $masscan_prefix  = MASSCAN_PREFIX;
        $cmd = <<<EOF
                mkdir -p {$workdir}/bin/
                cd {$masscan_prefix}/usr/bin/
                cp -f masscan {$workdir}/bin/
                strip {$workdir}/bin/masscan
                cd {$workdir}/bin/
                # APP_VERSION=\$({$workdir}/bin/masscan -v | head -n 1 | awk '{print $3}')
                APP_VERSION='latest'
                APP_NAME='masscan'
                echo \${APP_VERSION} > {$workdir}/APP_VERSION
                echo \${APP_NAME} > {$workdir}/APP_NAME

EOF;
        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
            xattr -cr {$workdir}/bin/\${APP_NAME}
            otool -L {$workdir}/bin/\${APP_NAME}
            tar -cJvf {$workdir}/\${APP_NAME}-\${APP_VERSION}-macos-{$system_arch}.tar.xz \${APP_NAME} LICENSE

EOF;
        } else {
            $cmd .= <<<EOF
            file {$workdir}/bin/\${APP_NAME}
            readelf -h {$workdir}/bin/\${APP_NAME}
            tar -cJvf {$workdir}/\${APP_NAME}-\${APP_VERSION}-linux-{$system_arch}.tar.xz \${APP_NAME} LICENSE

EOF;
        }
        return $cmd;
    });
};
