# Copyright (C) 2016-2017, TOSHIBA Corp., Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
# SPDX-License-Identifier:	MIT

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# no defconfig, use a full config in the local directory
LINUX_DEFCONFIG = ""
# Put your kenrel config under files directory.
SRC_URI += "file://default.config"
