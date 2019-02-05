CIP core: Instructions for QEMU x86_64
2017 (c) Toshiba corp.
author: <daniel.sangorrin@toshiba.co.jp>
-------------------------------------------------------------------------------

Build the binaries
==================

Build using KAS:
    host$ git clone https://gitlab.com/cip-project/cip-core/deby.git
    host$ docker run -v $PWD/deby:/deby -e USER_ID=`id -u $USER` -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e NO_PROXY="$no_proxy" -it kasproject/kas:0.13.0 sh
    docker$ cd /deby/poky/
    docker$ kas build --target core-image-minimal meta-cip-qemux86-64/kas-qemux86-64.yml
    [Note] To build the toolchain/SDK use "meta-toolchain" as a target

Test the image
==============

Using runqemu:
    [Note] make sure that your KAS docker image includes /sbin/ip
    [Opt] host$ sudo modprobe tun
    host$ docker run -v /dev/net/tun:/dev/net/tun -v $PWD/deby:/deby -e USER_ID=`id -u $USER` -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e NO_PROXY="$no_proxy" -it kasproject/kas:0.13.0 sh
    docker$ cd /deby/poky/
    docker$ kas shell --target core-image-minimal meta-cip-qemux86-64/kas-qemux86-64.yml
    docker$ runqemu qemux86-64 nographic slirp

Manually calling qemu
    host$ cd deby/poky/build/tmp/deploy/images/qemux86-64/
    host$ qemu-system-x86_64 -m 2G -kernel bzImage --device ide-hd,drive=mydisk --blockdev driver=raw,node-name=mydisk,file.driver=file,file.filename=./core-image-minimal-qemux86-64.ext4 -append "root=/dev/sda rw console=ttyS0" -nographic
    [Alt] Using the deprecated -hda option:
        host$ qemu-system-x86_64 -kernel bzImage -hda core-image-minimal-qemux86-64.ext4 -append "root=/dev/sda rw console=ttyS0" -nographic
