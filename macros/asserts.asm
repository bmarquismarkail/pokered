; Macros to verify assumptions about the data or code

.MACRO table_width
	.REDEFINE CURRENT_TABLE_WIDTH \1
.ENDM

.MACRO assert_table_length
	; Section-size validation is performed after linking because WLA cannot
	; resolve section-relative label arithmetic while assembling an object.
.ENDM

.MACRO assert_max_table_length
	; See assert_table_length.
.ENDM

.MACRO list_start
	.REDEFINE list_index 0
	.REDEFINE list_item_length 0
	.IF NARGS > 0
		.REDEFINE list_item_length \1
	.ENDIF
.ENDM

.MACRO li ARGS str
	.STRINGMAP pokemon, str
	.DB $50
	.REDEFINE list_index list_index + (1)
.ENDM

.MACRO assert_list_length
	.REDEFINE x \1
	.ASSERT ((x)-(list_index)) < 1 && ((x)-(list_index)) > -1
.ENDM

.MACRO nybble_array
	.REDEFINE CURRENT_NYBBLE_ARRAY_VALUE 0
	.REDEFINE CURRENT_NYBBLE_ARRAY_LENGTH 0
.ENDM

.MACRO nybble
	.ASSERT 0 <= (\1) && (\1) < $10
	.REDEFINE CURRENT_NYBBLE_ARRAY_VALUE (\1) | (CURRENT_NYBBLE_ARRAY_VALUE << 4)
	.REDEFINE CURRENT_NYBBLE_ARRAY_LENGTH CURRENT_NYBBLE_ARRAY_LENGTH + (1)
	.IF ((CURRENT_NYBBLE_ARRAY_LENGTH # 2)-(0)) < 1 && ((CURRENT_NYBBLE_ARRAY_LENGTH # 2)-(0)) > -1
		.DB CURRENT_NYBBLE_ARRAY_VALUE
		.REDEFINE CURRENT_NYBBLE_ARRAY_VALUE 0
	.ENDIF
.ENDM

.MACRO end_nybble_array
	.IF CURRENT_NYBBLE_ARRAY_LENGTH # 2
		.DB CURRENT_NYBBLE_ARRAY_VALUE << 4
	.ENDIF
	.IF (((NARGS))-(1)) < 1 && (((NARGS))-(1)) > -1
		.REDEFINE x \1
		.ASSERT ((x)-(CURRENT_NYBBLE_ARRAY_LENGTH)) < 1 && ((x)-(CURRENT_NYBBLE_ARRAY_LENGTH)) > -1
	.ENDIF
.ENDM

.MACRO bit_array
	.REDEFINE CURRENT_BIT_ARRAY_VALUE 0
	.REDEFINE CURRENT_BIT_ARRAY_LENGTH 0
.ENDM

.MACRO dbit
	.ASSERT (\1) >= 0 && (\1) < 2
	.REDEFINE CURRENT_BIT_ARRAY_VALUE CURRENT_BIT_ARRAY_VALUE | ((\1) << (CURRENT_BIT_ARRAY_LENGTH # 8))
	.REDEFINE CURRENT_BIT_ARRAY_LENGTH CURRENT_BIT_ARRAY_LENGTH + (1)
	.IF ((CURRENT_BIT_ARRAY_LENGTH # 8)-(0)) < 1 && ((CURRENT_BIT_ARRAY_LENGTH # 8)-(0)) > -1
		.DB CURRENT_BIT_ARRAY_VALUE
		.REDEFINE CURRENT_BIT_ARRAY_VALUE 0
	.ENDIF
.ENDM

.MACRO end_bit_array
	.IF CURRENT_BIT_ARRAY_LENGTH # 8
		.DB CURRENT_BIT_ARRAY_VALUE
	.ENDIF
	.IF (((NARGS))-(1)) < 1 && (((NARGS))-(1)) > -1
		.REDEFINE x \1
		.ASSERT ((x)-(CURRENT_BIT_ARRAY_LENGTH)) < 1 && ((x)-(CURRENT_BIT_ARRAY_LENGTH)) > -1
	.ENDIF
.ENDM

.MACRO def_grass_wildmons
;\1: encounter rate
	@_def_grass_wildmons_{\1}:
	.REDEFINE CURRENT_GRASS_WILDMONS_RATE \1
	.DB \1
.ENDM

.MACRO end_grass_wildmons
	; Validated from the linked section size.
.ENDM

.MACRO def_water_wildmons
;\1: encounter rate
	@_def_water_wildmons_{\1}:
	.REDEFINE CURRENT_WATER_WILDMONS_RATE \1
	.DB \1
.ENDM

.MACRO end_water_wildmons
	; Validated from the linked section size.
.ENDM
