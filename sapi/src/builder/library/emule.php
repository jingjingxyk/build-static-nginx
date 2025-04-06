<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $emule_prefix = EMULE_PREFIX;

    //文件名称 和 库名称一致
    $lib = new Library('emule');
    $lib->withHomePage('https://sourceforge.net/projects/emule/files/')
        ->withLicense('https://www.gnu.org/licenses/gpl-2.0.html', Library::LICENSE_LGPL)
        ->withManual('https://sourceforge.net/projects/emule/')
        ->withUrl('https://sourceforge.net/projects/emule/files/eMule/0.50a/eMule0.50a-Sources.zip')
        ->withFileHash('sha1', 'd0e0b78f8a0a7ac6ce37621e974d25bf2d7f04b1')
        ->withFile('eMule0.50a-Sources.zip')
        ->withPrefix($emule_prefix)
        ->withBuildCached(false)
        ->withInstallCached(false)
        ->withUntarArchiveCommand('unzip')
        ->withInstallCached(false)
        ->withBuildScript(<<<EOF
        emule only support windows !
EOF
        )
        ->withDependentLibraries('zlib', 'png');

    $p->addLibrary($lib);
};
