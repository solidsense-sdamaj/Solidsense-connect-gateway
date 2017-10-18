README
======

Overview
--------

This folder contains the Deby-based reference implementation of the
CIP Core project for multiple boards. Deby is a reference distribution 
built with poky and meta-debian, a layer for the poky build system that 
allows cross-building file system images from Debian stable source 
packages.

Goal
  * Input: Debian and CIP kernel source code
  * Build mechanism: bitbake with meta-debian
  * Output: Minimum deployable CIP base system

Supported boards
----------------

The list of supported boards for a specific version can be obtained by 
using `ls deby/poky/meta-cip-*`.

Currently, the following boards are supported:
  * iWave RZ/G1M Qseven Development Kit
  * Beaglebone Black
  * DE0-Nano-SoC Kit/Atlas-SoC Kit
  * QEMU x86_64

Generic build instructions
--------------------------

To build the file system image for a specific board you need to
prepare a [KAS](https://github.com/siemens/kas) docker environment.
One you have the environment ready run a KAS container and build
the image using its corresponding KAS project file.

For example, in case of iWave RZ/G1M Qseven Development Kit:

```shell
host$ docker run -v $PWD/cip-core:/cip-core -e USER_ID=`id -u $USER` -e http_proxy=$http_proxy -e https_proxy=$https_proxy -it kas sh
docker$ cd /cip-core/deby/poky/
docker$ kas build --target core-image-minimal meta-cip-iwg20m/kas-iwg20m.yml
```

For more detailed, instructions check the README file inside the
corresponding `deby/poky/meta-cip-<board>` folder.

