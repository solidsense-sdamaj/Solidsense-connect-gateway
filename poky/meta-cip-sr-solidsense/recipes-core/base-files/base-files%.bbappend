# Fix file conflicts
# 
#   file /var/log conflicts between attempted installs of systemd-1:241+0+c1f8ff8d0d-r0.cortexa9_vfp and base-files-3.0.14-r89.solidsense

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
   file://fstab \
"

do_install_append () {
    # Remove /var/log
    rm -f ${D}${localstatedir}/log
}
