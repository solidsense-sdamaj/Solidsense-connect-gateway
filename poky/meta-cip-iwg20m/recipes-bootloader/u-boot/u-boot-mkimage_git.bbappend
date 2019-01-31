LIC_FILES_CHKSUM = "file://COPYING;md5=1707d6db1d42237583f50183a5651ecb"

do_compile () {
	oe_runmake tools
}

INSANE_SKIP_${PN} = "already-stripped"

