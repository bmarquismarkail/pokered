; Oak's Lab activation and entrance states from scripts/OaksLab.asm.
OaksLabDefaultScript:
	LD A, ($D74B)
	BIT 7, A ; EVENT_OAK_APPEARED_IN_PALLET
	RET Z
	LD A, ($CF10) ; wNPCMovementScriptFunctionNum
	AND A
	RET NZ
	LD A, $31 ; TOGGLE_OAKS_LAB_OAK_2
	LD ($CC4D), A ; wToggleableObjectIndex
	LD A, $15 ; ShowObject predef
	CALL $3E6D ; Predef
	LD HL, $D72E ; wStatusFlags4
	RES 4, (HL) ; BIT_NO_BATTLES
	LD A, 1 ; SCRIPT_OAKSLAB_OAK_ENTERS_LAB
	LD ($D5F0), A ; wOaksLabCurScript
	RET
OaksLabDefaultEnd:
.ASSERT OaksLabDefaultEnd - OaksLabDefaultScript == 32

OaksLabOakEntersLabScript:
	LD A, 8 ; OAKSLAB_OAK2
	LDH ($8C), A ; hSpriteIndex
	LD DE, OakEntryMovement
	CALL $363A ; MoveSprite
	LD A, 2 ; SCRIPT_OAKSLAB_TOGGLE_OAKS
	LD ($D5F0), A
	RET
OaksLabOakEntersLabEnd:
.ASSERT OaksLabOakEntersLabEnd - OaksLabOakEntersLabScript == 16

OakEntryMovement:
	.DB $40,$40,$40,$FF ; NPC_MOVEMENT_UP x3, end
OakEntryMovementEnd:
.ASSERT OakEntryMovementEnd - OakEntryMovement == 4

OaksLabToggleOaksScript:
	LD A, ($D730) ; wStatusFlags5
	BIT 0, A ; BIT_SCRIPTED_NPC_MOVEMENT
	RET NZ
	LD A, $31 ; TOGGLE_OAKS_LAB_OAK_2
	LD ($CC4D), A
	LD A, $11 ; HideObject predef
	CALL $3E6D
	LD A, $2E ; TOGGLE_OAKS_LAB_OAK_1
	LD ($CC4D), A
	LD A, $15 ; ShowObject predef
	CALL $3E6D
	LD A, 3 ; SCRIPT_OAKSLAB_PLAYER_ENTERS_LAB
	LD ($D5F0), A
	RET
OaksLabToggleOaksEnd:
.ASSERT OaksLabToggleOaksEnd - OaksLabToggleOaksScript == 32
