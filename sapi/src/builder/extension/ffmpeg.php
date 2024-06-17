<?php

use SwooleCli\Preprocessor;
use SwooleCli\Extension;

return function (Preprocessor $p) {
    $depends = [
        'ffmpeg'
    ];
    $ext = (new Extension('ffmpeg'))
        ->withHomePage('https://ffmpeg.org/')
        ->withLicense(
            'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob/refs/heads/master:/LICENSE.md',
            Extension::LICENSE_LGPL
        )->withManual('https://ffmpeg.org/documentation.html');

    call_user_func_array([$ext, 'withDependentLibraries'], $depends);
    $p->addExtension($ext);
    $p->withReleaseArchive('ffmpeg', function (Preprocessor $p) {
        if (BUILD_SHARED_LIBS) {
            return '';
        }
        $workdir = $p->getWorkDir();
        $builddir = $p->getBuildDir();
        $ffmpeg_prefix = FFMPEG_PREFIX;
        $system_arch=$p->getSystemArch();
        $cmd = <<<EOF
                mkdir -p {$workdir}/bin/ffmpeg/
                cd {$ffmpeg_prefix}/
                pwd
                cp -rf bin {$workdir}/bin/ffmpeg/

                {$workdir}/bin/ffmpeg/bin/ffmpeg -h
                FFMPEG_VERSION=\$({$workdir}/bin/ffmpeg/bin/ffmpeg -version | grep 'ffmpeg version' | awk '{print $3}')

                for f in `ls {$workdir}/bin/ffmpeg/bin/` ; do
                    echo \$f
                    strip {$workdir}/bin/ffmpeg/bin/\$f
                done

                # 打包
                cd {$workdir}/bin/

EOF;
        if ($p->getOsType() == 'macos') {
            $cmd .= <<<EOF
                xattr -cr {$workdir}/bin/ffmpeg/bin/ffmpeg
                otool -L {$workdir}/bin/ffmpeg/bin/ffmpeg
                tar -cJvf {$workdir}/ffmpeg-\${FFMPEG_VERSION}-macos-{$system_arch}.tar.xz ffmpeg
EOF;
        } else {
            $cmd .= <<<EOF
                file {$workdir}/bin/ffmpeg/bin/ffmpeg
                readelf -h {$workdir}/bin/ffmpeg/bin/ffmpeg
                test $(ldd {$workdir}/bin/ffmpeg/bin/ffmpeg | wc -l) -gt 0 && ldd {$workdir}/bin/ffmpeg/bin/ffmpeg
                tar -cJvf {$workdir}/ffmpeg-\${FFMPEG_VERSION}-linux-{$system_arch}.tar.xz ffmpeg
EOF;
        }
        return $cmd;
    });
};
