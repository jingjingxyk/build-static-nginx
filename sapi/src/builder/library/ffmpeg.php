<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    // 查看更多 https://git.ffmpeg.org/gitweb

    //更多静态库参考： https://github.com/BtbN/FFmpeg-Builds/tree/master/scripts.d

    //https://github.com/zshnb/ffmpeg-gpu-compile-guide.git

    $ffmpeg_prefix = FFMPEG_PREFIX;
    $libxml2_prefix = LIBXML2_PREFIX;

    $cppflags = $p->getOsType() == 'macos' ? ' ' : "  "; # -I/usr/include
    $ldfalgs = $p->getOsType() == 'macos' ? ' ' : " -static "; #-L/usr/lib


    # $libs = $p->getOsType() == 'macos' ? ' -lc++ ' : ' -lc -lstdc++ /usr/lib/libc.a /usr/lib/libstdc++.a /usr/lib/libm.a /usr/lib/librt.a';
    $libs = $p->getOsType() == 'macos' ? ' -lc++ ' : ' -lc -lstdc++ ';

    # $ldexeflags = $p->getOsType() == 'macos' ? ' ' : ' -Bstatic '; # -wl,-Bstatic -ldl

    $lib = new Library('ffmpeg');
    $lib->withHomePage('https://ffmpeg.org/')
        ->withLicense(
            'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob/refs/heads/master:/LICENSE.md',
            Library::LICENSE_LGPL
        )
        //->withUrl('https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n6.0.tar.gz')
        //->withFile('ffmpeg-v6.tar.gz')
        ->withManual('https://trac.ffmpeg.org/wiki/CompilationGuide')
        ->withFile('ffmpeg-latest.tar.gz')
        ->withDownloadScript(
            'FFmpeg',
            <<<EOF
            # git clone --depth=1  --single-branch  https://git.ffmpeg.org/ffmpeg.git
            git clone -b master --depth=1  https://github.com/FFmpeg/FFmpeg.git
EOF
        )
        ->withPrefix($ffmpeg_prefix)
        ->withPreInstallCommand(
            'alpine',
            <<<EOF
            # 汇编编译器
            apk add yasm nasm
EOF
        )
        ->withBuildCached(false)
        //->withInstallCached(false)
        ->withConfigure(
            <<<EOF

            #  libavresample 已弃用，默认编译时不再构建它

            set -x
            ./configure --help
            # ./configure --help | grep shared
            # ./configure --help | grep static
            # ./configure --help | grep  '\-\-extra'
            # ./configure --help | grep  'enable'
            # ./configure --help | grep  'disable'

            PACKAGES='openssl  libxml-2.0  freetype2 gmp liblzma' # libssh2
            PACKAGES="\$PACKAGES libsharpyuv  libwebp  libwebpdecoder  libwebpdemux  libwebpmux"
            PACKAGES="\$PACKAGES SvtAv1Dec SvtAv1Enc "
            PACKAGES="\$PACKAGES aom "
            PACKAGES="\$PACKAGES dav1d "
            PACKAGES="\$PACKAGES lcms2 "
            PACKAGES="\$PACKAGES x264 "
            PACKAGES="\$PACKAGES x265 " # numa
            PACKAGES="\$PACKAGES sdl2 "
            PACKAGES="\$PACKAGES ogg "
            PACKAGES="\$PACKAGES opus "
            PACKAGES="\$PACKAGES openh264 "
            PACKAGES="\$PACKAGES vpx "
            PACKAGES="\$PACKAGES fdk-aac "
            PACKAGES="\$PACKAGES fribidi "
            PACKAGES="\$PACKAGES librabbitmq "

            CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES) "
            LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) "
            LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES) "

            CPPFLAGS="\$CPPFLAGS -I{$libxml2_prefix}/include/  "
            CPPFLAGS="\$CPPFLAGS  {$cppflags} "

            LDFLAGS="\$LDFLAGS  "
            LDFLAGS="\$LDFLAGS  {$ldfalgs} "

            LIBS="\$LIBS   "
            LIBS="\$LIBS  {$libs} "

            ./configure  \
            --prefix=$ffmpeg_prefix \
            --enable-gpl \
            --enable-version3 \
            --disable-shared \
            --enable-nonfree \
            --enable-static \
            --enable-pic \
            --enable-gray \
            --enable-ffplay \
            --enable-openssl \
            --enable-libwebp \
            --enable-libxml2 \
            --enable-libsvtav1 \
            --enable-libaom \
            --enable-lcms2 \
            --enable-gmp \
            --enable-libfreetype \
            --enable-libvpx \
            --enable-sdl2 \
            --enable-libdav1d \
            --enable-libopus \
            --enable-libopenh264 \
            --enable-libfdk-aac \
            --enable-libfribidi \
            --enable-librabbitmq \
            --enable-libx265 \
            --enable-libx264 \
            --disable-libxcb \
            --disable-libxcb-shm \
            --disable-libxcb-xfixes \
            --disable-libxcb-shape  \
            --disable-xlib  \
            --extra-cflags=" \${CPPFLAGS} " \
            --extra-cxxflags="\${CPPFLAGS} " \
            --extra-ldflags="\${LDFLAGS} " \
            --extra-libs="\${LIBS} " \
            --cc={$p->get_C_COMPILER()} \
            --cxx={$p->get_CXX_COMPILER()} \
            --pkg-config-flags="--static"

            # libxcb、xlib 是 x11 相关的库


            # --ld={$p->getLinker()}
            # --enable-libssh
            # --enable-cross-compile
            # --enable-libspeex

            # --enable-random \  # 需要外部组件
EOF
        )
        ->withPkgName('libavcodec')
        ->withPkgName('libavdevice')
        ->withPkgName('libavfilter')
        ->withPkgName('libavformat')
        ->withPkgName('libavutil')
        ->withPkgName('libswresample')
        ->withPkgName('libswscale')
        ->withBinPath($ffmpeg_prefix . '/bin/')
        ->withDependentLibraries(
            'openssl',
            'zlib',
            'liblzma',
            'libxml2',
            'libwebp',
            'svt_av1',
            'dav1d',
            'aom',
            'freetype',
            "gmp",
            "lcms2",
            "libx264",
            "liblzma",
            "libvpx",
            "sdl2",
            'libogg',
            'libopus',
            'openh264',
            'fdk_aac',
            'libfribidi',
            'rabbitmq_c',
            "libx265",
            //'speex', //被opus 取代
            //'libssh2',
        );

    $p->addLibrary($lib);
};
