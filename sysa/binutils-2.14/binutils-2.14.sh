# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>
# SPDX-FileCopyrightText: 2021 Paul Dersey <pdersey@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

src_prepare() {
    default_src_prepare

    rm configure
    autoconf-2.13
    for dir in binutils bfd gas ld gprof libiberty opcodes; do
        cd $dir
        rm configure
        autoconf-2.13
        cd ..
    done
    for dir in etc intl; do
        cd $dir
        rm configure
        autoconf-2.12
        cd ..
    done

    # automake errors out without this
    cd gas
    mv config/m68k-parse.y .
    sed -i 's#config/m68k-parse.y#m68k-parse.y#' Makefile.am
    cd ..

    # Disable documentation build which needs pod2man
    for dir in bfd binutils gas gprof ld opcodes; do
        cd $dir
        sed -i '/SUBDIRS/d' Makefile.am
        rm Makefile.in
        automake-1.4
        cd ..
    done

    # Rebuild bison files
    touch */*.y
    rm ld/ldgram.c ld/ldgram.h
    rm gas/itbl-parse.c gas/itbl-parse.h
    rm gas/m68k-parse.c
    rm binutils/arparse.c binutils/arparse.h
    rm binutils/nlmheader.c binutils/nlmheader.h
    rm binutils/sysinfo.c binutils/sysinfo.h
    rm binutils/defparse.c binutils/defparse.h
    rm binutils/rcparse.c binutils/rcparse.h

    # Rebuild flex generated files
    touch */*.l
    rm ld/ldlex.c
    rm gas/itbl-lex.c
    rm binutils/syslex.c binutils/rclex.c binutils/deflex.c binutils/arlex.c
}

src_configure() {
    AR="tcc -ar" RANLIB="true" CC="tcc -D __GLIBC_MINOR__=6" \
        ./configure \
        --disable-nls \
        --disable-shared \
        --disable-werror \
        --build=i386-unknown-linux \
        --host=i386-unknown-linux \
        --target=i386-unknown-linux \
        --with-sysroot=/after \
        --disable-64-bit-bfd \
        --prefix="${PREFIX}" \
        --libdir="${PREFIX}/lib/musl"

    # TODO: Find a way to avoid these hacks
    sed -i '/#undef pid_t/d' libiberty/config.in
    sed -i '/#undef uintptr_t/d' libiberty/config.in
    sed -i 's/C_alloca/alloca/g' libiberty/alloca.c
    sed -i 's/C_alloca/alloca/g' include/libiberty.h
}

src_compile() {
    # Rebuild generated header files. bfd/Makefile does not exists at this stage,
    # so we need to create it first.
    make configure-bfd
    make -C bfd headers

    default_src_compile
}
