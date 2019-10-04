# Fix checksum
# The LIC_FILES_CHKSUM does not match for
# file:///home/eric/work/Solidrun/solidsense/cip-project/deby/poky/poky/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690
# init-files: The new md5 checksum is b97a012949927931feb7793eee5ed924

LIC_FILES_CHKSUM = " \
    file://${COREBASE}/LICENSE;md5=b97a012949927931feb7793eee5ed924 \
"

do_install_append () {
    rm -f ${D}${sysconfdir}/network/interfaces
    rm -f ${D}${sysconfdir}/fstab
}
