<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $example_prefix = EXAMPLE_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;

    //各种其他设备的远程配置和管理的事实上的标准

    $lib = new Library('sysrepo');
    $lib->withHomePage('https://www.sysrepo.org/')
        ->withLicense('https://github.com/sysrepo/sysrepo/blob/master/LICENSE', Library::LICENSE_BSD)
        ->withUrl('https://github.com/sysrepo/sysrepo/archive/refs/tags/v2.2.73.tar.gz')
        ->withFile('sysrepo-v2.2.73.tar.gz')
        ->withManual('https://github.com/sysrepo/sysrepo.git')
        ->withBuildCached(false)
        ->withPrefix($example_prefix)
        ->withBuildScript(
            <<<EOF
        mkdir -p build
        cd build

        cmake .. \
        -DCMAKE_INSTALL_PREFIX={$example_prefix} \
        -DCMAKE_POLICY_DEFAULT_CMP0074=NEW \
        -DCMAKE_BUILD_TYPE=Release  \
        -DBUILD_SHARED_LIBS=OFF  \
        -DBUILD_STATIC_LIBS=ON \
        -DOpenSSL_ROOT={$openssl_prefix} \


EOF
        )
        ->withBinPath($example_prefix . '/bin/')
        ->withDependentLibraries('openssl')
    ;

    $p->addLibrary($lib);

};
