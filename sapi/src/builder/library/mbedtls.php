<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $mbedtls_prefix = MBEDTLS_PREFIX;
    $lib = new Library('mbedtls');
    $lib->withHomePage('https://github.com/Mbed-TLS/mbedtls')
        ->withLicense('https://github.com/Mbed-TLS/mbedtls?tab=License-1-ov-file#readme', Library::LICENSE_APACHE2)
        ->withManual('hhttps://github.com/Mbed-TLS/mbedtls')
        ->withUrl('https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/mbedtls-3.6.3.tar.gz')
        ->withFile('mbedtls-3.6.3.tar.gz')
        ->withPrefix($mbedtls_prefix)
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
        ->withPkgConfig('mbedcrypto')
        ->withPkgConfig('mbedtls')
        ->withPkgConfig('mbedx509')
    ;

    $p->addLibrary($lib);

};
