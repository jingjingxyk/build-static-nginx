<?php

use SwooleCli\Preprocessor;

$p = Preprocessor::getInstance();

define("JPEG_PREFIX", $p->getGlobalPrefix() . '/libjpeg');
define("GIF_PREFIX", $p->getGlobalPrefix() . '/libgif');
define("ZIP_PREFIX", $p->getGlobalPrefix() . '/libzip');
define("ZLIB_PREFIX", $p->getGlobalPrefix() . '/zlib');
define("BZIP2_PREFIX", $p->getGlobalPrefix() . '/bzip2');

define("FREETYPE_PREFIX", $p->getGlobalPrefix() . '/freetype');
define("PNG_PREFIX", $p->getGlobalPrefix() . '/libpng');
define("WEBP_PREFIX", $p->getGlobalPrefix() . '/libwebp');


define("CURL_PREFIX", $p->getGlobalPrefix() . '/curl');
define("CARES_PREFIX", $p->getGlobalPrefix() . '/cares');
define("OPENSSL_PREFIX", $p->getGlobalPrefix() . '/openssl');
define("OPENSSL_v1_PREFIX", $p->getGlobalPrefix() . '/openssl_v1');

define("LIBGCRYPT_PREFIX", $p->getGlobalPrefix() . '/libgcrypt');
define("LIBGCRYPT_ERROR_PREFIX", $p->getGlobalPrefix() . '/libgcrypt_error');

define("GMP_PREFIX", $p->getGlobalPrefix() . '/gmp');
define("ICONV_PREFIX", $p->getGlobalPrefix() . '/libiconv');
define("IMAGEMAGICK_PREFIX", $p->getGlobalPrefix() . '/imagemagick');
define("ICU_PREFIX", $p->getGlobalPrefix() . '/icu');
define("ONIGURUMA_PREFIX", $p->getGlobalPrefix() . '/oniguruma');
define("MIMALLOC_PREFIX", $p->getGlobalPrefix() . '/mimalloc');
define("NCURSES_PREFIX", $p->getGlobalPrefix() . '/ncurses');
define("READLINE_PREFIX", $p->getGlobalPrefix() . '/readline');
define("LIBYAML_PREFIX", $p->getGlobalPrefix() . '/libyaml');
define("LIBXML2_PREFIX", $p->getGlobalPrefix() . '/libxml2');
define("LIBXSLT_PREFIX", $p->getGlobalPrefix() . '/libxslt');
define("SQLITE3_PREFIX", $p->getGlobalPrefix() . '/sqlite3');
define("LIBSODIUM_PREFIX", $p->getGlobalPrefix() . '/libsodium');
define("LIBEDIT_PREFIX", $p->getGlobalPrefix() . '/libedit');

define("BROTLI_PREFIX", $p->getGlobalPrefix() . '/brotli');

define("LIBLZ4_PREFIX", $p->getGlobalPrefix() . '/liblz4');
define("LIBLZMA_PREFIX", $p->getGlobalPrefix() . '/liblzma');
define("LIBZSTD_PREFIX", $p->getGlobalPrefix() . '/libzstd');

define("BISON_PREFIX", $p->getGlobalPrefix() . '/bison');
define("NGHTTP2_PREFIX", $p->getGlobalPrefix() . '/nghttp2');

define("LIBFFI_PREFIX", $p->getGlobalPrefix() . '/libffi');

define("LIBEV_PREFIX", $p->getGlobalPrefix() . '/libev');
define("LIBUV_PREFIX", $p->getGlobalPrefix() . '/libuv');

define("LIBXLSXWRITER_PREFIX", $p->getGlobalPrefix() . '/libxlsxwriter');
define("LIBMINZIP_PREFIX", $p->getGlobalPrefix() . '/libminizip');
define("LIBXLSXIO_PREFIX", $p->getGlobalPrefix() . '/libxlsxio');
define("LIBMCRYPT_PREFIX", $p->getGlobalPrefix() . '/libmcrypt');
define("PRIVOXY_PREFIX", $p->getGlobalPrefix() . '/privoxy');


define("LIBDE265_PREFIX", $p->getGlobalPrefix() . '/libde265');
define("LIBX264_PREFIX", $p->getGlobalPrefix() . '/libx264');
define("NUMA_PREFIX", $p->getGlobalPrefix() . '/numa');
define("LIBX265_PREFIX", $p->getGlobalPrefix() . '/libx265');

define("LIBHEIF_PREFIX", $p->getGlobalPrefix() . '/libheif');
define("LIBJXL_PREFIX", $p->getGlobalPrefix() . '/libjxl');
define("LIBGD_PREFIX", $p->getGlobalPrefix() . '/libgd');


define("RAV1E_PREFIX", $p->getGlobalPrefix() . '/rav1e');


define("DEPOT_TOOLS_PREFIX", $p->getGlobalPrefix() . '/depot_tools');


define("HARFBUZZ_PREFIX", $p->getGlobalPrefix() . '/harfbuzz');
define("LIBFRIBIDI_PREFIX", $p->getGlobalPrefix() . '/libfribidi');


define("JANSSON_PREFIX", $p->getGlobalPrefix() . '/jansson');
define("NETTLE_PREFIX", $p->getGlobalPrefix() . '/nettle');
define("LIBTASN1_PREFIX", $p->getGlobalPrefix() . '/libtasn1');

define("GNUTLS_PREFIX", $p->getGlobalPrefix() . '/gnutls');

define("OPENCV_PREFIX", $p->getGlobalPrefix() . '/opencv');
define("OPENCV_DOCS_PREFIX", $p->getGlobalPrefix() . '/opencv_docs');


define("GNUPG_PREFIX", $p->getGlobalPrefix() . '/gnupg');
define("BOOST_PREFIX", $p->getGlobalPrefix() . '/boost');
define("BORINGSSL_PREFIX", $p->getGlobalPrefix() . '/boringssl');
define("WOLFSSL_PREFIX", $p->getGlobalPrefix() . '/wolfssl');
define("VALGRIND_PREFIX", $p->getGlobalPrefix() . '/valgrind');
define("CAPSTONE_PREFIX", $p->getGlobalPrefix() . '/capstone');
define("DYNASM_PREFIX", $p->getGlobalPrefix() . '/dynasm');


define("NGINX_PREFIX", $p->getGlobalPrefix() . '/nginx');
define("PCRE2_PREFIX", $p->getGlobalPrefix() . '/pcre2');
define("PCRE_PREFIX", $p->getGlobalPrefix() . '/pcre');

define("LIBIDN2_PREFIX", $p->getGlobalPrefix() . '/libidn2');

const DOWNLOAD_FILE_RETRY_NUMBE = 5;
const DOWNLOAD_FILE_WAIT_RETRY = 5;
const DOWNLOAD_FILE_USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36';

const DOWNLOAD_FILE_CONNECTION_TIMEOUT = 15;

define("NGHTTP3_PREFIX", $p->getGlobalPrefix() . '/nghttp3');
define("NGTCP2_PREFIX", $p->getGlobalPrefix() . '/ngtcp2');
define("LIBSSH2_PREFIX", $p->getGlobalPrefix() . '/libssh2');

define("FFMPEG_PREFIX", $p->getGlobalPrefix() . '/ffmpeg');
define("NODEJS_PREFIX", $p->getGlobalPrefix() . '/nodejs');
define("GOLANG_PREFIX", $p->getGlobalPrefix() . '/golang');


define("XORGPROTO_PREFIX", $p->getGlobalPrefix() . '/xorgproto');
define("LIBX11_PREFIX", $p->getGlobalPrefix() . '/libX11');
define("LIBXPM_PREFIX", $p->getGlobalPrefix() . '/libXpm');
define("GRAPHVIZ_PREFIX", $p->getGlobalPrefix() . '/graphviz');

define('LIBRSVG_PREFIX', $p->getGlobalPrefix() . '/librsvg');

define('GETTEXT_PREFIX', $p->getGlobalPrefix() . '/gettext');

define("PGSQL_PREFIX", $p->getGlobalPrefix() . '/pgsql');
define("UNIX_ODBC_PREFIX", $p->getGlobalPrefix() . '/unix_odbc');
define("LIBUUID_PREFIX", $p->getGlobalPrefix() . '/libuuid');
define("LIBINTL_PREFIX", $p->getGlobalPrefix() . '/libintl');
define("LIBUNISTRING_PREFIX", $p->getGlobalPrefix() . '/libunistring');
define("LIBURING_PREFIX", $p->getGlobalPrefix() . '/liburing');

define("ZOOKEEPER_PREFIX", $p->getGlobalPrefix() . '/zookeeper');

define("LIBEVENT_PREFIX", $p->getGlobalPrefix() . '/libevent');

define("SNAPPY_PREFIX", $p->getGlobalPrefix() . '/snappy');
define("LIBSASL_PREFIX", $p->getGlobalPrefix() . '/sasl');

define("LIBARCHIVE_PREFIX", $p->getGlobalPrefix() . '/libarchive');

define("SOCAT_PREFIX", $p->getGlobalPrefix() . '/socat');
define("ARIA2_PREFIX", $p->getGlobalPrefix() . '/aria2');

define("OVS_PREFIX", $p->getGlobalPrefix() . '/ovs');
define("OVN_PREFIX", $p->getGlobalPrefix() . '/ovn');
define("DPDK_PREFIX", $p->getGlobalPrefix() . '/dpdk');

define("COTURN_PREFIX", $p->getGlobalPrefix() . '/coturn');
define("HIREDIS_PREFIX", $p->getGlobalPrefix() . '/hiredis');
define("LIBMICROHTTP_PREFIX", $p->getGlobalPrefix() . '/libmicrohttp');

define("VTK_PREFIX", $p->getGlobalPrefix() . '/vtk');
define("JEMALLOC_PREFIX", $p->getGlobalPrefix() . '/jemalloc');
define("TCMALLOC_PREFIX", $p->getGlobalPrefix() . '/tcmalloc');


define("LIBWEBSOCKETS_PREFIX", $p->getGlobalPrefix() . '/libwebsockets');
define("GSTREAMER_PREFIX", $p->getGlobalPrefix() . '/gstreamer');
define("LIBNICE_PREFIX", $p->getGlobalPrefix() . '/libnice');
define("LIBSRTP_PREFIX", $p->getGlobalPrefix() . '/libsrtp');
define("LIBUSRSCTP_PREFIX", $p->getGlobalPrefix() . '/libusrsctp');
define("LIBMICROHTTPD_PREFIX", $p->getGlobalPrefix() . '/libmicrohttpd');
define("JANUS_GATEWAY_PREFIX", $p->getGlobalPrefix() . '/janus_gateway');
define("FREESWITCH_PREFIX", $p->getGlobalPrefix() . '/freeswitch');
define("LIBBPF_PREFIX", $p->getGlobalPrefix() . '/libbpf');
define("LIBELF_PREFIX", $p->getGlobalPrefix() . '/libelf');
define("CEPH_PREFIX", $p->getGlobalPrefix() . '/ceph');

define("IPERF3_PREFIX", $p->getGlobalPrefix() . '/iperf3');
define("OPENSSH_PREFIX", $p->getGlobalPrefix() . '/openssh');
define("LIBFIDO2_PREFIX", $p->getGlobalPrefix() . '/libfido2');
define("HIDAPI_PREFIX", $p->getGlobalPrefix() . '/hidapi');
define("LIBCBOR_PREFIX", $p->getGlobalPrefix() . '/libcbor');
define("LIBUDEV_PREFIX", $p->getGlobalPrefix() . '/libudev');

define("OPENCL_PREFIX", $p->getGlobalPrefix() . '/opencl');
define("OPENGL_PREFIX", $p->getGlobalPrefix() . '/opengl');
define("SPANDSP_PREFIX", $p->getGlobalPrefix() . '/spandsp');
define("SOFIA_SIP_PREFIX", $p->getGlobalPrefix() . '/sofia_sip');
define("AUDIOFILE_PREFIX", $p->getGlobalPrefix() . '/audiofile');
define("FLAC_PREFIX", $p->getGlobalPrefix() . '/flac');
define("LIBOGG_PREFIX", $p->getGlobalPrefix() . '/libogg');
define("ALSA_AUDIO_PREFIX", $p->getGlobalPrefix() . '/alsa_audio');
define("LIBOPUS_PREFIX", $p->getGlobalPrefix() . '/libopus');
define("LIBOPUSENC_PREFIX", $p->getGlobalPrefix() . '/libopusenc');
define("LIBOPUSFILE_PREFIX", $p->getGlobalPrefix() . '/libopusfile');
define("SPEEX_PREFIX", $p->getGlobalPrefix() . '/speex');
define("SPEEXDSP_PREFIX", $p->getGlobalPrefix() . '/speexdsp');
define("LIBLDNS_PREFIX", $p->getGlobalPrefix() . '/libldns');
define("LIBPCAP_PREFIX", $p->getGlobalPrefix() . '/libpcap');
define("PORTAUDIO_PREFIX", $p->getGlobalPrefix() . '/portaudio');
define("LIBKS_PREFIX", $p->getGlobalPrefix() . '/libks');
define("UTIL_LINUX_PREFIX", $p->getGlobalPrefix() . '/util_linux');
define("LIBATOMIC_PREFIX", $p->getGlobalPrefix() . '/libatomic');
define("UPNP_PREFIX", $p->getGlobalPrefix() . '/upnp');

define("USRSCTP_PREFIX", $p->getGlobalPrefix() . '/usrsctp');
define("RABBITMQ_C_PREFIX", $p->getGlobalPrefix() . '/rabbitmq_c');
define("LIBCONFIG_PREFIX", $p->getGlobalPrefix() . '/libconfig');
define("OPENH264_PREFIX", $p->getGlobalPrefix() . '/openh264');
define("PAHO_MQTT_PREFIX", $p->getGlobalPrefix() . '/paho_mqtt');

define("SDL2_PREFIX", $p->getGlobalPrefix() . '/sdl2');

define("LIBVPX_PREFIX", $p->getGlobalPrefix() . '/libvpx');
define("CJSON_PREFIX", $p->getGlobalPrefix() . '/cjson');
define("BLENDER_PREFIX", $p->getGlobalPrefix() . '/blender');
define("LIBG722_PREFIX", $p->getGlobalPrefix() . '/libg722');
define("OPENXR_PREFIX", $p->getGlobalPrefix() . '/OpenXR');
define("FREETDM_PREFIX", $p->getGlobalPrefix() . '/freetdm');
define("LIBPRI_PREFIX", $p->getGlobalPrefix() . '/libpri');

define("APR_PREFIX", $p->getGlobalPrefix() . '/apr');
define("APR_UTIL_PREFIX", $p->getGlobalPrefix() . '/apr-util');
define("LIBEXPAT_PREFIX", $p->getGlobalPrefix() . '/libexpat');


define("LIBAVIF_PREFIX", $p->getGlobalPrefix() . '/libavif');
define("DAV1D_PREFIX", $p->getGlobalPrefix() . '/dav1d');
define("LIBGAV1_PREFIX", $p->getGlobalPrefix() . '/libgav1');
define("AOM_PREFIX", $p->getGlobalPrefix() . '/aom');
define("SVT_AV1_PREFIX", $p->getGlobalPrefix() . '/svt_av1');

define("LIBTIFF_PREFIX", $p->getGlobalPrefix() . '/libtiff');
define("LIBRAW_PREFIX", $p->getGlobalPrefix() . '/libraw');
define("LCMS2_PREFIX", $p->getGlobalPrefix() . '/lcms2');


define("LIBARGON2_PREFIX", $p->getGlobalPrefix() . '/libargon2');
define("FFTW3_PREFIX", $p->getGlobalPrefix() . '/fftw3');
define("LIBSAMPLERATE_PREFIX", $p->getGlobalPrefix() . '/libsamplerate');

define("LIBCAP_NG_PREFIX", $p->getGlobalPrefix() . '/libcap_ng');
define("ICECREAM_PREFIX", $p->getGlobalPrefix() . '/icecream');
define("LZO_PREFIX", $p->getGlobalPrefix() . '/lzo');

define("LIBDRM_PREFIX", $p->getGlobalPrefix() . '/libdrm');
define("GLSLANG_PREFIX", $p->getGlobalPrefix() . '/glslang');
define("MESA3D_PREFIX", $p->getGlobalPrefix() . '/mesa3d');
define("LIBPLACEBO_PREFIX", $p->getGlobalPrefix() . '/libplacebo');
define("VULKAN_PREFIX", $p->getGlobalPrefix() . '/vulkan');
define("SHADERC_PREFIX", $p->getGlobalPrefix() . '/shaderc');
define("SPIRV_TOOLS_PREFIX", $p->getGlobalPrefix() . '/spirv_tools');
define("FDK_AAC_PREFIX", $p->getGlobalPrefix() . '/fdk_aac');

define("PROMETHEUS_CLIENT_C_PREFIX", $p->getGlobalPrefix() . '/prometheus_client_c');

define("LIBBSON_PREFIX", $p->getGlobalPrefix() . '/libbson');
define("LIBMONGOCRYPT_PREFIX", $p->getGlobalPrefix() . '/libmongocrypt');
define("LIBMONGOC_PREFIX", $p->getGlobalPrefix() . '/libmongoc');
define("LIBRIME_PREFIX", $p->getGlobalPrefix() . '/librime');
define("GLOG_PREFIX", $p->getGlobalPrefix() . '/glog');
define("LIBUNWIND_PREFIX", $p->getGlobalPrefix() . '/libunwind');
define("GFLAGS_PREFIX", $p->getGlobalPrefix() . '/gflags');
define("LEVELDB_PREFIX", $p->getGlobalPrefix() . '/leveldb');

define("PYTHON3_PREFIX", $p->getGlobalPrefix() . '/python3');
define("MPDECIMAL_PREFIX", $p->getGlobalPrefix() . '/mpdecimal');
define("LIBB2_PREFIX", $p->getGlobalPrefix() . '/libb2');

define("LIBOPENCC_PREFIX", $p->getGlobalPrefix() . '/libopencc');
define("LIBYAML_CPP_PREFIX", $p->getGlobalPrefix() . '/libyaml_cpp');
define("LIBMARISA_PREFIX", $p->getGlobalPrefix() . '/libmarisa');
define("LIBSCTP_PREFIX", $p->getGlobalPrefix() . '/libsctp');
define("BCG729_PREFIX", $p->getGlobalPrefix() . '/bcg729');
define("LIBDEFLATE_PREFIX", $p->getGlobalPrefix() . '/libdeflate');

define("COREUTILS_PREFIX", $p->getGlobalPrefix() . '/coreutils');
define("LIBGOMP_PREFIX", $p->getGlobalPrefix() . '/libgomp');
define("LIBMLX5_PREFIX", $p->getGlobalPrefix() . '/libmlx5');
define("LIBNL_PREFIX", $p->getGlobalPrefix() . '/libnl');
define("LIBFVAD_PREFIX", $p->getGlobalPrefix() . '/libfvad');
define("GVDB_PREFIX", $p->getGlobalPrefix() . '/gvdb');
define("GLIB_PREFIX", $p->getGlobalPrefix() . '/glib');
define("LIBSOUP_PREFIX", $p->getGlobalPrefix() . '/libsoup');
define("LIBPSL_PREFIX", $p->getGlobalPrefix() . '/libpsl');
define("LIBBSD_PREFIX", $p->getGlobalPrefix() . '/libbsd');
define("LIBMD_PREFIX", $p->getGlobalPrefix() . '/libmd');
define("PGSQL_LATEST_PREFIX", $p->getGlobalPrefix() . '/pgsql_latest');
define("OSSP_UUID_PREFIX", $p->getGlobalPrefix() . '/ossp_uuid');
define("PROXYCHAINS_PREFIX", $p->getGlobalPrefix() . '/proxychains');
define("UNBOUND_PREFIX", $p->getGlobalPrefix() . '/unbound');
define("LIBXDP_PREFIX", $p->getGlobalPrefix() . '/libxdp');
define("CPU_FEATURES_PREFIX", $p->getGlobalPrefix() . '/cpu_features');
define("OPENEXR_PREFIX", $p->getGlobalPrefix() . '/openexr');
define("OPENJPEG_PREFIX", $p->getGlobalPrefix() . '/openjpeg');
define("OPENBLAS_PREFIX", $p->getGlobalPrefix() . '/openblas');
define("LAPACK_PREFIX", $p->getGlobalPrefix() . '/lapack');
define("RISCV_PREFIX", $p->getGlobalPrefix() . '/riscv');
define("IMATH_PREFIX", $p->getGlobalPrefix() . '/imath');
define("LIBEIGEN_PREFIX", $p->getGlobalPrefix() . '/libeigen');
define("LIBOSMESA_PREFIX", $p->getGlobalPrefix() . '/libosmesa');
define("WAYLAND_PREFIX", $p->getGlobalPrefix() . '/wayland');
define("WAYLAND_PROTOCOLS_PREFIX", $p->getGlobalPrefix() . '/wayland_protocols');
define("OPENLDAP_PREFIX", $p->getGlobalPrefix() . '/openldap');
define("LIBPAM_PREFIX", $p->getGlobalPrefix() . '/libpam');
define("IDDAWC_PREFIX", $p->getGlobalPrefix() . '/iddawc');
define("LIBMNL_PREFIX", $p->getGlobalPrefix() . '/libmnl');
define("PROTOBUF_PREFIX", $p->getGlobalPrefix() . '/protobuf');
define("PROTOBUF_C_PREFIX", $p->getGlobalPrefix() . '/protobuf_c');
define("VLC_PREFIX", $p->getGlobalPrefix() . '/vlc');
define("LIBDC1394_PREFIX", $p->getGlobalPrefix() . '/libdc1394');
define("SUITESPARSE_PREFIX", $p->getGlobalPrefix() . '/suitesparse');
define("BLAS_PREFIX", $p->getGlobalPrefix() . '/blas');
define("MPFR_PREFIX", $p->getGlobalPrefix() . '/mpfr');
define("LIBVA_PREFIX", $p->getGlobalPrefix() . '/libva');
define("LIBMYSQLICLIENT_PREFIX", $p->getGlobalPrefix() . '/libmysqlclient');
define("LIBCEPH_PREFIX", $p->getGlobalPrefix() . '/libceph');
define("DAHDI_LINUX_PREFIX", $p->getGlobalPrefix() . '/dahdi_linux');
define("DAHDI_TOOLS_PREFIX", $p->getGlobalPrefix() . '/dahdi_tools');
define("ASTERISK_PREFIX", $p->getGlobalPrefix() . '/asterisk');
define("PJPROJECT_PREFIX", $p->getGlobalPrefix() . '/pjproject');
define("QEMU_PREFIX", $p->getGlobalPrefix() . '/qemu');

define("STRONGSWAN_PREFIX", $p->getGlobalPrefix() . '/strongswan');

define("MUSL_CROSS_MAKE_PREFIX", $p->getGlobalPrefix() . '/musl_cross_make');
define("MUSL_LIBC_PREFIX", $p->getGlobalPrefix() . '/musl_libc');


define("ABSL_PREFIX", $p->getGlobalPrefix() . '/absl');

define("GRPC_PREFIX", $p->getGlobalPrefix() . '/grpc');
define("RE2_PREFIX", $p->getGlobalPrefix() . '/re2');

define("GPAC_PREFIX", $p->getGlobalPrefix() . '/gpac');

define("SNDIO_AUDIO_PREFIX", $p->getGlobalPrefix() . '/sndio_audio');
define("JACK_AUDIO_PREFIX", $p->getGlobalPrefix() . '/jack_audio');
define("OPEN_SOUND_AUDIO_PREFIX", $p->getGlobalPrefix() . '/opensound_audio');
define("PULSE_AUDIO_PREFIX", $p->getGlobalPrefix() . '/pulse_audio');

define("V4L_UTILS_PREFIX", $p->getGlobalPrefix() . '/v4l_utils');
define("EXAMPLE_PREFIX", $p->getGlobalPrefix() . '/example');


