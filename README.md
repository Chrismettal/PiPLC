<!-- TODO, J? -->
# PiPLC <!-- omit in toc -->

[![License: CC BY-SA 4.0](https://img.shields.io/badge/license-CC%20BY--SA%204.0-blue?style=flat-square)](https://creativecommons.org/licenses/by-sa/4.0/)
[![Shop: Tindie](https://img.shields.io/badge/shop-Tindie-blue?style=flat-square)](https://www.tindie.com/stores/binary-6/?ref=offsite_badges&utm_source=sellers_Chrismettal&utm_medium=badges&utm_campaign=badge_medium)
[![Donations: Coffee](https://img.shields.io/badge/donations-Coffee-brown?style=flat-square)](https://github.com/Chrismettal#donations)

![Logo](img/Logo.png)

This is a work in progress for a Raspberry Pi breakout board + DIN rail case to use Pis in PLC-like industrial situations.

The design relies on a Raspberry Pi 4 for all functions to work. Pi 5 is currently untested, while Pi 3 and below don't allow for all functions to be used.

All the parts are or will be stocked at Tindie!

<a href="https://www.tindie.com/stores/binary-6/?ref=offsite_badges&utm_source=sellers_Chrismettal&utm_medium=badges&utm_campaign=badge_medium"><img src="https://d2ss6ovg47m0r5.cloudfront.net/badges/tindie-mediums.png" alt="I sell on Tindie" width="150" height="78"></a>

**If you like my work please consider [supporting me](https://github.com/Chrismettal#donations)!**

## Table of contents <!-- omit in toc -->

- [Software](#software)
- [GPIO mapping](#gpio-mapping)
- [Modules](#modules)
  - [Digital Inputs (I1-8)](#digital-inputs-i1-8)
  - [Digital Outputs (Q1-8)](#digital-outputs-q1-8)
  - [J? / KNX / NCN5121](#j--knx--ncn5121)
  - [J? / Modbus](#j--modbus)
  - [J? / Pure](#j--pure)
  - [J? / Extbus](#j--extbus)
  - [J? / I²C](#j--ic)
  - [J? / 1-Wire](#j--1-wire)
- [Power](#power)
- [Software](#software-1)
  - [OpenPLC](#openplc)
  - [HomeAssistant](#homeassistant)
  - [Codesys](#codesys)
- [Tools used](#tools-used)
- [Sources](#sources)
- [Donations](#donations)
- [License](#license)

## Software

The PiPLC is intended to be used with [Home Assistant](https://www.home-assistant.io/), as well as [Autonomy](https://autonomylogic.com/) / [OpenPLC](https://openplcproject.github.io/) (to be honest I don't exactly know why OpenPLC runs under two names and at this point I am too afraid to ask)

Obviously, since it's just a breakout board for any Pi, you can run whatever software you want, but Home Assistant and OpenPLC are the ones inspiring the design of this project.

## GPIO mapping

| GPIO Name | Header<br>Pin Nbr | PiPLC naming                   | OpenPLC<br>RPI mapping | Usable with<br>OpenPLC                         |
| :-------: | :---------------: | :----------------------------- | :--------------------: | :--------------------------------------------- |
| `GPIO_02` |       `03`        | :blue_square: I²C SDA          |        `%IX0.0`        | :ballot_box_with_check: Unprotected input      |
| `GPIO_03` |       `05`        | :blue_square: I²C SCL          |        `%IX0.1`        | :ballot_box_with_check: Unprotected input      |
| `GPIO_04` |       `07`        | :blue_square: Modbus UART TX   |        `%IX0.2`        | :warning: TODO Modbus through driver?          |
| `GPIO_05` |       `29`        | :blue_square: Modbus UART RX   |        `%IX1.1`        | :warning: TODO Modbus through driver?          |
| `GPIO_06` |       `31`        | :blue_square: Modbus UART RTS  |        `%IX1.2`        | :warning: TODO Modbus through driver?          |
| `GPIO_07` |       `26`        | :red_square: Q4                |        `%QX0.6`        | :white_check_mark: Relay output                |
| `GPIO_08` |       `24`        | :red_square: Q3                |        `%QX0.5`        | :white_check_mark: Relay output                |
| `GPIO_09` |       `21`        | :yellow_square: I5             |        `%IX0.7`        | :white_check_mark: Protected input             |
| `GPIO_10` |       `19`        | :yellow_square: I4             |        `%IX0.6`        | :white_check_mark: Protected input             |
| `GPIO_11` |       `23`        | :yellow_square: I6             |        `%IX1.0`        | :white_check_mark: Protected input             |
| `GPIO_12` |       `32`        | :red_square: Q5                |        `%QX0.7`        | :white_check_mark: Relay output                |
| `GPIO_13` |       `33`        | :yellow_square: I7             |        `%IX1.3`        | :white_check_mark: Protected input             |
| `GPIO_14` |       `08`        | :blue_square: KNX UART TX      |        `%QX0.0`        | :x: KNX not supported                          |
| `GPIO_15` |       `10`        | :blue_square: KNX UART RX      |        `%QX0.1`        | :x: KNX not supported                          |
| `GPIO_16` |       `36`        | :red_square: Q6                |        `%QX1.0`        | :white_check_mark: Relay output                |
| `GPIO_17` |       `11`        | :yellow_square: I1             |        `%IX0.3`        | :white_check_mark: Protected input             |
| `GPIO_18` |       `12`        | :orange_square: PWM_0 *@ TODO* |        `%QW0.0`        | :ballot_box_with_check: Unprotected PWM output |
| `GPIO_19` |       `35`        | :orange_square: PWM_1 *@ TODO* |        `%QX1.0`        | :white_check_mark: Relay output                |
| `GPIO_20` |       `38`        | :red_square: Q7                |        `%QX1.1`        | :white_check_mark: Relay output                |
| `GPIO_21` |       `40`        | :red_square: Q8                |        `%QX1.2`        | :white_check_mark: Relay output                |
| `GPIO_22` |       `15`        | :yellow_square: I3             |        `%IX0.5`        | :white_check_mark: Protected input             |
| `GPIO_23` |       `16`        | :blue_square: 1-Wire           |        `%QX0.2`        | :white_check_mark: Relay output                |
| `GPIO_24` |       `18`        | :red_square: Q1                |        `%QX0.3`        | :white_check_mark: Relay output                |
| `GPIO_25` |       `22`        | :red_square: Q2                |        `%QX0.4`        | :white_check_mark: Relay output                |
| `GPIO_26` |       `37`        | :yellow_square: I8             |        `%IX1.5`        | :white_check_mark: Protected input             |
| `GPIO_27` |       `13`        | :yellow_square: I2             |        `%IX0.4`        | :white_check_mark: Protected input             |

Pins marked unusable with OpenPLC are either not broken out, or differ too much from OpenPLC's mapping. As OpenPLC's mapping is immutable, these pins might not be used if PiPLC is used with the OpenPLC runtime and Pi default hardware layer.

## Modules

### Digital Inputs (I1-8)

8 digital inputs are found at the top of the device. These inputs are 5-24 V tolerant current sinking inputs through `EL817C` optocouplers.

All inputs feature a status LED driven by the optocoupler output, thus not loading the input. 

On the Raspberry side, pullups need to be enabled on the GPIOs to enable reading from these input stages.

Input currents are as follows:

| Voltage | Input current |
| ------- | ------------- |
| 5 V     | TODO mA       |
| 12 V    | TODO mA       |
| 24 V    | 5 mA          |

### Digital Outputs (Q1-8)

8 digital outputs are found at the pottom of the device. These outputs are driven by `G5RL-1A-E-TV8` relays theoretically capable of **16 A at 250 V AC** / **16 A at 24 V DC**. 

As with the digital inputs, each output features a status LED.

> [!WARNING]  
> As this the PiPLC is an open source passion project and not externally rated by TÜV or a similar agency, usage of these relays in mains powered systems is at your own risk.
> 
> All components chosen are rated for 16 A at 250 V AC and should be capable of driving everything in a home environment.
> 
> Only certified electricians should ever be performing mains work, and home-built devices should never be connected to mains power unless you know what you are doing.

### J? / KNX / NCN5121

Utilizing [knxd](https://github.com/knxd/knxd/tree/main) to run a [NCN5121](https://www.onsemi.com/pdf/datasheet/ncn5121-d.pdf) KNX transceiver chip the PiPLC can talk to KNX networks natively, without going through an actual KNX-IP gateway first. (Internally, knxd looks like a KNX-IP gateway, but it won't route through your actual LAN)

For Home Assistant, there is [an addon for knxd](https://github.com/da-anda/hass-io-addons/tree/main/knxd), so Home Assistant sees the internal NCN5121 as a KNX-IP gateway @ localhost.

See the [knxd documentation](https://github.com/knxd/knxd/blob/main/doc/inifile.rst#ncn5120) for specifics on how to use the driver if you are not using Home Assistant.

In this board, the NC5121 is NOT supplied through the KNX supply, but through the Pi's 3v3 rail. This means that it doesn't need to be taken into account when calculating the KNX power supply needs.

> [!IMPORTANT]  
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
 
### J? / Modbus

TODO

https://raspberrypi.stackexchange.com/questions/104464/where-are-the-uarts-on-the-raspberry-pi-4 

https://raspberrypi.stackexchange.com/questions/45570/how-do-i-make-serial-work-on-the-raspberry-pi3-pizerow-pi4-or-later-models/107780#107780

> [!IMPORTANT]  
> To enable Modbus, make sure to enable `UART3` at GPIO5/06
> This UART is not enabled by default and is only present on Raspberry Pi models 4 and up!
>
> In `/boot/config.txt` add:
> TODO
>
> reboot

### J? / Pure 

TODO which pins are here?

TODO how to enable PWM

### J? / Extbus

TODO

### J? / I²C

TODO

### J? / 1-Wire

This header contains `GPIO_04` for native 1-Wire capability, as well as `GPIO_26` since I couldn't find a better place for it. Bear in mind, both of these are unprotected just as `J?`.

## Power

The PiPLC is to be supplied by 12 V / 24 V (24 V is preferred) and requires at least a TODO power supply under full load.
(Full load measured with TODO mA with all relays closed, all DI HIGH, transmitting over KNX and I²C, connected to Wifi and with the Pi at 100% CPU load without overclocking)

Internally, 5V is generated by a `TPS54331D` based DC-DC converter. 
At `J1`, `J3` and `J8` 12/24V is passed through unprotected. 
At `J4`, 5 V from the DC-DC can be used to draw up to 500mA (protected through a polyfuse). 
At `J5`, 3V3 from the RPI can be used to draw up to 500mA (protected through a polyfuse)

## Software

### OpenPLC

TODO own hardware driver? Dark mode?

### HomeAssistant

TODO installation steps
TODO knxd
TODO modbus

### Codesys

TODO? Not open source so might not do. No reason why it shouldn't work tho.

## Tools used

- FreeCAD 0.21.1
  - KicadStepUp Workbench 10.20.7
- KiCAD 7.0.8

## Sources

- Wago 243-211 KNX Connector 3D file - https://grabcad.com/library/knx-connector-1
- Raspberry Pi 3D file - https://grabcad.com/library/raspberry-pi-4-model-b-1#!
- PCB Standoffs 3D files - https://grabcad.com/library/ettinger-standoff-nickel-plated-brass-m-f-m2-m8-1/details?folder_id=12725833

## Donations

**If you like my work please consider [supporting me](https://github.com/Chrismettal#donations)!**

## License

 <a rel="CClicense" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
