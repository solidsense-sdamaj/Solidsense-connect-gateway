# Fix file conflicts
# 
#   file /var/log conflicts between attempted installs of systemd-1:241+0+c1f8ff8d0d-r0.cortexa9_vfp and base-files-3.0.14-r89.solidsense
#   file /etc/fstab conflicts between attempted installs of init-files-1.0-r0.cortexa9_vfp and base-files-3.0.14-r89.solidsense

do_install_append () {
    rm -f ${D}${sysconfdir}/fstab
    rm -f ${D}${localstatedir}/log
}
