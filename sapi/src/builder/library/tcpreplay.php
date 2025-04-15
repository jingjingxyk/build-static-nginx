<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $example_prefix = EXAMPLE_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;

    $tag = 'main';

    //文件名称 和 库名称一致
    $lib = new Library('tcpreplacy');
    $lib->withHomePage('https://github.com/appneta/tcpreplay.git')
        ->withLicense('http://www.gnu.org/licenses/lgpl-2.1.html', Library::LICENSE_SPEC)
        ->withManual('https://tcpreplay.appneta.com/wiki/installation.html#downloads')
        ->withFile('tcpreplay-' . $tag . '.tar.gz')
        ->withDownloadScript(
            'tcpreplay',
            <<<EOF
            git clone -b main  --depth=1 https://github.com/appneta/tcpreplay.git
EOF
        )
        ->withPrefix($example_prefix)
        ->withBuildCached(false)
        ->withInstallCached(false)
        ->withConfigure(
            <<<EOF
        sh autogen.sh
        ./configure --help

        PACKAGES='openssl  '
        PACKAGES="\$PACKAGES libpcap"

        OPENSSL_CFLAGS=$(pkg-config  --cflags --static openssl)
        OPENSSL_LIBS=$(pkg-config    --libs   --static openssl)

        CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)" \
        LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) " \
        LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
        ./configure \
        --prefix={$example_prefix} \
        --with-netmap=/home/fklassen/git/netmap \
        --enable-shared=no \
        --enable-static=yes

        # 显示构建详情
        # make VERBOSE=1
        # 指定安装目录
        # make DESTDIR=/usr/local/swoole-cli/example
        #

EOF
        )
        ->withPkgName('libexample')
        ->withBinPath($example_prefix . '/bin/')
        //依赖其它静态链接库
        ->withDependentLibraries('libpcap', 'openssl');

    $p->addLibrary($lib);
};
