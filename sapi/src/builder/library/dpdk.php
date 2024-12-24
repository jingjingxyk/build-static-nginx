<?php

use SwooleCli\Library;
use SwooleCli\Preprocessor;

return function (Preprocessor $p) {
    $dpdk_prefix = DPDK_PREFIX;
    $libarchive_prefix = LIBARCHIVE_PREFIX;
    $numa_prefix = NUMA_PREFIX;
    $liblzma_prefix = LIBLZMA_PREFIX;
    $libiconv_prefix = ICONV_PREFIX;
    $bzip2_prefix = BZIP2_PREFIX;
    $p->addLibrary(
        (new Library('dpdk'))
            ->withHomePage('http://core.dpdk.org/')
            ->withLicense('https://core.dpdk.org/contribute/', Library::LICENSE_BSD)
            ->withManual('https://github.com/DPDK/dpdk.git')
            ->withManual('http://core.dpdk.org/doc/')
            ->withManual('https://core.dpdk.org/doc/quick-start/')
            ->withFile('dpdk-v22.11.3.tar.gz')
            ->withDownloadScript(
                'dpdk-stable',
                <<<EOF
                # https://git.dpdk.org/dpdk-stable/refs

                git clone -b v22.11.3 --depth=1 https://dpdk.org/git/dpdk-stable
EOF
            )

            ->withPreInstallCommand(
                'alpine',
                <<<EOF
            apk add python3 py3-pip
            # pip3 install  pyelftools -i https://pypi.tuna.tsinghua.edu.cn/simple
            # pip3 install  pyelftools -ihttps://pypi.python.org/simple
            apk add meson
            pip3 install  pyelftools
            apk add bsd-compat-headers
            # apk add libxdp libxdp-static
            # apk add libxdp numactl-dev numactl-tools
            # apk add libfdt
            # apk add libarchive-dev libarchive-static
EOF
            )
            ->withPreInstallCommand(
                'debian',
                <<<EOF
            apt install python3-pyelftools
EOF
            )
            ->withBuildCached(false)
            ->withBuildScript(
                <<<EOF

            test -d build && rm -rf build
            meson  -h
            meson setup -h
            # meson configure -h

            PACKAGES=" jansson  openssl libxml-2.0  nettle hogweed gmp  "
            # PACKAGES="\$PACKAGES numa "
            PACKAGES="\$PACKAGES zlib  liblzma liblz4 libzstd "
            # PACKAGES="\$PACKAGES  liblzma  "
            # PACKAGES="\$PACKAGES libarchive "
            # PACKAGES="\$PACKAGES libpcap "
            # PACKAGES="\$PACKAGES  libbpf "
            PACKAGES="\$PACKAGES libmlx4 libibverbs libmlx5 libefa libibmad libibnetdisc libibumad libmana librdmacm  "
            PACKAGES="\$PACKAGES libnl-genl-3.0 libnl-idiag-3.0 libnl-route-3.0 libnl-xfrm-3.0 "
            # PACKAGES="\$PACKAGES libbsd libbsd-overlay libmd "


            CPPFLAGS="$(pkg-config  --cflags-only-I  --static \$PACKAGES) "
            LDFLAGS="$(pkg-config   --libs-only-L    --static \$PACKAGES) "
            LIBS="$(pkg-config      --libs-only-l    --static \$PACKAGES) "

            CPPFLAGS="\$CPPFLAGS -I{$libiconv_prefix}/include -I{$bzip2_prefix}/include  " # -I{$libarchive_prefix}/include
            LDFLAGS="\$LDFLAGS -L{$libiconv_prefix}/lib -L{$bzip2_prefix}/lib " # -L{$libarchive_prefix}/lib
            LIBS="\$LIBS  -liconv -lbz2 "

            CPPFLAGS="\$CPPFLAGS" \
            LDFLAGS="\$LDFLAGS" \
            LIBS="\$LIBS"  \
            meson setup  build \
            -Dprefix={$dpdk_prefix} \
            -Dbackend=ninja \
            -Dbuildtype=release \
            -Ddefault_library=static \
            -Db_staticpic=true \
            -Db_pie=true \
            -Dprefer_static=true \
            -Dibverbs_link=static \
            -Dtests=false \
            -Dibverbs_link=static \
            -Dexamples='cmdline' \
            -Denable_apps='dumpcap,pdump,proc-info' \
            -Dcheck_includes=true

            # -Dexamples=all
            # -Dexamples=''


            ninja -C build
            ninja -C build install

            # ldconfig
            # pkg-config --modversion libdpdk
EOF
            )
            ->withBinPath($dpdk_prefix . '/bin/')
            ->withDependentLibraries(
                'jansson',
                'zlib',
                'openssl',
                'libmlx5',
                'libnl',
                'liblzma',
                'liblz4',
                'libiconv',
                'libzstd',
                'bzip2',
                'nettle',
                'bzip2',
                'libxml2',
                'libiconv',
                'gmp'
                //'libarchive',
                //'numa',
                //'libpcap',
                //'libxdp',
                //'libbpf',
                //'libbsd',

            )
            ->withScriptAfterInstall(
                <<<EOF
            rm -rf {$dpdk_prefix}/lib/*.so.*
            rm -rf {$dpdk_prefix}/lib/*.so
            rm -rf {$dpdk_prefix}/lib/*.dylib
            rm -rf {$dpdk_prefix}/lib/dpdk/
EOF
            )
        ->withPkgName('libdpdk-libs')
        ->withPkgName('libdpdk')
    );
};

/*

DPDK (Data Plane Development Kit)

PPS（Packet Per Second)

PMD（Poll Mode Driver）

UIO（Userspace I/O）

Zero Copy、无系统调用的好处


https://cloud.tencent.com/developer/article/1198333

https://www.packetcoders.io/what-is-dpdk/

 */
