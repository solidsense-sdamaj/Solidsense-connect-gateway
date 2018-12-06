# Copyright (C) 2016-2018, TOSHIBA Corp., Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
# SPDX-License-Identifier:	MIT

# Adjustments for the ramdisk to work
create_init_link() {
       ln -s /sbin/init ${IMAGE_ROOTFS}/init
       rm ${IMAGE_ROOTFS}/linuxrc
       ln -s /bin/busybox ${IMAGE_ROOTFS}/linuxrc
}
ROOTFS_POSTPROCESS_COMMAND += "create_init_link;"

# modify PS1 to something easy to recognize by LAVA (cip-project# or cip-project$)
setup_prompt() {
	sed -i 's/PS1='\''# '\''/PS1='\''cip-project# '\''/g' ${IMAGE_ROOTFS}/etc/profile
	sed -i 's/PS1='\''\$ '\''/PS1='\''cip-project\$ '\''/g' ${IMAGE_ROOTFS}/etc/profile
}
ROOTFS_POSTPROCESS_COMMAND += "setup_prompt;"

# Remove Linux images from rootfs to save space
remove_boot() {
	rm -rf ${IMAGE_ROOTFS}/boot/*
}
IMAGE_POSTPROCESS_COMMAND += "remove_boot;"
