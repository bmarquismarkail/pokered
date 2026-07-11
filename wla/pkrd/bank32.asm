.BANK 32
.ORG $0000

; Structured replacement for RGBDS section "Text 1".
.INCLUDE "wla/banks/bank32_text.asm"

; Text 1 occupies $80000-$82AAE; preserve the bank's free space.
.DSB $4000 - $2aaf, $00

Bank32End::
