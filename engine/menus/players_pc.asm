PlayerPC:
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	ld a, ITEM_NAME
	ld [wNameListType], a
	call SaveScreenTilesToBuffer1
	xor a
	ld [wBagSavedMenuItem], a
	ld [wParentMenuItem], a
	ld a, [wMiscFlags]
	bit BIT_USING_GENERIC_PC, a
	jr nz, PlayerPCMenu
; accessing it directly
	ld a, SFX_TURN_ON_PC
	call PlaySound
	ld hl, TurnedOnPC2Text
	call PrintText

PlayerPCMenu:
	ld a, [wParentMenuItem]
	ld [wCurrentMenuItem], a
	ld hl, wMiscFlags
	set BIT_NO_MENU_BUTTON_SOUND, [hl]
	call LoadScreenTilesFromBuffer2
	hlcoord 0, 0
	ld b, $8
	ld c, $e
	call TextBoxBorder
	call UpdateSprites
	hlcoord 2, 2
	ld de, PlayersPCMenuEntries
	call PlaceString
	ld hl, wTopMenuItemY
	ld a, 2
	ld [hli], a ; wTopMenuItemY
	dec a
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, 3
	ld [hli], a ; wMaxMenuItem
	ld a, PAD_A | PAD_B
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hl], a
	ld hl, wListScrollOffset
	ld [hli], a ; wListScrollOffset
	ld [hl], a ; wMenuWatchMovingOutOfBounds
	ld [wPlayerMonNumber], a
	ld hl, WhatDoYouWantText
	call PrintText
	call HandleMenuInput
	bit B_PAD_B, a
	jp nz, ExitPlayerPC
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	ld [wParentMenuItem], a
	and a
	jp z, PlayerPCWithdraw
	dec a
	jp z, PlayerPCDeposit
	dec a
	jp z, PlayerPCToss

ExitPlayerPC:
	ld a, [wMiscFlags]
	bit BIT_USING_GENERIC_PC, a
	jr nz, ExitPlayerPC.next
; accessing it directly
	ld a, SFX_TURN_OFF_PC
	call PlaySound
	call WaitForSoundToFinish
ExitPlayerPC.next
	ld hl, wMiscFlags
	res BIT_NO_MENU_BUTTON_SOUND, [hl]
	call LoadScreenTilesFromBuffer2
	xor a
	ld [wListScrollOffset], a
	ld [wBagSavedMenuItem], a
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret

PlayerPCDeposit:
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld a, [wNumBagItems]
	and a
	jr nz, PlayerPCDeposit.loop
	ld hl, NothingToDepositText
	call PrintText
	jp PlayerPCMenu
PlayerPCDeposit.loop
	ld hl, WhatToDepositText
	call PrintText
	ld hl, wNumBagItems
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	call DisplayListMenuID
	jp c, PlayerPCMenu
	call IsKeyItem
	ld a, 1
	ld [wItemQuantity], a
	ld a, [wIsKeyItem]
	and a
	jr nz, PlayerPCDeposit.next
; if it's not a key item, there can be more than one of the item
	ld hl, DepositHowManyText
	call PrintText
	call DisplayChooseQuantityMenu
	cp $ff
	jp z, PlayerPCDeposit.loop
PlayerPCDeposit.next
	ld hl, wNumBoxItems
	call AddItemToInventory
	jr c, PlayerPCDeposit.roomAvailable
	ld hl, NoRoomToStoreText
	call PrintText
	jp PlayerPCDeposit.loop
PlayerPCDeposit.roomAvailable
	ld hl, wNumBagItems
	call RemoveItemFromInventory
	call WaitForSoundToFinish
	ld a, SFX_WITHDRAW_DEPOSIT
	call PlaySound
	call WaitForSoundToFinish
	ld hl, ItemWasStoredText
	call PrintText
	jp PlayerPCDeposit.loop

PlayerPCWithdraw:
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld a, [wNumBoxItems]
	and a
	jr nz, PlayerPCWithdraw.loop
	ld hl, NothingStoredText
	call PrintText
	jp PlayerPCMenu
PlayerPCWithdraw.loop
	ld hl, WhatToWithdrawText
	call PrintText
	ld hl, wNumBoxItems
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	call DisplayListMenuID
	jp c, PlayerPCMenu
	call IsKeyItem
	ld a, 1
	ld [wItemQuantity], a
	ld a, [wIsKeyItem]
	and a
	jr nz, PlayerPCWithdraw.next
; if it's not a key item, there can be more than one of the item
	ld hl, WithdrawHowManyText
	call PrintText
	call DisplayChooseQuantityMenu
	cp $ff
	jp z, PlayerPCWithdraw.loop
PlayerPCWithdraw.next
	ld hl, wNumBagItems
	call AddItemToInventory
	jr c, PlayerPCWithdraw.roomAvailable
	ld hl, CantCarryMoreText
	call PrintText
	jp PlayerPCWithdraw.loop
PlayerPCWithdraw.roomAvailable
	ld hl, wNumBoxItems
	call RemoveItemFromInventory
	call WaitForSoundToFinish
	ld a, SFX_WITHDRAW_DEPOSIT
	call PlaySound
	call WaitForSoundToFinish
	ld hl, WithdrewItemText
	call PrintText
	jp PlayerPCWithdraw.loop

PlayerPCToss:
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld a, [wNumBoxItems]
	and a
	jr nz, PlayerPCToss.loop
	ld hl, NothingStoredText
	call PrintText
	jp PlayerPCMenu
PlayerPCToss.loop
	ld hl, WhatToTossText
	call PrintText
	ld hl, wNumBoxItems
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	push hl
	call DisplayListMenuID
	pop hl
	jp c, PlayerPCMenu
	push hl
	call IsKeyItem
	pop hl
	ld a, 1
	ld [wItemQuantity], a
	ld a, [wIsKeyItem]
	and a
	jr nz, PlayerPCToss.next
	ld a, [wCurItem]
	call IsItemHM
	jr c, PlayerPCToss.next
; if it's not a key item, there can be more than one of the item
	push hl
	ld hl, TossHowManyText
	call PrintText
	call DisplayChooseQuantityMenu
	pop hl
	cp $ff
	jp z, PlayerPCToss.loop
PlayerPCToss.next
	call TossItem ; disallows tossing key items
	jp PlayerPCToss.loop

PlayersPCMenuEntries:
		.STRINGMAP pokemon, "WITHDRAW ITEM"
	next "DEPOSIT ITEM"
	next "TOSS ITEM"
	next "LOG OFF@"

TurnedOnPC2Text:
	text_far WLA_GLOBAL_TurnedOnPC2Text
	text_end

WhatDoYouWantText:
	text_far WLA_GLOBAL_WhatDoYouWantText
	text_end

WhatToDepositText:
	text_far WLA_GLOBAL_WhatToDepositText
	text_end

DepositHowManyText:
	text_far WLA_GLOBAL_DepositHowManyText
	text_end

ItemWasStoredText:
	text_far WLA_GLOBAL_ItemWasStoredText
	text_end

NothingToDepositText:
	text_far WLA_GLOBAL_NothingToDepositText
	text_end

NoRoomToStoreText:
	text_far WLA_GLOBAL_NoRoomToStoreText
	text_end

WhatToWithdrawText:
	text_far WLA_GLOBAL_WhatToWithdrawText
	text_end

WithdrawHowManyText:
	text_far WLA_GLOBAL_WithdrawHowManyText
	text_end

WithdrewItemText:
	text_far WLA_GLOBAL_WithdrewItemText
	text_end

NothingStoredText:
	text_far WLA_GLOBAL_NothingStoredText
	text_end

CantCarryMoreText:
	text_far WLA_GLOBAL_CantCarryMoreText
	text_end

WhatToTossText:
	text_far WLA_GLOBAL_WhatToTossText
	text_end

TossHowManyText:
	text_far WLA_GLOBAL_TossHowManyText
	text_end
