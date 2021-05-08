#!/bin/bash 

apt-get -qq update
apt-get -qq install build-essential bzip2 gawk gettext git patch unzip htop wget curl -y
apt-get -qq install iproute2 ntpdate make tcpdump telnet traceroute nfs-kernel-server nfs-common lrzsz tree openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev gcc iotop unzip zip libreadline-dev libsystemd-dev -y
apt-get -qq autoremove --purge


FILE_DIR="/tmp"
HAPROXY_PKG="haproxy-2.3.10.tar.gz"
HAPROXY_DIR="haproxy-2.3.10"
HAPROXY_VER="2.3.10"
LUA_PKG="lua-5.4.3.tar.gz"
LUA_DIR="lua-5.4.3"
LUA_WGET="http://www.lua.org/ftp/lua-5.4.3.tar.gz"
HAPROXY_WGET="https://www.haproxy.org/download/2.3/src/haproxy-2.3.10.tar.gz"
PCRE2_WGET="https://ftp.pcre.org/pub/pcre/pcre2-10.36.tar.gz"
PCRE2_PKG="pcre2-10.36.tar.gz"
PCRE2_DIR="pcre2-10.36"
OPENSSL_WGET="https://www.openssl.org/source/openssl-1.1.1k.tar.gz"
OPENSSL_DPKG="openssl-1.1.1k.tar.gz"
OPENSSL_DIR="openssl-1.1.1k"
SLZ_WGET="http://git.1wt.eu/web?p=libslz.git;a=snapshot;h=ff537154e7f5f2fffdbef1cd8c52b564c1b00067;sf=tgz"
SLZ_DIR="libslz"
SLZ_PKG="libslz.tar.gz"
#SLZ
cd ${FILE_DIR}  && wget -O ${SLZ_PKG} ${SLZ_WGET} && tar xvf ${SLZ_PKG} && cd ${SLZ_DIR} && make
#PCRE2
cd ${FILE_DIR}  && wget -O ${PCRE2_PKG} ${PCRE2_WGET} && tar xvf ${PCRE2_PKG} && cd ${PCRE2_DIR} && ./configure --prefix=/usr --docdir=/usr/share/doc/pcre2-10.36 --enable-unicode --enable-jit --enable-pcre2-16 --enable-pcre2-32 --enable-pcre2grep-libz --enable-pcre2grep-libbz2 --enable-pcre2test-libreadline --enable-static && make && make install
#OPENSL
cd ${FILE_DIR}  && wget -O ${OPENSSL_DPKG} ${OPENSSL_WGET} && tar xvf ${OPENSSL_DPKG} && cd ${OPENSSL_DIR} && export STATICLIBSSL=/tmp/${OPENSSL_DIR}  ./config --prefix=/usr/local/openssl no-shared && make && make install_sw
#lua
cd ${FILE_DIR}  && wget -O ${LUA_PKG} ${LUA_WGET} && tar xvf ${LUA_PKG} && cd ${LUA_DIR} && make linux
#haproxy
cd ${FILE_DIR} && wget -O ${HAPROXY_PKG} ${HAPROXY_WGET} && tar xvf ${HAPROXY_PKG} && cd ${HAPROXY_DIR}

#make
#make ARCH=x86_64 TARGET=linux-glibc USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_SYSTEMD=1 USE_CPU_AFFINITY=1 USE_LUA=1 LUA_INC=/tmp/lua-5.3.6/src/ LUA_LIB=/tmp/lua-5.3.6/src/ PREFIX=/apps/haproxy

make ARCH=x86_64 TARGET=linux-glibc USE_GETADDRINFO=1 USE_OPENSSL=1 SSL_INC=/usr/local/openssl/include SSL_LIB=/usr/local/openssl/lib ADDLIB=-lz USE_ZLIB=1 USE_SYSTEMD=1 USE_CPU_AFFINITY=1 USE_TFO=1 USE_THREAD=1 USE_NS=1 USE_CRYPT_H=1 USE_LIBCRYPT=1 USE_LUA=1 LUA_INC=/tmp/lua-5.4.3/src/ LUA_LIB=/tmp/lua-5.4.3/src/ USE_STATIC_PCRE2=1 PCRE2_INC=/usr/ PCRE2_LIB=/usr/
