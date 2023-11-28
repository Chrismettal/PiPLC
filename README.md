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
- [Software](#software)
  - [OpenPLC](#openplc)
  - [Home Assistant](#home-assistant)
  - [Codesys](#codesys)
- [Making your own](#making-your-own)
  - [Boards](#boards)
    - [Mainboard](#mainboard)
    - [HMI](#hmi)
    - [Frontpanel](#frontpanel)
    - [Pi Riser](#pi-riser)
    - [HMI Riser](#hmi-riser)
  - [3D printing](#3d-printing)
- [Tools used](#tools-used)
- [Sources](#sources)
- [Donations](#donations)
- [License](#license)

---

## GPIO mapping

| GPIO Name | RPI Header<br>Pin Nbr | PiPLC naming                  | OpenPLC<br>RPI mapping | Usable with<br>OpenPLC                         |
| :-------: | :-------------------: | :---------------------------- | :--------------------: | :--------------------------------------------- |
| `GPIO_02` |         `03`          | :blue_square: I²C SDA         |        `%IX0.0`        | :warning: TODO I²C through driver?             |
| `GPIO_03` |         `05`          | :blue_square: I²C SCL         |        `%IX0.1`        | :warning: TODO I²C through driver?             |
| `GPIO_04` |         `07`          | :blue_square: Modbus UART TX  |        `%IX0.2`        | :warning: TODO Modbus through driver?          |
| `GPIO_05` |         `29`          | :blue_square: Modbus UART RX  |        `%IX1.1`        | :warning: TODO Modbus through driver?          |
| `GPIO_06` |         `31`          | :blue_square: Modbus UART RTS |        `%IX1.2`        | :warning: TODO Modbus through driver?          |
| `GPIO_07` |         `26`          | :red_square: Q4               |        `%QX0.6`        | :white_check_mark: Relay output                |
| `GPIO_08` |         `24`          | :red_square: Q3               |        `%QX0.5`        | :white_check_mark: Relay output                |
| `GPIO_09` |         `21`          | :yellow_square: I5            |        `%IX0.7`        | :white_check_mark: Protected input             |
| `GPIO_10` |         `19`          | :yellow_square: I4            |        `%IX0.6`        | :white_check_mark: Protected input             |
| `GPIO_11` |         `23`          | :yellow_square: I6            |        `%IX1.0`        | :white_check_mark: Protected input             |
| `GPIO_12` |         `32`          | :red_square: Q5               |        `%QX0.7`        | :white_check_mark: Relay output                |
| `GPIO_13` |         `33`          | :yellow_square: I7            |        `%IX1.3`        | :white_check_mark: Protected input             |
| `GPIO_14` |         `08`          | :blue_square: KNX UART TX     |        `%QX0.0`        | :x: KNX not supported                          |
| `GPIO_15` |         `10`          | :blue_square: KNX UART RX     |        `%QX0.1`        | :x: KNX not supported                          |
| `GPIO_16` |         `36`          | :red_square: Q6               |        `%QX1.0`        | :white_check_mark: Relay output                |
| `GPIO_17` |         `11`          | :yellow_square: I1            |        `%IX0.3`        | :white_check_mark: Protected input             |
| `GPIO_18` |         `12`          | :orange_square: PWM_0         |        `%QW0.0`        | :ballot_box_with_check: Unprotected PWM output |
| `GPIO_19` |         `35`          | :orange_square: PWM_1         |        `%QX1.0`        | :ballot_box_with_check: Unprotected PWM output |
| `GPIO_20` |         `38`          | :red_square: Q7               |        `%QX1.1`        | :white_check_mark: Relay output                |
| `GPIO_21` |         `40`          | :red_square: Q8               |        `%QX1.2`        | :white_check_mark: Relay output                |
| `GPIO_22` |         `15`          | :yellow_square: I3            |        `%IX0.5`        | :white_check_mark: Protected input             |
| `GPIO_23` |         `16`          | :blue_square: 1-Wire          |        `%QX0.2`        | :warning: 1-Wire through driver?               |
| `GPIO_24` |         `18`          | :red_square: Q1               |        `%QX0.3`        | :white_check_mark: Relay output                |
| `GPIO_25` |         `22`          | :red_square: Q2               |        `%QX0.4`        | :white_check_mark: Relay output                |
| `GPIO_26` |         `37`          | :yellow_square: I8            |        `%IX1.5`        | :white_check_mark: Protected input             |
| `GPIO_27` |         `13`          | :yellow_square: I2            |        `%IX0.4`        | :white_check_mark: Protected input             |

Pins marked unusable with OpenPLC are either not broken out, or differ too much from OpenPLC's mapping. As OpenPLC's mapping is immutable, these pins might not be used if PiPLC is used with the OpenPLC runtime and Pi default hardware layer.

## Pinout

![Pinout](/doc/PiPLC_Pinout.drawio.svg)

---

## I/O

### J1 | Power Input

|    1    |    2    |   3   |   4   |
| :-----: | :-----: | :---: | :---: |
| `+24 V` | `+24 V` | `GND` | `GND` |
 
The PiPLC is to be supplied by 12 V / 24 V (24 V is preferred) and requires at least a TODO power supply under full load.
(Full load measured with TODO mA @ 24 V with all relays closed, all DI HIGH, transmitting over KNX and I²C, connected to Wifi and with the Pi at 100% CPU load without overclocking)

Internally, 5V is generated by a `TPS54331D` based DC-DC converter. 
At `J10` 12/24V is passed through unprotected from the power input. 
At `J2` and `J8` 5 V from the DC-DC can be used to draw up to 500mA (protected through a polyfuse). 
At `J3`, 3V3 from the RPI can be used to draw up to 500mA (protected through a polyfuse)

---

### J2 | Modbus

|   1    |            2             |            3             |   4   |
| :----: | :----------------------: | :----------------------: | :---: |
| `+5 V` | :blue_square: `Modbus A` | :blue_square: `Modbus B` | `GND` |

Modbus is an industrial communication protocol often used with PLCs communicating with I/O extensions or other PLCs. 
The wire based one used here is called `Modbus RTU` and is based on half-duplex RS-485 so the header can also be used for that if you dislike Modbus. 

OpenPLC natively supports Modbus to talk to more I/O, while Homeassistant has a [Modbus integration](https://www.home-assistant.io/integrations/modbus/).

> [!NOTE]  
> To enable Modbus on your pi, make sure to enable `UART3` at GPIO5/06. We also need to enable the `ctsrts` option.
> This UART is not enabled by default and is only present on Raspberry Pi models 4 and up!
>
> In `/boot/config.txt` add:
> 
> `dtoverlay=uart3,ctsrts`
>
> and reboot afterwards
>
> After rebooting you should see the new serial port `/dev/ttyAMA3` when executing `ls /dev/tty*`

<details>
<summary>**Example usage**</summary>

TODO usage example on OpenPLC
TODO usage example on Homeassistant

</details>

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

<details>
<summary>**Example usage**</summary>

TODO usage example

</details>

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

<details>
<summary>**Example usage**</summary>

TODO usage example

</details>

> [!WARNING]
> Unprotected access to `GPIO_18` and `GPIO_19`. Take care not to damage your Pi!

---

### J8 | I²C

|   1    |   2   |            3            |            4            |
| :----: | :---: | :---------------------: | :---------------------: |
| `+5 V` | `GND` | :blue_square: `I²C SDA` | :blue_square: `I²C SCL` |

Here you have a protected, somewhat isolated 5 V tolerant I²C header with integrated pullups. This was at first intended for connecting to extensions, but the Modbus header takes care of that now.
You do have the option however, to attach whatever I²C device you want, provided the runtime you are using supports I²C communication.

<details>
<summary>**Example usage**</summary>

TODO usage example

</details>

> [!WARNING]
> The I²C contacts are already pulled up to 5 V so do not connect any 3.3 V only I²C devices directly without isolation!

---

### J9 | 1-Wire

|     1     |   2   |           3            |           4            |
| :-------: | :---: | :--------------------: | :--------------------: |
| `+ 3.3 V` | `GND` | :blue_square: `1-Wire` | :blue_square: `1-Wire` |

This header contains `GPIO_04` for native 1-Wire capability. 

1-Wire is usually used for temperature sensors, like `DS18B20`, or battery voltage sensing, but is sometimes also used for access control with iButtons.

<details>
<summary>**Example usage**</summary>

TODO usage example

</details>

> [!WARNING]
> Unprotected access to `GPIO_04`. Take care not to damage your Pi!

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

All inputs feature a status LED driven by the optocoupler output, thus not loading the input. 

On the Raspberry side, pullups need to be enabled on the GPIOs to enable reading from these input stages.

Input currents are as follows:

| Voltage | Input current |
| ------- | ------------- |
| 5 V     | TODO mA       |
| 12 V    | TODO mA       |
| 24 V    | 5 mA          |

<details>
<summary>**Example usage**</summary>

TODO usage example

</details>

---

### Wago header | KNX / NCN5121

Utilizing [knxd](https://github.com/knxd/knxd/tree/main) to run a [NCN5121](https://www.onsemi.com/pdf/datasheet/ncn5121-d.pdf) KNX transceiver chip the PiPLC can talk to KNX networks natively, without going through an actual KNX-IP gateway first. (Internally, knxd looks like a KNX-IP gateway, but it won't route through your actual LAN)

For Home Assistant, there is [an addon for knxd](https://github.com/da-anda/hass-io-addons/tree/main/knxd), so Home Assistant sees the internal NCN5121 as a KNX-IP gateway @ localhost.

See the [knxd documentation](https://github.com/knxd/knxd/blob/main/doc/inifile.rst#ncn5120) for specifics on how to use the driver if you are not using Home Assistant.

In this board, the NC5121 is NOT supplied through the KNX supply, but through the Pi's 3v3 rail. This means that it doesn't need to be taken into account when calculating the KNX power supply needs.

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

<details>
<summary>**Example usage**</summary>

TODO usage example

</details>

---

## Software

### OpenPLC

[OpenPLC](https://autonomylogic.com/) is a Fully IEC 61131-3 compliant, open source, multi-hardware programmable logic controller suite.

Consisting of a separate runtime and editor, it can run on regular PCs as a soft PLC, as well as a multitude of embedded systems. (Think Beckhoff XAR / XAE)

I am currently creating a hardware layer for PiPLC at https://github.com/Chrismettal/OpenPLC_v3. This should allow easy adressing of all IO while enabling native use of Modbus and other interfaces. The regular "Rpi" layer should also be compatible, but I²C, Modbus and KNX might not work, and I1-8 / Q1-8 adressing might be a bit unintuitive (See [GPIO mapping table](##-GPIO-mapping))

<details>
<summary>**Installation**</summary>

1. You are going to need a fresh installation of [Raspberry Pi OS](https://www.raspberrypi.com/software/) on your Pi 4. There is an official [getting started guide](https://www.raspberrypi.com/documentation/computers/getting-started.html) that is being kept up to date, so the first steps are not further described here.

2. Execute `git clone https://github.com/chrismettal/OpenPLC_v3` on your Pi.

3. `cd OpenPLC_v3` to enter the just cloned folder

4. `./install rpi` will start the full OpenPLC installation. (This will take a few minutes)

5. After a reboot, your OpenPLC installation's webinterface should be accessible on port 8080 on your Pi. Either try to access it at `127.0.0.1:8080` locally on your pi, or access it through your Pi's IP adress in your host computer.

6. The default credentials will be `Name: openplc`, `Password: openplc`. You might want to change these right after logging in for the first time. To do so, use the "Users" tab and edit the default "openplc" account:

![OpenPLCUsers](/img/OpenPLCManual/Users.png)

7. Head over to the "Hardware" tab to select the hardware layer. Select and save the "PiPLC" layer (Exact name might differ once merged upstream):

![OpenPLCHardware](/img/OpenPLCManual/Hardware.png)

8. That should be it for a base installation. You should now have access to D1-8 and Q1-8 already, but you won't see Modbus RTU yet for slave devices. Instructions how to enable the Modbus COM port are found at [J2 | Modbus](#j2--modbus).

9. After enabling UART3 [as described above](#j2--modbus) and rebooting your Pi, you should see /dev/AMA3 be available as a COM port for Modbus slaves:

![ModbusCOM](/img/OpenPLCManualModbusCOM.png)

10. That's all there is to install the base OpenPLC install. There is currently no easy way to enable KNX connectivity, and while I²C connectivity from OpenPLC is possible, it is currently not implemented in the hardware layer. See the usage example below for further information. Also see the [OpenPLC getting started guide](https://autonomylogic.com/docs/openplc-overview/) for general instructions on how to upload code to your OpenPLC instance

</details>

<details>
<summary>**Example usage**</summary>

TODO usage example

</details>

---

### Home Assistant

[Home Assistant](https://www.home-assistant.io/) is an open source smart-home automation software, that provides logic, visualization and automation in a single place. It allows you to connect practically everything to your home under one interface, awakening your smart home.

Home Assistant seems to move away from local hardware IO a bit, instead focussing on devices in your LAN / WiFi. That doesn't mean though, that it isn't fully capable of running on an actual PLC, giving you control of your devices without a middle man or WiFi shenanigans. This is where the `NC5121` KNX interface comes into play, which enables you to talk to a vast variety of off-the-shelf decentralised ACTUAL smart home components (No supplier apps, no accounts, no telemetry) without needing to go through an KNX-IP interface first.

<details>
<summary>**Installation**</summary>

TODO installation steps
TODO knxd
TODO modbus

> [!NOTE]  
> See also [Wago header | KNX / NCN5121](#wago-header--knx--ncn5121) for general knxd installation steps

> [!NOTE]  
> See also [J2 | Modbus](#j2--modbus) for general Modbus installation steps

</details>

<details>
<summary>**Example usage**</summary>

TODO usage example

</details>

---

### Codesys

TODO? Not open source so might not do. No reason why it shouldn't work tho. Let me know if this is an interesting usecase for you, so I might invest the time (and licensing cost) to document compatibility. Sending a [license for the RPI runtime](https://store.codesys.com/codesys-control-for-raspberry-pi-sl.html) my way would ~~force~~ guarantee me to put in the time to make it compatible.

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
