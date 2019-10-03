FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://rndc.conf \
"

INITSCRIPT_PARAMS = "remove"

do_install_append () {
    rm -f ${D}${sysconfdir}/bind/rndc.conf
    install -d ${D}${sysconfdir}/bind
    install -m 0644 ${WORKDIR}/rndc.conf ${D}${sysconfdir}/bind/rndc.conf

    install -d ${D}/var/named
    ln -s /etc/bind/db.root ${D}/var/named/named.ca
    ln -s /etc/bind/zones.rfc1918 ${D}${sysconfdir}/named.rfc1912.zones
}

FILES_${PN} += " \
    /var/named/named.ca \
"
