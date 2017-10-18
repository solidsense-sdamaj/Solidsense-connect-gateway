# Copyright (C) 2016-2017, TOSHIBA Corp., Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
# SPDX-License-Identifier:	MIT

RDEPENDS_${PN} += "kernel-image"
RDEPENDS_${PN} += "kernel-modules"
# Add required packages for rootfs here
RDEPENDS_${PN} += "openssh-server"

