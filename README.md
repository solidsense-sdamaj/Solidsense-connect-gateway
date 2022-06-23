README
======

Overview
--------

This folder contains the Deby-based reference implementation of the
Solidsense Core project for multiple boards. Deby is a reference distribution
built with poky and meta-debian, a layer for the poky build system that 
allows cross-building file system images from Debian stable source 
packages.

Goal
  * Input: Debian and kernel source code
  * Build mechanism: bitbake with meta-debian
  * Output: deployable base system and performing the function of an IoT gateway for Wirepas, BLE, LTE and Wi-Fi.

Supported boards
----------------

The list of supported boards for a specific version can be obtained by 
using `ls deby/poky/meta-cip-*`.

Currently, the following boards are supported:
  * N6 indoor		: n6gq n6gsdl
  * N6 outdoor		: n6gq n6gsdl
  * N6 industrial	: in6gq in6gsdl
  * N8 indoor		: imx8mnc


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

=> Install required packages:
 `Preference to use Ubuntu 20.4 or Debian 10 equivalent to build images `

* for Ubuntu 20.4:
 ```shell
sudo apt update
sudo apt install chrpath diffstat python2.7 unzip texinfo libz-dev default-jdk python3-pip
pip3 install kas==2.5
 ```
 * for Debian 10:
 ```shell
sudo apt update
sudo apt install chrpath diffstat texinfo libz-dev openjdk-11-jdk gawk python3-pip
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

* Build configuration:
```shell
- Build Configuration:
- BB_VERSION           = "1.42.0"
- BUILD_SYS            = "x86_64-linux"
- NATIVELSBSTRING      = "universal"
- TARGET_SYS           = "aarch64-deby-linux"
- MACHINE              = "imx8mnc"
- DISTRO               = "deby"
- DISTRO_VERSION       = "10.0"
- TUNE_FEATURES        = "aarch64 cortexa53 crc"
- TARGET_FPU           = ""
- meta-cip-common      = "meta-solidsense-products-sr:bcfd22185ae4f32792b8c6a4b326319019528767"
- meta-cip-sr-common   = "master:df10d90d18f91c98112574ab2e83b4da03d33dea"
- meta-cip-sr-imx8mnc  = "meta-solidsense-products-sr:bcfd22185ae4f32792b8c6a4b326319019528767"
- meta-debian          = "patched-warrior:b65f27bf02273ec3f7304fa3c7a9901c725cc04d"
- meta-iot-cloud       = "patched-warrior:8d15403f169b80786e85b5695ee37073a39ed835"
- meta-java            = "patched-master-aarch64-fixes:61d0a138835f899fb99045eb6e6d493045bec950"
- meta-mender-core     = "patched-warrior:81a8eb0a6e279056b029657eeee5c662718a2668"
- meta-filesystems
- meta-networking
- meta-oe
- meta-python          = "warrior:a24acf94d48d635eca668ea34598c6e5c857e3f8"
- meta-readonly-rootfs-overlay = "master:c7b8a6fec1da23104299130f3ce17fea22dfda19"
- meta-virtualization  = "warrior:6961097ff660eb32860fcd4d8eb29405be4c6766"
- meta
- meta-poky            = "patched-warrior:e358fb931936d27225431fdd20948f73902687ca"
```

=> check logs:
You can check logs while building images:

```shell
 sdamaj@sdamaj:~/Solidsense-connect-gateway/poky$ tail -f deploy/logs/Solidsense-dev-yyyymmdd00/build-imx8mnc-yyyymmdd-hh\:mm
```

Solidsense images path
----------------------
After build, all images will be generated in Solidsense-connect-gateway/poky/deploy/Solidsense-{tag}-yyymmdd00:

```
-rw-r--r-- 1 sdamaj sdamaj     48608 May 24 15:30 imx6dl-hummingboard2-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     47914 May 24 15:30 imx6dl-solidsense-in6-a-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     47586 May 24 15:30 imx6dl-solidsense-in6-b-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     46407 May 24 15:30 imx6dl-solidsense-in6-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     49994 May 24 15:30 imx6q-hummingboard2-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     49151 May 24 15:30 imx6q-solidsense-in6-a-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     48823 May 24 15:30 imx6q-solidsense-in6-b-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     47644 May 24 15:30 imx6q-solidsense-in6-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     63064 May 24 15:30 imx8mnc-core-image-minimal-Solidsense-2.0.2-2022052400.manifest
-rw-r--r-- 1 sdamaj sdamaj     72564 May 24 15:30 imx8mnc-core-image-minimal-Solidsense-2.0.2-2022052400.manifest.lic
-rw------- 1 sdamaj sdamaj 442786816 May 24 15:30 imx8mnc-core-image-minimal-Solidsense-2.0.2-2022052400.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 May 24 15:30 imx8mnc-core-image-minimal-Solidsense-2.0.2-2022052400.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 442785792 May 24 15:30 imx8mnc-core-image-minimal-Solidsense-2.0.2-2022052400.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 418607742 May 24 15:30 imx8mnc-core-image-minimal-Solidsense-2.0.2-2022052400.tar.gz
-rw-r--r-- 1 sdamaj sdamaj     37242 May 24 15:30 imx8mn-compact.dtb
-rw-r--r-- 1 sdamaj sdamaj    166539 May 24 15:30 in6gq-core-image-minimal-Solidsense-2.0.2-2022052400.manifest
-rw-r--r-- 1 sdamaj sdamaj    185105 May 24 15:30 in6gq-core-image-minimal-Solidsense-2.0.2-2022052400.manifest.lic
-rw------- 1 sdamaj sdamaj 436619264 May 24 15:30 in6gq-core-image-minimal-Solidsense-2.0.2-2022052400.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 May 24 15:30 in6gq-core-image-minimal-Solidsense-2.0.2-2022052400.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 436618240 May 24 15:30 in6gq-core-image-minimal-Solidsense-2.0.2-2022052400.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 413005813 May 24 15:30 in6gq-core-image-minimal-Solidsense-2.0.2-2022052400.tar.gz
-rw-r--r-- 1 sdamaj sdamaj    170691 May 24 15:30 in6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.manifest
-rw-r--r-- 1 sdamaj sdamaj    189257 May 24 15:30 in6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.manifest.lic
-rw------- 1 sdamaj sdamaj 436619264 May 24 15:31 in6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 May 24 15:30 in6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 436618240 May 24 15:31 in6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 413010091 May 24 15:30 in6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.tar.gz
-rw-r--r-- 1 sdamaj sdamaj    164300 May 24 15:30 n6gq-core-image-minimal-Solidsense-2.0.2-2022052400.manifest
-rw-r--r-- 1 sdamaj sdamaj    182834 May 24 15:30 n6gq-core-image-minimal-Solidsense-2.0.2-2022052400.manifest.lic
-rw------- 1 sdamaj sdamaj 436085248 May 24 15:31 n6gq-core-image-minimal-Solidsense-2.0.2-2022052400.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 May 24 15:30 n6gq-core-image-minimal-Solidsense-2.0.2-2022052400.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 436084224 May 24 15:31 n6gq-core-image-minimal-Solidsense-2.0.2-2022052400.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 412508518 May 24 15:30 n6gq-core-image-minimal-Solidsense-2.0.2-2022052400.tar.gz
-rw-r--r-- 1 sdamaj sdamaj    168452 May 24 15:30 n6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.manifest
-rw-r--r-- 1 sdamaj sdamaj    186986 May 24 15:30 n6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.manifest.lic
-rw------- 1 sdamaj sdamaj 436153856 May 24 15:31 n6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 May 24 15:30 n6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 436152832 May 24 15:31 n6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 412509704 May 24 15:30 n6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.tar.gz
-rw-r--r-- 1 sdamaj sdamaj    176570 May 24 15:30 solidsense-core-image-minimal-Solidsense-2.0.2-2022052400.manifest
-rw-r--r-- 1 sdamaj sdamaj    195072 May 24 15:30 solidsense-core-image-minimal-Solidsense-2.0.2-2022052400.manifest.lic
-rw------- 1 sdamaj sdamaj 435725824 May 24 15:31 solidsense-core-image-minimal-Solidsense-2.0.2-2022052400.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 May 24 15:30 solidsense-core-image-minimal-Solidsense-2.0.2-2022052400.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 435724800 May 24 15:31 solidsense-core-image-minimal-Solidsense-2.0.2-2022052400.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 412113219 May 24 15:30 solidsense-core-image-minimal-Solidsense-2.0.2-2022052400.tar.gz
```

Build errors
------------------
If your build failed after following this procedure, ensure that:

```
* Using Debian 10
* bitbake will not run as root - had to create user in docker container
* kas is found in /usr/local/bin - had to modify meta-cip-sr-common/scripts/build
* Debian requires additional dependencies - cpio python2 python2.7 unzip wget
* Build requires "python2" to be in the /usr/bin directory - had to create symbolic link to /usr/bin/python2.7
* If the build gets in a bad state, clean it by removing build, deploy, and poky from the poky directory
* System needs to support the en_US.UTF-8 locale - had to install locales and generate this locale using dpkg-reconfigure locales
```

Updating a SolidSense Board
---------------------------
This is an example how to updating a SolidSense N6 board.

Copy your image mender on your board in /tmp/n6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.mender, then execute the following commands:

```
# mender install /tmp/n6gsdl-core-image-minimal-Solidsense-2.0.2-2022052400.mender
# mender commit
# /opt/scripts/restart --wipe
```
After boot, Kura will be available after 4 minutes. You can check your configuration by taping `https://serial_number_of_your_gateway` or `https://ip_address_board` on your navigator.

`If you dont able to load Kura from browser`
```
# /opt/scripts/restart --config
```
Wait for reboot, kura will be available after 4 minutes.


Solidsense-connect N6 Boards
----------------------------
* N6 indoor		: n6gq n6gsdl
* N6 outdoor	: n6gq n6gsdl
* N6 industrial	: in6gq in6gsdl 

Solidsense-connect N8 Boards
----------------------------
* N8 indoor     : imx8mnc
* N8 outdoor    : coming soon
* N8 industrial	: BOM in progress

Images Ready-To-Use
-------------------
* `unsigned images`: https://images.solidsense.io/SolidSense/mender/SolidRun-unsigned/index.html
* `signed images`: https://images.solidsense.io/SolidSense/mender/SolidRun-signed/index.html

Last images
-----------
* `Solidsense-connect N6 indoor/outdoor`: n6gsdl-core-image-minimal-Solidsense-2.0-2021122000.mender
* `Solidsense-connect insdustrial N6`: in6gsdl-core-image-minimal-Solidsense-2.0-2021122000.mender
* `Solidsense-connect N8 family`: imx8mnc-core-image-minimal-Solidsense-2.0-2021122000.mender

Firmware content
----------------
* Kernel 5.4.47
* Wi-Fi Boradcom Combo: Wifi / BLE
* wpa_supplicant v2.7
* Sink Nordic: Transport Layer
* Kura 5.0.1
* Mqtt 3.1.1
* Java JDK11
* Python v3.7
* Mender v2.6
* Docker v18.09.3

Informations
------------
* ! Wirepas 5.1 firmwares for the sinks are not integrated into the images.
* ! You need to buy licences from SolidRun or see with SoliSense-Connect marketing service to flush the sinks.
* ! wirepas 4.0 is not compatible with wirepas 5.0.
* ! BLE 1.8.1 for the sinks is available with SolidSense-Connect.

