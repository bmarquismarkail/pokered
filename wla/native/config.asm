; Shared memory model for every native WLA-DX object.
; Every object must use this exact map or WLALINK will reject the link.
.MEMORYMAP
  SLOT 0 START $0000 SIZE $4000 ; fixed ROM bank
  SLOT 1 START $4000 SIZE $4000 ; switchable ROM bank
  SLOT 2 START $8000 SIZE $2000 ; VRAM
  SLOT 3 START $a000 SIZE $2000 ; cartridge SRAM window
  SLOT 4 START $c000 SIZE $2000 ; WRAM0
  SLOT 5 START $ff8a SIZE $0076 ; HRAM after the OAM DMA routine
  SLOT 6 START $ff80 SIZE $000a ; OAM DMA routine copied into HRAM
  DEFAULTSLOT 1
.ENDME

.ROMBANKMAP
  BANKSTOTAL 64
  BANKSIZE $4000
  BANKS 64
.ENDRO

.DEFINE _RED 1
