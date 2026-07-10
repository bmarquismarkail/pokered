.BANK 38
.ORG $0000

; Structured replacement for RGBDS section "Text 7".
.INCLUDE "wla/banks/bank38_text.asm"

; Text 7 occupies $98000-$9AB7A; preserve the bank's free space.
.DSB $4000 - $2b7b, $00

Bank38End::
