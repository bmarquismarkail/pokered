.BANK 35
.ORG $0000

; Structured replacement for RGBDS section "Text 4".
.INCLUDE "wla/banks/bank35_text.asm"

; Text 4 occupies $8C000-$8EC08; preserve the bank's free space.
.DSB $4000 - $2c09, $00

Bank35End::
