.BANK 34
.ORG $0000

; Structured replacement for RGBDS section "Text 3".
.INCLUDE "wla/banks/bank34_text.asm"

; Text 3 occupies $88000-$8ACF8; preserve the bank's free space.
.DSB $4000 - $2cf9, $00

Bank34End::
