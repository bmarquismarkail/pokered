; Value macros

.MACRO bcd2
	dn ((\1) / 1000) # 10, ((\1) / 100) # 10
	dn ((\1) / 10) # 10, (\1) # 10
.ENDM

.MACRO bcd3
	dn ((\1) / 100000) # 10, ((\1) / 10000) # 10
	dn ((\1) / 1000) # 10, ((\1) / 100) # 10
	dn ((\1) / 10) # 10, (\1) # 10
.ENDM

; used in data/pokemon/base_stats/*.asm
.MACRO tmhm
	; initialize bytes to 0
	.REDEFINE _tm0 0
	.REDEFINE _tm1 0
	.REDEFINE _tm2 0
	.REDEFINE _tm3 0
	.REDEFINE _tm4 0
	.REDEFINE _tm5 0
	.REDEFINE _tm6 0
	; set bits of bytes
	.REPT NARGS
		.ARRAYOUT NAME tmhm_numbers INDEX \1 DEFINITION _tmhm_number_value
		.IF _tmhm_number_value > 0
			.REDEFINE _tmhm_byte (_tmhm_number_value - 1) / 8
			.REDEFINE _tmhm_bit (_tmhm_number_value - 1) # 8
			.IF _tmhm_byte < 1
				.REDEFINE _tm0 _tm0 | (1 << _tmhm_bit)
			.ELIF _tmhm_byte < 2
				.REDEFINE _tm1 _tm1 | (1 << _tmhm_bit)
			.ELIF _tmhm_byte < 3
				.REDEFINE _tm2 _tm2 | (1 << _tmhm_bit)
			.ELIF _tmhm_byte < 4
				.REDEFINE _tm3 _tm3 | (1 << _tmhm_bit)
			.ELIF _tmhm_byte < 5
				.REDEFINE _tm4 _tm4 | (1 << _tmhm_bit)
			.ELIF _tmhm_byte < 6
				.REDEFINE _tm5 _tm5 | (1 << _tmhm_bit)
			.ELSE
				.REDEFINE _tm6 _tm6 | (1 << _tmhm_bit)
			.ENDIF
		.ENDIF
		.SHIFT
	.ENDR
	; output bytes
	.DB _tm0, _tm1, _tm2, _tm3, _tm4, _tm5, _tm6
.ENDM


; Constant data (db, dw, dl) macros

.MACRO dbw
	.DB \1
	.DW \2
.ENDM

.MACRO dwb
	.DW \1
	.DB \2
.ENDM

.MACRO dn ; nybbles
	.REPT NARGS / 2
		.DB ((\1) << 4) | (\2)
		.SHIFT
		.SHIFT
	.ENDR
.ENDM

.MACRO dc ; "crumbs"
	.REPT NARGS / 4
		.DB ((\1) << 6) | ((\2) << 4) | ((\3) << 2) | (\4)
		.SHIFT
		.SHIFT
		.SHIFT
		.SHIFT
	.ENDR
.ENDM

.MACRO bigdw ; big-endian word
	.DB hibyte(\1), lobyte(\1)
.ENDM

.MACRO dba ; dbw bank, address
	.REPT NARGS
		dbw bank(\1), \1
		.SHIFT
	.ENDR
.ENDM

.MACRO dab ; dwb address, bank
	.REPT NARGS
		dwb \1, bank(\1)
		.SHIFT
	.ENDR
.ENDM

.MACRO dname ARGS str, requested_length
	.IF (((NARGS))-(2)) < 1 && (((NARGS))-(2)) > -1
		.REDEFINE n requested_length
	.ELSE
		.REDEFINE n NAME_LENGTH - 1
	.ENDIF
	.REDEFINE dname_start org()
	.STRINGMAP pokemon, str
	.REDEFINE dname_length org() - dname_start
	.ASSERT dname_length <= n
	.IF n > dname_length
		.DSB n - dname_length, $50
	.ENDIF
.ENDM
