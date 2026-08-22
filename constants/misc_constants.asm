; Boolean checks
.DEFINE FALSE 0
.DEFINE TRUE 1

; flag operations
	const_def
	const FLAG_RESET ; 0
	const FLAG_SET   ; 1
	const FLAG_TEST  ; 2

; input
.DEFINE NO_INPUT 0

; SGB command MLT_REQ can be used to detect SGB hardware
.DEFINE JOYP_SGB_MLT_REQ %00000011
