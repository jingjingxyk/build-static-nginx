<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $liboauth2_prefix = EXAMPLE_PREFIX;
    $liboauth2_prefix = LIBOAUTH2_PREFIX;
    $openssl_prefix = OPENSSL_PREFIX;
    $gettext_prefix = GETTEXT_PREFIX;
    $cares_prefix = CARES_PREFIX;
    $nginx_prefix = NGINX_PREFIX;
    $build_dir=$p->getBuildDir();
    $lib = new Library('liboauth2');
    $lib->withHomePage('https://github.com/OpenIDC/liboauth2.git')
        ->withLicense('http://www.gnu.org/licenses/lgpl-2.1.html', Library::LICENSE_LGPL)
        ->withManual('https://github.com/OpenIDC/liboauth2.git')
        ->withUrl('https://github.com/OpenIDC/liboauth2/archive/refs/tags/v1.6.3.tar.gz')
        ->withFile('liboauth2-v1.6.3.tar.gz')
        ->withPrefix($liboauth2_prefix)
        ->withBuildCached(false)
        ->withInstallCached(false)
        /* 使用 autoconfig automake  构建 start  */
        ->withConfigure(
            <<<EOF
        sh autogen.sh

        ./configure --help


        CURL_CFLAGS=$(pkg-config  --cflags --static libcurl)
        CURL_LIBS=$(pkg-config    --libs   --static libcurl)

        PACKAGES='openssl  '
        PACKAGES="\$PACKAGES zlib"
        # PACKAGES="\$PACKAGES libcurl"
        PACKAGES="\$PACKAGES jansson"
        PACKAGES="\$PACKAGES libpcre2-16 libpcre2-32 libpcre2-8 libpcre2-posix"
        PACKAGES="\$PACKAGES hiredis"
        PACKAGES="\$PACKAGES cjose"

        CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)" \
        LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) " \
        LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)" \
        ./configure \
        --prefix={$liboauth2_prefix} \
        --enable-shared=no \
        --enable-static=yes \
        --with-redis \
        --without-apache \
        --with-nginx={$nginx_prefix} \

EOF
        )
        ->withPkgName('liboauth2')
        ->withDependentLibraries(
            'zlib',
            'openssl',
            'curl',
            'pcre2',
            'hiredis',
            'jansson',
            'cjose',
            'nginx'

        )
    ;
    $p->addLibrary($lib);
};

