CIP core: Instructions for the Renesas IWG20M board
2017 (c) Toshiba corp.
author: <daniel.sangorrin@toshiba.co.jp>
-------------------------------------------------------------------------------

Build the binaries
==================

Build using KAS:
    host$ docker run -v $PWD/cip-core:/cip-core -e USER_ID=`id -u $USER` -e http_proxy=$http_proxy -e https_proxy=$https_proxy -it kas sh
    docker$ cd /cip-core/deby/poky/
    docker$ kas build --target core-image-minimal meta-cip-iwg20m/kas-iwg20m.yml

Get the resulting binaries
    host$ cd build/tmp/deploy/images/iwg20m/
    host$ ls
        core-image-minimal-iwg20m.tar.gz
        uImage
        uImage-r8a7743-iwg20m.dtb
        u-boot.bin

Install the binaries
====================

[Note] For u-boot follow the instuctions in the board's documentation.

Prepare SD Card partitions
    See board's guide

Install the binaries
    $ cp -L uImage /media/<user>/BOOT/uImage
    $ cp -L uImage-r8a7743-iwg20m.dtb /media/<user>/BOOT/r8a7743-iwg20m_q7.dtb
    $ sudo rm -rf /media/<user>/ROOT/*
    $ sudo tar xvf core-image-minimal-iwg20m.tar.gz -C /media/<user>/ROOT/

Boot test
=========

Insert the card on the micro-sd slot (on the upper SOM) and boot
    $ picocom -b 115200 /dev/ttyUSB0
    iWave-G20M > setenv bootcmd_msd 'run bootargs_msd;run fdt_check;mmc dev 1;fatload mmc 1 ${loadaddr} ${kernel};fatload mmc 1 ${fdt_addr} ${fdt_file};bootm ${loadaddr} - ${fdt_addr}'
    iWave-G20M > setenv bootargs_msd 'setenv bootargs ${bootargs_base} root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait'
      [Note] mmcblk0p2 is the sdcard on the CIP kernel
    iWave-G20M > saveenv
    iWave-G20M > run bootcmd_msd
        -> login as root (no password)

Boot log
    U-Boot 2013.01.01 (Nov 04 2016 - 22:21:05)

    CPU: Renesas Electronics R8A7743 rev 3.0
    CPU: Temperature 35 C
    Board: RZ/G1M iW-RainboW-G20M-Q7

    DRAM:  1 GiB
    MMC:   sh-sdhi: 0, sh-sdhi: 1, sh_mmcif: 2
    SF: Detected SST25VF016B with page size 4 KiB, total 2 MiB
    In:    serial
    Out:   serial
    Err:   serial

    Board Info:
	    BSP Version     : iW-PREWZ-SC-01-R3.0-REL2.0-Linux3.10.31
	    SOM Version     : iW-PREWZ-AP-01-R3.0

    Net:   ether_avb
    Hit any key to stop autoboot:  0 
    iWave-G20M > setenv bootcmd_msd 'run bootargs_msd;run fdt_check;mmc dev 1;fatload mmc 1 ${loadaddr} ${kernel};fatload mmc 1 ${fdt_addr} ${fdt_file};bootm ${loadaddr} - ${fdt_addr}'
    iWave-G20M > setenv bootargs_msd 'setenv bootargs ${bootargs_base} root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait'
    iWave-G20M > run bootcmd_msd
    mmc1 is current device
    reading uImage
    4048344 bytes read in 184 ms (21 MiB/s)
    reading r8a7743-iwg20m_q7.dtb
    46717 bytes read in 5 ms (8.9 MiB/s)
    ## Booting kernel from Legacy Image at 40007fc0 ...
       Image Name:   Linux-4.4.69-cip4
       Image Type:   ARM Linux Kernel Image (uncompressed)
       Data Size:    4048280 Bytes = 3.9 MiB
       Load Address: 40008000
       Entry Point:  40008000
       Verifying Checksum ... OK
    ## Flattened Device Tree blob at 40f00000
       Booting using the fdt blob at 0x40f00000
       XIP Kernel Image ... OK
    OK
       Loading Device Tree to 40ef1000, end 40eff67c ... OK
    Unable to update property /iwg20m_q7_common:vin2-ov5640, err=FDT_ERR_NOTFOUND

    Starting kernel ...

    Booting Linux on physical CPU 0x0
    Linux version 4.4.69-cip4 (builder@e954f657d182) (gcc version 4.9.2 (GCC) ) #1 SMP PREEMPT Fri Sep 1 01:33:35 UTC 2017
    CPU: ARMv7 Processor [413fc0f2] revision 2 (ARMv7), cr=30c5387d
    CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
    Machine model: iwg20m
    debug: ignoring loglevel setting.
    cma: Reserved 256 MiB at 0x0000000050000000
    cma: Reserved 128 MiB at 0x0000000048000000
    Forcing write-allocate cache policy for SMP
    Memory policy: Data cache writealloc
    On node 0 totalpages: 262144
    free_area_init_node: node 0, pgdat c080c440, node_mem_map c4339000
      DMA zone: 1024 pages used for memmap
      DMA zone: 0 pages reserved
      DMA zone: 131072 pages, LIFO batch:31
      HighMem zone: 131072 pages, LIFO batch:31
    PERCPU: Embedded 12 pages/cpu @c42f2000 s18304 r8192 d22656 u49152
    pcpu-alloc: s18304 r8192 d22656 u49152 alloc=12*4096
    pcpu-alloc: [0] 0 [0] 1 
    Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 261120
    Kernel command line: console=ttySC0,115200n8 ignore_loglevel vmalloc=384M root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait
    PID hash table entries: 2048 (order: 1, 8192 bytes)
    Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
    Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
    Memory: 637176K/1048576K available (5452K kernel code, 216K rwdata, 2240K rodata, 300K init, 223K bss, 18184K reserved, 393216K cma-reserved, 524288K highmem)
    Virtual kernel memory layout:
        vector  : 0xffff0000 - 0xffff1000   (   4 kB)
        fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
        vmalloc : 0xe0800000 - 0xff800000   ( 496 MB)
        lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
        pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
        modules : 0xbf000000 - 0xbfe00000   (  14 MB)
          .text : 0xc0008000 - 0xc078c06c   (7697 kB)
          .init : 0xc078d000 - 0xc07d8000   ( 300 kB)
          .data : 0xc07d8000 - 0xc080e3e0   ( 217 kB)
           .bss : 0xc0811000 - 0xc0848e6c   ( 224 kB)
    Preemptible hierarchical RCU implementation.
	    Build-time adjustment of leaf fanout to 32.
	    RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
    RCU: Adjusting geometry for rcu_fanout_leaf=32, nr_cpu_ids=2
    NR_IRQS:16 nr_irqs:16 16
    Architected cp15 timer(s) running at 10.00MHz (virt).
    clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x24e6a1710, max_idle_ns: 440795202120 ns
    sched_clock: 56 bits at 10MHz, resolution 100ns, wraps every 4398046511100ns
    Switching to timer-based delay loop, resolution 100ns
    Console: colour dummy device 80x30
    Calibrating delay loop (skipped), value calculated using timer frequency.. 20.00 BogoMIPS (lpj=100000)
    pid_max: default: 32768 minimum: 301
    Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
    Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
    CPU: Testing write buffer coherency: ok
    CPU0: update cpu_capacity 1024
    CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
    Setting up static identity map for 0x40009000 - 0x40009058
    CPU1: update cpu_capacity 1024
    CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
    Brought up 2 CPUs
    SMP: Total of 2 processors activated (40.00 BogoMIPS).
    CPU: All CPU(s) started in SVC mode.
    devtmpfs: initialized
    VFP support v0.3: implementor 41 architecture 4 part 30 variant f rev 0
    clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
    futex hash table entries: 512 (order: 3, 32768 bytes)
    pinctrl core: initialized pinctrl subsystem
    NET: Registered protocol family 16
    DMA: preallocated 256 KiB pool for atomic coherent allocations
    renesas_irqc e61c0000.interrupt-controller: driving 10 irqs
    sh-pfc e6060000.pfc: r8a77430_pfc support registered
    No ATAGs?
    hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchpoint registers.
    hw-breakpoint: maximum watchpoint size is 8 bytes.
    gpio-regulator reg_vccq_sdhi1: Could not obtain regulator setting GPIOs: -517
    SCSI subsystem initialized
    libata version 3.00 loaded.
    usbcore: registered new interface driver usbfs
    usbcore: registered new interface driver hub
    usbcore: registered new device driver usb
    media: Linux media interface: v0.10
    Linux video capture interface: v2.00
    pps_core: LinuxPPS API ver. 1 registered
    pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
    PTP clock support registered
    Advanced Linux Sound Architecture Driver Initialized.
    clocksource: Switched to clocksource arch_sys_counter
    NET: Registered protocol family 2
    TCP established hash table entries: 4096 (order: 2, 16384 bytes)
    TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
    TCP: Hash tables configured (established 4096 bind 4096)
    UDP hash table entries: 256 (order: 1, 8192 bytes)
    UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
    NET: Registered protocol family 1
    RPC: Registered named UNIX socket transport module.
    RPC: Registered udp transport module.
    RPC: Registered tcp transport module.
    RPC: Registered tcp NFSv4.1 backchannel transport module.
    PCI: CLS 0 bytes, default 64
    NFS: Registering the id_resolver key type
    Key type id_resolver registered
    Key type id_legacy registered
    nfs4filelayout_init: NFSv4 File Layout Driver Registering...
    bounce: pool size: 64 pages
    Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
    io scheduler noop registered
    io scheduler deadline registered
    io scheduler cfq registered (default)
    GPIO line 996 (can1-trx-en-gpio) hogged as output/low
    GPIO line 1014 (tvp-power) hogged as output/high
    gpio_rcar e6050000.gpio: driving 32 GPIOs
    gpio_rcar e6051000.gpio: driving 32 GPIOs
    GPIO line 931 (can0-trx-en-gpio) hogged as output/low
    gpio_rcar e6052000.gpio: driving 32 GPIOs
    gpio_rcar e6053000.gpio: driving 32 GPIOs
    gpio_rcar e6054000.gpio: driving 32 GPIOs
    gpio_rcar e6055000.gpio: driving 32 GPIOs
    gpio_rcar e6055400.gpio: driving 32 GPIOs
    gpio_rcar e6055800.gpio: driving 26 GPIOs
    pci-rcar-gen2 ee090000.pci: PCI: bus0 revision 11
    pci-rcar-gen2 ee090000.pci: PCI host bridge to bus 0000:00
    pci_bus 0000:00: root bus resource [io  0xee080000-0xee0810ff]
    pci_bus 0000:00: root bus resource [mem 0xee080000-0xee0810ff]
    pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
    pci 0000:00:00.0: [1033:0000] type 00 class 0x060000
    pci 0000:00:00.0: reg 0x10: [mem 0xee090800-0xee090bff]
    pci 0000:00:00.0: reg 0x14: [mem 0x40000000-0x7fffffff pref]
    pci 0000:00:01.0: [1033:0035] type 00 class 0x0c0310
    pci 0000:00:01.0: reg 0x10: [mem 0x00000000-0x00000fff]
    pci 0000:00:01.0: supports D1 D2
    pci 0000:00:01.0: PME# supported from D0 D1 D2 D3hot
    pci 0000:00:02.0: [1033:00e0] type 00 class 0x0c0320
    pci 0000:00:02.0: reg 0x10: [mem 0x00000000-0x000000ff]
    pci 0000:00:02.0: supports D1 D2
    pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot
    PCI: bus0: Fast back to back transfers disabled
    pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
    pci 0000:00:01.0: BAR 0: assigned [mem 0xee080000-0xee080fff]
    pci 0000:00:02.0: BAR 0: assigned [mem 0xee081000-0xee0810ff]
    pci 0000:00:01.0: enabling device (0140 -> 0142)
    pci 0000:00:02.0: enabling device (0140 -> 0142)
    rcar-pcie fe000000.pcie: PCIe link down
    Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
    SuperH (H)SCI(F) driver initialized
    e6c30000.serial: ttySC3 at MMIO 0xe6c30000 (irq = 108, base_baud = 0) is a scifb
    e6e60000.serial: ttySC0 at MMIO 0xe6e60000 (irq = 109, base_baud = 0) is a scif
    console [ttySC0] enabled
    e6e68000.serial: ttySC1 at MMIO 0xe6e68000 (irq = 110, base_baud = 0) is a scif
    e6ee0000.serial: ttySC2 at MMIO 0xe6ee0000 (irq = 111, base_baud = 0) is a scif
    e62c8000.serial: ttySC4 at MMIO 0xe62c8000 (irq = 112, base_baud = 0) is a hscif
    [drm] Initialized drm 1.1.0 20060810
    [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
    [drm] No driver support for vblank timestamp query.
    rcar-du feb00000.display: failed to initialize DRM/KMS (-517)
    renesas_spi e6b10000.spi: DMA available
    m25p80 spi0.0: sst25vf016b (2048 Kbytes)
    renesas_spi e6b10000.spi: probed
    spi_sh_msiof e6e00000.spi: DMA available
    CAN device driver interface
    rcar_can e6e80000.can: device registered (regs @ e0904000, IRQ125)
    rcar_can e6e88000.can: device registered (regs @ e0906000, IRQ126)
    libphy: ravb_mii: probed
    ravb e6800000.ethernet eth0: Base address at 0xe6800000, 00:01:02:03:04:05, IRQ 113.
    ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
    ehci-pci: EHCI PCI platform driver
    ehci-pci 0000:00:02.0: EHCI Host Controller
    ehci-pci 0000:00:02.0: new USB bus registered, assigned bus number 1
    ehci-pci 0000:00:02.0: irq 130, io mem 0xee081000
    ehci-pci 0000:00:02.0: USB 2.0 started, EHCI 1.00
    hub 1-0:1.0: USB hub found
    hub 1-0:1.0: 1 port detected
    ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
    ohci-pci: OHCI PCI platform driver
    ohci-pci 0000:00:01.0: OHCI PCI host controller
    ohci-pci 0000:00:01.0: new USB bus registered, assigned bus number 2
    ohci-pci 0000:00:01.0: irq 130, io mem 0xee080000
    hub 2-0:1.0: USB hub found
    hub 2-0:1.0: 1 port detected
    xhci-hcd ee000000.usb: xHCI Host Controller
    xhci-hcd ee000000.usb: new USB bus registered, assigned bus number 3
    xhci-hcd ee000000.usb: hcc params 0x014051ce hci version 0x100 quirks 0x00810010
    xhci-hcd ee000000.usb: irq 129, io mem 0xee000000
    hub 3-0:1.0: USB hub found
    hub 3-0:1.0: 1 port detected
    xhci-hcd ee000000.usb: xHCI Host Controller
    xhci-hcd ee000000.usb: new USB bus registered, assigned bus number 4
    usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
    hub 4-0:1.0: USB hub found
    hub 4-0:1.0: 1 port detected
    usbcore: registered new interface driver usb-storage
    mousedev: PS/2 mouse device common for all mice
    i2c /dev entries driver
    bq32k 2-0068: rtc core: registered bq32k as rtc0
    i2c-rcar e6530000.i2c: probed
    i2c-rcar e6528000.i2c: probed
    tvp5150 5-005d: i2c i/o error: rc == -6
    usbcore: registered new interface driver uvcvideo
    USB Video Class driver (1.1.1)
    rcar_thermal e61f0000.thermal: 1 sensor probed
    sh_mobile_sdhi ee100000.sd: Got CD GPIO
    sh_mobile_sdhi ee100000.sd: mmc0 base at 0xee100000 clock rate 97 MHz
    sh_mobile_sdhi ee140000.sd: Got CD GPIO
    sh_mobile_sdhi ee140000.sd: Got WP GPIO
    sh_mmcif ee200000.mmc: No vqmmc regulator found
    sh_mmcif ee200000.mmc: Chip version 0x0003, clock rate 12MHz
    usbcore: registered new interface driver usbhid
    usb 3-1: new high-speed USB device number 2 using xhci-hcd
    usbhid: USB HID core driver
    sgtl5000 2-000a: sgtl5000 revision 0x11
    rcar_sound ec500000.sound: probed
    NET: Registered protocol family 10
    sit: IPv6 over IPv4 tunneling driver
    NET: Registered protocol family 17
    can: controller area network core (rev 20120528 abi 9)
    NET: Registered protocol family 29
    can: raw protocol (rev 20120528)
    can: broadcast manager protocol (rev 20120528 t)
    can: netlink gateway (rev 20130117) max_hops=1
    Key type dns_resolver registered
    Registering SWP/SWPB emulation handler
    [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
    [drm] No driver support for vblank timestamp query.
    rcar-du feb00000.display: failed to initialize DRM/KMS (-517)
    sh_mobile_sdhi ee140000.sd: Got CD GPIO
    sh_mobile_sdhi ee140000.sd: Got WP GPIO
    hub 3-1:1.0: USB hub found
    hub 3-1:1.0: 2 ports detected
    mmc0: new high speed SDHC card at address 59b4
    sh_mobile_sdhi ee140000.sd: mmc2 base at 0xee140000 clock rate 97 MHz
    sgtl5000 2-000a: Using internal LDO instead of VDDD
    asoc-simple-card sound: sgtl5000 <-> ec500000.sound mapping ok
    asoc-simple-card sound: ASoC: no source widget found for Mic Jack
    mmcblk0: mmc0:59b4 USDU1 14.7 GiB 
    asoc-simple-card sound: ASoC: Failed to add route Mic Jack -> direct -> MIC_IN
    asoc-simple-card sound: ASoC: no sink widget found for Mic Jack
    asoc-simple-card sound: ASoC: Failed to add route Mic Bias -> direct -> Mic Jack
    asoc-simple-card sound: ASoC: no sink widget found for Headphone Jack
    asoc-simple-card sound: ASoC: Failed to add route HP_OUT -> direct -> Headphone Jack
    [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
    [drm] No driver support for vblank timestamp query.
    rcar-du feb00000.display: failed to initialize DRM/KMS (-517)
    bq32k 2-0068: setting system clock to 2017-02-14 00:29:45 UTC (1487032185)
    ALSA device list:
      #0: rsnd-dai.0-sgtl5000
     mmcblk0: p1 p2
    [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
    [drm] No driver support for vblank timestamp query.
    rcar-du feb00000.display: failed to initialize DRM/KMS (-517)
    EXT4-fs (mmcblk0p2): mounting ext3 file system using the ext4 subsystem
    EXT4-fs (mmcblk0p2): recovery complete
    EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
    VFS: Mounted root (ext3 filesystem) on device 179:2.
    devtmpfs: mounted
    Freeing unused kernel memory: 300K (c078d000 - c07d8000)
    mmc1: MAN_BKOPS_EN bit is not set

    mmc1: new high speed MMC card at address 0001
    Debian GNU/Linuxmmcblk1: mmc1:0001 MMC04G 3.52 GiB 
     8 (none) /dev/tmmcblk1boot0: mmc1:0001 MMC04G partition 1 16.0 MiB
    tySC0

    (nonemmcblk1boot1: mmc1:0001 MMC04G partition 2 16.0 MiB
    ) login:  mmcblk1: p1 p2
    [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
    [drm] No driver support for vblank timestamp query.
    rcar-du feb00000.display: failed to initialize DRM/KMS (-517)
    root

    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    login[818]: root login on 'ttySC0'


    BusyBox v1.22.1 (2017-09-01 01:37:39 UTC) built-in shell (ash)
    Enter 'help' for a list of built-in commands.

    # ls
    # uname -a
    Linux (none) 4.4.69-cip4 #1 SMP PREEMPT Fri Sep 1 01:33:35 UTC 2017 armv7l GNU/Linux

