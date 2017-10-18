FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# LINUX_DEFCONFIG must be defined in machine config
SRC_URI += "file://common.config"
