DrawPartyMenu_:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call ClearScreen
	call UpdateSprites
	farcall LoadMonPartySpriteGfxWithLCDDisabled ; load pokemon icon graphics

RedrawPartyMenu_:
	ld a, [wPartyMenuTypeOrMessageID]
	cp SWAP_MONS_PARTY_MENU
	jp z, RedrawPartyMenu_.printMessage
	call ErasePartyMenuCursors
	farcall InitPartyMenuBlkPacket
	hlcoord 3, 0
	ld de, wPartySpecies
	xor a
	ld c, a
	ldh [lobyte(hPartyMonIndex)], a
	ld [wWhichPartyMenuHPBar], a
RedrawPartyMenu_.loop
	ld a, [de]
	cp $FF ; reached the terminator?
	jp z, RedrawPartyMenu_.afterDrawingMonEntries
	push bc
	push de
	push hl
	ld a, c
	push hl
	ld hl, wPartyMonNicks
	call GetPartyMonName
	pop hl
	call PlaceString ; print the pokemon's name
	farcall WriteMonPartySpriteOAMByPartyIndex ; place the appropriate pokemon icon
	ldh a, [lobyte(hPartyMonIndex)]
	ld [wWhichPokemon], a
	inc a
	ldh [lobyte(hPartyMonIndex)], a
	call LoadMonData
	pop hl
	push hl
	ld a, [wMenuItemToSwap]
	and a ; is the player swapping pokemon positions?
	jr z, RedrawPartyMenu_.skipUnfilledRightArrow
; if the player is swapping pokemon positions
	dec a
	ld b, a
	ld a, [wWhichPokemon]
	cp b ; is the player swapping the current pokemon in the list?
	jr nz, RedrawPartyMenu_.skipUnfilledRightArrow
; the player is swapping the current pokemon in the list
	dec hl
	dec hl
	dec hl
	ld a, $ec ; unfilled right arrow menu cursor
	ld [hli], a ; place the cursor
	inc hl
	inc hl
RedrawPartyMenu_.skipUnfilledRightArrow
	ld a, [wPartyMenuTypeOrMessageID] ; menu type
	cp TMHM_PARTY_MENU
	jr z, RedrawPartyMenu_.teachMoveMenu
	cp EVO_STONE_PARTY_MENU
	jr z, RedrawPartyMenu_.evolutionStoneMenu
	push hl
	ld bc, 14 ; 14 columns to the right
	add hl, bc
	ld de, wLoadedMonStatus
	call PrintStatusCondition
	pop hl
	push hl
	ld bc, SCREEN_WIDTH + 1 ; down 1 row and right 1 column
	ldh a, [lobyte(hUILayoutFlags)]
	set BIT_PARTY_MENU_HP_BAR, a
	ldh [lobyte(hUILayoutFlags)], a
	add hl, bc
	predef DrawHP2 ; draw HP bar and prints current / max HP
	ldh a, [lobyte(hUILayoutFlags)]
	res BIT_PARTY_MENU_HP_BAR, a
	ldh [lobyte(hUILayoutFlags)], a
	call SetPartyMenuHPBarColor ; color the HP bar (on SGB)
	pop hl
	jr RedrawPartyMenu_.printLevel
RedrawPartyMenu_.teachMoveMenu
	push hl
	predef CanLearnTM ; check if the pokemon can learn the move
	pop hl
	ld de, RedrawPartyMenu_.ableToLearnMoveText
	ld a, c
	and a
	jr nz, RedrawPartyMenu_.placeMoveLearnabilityString
	ld de, RedrawPartyMenu_.notAbleToLearnMoveText
RedrawPartyMenu_.placeMoveLearnabilityString
	ld bc, SCREEN_WIDTH + 9 ; 1 row down and 9 columns right
	push hl
	add hl, bc
	call PlaceString
	pop hl
RedrawPartyMenu_.printLevel
	ld bc, 10 ; move 10 columns to the right
	add hl, bc
	call PrintLevel
	pop hl
	pop de
	inc de
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop bc
	inc c
	jp RedrawPartyMenu_.loop
RedrawPartyMenu_.ableToLearnMoveText
		.STRINGMAP pokemon, "ABLE@"
RedrawPartyMenu_.notAbleToLearnMoveText
		.STRINGMAP pokemon, "NOT ABLE@"
RedrawPartyMenu_.evolutionStoneMenu
	push hl
	ld hl, EvosMovesPointerTable
	ld b, 0
	ld a, [wLoadedMonSpecies]
	dec a
	add a
	rl b
	ld c, a
	add hl, bc
	ld de, wEvoDataBuffer
	ld a, bank(EvosMovesPointerTable)
	ld bc, 2
	call FarCopyData
	ld hl, wEvoDataBuffer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wEvoDataBuffer
	ld a, bank(EvosMovesPointerTable)
	ld bc, wEvoDataBufferEnd - wEvoDataBuffer
	call FarCopyData
	ld hl, wEvoDataBuffer
	ld de, RedrawPartyMenu_.notAbleToEvolveText
; loop through the pokemon's evolution entries
RedrawPartyMenu_.checkEvolutionsLoop
	ld a, [hli]
	and a ; reached terminator?
	jr z, RedrawPartyMenu_.placeEvolutionStoneString ; if so, place the "NOT ABLE" string
	inc hl
	inc hl
	cp EVOLVE_ITEM
	jr nz, RedrawPartyMenu_.checkEvolutionsLoop
; if it's a stone evolution entry
	dec hl
	dec hl
	ld b, [hl]
	ld a, [wEvoStoneItemID] ; the stone the player used
	inc hl
	inc hl
	inc hl
	cp b ; does the player's stone match this evolution entry's stone?
	jr nz, RedrawPartyMenu_.checkEvolutionsLoop
; if it does match
	ld de, RedrawPartyMenu_.ableToEvolveText
RedrawPartyMenu_.placeEvolutionStoneString
	ld bc, 20 + 9 ; down 1 row and right 9 columns
	pop hl
	push hl
	add hl, bc
	call PlaceString
	pop hl
	jr RedrawPartyMenu_.printLevel
RedrawPartyMenu_.ableToEvolveText
		.STRINGMAP pokemon, "ABLE@"
RedrawPartyMenu_.notAbleToEvolveText
		.STRINGMAP pokemon, "NOT ABLE@"
RedrawPartyMenu_.afterDrawingMonEntries
	ld b, SET_PAL_PARTY_MENU
	call RunPaletteCommand
RedrawPartyMenu_.printMessage
	ld hl, wStatusFlags5
	ld a, [hl]
	push af
	push hl
	set BIT_NO_TEXT_DELAY, [hl]
	ld a, [wPartyMenuTypeOrMessageID] ; message ID
	cp FIRST_PARTY_MENU_TEXT_ID
	jr nc, RedrawPartyMenu_.printItemUseMessage
	add a
	ld hl, PartyMenuMessagePointers
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
RedrawPartyMenu_.done
	pop hl
	pop af
	ld [hl], a
	ld a, 1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call Delay3
	jp GBPalNormal
RedrawPartyMenu_.printItemUseMessage
	and $0F
	ld hl, PartyMenuItemUseMessagePointers
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, [wUsedItemOnWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	pop hl
	call PrintText
	jr RedrawPartyMenu_.done

PartyMenuItemUseMessagePointers:
	.DW AntidoteText
	.DW BurnHealText
	.DW IceHealText
	.DW AwakeningText
	.DW ParlyzHealText
	.DW PotionText
	.DW FullHealText
	.DW ReviveText
	.DW RareCandyText

PartyMenuMessagePointers:
	.DW PartyMenuNormalText
	.DW PartyMenuItemUseText
	.DW PartyMenuBattleText
	.DW PartyMenuUseTMText
	.DW PartyMenuSwapMonText
	.DW PartyMenuItemUseText

PartyMenuNormalText:
	text_far WLA_GLOBAL_PartyMenuNormalText
	text_end

PartyMenuItemUseText:
	text_far WLA_GLOBAL_PartyMenuItemUseText
	text_end

PartyMenuBattleText:
	text_far WLA_GLOBAL_PartyMenuBattleText
	text_end

PartyMenuUseTMText:
	text_far WLA_GLOBAL_PartyMenuUseTMText
	text_end

PartyMenuSwapMonText:
	text_far WLA_GLOBAL_PartyMenuSwapMonText
	text_end

PotionText:
	text_far WLA_GLOBAL_PotionText
	text_end

AntidoteText:
	text_far WLA_GLOBAL_AntidoteText
	text_end

ParlyzHealText:
	text_far WLA_GLOBAL_ParlyzHealText
	text_end

BurnHealText:
	text_far WLA_GLOBAL_BurnHealText
	text_end

IceHealText:
	text_far WLA_GLOBAL_IceHealText
	text_end

AwakeningText:
	text_far WLA_GLOBAL_AwakeningText
	text_end

FullHealText:
	text_far WLA_GLOBAL_FullHealText
	text_end

ReviveText:
	text_far WLA_GLOBAL_ReviveText
	text_end

RareCandyText:
	text_far WLA_GLOBAL_RareCandyText
	sound_get_item_1 ; probably supposed to play SFX_LEVEL_UP but the wrong music bank is loaded
	text_promptbutton
	text_end

SetPartyMenuHPBarColor:
	ld hl, wPartyMenuHPBarColors
	ld a, [wWhichPartyMenuHPBar]
	ld c, a
	ld b, 0
	add hl, bc
	call GetHealthBarColor
	ld b, SET_PAL_PARTY_MENU_HP_BARS
	call RunPaletteCommand
	ld hl, wWhichPartyMenuHPBar
	inc [hl]
	ret
