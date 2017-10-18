# Copyright (C) 2016-2017, TOSHIBA Corp., Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
# SPDX-License-Identifier:	MIT

#
# Misc
#
setup_misc() {
	# add mdev because when using a ramdisk dev is not populated properly
	echo "echo /sbin/mdev > /proc/sys/kernel/hotplug" >> ${IMAGE_ROOTFS}/etc/init.d/rcS
	echo "mdev -s" >> ${IMAGE_ROOTFS}/etc/init.d/rcS
	# modify PS1 to something easy to recognize by LAVA (cip# or cip$)
	sed -i 's/PS1='\''# '\''/PS1='\''cip# '\''/g' ${IMAGE_ROOTFS}/etc/profile
	sed -i 's/PS1='\''\$ '\''/PS1='\''cip\$ '\''/g' ${IMAGE_ROOTFS}/etc/profile
}

# Setup misc files after package install
do_setup() {
	cd ${WORKDIR}/rootfs
	setup_misc
}

ROOTFS_POSTPROCESS_COMMAND += "do_setup;"

create_init_link() {
       # link for the initramdisk
       ln -s /sbin/init ${IMAGE_ROOTFS}/init
}

ROOTFS_POSTPROCESS_COMMAND += "create_init_link ;"

