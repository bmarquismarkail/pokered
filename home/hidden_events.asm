UpdateCinnabarGymGateTileBlocks:
	farjp UpdateCinnabarGymGateTileBlocks_

CheckForHiddenEventOrBookshelfOrCardKeyDoor:
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ldh a, [lobyte(hJoyHeld)]
	bit B_PAD_A, a
	jr z, CheckForHiddenEventOrBookshelfOrCardKeyDoor.nothingFound
; A button is pressed
	ld a, bank(CheckForHiddenEvent)
	ld [rROMB], a
	ldh [lobyte(hLoadedROMBank)], a
	call CheckForHiddenEvent
	ldh a, [lobyte(hDidntFindAnyHiddenEvent)]
	and a
	jr nz, CheckForHiddenEventOrBookshelfOrCardKeyDoor.hiddenEventNotFound
	ld a, [wHiddenEventFunctionRomBank]
	ld [rROMB], a
	ldh [lobyte(hLoadedROMBank)], a
	ld de, CheckForHiddenEventOrBookshelfOrCardKeyDoor.returnAddress
	push de
	jp hl
CheckForHiddenEventOrBookshelfOrCardKeyDoor.returnAddress
	xor a
	jr CheckForHiddenEventOrBookshelfOrCardKeyDoor.done
CheckForHiddenEventOrBookshelfOrCardKeyDoor.hiddenEventNotFound
	farcall PrintBookshelfText
	ldh a, [lobyte(hInteractedWithBookshelf)]
	and a
	jr z, CheckForHiddenEventOrBookshelfOrCardKeyDoor.done
CheckForHiddenEventOrBookshelfOrCardKeyDoor.nothingFound
	ld a, $ff
CheckForHiddenEventOrBookshelfOrCardKeyDoor.done
	ldh [lobyte(hItemAlreadyFound)], a
	pop af
	ld [rROMB], a
	ldh [lobyte(hLoadedROMBank)], a
	ret
