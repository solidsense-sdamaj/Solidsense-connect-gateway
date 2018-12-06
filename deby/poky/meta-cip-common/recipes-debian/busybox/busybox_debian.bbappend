# Copyright (C) 2016-2018, TOSHIBA Corp., Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
# SPDX-License-Identifier:	MIT
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Note: inittab and rcS also overwrite the original ones.
SRC_URI_append += " \
	file://rcE \
	"

do_install_append () {
	if [ "${VIRTUAL-RUNTIME_init_manager}" = "busybox" ]; then
		install -m 0755 ${WORKDIR}/rcE ${D}${sysconfdir}/init.d
        fi
}
