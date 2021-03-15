#!/bin/bash

# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>
# SPDX-FileCopyrightText: 2021 fosslinux <fosslinux@aussies.space>
# SPDX-FileCopyrightText: 2021 Paul Dersey <pdersey@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e
. helpers.sh

build automake-1.5 stage1.sh
build automake-1.5 stage2.sh

echo "Bootstrapping completed."

exec env - PATH=/after/bin PS1="\w # " bash -i