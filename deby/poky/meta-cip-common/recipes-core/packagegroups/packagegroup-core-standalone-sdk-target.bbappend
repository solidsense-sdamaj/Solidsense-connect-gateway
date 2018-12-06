# Copyright (C) 2016-2018, TOSHIBA Corp., Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
# SPDX-License-Identifier:	MIT

RDEPENDS_${PN} += "linux-libc-headers-base-dev"
RDEPENDS_${PN} += "kernel-dev"
RDEPENDS_${PN} += "libc6-dev"
# Add required packages for toolchain
RDEPENDS_${PN} += "openssh-dev"
