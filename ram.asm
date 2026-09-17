.INCLUDE "wla/native/config.asm"
.INCLUDE "wla/native/ram_constants.asm"
.INCLUDE "macros/ram.asm"


.INCLUDE "ram/vram.asm"
.INCLUDE "ram/wram.asm"
.INCLUDE "ram/sram.asm"
.INCLUDE "ram/hram.asm"

.RAMSECTION "OAM DMA HRAM" BANK 0 SLOT 6
hDMARoutine: ds 6
hDMARoutine.wait: ds 4
.ENDS
