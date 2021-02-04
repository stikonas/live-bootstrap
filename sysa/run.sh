#!/bin/bash

# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>
# SPDX-License-Identifier: GPL-3.0-or-later

set -e
# shellcheck source=sysa/helpers.sh
. helpers.sh

export PREFIX=/after

# Part 21
build m4-1.4.4

# Part 22
build flex-2.5.11

# Part 23
build musl-1.1.24

# Part 24
build tcc-0.9.27 tcc-musl.sh

# Part 25
build flex-2.6.4

echo "Bootstrapping completed."
