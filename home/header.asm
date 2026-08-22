; rst vectors (unused)

; Native WLA-DX cartridge metadata. The linker writes these fields over the
; reserved header bytes below and computes both Game Boy checksums.
.GBHEADER
	NAME "POKEMON RED"
	LICENSEECODENEW "01"
	CARTRIDGETYPE $13
	ROMSIZE $05
	RAMSIZE $03
	COUNTRYCODE $01
	NINTENDOLOGO
	VERSION $00
	ROMSGB
.ENDGB

.SECTION "rst0" FORCE BANK $00 SLOT 0 ORG $0000
	rst $38

	.DSB $08 - orga(), 0 ; unused


.ENDS

.SECTION "rst8" FORCE BANK $00 SLOT 0 ORG $0008
	rst $38

	.DSB $10 - orga(), 0 ; unused


.ENDS

.SECTION "rst10" FORCE BANK $00 SLOT 0 ORG $0010
	rst $38

	.DSB $18 - orga(), 0 ; unused


.ENDS

.SECTION "rst18" FORCE BANK $00 SLOT 0 ORG $0018
	rst $38

	.DSB $20 - orga(), 0 ; unused


.ENDS

.SECTION "rst20" FORCE BANK $00 SLOT 0 ORG $0020
	rst $38

	.DSB $28 - orga(), 0 ; unused


.ENDS

.SECTION "rst28" FORCE BANK $00 SLOT 0 ORG $0028
	rst $38

	.DSB $30 - orga(), 0 ; unused


.ENDS

.SECTION "rst30" FORCE BANK $00 SLOT 0 ORG $0030
	rst $38

	.DSB $38 - orga(), 0 ; unused


.ENDS

.SECTION "rst38" FORCE BANK $00 SLOT 0 ORG $0038
	rst $38

	.DSB $40 - orga(), 0 ; unused


; Game Boy hardware interrupts


.ENDS

.SECTION "vblank" FORCE BANK $00 SLOT 0 ORG $0040
	jp VBlank

	.DSB $48 - orga(), 0 ; unused


.ENDS

.SECTION "lcd" FORCE BANK $00 SLOT 0 ORG $0048
	rst $38

	.DSB $50 - orga(), 0 ; unused


.ENDS

.SECTION "timer" FORCE BANK $00 SLOT 0 ORG $0050
	jp Timer

	.DSB $58 - orga(), 0 ; unused


.ENDS

.SECTION "serial" FORCE BANK $00 SLOT 0 ORG $0058
	jp Serial

	.DSB $60 - orga(), 0 ; unused


.ENDS

.SECTION "joypad" FORCE BANK $00 SLOT 0 ORG $0060
	reti



.ENDS

.SECTION "Header" FORCE BANK $00 SLOT 0 ORG $0100

Start:
; Nintendo requires all Game Boy ROMs to begin with a nop ($00) and a jp ($C3)
; to the starting address.
	nop
	jp WLA_GLOBAL_Start

; WLA-DX writes the native cartridge header over this reserved range.

.ENDS
