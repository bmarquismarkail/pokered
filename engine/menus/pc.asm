ActivatePC:
	call SaveScreenTilesToBuffer2
	ld a, SFX_TURN_ON_PC
	call PlaySound
	ld hl, TurnedOnPC1Text
	call PrintText
	call WaitForSoundToFinish
	ld hl, wMiscFlags
	set BIT_USING_GENERIC_PC, [hl]
	call LoadScreenTilesFromBuffer2
	call Delay3
PCMainMenu:
	farcall DisplayPCMainMenu
	ld hl, wMiscFlags
	set BIT_NO_MENU_BUTTON_SOUND, [hl]
	call HandleMenuInput
	bit B_PAD_B, a
	jp nz, LogOff
	ld a, [wMaxMenuItem]
	cp 2
	jr nz, PCMainMenu.next ;if not 2 menu items (not counting log off) (2 occurs before you get the pokedex)
	ld a, [wCurrentMenuItem]
	and a
	jp z, BillsPC    ;if current menu item id is 0, it's bills pc
	cp 1
	jr z, PCMainMenu.playersPC ;if current menu item id is 1, it's players pc
	jp LogOff        ;otherwise, it's 2, and you're logging off
PCMainMenu.next
	cp 3
	jr nz, PCMainMenu.next2 ;if not 3 menu items (not counting log off) (3 occurs after you get the pokedex, before you beat the pokemon league)
	ld a, [wCurrentMenuItem]
	and a
	jp z, BillsPC    ;if current menu item id is 0, it's bills pc
	cp 1
	jr z, PCMainMenu.playersPC ;if current menu item id is 1, it's players pc
	cp 2
	jp z, OaksPC     ;if current menu item id is 2, it's oaks pc
	jp LogOff        ;otherwise, it's 3, and you're logging off
PCMainMenu.next2
	ld a, [wCurrentMenuItem]
	and a
	jp z, BillsPC    ;if current menu item id is 0, it's bills pc
	cp 1
	jr z, PCMainMenu.playersPC ;if current menu item id is 1, it's players pc
	cp 2
	jp z, OaksPC     ;if current menu item id is 2, it's oaks pc
	cp 3
	jp z, PKMNLeague ;if current menu item id is 3, it's pkmnleague
	jp LogOff        ;otherwise, it's 4, and you're logging off
PCMainMenu.playersPC
	ld hl, wMiscFlags
	res BIT_NO_MENU_BUTTON_SOUND, [hl]
	set BIT_USING_GENERIC_PC, [hl]
	ld a, SFX_ENTER_PC
	call PlaySound
	call WaitForSoundToFinish
	ld hl, AccessedMyPCText
	call PrintText
	farcall PlayerPC
	jr ReloadMainMenu
OaksPC:
	ld a, SFX_ENTER_PC
	call PlaySound
	call WaitForSoundToFinish
	farcall OpenOaksPC
	jr ReloadMainMenu
PKMNLeague:
	ld a, SFX_ENTER_PC
	call PlaySound
	call WaitForSoundToFinish
	farcall PKMNLeaguePC
	jr ReloadMainMenu
BillsPC:
	ld a, SFX_ENTER_PC
	call PlaySound
	call WaitForSoundToFinish
	CheckEvent EVENT_MET_BILL
	jr nz, BillsPC.billsPC ;if you've met bill, use that bill's instead of someone's
	ld hl, AccessedSomeonesPCText
	jr BillsPC.printText
BillsPC.billsPC
	ld hl, AccessedBillsPCText
BillsPC.printText
	call PrintText
	farcall BillsPC_
ReloadMainMenu:
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call ReloadMapData
	call UpdateSprites
	jp PCMainMenu
LogOff:
	ld a, SFX_TURN_OFF_PC
	call PlaySound
	call WaitForSoundToFinish
	ld hl, wMiscFlags
	res BIT_USING_GENERIC_PC, [hl]
	res BIT_NO_MENU_BUTTON_SOUND, [hl]
	ret

TurnedOnPC1Text:
	text_far WLA_GLOBAL_TurnedOnPC1Text
	text_end

AccessedBillsPCText:
	text_far WLA_GLOBAL_AccessedBillsPCText
	text_end

AccessedSomeonesPCText:
	text_far WLA_GLOBAL_AccessedSomeonesPCText
	text_end

AccessedMyPCText:
	text_far WLA_GLOBAL_AccessedMyPCText
	text_end

; removes one of the specified item ID [hItemToRemoveID] from bag (if existent)
RemoveItemByID:
	ld hl, wBagItems
	ldh a, [lobyte(hItemToRemoveID)]
	ld b, a
	xor a
	ldh [lobyte(hItemToRemoveIndex)], a
RemoveItemByID.loop
	ld a, [hli]
	cp -1 ; reached terminator?
	ret z
	cp b
	jr z, RemoveItemByID.foundItem
	inc hl
	ldh a, [lobyte(hItemToRemoveIndex)]
	inc a
	ldh [lobyte(hItemToRemoveIndex)], a
	jr RemoveItemByID.loop
RemoveItemByID.foundItem
	ld a, $1
	ld [wItemQuantity], a
	ldh a, [lobyte(hItemToRemoveIndex)]
	ld [wWhichPokemon], a
	ld hl, wNumBagItems
	jp RemoveItemFromInventory
