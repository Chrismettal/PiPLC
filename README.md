# Project <!-- omit in toc -->

[![License: CC BY-SA 4.0](https://img.shields.io/badge/license-CC%20BY--SA%204.0-blue?style=flat-square)](https://creativecommons.org/licenses/by-sa/4.0/)
[![Shop: Tindie](https://img.shields.io/badge/shop-Tindie-blue?style=flat-square)](https://www.tindie.com/stores/binary-6/?ref=offsite_badges&utm_source=sellers_Chrismettal&utm_medium=badges&utm_campaign=badge_medium)
[![Donations: Coffee](https://img.shields.io/badge/donations-Coffee-brown?style=flat-square)](https://github.com/Chrismettal#donations)
[![Version](https://img.shields.io/github/v/tag/chrismettal/threedeploy?label=version&style=flat-square)](https://github.com/Chrismettal/Test)

![Logo](img/Logo.png)

This is a work in progress for a Raspberry Pi breakout board + DIN rail case to use Pis in PLC-like industrial situations.

All the parts are or will be stocked at Tindie!

<a href="https://www.tindie.com/stores/binary-6/?ref=offsite_badges&utm_source=sellers_Chrismettal&utm_medium=badges&utm_campaign=badge_medium"><img src="https://d2ss6ovg47m0r5.cloudfront.net/badges/tindie-mediums.png" alt="I sell on Tindie" width="150" height="78"></a>

**If you like my work please consider [supporting me](https://github.com/Chrismettal#donations)!**

## Table of contents <!-- omit in toc -->

- [GPIO mapping](#gpio-mapping)
- [Modules](#modules)
  - [Digital Inputs (I1-8)](#digital-inputs-i1-8)
  - [KNX / NCN5121](#knx--ncn5121)
- [Tools used](#tools-used)
- [Donations](#donations)
- [License](#license)

## GPIO mapping

| GPIO Name | Header Pin Nbr | PiPLC                           | OpenPLC | Usable with OpenPLC |
| --------- | -------------- | ------------------------------- | ------- | ------------------- |
| GPIO_02   | 03             | I²C SDA (Internal and External) | %IX0.0  | :white_check_mark:  |
| GPIO_03   | 05             | I²C SCL (Internal and External) | %IX0.1  | :white_check_mark:  |
| GPIO_04   | 07             | 1-Wire                          | %IX0.2  | :white_check_mark:  |
| GPIO_05   | 29             | I7                              | %IX1.1  | :white_check_mark:  |
| GPIO_06   | 31             | I8                              | %IX1.2  | :white_check_mark:  |
| GPIO_07   | 26             | Q4                              | %QX0.6  | :white_check_mark:  |
| GPIO_08   | 24             | Q3                              | %QX0.5  | :white_check_mark:  |
| GPIO_09   | 21             | I5                              | %IX0.7  | :white_check_mark:  |
| GPIO_10   | 19             | I4                              | %IX0.6  | :white_check_mark:  |
| GPIO_11   | 23             | I6                              | %IX1.0  | :white_check_mark:  |
| GPIO_12   | 32             | Q5                              | %QX0.7  | :white_check_mark:  |
| GPIO_13   | 33             |                                 | %IX1.3  |                     |
| GPIO_14   | 08             | KNX UART TX                     | %QX0.0  | :x:                 |
| GPIO_15   | 10             | KNX UART RX                     | %QX0.1  | :x:                 |
| GPIO_16   | 36             | Q6                              | %QX1.0  | :white_check_mark:  |
| GPIO_17   | 11             | I1                              | %IX0.3  |                     |
| GPIO_18   | 12             | PWM_0                           | %QW0.0  | :white_check_mark:  |
| GPIO_19   | 35             | PWM_1                           | %QX1.0  | :white_check_mark:  |
| GPIO_20   | 38             | Q7                              | %QX1.1  | :white_check_mark:  |
| GPIO_21   | 40             | Q8                              | %QX1.2  | :white_check_mark:  |
| GPIO_22   | 15             | I3                              | %IX0.5  | :white_check_mark:  |
| GPIO_23   | 16             |                                 | %QX0.2  |                     |
| GPIO_24   | 18             | Q1                              | %QX0.3  | :white_check_mark:  |
| GPIO_25   | 22             | Q2                              | %QX0.4  | :white_check_mark:  |
| GPIO_26   | 37             |                                 | %IX1.5  |                     |
| GPIO_27   | 13             | I2                              | %IX0.4  | :white_check_mark:  |

Pins marked unusable with OpenPLC are either not broken out, or differ too much from OpenPLC's mapping. As OpenPLC's mapping is immutable, these pins might not be used if PiPLC is used with the OpenPLC runtime.

## Modules

### Digital Inputs (I1-8)

8 digital inputs are found at the top of the device.

### KNX / NCN5121

Utilizing [knxd](https://github.com/knxd/knxd/tree/main) to run a [NCN5121](https://www.onsemi.com/pdf/datasheet/ncn5121-d.pdf) KNX transceiver chip the PiPLC can talk to KNX networks natively, without going through an actual KNX-IP gateway first. (Internally, knxd looks like a KNX-IP gateway, but it won't route through your actual LAN)

For Home Assistant, there is [an addon for knxd](https://github.com/da-anda/hass-io-addons/tree/main/knxd), so Home Assistant sees the internal NCN5121 as a KNX-IP gateway @ localhost.

See the [knxd documentation](https://github.com/knxd/knxd/blob/main/doc/inifile.rst#ncn5120) for specifics on how to use the driver if you are not using Home Assistant.

In this board, the NC5121 is NOT supplied through the KNX supply, but through the Pi's 3v3 rail. This means that it doesn't need to be taken into account when calculating the KNX power supply needs.

## Tools used

- FreeCAD 0.21.1
  - KicadStepUp Workbench 10.20.7
- KiCAD 7.0.8

## Donations

**If you like my work please consider [supporting me](https://github.com/Chrismettal#donations)!**

## License

 <a rel="CClicense" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
