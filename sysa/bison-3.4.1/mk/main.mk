# SPDX-FileCopyrightText: 2020 Giovanni Mascellani gio@debian.org
# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>
#
# SPDX-License-Identifier: GPL-3.0-or-later

CC=tcc
AR="tcc -ar"

all: bison

bison: src.a lib.a
	$(CC) $(CFLAGS) -g -o $@ $^

%.a: FORCE
	set -e ;\
	DIR=$(basename $@ .a) ;\
	$(MAKE) CC=$(CC) AR=$(AR) CFLAGS=$(CGLAGS) -C $$DIR $@ ;\
	cp $$DIR/$@ $@

FORCE:

install:
	install bison $(PREFIX)/bin
	rm -rf $(PREFIX)/share/bison
	install -d $(PREFIX)/share/bison
	mv data/skeletons/ $(PREFIX)/share/bison
	mv data/m4sugar/ $(PREFIX)/share/bison
