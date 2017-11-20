CIP core: Instructions for the BBB
2017 (c) Toshiba corp.
author: <daniel.sangorrin@toshiba.co.jp>
-------------------------------------------------------------------------------

Build the binaries
==================

Build using KAS:
    host$ docker run -v $PWD/cip-core:/cip-core -e USER_ID=`id -u $USER` -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e NO_PROXY="$no_proxy" -it kasproject/kas:0.13.0 sh
    docker$ cd /cip-core/deby/poky/
    docker$ kas build --target core-image-minimal meta-cip-bbb/kas-bbb.yml

Get the resulting binaries
    host$ cd build/tmp/deploy/images/bbb/
    host$ ls
        core-image-minimal-bbb.rootfs.tar.gz
        zImage
        zImage-am335x-boneblack.dtb
        u-boot.img
        MLO

Install the binaries
====================

Create two partitions on the SD Card: BOOT (FAT32) and ROOT (ext4)
    - Follow generic BBB users guide

Install the root file system
    $ sudo tar xvf core-image-minimal-bbb.tar.gz -C /media/<user>/ROOT/
    $ sudo cp zImage-am335x-boneblack.dtb /media/<user>/ROOT/boot/am335x-boneblack.dtb
    $ sudo ls /media/<user>/ROOT/boot
        zImage  zImage-4.4.55-cip3 <-- the kernel is already installed

Install the bootloader
    $ cp MLO /media/<user>/BOOT/
    $ cp u-boot.img /media/<user>/BOOT/
    $ vi /media/<user>/BOOT/uEnv.txt
        bootpart=0:2
        bootdir=/boot
        bootfile=zImage-4.4.55-cip3
        console=ttyO0,115200n8
        fdtaddr=0x81000000
        fdtfile=am335x-boneblack.dtb
        loadaddr=0x80008000
        mmcroot=/dev/mmcblk0p2 ro
        mmcrootfstype=ext4 rootwait
        mmcargs=setenv bootargs console=${console} root=${mmcroot} rootfstype=${mmcrootfstype}
        loadfdt=load mmc ${bootpart} ${fdtaddr} ${bootdir}/${fdtfile}
        loadimage=load mmc ${bootpart} ${loadaddr} ${bootdir}/${bootfile}
        uenvcmd=if run loadfdt; then echo Loaded ${fdtfile}; if run loadimage; then run mmcargs; bootz ${loadaddr} - ${fdtaddr}; fi; fi;

Boot test
=========

Connect serial cable to jumper J1
    J1: * TXD RXD * * GND [DOT]
    - connect cable's RXD to TXD, TXD to RXD, and GND to GND
      [Note] for a standard FTDI cable, the black wire is the GND

Press S2 and then, put the power on so that it uses the microSD card for u-boot
    $ picocom -b 115200 /dev/ttyUSB1
        U-Boot 2016.07-dirty (Aug 30 2017 - 04:46:20 +0000)

               Watchdog enabled
        I2C:   ready
        DRAM:  512 MiB
        MMC:   OMAP SD/MMC: 0, OMAP SD/MMC: 1
        *** Warning - bad CRC, using default environment

        Net:   <ethaddr> not set. Validating first E-fuse MAC
        cpsw, usb_ether
        Press SPACE to abort autoboot in 2 seconds
        switch to partitions #0, OK
        mmc0 is current device
        SD/MMC found on device 0
        reading boot.scr
        ** Unable to read file boot.scr **
        reading uEnv.txt
        545 bytes read in 6 ms (87.9 KiB/s)
        Loaded env from uEnv.txt
        Importing environment from mmc0 ...
        Running uenvcmd ...
        31516 bytes read in 35 ms (878.9 KiB/s)
        Loaded am335x-boneblack.dtb
        3660208 bytes read in 231 ms (15.1 MiB/s)
        Kernel image @ 0x80008000 [ 0x000000 - 0x37d9b0 ]
        ## Flattened Device Tree blob at 81000000
           Booting using the fdt blob at 0x81000000
           Loading Device Tree to 8fff5000, end 8ffffb1b ... OK

        Starting kernel ...

        [    0.000000] Booting Linux on physical CPU 0x0
        [    0.000000] Initializing cgroup subsys cpuset
        [    0.000000] Initializing cgroup subsys cpu
        [    0.000000] Initializing cgroup subsys cpuacct
        [    0.000000] Linux version 4.4.55-cip3 (builder@490716fee4a9) (gcc version 4.9.2 (GCC) ) #1 SMP Wed Aug 30 04:44:01 UTC 2017
        [    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c5387d
        [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
        [    0.000000] Machine model: TI AM335x BeagleBone Black
        [    0.000000] cma: Reserved 16 MiB at 0x9e800000
        [    0.000000] Memory policy: Data cache writeback
        [    0.000000] CPU: All CPU(s) started in SVC mode.
        [    0.000000] AM335X ES2.1 (sgx neon )
        [    0.000000] PERCPU: Embedded 14 pages/cpu @df916000 s24960 r8192 d24192 u57344
        [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129408
        [    0.000000] Kernel command line: console=ttyO0,115200n8 root=/dev/mmcblk0p2 ro rootfstype=ext4 rootwait
        [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
        [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
        [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
        [    0.000000] Memory: 481880K/522240K available (6747K kernel code, 748K rwdata, 2280K rodata, 456K init, 8263K bss, 23976K reserved, 16384K cma-reserved, 0K highmem)
        [    0.000000] Virtual kernel memory layout:
        [    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
        [    0.000000]     fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
        [    0.000000]     vmalloc : 0xe0800000 - 0xff800000   ( 496 MB)
        [    0.000000]     lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
        [    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
        [    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
        [    0.000000]       .text : 0xc0008000 - 0xc08d9074   (9029 kB)
        [    0.000000]       .init : 0xc08da000 - 0xc094c000   ( 456 kB)
        [    0.000000]       .data : 0xc094c000 - 0xc0a07138   ( 749 kB)
        [    0.000000]        .bss : 0xc0a0a000 - 0xc121bef0   (8264 kB)
        [    0.000000] Running RCU self tests
        [    0.000000] Hierarchical RCU implementation.
        [    0.000000] 	RCU lockdep checking is enabled.
        [    0.000000] 	Build-time adjustment of leaf fanout to 32.
        [    0.000000] 	RCU restricting CPUs from NR_CPUS=2 to nr_cpu_ids=1.
        [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=32, nr_cpu_ids=1
        [    0.000000] NR_IRQS:16 nr_irqs:16 16
        [    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 5.0) with 128 interrupts
        [    0.000000] OMAP clockevent source: timer2 at 24000000 Hz
        [    0.000016] sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 89478484971ns
        [    0.000038] clocksource: timer1: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 79635851949 ns
        [    0.000084] OMAP clocksource: timer1 at 24000000 Hz
        [    0.000926] Console: colour dummy device 80x30
        [    0.000985] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
        [    0.000994] ... MAX_LOCKDEP_SUBCLASSES:  8
        [    0.001002] ... MAX_LOCK_DEPTH:          48
        [    0.001011] ... MAX_LOCKDEP_KEYS:        8191
        [    0.001018] ... CLASSHASH_SIZE:          4096
        [    0.001025] ... MAX_LOCKDEP_ENTRIES:     32768
        [    0.001033] ... MAX_LOCKDEP_CHAINS:      65536
        [    0.001041] ... CHAINHASH_SIZE:          32768
        [    0.001049]  memory used by lock dependency info: 5167 kB
        [    0.001057]  per task-struct memory footprint: 1536 bytes
        [    0.001084] Calibrating delay loop... 996.14 BogoMIPS (lpj=4980736)
        [    0.078792] pid_max: default: 32768 minimum: 301
        [    0.079178] Security Framework initialized
        [    0.079294] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
        [    0.079307] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
        [    0.082316] Initializing cgroup subsys io
        [    0.082416] Initializing cgroup subsys memory
        [    0.082508] Initializing cgroup subsys devices
        [    0.082638] Initializing cgroup subsys freezer
        [    0.082715] Initializing cgroup subsys perf_event
        [    0.082779] CPU: Testing write buffer coherency: ok
        [    0.084256] CPU0: thread -1, cpu 0, socket -1, mpidr 0
        [    0.084375] Setting up static identity map for 0x80008280 - 0x800082f0
        [    0.088107] Brought up 1 CPUs
        [    0.088132] SMP: Total of 1 processors activated (996.14 BogoMIPS).
        [    0.088142] CPU: All CPU(s) started in SVC mode.
        [    0.092265] devtmpfs: initialized
        [    0.125991] VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 3
        [    0.168223] omap_hwmod: tptc0 using broken dt data from edma
        [    0.168684] omap_hwmod: tptc1 using broken dt data from edma
        [    0.169195] omap_hwmod: tptc2 using broken dt data from edma
        [    0.177869] omap_hwmod: debugss: _wait_target_disable failed
        [    0.233229] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
        [    0.233315] futex hash table entries: 256 (order: 2, 16384 bytes)
        [    0.235831] pinctrl core: initialized pinctrl subsystem
        [    0.241220] NET: Registered protocol family 16
        [    0.246909] DMA: preallocated 256 KiB pool for atomic coherent allocations
        [    0.249157] cpuidle: using governor ladder
        [    0.249184] cpuidle: using governor menu
        [    0.258704] OMAP GPIO hardware version 0.1
        [    0.279006] No ATAGs?
        [    0.279044] hw-breakpoint: debug architecture 0x4 unsupported.
        [    0.279608] omap4_sram_init:Unable to allocate sram needed to handle errata I688
        [    0.279625] omap4_sram_init:Unable to get sram pool needed to handle errata I688
        [    0.304825] edma 49000000.edma: Legacy memcpy is enabled, things might not work
        [    0.321556] edma 49000000.edma: TI EDMA DMA engine driver
        [    0.325520] SCSI subsystem initialized
        [    0.327454] omap_i2c 44e0b000.i2c: could not find pctldev for node /ocp/l4_wkup@44c00000/scm@210000/pinmux@800/pinmux_i2c0_pins, deferring probe
        [    0.327564] omap_i2c 4819c000.i2c: could not find pctldev for node /ocp/l4_wkup@44c00000/scm@210000/pinmux@800/pinmux_i2c2_pins, deferring probe
        [    0.327805] pps_core: LinuxPPS API ver. 1 registered
        [    0.327816] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
        [    0.327869] PTP clock support registered
        [    0.332126] clocksource: Switched to clocksource timer1
        [    0.472498] NET: Registered protocol family 2
        [    0.474493] TCP established hash table entries: 4096 (order: 2, 16384 bytes)
        [    0.474591] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
        [    0.475794] TCP: Hash tables configured (established 4096 bind 4096)
        [    0.475995] UDP hash table entries: 256 (order: 2, 20480 bytes)
        [    0.476170] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
        [    0.477025] NET: Registered protocol family 1
        [    0.478747] RPC: Registered named UNIX socket transport module.
        [    0.478774] RPC: Registered udp transport module.
        [    0.478785] RPC: Registered tcp transport module.
        [    0.478795] RPC: Registered tcp NFSv4.1 backchannel transport module.
        [    0.481467] hw perfevents: enabled with armv7_cortex_a8 PMU driver, 5 counters available
        [    0.486320] audit: initializing netlink subsys (disabled)
        [    0.486570] audit: type=2000 audit(0.480:1): initialized
        [    0.491221] VFS: Disk quotas dquot_6.6.0
        [    0.491398] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
        [    0.494203] NFS: Registering the id_resolver key type
        [    0.494574] Key type id_resolver registered
        [    0.494589] Key type id_legacy registered
        [    0.494789] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
        [    0.500212] io scheduler noop registered
        [    0.500249] io scheduler deadline registered
        [    0.500307] io scheduler cfq registered (default)
        [    0.502562] pinctrl-single 44e10800.pinmux: 142 pins at pa f9e10800 size 568
        [    0.505011] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
        [    0.510658] omap_uart 44e09000.serial: no wakeirq for uart0
        [    0.511293] 44e09000.serial: ttyO0 at MMIO 0x44e09000 (irq = 155, base_baud = 3000000) is a OMAP UART0
        [    1.255643] console [ttyO0] enabled
        [    1.297305] brd: module loaded
        [    1.323655] loop: module loaded
        [    1.329351] mtdoops: mtd device (mtddev=name/number) must be supplied
        [    1.402140] davinci_mdio 4a101000.mdio: davinci mdio revision 1.6
        [    1.408526] davinci_mdio 4a101000.mdio: detected phy mask fffffffe
        [    1.418847] libphy: 4a101000.mdio: probed
        [    1.423209] davinci_mdio 4a101000.mdio: phy[0]: device 4a101000.mdio:00, driver SMSC LAN8710/LAN8720
        [    1.434040] cpsw 4a100000.ethernet: Detected MACID = d0:5f:b8:ef:b7:5f
        [    1.446142] mousedev: PS/2 mouse device common for all mice
        [    1.452133] i2c /dev entries driver
        [    1.457446] omap_hsmmc 48060000.mmc: Got CD GPIO
        [    1.539686] mmc0: host does not support reading read-only switch, assuming write-enable
        [    1.548658] ledtrig-cpu: registered to indicate activity on CPUs
        [    1.556210] oprofile: using arm/armv7
        [    1.560907] Initializing XFRM netlink socket
        [    1.565874] NET: Registered protocol family 10
        [    1.572408] mmc0: new high speed SDHC card at address 59b4
        [    1.580993] mmcblk0: mmc0:59b4 USDU1 7.37 GiB
        [    1.590752] sit: IPv6 over IPv4 tunneling driver
        [    1.598062] NET: Registered protocol family 17
        [    1.602911] NET: Registered protocol family 15
        [    1.607939] Key type dns_resolver registered
        [    1.612661] omap_voltage_late_init: Voltage driver support not added
        [    1.619315] sr_dev_init: No voltage domain specified for smartreflex0. Cannot initialize
        [    1.627809] sr_dev_init: No voltage domain specified for smartreflex1. Cannot initialize
        [    1.637436] ThumbEE CPU extension supported.
        [    1.642287] Registering SWP/SWPB emulation handler
        [    1.647324] SmartReflex Class3 initialized
        [    1.653262]  mmcblk0: p1 p2
        [    1.708908] mmc1: MAN_BKOPS_EN bit is not set
        [    1.714311] tps65217 0-0024: TPS65217 ID 0xe version 1.2
        [    1.720820] omap_i2c 44e0b000.i2c: bus 0 rev0.11 at 400 kHz
        [    1.731202] omap_i2c 4819c000.i2c: bus 2 rev0.11 at 100 kHz
        [    1.738932] hctosys: unable to open rtc device (rtc0)
        [    1.744360] sr_init: No PMIC hook to init smartreflex
        [    1.749868] sr_init: platform driver register failed for SR
        [    1.778681] mmc1: new high speed MMC card at address 0001
        [    1.789040] mmcblk1: mmc1:0001 MMC04G 3.60 GiB
        [    1.800468] mmcblk1boot0: mmc1:0001 MMC04G partition 1 2.00 MiB
        [    1.810530] mmcblk1boot1: mmc1:0001 MMC04G partition 2 2.00 MiB
        [    1.822780] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
        [    1.831431] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
        [    1.840959]  mmcblk1: p1 p2
        [    1.858339] devtmpfs: mounted
        [    1.862477] Freeing unused kernel memory: 456K (c08da000 - c094c000)

        Debian GNU/Linux 8 (none) /dev/ttyO0

        (none) login: root

        The programs included with the Debian GNU/Linux system are free software;
        the exact distribution terms for each program are described in the
        individual files in /usr/share/doc/*/copyright.

        Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
        permitted by applicable law.
        login[83]: root login on 'ttyO0'


        BusyBox v1.22.1 (2017-08-30 04:08:50 UTC) built-in shell (ash)
        Enter 'help' for a list of built-in commands.

        # uname -a
        Linux (none) 4.4.55-cip3 #1 SMP Wed Aug 30 04:44:01 UTC 2017 armv7l GNU/Linux

