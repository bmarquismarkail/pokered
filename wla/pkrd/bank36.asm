.BANK 36
.ORG $0000

; Structured replacement for RGBDS section "Text 5".
.INCLUDE "wla/banks/bank36_text.asm"

; Text 5 occupies $90000-$92902; preserve the bank's free space.
.DSB $4000 - $2903, $00

Bank36End::
