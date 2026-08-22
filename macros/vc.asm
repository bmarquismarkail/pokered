.MACRO vc_hook
	.IF defined(_RED_VC) || defined(_BLUE_VC)
	.VC_\1:
	.ENDIF
.ENDM

.MACRO vc_hook_red
	.IF defined(_RED_VC)
	.VC_\1:
	.ENDIF
.ENDM

.MACRO vc_hook_blue
	.IF defined(_BLUE_VC)
	.VC_\1:
	.ENDIF
.ENDM

.MACRO vc_patch
	.IF defined(_RED_VC) || defined(_BLUE_VC)
		.ASSERT !defined(CURRENT_VC_PATCH)
		.DEFINE CURRENT_VC_PATCH \1
	.VC_{CURRENT_VC_PATCH}:
	.ENDIF
.ENDM

.MACRO vc_patch_end
	.IF defined(_RED_VC) || defined(_BLUE_VC)
		.ASSERT defined(CURRENT_VC_PATCH)
	.VC_{CURRENT_VC_PATCH}_End:
		.UNDEFINE CURRENT_VC_PATCH
	.ENDIF
.ENDM

.MACRO vc_assert
	.IF defined(_RED_VC) || defined(_BLUE_VC)
		.ASSERT \1
	.ENDIF
.ENDM
