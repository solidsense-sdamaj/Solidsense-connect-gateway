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
* clone the repo solidsense-connect-gateway from https://github.com/solidsense-connect/Solidsense-connect-gateway.git :
 ```shell
git clone https://github.com/solidsense-connect/Solidsense-connect-gateway.git
```
* create a new folder mender-cert in poky/meta-cip-sr-common
* copy and rename the generated public.key ~/solidsense-connect/signing-private-keys to meta-cip-sr-common/mender-cert/artifact-verify-key.pem

=> Install required packages:
 `Preference to use Debian 10 to build images `

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
-rw-r--r-- 1 sdamaj sdamaj     48957 Oct  3 16:38 imx6dl-hummingboard2-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     48263 Oct  3 16:37 imx6dl-solidsense-in6-a-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     47935 Oct  3 16:37 imx6dl-solidsense-in6-b-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     46756 Oct  3 16:37 imx6dl-solidsense-in6-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     50343 Oct  3 16:38 imx6q-hummingboard2-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     49500 Oct  3 16:37 imx6q-solidsense-in6-a-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     49172 Oct  3 16:37 imx6q-solidsense-in6-b-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     47993 Oct  3 16:37 imx6q-solidsense-in6-emmc-som-v15.dtb
-rw-r--r-- 1 sdamaj sdamaj     66062 Oct  3 16:37 imx8mnc-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest
-rw-r--r-- 1 sdamaj sdamaj     76282 Oct  3 16:37 imx8mnc-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest.lic
-rw------- 1 sdamaj sdamaj 490677248 Oct  3 16:38 imx8mnc-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 Oct  3 16:37 imx8mnc-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 490676224 Oct  3 16:38 imx8mnc-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 463284019 Oct  3 16:37 imx8mnc-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.tar.gz
-rw-r--r-- 1 sdamaj sdamaj     37696 Oct  3 16:37 imx8mn-compact.dtb
-rw-r--r-- 1 sdamaj sdamaj    170664 Oct  3 16:37 in6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest
-rw-r--r-- 1 sdamaj sdamaj    189966 Oct  3 16:37 in6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest.lic
-rw------- 1 sdamaj sdamaj 482911232 Oct  3 16:38 in6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 Oct  3 16:37 in6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 482910208 Oct  3 16:38 in6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 456088392 Oct  3 16:37 in6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.tar.gz
-rw-r--r-- 1 sdamaj sdamaj    174816 Oct  3 16:37 in6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest
-rw-r--r-- 1 sdamaj sdamaj    194118 Oct  3 16:38 in6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest.lic
-rw------- 1 sdamaj sdamaj 482949120 Oct  3 16:39 in6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 Oct  3 16:37 in6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 482948096 Oct  3 16:39 in6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 456089646 Oct  3 16:37 in6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.tar.gz
-rw-r--r-- 1 sdamaj sdamaj    168587 Oct  3 16:38 n6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest
-rw-r--r-- 1 sdamaj sdamaj    187889 Oct  3 16:38 n6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest.lic
-rw------- 1 sdamaj sdamaj 482884608 Oct  3 16:39 n6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 Oct  3 16:38 n6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 482883584 Oct  3 16:39 n6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 456068324 Oct  3 16:38 n6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.tar.gz
-rw-r--r-- 1 sdamaj sdamaj    172739 Oct  3 16:38 n6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest
-rw-r--r-- 1 sdamaj sdamaj    192041 Oct  3 16:38 n6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest.lic
-rw------- 1 sdamaj sdamaj 482876416 Oct  3 16:38 n6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 Oct  3 16:38 n6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 482209792 Oct  3 14:12 n6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.unsigned
-rw-r--r-- 1 sdamaj sdamaj 456068566 Oct  3 16:38 n6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.tar.gz
-rw-r--r-- 1 sdamaj sdamaj    180857 Oct  3 16:38 solidsense-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest
-rw-r--r-- 1 sdamaj sdamaj    200127 Oct  3 16:38 solidsense-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.manifest.lic
-rw-r--r-- 1 sdamaj sdamaj 482524160 Oct  3 16:38 solidsense-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender
-rw-r--r-- 1 sdamaj sdamaj      2284 Oct  3 16:38 solidsense-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender.bmap
-rw-r--r-- 1 sdamaj sdamaj 455698789 Oct  3 16:38 solidsense-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.tar.gz

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

Download the last N6 image mender on your board and install it following theses commands:

```
# mender install https://images.solidsense.io/SolidSense/mender/SolidRun-signed/2.1.0-rc3/n6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender
# mender -commit
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
* N6 indoor     : n6gq n6gsdl
* N6 outdoor	: n6gq n6gsdl
* N6 industrial	: in6gq in6gsdl 

Solidsense N6 products
----------------------

| Product  | Informations                                                     |
|--------  |----------------------------------------------------------------- |
|SRG0001   | SolidSense N6 Edge Gateway Indoor - Dual core-WiFi               |
|SRG0002   | SolidSense N6 Edge Gateway Indoor - Dual core-WiFi -LTE C4 EU    |
|SRG0003   | SolidSense N6 Edge Gateway Indoor - Quad core-WiFi -LTE C4 EU    |
|SRG0004   | SolidSense N6 Edge Gateway Indoor - Dual core-WiFi -LTE C4 US    |
|SRG0005   | SolidSense N6 Edge Gateway Indoor - Single core-WiFi -LTE C4 US  |
|SRG0006   | SolidSense N6 Edge Gateway Indoor - Dual core-WiFi -LTE C4 AU    |
|SRG0007   | SolidSense N6 Edge Gateway Indoor - Quad core-WiFi -LTE C4 US    |

Solidsense-connect N8 Boards
----------------------------
* N8 indoor     : imx8mnc
* N8 outdoor    : coming soon
* N8 industrial : BOM in progress


SolidSense N8 products
----------------------

| Product       | Informations                                                       |
|-------------- |------------------------------------------------------------------- |
|SRG0400        | SolidSense N8 Compact - Test version fully equiped                 |
|SRG0401        | SolidSense N8 Compact - WiFi BLE                                   |
|SRG0402        | SolidSense N8 Compact - WiFi LTE BLE                               |
|SRG0403        | SolidSense N8 Compact - WiFi Extended                              |
|SRG0404        | SolidSense N8 Compact - WiFi LTE Extended                          |
|SRG0405.01SD   | SolidSense N8 Compact - WiFi BLE-UBLOX LTE RS485 CAN ETH-Atheros   |
|SRG0405.02SD   | SolidSense N8 Compact - WiFi BLE-FWM LTE POE RS485 CAN ETH-ADIN    |

Images Ready-To-Use
-------------------
* `unsigned images`: https://images.solidsense.io/SolidSense/mender/SolidRun-unsigned/index.html
* `signed images`: https://images.solidsense.io/SolidSense/mender/SolidRun-signed/index.html

Last images
-----------
* `Solidsense-connect N6 dual indoor/outdoor`: n6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender
* `Solidsense-connect N6 quad indoor/outdoor`: n6gq-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender
* `Solidsense-connect N6 dual insdustrial`: in6gsdl-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender
* `Solidsense-connect compact (ex N8)`: imx8mnc-core-image-minimal-Solidsense-2.1.0-rc3-2023100300.mender

Firmware content
----------------
* Kernel 5.4.47
* Wi-Fi Broadcom Combo: Wifi / BLE for N8
* Wi-Fi TI Combo: WiFi/BLE for N6
* wpa_supplicant v2.7
* Sink Nordic: Transport Layer
* Kura 5.1.0
* Mqtt 3.1.1
* Java JDK11
* Python v3.7
* Mender v2.6
* Docker v18.09.3

Informations about Wirepas firmware
-----------------------------------
* Wirepas 4.x and 5.x firmwares for the sinks are not integrated into the images.
* You need to buy licences from SoliSense-Connect marketing service to flush the sinks.
* wirepas 4.x is not compatible with wirepas 5.x.

Informations about BLE firmwares
--------------------------------
* For U-BLOX NINA1: https://images.solidsense.io/SolidSense/bluetooth/nina-b1/index.html
* For U-BLOX NINA3: https://images.solidsense.io/SolidSense/bluetooth/nina-b3/index.html
* For FUJITSU FWM7BLZ22W: https://images.solidsense.io/SolidSense/bluetooth/fwm7blz22w/index.html  

Maintainers
------------
- Samer Damaj <samer.damaj@solidsense-connect.com>
- Anthony Pauthonnier <anthony.pauthonnier@sodira-connect.com>
