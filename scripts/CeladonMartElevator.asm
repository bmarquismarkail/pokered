CeladonMartElevator_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	push hl
	call nz, CeladonMartElevatorStoreWarpEntriesScript
	pop hl
	bit BIT_CUR_MAP_USED_ELEVATOR, [hl]
	res BIT_CUR_MAP_USED_ELEVATOR, [hl]
	call nz, CeladonMartElevatorShakeScript
	xor a
	ld [wAutoTextBoxDrawingControl], a
	inc a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret

CeladonMartElevatorStoreWarpEntriesScript:
	ld hl, wWarpEntries
	ld a, [wWarpedFromWhichWarp]
	ld b, a
	ld a, [wWarpedFromWhichMap]
	ld c, a
	call CeladonMartElevatorStoreWarpEntriesScript.StoreWarpEntry
	; fallthrough
CeladonMartElevatorStoreWarpEntriesScript.StoreWarpEntry:
	inc hl
	inc hl
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ret

CeladonMartElevatorCopyWarpMapsScript:
	ld hl, CeladonMartElevatorFloors
	call LoadItemList
	ld hl, CeladonMartElevatorWarpMaps
	ld de, wElevatorWarpMaps
	ld bc, CeladonMartElevatorWarpMaps.End - CeladonMartElevatorWarpMaps
	jp CopyData

CeladonMartElevatorFloors:
	.DB 5 ; #
	.DB FLOOR_1F
	.DB FLOOR_2F
	.DB FLOOR_3F
	.DB FLOOR_4F
	.DB FLOOR_5F
	.DB -1 ; end

; These specify where the player goes after getting out of the elevator.
CeladonMartElevatorWarpMaps:
	; warp number, map id
	.DB 5, CELADON_MART_1F
	.DB 2, CELADON_MART_2F
	.DB 2, CELADON_MART_3F
	.DB 2, CELADON_MART_4F
	.DB 2, CELADON_MART_5F
CeladonMartElevatorWarpMaps.End:

CeladonMartElevatorShakeScript:
	farjp ShakeElevator

CeladonMartElevator_TextPointers:
	def_text_pointers
	dw_const CeladonMartElevatorText, TEXT_CELADONMARTELEVATOR

CeladonMartElevatorText:
	text_asm
	call CeladonMartElevatorCopyWarpMapsScript
	ld hl, CeladonMartElevatorWarpMaps
	predef DisplayElevatorFloorMenu
	jp TextScriptEnd
