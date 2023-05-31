<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $privoxy_prefix = PCRE2_PREFIX;
    $p->addLibrary(
        (new Library('privoxy'))
            ->withHomePage('https://github.com/PCRE2Project/pcre2.git')
            ->withUrl('https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.gz')
            ->withDocumentation('https://pcre2project.github.io/pcre2/doc/html/index.html')
            ->withManual('https://github.com/PCRE2Project/pcre2.git')
            ->withLicense(
                'https://github.com/PCRE2Project/pcre2/blob/master/COPYING',
                Library::LICENSE_SPEC
            )
            ->withFile('pcre2-10.42.tar.gz')
            ->withPrefix($privoxy_prefix)
            ->withCleanBuildDirectory()
            ->withCleanPreInstallDirectory($privoxy_prefix)
            ->withConfigure(
                <<<EOF
                ./configure --help

                ./configure \
                --prefix=$pcre2_prefix \
                --enable-shared=no \
                --enable-static=yes \
                --enable-pcre2-16 \
                --enable-pcre2-32 \
                --enable-jit \
                --enable-unicode


 EOF
            )
    //->withPkgName("libpcrelibpcre2-32libpcre2-8 libpcre2-posix")
    );
};