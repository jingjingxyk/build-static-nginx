<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $ttypd_prefix = TTYD_PREFIX;

    $libuv_prefix = LIBUV_PREFIX;
    $zlib_prefix = ZLIB_PREFIX;
    $libwebsockets_prefix = LIBWEBSOCKETS_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $libjson_c_prefix = LIBJSON_C_PREFIX;
    //文件名称 和 库名称一致
    $lib = new Library('ttyd');
    $lib->withHomePage('https://tsl0922.github.io/ttyd')
        ->withLicense('https://github.com/tsl0922/ttyd#MIT-1-ov-file', Library::LICENSE_MIT)
        ->withManual('https://github.com/tsl0922/ttyd/wiki')
        ->withFile('opencv-latest.tar.gz')
        ->withDownloadScript(
            'ttyd',
            <<<EOF
            git clone -b main  --depth=1 https://github.com/tsl0922/ttyd.git
EOF
        )
        ->withPrefix($ttypd_prefix)
        ->withBuildScript(
            <<<EOF
         mkdir -p build
         cd build

         cmake .. \
        -DCMAKE_INSTALL_PREFIX={$ttypd_prefix} \
        -DCMAKE_BUILD_TYPE=Release  \
        -DBUILD_SHARED_LIBS=OFF  \
        -DBUILD_STATIC_LIBS=ON \
        -DCMAKE_FIND_LIBRARY_SUFFIXES=".a" \
        -DLWS_WITH_LIBUV=ON \
        -DOPENSSL_ROOT_DIR={$openssl_prefix} \
        -DCMAKE_PREFIX_PATH="{$libuv_prefix};{$openssl_prefix};{$zlib_prefix};{$libwebsockets_prefix};{$libuv_prefix};{$libjson_c_prefix}"


        cmake --build . --config Release

        cmake --build . --config Release --target install


EOF
        )
        ->withPkgName('libexample')
        ->withBinPath($ttypd_prefix . '/bin/')
        //依赖其它静态链接库
        ->withDependentLibraries('zlib', 'openssl', 'libuv', 'libwebsockets', 'libjson_c');

    $p->addLibrary($lib);

};
