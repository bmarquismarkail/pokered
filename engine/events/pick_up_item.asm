PickUpItem:
	call EnableAutoTextBoxDrawing

	ldh a, [lobyte(hSpriteIndex)]
	ld b, a
	ld hl, wToggleableObjectList
PickUpItem.toggleableObjectsListLoop
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr z, PickUpItem.isToggleable
	inc hl
	jr PickUpItem.toggleableObjectsListLoop

PickUpItem.isToggleable
	ld a, [hl]
	ldh [lobyte(hToggleableObjectIndex)], a

	ld hl, wMapSpriteExtraData
	ldh a, [lobyte(hSpriteIndex)]
	dec a
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld b, a ; item
	ld c, 1 ; quantity
	call GiveItem
	jr nc, PickUpItem.BagFull

	ldh a, [lobyte(hToggleableObjectIndex)]
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, FoundItemText
	jr PickUpItem.print

PickUpItem.BagFull
	ld hl, NoMoreRoomForItemText
PickUpItem.print
	call PrintText
	ret

FoundItemText:
	text_far WLA_GLOBAL_FoundItemText
	sound_get_item_1
	text_end

NoMoreRoomForItemText:
	text_far WLA_GLOBAL_NoMoreRoomForItemText
	text_end
