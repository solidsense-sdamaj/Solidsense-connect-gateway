CIP core: Instructions for QEMU x86_64
2017 (c) Toshiba corp.
author: <daniel.sangorrin@toshiba.co.jp>
-------------------------------------------------------------------------------

Build the binaries
==================

Build using KAS:
    host$ docker run -v $PWD/cip-core:/cip-core -e USER_ID=`id -u $USER` -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e NO_PROXY="$no_proxy" -it kasproject/kas:0.13.0 sh
    docker$ cd /cip-core/deby/poky/
    docker$ kas build --target core-image-minimal meta-cip-qemux86-64/kas-qemux86-64.yml

Test the image
==============

$ runqemu qemux86-64 nographic

