CIP core: Instructions for the DE0-Nano-SoC cyclonev board
2017 (c) Toshiba corp.
author: <daniel.sangorrin@toshiba.co.jp>
-------------------------------------------------------------------------------

Build the binaries
==================

Build using KAS:
    host$ git clone https://gitlab.com/cip-project/cip-core/deby.git
    host$ docker run -v $PWD/deby:/deby -e USER_ID=`id -u $USER` -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e NO_PROXY="$no_proxy" -it kasproject/kas sh
    docker$ cd /deby/poky/
    docker$ kas build --target core-image-minimal meta-cip-cyclonev/kas-cyclonev.yml
    docker$ kas build --target meta-toolchain meta-cip-cyclonev/kas-cyclonev.yml

Get the resulting binaries
    host$ cd build/tmp/deploy/images/cyclonev/
    host$ ls
        core-image-minimal-cyclonev.tar.gz
        zImage
        zImage-socfpga_cyclone5_de0_sockit.dtb
        u-boot.bin,elf

Install the binaries
====================

[Note] For u-boot follow the instuctions in the board's documentation.

Prepare SD Card partitions
    See board's guide or use the original sd card (take a backup)

Install the binaries
    $ cp -L zImage /media/<user>/<boot partition>/
    $ cp -L zImage-socfpga_cyclone5_de0_sockit.dtb /media/<user>/<boot partition>/
    $ sudo rm -rf /media/<user>/<root partition>/* (or put them on a backup folder)
    $ sudo tar xvf core-image-minimal-cyclonev.tar.gz -C /media/<user>/<root partition>/

Tests
=====

Boot test
---------

Insert the card on the micro-sd slot and boot
    $ picocom -b 115200 /dev/ttyUSB0
picocom v1.7

port is        : /dev/ttyUSB2
flowcontrol    : none
baudrate is    : 115200
parity is      : none
databits are   : 8
escape is      : C-a
local echo is  : no
noinit is      : no
noreset is     : no
nolock is      : no
send_cmd is    : sz -vv
receive_cmd is : rz -vv
imap is        :
omap is        :
emap is        : crcrlf,delbs,

Terminal ready

Debian GNU/Linux 8 (none) /dev/ttyS0

(none) login:
U-Boot SPL 2013.01.01 (Sep 21 2015 - 06:53:43)
BOARD : Altera SOCFPGA Cyclone V Board
CLOCK: EOSC1 clock 25000 KHz
CLOCK: EOSC2 clock 25000 KHz
CLOCK: F2S_SDR_REF clock 0 KHz
CLOCK: F2S_PER_REF clock 0 KHz
CLOCK: MPU clock 925 MHz
CLOCK: DDR clock 400 MHz
CLOCK: UART clock 100000 KHz
CLOCK: MMC clock 50000 KHz
CLOCK: QSPI clock 3613 KHz
RESET: COLD
SDRAM: Initializing MMR registers
SDRAM: Calibrating PHY
SEQ.C: Preparing to start memory calibration
SEQ.C: CALIBRATION PASSED
SDRAM: 1024 MiB
ALTERA DWMMC: 0
reading ATLAS_SOC_GHRD/u-boot.img
reading ATLAS_SOC_GHRD/u-boot.img


U-Boot 2013.01.01 (Sep 21 2015 - 06:53:50)

CPU   : Altera SOCFPGA Platform
BOARD : Altera SOCFPGA Cyclone V Board
I2C:   ready
DRAM:  1 GiB
MMC:   ALTERA DWMMC: 0
*** Warning - bad CRC, using default environment

In:    serial
Out:   serial
Err:   serial
Skipped ethaddr assignment due to invalid EMAC address in EEPROM
Net:   mii0
Warning: failed to set MAC address

Hit any key to stop autoboot:  0
reading u-boot.scr
903 bytes read in 4 ms (219.7 KiB/s)
## Executing script at 02000000
---Booting ATLAS SOC GHRD---
---Programming FPGA---
reading ATLAS_SOC_GHRD/output_files/ATLAS_SOC_GHRD.rbf
2109256 bytes read in 109 ms (18.5 MiB/s)
---Setting Env variables---
## Starting application at 0x3FF79550 ...
## Application terminated, rc = 0x0
---Generating MAC Address---
ethaddr = 00:07:ed:4a:57:18
---Booting Linux---
reading zImage
3994680 bytes read in 193 ms (19.7 MiB/s)
reading zImage-socfpga_cyclone5_de0_sockit.dtb
30515 bytes read in 9 ms (3.2 MiB/s)
## Flattened Device Tree blob at 00000100
   Booting using the fdt blob at 0x00000100
   reserving fdt memory region: addr=0 size=1000
   Loading Device Tree to 03ff5000, end 03fff732 ... OK

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 4.4.75-cip6 (builder@a42d984006c1) (gcc version 4.9.2 (GCC) ) #2 SMP Thu Sep 7 07:49:48 UTC 2017
[    0.000000] CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine model: Terasic DE-0(Atlas)
[    0.000000] Truncating RAM at 0x00000000-0x40000000 to -0x30000000
[    0.000000] Consider using a HIGHMEM enabled kernel.
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] PERCPU: Embedded 13 pages/cpu @ef9c4000 s21760 r8192 d23296 u53248
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 195072
[    0.000000] Kernel command line: console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootwait
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 770552K/786432K available (6104K kernel code, 402K rwdata, 1564K rodata, 440K init, 137K bss, 15880K reserved, 0K cma-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
[    0.000000]     vmalloc : 0xf0800000 - 0xff800000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf0000000   ( 768 MB)
[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0785660   (7670 kB)
[    0.000000]       .init : 0xc0786000 - 0xc07f4000   ( 440 kB)
[    0.000000]       .data : 0xc07f4000 - 0xc08589f0   ( 403 kB)
[    0.000000]        .bss : 0xc08589f0 - 0xc087aeb4   ( 138 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 32.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] L2C: platform modifies aux control register: 0x02060000 -> 0x32460000
[    0.000000] L2C: platform provided aux values permit register corruption.
[    0.000000] L2C: DT/platform modifies aux control register: 0x02060000 -> 0x32460000
[    0.000000] L2C-310 erratum 769419 enabled
[    0.000000] L2C-310 enabling early BRESP for Cortex-A9
[    0.000000] L2C-310 full line of zeros enabled for Cortex-A9
[    0.000000] L2C-310 ID prefetch enabled, offset 1 lines
[    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
[    0.000000] L2C-310 cache controller enabled, 8 ways, 512 kB
[    0.000000] L2C-310: CACHE_ID 0x410030c9, AUX_CTRL 0x76460001
[    0.000000] clocksource: timer1: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604467 ns
[    0.000005] sched_clock: 32 bits at 100MHz, resolution 10ns, wraps every 21474836475ns
[    0.000309] Console: colour dummy device 80x30
[    0.000328] Calibrating delay loop... 1836.64 BogoMIPS (lpj=9183232)
[    0.059774] pid_max: default: 32768 minimum: 301
[    0.059872] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.059882] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.060406] CPU: Testing write buffer coherency: ok
[    0.060432] ftrace: allocating 20181 entries in 60 pages
[    0.090894] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.091102] Setting up static identity map for 0x8280 - 0x82d8
[    0.149795] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.149857] Brought up 2 CPUs
[    0.149871] SMP: Total of 2 processors activated (3679.84 BogoMIPS).
[    0.149877] CPU: All CPU(s) started in SVC mode.
[    0.150546] devtmpfs: initialized
[    0.157367] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 4
[    0.157642] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.157666] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.158949] NET: Registered protocol family 16
[    0.159667] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.165690] hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchpoint registers.
[    0.165703] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.201817] SCSI subsystem initialized
[    0.202084] usbcore: registered new interface driver usbfs
[    0.202147] usbcore: registered new interface driver hub
[    0.202204] usbcore: registered new device driver usb
[    0.202333] soc:usbphy@0 supply vcc not found, using dummy regulator
[    0.203030] pps_core: LinuxPPS API ver. 1 registered
[    0.203040] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.203070] PTP clock support registered
[    0.203239] FPGA manager framework
[    0.204001] clocksource: Switched to clocksource timer1
[    0.234213] NET: Registered protocol family 2
[    0.234727] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.234802] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.234907] TCP: Hash tables configured (established 8192 bind 8192)
[    0.234984] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.235027] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.235197] NET: Registered protocol family 1
[    0.235556] RPC: Registered named UNIX socket transport module.
[    0.235565] RPC: Registered udp transport module.
[    0.235571] RPC: Registered tcp transport module.
[    0.235577] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.235906] hw perfevents: enabled with armv7_cortex_a9 PMU driver, 7 counters available
[    0.235981] armv7-pmu arm-pmu: PMU:CTI successfully enabled for 2 cores
[    0.247876] NFS: Registering the id_resolver key type
[    0.247919] Key type id_resolver registered
[    0.247925] Key type id_legacy registered
[    0.247983] ntfs: driver 2.1.32 [Flags: R/W].
[    0.248299] jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
[    0.249330] io scheduler noop registered (default)
[    0.253975] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.254971] console [ttyS0] disabled
[    0.255010] ffc02000.serial0: ttyS0 at MMIO 0xffc02000 (irq = 41, base_baud = 6250000) is a 16550A
[    0.815765] console [ttyS0] enabled
[    0.819830] ffc03000.serial1: ttyS1 at MMIO 0xffc03000 (irq = 42, base_baud = 6250000) is a 16550A
[    0.830363] brd: module loaded
[    0.835018] CAN device driver interface
[    0.839268] stmmac - user ID: 0x10, Synopsys ID: 0x37
[    0.844321]  Ring mode enabled
[    0.847362]  DMA HW capability register supported
[    0.851870]  Enhanced/Alternate descriptors
[    0.856224] 	Enabled extended descriptors
[    0.860215]  RX Checksum Offload Engine supported (type 2)
[    0.865686]  TX Checksum insertion supported
[    0.869936]  Enable RX Mitigation via HW Watchdog Timer
[    0.880647] libphy: stmmac: probed
[    0.884060] eth%d: PHY ID 00221622 at 1 IRQ POLL (stmmac-0:01) active
[    0.891337] ffb40000.usb supply vusb_d not found, using dummy regulator
[    0.897985] ffb40000.usb supply vusb_a not found, using dummy regulator
[    1.243966] dwc2 ffb40000.usb: EPs: 16, dedicated fifos, 8064 entries in SPRAM
[    1.804050] dwc2 ffb40000.usb: DWC OTG Controller
[    1.808757] dwc2 ffb40000.usb: new USB bus registered, assigned bus number 1
[    1.815812] dwc2 ffb40000.usb: irq 43, io mem 0x00000000
[    1.821270] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.828043] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.835243] usb usb1: Product: DWC OTG Controller
[    1.839928] usb usb1: Manufacturer: Linux 4.4.75-cip6 dwc2_hsotg
[    1.845916] usb usb1: SerialNumber: ffb40000.usb
[    1.851020] hub 1-0:1.0: USB hub found
[    1.854803] hub 1-0:1.0: 1 port detected
[    1.859316] usbcore: registered new interface driver usb-storage
[    1.865641] mousedev: PS/2 mouse device common for all mice
[    1.871466] i2c /dev entries driver
[    1.875713] Synopsys Designware Multimedia Card Interface Driver
[    1.881944] dw_mmc ff704000.dwmmc0: IDMAC supports 32-bit address mode.
[    1.888584] dw_mmc ff704000.dwmmc0: Using internal DMA controller.
[    1.894754] dw_mmc ff704000.dwmmc0: Version ID is 240a
[    1.899906] dw_mmc ff704000.dwmmc0: DW MMC controller at irq 30,32 bit host data width,1024 deep fifo
[    1.923953] mmc_host mmc0: Bus speed (slot 0) = 50000000Hz (slot req 400000Hz, actual 396825HZ div = 63)
[    1.943974] dw_mmc ff704000.dwmmc0: 1 slots initialized
[    1.949551] ledtrig-cpu: registered to indicate activity on CPUs
[    1.955732] usbcore: registered new interface driver usbhid
[    1.961279] usbhid: USB HID core driver
[    1.965332] fpga_manager fpga0: Altera SOCFPGA FPGA Manager registered
[    1.972217] altera_hps2fpga_bridge ff400000.fpga_bridge: fpga bridge [lwhps2fpga] registered
[    1.980852] altera_hps2fpga_bridge ff500000.fpga_bridge: fpga bridge [hps2fpga] registered
[    1.982626] mmc_host mmc0: Bus speed (slot 0) = 50000000Hz (slot req 50000000Hz, actual 50000000HZ div = 0)
[    1.982683] mmc0: new high speed SDHC card at address 59b4
[    1.983103] mmcblk0: mmc0:59b4       3.73 GiB
[    1.984125]  mmcblk0: p1 p2 p3
[    2.012122] fpga-region soc:base_fpga_region: FPGA Region probed
[    2.018372] oprofile: using arm/armv7-ca9
[    2.023419] NET: Registered protocol family 10
[    2.028633] sit: IPv6 over IPv4 tunneling driver
[    2.033815] NET: Registered protocol family 17
[    2.038286] NET: Registered protocol family 15
[    2.042716] can: controller area network core (rev 20120528 abi 9)
[    2.048931] NET: Registered protocol family 29
[    2.053363] can: raw protocol (rev 20120528)
[    2.057632] can: broadcast manager protocol (rev 20120528 t)
[    2.063274] can: netlink gateway (rev 20130117) max_hops=1
[    2.068972] 8021q: 802.1Q VLAN Support v1.8
[    2.073186] Key type dns_resolver registered
[    2.077534] ThumbEE CPU extension supported.
[    2.081798] Registering SWP/SWPB emulation handler
[    2.087409] of_cfs_init
[    2.089901] of_cfs_init: OK
[    2.094840] ttyS0 - failed to request DMA
[    2.099804] EXT4-fs (mmcblk0p2): mounting ext3 file system using the ext4 subsystem
[    2.831515] EXT4-fs (mmcblk0p2): recovery complete
[    2.876680] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
[    2.884775] VFS: Mounted root (ext3 filesystem) on device 179:2.
[    2.891906] devtmpfs: mounted
[    2.895196] Freeing unused kernel memory: 440K (c0786000 - c07f4000)

Debian GNU/Linux 8 (none) /dev/ttyS0

(none) login: root

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
login[623]: root login on 'ttyS0'


BusyBox v1.22.1 (2017-09-07 07:11:45 UTC) built-in shell (ash)
Enter 'help' for a list of built-in commands.

# uname -a
Linux (none) 4.4.75-cip6 #2 SMP Thu Sep 7 07:49:48 UTC 2017 armv7l GNU/Linux

GPIO test
---------

Ref: https://media.digikey.com/pdf/Data%20Sheets/Terasic%20Technologies/DE0-Nano-SoC_UM.pdf
Ref: https://www.altera.com/en_US/pdfs/literature/ug/DE0_Nano_User_Manual_v1.9.pdf

- Three GPIO controllers
    GPIO0: /sys/class/gpio/gpiochip483/label = ff708000.gpio (ngpio: 27)
    GPIO1: /sys/class/gpio/gpiochip454/label = ff709000.gpio (ngpio: 29)
    GPIO2: /sys/class/gpio/gpiochip427/label = ff70a000.gpio (ngpio: 29)

Build
    host$ git clone https://github.com/larsks/gpio-watch
    host$ cd gpio-watch/
    host$ source path/to/environment-setup-armv7a-vfs-neon-deby-linux-gnueabi
    host$ make
    host$ sudo cp gpio-watch <sdcard root partition>/root

Configure
    host$ sudo mkdir <sdcard root partition>/root/scripts
    host$ sudo vi  <sdcard root partition>/root/scripts/479
        #!/bin/sh
        echo "Button pressed: Pin:$1 Value:$2"
    host$ sudo chmod +x <sdcard root partition>/root/scripts/479

Run
    target# ./gpio-watch -s scripts 479
    (Press Key2 button)
        Button pressed: Pin:479 Value:0
        Button pressed: Pin:479 Value:1
        Button pressed: Pin:479 Value:1
        Button pressed: Pin:479 Value:0

Gigabit Ethernet test
---------------------

- Plug RJ45 cable to RJ45 connector on the board
- Make sure a led on RJ45 connector is ON
- Type the below command:
    # ifconfig eth0 <ip_address>
- Get kernel message output like:
    # [  777.674701] socfpga-dwmac ff702000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
- Type command:
    # ping <another_ip_address>
- Get output like:
    PING 10.116.41.48 (10.116.41.48): 56 data bytes
    64 bytes from 10.116.41.48: seq=0 ttl=64 time=1.863 ms
    64 bytes from 10.116.41.48: seq=1 ttl=64 time=0.995 ms
    64 bytes from 10.116.41.48: seq=2 ttl=64 time=0.955 ms

HPS reset buttons
-----------------

- HPS_RESET_N resets all HPS logics that can be reset (Include HPS, Ethernet, USB, ...).
- HPS_WARM_RST_N resets to the HPS block.
- Test procedure:
    - Press either HPS_RESET_N or HPS_WARM_RST_N.
    - The system will be rebooted.

HPS_LED
-------

- Build toolchain for the board
        - $ bitbake meta-toolchain
        - When building is completed, the output is in tmp/deploy/sdk/
        - Run the *.sh file. (use -d option for installing the SDK to directory)
- Use the toolchain to compile C-source for testing the HPS_LED
        - In toolchain directory, run: $ source environment-setup-armv7a-vfs-neon-deby-linux-gnueabi
        - Go to the C-source directory which contains the blink.c file.
          [Note] blink.c can be obtained from the Kit installation (ZIP) (Linux)
                 Ref: https://www.altera.com/products/boards_and_kits/dev-kits/altera/kit-cyclone-v-soc.html
        - Run: $ $CC -o blink_test blink.c
        - Copy the execute blink_test to the board
- Run the testing on the board
        - Run: ./blink_test led_number delay_time
        - Currently, HPS_LED just has only a led, so led_number is 0
        - Ex: ./blink_test 0 100
        - The led will blink with 100 ms

HPS_button
----------

- Build a kernel module for controlling the button
    - Copy source/recipes-kernel folder to deby/poky/meta-cip-cyclonev/
    - build linux-base recipe to get the module.
        - $ bitbake linux-base
    - The gpio_test.ko module is available in
            deby/build-meta-cip-cyclonev/tmp/work/cyclonev-deby-linux-gnueabi/linux-base/gitAUTOINC+7e7c26e0e4-r0/build/drivers/gpio_interrupt/
    - Copy the module gpio_test.ko to the board
- Run the module on the board
    - insmod ./gpio_test.ko gpioButton=479
    - get output like the below
        [10318.140861] GPIO_TEST: Initializing the GPIO_TEST LKM
        [10318.146036] GPIO_TEST: The button state is currently: 1
        [10318.151240] GPIO_TEST: The button is mapped to IRQ: 101
        [10318.156474] GPIO_TEST: The interrupt request result is: 0
    - Press the HPS_button, get output like
        [10388.945025] GPIO_TEST: Interrupt! (button state is 1)
        [10397.853717] GPIO_TEST: Interrupt! (button state is 1)
        [10397.858760] GPIO_TEST: Interrupt! (button state is 1)
    - rmmod ./gpio_test.ko, get output like
        [10465.303532] GPIO_TEST: The button state is currently: 1
        [10465.308773] GPIO_TEST: The button was pressed 3 times
        [10465.313907] GPIO_TEST: Goodbye from the LKM!
