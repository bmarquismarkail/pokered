HiddenItems:
	ld hl, HiddenItemCoords
	call FindHiddenItemOrCoinsIndex
	ld [wHiddenItemOrCoinsIndex], a
	ld hl, wObtainedHiddenItemsFlags
	ld a, [wHiddenItemOrCoinsIndex]
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	ret nz
	call EnableAutoTextBoxDrawing
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, [wHiddenEventFunctionArgument] ; item ID
	ld [wNamedObjectIndex], a
	call GetItemName
	tx_pre_jump FoundHiddenItemText

.INCLUDE "data/events/hidden_item_coords.asm"

FoundHiddenItemText:
	text_far WLA_GLOBAL_FoundHiddenItemText
	text_asm
	ld a, [wHiddenEventFunctionArgument] ; item ID
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, FoundHiddenItemText.bagFull
	ld hl, wObtainedHiddenItemsFlags
	ld a, [wHiddenItemOrCoinsIndex]
	ld c, a
	ld b, FLAG_SET
	predef FlagActionPredef
	ld a, SFX_GET_ITEM_2
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	jp TextScriptEnd
FoundHiddenItemText.bagFull
	call WaitForTextScrollButtonPress ; wait for button press
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, HiddenItemBagFullText
	call PrintText
	jp TextScriptEnd

HiddenItemBagFullText:
	text_far WLA_GLOBAL_HiddenItemBagFullText
	text_end

HiddenCoins:
	ld b, COIN_CASE
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret z
	ld hl, HiddenCoinCoords
	call FindHiddenItemOrCoinsIndex
	ld [wHiddenItemOrCoinsIndex], a
	ld hl, wObtainedHiddenCoinsFlags
	ld a, [wHiddenItemOrCoinsIndex]
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	ret nz
	xor a
	ldh [lobyte(hUnusedCoinsByte)], a
	ldh [lobyte(hCoins)], a
	ldh [lobyte(hCoins + 1)], a
	ld a, [wHiddenEventFunctionArgument]
	sub COIN
	cp 10
	jr z, HiddenCoins.bcd10
	cp 20
	jr z, HiddenCoins.bcd20
	cp 40
	jr z, HiddenCoins.bcd20 ; should be bcd40
	jr HiddenCoins.bcd100
HiddenCoins.bcd10
	ld a, $10
	ldh [lobyte(hCoins + 1)], a
	jr HiddenCoins.bcdDone
HiddenCoins.bcd20
	ld a, $20
	ldh [lobyte(hCoins + 1)], a
	jr HiddenCoins.bcdDone
HiddenCoins.bcd40 ; due to a typo, this is never used
	ld a, $40
	ldh [lobyte(hCoins + 1)], a
	jr HiddenCoins.bcdDone
HiddenCoins.bcd100
	ld a, $1
	ldh [lobyte(hCoins)], a
HiddenCoins.bcdDone
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef
	ld hl, wObtainedHiddenCoinsFlags
	ld a, [wHiddenItemOrCoinsIndex]
	ld c, a
	ld b, FLAG_SET
	predef FlagActionPredef
	call EnableAutoTextBoxDrawing
	ld a, [wPlayerCoins]
	cp $99
	jr nz, HiddenCoins.roomInCoinCase
	ld a, [wPlayerCoins + 1]
	cp $99
	jr nz, HiddenCoins.roomInCoinCase
	tx_pre_id DroppedHiddenCoinsText
	jr HiddenCoins.done
HiddenCoins.roomInCoinCase
	tx_pre_id FoundHiddenCoinsText
HiddenCoins.done
	jp PrintPredefTextID

.INCLUDE "data/events/hidden_coins.asm"

FoundHiddenCoinsText:
	text_far WLA_GLOBAL_FoundHiddenCoinsText
	sound_get_item_2
	text_end

DroppedHiddenCoinsText:
	text_far WLA_GLOBAL_FoundHiddenCoins2Text
	sound_get_item_2
	text_far WLA_GLOBAL_DroppedHiddenCoinsText
	text_end

FindHiddenItemOrCoinsIndex:
	ld a, [wHiddenEventY]
	ld d, a
	ld a, [wHiddenEventX]
	ld e, a
	ld a, [wCurMap]
	ld b, a
	ld c, -1
FindHiddenItemOrCoinsIndex.loop
	inc c
	ld a, [hli]
	cp -1 ; end of the list?
	ret z  ; if so, we're done here
	cp b
	jr nz, FindHiddenItemOrCoinsIndex.next1
	ld a, [hli]
	cp d
	jr nz, FindHiddenItemOrCoinsIndex.next2
	ld a, [hli]
	cp e
	jr nz, FindHiddenItemOrCoinsIndex.loop
	ld a, c
	ret
FindHiddenItemOrCoinsIndex.next1
	inc hl
FindHiddenItemOrCoinsIndex.next2
	inc hl
	jr FindHiddenItemOrCoinsIndex.loop
