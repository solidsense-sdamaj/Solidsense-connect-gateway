DESCRIPTION = "Sodira openvpn"
LICENSE = "MIT"
LIC_FILES_CHKSUM = " \
    file://../sodira_license.txt;md5=cfc9efaf1a28b6b60fc85db731edea1e \ 
"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
    file://sodira_license.txt \
    file://client.conf \
"

SODIRA_DIR = "/data/openvpn"
ETC_DIR = "/etc/openvpn"
do_install () {
    install -d ${D}${ETC_DIR}
    install -d ${D}${SODIRA_DIR}
    install -m 0644 ${WORKDIR}/sodira_license.txt ${D}${SODIRA_DIR}/sodira_license.txt
    install -m 0644 ${WORKDIR}/client.conf ${D}${SODIRA_DIR}/client.conf
    ln -s ${SODIRA_DIR}/client.conf ${D}${ETC_DIR}/client.conf
}

FILES_${PN} = " \
  /data \
  /data/openvpn \
  /data/openvpn/client.conf \
  /data/sodira/sodira_license.txt \
  /etc  \
  /etc/openvpn \
"
