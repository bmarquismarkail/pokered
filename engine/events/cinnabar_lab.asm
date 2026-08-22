GiveFossilToCinnabarLab:
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	xor a
	ld [wCurrentMenuItem], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, [wFilteredBagItemsCount]
	dec a
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	ld a, [wFilteredBagItemsCount]
	dec a
	ld bc, 2
	ld hl, 3
	call AddNTimes
	dec l
	ld b, l
	ld c, $d
	hlcoord 0, 0
	call TextBoxBorder
	call UpdateSprites
	call PrintFossilsInBag
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, GiveFossilToCinnabarLab.cancelledGivingFossil
	ld hl, wFilteredBagItems
	ld a, [wCurrentMenuItem]
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ldh [lobyte(hItemToRemoveID)], a
	cp DOME_FOSSIL
	jr z, GiveFossilToCinnabarLab.choseDomeFossil
	cp HELIX_FOSSIL
	jr z, GiveFossilToCinnabarLab.choseHelixFossil
	ld b, AERODACTYL
	jr GiveFossilToCinnabarLab.fossilSelected
GiveFossilToCinnabarLab.choseHelixFossil
	ld b, OMANYTE
	jr GiveFossilToCinnabarLab.fossilSelected
GiveFossilToCinnabarLab.choseDomeFossil
	ld b, KABUTO
GiveFossilToCinnabarLab.fossilSelected
	ld [wFossilItem], a
	ld a, b
	ld [wFossilMon], a
	call LoadFossilItemAndMonName
	ld hl, GiveFossilToCinnabarLab.ScientistSeesFossilText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, GiveFossilToCinnabarLab.cancelledGivingFossil
	ld hl, GiveFossilToCinnabarLab.ScientistTakesFossilText
	call PrintText
	ld a, [wFossilItem]
	ldh [lobyte(hItemToRemoveID)], a
	farcall RemoveItemByID
	ld hl, GiveFossilToCinnabarLab.GoForAWalkText
	call PrintText
	SetEvents EVENT_GAVE_FOSSIL_TO_LAB, EVENT_LAB_STILL_REVIVING_FOSSIL
	ret
GiveFossilToCinnabarLab.cancelledGivingFossil
	ld hl, GiveFossilToCinnabarLab.ComeAgainText
	call PrintText
	ret

GiveFossilToCinnabarLab.ScientistSeesFossilText:
	text_far WLA_GLOBAL_CinnabarLabFossilRoomScientist1SeesFossilText
	text_end

GiveFossilToCinnabarLab.ScientistTakesFossilText:
	text_far WLA_GLOBAL_CinnabarLabFossilRoomScientist1TakesFossilText
	text_end

GiveFossilToCinnabarLab.GoForAWalkText:
	text_far WLA_GLOBAL_CinnabarLabFossilRoomScientist1GoForAWalkText2
	text_end

GiveFossilToCinnabarLab.ComeAgainText:
	text_far WLA_GLOBAL_CinnabarLabFossilRoomScientist1ComeAgainText
	text_end

PrintFossilsInBag:
; Prints each fossil in the player's bag on a separate line in the menu.
	ld hl, wFilteredBagItems
	xor a
	ldh [lobyte(hItemCounter)], a
PrintFossilsInBag.loop
	ld a, [hli]
	cp $ff
	ret z
	push hl
	ld [wNamedObjectIndex], a
	call GetItemName
	hlcoord 2, 2
	ldh a, [lobyte(hItemCounter)]
	ld bc, SCREEN_WIDTH * 2
	call AddNTimes
	ld de, wNameBuffer
	call PlaceString
	ld hl, hItemCounter
	inc [hl]
	pop hl
	jr PrintFossilsInBag.loop

; loads the names of the fossil item and the resulting mon
LoadFossilItemAndMonName:
	ld a, [wFossilMon]
	ld [wNamedObjectIndex], a
	call GetMonName
	call CopyToStringBuffer
	ld a, [wFossilItem]
	ld [wNamedObjectIndex], a
	call GetItemName
	ret
