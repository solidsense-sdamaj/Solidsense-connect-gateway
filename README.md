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
Make sure that your docker is using the overlay2 storage driver and
your host kernel supports overlayfs.


```shell
host$ docker run -v $PWD/deby:/deby -e USER_ID=`id -u $USER` -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e NO_PROXY="$no_proxy" -it kasproject/kas sh
docker$ cd /deby/poky/
```

To build the file system image use the corresponding kas project file. 
For example, in case of the iWave RZ/G1M Qseven Development Kit:

```shell
docker$ kas build --target core-image-minimal meta-cip-iwg20m/kas-iwg20m.yml
```

For more detailed, instructions check the README file inside the
corresponding `deby/poky/meta-cip-<board>` folder.

Build solidsense images
-----------------------
=> To create your solidsense-connect environnement, follow these steps:

* create this path folder on your workspace: ~/solidsense-connect/bin/
* install mender-artifact binary from https://mender.io (version 3.5.1) and put it in ~/solidsense-connect/bin/
* create this path in your workspace: ~/solidsense-connect/signing-private-keys
* generate private.key and public.key by following: mender doc https://docs.mender.io/development/artifact-creation/sign-and-verify
* copy the generated keys in ~/solidsense-connect/signing-private-keys
* clone the repo solidsense-connect-gateway from https://github.com/solidsense-connect/Solidsense-connect-gateway.git, branch meta-solidsense-products-sr:

 ```shell
git clone https://github.com/solidsense-connect/Solidsense-connect-gateway.git --branch meta-solidsense-products-sr
```
* from poky directory, clone the meta-cip-sr-common who contains specific files, scripts, kas and yaml files.
 ```shell
git clone https://github.com/solidsense-connect/meta-cip-sr-common.git
```
* create a new folder mender-cert in poky/meta-cip-sr-common
* copy and rename the generated public.key ~/solidsense-connect/signing-private-keys to meta-cip-sr-common/mender-cert/artifact-verify-key.pem

=> Install librairies and apps:

Preference to use Ubuntu 20.4 or Debian 10 equivalent to build images:
* for Ubuntu 20.4:
 ```shell
sudo apt update
sudo apt install chrpath diffstat python2 python2.7 unzip texinfo default-jdk python3-pip
pip3 install kas==2.5
 ```
 * for Debian 10:
 ```shell
sudo apt update
sudo apt install chrpath diffstat texinfo openjdk-11-jdk gawk python3-pip
pip3 install kas==2.5
 ```

=> To build your solidsense-connect images for all or a specific product:

* build images from poky directory to generate images by using: meta-cip-sr-common/scripts/build

 ```shell
sdamaj@sdamaj:~/Solidsense-connect-gateway/poky$ meta-cip-sr-common/scripts/build -h
build:
    -H|--hardware <hardware type>                 :default is <all>
    -p|--product <product>                        :default is <Solidsense>
    -r|--release <release version>                :default is <dev>
    -d|--date <date>                              :default is <20220330>
    -D|--docker                                   :default is to not use docker
    -i|--iteration <iteration>                    :default is <00>
    -v|--variant <variant>                        :default is no specific variant
    -c|--config <config>                          :default is <meta-cip-sr-common/scripts/build.conf>
    -C|--clean-meta                               :default is to not remove extra meta-* directories
    -u|--usb-image                                :default is to not build bootable usb/sd images to flash eMMC
                                                   This option will enforce building of all images
    -h|--help

```

* to build an image for N8 indoor, you can specify the N8 hardware imx8mnc:
 ```shell
 sdamaj@sdamaj:~/Solidsense-connect-gateway/poky$ ./meta-cip-sr-common/scripts/build -H imx8mnc
 ```

* to build an image for N6 indoor/outdoor, you can specify the N6 hardware n6gsdl:
 ```shell
 sdamaj@sdamaj:~/Solidsense-connect-gateway/poky$ ./meta-cip-sr-common/scripts/build -H n6gsdl
 ```
* to build an image for industrial N6, you can specify the N6 hardware in6gsdl:
 ```shell
 sdamaj@sdamaj:~/Solidsense-connect-gateway/poky$ ./meta-cip-sr-common/scripts/build -H in6gsdl
```

* to build images for all solidsense families (default is all):
 ```shell
 sdamaj@sdamaj:~/Solidsense-connect-gateway/poky$ ./meta-cip-sr-common/scripts/build
```

=> Solidsense-connect N6 Boards:
* N6 indoor		: n6gq n6gsdl
* N6 outdoor	: n6gq n6gsdl
* N6 industrial	: in6gq in6gsdl 

=> Solidsense-connect N8 Boards:
* N8 indoor		: imx8mnc
* N8 outdoor 	: coming soon
* N8 industrial	: BOM in progress

=> Images Ready-To-Use from Solidsense-Connect mender:
* `unsigned images`: https://images.solidsense.io/SolidSense/mender/SolidRun-unsigned/index.html
* `signed images`: https://images.solidsense.io/SolidSense/mender/SolidRun-signed/index.html

=> Last images:
* `Solidsense-connect N6 indoor/outdoor`: n6gsdl-core-image-minimal-Solidsense-2.0-2021122000.mender
* `Solidsense-connect insdustrial N6`: in6gsdl-core-image-minimal-Solidsense-2.0-2021122000.mender
* `Solidsense-connect N8 family`: imx8mnc-core-image-minimal-Solidsense-2.0-2021122000.mender

=> Firmware content:
* Kernel 5.4.47
* Wi-Fi Boradcom Combo: Wifi / BLE
* wpa_supplicant v2.7
* Sink Nordic: Wirepas 5.1, BLE v1.8.1
* Kura 5.0.1
* Mqtt/Kapua
* Java JDK11
* Python v3.7
* Mender v2.6
* Docker v18.09.3

