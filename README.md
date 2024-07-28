# AthenaOS

Open source reimplementation of the FreyaBIOS/FreyaOS abstraction layer.

## Motivation

The main purpose of AthenaOS is achieving interoperability of freely available WonderWitch software with
third-party emulators and cartridges. Acquiring a WonderWitch user or development kit in 2024 can cost
anywhere between 150 and 500 USD, on top of the cost of the console itself. There is no alternative solution
to run most WonderWitch games, other than the second hand market. As such, hundreds of games and applications
have no way of being executed in a freely available environment. Like FreeDOS for DOS and WINE for Windows,
the goal of AthenaOS is principally to build such a system.

PS. If you just want to play Judgement Silversword, that one is available [on Steam](https://store.steampowered.com/app/278510/JUDGEMENT_SILVERSWORD__Resurrection/).

## Distribution contents

* `AthenaBIOS.raw` - BIOS/System image (raw)
* `AthenaBIOS.bin` - BIOS/System image (XMODEM update format)
* `AthenaOS.raw` - OS/Soft image (raw)
* `AthenaOS.bin` - OS/Soft image (XMODEM update format)

## Building

### Requirements

* Wonderful toolchain. See [Getting Started](https://wonderful.asie.pl/docs/getting-started/) for installation instructions
  * After installation, run `wf-pacman -S target-wswan` to install the WonderSwan components.
  * Additional documentation available [here](https://wonderful.asie.pl/wiki/doku.php?id=wswan:index).
* Python 3 with the Pillow image library
  * Windows/MSYS2: `pacman -S mingw-w64-ucrt-x86_64-python mingw-w64-ucrt-x86_64-python-pillow`
  * Debian: `apt-get install python3 python3-pil`
  * Arch Linux: `pacman -S python python-pillow`
* GNU Make
  * Windows/MSYS2: `pacman -S make`

### Configuration

Build settings can be configured by editing `config.mk`.

### Build steps

    $ make

The build process results should now be available in `dist/`. ELF object files and other intermediate outputs are placed in `build/`.

## License

AthenaBIOS and AthenaOS are provided under the MIT license.

The fonts are derived from the following sources:

* ASCII font - [unscii](http://viznut.fi/unscii/) by Viznut - Public Domain,
* Shift-JIS font - [Misaki](https://littlelimit.net/misaki.htm) by Little Limit - Custom font license, reproduced below.

### Little Limit font license

> These fonts are free software.
> Unlimited permission is granted to use, copy, and distribute them, with or without modification, either commercially or noncommercially.
> THESE FONTS ARE PROVIDED "AS IS" WITHOUT WARRANTY.
>
> これらのフォントはフリー（自由な）ソフトウエアです。
> あらゆる改変の有無に関わらず、また商業的な利用であっても、自由にご利用、複製、再配布することができますが、全て無保証とさせていただきます。 

([Source](https://littlelimit.net/font.htm))
