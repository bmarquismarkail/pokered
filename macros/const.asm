; Enumerate constants

.MACRO const_def
	.IF defined(const_value)
		.UNDEFINE const_value
	.ENDIF
	.IF defined(const_inc)
		.UNDEFINE const_inc
	.ENDIF
	.IF NARGS >= 1
		.DEFINE const_value \1
	.ELSE
		.DEFINE const_value 0
	.ENDIF
	.IF NARGS >= 2
		.DEFINE const_inc \2
	.ELSE
		.DEFINE const_inc 1
	.ENDIF
.ENDM

.MACRO const
	.DEFINE \1 const_value
	.REDEFINE const_value const_value + (const_inc)
.ENDM

.MACRO const_export
	const \1
	.EXPORT \1
.ENDM

.MACRO shift_const
	.DEFINE \1 1 << const_value
	.REDEFINE const_value const_value + (const_inc)
.ENDM

.MACRO const_skip
	.IF NARGS >= 1
		.REDEFINE const_value const_value + (const_inc * (\1))
	.ELSE
		.REDEFINE const_value const_value + (const_inc)
	.ENDIF
.ENDM

.MACRO const_next
	.IF (const_value > 0 && \1 < const_value) || (const_value < 0 && \1 > const_value)
		.FAIL "const_next cannot go backwards from {const_value} to \1"
	.ELSE
		.REDEFINE const_value \1
	.ENDIF
.ENDM

.MACRO dw_const
	.DW \1
	const \2
.ENDM
