# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>
#
# SPDX-License-Identifier: GPL-3.0-or-later

src_prepare() {
    default_src_prepare

    # tcc does not support complex types
    rm -rf src/complex

    # Configure fails without this
    mkdir -p /dev
}

src_configure() {
    CC=tcc ./configure \
      --host=i386 \
      --disable-shared \
      --prefix=/after \
      --libdir=/after/lib/musl/ \
      --includedir=/after/include/musl

    # configure script creates this file
    test -f /dev/null && rm /dev/null
}

src_compile() {
    make CROSS_COMPILE= AR="tcc -ar" RANLIB=true CFLAGS="-DSYSCALL_NO_TLS"
}
