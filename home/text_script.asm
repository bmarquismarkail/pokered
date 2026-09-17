; this function is used to display sign messages, sprite dialog, etc.
; INPUT: [hSpriteIndex] = sprite ID or [hTextID] = text ID
DisplayTextID:
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	farcall DisplayTextIDInit ; initialization
	ld hl, wTextPredefFlag
	bit BIT_TEXT_PREDEF, [hl]
	res BIT_TEXT_PREDEF, [hl]
	jr nz, DisplayTextID.skipSwitchToMapBank
	ld a, [wCurMap]
	call SwitchToMapRomBank
DisplayTextID.skipSwitchToMapBank
	ld a, 30 ; half a second
	ldh [lobyte(hFrameCounter)], a ; used as joypad poll timer
	ld hl, wCurMapTextPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = map text pointer
	ld d, $00
	ldh a, [lobyte(hTextID)]
	ld [wSpriteIndex], a

	dict TEXT_START_MENU,       DisplayStartMenu
	dict TEXT_SAFARI_GAME_OVER, DisplaySafariGameOverText
	dict TEXT_MON_FAINTED,      DisplayPokemonFaintedText
	dict TEXT_BLACKED_OUT,      DisplayPlayerBlackedOutText
	dict TEXT_REPEL_WORE_OFF,   DisplayRepelWoreOffText

	ld a, [wNumSprites]
	ld e, a
	ldh a, [lobyte(hSpriteIndex)] ; sprite ID
	cp e
	jr z, DisplayTextID.spriteHandling
	jr nc, DisplayTextID.skipSpriteHandling
DisplayTextID.spriteHandling
; get the text ID of the sprite
	push hl
	push de
	push bc
	farcall UpdateSpriteFacingOffsetAndDelayMovement ; update the graphics of the sprite the player is talking to (to face the right direction)
	pop bc
	pop de
	ld hl, wMapSpriteData ; NPC text entries
	ldh a, [lobyte(hSpriteIndex)]
	dec a
	add a
	add l
	ld l, a
	jr nc, DisplayTextID.noCarry
	inc h
DisplayTextID.noCarry
	inc hl
	ld a, [hl] ; a = text ID of the sprite
	pop hl
DisplayTextID.skipSpriteHandling
; look up the address of the text in the map's text entries
	dec a
	ld e, a
	sla e
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = address of the text
	ld a, [hl] ; a = first byte of text

; check first byte of text for special cases

.MACRO dict_farcall
	cp \1
	jr nz, .not_far\@
	ld b, bank(\2)
	ld hl, \2
	call Bankswitch
	jr AfterDisplayingTextID
DisplayTextID.not_u2:
.not_far\@
.ENDM

.MACRO dict_callfar
	cp \1
	jr nz, .not_callfar\@
	ld hl, \2
	ld b, bank(\2)
	call Bankswitch
	jr AfterDisplayingTextID
DisplayTextID.not_u3:
.not_callfar\@
.ENDM

	dict  TX_SCRIPT_MART,                    DisplayPokemartDialogue
	dict  TX_SCRIPT_POKECENTER_NURSE,        DisplayPokemonCenterDialogue
	dict  TX_SCRIPT_PLAYERS_PC,              TextScript_ItemStoragePC
	dict  TX_SCRIPT_BILLS_PC,                TextScript_BillsPC
	dict  TX_SCRIPT_POKECENTER_PC,           TextScript_PokemonCenterPC
	dict_farcall TX_SCRIPT_VENDING_MACHINE, VendingMachineMenu
	dict  TX_SCRIPT_PRIZE_VENDOR,            TextScript_GameCornerPrizeMenu
	dict_callfar TX_SCRIPT_CABLE_CLUB_RECEPTIONIST, CableClubNPC

	call PrintText_NoCreatingTextBox
	ld a, [wDoNotWaitForButtonPressAfterDisplayingText]
	and a
	jr nz, HoldTextDisplayOpen

AfterDisplayingTextID:
	ld a, [wEnteringCableClub]
	and a
	jr nz, HoldTextDisplayOpen
	call WaitForTextScrollButtonPress

; loop to hold the dialogue box open as long as the player keeps holding down the A button
HoldTextDisplayOpen:
	call Joypad
	ldh a, [lobyte(hJoyHeld)]
	bit B_PAD_A, a
	jr nz, HoldTextDisplayOpen

CloseTextDisplay:
	ld a, [wCurMap]
	call SwitchToMapRomBank
	ld a, $90
	ldh [lobyte(hWY)], a ; move the window off the screen
	call DelayFrame
	call LoadGBPal
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a ; disable continuous WRAM to VRAM transfer each V-blank
; loop to make sprites face the directions they originally faced before the dialogue
	ld hl, wSprite01StateData2OrigFacingDirection
	ld c, NUM_SPRITESTATEDATA_STRUCTS - 1
	ld de, SPRITESTATEDATA1_LENGTH
CloseTextDisplay.restoreSpriteFacingDirectionLoop
	ld a, [hl] ; x#SPRITESTATEDATA2_ORIGFACINGDIRECTION
	dec h
	ld [hl], a ; [x#SPRITESTATEDATA1_FACINGDIRECTION]
	inc h
	add hl, de
	dec c
	jr nz, CloseTextDisplay.restoreSpriteFacingDirectionLoop
	ld a, bank(InitMapSprites)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	call InitMapSprites ; reload sprite tile pattern data (since it was partially overwritten by text tile patterns)
	ld hl, wFontLoaded
	res BIT_FONT_LOADED, [hl]
	ld a, [wStatusFlags6]
	bit BIT_FLY_WARP, a
	call z, LoadPlayerSpriteGraphics
	call LoadCurrentMapView
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	jp UpdateSprites

DisplayPokemartDialogue:
	push hl
	ld hl, PokemartGreetingText
	call PrintText
	pop hl
	inc hl
	call LoadItemList
	ld a, PRICEDITEMLISTMENU
	ld [wListMenuID], a
	homecall DisplayPokemartDialogue_
	jp AfterDisplayingTextID

PokemartGreetingText:
	text_far WLA_GLOBAL_PokemartGreetingText
	text_end

LoadItemList:
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	ld a, h
	ld [wItemListPointer], a
	ld a, l
	ld [wItemListPointer + 1], a
	ld de, wItemList
LoadItemList.loop
	ld a, [hli]
	ld [de], a
	inc de
	cp $ff
	jr nz, LoadItemList.loop
	ret

DisplayPokemonCenterDialogue:
; zeroing these doesn't appear to serve any purpose
	xor a
	ldh [lobyte(hItemPrice)], a
	ldh [lobyte(hItemPrice + 1)], a
	ldh [lobyte(hItemPrice + 2)], a

	inc hl
	homecall DisplayPokemonCenterDialogue_
	jp AfterDisplayingTextID

DisplaySafariGameOverText:
	callfar PrintSafariGameOverText
	jp AfterDisplayingTextID

DisplayPokemonFaintedText:
	ld hl, PokemonFaintedText
	call PrintText
	jp AfterDisplayingTextID

PokemonFaintedText:
	text_far WLA_GLOBAL_PokemonFaintedText
	text_end

DisplayPlayerBlackedOutText:
	ld hl, PlayerBlackedOutText
	call PrintText
	ld a, [wStatusFlags6]
	res BIT_ALWAYS_ON_BIKE, a
	ld [wStatusFlags6], a
	jp HoldTextDisplayOpen

PlayerBlackedOutText:
	text_far WLA_GLOBAL_PlayerBlackedOutText
	text_end

DisplayRepelWoreOffText:
	ld hl, RepelWoreOffText
	call PrintText
	jp AfterDisplayingTextID

RepelWoreOffText:
	text_far WLA_GLOBAL_RepelWoreOffText
	text_end
