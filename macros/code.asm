; Syntactic sugar macros

.MACRO lb ; r, hi, lo
	ld \1, (((\2) & $ff) << 8) + ((\3) & $ff)
.ENDM

.MACRO ldpal
	ld \1, \2 << 6 | \3 << 4 | \4 << 2 | \5
.ENDM

; Design patterns

.MACRO ld_hli_a_string ARGS str
	; WLA's string maps emit data but do not expose mapped characters as
	; immediate expressions. Keep the original instruction sequence for the
	; fixed set of short strings used by this macro.
	.IF str == "FNT"
		ld a, $85
		ld [hli], a
		ld a, $8d
		ld [hli], a
		ld [hl], $93
	.ELIF str == "SLP"
		ld a, $92
		ld [hli], a
		ld a, $8b
		ld [hli], a
		ld [hl], $8f
	.ELIF str == "PSN"
		ld a, $8f
		ld [hli], a
		ld a, $92
		ld [hli], a
		ld [hl], $8d
	.ELIF str == "BRN"
		ld a, $81
		ld [hli], a
		ld a, $91
		ld [hli], a
		ld [hl], $8d
	.ELIF str == "FRZ"
		ld a, $85
		ld [hli], a
		ld a, $91
		ld [hli], a
		ld [hl], $99
	.ELIF str == "PAR"
		ld a, $8f
		ld [hli], a
		ld a, $80
		ld [hli], a
		ld [hl], $91
	.ELIF str == "GHOST@"
		ld a, $86
		ld [hli], a
		ld a, $87
		ld [hli], a
		ld a, $8e
		ld [hli], a
		ld a, $92
		ld [hli], a
		ld a, $93
		ld [hli], a
		ld [hl], $50
	.ELIF str == "<BOLD_V><BOLD_S>"
		ld a, $69
		ld [hli], a
		ld [hl], $6a
	.ELSE
		.FAIL
	.ENDIF
.ENDM

.MACRO dict
	.IF \1
		cp \1
	.ELSE
		and a
	.ENDIF
	jp z, \2
.ENDM
