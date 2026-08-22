; not zero if an NPC movement script is running, the player character is
; automatically stepping down from a door, or joypad states are being simulated
IsPlayerCharacterBeingControlledByGame:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, [wMovementFlags]
	bit BIT_EXITING_DOOR, a
	ret nz
	ld a, [wStatusFlags5]
	and 1 << BIT_SCRIPTED_MOVEMENT_STATE
	ret

RunNPCMovementScript:
	ld hl, wMovementFlags
	bit BIT_STANDING_ON_DOOR, [hl]
	res BIT_STANDING_ON_DOOR, [hl]
	jr nz, RunNPCMovementScript.playerStepOutFromDoor
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret z
	dec a
	add a
	ld d, 0
	ld e, a
	ld hl, RunNPCMovementScript.NPCMovementScriptPointerTables
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, [wNPCMovementScriptBank]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ld a, [wNPCMovementScriptFunctionNum]
	call CallFunctionInTable
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

RunNPCMovementScript.NPCMovementScriptPointerTables
	.DW PalletMovementScriptPointerTable
	.DW PewterMuseumGuyMovementScriptPointerTable
	.DW PewterGymGuyMovementScriptPointerTable
RunNPCMovementScript.playerStepOutFromDoor
	farjp PlayerStepOutFromDoor

EndNPCMovementScript:
	farjp WLA_GLOBAL_EndNPCMovementScript

DebugPressedOrHeldB: ; dummy except in _DEBUG
; This is used to skip Trainer battles, the
; Safari Game step counter, and some NPC scripts.
.IF defined(_DEBUG)
	ld a, [wStatusFlags6]
	bit BIT_DEBUG_MODE, a
	ret z
	ldh a, [lobyte(hJoyHeld)]
	bit B_PAD_B, a
	ret nz
	ldh a, [lobyte(hJoyPressed)]
	bit B_PAD_B, a
.ENDIF
	ret
