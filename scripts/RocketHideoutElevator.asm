RocketHideoutElevator_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	push hl
	call nz, RocketHideoutElevatorStoreWarpEntriesScript
	pop hl
	bit BIT_CUR_MAP_USED_ELEVATOR, [hl]
	res BIT_CUR_MAP_USED_ELEVATOR, [hl]
	call nz, RocketHideoutElevatorShakeScript
	xor a
	ld [wAutoTextBoxDrawingControl], a
	inc a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret

RocketHideoutElevatorStoreWarpEntriesScript:
	ld hl, wWarpEntries
	ld a, [wWarpedFromWhichWarp]
	ld b, a
	ld a, [wWarpedFromWhichMap]
	ld c, a
	call RocketHideoutElevatorStoreWarpEntriesScript.StoreWarpEntry
	; fallthrough
RocketHideoutElevatorStoreWarpEntriesScript.StoreWarpEntry:
	inc hl
	inc hl
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ret

RocketHideoutElevatorScript:
	ld hl, RocketHideoutElevatorFloors
	call LoadItemList
	ld hl, RocketHideoutElevatorWarpMaps
	ld de, wElevatorWarpMaps
	ld bc, RocketHideoutElevatorWarpMaps.End - RocketHideoutElevatorWarpMaps
	call CopyData
	ret

RocketHideoutElevatorFloors:
	.DB 3 ; #
	.DB FLOOR_B1F
	.DB FLOOR_B2F
	.DB FLOOR_B4F
	.DB -1 ; end

; These specify where the player goes after getting out of the elevator.
RocketHideoutElevatorWarpMaps:
	; warp number, map id
	.DB 4, ROCKET_HIDEOUT_B1F
	.DB 4, ROCKET_HIDEOUT_B2F
	.DB 2, ROCKET_HIDEOUT_B4F
RocketHideoutElevatorWarpMaps.End:

RocketHideoutElevatorShakeScript:
	call Delay3
	farcall ShakeElevator
	ret

RocketHideoutElevator_TextPointers:
	def_text_pointers
	dw_const RocketHideoutElevatorText, TEXT_ROCKETHIDEOUTELEVATOR

RocketHideoutElevatorText:
	text_asm
	ld b, LIFT_KEY
	call IsItemInBag
	jr z, RocketHideoutElevatorText.no_key
	call RocketHideoutElevatorScript
	ld hl, RocketHideoutElevatorWarpMaps
	predef DisplayElevatorFloorMenu
	jr RocketHideoutElevatorText.text_script_end
RocketHideoutElevatorText.no_key
	ld hl, RocketHideoutElevatorText.AppearsToNeedKeyText
	call PrintText
RocketHideoutElevatorText.text_script_end
	jp TextScriptEnd

RocketHideoutElevatorText.AppearsToNeedKeyText:
	text_far WLA_GLOBAL_RocketHideoutElevatorAppearsToNeedKeyText
	text_waitbutton
	text_end
