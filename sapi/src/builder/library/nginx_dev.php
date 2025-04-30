<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $builderDir = $p->getBuildDir();
    $workDir = $p->getWorkDir();

    $nginx_prefix = NGINX_PREFIX;

    $openssl = $p->getLibrary('openssl');
    $zlib = $p->getLibrary('zlib');
    $pcre2 = $p->getLibrary('pcre2');
    $options='';
    $cflags = '';
    $ldflags = '';
    if ($p->isLinux()) {
        $cflags .= ' -static -fPIE ';
        $ldflags .= ' -static  '; //-static-pie
        $options .=' --with-file-aio ';
    }
    $tag = '1.28.0';
    $p->addLibrary(
        (new Library('nginx_dev'))
            ->withHomePage('https://nginx.org/')
            ->withLicense('https://github.com/nginx/nginx/blob/master/docs/text/LICENSE', Library::LICENSE_SPEC)
            ->withManual('https://github.com/nginx/nginx')
            ->withManual('http://nginx.org/en/docs/configure.html')
            ->withDocumentation('https://nginx.org/en/docs/')
            ->withFile('nginx-release-' . $tag . '.tar.gz')
            ->withDownloadScript(
                'nginx',
                <<<EOF
                git clone -b release-{$tag} --depth 1 --progress  https://github.com/nginx/nginx.git
EOF
            )
            ->withPrefix($nginx_prefix)
            ->withBuildCached(false)
            ->withInstallCached(false)
            ->withConfigure(
                <<<EOF

            set -x
            patch -p1 < {$builderDir}/ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch

            cp -f auto/configure configure

            ./configure --help

            PACKAGES=" libxml-2.0 libexslt libxslt openssl zlib"
            PACKAGES=" \$PACKAGES libjwt libcurl jansson"
            PACKAGES=" \$PACKAGES libcares libbrotlicommon libbrotlidec libbrotlienc libzstd libnghttp2"
            PACKAGES=" \$PACKAGES libssh2 libnghttp3 libngtcp2  libngtcp2_crypto_quictls"

            # pcre-2.0
            PACKAGES="\$PACKAGES libpcre2-16  libpcre2-32  libpcre2-8   libpcre2-posix"

            CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES)"
            LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES)"
            LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES)"

             ./configure \
            --prefix={$nginx_prefix} \
            --with-http_ssl_module \
            --with-http_gzip_static_module \
            --with-http_stub_status_module \
            --with-http_realip_module \
            --with-http_gunzip_module \
            --with-http_mp4_module \
            --with-http_random_index_module \
            --with-http_auth_request_module \
            --with-http_v2_module \
            --with-http_v3_module \
            --with-http_flv_module \
            --with-http_sub_module \
            --with-stream \
            --with-stream_ssl_preread_module \
            --with-stream_ssl_module \
            --with-stream_realip_module \
            --with-threads \
            --with-cc-opt="{$cflags}  \$CPPFLAGS " \
            --with-ld-opt="{$ldflags} \$LDFLAGS \$LIBS " \
            --add-module={$builderDir}/ngx_http_proxy_connect_module/ \
            --add-module={$builderDir}/ngx_http_auth_jwt_module/ \
            {$options}

EOF
            )
            ->withBinPath($nginx_prefix . '/sbin/')
            ->withDependentLibraries(
                'libxml2',
                'libxslt',
                'openssl',
                'zlib',
                'pcre2',
                'ngx_http_proxy_connect_module',
                'ngx_http_auth_jwt_module',
                'libjwt'
            )
    );
};


