# Copyright (C) 2016-2018, TOSHIBA Corp., Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
# SPDX-License-Identifier:	MIT
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# LINUX_DEFCONFIG must be defined in machine config
SRC_URI += "file://common.config"
