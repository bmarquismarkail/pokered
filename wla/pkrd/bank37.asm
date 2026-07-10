.BANK 37
.ORG $0000

; Structured replacement for RGBDS section "Text 6".
.INCLUDE "wla/banks/bank37_text.asm"

; Text 6 occupies $94000-$96A37; preserve the bank's free space.
.DSB $4000 - $2a38, $00

Bank37End::
