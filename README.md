# OpenAmiga2000CoproAdapter

# A2000 Boss Experiment
This branch contains the code and pcb for a coprocessor containing a CPLD that allows host CPU takeover by doing proper bus arbitration
This doesn't completely work, E/VPA/VMA doesn't work properly causing CIA issues...

__I forgot to route DTACK to the CPLD, you will need to cut the DTACK trace, connect the socket's DTACK to TP1 and the Slot's DTACK to TP2__

## Theory of operation
This holds the coprocessor in a reset state until BOSS is asserted, doing so requires us to isolate some signals as the 68000 does not tristate them during DMA or HALT:

* Reset
* Halt
* RW
* LDS
* UDS
* AS
* BG
* BR
* FC0-2

Most of these are routed through the CPLD to acheive this except RESET/HALT which are bidirectional signals and necessitated a CBT buffer - but most if not all of these would be better served using a buffer rather than wasting CPLD resources

It is also necessary to generate an internal E clock (the 68k does not ever stop driving this) and generate VPA/DTACK around that to handle the CIA VPA/VMA stuff in a way that results in reliable operation. I still haven't figured this out yet...



OpenAmiga2000CoproAdapter is an Open Hardware adapter that allows installing the main processor of a Commodore Amiga 2000 computer in the co-processor slot.

![Board](https://raw.githubusercontent.com/SukkoPera/OpenAmiga2000CoproAdapter/master/doc/render-top.png)

### Summary
OpenAmiga2000CoproAdapter is an adapter that allows installing the main processor of a Commodore Amiga 2000 computer in the co-processor slot, based on [work by kipper2k](http://eab.abime.net/showthread.php?t=89604). It is mainly useful to mount TerribleFire and other accelerator cards without having to remove the floppy drive tray and without having them bump into your MegaChip, in case.

The adapter is very similar to the original, except that I skipped the INT7 and the A600 NMI circuits. Those are not needed for TerribleFire cards and for most other boards (I think they are for Vampires only). I carried over the INT2/OVR header, since the former is needed for the TF530. I have also introduced solder jumpers for the FR0-2 signals: those are not connected on kipper2k's board, I don't know why and it works well anyway, but I thought they wouldn't hurt as they will be open by default.

You may be able to install this without removing the original CPU by cutting the E jumper and closing the BOSS one.

This is a slightly expensive board to manufacture because it exceeds the 10x10cm limit that cheap fab houses impose, because it needs gold-plating for better contact and resistance to repeated insertions/removals, and because the edge connector should be beveled to ease insertion. These are the recommended settings if you want to get the boards made.

### Installation
**Please be very careful when plugging this board** in the co-processor slot: there is an arrow on the board, **it must point to the back of the Amiga**. Plugging this adapter backwards will damage your CPU/accelerator card, as some pins of the CPU slot carry +12V!

When this board is installed, most likely the original 68000 socket must be left empty unless you cut the E jumper and close the BOSS jumper, though this ultimately depends on the particular card you will be installing.

### License
The OpenAmiga2000CoproAdapter documentation, including the design itself, is copyright &copy; SukkoPera 2018-2019.

OpenAmiga2000CoproAdapter is Open Hardware licensed under the [CERN OHL v. 1.2](http://ohwr.org/cernohl).

You may redistribute and modify this documentation under the terms of the CERN OHL v.1.2. This documentation is distributed *as is* and WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES whatsoever with respect to its functionality, operability or use, including, without limitation, any implied warranties OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE or infringement. We expressly disclaim any liability whatsoever for any direct, indirect, consequential, incidental or special damages, including, without limitation, lost revenues, lost profits, losses resulting from business interruption or loss of data, regardless of the form of action or legal theory under which the liability may be asserted, even if advised of the possibility or likelihood of such damages.

A copy of the full license is included in file [LICENSE.pdf](LICENSE.pdf), please refer to it for applicable conditions. In order to properly deal with its terms, please see file [LICENSE_HOWTO.pdf](LICENSE_HOWTO.pdf).

The contact points for information about manufactured Products (see section 4.2) are listed in file [PRODUCT.md](PRODUCT.md).

Any modifications made by Licensees (see section 3.4.b) shall be recorded in file [CHANGES.md](CHANGES.md).

The Documentation Location of the original project is https://github.com/SukkoPera/OpenAmiga2000CoproAdapter/.

### Support the Project
Since the project is open you are free to get the PCBs made by your preferred manufacturer, however in case you want to support the development, you can order them from PCBWay through this link:

[![PCB from PCBWay](https://www.pcbway.com/project/img/images/frompcbway.png)](https://www.pcbway.com/project/shareproject/OpenAmiga2000CoproAdapter_V3.html)

You get cheap, professionally-made and good quality PCBs, I get some credit that will help with this and [other projects](https://www.pcbway.com/project/member/shareproject/?bmbid=41100). You won't even have to worry about the various PCB options, it's all pre-configured for you!

Also, if you still have to register to that site, [you can use this link](https://www.pcbway.com/setinvite.aspx?inviteid=41100) to get some bonus initial credit (and yield me some more).

Again, if you want to use another manufacturer, feel free to, don't feel obligated :). But then you can buy me a coffee if you want:

<a href='https://ko-fi.com/L3L0U18L' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi2.png?v=2' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

### Get Help
If you need help or have questions, you can join [the official Telegram group](https://t.me/joinchat/HUHdWBC9J9JnYIrvTYfZmg).

### Thanks
Thanks to kipper2k, of course :).
