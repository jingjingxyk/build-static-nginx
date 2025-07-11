<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $tag = '1.2.6';
    $lib = new Library('ngx_sticky_module');
    $lib->withHomePage('https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng.git')
        ->withLicense(
            'https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/src/master/LICENSE',
            Library::LICENSE_SPEC
        )
        ->withManual('https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng.git')
        ->withFile('nginx-sticky-module-ng-' . $tag . '.tar.gz')
        ->withDownloadScript(
            'nginx-sticky-module-ng',
            <<<EOF
            git clone -b {$tag} --progress  https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng.git
EOF
        )
        ->withBuildScript('return 0')
        ->withBuildCached(false)
        ->withInstallCached(false);

    $p->addLibrary($lib);
};
