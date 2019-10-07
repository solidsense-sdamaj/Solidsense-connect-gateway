SUMMARY = "Wirepas Mesh - IoT network with unprecedented scale, density, flexibility and reliability"
HOMEPAGE = "https://github.com/wirepas/gateway"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=b8b4f77337154d1f64ebe68dcd93fab6"

PYPI_PACKAGE = "wirepas_gateway"

SRC_URI = " \
    file://LICENSE \
    file://com.wirepas.sink.conf \
    file://configure_node.py \
    file://grpc.tar.gz \
    file://sinkService \
    file://wirepasMicro.service \
    file://wirepasSink1.service \
    file://wirepasSink2.service \
    file://wirepasSinkConfig.service \
    file://wirepasTransport1.service \
    file://wirepasTransport2.service \
    file://wirepas_gateway-1.1.0-py3-none-any.whl \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS = " \
    python3-native \
    python3-pip-native \
"
RDEPENDS_${PN} = " \
    openocd \
    python3 \
    python3-grpcio \
    python3-grpcio-tools \
    python3-paho-mqtt \
    python3-pydbus \
    python3-pyyaml \
    systemd \
    wirepas-messaging \
"

SYSTEMD_SERVICE_${PN} = "wirepasSink1.service wirepasSink2.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

inherit python3native python3-dir setuptools3 systemd

do_configure () {
}

do_compile () {
}

do_install () {
    ${STAGING_BINDIR_NATIVE}/pip3 install ${WORKDIR}/wirepas_gateway-1.1.0-py3-none-any.whl
}

do_install_append () {
    # Install the require grpc
    install -d ${D}/data/solidsense/grpc
    cp -a ${WORKDIR}/grpc/* ${D}/data/solidsense/grpc
    chown -R root:root ${D}/data/solidsense/grpc

    install -d ${D}/data/solidsense/wirepas
    install -m 0755 ${WORKDIR}/sinkService ${D}/data/solidsense/wirepas/sinkService
    install -m 0644 ${WORKDIR}/configure_node.py ${D}/data/solidsense/wirepas/configure_node.py
    install -d ${D}${sysconfdir}/dbus-1/system.d
    install -m 0644 ${WORKDIR}/com.wirepas.sink.conf ${D}${sysconfdir}/dbus-1/system.d/com.wirepas.sink.conf

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wirepasMicro.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wirepasSink1.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wirepasSink2.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wirepasSinkConfig.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wirepasTransport1.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wirepasTransport2.service ${D}${systemd_unitdir}/system
    sed -i -e 's,@SBINDIR@,${sbindir},g' \
        -e 's,@SYSCONFDIR@,${sysconfdir},g' \
        ${D}${systemd_unitdir}/system/wirepasMicro.service
    sed -i -e 's,@SBINDIR@,${sbindir},g' \
        -e 's,@SYSCONFDIR@,${sysconfdir},g' \
        ${D}${systemd_unitdir}/system/wirepasSink1.service
    sed -i -e 's,@SBINDIR@,${sbindir},g' \
        -e 's,@SYSCONFDIR@,${sysconfdir},g' \
        ${D}${systemd_unitdir}/system/wirepasSink2.service
    sed -i -e 's,@SBINDIR@,${sbindir},g' \
        -e 's,@SYSCONFDIR@,${sysconfdir},g' \
        ${D}${systemd_unitdir}/system/wirepasSinkConfig.service
    sed -i -e 's,@SBINDIR@,${sbindir},g' \
        -e 's,@SYSCONFDIR@,${sysconfdir},g' \
        ${D}${systemd_unitdir}/system/wirepasTransport1.service
    sed -i -e 's,@SBINDIR@,${sbindir},g' \
        -e 's,@SYSCONFDIR@,${sysconfdir},g' \
        ${D}${systemd_unitdir}/system/wirepasTransport2.service
}

FILES_${PN} = " \
    /etc \
    /data/solidsense/grpc \
    /data/solidsense/grpc/grpc_service.proto \
    /data/solidsense/grpc/grpc_service_pb2.py \
    /data/solidsense/grpc/argument_tools.py \
    /data/solidsense/grpc/grpc_service_pb2_grpc.py \
    /data/solidsense/grpc/client_demo.py \
    /data/solidsense/grpc/grpc_service.py \
    /data/solidsense/wirepas/sinkService \
    /data/solidsense/wirepas/configure_node.py \
    /lib/systemd/system/wirepasSinkConfig.service \
    /lib/systemd/system/wirepasTransport2.service \
    /lib/systemd/system/wirepasTransport1.service \
    /lib/systemd/system/wirepasMicro.service \
    /etc/dbus-1 \
    /etc/dbus-1/system.d \
    /etc/dbus-1/system.d/com.wirepas.sink.conf \
"
