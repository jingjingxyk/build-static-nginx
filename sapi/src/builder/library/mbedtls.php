<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $mbedtls_prefix = MBEDTLS_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;

    $gettext_prefix = GETTEXT_PREFIX;
    $cares_prefix = CARES_PREFIX;


    //文件名称 和 库名称一致
    $lib = new Library('mbedtls');
    $lib->withHomePage('https://github.com/Mbed-TLS/mbedtls')
        ->withLicense('https://github.com/Mbed-TLS/mbedtls?tab=License-1-ov-file#readme', Library::LICENSE_APACHE2)
        ->withManual('hhttps://github.com/Mbed-TLS/mbedtls')
        ->withUrl('https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/mbedtls-3.6.3.tar.gz')
        ->withFile('mbedtls-3.6.3.tar.gz')
        ->withPrefix($mbedtls_prefix)


        //明确申明 不使用构建缓存 例子： thirdparty/openssl (每次都解压全新源代码到此目录）
        ->withBuildCached(false)

        //明确申明 不使用库缓存  例子： /usr/local/swoole-cli/zlib (每次构建都需要安装到此目录）
         ->withInstallCached(false)

        /* 使用 cmake 构建 start */
        ->withBuildScript(
            <<<EOF
         mkdir -p build
         cd build
         cmake -LH
         cmake .. \
        -DCMAKE_INSTALL_PREFIX={$mbedtls_prefix} \
        -DCMAKE_BUILD_TYPE=Release  \
        -DBUILD_SHARED_LIBS=OFF  \
        -DBUILD_STATIC_LIBS=ON \
        -DENABLE_TESTING=Off \
        -DUSE_SHARED_MBEDTLS_LIBRARY=OFF

        cmake --build . --config Release

        cmake --build . --config Release --target install

EOF
        )
    ;

    $p->addLibrary($lib);

};
