CeruleanHideRocket:
	CALL $20EF ; GBFadeOutToBlack
	LD A, $07 ; TOGGLE_CERULEAN_GUARD_1
	LD ($CC4D), A ; wToggleableObjectIndex
	LD A, $15 ; ShowObject predef
	CALL $3E6D
	LD A, $09 ; TOGGLE_CERULEAN_GUARD_2
	LD ($CC4D), A
	LD A, $11 ; HideObject predef
	CALL $3E6D
	LD A, $06 ; TOGGLE_CERULEAN_ROCKET
	LD ($CC4D), A
	LD A, $11
	CALL $3E6D
	CALL $20D1 ; GBFadeInFromBlack
	RET
CeruleanHideRocketEnd:
.ASSERT CeruleanHideRocketEnd - CeruleanHideRocket == 37
