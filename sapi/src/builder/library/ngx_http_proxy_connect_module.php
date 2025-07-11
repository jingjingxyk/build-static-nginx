<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $tag = 'v0.0.7';
    $lib = new Library('ngx_http_proxy_connect_module');
    $lib->withHomePage('https://github.com/chobits/ngx_http_proxy_connect_module.git')
        ->withLicense(
            'https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/LICENSE',
            Library::LICENSE_BSD
        )
        ->withManual('https://github.com/chobits/ngx_http_proxy_connect_module.git')
        ->withFile('ngx_http_proxy_connect_module-' . $tag . '.tar.gz')
        ->withDownloadScript(
            'ngx_http_proxy_connect_module',
            <<<EOF
            git clone -b {$tag} --depth 1 --progress   https://github.com/chobits/ngx_http_proxy_connect_module.git
EOF
        )
        ->withBuildScript('return 0')
        ->withBuildCached(false)
        ->withInstallCached(false);

    $p->addLibrary($lib);
};
