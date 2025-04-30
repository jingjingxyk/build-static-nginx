<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $libjwt_prefix = LIBJWT_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $jansson_prefix = JANSSON_PREFIX;
    $curl_prefix = CURL_PREFIX;
    $cares_prefix = CARES_PREFIX;
    $nghttp3_prefix = NGHTTP3_PREFIX;
    $ngtcp2_prefix = NGTCP2_PREFIX;
    $libssh2_prefix = LIBSSH2_PREFIX;


    $tag = 'v3.2.1';
    //文件名称 和 库名称一致
    $lib = new Library('libjwt');
    $lib->withHomePage('https://libjwt.io/')
        ->withLicense('https://github.com/benmcollins/libjwt#MPL-2.0-1-ov-file', Library::LICENSE_SPEC)
        ->withManual('https://github.com/benmcollins/libjwt')
        ->withFile('libjwt-' . $tag . '.tar.gz')
        ->withDownloadScript(
            'libjwt',
            <<<EOF
            git clone -b {$tag}  --depth=1 https://github.com/benmcollins/libjwt.git
EOF
        )
        ->withPrefix($libjwt_prefix)
        ->withBuildCached(false)
        ->withInstallCached(false)

        /* 使用 cmake 构建 start */
        ->withBuildScript(
            <<<EOF
         sed -i.bak 's/(WITH_GNUTLS)/(X_WITH_GNUTLS)/g' CMakeLists.txt
         sed -i.bak 's/GNUTLS_FOUND/X_GNUTLS_FOUND/g' CMakeLists.txt
         mkdir -p build
         cd build
         cmake -LH ..

         cmake .. \
        -DCMAKE_INSTALL_PREFIX={$libjwt_prefix} \
        -DCMAKE_BUILD_TYPE=Release  \
        -DBUILD_SHARED_LIBS=OFF  \
        -DBUILD_STATIC_LIBS=ON \
        -DCMAKE_PREFIX_PATH="{$openssl_prefix};{$jansson_prefix};{$curl_prefix};{$nghttp3_prefix};{$ngtcp2_prefix};{$libssh2_prefix}" \
        -DWITH_GNUTLS=OFF \
        -DWITH_LIBCURL=ON \
        -DWITH_TESTS=OFF \
        -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON \
        -DCMAKE_DISABLE_FIND_PACKAGE_GNUTLS=ON

        cmake --build . --config Release --target install

EOF
        )
        ->withScriptAfterInstall(
            <<<EOF
            rm -rf {$libjwt_prefix}/lib/*.so.*
            rm -rf {$libjwt_prefix}/lib/*.so
            rm -rf {$libjwt_prefix}/lib/*.dylib
EOF
        )
        ->withPkgName('libjwt')
        ->withDependentLibraries('jansson', 'openssl','curl')
    ;

    $p->addLibrary($lib);
};
