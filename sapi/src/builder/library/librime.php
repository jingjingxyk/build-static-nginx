<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {

    $librime_prefix = LIBRIME_PREFIX;

    $glog_prefix = GLOG_PREFIX;
    $libyaml_cpp_prefix = LIBYAML_CPP_PREFIX;
    $leveldb_prefix = LEVELDB_PREFIX;
    $libmarisa_prefix = LIBMARISA_PREFIX;
    $boost_prefix = BOOST_PREFIX;
    $libopencc_prefix = LIBOPENCC_PREFIX;
    $gflags_prefix = GFLAGS_PREFIX;

    $lib = new Library('librime');
    $lib->withHomePage('https://rime.im/')
        ->withLicense('https://github.com/rime/librime/blob/master/LICENSE', Library::LICENSE_BSD)
        ->withManual('https://github.com/rime/librime/blob/master/CMakeLists.txt')
        ->withManual('https://github.com/rime/librime.git')
        ->withFile('librime-latest.tar.gz')
        ->withDownloadScript(
            'librime',
            <<<EOF
            # git clone -b master  --depth=1 --recursive https://github.com/rime/librime.git
            git clone -b master  --depth=1  https://github.com/rime/librime.git
EOF
        )
        ->withPrefix($librime_prefix)
        ->withBuildCached(false)

        /** 使用 cmake 构建 start **/
        ->withBuildScript(
            <<<EOF
             mkdir -p build
             cd build
             cmake .. \
            -DCMAKE_INSTALL_PREFIX={$librime_prefix} \
            -DCMAKE_BUILD_TYPE=Release  \
            -DBUILD_SHARED_LIBS=OFF  \
            -DBUILD_STATIC_LIBS=ON \
            -DBUILD_STATIC=ON \
            -DBUILD_DATA=ON \
            -DBUILD_TEST=OFF \
            -DBoost_ROOT={$boost_prefix} \
            -DCMAKE_PREFIX_PATH="{$glog_prefix};{$libyaml_cpp_prefix};{$leveldb_prefix};{$libmarisa_prefix};{$libopencc_prefix}" \
            -DINCLUDE_DIRECTORIES="{$gflags_prefix}/include/" \
            -DENABLE_LOGGING=OFF

            cmake --build . --config Release --target install

EOF
        )


        ->withPkgName('rime')
        ->withBinPath($librime_prefix . '/bin/')

        ->withDependentLibraries('glog', 'leveldb', 'libopencc', 'libyaml_cpp', 'libmarisa', 'boost', 'gflags')
    ;

    $p->addLibrary($lib);
};

/*
     GB18030-2022新增汉字 中文编码字符集
     https://openstd.samr.gov.cn/bzgk/gb/newGbInfo?hcno=A1931A578FE14957104988029B0833D3
 */


/*

  NEDD boost components filesystem regex system

 */
