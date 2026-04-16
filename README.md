# Luma3DS

![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/LumaTeam/Luma3DS/total)
![License](https://img.shields.io/badge/License-GPLv3-blue.svg)

*Nintendo 3DS "Custom Firmware"*

![Boot menu screenshot](img/boot_menu_v1321.png)
![Rosalina menu screenshot](img/rosalina_menu_v1321.png)

> **Personal fork** — used for learning and tinkering. For the official release, see [LumaTeam/Luma3DS](https://github.com/LumaTeam/Luma3DS).
>
> **Personal note:** I changed my Rosalina combo to <kbd>L+Down+Select</kbd> → <kbd>L+Up+B</kbd> to avoid conflicts with games that use the default combo.

## Description
**Luma3DS** patches and reimplements significant parts of the system software running on all models of the Nintendo 3DS family of consoles. It aims to greatly improve the user experience and support the 3DS far beyond its end-of-life. Features include:

* **First-class support for homebrew applications**
* **Rosalina**, an overlay menu (triggered by <kbd>L+Down+Select</kbd> by default), allowing things like:
    * Taking screenshots while in game
    * Blue light filters and other screen filters
    * Input redirection to play with external devices, such as controllers
    * Using cheat codes
    * Setting time and date accurately from the network (NTP)
    * ... and much more!
* **Many game modding features**, such as, but not limited to:
    * Game plugins (in 3GX format)
    * Per-game language overrides ("locale emulation")
    * Asset content path redirection ("LayeredFS")
* **Support for user-provided patches and/or full "system modules" replacements**, an essential feature for Nintendo Network replacements (amongst other projects)
* A **fully-fledged GDB stub**, allowing homebrew developers and reverse-engineers alike to work much more efficiently
* Ability to chainload other firmware files, including other versions of itself
* ... and much more!

## Installation and upgrade
Luma3DS requires [boot9strap](https://github.com/SciresM/boot9strap) to run.

Once boot9strap has been installed, simply download the [latest release archive](https://github.com/LumaTeam/Luma3DS/releases/latest) and extract the archive onto the root of your SD card to "install" or to upgrade Luma3DS alongside the [homebrew menu and certs bundle](https://github.com/devkitPro/3ds-hbmenu) shipped with it. Replace existing files and merge existing folders if necessary.

## Basic usage
**The main Luma3DS configuration menu** can be accessed by pressing <kbd>Select</kbd> at boot. The configuration file is stored in `/luma/config.ini` on the SD card (or `/rw/luma/config.ini` on the CTRNAND partition if Luma3DS has been launched from the CTRNAND partition, which happens when SD card is missing).

**The chainloader menu** is accessed by pressing <kbd>Start</kbd> at boot, or from the configuration menu. Payloads are expected to be located in `/luma/payloads` with the `.firm` extension; if there is only one such payload, the aforementioned selection menu will be skipped. Hotkeys can be assigned to payload, for example `x_test.firm` will be chainloaded when <kbd>X</kbd> is pressed at boot.

**The overlay
