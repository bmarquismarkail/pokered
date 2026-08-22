StartMenu_Pokedex:
	predef ShowPokedexMenu
	call LoadScreenTilesFromBuffer2
	call Delay3
	call LoadGBPal
	call UpdateSprites
	jp RedisplayStartMenu

StartMenu_Pokemon:
	ld a, [wPartyCount]
	and a
	jp z, RedisplayStartMenu
	xor a
	ld [wMenuItemToSwap], a
	ld [wPartyMenuTypeOrMessageID], a
	ld [wUpdateSpritesEnabled], a
	call DisplayPartyMenu
	jr StartMenu_Pokemon.checkIfPokemonChosen
StartMenu_Pokemon.loop
	xor a
	ld [wMenuItemToSwap], a
	ld [wPartyMenuTypeOrMessageID], a
	call GoBackToPartyMenu
StartMenu_Pokemon.checkIfPokemonChosen
	jr nc, StartMenu_Pokemon.chosePokemon
StartMenu_Pokemon.exitMenu
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	jp RedisplayStartMenu
StartMenu_Pokemon.chosePokemon
	call SaveScreenTilesToBuffer1
	ld a, FIELD_MOVE_MON_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID ; display pokemon menu options
	ld hl, wFieldMoves
	lb "bc", 2, 12 ; max menu item ID, top menu item Y
	ld e, 5
StartMenu_Pokemon.adjustMenuVariablesLoop
	dec e
	jr z, StartMenu_Pokemon.storeMenuVariables
	ld a, [hli]
	and a ; end of field moves?
	jr z, StartMenu_Pokemon.storeMenuVariables
	inc b
	dec c
	dec c
	jr StartMenu_Pokemon.adjustMenuVariablesLoop
StartMenu_Pokemon.storeMenuVariables
	ld hl, wTopMenuItemY
	ld a, c
	ld [hli], a ; top menu item Y
	ldh a, [lobyte(hFieldMoveMonMenuTopMenuItemX)]
	ld [hli], a ; top menu item X
	xor a
	ld [hli], a ; current menu item ID
	inc hl
	ld a, b
	ld [hli], a ; max menu item ID
	ld a, PAD_A | PAD_B
	ld [hli], a ; menu watched keys
	xor a
	ld [hl], a
	call HandleMenuInput
	push af
	call LoadScreenTilesFromBuffer1
	pop af
	bit B_PAD_B, a
	jp nz, StartMenu_Pokemon.loop
; if the B button wasn't pressed
	ld a, [wMaxMenuItem]
	ld b, a
	ld a, [wCurrentMenuItem] ; menu selection
	cp b
	jp z, StartMenu_Pokemon.exitMenu ; if the player chose Cancel
	dec b
	cp b
	jr z, StartMenu_Pokemon.choseSwitch
	dec b
	cp b
	jp z, StartMenu_Pokemon.choseStats
	ld c, a
	ld b, 0
	ld hl, wFieldMoves
	add hl, bc
	jp StartMenu_Pokemon.choseOutOfBattleMove
StartMenu_Pokemon.choseSwitch
	ld a, [wPartyCount]
	cp 2 ; is there more than one pokemon in the party?
	jp c, StartMenu_Pokemon ; if not, no switching
	call SwitchPartyMon_InitVarOrSwapData ; init [wMenuItemToSwap]
	ld a, SWAP_MONS_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call GoBackToPartyMenu
	jp StartMenu_Pokemon.checkIfPokemonChosen
StartMenu_Pokemon.choseStats
	call ClearSprites
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	predef StatusScreen
	predef StatusScreen2
	call ReloadMapData
	jp StartMenu_Pokemon
StartMenu_Pokemon.choseOutOfBattleMove
	push hl
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	pop hl
	ld a, [hl]
	dec a
	add a
	ld b, 0
	ld c, a
	ld hl, StartMenu_Pokemon.outOfBattleMovePointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wObtainedBadges]
	jp hl
StartMenu_Pokemon.outOfBattleMovePointers
	.DW StartMenu_Pokemon.cut
	.DW StartMenu_Pokemon.fly
	.DW StartMenu_Pokemon.surf
	.DW StartMenu_Pokemon.surf
	.DW StartMenu_Pokemon.strength
	.DW StartMenu_Pokemon.flash
	.DW StartMenu_Pokemon.dig
	.DW StartMenu_Pokemon.teleport
	.DW StartMenu_Pokemon.softboiled
StartMenu_Pokemon.fly
	bit BIT_THUNDERBADGE, a
	jp z, StartMenu_Pokemon.newBadgeRequired
	call CheckIfInOutsideMap
	jr z, StartMenu_Pokemon.canFly
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, StartMenu_Pokemon.cannotFlyHereText
	call PrintText
	jp StartMenu_Pokemon.loop
StartMenu_Pokemon.canFly
	call ChooseFlyDestination
	ld a, [wStatusFlags6]
	bit BIT_FLY_WARP, a
	jp nz, StartMenu_Pokemon.goBackToMap
	call LoadFontTilePatterns
	ld hl, wStatusFlags4
	set BIT_UNKNOWN_4_1, [hl]
	jp StartMenu_Pokemon
StartMenu_Pokemon.cut
	bit BIT_CASCADEBADGE, a
	jp z, StartMenu_Pokemon.newBadgeRequired
	predef UsedCut
	ld a, [wActionResultOrTookBattleTurn]
	and a
	jp z, StartMenu_Pokemon.loop
	jp CloseTextDisplay
StartMenu_Pokemon.surf
	bit BIT_SOULBADGE, a
	jp z, StartMenu_Pokemon.newBadgeRequired
	farcall IsSurfingAllowed
	ld hl, wStatusFlags1
	bit BIT_SURF_ALLOWED, [hl]
	res BIT_SURF_ALLOWED, [hl]
	jp z, StartMenu_Pokemon.loop
	ld a, SURFBOARD
	ld [wCurItem], a
	ld [wPseudoItemID], a
	call UseItem
	ld a, [wActionResultOrTookBattleTurn]
	and a
	jp z, StartMenu_Pokemon.loop
	call GBPalWhiteOutWithDelay3
	jp StartMenu_Pokemon.goBackToMap
StartMenu_Pokemon.strength
	bit BIT_RAINBOWBADGE, a
	jp z, StartMenu_Pokemon.newBadgeRequired
	predef PrintStrengthText
	call GBPalWhiteOutWithDelay3
	jp StartMenu_Pokemon.goBackToMap
StartMenu_Pokemon.flash
	bit BIT_BOULDERBADGE, a
	jp z, StartMenu_Pokemon.newBadgeRequired
	xor a
	ld [wMapPalOffset], a
	ld hl, StartMenu_Pokemon.flashLightsAreaText
	call PrintText
	call GBPalWhiteOutWithDelay3
	jp StartMenu_Pokemon.goBackToMap
StartMenu_Pokemon.flashLightsAreaText
	text_far WLA_GLOBAL_FlashLightsAreaText
	text_end
StartMenu_Pokemon.dig
	ld a, ESCAPE_ROPE
	ld [wCurItem], a
	ld [wPseudoItemID], a
	call UseItem
	ld a, [wActionResultOrTookBattleTurn]
	and a
	jp z, StartMenu_Pokemon.loop
	call GBPalWhiteOutWithDelay3
	jp StartMenu_Pokemon.goBackToMap
StartMenu_Pokemon.teleport
	call CheckIfInOutsideMap
	jr z, StartMenu_Pokemon.canTeleport
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, StartMenu_Pokemon.cannotUseTeleportNowText
	call PrintText
	jp StartMenu_Pokemon.loop
StartMenu_Pokemon.canTeleport
	ld hl, StartMenu_Pokemon.warpToLastPokemonCenterText
	call PrintText
	ld hl, wStatusFlags6
	set BIT_FLY_WARP, [hl]
	set BIT_ESCAPE_WARP, [hl]
	ld hl, wStatusFlags4
	set BIT_UNKNOWN_4_1, [hl]
	res BIT_NO_BATTLES, [hl]
	ld c, 60
	call DelayFrames
	call GBPalWhiteOutWithDelay3
	jp StartMenu_Pokemon.goBackToMap
StartMenu_Pokemon.warpToLastPokemonCenterText
	text_far WLA_GLOBAL_WarpToLastPokemonCenterText
	text_end
StartMenu_Pokemon.cannotUseTeleportNowText
	text_far WLA_GLOBAL_CannotUseTeleportNowText
	text_end
StartMenu_Pokemon.cannotFlyHereText
	text_far WLA_GLOBAL_CannotFlyHereText
	text_end
StartMenu_Pokemon.softboiled
	ld hl, wPartyMon1MaxHP
	ld a, [wWhichPokemon]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hli]
	ldh [lobyte(hDividend)], a
	ld a, [hl]
	ldh [lobyte(hDividend + 1)], a
	ld a, 5
	ldh [lobyte(hDivisor)], a
	ld b, 2 ; number of bytes
	call Divide
	ld bc, MON_HP - MON_MAXHP
	add hl, bc
	ld a, [hld]
	ld b, a
	ldh a, [lobyte(hQuotient + 3)]
	sub b
	ld b, [hl]
	ldh a, [lobyte(hQuotient + 2)]
	sbc b
	jp nc, StartMenu_Pokemon.notHealthyEnough
	ld a, [wPartyAndBillsPCSavedMenuItem]
	push af
	ld a, POTION
	ld [wCurItem], a
	ld [wPseudoItemID], a
	call UseItem
	pop af
	ld [wPartyAndBillsPCSavedMenuItem], a
	jp StartMenu_Pokemon.loop
StartMenu_Pokemon.notHealthyEnough ; if current HP is less than 1/5 of max HP
	ld hl, StartMenu_Pokemon.notHealthyEnoughText
	call PrintText
	jp StartMenu_Pokemon.loop
StartMenu_Pokemon.notHealthyEnoughText
	text_far WLA_GLOBAL_NotHealthyEnoughText
	text_end
StartMenu_Pokemon.goBackToMap
	call RestoreScreenTilesAndReloadTilePatterns
	jp CloseTextDisplay
StartMenu_Pokemon.newBadgeRequired
	ld hl, StartMenu_Pokemon.newBadgeRequiredText
	call PrintText
	jp StartMenu_Pokemon.loop
StartMenu_Pokemon.newBadgeRequiredText
	text_far WLA_GLOBAL_NewBadgeRequiredText
	text_end

; writes a blank + TILE_SIZE * to all possible menu cursor positions on the party menu
ErasePartyMenuCursors:
	hlcoord 0, 1
	ld bc, 2 * SCREEN_WIDTH ; menu cursor positions are 2 rows apart
	ld a, 6 ; 6 menu cursor positions
ErasePartyMenuCursors.loop
	ld [hl], $7f
	add hl, bc
	dec a
	jr nz, ErasePartyMenuCursors.loop
	ret

ItemMenuLoop:
	call LoadScreenTilesFromBuffer2DisableBGTransfer
	call RunDefaultPaletteCommand

StartMenu_Item:
	ld a, [wLinkState]
	dec a ; is the player in the Colosseum or Trade Centre?
	jr nz, StartMenu_Item.notInCableClubRoom
	ld hl, CannotUseItemsHereText
	call PrintText
	jr StartMenu_Item.exitMenu
StartMenu_Item.notInCableClubRoom
	ld bc, wNumBagItems
	ld hl, wListPointer
	ld a, c
	ld [hli], a
	ld [hl], b ; store item bag pointer in wListPointer (for DisplayListMenuID)
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	ld a, [wBagSavedMenuItem]
	ld [wCurrentMenuItem], a
	call DisplayListMenuID
	ld a, [wCurrentMenuItem]
	ld [wBagSavedMenuItem], a
	jr nc, StartMenu_Item.choseItem
StartMenu_Item.exitMenu
	call LoadScreenTilesFromBuffer2
	call LoadTextBoxTilePatterns
	call UpdateSprites
	jp RedisplayStartMenu
StartMenu_Item.choseItem
; erase menu cursor (blank each + TILE_SIZE * in front of an item name)
	ld a, $7f
	ldcoord_a 5, 4
	ldcoord_a 5, 6
	ldcoord_a 5, 8
	ldcoord_a 5, 10
	call PlaceUnfilledArrowMenuCursor
	xor a
	ld [wMenuItemToSwap], a
	ld a, [wCurItem]
	cp BICYCLE
	jp z, StartMenu_Item.useOrTossItem
; not Bicycle
	ld a, USE_TOSS_MENU_TEMPLATE
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, wTopMenuItemY
	ld a, 11
	ld [hli], a ; top menu item Y
	ld a, 14
	ld [hli], a ; top menu item X
	xor a
	ld [hli], a ; current menu item ID
	inc hl
	inc a ; a = 1
	ld [hli], a ; max menu item ID
	ld a, PAD_A | PAD_B
	ld [hli], a ; menu watched keys
	xor a
	ld [hl], a ; old menu item id
	call HandleMenuInput
	call PlaceUnfilledArrowMenuCursor
	bit B_PAD_B, a
	jr z, StartMenu_Item.useOrTossItem
	jp ItemMenuLoop
StartMenu_Item.useOrTossItem
	ld a, [wCurItem]
	ld [wNamedObjectIndex], a
	call GetItemName
	call CopyToStringBuffer
	ld a, [wCurItem]
	cp BICYCLE
	jr nz, StartMenu_Item.notBicycle
	ld a, [wStatusFlags6]
	bit BIT_ALWAYS_ON_BIKE, a
	jr z, StartMenu_Item.useItem_closeMenu
	ld hl, CannotGetOffHereText
	call PrintText
	jp ItemMenuLoop
StartMenu_Item.notBicycle
	ld a, [wCurrentMenuItem]
	and a
	jr nz, StartMenu_Item.tossItem
; use item
	ld [wPseudoItemID], a ; a must be 0 due to above conditional jump
	ld a, [wCurItem]
	cp HM01
	jr nc, StartMenu_Item.useItem_partyMenu
	ld hl, UsableItems_CloseMenu
	ld de, 1
	call IsInArray
	jr c, StartMenu_Item.useItem_closeMenu
	ld a, [wCurItem]
	ld hl, UsableItems_PartyMenu
	ld de, 1
	call IsInArray
	jr c, StartMenu_Item.useItem_partyMenu
	call UseItem
	jp ItemMenuLoop
StartMenu_Item.useItem_closeMenu
	xor a
	ld [wPseudoItemID], a
	call UseItem
	ld a, [wActionResultOrTookBattleTurn]
	and a
	jp z, ItemMenuLoop
	jp CloseStartMenu
StartMenu_Item.useItem_partyMenu
	ld a, [wUpdateSpritesEnabled]
	push af
	call UseItem
	ld a, [wActionResultOrTookBattleTurn]
	cp $02
	jp z, StartMenu_Item.partyMenuNotDisplayed
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	pop af
	ld [wUpdateSpritesEnabled], a
	jp StartMenu_Item
StartMenu_Item.partyMenuNotDisplayed
	pop af
	ld [wUpdateSpritesEnabled], a
	jp ItemMenuLoop
StartMenu_Item.tossItem
	call IsKeyItem
	ld a, [wIsKeyItem]
	and a
	jr nz, StartMenu_Item.skipAskingQuantity
	ld a, [wCurItem]
	call IsItemHM
	jr c, StartMenu_Item.skipAskingQuantity
	call DisplayChooseQuantityMenu
	inc a
	jr z, StartMenu_Item.tossZeroItems
StartMenu_Item.skipAskingQuantity
	ld hl, wNumBagItems
	call TossItem
StartMenu_Item.tossZeroItems
	jp ItemMenuLoop

CannotUseItemsHereText:
	text_far WLA_GLOBAL_CannotUseItemsHereText
	text_end

CannotGetOffHereText:
	text_far WLA_GLOBAL_CannotGetOffHereText
	text_end

.INCLUDE "data/items/use_party.asm"

.INCLUDE "data/items/use_overworld.asm"

StartMenu_TrainerInfo:
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ldh a, [lobyte(hTileAnimations)]
	push af
	xor a
	ldh [lobyte(hTileAnimations)], a
	call DrawTrainerInfo
	predef DrawBadges
	ld b, SET_PAL_TRAINER_CARD
	call RunPaletteCommand
	call GBPalNormal
	call WaitForTextScrollButtonPress
	call GBPalWhiteOut
	call LoadFontTilePatterns
	call LoadScreenTilesFromBuffer2
	call RunDefaultPaletteCommand
	call ReloadMapData
	call LoadGBPal
	pop af
	ldh [lobyte(hTileAnimations)], a
	jp RedisplayStartMenu

; loads + TILE_SIZE * patterns and draws everything except for gym leader faces / badges
DrawTrainerInfo:
	ld de, RedPicFront
	lb "bc", bank(RedPicFront), $01
	predef DisplayPicCenteredOrUpperRight
	call DisableLCD
	hlcoord 0, 2
	ld a, $7f
	call TrainerInfo_DrawVerticalLine
	hlcoord 1, 2
	call TrainerInfo_DrawVerticalLine
	ld hl, vChars2 + TILE_SIZE * $07
	ld de, vChars2 + TILE_SIZE * $00
	ld bc, TILE_SIZE * $1c
	call CopyData
	ld hl, TrainerInfoTextBoxTileGraphics
	ld de, vChars2 + TILE_SIZE * $77
	ld bc, 8 * TILE_SIZE
	push bc
	call TrainerInfo_FarCopyData
	ld hl, BlankLeaderNames
	ld de, vChars2 + TILE_SIZE * $60
	ld bc, $17 * TILE_SIZE
	call TrainerInfo_FarCopyData
	pop bc
	ld hl, BadgeNumbersTileGraphics
	ld de, vChars1 + TILE_SIZE * $58
	call TrainerInfo_FarCopyData
	ld hl, GymLeaderFaceAndBadgeTileGraphics
	ld de, vChars2 + TILE_SIZE * $20
	ld bc, 8 * 8 * TILE_SIZE
	ld a, bank(GymLeaderFaceAndBadgeTileGraphics)
	call FarCopyData2
	ld hl, TextBoxGraphics
	ld de, 13 * TILE_SIZE
	add hl, de ; hl = colon + TILE_SIZE * pattern
	ld de, vChars1 + TILE_SIZE * $56
	ld bc, TILE_SIZE
	ld a, bank(TextBoxGraphics)
	push bc
	call FarCopyData2
	pop bc
	ld hl, TrainerInfoTextBoxTileGraphics + TILE_SIZE * 8  ; background + TILE_SIZE * pattern
	ld de, vChars1 + TILE_SIZE * $57
	call TrainerInfo_FarCopyData
	call EnableLCD
	ld hl, wTrainerInfoTextBoxWidthPlus1
	ld a, 18 + 1
	ld [hli], a
	dec a
	ld [hli], a
	ld [hl], 1
	hlcoord 0, 0
	call TrainerInfo_DrawTextBox
	ld hl, wTrainerInfoTextBoxWidthPlus1
	ld a, 16 + 1
	ld [hli], a
	dec a
	ld [hli], a
	ld [hl], 3
	hlcoord 1, 10
	call TrainerInfo_DrawTextBox
	hlcoord 0, 10
	ld a, $d7
	call TrainerInfo_DrawVerticalLine
	hlcoord 19, 10
	call TrainerInfo_DrawVerticalLine
	hlcoord 6, 9
	ld de, TrainerInfo_BadgesText
	call PlaceString
	hlcoord 2, 2
	ld de, TrainerInfo_NameMoneyTimeText
	call PlaceString
	hlcoord 7, 2
	ld de, wPlayerName
	call PlaceString
	hlcoord 8, 4
	ld de, wPlayerMoney
	ld c, 3 | LEADING_ZEROES | LEFT_ALIGN | MONEY_SIGN
	call PrintBCDNumber
	hlcoord 9, 6
	ld de, wPlayTimeHours
	lb "bc", LEFT_ALIGN | 1, 3
	call PrintNumber
	ld [hl], $d6 ; colon + TILE_SIZE * ID
	inc hl
	ld de, wPlayTimeMinutes
	lb "bc", LEADING_ZEROES | 1, 2
	jp PrintNumber

TrainerInfo_FarCopyData:
	ld a, bank(TrainerInfoTextBoxTileGraphics)
	jp FarCopyData2

TrainerInfo_NameMoneyTimeText:
		.STRINGMAP pokemon, "NAME/"
	next "MONEY/"
	next "TIME/@"

; $76 is a circle tile.
TrainerInfo_BadgesText:
		.DB $76
		.STRINGMAP pokemon, "BADGES"
		.DB $76
		.STRINGMAP pokemon, "@"

; draws a text box on the trainer info screen
; height is always 6
; INPUT:
; hl = destination address
; [wTrainerInfoTextBoxWidthPlus1] = width
; [wTrainerInfoTextBoxWidth] = width - 1
; [wTrainerInfoTextBoxNextRowOffset] = distance from the end of a text box row to the start of the next
TrainerInfo_DrawTextBox:
	ld a, $79 ; upper left corner + TILE_SIZE * ID
	lb "de", $7a, $7b ; top edge and upper right corner + TILE_SIZE * ID's
	call TrainerInfo_DrawHorizontalEdge ; draw top edge
	call TrainerInfo_NextTextBoxRow
	ld a, [wTrainerInfoTextBoxWidthPlus1]
	ld e, a
	ld d, 0
	ld c, 6 ; height of the text box
TrainerInfo_DrawTextBox.loop
	ld [hl], $7c ; left edge + TILE_SIZE * ID
	add hl, de
	ld [hl], $78 ; right edge + TILE_SIZE * ID
	call TrainerInfo_NextTextBoxRow
	dec c
	jr nz, TrainerInfo_DrawTextBox.loop
	ld a, $7d ; lower left corner + TILE_SIZE * ID
	lb "de", $77, $7e ; bottom edge and lower right corner + TILE_SIZE * ID's

TrainerInfo_DrawHorizontalEdge:
	ld [hli], a ; place left corner tile
	ld a, [wTrainerInfoTextBoxWidth]
	ld c, a
	ld a, d
TrainerInfo_DrawHorizontalEdge.loop
	ld [hli], a ; place edge tile
	dec c
	jr nz, TrainerInfo_DrawHorizontalEdge.loop
	ld a, e
	ld [hl], a ; place right corner tile
	ret

TrainerInfo_NextTextBoxRow:
	ld a, [wTrainerInfoTextBoxNextRowOffset] ; distance to the start of the next row
TrainerInfo_NextTextBoxRow.loop
	inc hl
	dec a
	jr nz, TrainerInfo_NextTextBoxRow.loop
	ret

; draws a vertical line
; INPUT:
; hl = address of top + TILE_SIZE * in the line
; a = + TILE_SIZE * ID
TrainerInfo_DrawVerticalLine:
	ld de, SCREEN_WIDTH
	ld c, 8
TrainerInfo_DrawVerticalLine.loop
	ld [hl], a
	add hl, de
	dec c
	jr nz, TrainerInfo_DrawVerticalLine.loop
	ret

StartMenu_SaveReset:
	ld a, [wStatusFlags4]
	bit BIT_LINK_CONNECTED, a
	jp nz, Init
	predef SaveMenu
	call LoadScreenTilesFromBuffer2
	jp HoldTextDisplayOpen

StartMenu_Option:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call ClearScreen
	call UpdateSprites
	callfar DisplayOptionMenu
	call LoadScreenTilesFromBuffer2
	call LoadTextBoxTilePatterns
	call UpdateSprites
	jp RedisplayStartMenu

SwitchPartyMon:
	call SwitchPartyMon_InitVarOrSwapData ; swap data
	ld a, [wSwappedMenuItem]
	call SwitchPartyMon_ClearGfx
	ld a, [wCurrentMenuItem]
	call SwitchPartyMon_ClearGfx
	jp RedrawPartyMenu_

SwitchPartyMon_ClearGfx:
	push af
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * 2
	call AddNTimes
	ld c, SCREEN_WIDTH * 2
	ld a, $7f
SwitchPartyMon_ClearGfx.clearMonBGLoop ; clear the mon's row in the party menu
	ld [hli], a
	dec c
	jr nz, SwitchPartyMon_ClearGfx.clearMonBGLoop
	pop af
	ld hl, wShadowOAMSprite00YCoord
	ld bc, OBJ_SIZE * 4
	call AddNTimes
	ld de, OBJ_SIZE
	ld c, e
SwitchPartyMon_ClearGfx.clearMonOAMLoop
	ld [hl], SCREEN_HEIGHT_PX + OAM_Y_OFS
	add hl, de
	dec c
	jr nz, SwitchPartyMon_ClearGfx.clearMonOAMLoop
	call WaitForSoundToFinish
	ld a, SFX_SWAP
	jp PlaySound

SwitchPartyMon_InitVarOrSwapData:
; This is used to initialise [wMenuItemToSwap] and to actually swap the data.
	ld a, [wMenuItemToSwap]
	and a ; has [wMenuItemToSwap] been initialised yet?
	jr nz, SwitchPartyMon_InitVarOrSwapData.pickedMonsToSwap
; If not, initialise [wMenuItemToSwap] so that it matches the current mon.
	ld a, [wWhichPokemon]
	inc a ; [wMenuItemToSwap] counts from 1
	ld [wMenuItemToSwap], a
	ret
SwitchPartyMon_InitVarOrSwapData.pickedMonsToSwap
	xor a
	ld [wPartyMenuTypeOrMessageID], a
	ld a, [wMenuItemToSwap]
	dec a
	ld b, a
	ld a, [wCurrentMenuItem]
	ld [wSwappedMenuItem], a
	cp b ; swapping a mon with itself?
	jr nz, SwitchPartyMon_InitVarOrSwapData.swappingDifferentMons
; can't swap a mon with itself
	xor a
	ld [wMenuItemToSwap], a
	ld [wPartyMenuTypeOrMessageID], a
	ret
SwitchPartyMon_InitVarOrSwapData.swappingDifferentMons
	ld a, b
	ld [wMenuItemToSwap], a
	push hl
	push de
	ld hl, wPartySpecies
	ld d, h
	ld e, l
	ld a, [wCurrentMenuItem]
	add l
	ld l, a
	jr nc, SwitchPartyMon_InitVarOrSwapData.noCarry
	inc h
SwitchPartyMon_InitVarOrSwapData.noCarry
	ld a, [wMenuItemToSwap]
	add e
	ld e, a
	jr nc, SwitchPartyMon_InitVarOrSwapData.noCarry2
	inc d
SwitchPartyMon_InitVarOrSwapData.noCarry2
	ld a, [hl]
	ldh [lobyte(hSwapTemp)], a
	ld a, [de]
	ld [hl], a
	ldh a, [lobyte(hSwapTemp)]
	ld [de], a
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurrentMenuItem]
	call AddNTimes
	push hl
	ld de, wSwitchPartyMonTempBuffer
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyData
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wMenuItemToSwap]
	call AddNTimes
	pop de
	push hl
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyData
	pop de
	ld hl, wSwitchPartyMonTempBuffer
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyData
	ld hl, wPartyMonOT
	ld a, [wCurrentMenuItem]
	call SkipFixedLengthTextEntries
	push hl
	ld de, wSwitchPartyMonTempBuffer
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wPartyMonOT
	ld a, [wMenuItemToSwap]
	call SkipFixedLengthTextEntries
	pop de
	push hl
	ld bc, NAME_LENGTH
	call CopyData
	pop de
	ld hl, wSwitchPartyMonTempBuffer
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wPartyMonNicks
	ld a, [wCurrentMenuItem]
	call SkipFixedLengthTextEntries
	push hl
	ld de, wSwitchPartyMonTempBuffer
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wPartyMonNicks
	ld a, [wMenuItemToSwap]
	call SkipFixedLengthTextEntries
	pop de
	push hl
	ld bc, NAME_LENGTH
	call CopyData
	pop de
	ld hl, wSwitchPartyMonTempBuffer
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMenuItemToSwap]
	ld [wSwappedMenuItem], a
	xor a
	ld [wMenuItemToSwap], a
	ld [wPartyMenuTypeOrMessageID], a
	pop de
	pop hl
	ret
