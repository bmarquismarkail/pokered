SilphCoElevator_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	push hl
	call nz, SilphCoElevatorStoreWarpEntriesScript
	pop hl
	bit BIT_CUR_MAP_USED_ELEVATOR, [hl]
	res BIT_CUR_MAP_USED_ELEVATOR, [hl]
	call nz, SilphCoElevatorShakeScript
	xor a
	ld [wAutoTextBoxDrawingControl], a
	inc a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret

SilphCoElevatorStoreWarpEntriesScript:
	ld hl, wWarpEntries
	ld a, [wWarpedFromWhichWarp]
	ld b, a
	ld a, [wWarpedFromWhichMap]
	ld c, a
	call SilphCoElevatorStoreWarpEntriesScript.StoreWarpEntry
	; fallthrough
SilphCoElevatorStoreWarpEntriesScript.StoreWarpEntry:
	inc hl
	inc hl
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ret

SilphCoElevatorCopyWarpMapsScript:
	ld hl, SilphCoElevatorFloors
	call LoadItemList
	ld hl, SilphCoElevatorWarpMaps
	ld de, wElevatorWarpMaps
	ld bc, SilphCoElevatorWarpMaps.End - SilphCoElevatorWarpMaps
	call CopyData
	ret

SilphCoElevatorFloors:
	.DB 11 ; #
	.DB FLOOR_1F
	.DB FLOOR_2F
	.DB FLOOR_3F
	.DB FLOOR_4F
	.DB FLOOR_5F
	.DB FLOOR_6F
	.DB FLOOR_7F
	.DB FLOOR_8F
	.DB FLOOR_9F
	.DB FLOOR_10F
	.DB FLOOR_11F
	.DB -1 ; end

; These specify where the player goes after getting out of the elevator.
SilphCoElevatorWarpMaps:
	; warp number, map id
	.DB 3, SILPH_CO_1F
	.DB 2, SILPH_CO_2F
	.DB 2, SILPH_CO_3F
	.DB 2, SILPH_CO_4F
	.DB 2, SILPH_CO_5F
	.DB 2, SILPH_CO_6F
	.DB 2, SILPH_CO_7F
	.DB 2, SILPH_CO_8F
	.DB 2, SILPH_CO_9F
	.DB 2, SILPH_CO_10F
	.DB 1, SILPH_CO_11F
SilphCoElevatorWarpMaps.End:

SilphCoElevatorShakeScript:
	call Delay3
	farcall ShakeElevator
	ret

SilphCoElevator_TextPointers:
	def_text_pointers
	dw_const SilphCoElevatorElevatorText, TEXT_SILPHCOELEVATOR_ELEVATOR

SilphCoElevatorElevatorText:
	text_asm
	call SilphCoElevatorCopyWarpMapsScript
	ld hl, SilphCoElevatorWarpMaps
	predef DisplayElevatorFloorMenu
	jp TextScriptEnd
