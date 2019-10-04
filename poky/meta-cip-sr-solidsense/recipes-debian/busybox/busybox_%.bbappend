SRC_URI += "file://fragment.cfg;subdir=busybox-1.30.1"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SYSTEMD_SERVICE_${PN}-syslog = ""
