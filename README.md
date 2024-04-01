<!-- TODO, J? -->
# PiPLC <!-- omit in toc -->

[![License: CC BY-SA 4.0](https://img.shields.io/badge/license-CC%20BY--SA%204.0-blue?style=flat-square)](https://creativecommons.org/licenses/by-sa/4.0/)
[![Shop: Tindie](https://img.shields.io/badge/shop-Tindie-blue?style=flat-square)](https://www.tindie.com/stores/binary-6/?ref=offsite_badges&utm_source=sellers_Chrismettal&utm_medium=badges&utm_campaign=badge_medium)
[![Donations: Coffee](https://img.shields.io/badge/donations-Coffee-brown?style=flat-square)](https://github.com/Chrismettal#donations)

This is a work in progress for a Raspberry Pi breakout board + DIN rail case to use Pis in PLC-like industrial situations.

The design relies on a Raspberry Pi 4 for all functions to work. Pi 5 is currently untested, while Pi 3 and below don't allow for all functions to be used.

The PiPLC is intended to be used with [Home Assistant](https://www.home-assistant.io/), as well as [OpenPLC](https://autonomylogic.com/).
Obviously, since it's just a breakout board for any Pi, you can run whatever software you want, but Home Assistant and OpenPLC are the ones inspiring the design of this project.

**IO featured on board the PLC are:**

- 8 x 24 V tolerant optocoupled inputs
- 8 x 16A Relays (250 V AC / 24 V DC)
- KNX TP
- Modbus RTU / RS-485
- I²C
- 2 x analog 3.3 V PWM outputs

All the parts are or will be stocked at Tindie!

<a href="https://www.tindie.com/stores/binary-6/?ref=offsite_badges&utm_source=sellers_Chrismettal&utm_medium=badges&utm_campaign=badge_medium"><img src="https://d2ss6ovg47m0r5.cloudfront.net/badges/tindie-mediums.png" alt="I sell on Tindie" width="150" height="78"></a>

**If you like my work please consider [supporting me](https://github.com/Chrismettal#donations)!**

## Table of contents <!-- omit in toc -->

- [GPIO mapping](#gpio-mapping)
- [Pinout](#pinout)
- [I/O](#io)
    - [J1 | Power Input](#j1--power-input)
    - [J2 | Modbus](#j2--modbus)
    - [J3 - J6 | Digital Outputs (Q1-8)](#j3---j6--digital-outputs-q1-8)
    - [J7 | PWM](#j7--pwm)
    - [J8 | I²C](#j8--ic)
    - [J9 | 1-Wire](#j9--1-wire)
    - [J10 - J12 | Digital Inputs (I1-8)](#j10---j12--digital-inputs-i1-8)
    - [Wago header | KNX / NCN5121](#wago-header--knx--ncn5121)
- [On board devices](#on-board-devices)
    - [PCF8523 RTC](#pcf8523-rtc)
- [Example Hardware](#example-hardware)
- [Software](#software)
    - [OpenPLC](#openplc)
        - [Installation](#installation)
        - [Example](#example)
    - [Home Assistant](#home-assistant)
        - [Installation](#installation-1)
        - [Example](#example-1)
    - [Codesys](#codesys)
        - [Installation](#installation-2)
        - [Example](#example-2)
- [Raspberry pi configuration](#raspberry-pi-configuration)
    - [`/boot/config.txt`](#bootconfigtxt)
    - [`/boot/cmdline.txt`](#bootcmdlinetxt)
- [Making your own](#making-your-own)
    - [Boards](#boards)
        - [Mainboard](#mainboard)
        - [HMI](#hmi)
        - [Frontpanel](#frontpanel)
        - [Pi Riser](#pi-riser)
        - [HMI Riser](#hmi-riser)
    - [3D printing](#3d-printing)
    - [Testing](#testing)
- [Tools used](#tools-used)
- [Sources](#sources)
- [Donations](#donations)
- [License](#license)

---

## GPIO mapping

| GPIO Name | PiPLC function           | OpenPLC                | Home Assistant               | Codesys                |
| :-------: | :----------------------- | :--------------------- | :--------------------------- | :--------------------- |
| `GPIO_02` | :blue_square: I²C SDA    | :warning: TODO driver? | :warning: To be tested       | :warning: To be tested |
| `GPIO_03` | :blue_square: I²C SCL    | :warning: TODO driver? | :warning: To be tested       | :warning: To be tested |
| `GPIO_04` | :blue_square: Modbus TX  | `/dev/ttyAMA3`         | `/dev/ttyAMA3`               | :warning: To be tested |
| `GPIO_05` | :blue_square: Modbus RX  | `/dev/ttyAMA3`         | `/dev/ttyAMA3`               | :warning: To be tested |
| `GPIO_06` | :blue_square: Modbus RTS | `/dev/ttyAMA3`         | `/dev/ttyAMA3`               | :warning: To be tested |
| `GPIO_07` | :red_square: Q4          | `%QX0.3`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_08` | :red_square: Q3          | `%QX0.2`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_09` | :yellow_square: I5       | `%IX0.4`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_10` | :yellow_square: I4       | `%IX0.3`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_11` | :yellow_square: I6       | `%IX1.5`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_12` | :red_square: Q5          | `%QX0.4`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_13` | :yellow_square: I7       | `%IX0.6`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_14` | :blue_square: KNX TX     | :x:                    | `/dev/ttyAMA0`               | :warning: To be tested |
| `GPIO_15` | :blue_square: KNX RX     | :x:                    | `/dev/ttyAMA0`               | :warning: To be tested |
| `GPIO_16` | :red_square: Q6          | `%QX0.5`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_17` | :yellow_square: I1       | `%IX0.0`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_18` | :orange_square: PWM_0    | `%QW0`                 | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_19` | :orange_square: PWM_1    | `%QW1`                 | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_20` | :red_square: Q7          | `%QX0.6`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_21` | :red_square: Q8          | `%QX0.7`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_22` | :yellow_square: I3       | `%IX0.2`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_23` | :blue_square: 1-Wire     | :warning: TODO driver? | :warning: To be tested       | :warning: To be tested |
| `GPIO_24` | :red_square: Q1          | `%QX0.0`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_25` | :red_square: Q2          | `%QX0.1`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_26` | :yellow_square: I8       | `%IX0.7`               | :white_check_mark: TODO Link | :warning: To be tested |
| `GPIO_27` | :yellow_square: I2       | `%IX0.1`               | :white_check_mark: TODO Link | :warning: To be tested |

Pins marked unusable with OpenPLC are either not broken out, or differ too much from OpenPLC's mapping. As OpenPLC's mapping is immutable, these pins might not be used if PiPLC is used with the OpenPLC runtime and Pi default hardware layer.

## Pinout

![Pinout](/doc/PiPLC_Pinout.drawio.svg)

---

## I/O

### J1 | Power Input

|    1    |    2    |   3   |   4   |
| :-----: | :-----: | :---: | :---: |
| `+24 V` | `+24 V` | `GND` | `GND` |
 
The PiPLC is to be supplied with 24 V and requires at least a TODO power supply under full load.
(Full load measured with TODO mA @ 24 V with all relays closed, all DI HIGH, transmitting over KNX and I²C, connected to Wifi and with the Pi at 100% CPU load without overclocking)

While it will theoretically work at 12 V, the relays used for `Q1-8` require 24V coil voltage to trigger. If you are not placing the relays, feel free to supply your PLC with 12 V though.

Internally, 5V is generated by a `TPS54331D` based DC-DC converter. 
At `J10` 12/24V is passed through unprotected from the power input. 
At `J2` and `J8` 5 V from the DC-DC can be used to draw up to 500mA (protected through a polyfuse). 
At `J3`, 3V3 from the RPI can be used to draw up to 500mA (protected through a polyfuse)

---

### J2 | Modbus

|   1    |            2             |            3             |   4   |
| :----: | :----------------------: | :----------------------: | :---: |
| `+5 V` | :blue_square: `Modbus B` | :blue_square: `Modbus A` | `GND` |

Modbus is an industrial communication protocol often used with PLCs communicating with I/O extensions or other PLCs. 
The wire based one used here is called `Modbus RTU` and is based on half-duplex RS-485 so the header can also be used for that if you dislike Modbus. 

OpenPLC natively supports Modbus to talk to I/O, while Home Assistant has a [Modbus integration](https://www.home-assistant.io/integrations/modbus/).

> [!NOTE]  
> To enable Modbus on your Pi, make sure to enable `UART3` at GPIO5/06.
> This UART is not enabled by default and is only present on Raspberry Pi models 4 and up!
>
> We do NOT enable the `ctsrts` option as we don't want to run with hardware handshakes. We do however need to set/unset the `DE/NRE` pins of the RS485 transceiver IC. How to do this differs based on the chose OS.
>
> In `/boot/config.txt` add:
> 
> `dtoverlay=uart3`
>
> and reboot afterwards
>
> After rebooting you should see the new serial port `/dev/ttyAMA3` when executing `ls /dev/tty*`
>
> For OpenPLC, if you followed the [installation guide](#installation) you should have installed my fork that includes `DE/NRE` control via `GPIO_6` so there should be nothing else for you to do
>
> For Home Assistant, TODO hardware change documentation

<details>
<summary>Further reading</summary>

https://raspberrypi.stackexchange.com/questions/104464/where-are-the-uarts-on-the-raspberry-pi-4 

https://raspberrypi.stackexchange.com/questions/45570/how-do-i-make-serial-work-on-the-raspberry-pi3-pizerow-pi4-or-later-models/107780#107780

</details>

---

### J3 - J6 | Digital Outputs (Q1-8)

**J3**

|         1         |         2         |         3         |         4         |
| :---------------: | :---------------: | :---------------: | :---------------: |
| :red_square: `Q1` | :red_square: `Q1` | :red_square: `Q2` | :red_square: `Q2` |

**J4**

|         1         |         2         |         3         |         4         |
| :---------------: | :---------------: | :---------------: | :---------------: |
| :red_square: `Q3` | :red_square: `Q3` | :red_square: `Q4` | :red_square: `Q4` |

**J5**

|         1         |         2         |         3         |         4         |
| :---------------: | :---------------: | :---------------: | :---------------: |
| :red_square: `Q5` | :red_square: `Q5` | :red_square: `Q6` | :red_square: `Q6` |

**J6**

|         1         |         2         |         3         |         4         |
| :---------------: | :---------------: | :---------------: | :---------------: |
| :red_square: `Q7` | :red_square: `Q7` | :red_square: `Q8` | :red_square: `Q8` |

8 digital outputs are found at the pottom of the device. These outputs are driven by `G5RL-1A-E-TV8` relays theoretically capable of **16 A at 250 V AC** / **16 A at 24 V DC**. 

As with the digital inputs, each output features a status LED found on the HMI subboard.

> [!WARNING]
> As this the PiPLC is an open source passion project and not externally rated by TÜV or a similar agency, usage of these relays in mains powered systems is at your own risk.
> 
> All components chosen are rated for 16 A at 250 V AC and should be capable of driving everything in a home environment.
> 
> Only certified electricians should ever be performing mains work, and home-built devices should never be connected to mains power unless you know what you are doing.

---

### J7 | PWM

|            1            |            2            |   3   |   4   |
| :---------------------: | :---------------------: | :---: | :---: |
| :orange_square: `PWM 0` | :orange_square: `PWM 1` | `GND` | `GND` |

The PWM outputs are intentionally bare, unprotected GPIO connections of `GPIO_18` for `PWM 0` and `GPIO_19` for `PWM 1` so take care not to damage the Pi here. 
If choosing to use the GPIO as inputs, bear in mind that the Pi's GPIO are only 3.3 V tolerant.

Choosing to actually use the PWM outputs, you have both hardware PWM's available to you here.

> [!WARNING]
> Unprotected access to `GPIO_18` and `GPIO_19`. Take care not to damage your Pi!

---

### J8 | I²C

|   1    |   2   |            3            |            4            |
| :----: | :---: | :---------------------: | :---------------------: |
| `+5 V` | `GND` | :blue_square: `I²C SDA` | :blue_square: `I²C SCL` |

Here you have a protected, somewhat isolated 5 V tolerant I²C header with integrated pullups. This was at first intended for connecting to extensions, but the Modbus header takes care of that now.
You do have the option however, to attach whatever I²C device you want, provided the runtime you are using supports I²C communication.

> [!WARNING]
> The I²C contacts are already pulled up to 5 V so do not connect any 3.3 V only I²C devices directly without isolation!

> [!NOTE]
> To enable I²C, go into `/boot/config.txt` and uncomment `dtparam=i2c_arm=on`, or alternatively enable I²C through `sudo raspi-config`
>
> You might need to install `i2c-tools` with `sudo apt install i2c-tools` to test your I²C connections. 
>
> `i2cdetect -y 1` should show the adresses of all found I²C devices afterwards

---

### J9 | 1-Wire

|     1     |   2   |           3            |           4            |
| :-------: | :---: | :--------------------: | :--------------------: |
| `+ 3.3 V` | `GND` | :blue_square: `1-Wire` | :blue_square: `1-Wire` |

This header contains `GPIO_04` for native 1-Wire capability. 

1-Wire is usually used for temperature sensors, like `DS18B20`, or battery voltage sensing, but is sometimes also used for access control with iButtons.

> [!WARNING]
> Unprotected access to `GPIO_04`. Take care not to damage your Pi!

> [!NOTE]
> To enable 1-Wire, add the following to `/boot/config.txt`:
> 
> `dtoverlay=w1-gpio,gpiopin=23`
>
> reboot
>
> You should be able to find any connected 1-Wire devices automatically with `ls /sys/bus/w1/devices/` afterwards

---

### J10 - J12 | Digital Inputs (I1-8)

**J10**

|    1    |    2    |    3    |    4    |
| :-----: | :-----: | :-----: | :-----: |
| `+24 V` | `+24 V` | `+24 V` | `+24 V` |

**J11**

|          1           |          2           |          3           |          4           |
| :------------------: | :------------------: | :------------------: | :------------------: |
| :yellow_square: `I4` | :yellow_square: `I3` | :yellow_square: `I2` | :yellow_square: `I1` |

**J12**

|          1           |          2           |          3           |          4           |
| :------------------: | :------------------: | :------------------: | :------------------: |
| :yellow_square: `I8` | :yellow_square: `I7` | :yellow_square: `I6` | :yellow_square: `I5` |


8 digital inputs are found at the top of the device. These inputs are 5-24 V tolerant current sinking inputs through `EL817C` optocouplers. 
J10 features 24 V outputs to easily supply switches or other sensors feeding back into J11-J12 as inputs.

All inputs feature a status//Order is intentional to match the GPIO mapping table of PiPLC at https://github.com/chrismettal/piplc#gpio-mapping
//while having all relays mapped "in order" from left to right LED driven by the optocoupler output, thus not loading the input. 

On the Raspberry side, pullups need to be enabled on the GPIOs to enable reading from these input stages.

Input currents are as follows:

| Voltage | Input current |
| ------- | ------------- |
| 5 V     | TODO mA       |
| 12 V    | TODO mA       |
| 24 V    | 5 mA          |

---

### Wago header | KNX / NCN5121

Utilizing [knxd](https://github.com/knxd/knxd/tree/main) to run a [NCN5121](https://www.onsemi.com/pdf/datasheet/ncn5121-d.pdf) KNX transceiver chip the PiPLC can talk to KNX networks natively, without going through an actual KNX-IP gateway first. (Internally, knxd looks like a KNX-IP gateway, but it won't route through your actual LAN)

For Home Assistant, there is [an addon for knxd](https://github.com/da-anda/hass-io-addons/tree/main/knxd), so Home Assistant sees the internal NCN5121 as a KNX-IP gateway @ localhost.

See the [knxd documentation](https://github.com/knxd/knxd/blob/main/doc/inifile.rst#ncn5120) for specifics on how to use the driver if you are not using Home Assistant.

In this board, the `NC5121` is NOT supplied through the KNX supply, but through the Pi's `3v3` rail. This means that it doesn't need to be taken into account when calculating the KNX power supply needs.

> [!NOTE]  
> To enable KNX, make sure to disable bluetooth and the serial console on your Pi
> This is required to enable full `UART0` at GPIO14/15
>
> In `/boot/config.txt` add:
> 
> `dtoverlay=pi3-disable-bt`
>
> In `/boot/cmdline.txt` remove:
> 
> `console=serial0,115200` or `console=ttyAMA0,115200` if found
>
> reboot
>
> In your OS, `/dev/ttyAMA0` can now be used as your KNX interface
>
> TODO add OpenPLC installation steps

---

## On board devices

### PCF8523 RTC

A `PCF8523` based realtime clock is present on the board so the PiPLC can keep track of time even when its 24 V input drops.

> [!NOTE]  
>
> To enable the real time clock on your Pi, add the following to `/boot/config.txt`:
>
> `dtoverlay=i2c-rtc,pcf8523`
>
> And reboot afterwards.
>
> Enabling RTC in the Pi and setting the time correctly is explained well in [Adafruit's RTC guide](https://learn.adafruit.com/adding-a-real-time-clock-to-raspberry-pi/set-rtc-time).

---


## Example Hardware

![TestBoardSchematic](/doc/PiPLC_Testboard.drawio.svg)

This is the testing "schematic" used for all software examples. It demonstrates all interfaces present on-board and all testing of PiPLC was done in this configuration.

|   GPIO Name    | PiPLC function        | Device                               |
| :------------: | :-------------------- | :----------------------------------- |
| `GPIO_02 - 03` | :blue_square: I²C     | `PCA9685` 16 Ch. PWM servo driver    |
| `GPIO_04 - 06` | :blue_square: Modbus  | EBYTE `MA01-XACX0440` I/O Module     |
| `GPIO_04 - 06` | :blue_square: Modbus  | ARCELI `SHT20` Temp + Humidity probe |
|   `GPIO_24`    | :red_square: Q1       | 230 V Light                          |
|   `GPIO_08`    | :red_square: Q3       | Stacklight Green Channel             |
|   `GPIO_07`    | :red_square: Q4       | Stacklight Yellow Channel            |
|   `GPIO_12`    | :red_square: Q5       | Stacklight Red Channel               |
|   `GPIO_17`    | :yellow_square: I1    | `S0` Home power meter                |
|   `GPIO_27`    | :yellow_square: I2    | Light switch                         |
|   `GPIO_22`    | :yellow_square: I3    | Emergency Stop NO                    |
|   `GPIO_10`    | :yellow_square: I4    | Emergency Stop NC                    |
|   `GPIO_09`    | :yellow_square: I5    | Toggle Switch left                   |
|   `GPIO_11`    | :yellow_square: I6    | Toggle Switch right                  |
|   `GPIO_13`    | :yellow_square: I7    | Green button                         |
|   `GPIO_26`    | :yellow_square: I8    | Red button                           |
| `GPIO_14 - 15` | :blue_square: KNX     | 4 Ch. Relay                          |
|   `GPIO_18`    | :orange_square: PWM_0 | Dimmable LED                         |
|   `GPIO_19`    | :orange_square: PWM_1 | Dimmable LED                         |
|   `GPIO_23`    | :blue_square: 1-Wire  | `DS18B20` Temperature probe          |
|      USB       | USB                   | Arduino Uno (OpenPLC Slave Firmware) |
|   RJ45 Jack    | EtherCAT              | TBD                                  |
|      Wifi      | LAN access            | Android Tablet as HMI                |
|      Wifi      | LAN access            | Programming device (Laptop)          |


There is an example chinesium Modbus I/O module on the testing board with the following information:

| Parameter                 | Value                     |
| :------------------------ | :------------------------ |
| Device Type               | Generic Modbus RTU Device |
| Slave ID                  | 32                        |
| COM Port                  | `/dev/ttyAMA3`            |
| Baudrate                  | 9600                      |
| Parity                    | None                      |
| Data bits                 | 8                         |
| Stop bits                 | 1                         |
| Transmission Pause        | 0                         |
| Discrete Inputs           | Address 0, Size 0         |
| Coils                     | Address 0, Size 4         |
| Input Registers           | Address 0, Size 0         |
| Holding Registers - Read  | Address 0, Size 0         |
| Holding Registers - Write | Address 0, Size 0         |


---

## Software

### OpenPLC

[OpenPLC](https://autonomylogic.com/) is a Fully `IEC 61131-3` compliant, open source, multi-hardware programmable logic controller suite.

Consisting of a separate runtime and editor, it can run on regular PCs as a soft PLC, as well as a multitude of embedded systems. (Think Beckhoff XAR / XAE)

I am currently creating a hardware layer for PiPLC at https://github.com/Chrismettal/OpenPLC_v3. This should allow easy adressing of all IO while enabling native use of Modbus and other interfaces. The regular "Rpi" layer should also be compatible, but I²C, Modbus and KNX might not work, and I1-8 / Q1-8 adressing might be a bit unintuitive (See [GPIO mapping table](##-GPIO-mapping))

#### Installation

<details>
<summary>Click to expand</summary>

1. You are going to need a fresh installation of [Raspberry Pi OS](https://www.raspberrypi.com/software/) on your Pi 4. There is an official [getting started guide](https://www.raspberrypi.com/documentation/computers/getting-started.html) that is being kept up to date, so the first steps are not further described here.

2. Execute `git clone https://github.com/chrismettal/OpenPLC_v3` on your Pi. This will clone a forked version of the OpenPLC runtime that contains some changes to make it compatible with PiPLC. Should these changes get merged, this link will be changed to point to the official version.

3. `cd OpenPLC_v3` to enter the just cloned folder

4. `./install rpi` will start the full OpenPLC installation. (This will take a few minutes)

5. After a reboot, your OpenPLC installation's webinterface should be accessible on port 8080 on your Pi. Either try to access it at `127.0.0.1:8080` locally on your pi, or access it through your Pi's IP adress in your host computer.

6. The default credentials will be `Name: openplc`, `Password: openplc`. You might want to change these right after logging in for the first time. To do so, use the "Users" tab and edit the default "openplc" account:

![OpenPLCUsers](/img/OpenPLCManual/Users.png)

7. Head over to the "Hardware" tab to select the hardware layer. Select and save the "PiPLC" layer (Exact name might differ once merged upstream):

![OpenPLCHardware](/img/OpenPLCManual/Hardware.png)

8. That should be it for a base installation. You should now have access to D1-8 and Q1-8 already, but you won't see Modbus RTU yet for slave devices. Instructions how to enable the Modbus COM port are found at [J2 | Modbus](#j2--modbus).

9. After enabling UART3 [as described above](#j2--modbus) and rebooting your Pi, you should see `/dev/ttyAMA3` be available as a COM port for Modbus slaves:

![ModbusCOM](/img/OpenPLCManual/ModbusCOM.png)

10. That's all there is to install the base OpenPLC install. There is currently no easy way to enable KNX or 1-Wire connectivity, and while I²C connectivity from OpenPLC is possible, it is currently not implemented in the hardware layer. All of these might be done in future within said hardware layer. See the usage example below for further information. Also see the [OpenPLC getting started guide](https://autonomylogic.com/docs/openplc-overview/) for general instructions on how to upload code to your OpenPLC instance

</details>

#### Example

TODO link to project

---

### Home Assistant

[Home Assistant](https://www.home-assistant.io/) is an open source smart-home automation software, that provides logic, visualization and automation in a single place. It allows you to connect practically everything to your home under one interface, awakening your smart home.

Home Assistant seems to move away from local hardware IO a bit, instead focussing on devices in your LAN / WiFi. That doesn't mean though, that it isn't fully capable of running on an actual PLC, giving you control of your devices without a middle man or WiFi shenanigans. This is where the `NC5121` KNX interface comes into play, which enables you to talk to a vast variety of off-the-shelf decentralised ACTUAL smart home components (No supplier apps, no accounts, no telemetry) without needing to go through an KNX-IP interface first.

#### Installation

<details>
<summary>Click to expand</summary>

1. Follow the [official first steps](https://www.home-assistant.io/installation/raspberrypi) for a standard Home Assistant Raspberry Pi installation

2. Also follow the [official onboarding steps](https://www.home-assistant.io/getting-started/onboarding/) to create your Home Assistant account and generally be able to use the system

3. Power down your Home Assistant install and take out the SD card

4. Install the SD card in a linux computer

5. Mount the first partition (Should be a 32MB one) temporarily to your system:

```
mkdir ~/TempMount

sudo mount -t vfat /dev/sdx1 ~/TempMount
```

6. In the now mounted `TempMount` directory, you will find `Config.txt` where we can set dtoverlays to enable additional serial ports etc.

7. Follow both the [KNX enabling guide](#wago-header--knx--ncn5121) as well as the [Modbus enabling guide](#j2--modbus), adding their specific dtoverlays to `Config.txt`. This will make sure the Pi knows to enable the required UART connections there.

8. You can now unmount the drive with `sudo umount ~/TempMount` and put the SD card back in your Pi before booting Home Assistant back up

9. To enable KNX communication, you'll need to install the [knxd addon](https://github.com/da-anda/hass-io-addons). 

10. Configure the `knxd` daemon as shown in the following picture. The `/dev/ttyAMA0` interface makes sure we are talking to our on-board `NC5121`. Theoretically you could also use a KNX-USB interface if you weren't using the PiPLC board. Don't forget to start the daemon and set it to autostart.

![knxaddon](/img/HAManual/knxaddon.png)

11. Once the `knxd` deamon is running install the `KNX` integration:

![KNX integration](knxintegration.png)

12. During initial setup of the `KNX` integration, it should find your local `knxd` daemon instance as a valid interface.

13. TODO modbus

</details>

#### Example

TODO link to project

---

### Codesys

Codesys, like OpenPLC is a `IEC 61131-3` compliant PLC runtime, compatible with PiPLC. It is not open source and the [license for the RPI runtime](https://store.codesys.com/codesys-control-for-raspberry-pi-sl.html) costs about 55€. PiPLC was designed for OpenPLC but Codesys (as of 2024-01) is a much more robust runtime with more features.

As Codesys is proprietary, I won't be focussing much on it, but I want to make sure that most functions work well with PiPLC.

#### Installation

<details>
<summary>Click to expand</summary>

1. Setup your Pi with a fresh install of Pi OS. I only had luck using the "legacy" 32 Bit Debian Buster install and not the most recent (as of 2024-02) Debian Bookworm. (Wiringpi?)

2. Follow the [Codesys Pi FAQ](https://faq.codesys.com/display/CDSFAQ/Raspberry+Pi%3A+FAQ) to install the runtime on your Pi as well as to get your engineering system set up

3. After enabling UART3 [as described above](#j2--modbus) and rebooting your Pi, you can set `/dev/ttyAMA3` to be your Modbus master port:

TODO Modbus port image

TODO I²C port settings
TODO 1-Wire port settings

</details>

#### Example

TODO link to project

---

## Raspberry pi configuration

### `/boot/config.txt`

```
# PiPLC
dtoverlay=uart3
dtoverlay=pi3-disable-bt
dtoverlay=w1-gpio,gpiopin=23
dtoverlay=i2c-rtc,pcf8523
```

### `/boot/cmdline.txt`

remove `console=serial0,115200` and/or `console=ttyAMA0,115200` if found.

---

## Making your own

### Boards

A full PiPLC consists of several subboards that need to be manufactured individually. 
Theoretically only the mainboard is technically required, as you could use wires to manually connect the Pi to the PLC 
as well as just not using the HMI as it is only a status display at the moment, 
but the existing 3D printable case assumes all boards to be used.

Only the main board has SMD parts that need to be assembled, so only one board will need to go through PCBA.

All boards are designed to be manufactured by JLCPCB, with BOMs using LCSC partnumbers attached.
ALso all boards are to be manufactured with regular 1.6mm thickness, lead free HASL and 1oz copper weight.

---

#### Mainboard

![Render_Mainboard](/img/Render_Mainboard.png)

[Interactive Bom / Online view](https://htmlpreview.github.io/?https://raw.githubusercontent.com/Chrismettal/PiPLC/master/pcb/PiPLC-Mainboard/bom/ibom.html)

This board houses all logic and is the only one that benefits from a PCBA service. All other boards plug into here, including the Raspberry Pi.

---

#### HMI

![Render_HMI](/img/Render_HMI.png)

[Interactive Bom](https://htmlpreview.github.io/?https://raw.githubusercontent.com/Chrismettal/PiPLC/master/pcb/PiPLC-HMI/bom/ibom.html)

While not strictly required, this board houses frontpanel LEDs for status view of digital inputs and outputs, as well as 5V and 24V power status LEDs.

Additionally, the Wago header to plug into a KNX network is housed on this board.

---

#### Frontpanel

![Render_Frontpanel](/img/Render_Frontpanel.png)

[Interactive Bom / Online view](https://htmlpreview.github.io/?https://raw.githubusercontent.com/Chrismettal/PiPLC/master/pcb/PiPLC-Frontpanel/bom/ibom.html)

Purely for decoration / labelling. No electrical connections here. Can theoretically be replaced by a sticker.

---

#### Pi Riser

![Render_PiRiser](/img/Render_PiRiser.png)

[Interactive Bom / Online view](https://htmlpreview.github.io/?https://raw.githubusercontent.com/Chrismettal/PiPLC/master/pcb/PiPLC-PiRiser/bom/ibom.html)

Riser board to give the Pi enough clearance to connect face-down to the mainboard. Can theoretically be replaced by a ribbon cable.

---

#### HMI Riser

![Render_HmiRiser](/img/Render_HmiRiser.png)

[Interactive Bom / Online view](https://htmlpreview.github.io/?https://raw.githubusercontent.com/Chrismettal/PiPLC/master/pcb/PiPLC-HmiRiser/bom/ibom.html)

Riser board to connect the HMI board to the mainboard. Can theoretically be replaced by a ribbon cable

---

### 3D printing

3D printable parts are currently being designed.

The case is intended to be printed in a isolating and/or flame retardant filament like PC or PETG VO. 

---

### Testing

The following commands can be used to test your hardware configuration without installing PLC code or a full Home Assistant install. These are to be executed on a regular Pi OS install with `raspi-gpio` installed.

- Enable pull ups on all input pins

`raspi-gpio set 17,27,22,10,9,11,13,26 pu`

- Set all output relay pins to be outputs

`raspi-gpio set 24,25,8,7,12,16,20,21 op`

- Read state of all input pins

`raspi-gpio get 17,27,22,10,9,11,13,26`

- Set individual relays HIGH/LOW (See [GPIO mapping](#gpio-mapping))

`raspi-gpio set 24 dh` / `raspi-gpio set 24 dl`

- Detect connected I²C devices (Should show found addresses in the grid if properly connected)

`i2cdetect -y 1`

---

## Tools used

- FreeCAD 0.21.2
  - KicadStepUp Workbench 10.20.7
- KiCAD 7.0.9

---

## Sources

- Wago 243-211 KNX Connector 3D file - https://grabcad.com/library/knx-connector-1
- Raspberry Pi 3D file - https://grabcad.com/library/raspberry-pi-4-model-b-1
- PCB Standoffs 3D files - https://grabcad.com/library/ettinger-standoff-nickel-plated-brass-m-f-m2-m8-1/details?folder_id=12725833

---

## Donations

**If you like my work please consider [supporting me](https://github.com/Chrismettal#donations)!**

---

## License

 <a rel="CClicense" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
