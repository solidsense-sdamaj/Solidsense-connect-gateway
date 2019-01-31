# Copyright (C) 2016-2018, TOSHIBA Corp., Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
# SPDX-License-Identifier:	MIT

LICENSE = "MIT"
LIC_FILES_CHKSUM = " \
file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690 \
file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420 \
"

PR = "r0"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
S = "${WORKDIR}"

SRC_URI += "file://fstab.base"
install_fstab() {
	install -d ${D}/${sysconfdir}
	install -m 0644 ${WORKDIR}/fstab.base ${D}/${sysconfdir}/fstab
}

SRC_URI += "file://interfaces"
install_interfaces () {
        install -d ${D}${sysconfdir}/network
        install -m 0644 ${WORKDIR}/interfaces ${D}${sysconfdir}/network/interfaces
}

do_configure() {
	:
}

do_compile() {
	:
}

do_install() {
	install_fstab
	install_interfaces
	ln -s /proc/mounts ${D}/${sysconfdir}/mtab
}
