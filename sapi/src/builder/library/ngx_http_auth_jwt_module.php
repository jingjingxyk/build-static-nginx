<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $tag = '2.3.1';
    $lib = new Library('ngx_http_auth_jwt_module');
    $lib->withHomePage('https://github.com/TeslaGov/ngx-http-auth-jwt-module.git')
        ->withLicense(
            'https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/LICENSE',
            Library::LICENSE_BSD
        )
        ->withManual('https://github.com/TeslaGov/ngx-http-auth-jwt-module.git')
        ->withFile('ngx_http_proxy_connect_module-' . $tag . '.tar.gz')
        ->withDownloadScript(
            'ngx_http_proxy_connect_module',
            <<<EOF
            git clone -b {$tag} --depth 1 --progress   https://github.com/TeslaGov/ngx-http-auth-jwt-module.git
EOF
        )
        ->withBuildScript('return 0')
        ->withBuildCached(false)
        ->withInstallCached(false);

    $p->addLibrary($lib);
};
