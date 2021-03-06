# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>

# SPDX-License-Identifier: GPL-3.0-or-later

VERSION=5.005_03
PRIVLIB_EXP=$(PREFIX)/lib/perl5/$(VERSION)

CC      = tcc
CFLAGS  = -DPRIVLIB_EXP=\"$(PRIVLIB_EXP)\"

.PHONY: all

MINIPERL_SRC = av deb doio doop dump globals gv hv mg miniperlmain op perl perlio perly pp pp_ctl pp_hot pp_sys regcomp regexec run scope sv taint toke universal util
MINIPERL_OBJ = $(addsuffix .o, $(MINIPERL_SRC))

all: miniperl

miniperl: $(MINIPERL_OBJ)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

install: all
	install miniperl $(PREFIX)/bin/perl
	mkdir -p "$(PRIVLIB_EXP)"
	cp -r lib/* "$(PRIVLIB_EXP)"
