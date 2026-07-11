.BANK 33
.ORG $0000

; Structured replacement for RGBDS section "Text 2".
.INCLUDE "wla/banks/bank33_text.asm"

; Text 2 occupies $84000-$86CA0; preserve the bank's free space.
.DSB $4000 - $2ca1, $00

Bank33End::
