SUMMARY = "Kura"
DESCRIPTION = "Kura"
LICENSE = "epl-v10"
LIC_FILES_CHKSUM = " \
    file://kura_${PV}_raspberry-pi-2/epl-v10.html;md5=d0fc088e4e5216422c217d39853d8601 \
"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
    git://github.com/SolidRun/SolidSense-V1.git;protocol=ssh \
    file://kura_${PV}_raspberry-pi-2-3_installer.deb \
    file://kura.service \
    file://start_kura_background.sh \
    file://iptables \
    file://ip6tables \
    file://krc.sh \
    file://log4j.xml \
"
SRCREV = "98a3331932752cadafa34d1e6ff84873f0c14ac0"

SYSTEMD_SERVICE_${PN} = "kura.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

INSANE_SKIP_${PN} = "ldflags"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

DEPENDS_${PN} = " \
"
RDEPENDS_${PN} = " \
    openjdk-8 \
    python3 \
"

inherit systemd

do_compile () {
    cd ${S}
    unzip ${WORKDIR}/tmp/kura_${PV}_raspberry-pi-2.zip
}

do_install () {
    install -d ${D}/opt/eclipse/kura_${PV}_solid_sense
    ln -s /opt/eclipse/kura_4.1.0_solid_sense ${D}/opt/eclipse/kura
    cp -arP ${S}/kura_${PV}_raspberry-pi-2 ${D}/opt/eclipse/kura_${PV}_solid_sense

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/kura.service ${D}${systemd_unitdir}/system
    sed -i -e 's,@SBINDIR@,${sbindir},g' \
        -e 's,@SYSCONFDIR@,${sysconfdir},g' \
        ${D}${systemd_unitdir}/system/kura.service

    # Install updated startup script
    install -d ${D}/opt/eclipse/kura_${PV}_solid_sense/bin
    install -m 0755 ${WORKDIR}/start_kura_background.sh ${D}/opt/eclipse/kura_${PV}_solid_sense/bin/start_kura_background.sh

    # Install firewall rules
    install -d ${D}/opt/eclipse/kura_${PV}_solid_sense/.data
    install -m 0644 ${WORKDIR}/iptables ${D}/opt/eclipse/kura_${PV}_solid_sense/.data/iptables
    install -m 0644 ${WORKDIR}/ip6tables ${D}/opt/eclipse/kura_${PV}_solid_sense/.data/ip6tables

    # Install shell script to assist with running cli command via Kura/Kapua
    install -d ${D}${base_bindir}
    install -m 0755 ${WORKDIR}/krc.sh ${D}${base_bindir}/krc

    # Install updated logging config
    install -d ${D}/opt/eclipse/kura_${PV}_solid_sense/user
    install -m 0644 ${WORKDIR}/log4j.xml ${D}/opt/eclipse/kura_${PV}_solid_sense/user/log4j.xml

    # Install SolidSense configuration scripts/data
    cp -arP ${WORKDIR}/git/Kura/Config/* ${D}/opt/SolidSense/kura/config/

    chown -R root:root ${D}/opt
}

FILES_${PN} = " \
  /bin/krc \
"
