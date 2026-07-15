; Native WLA-DX form of engine/events/card_key.asm, engine/events/prize_menu.asm, engine/events/hidden_events/school_notebooks.asm, engine/events/hidden_events/fighting_dojo.asm, engine/events/hidden_events/indigo_plateau_hq.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"
PrintCardKeyText:
	ld hl, SilphCoMapList
	ld a, (wCurMap)
	ld b, a
PrintCardKeyText.silphCoMapListLoop:
	ld a, (HL+)
	cp -1
	ret z
	cp b
	jr nz, PrintCardKeyText.silphCoMapListLoop
	ld a, $35
	call Predef
	ld a, (wTileInFrontOfPlayer)
	cp $18
	jr z, PrintCardKeyText.cardKeyDoorInFrontOfPlayer
	cp $24
	jr z, PrintCardKeyText.cardKeyDoorInFrontOfPlayer
	ld b, a
	ld a, (wCurMap)
	cp SILPH_CO_11F
	ret nz
	ld a, b
	cp $5e
	ret nz
PrintCardKeyText.cardKeyDoorInFrontOfPlayer:
	ld b, CARD_KEY
	call IsItemInBag
	jr z, PrintCardKeyText.noCardKey
	call GetCoordsInFrontOfPlayer
	push de
	ld a, $01
	ldh (hTextID - $FF00), a
	call PrintPredefTextID
	pop de
	srl d
	ld a, d
	ld b, a
	ld (wCardKeyDoorY), a
	srl e
	ld a, e
	ld c, a
	ld (wCardKeyDoorX), a
	ld a, (wCurMap)
	cp SILPH_CO_11F
	jr nz, PrintCardKeyText.notSilphCo11F
	ld a, $3
	jr PrintCardKeyText.replaceCardKeyDoorTileBlock
PrintCardKeyText.notSilphCo11F:
	ld a, $e
PrintCardKeyText.replaceCardKeyDoorTileBlock:
	ld (wNewTileBlockID), a
	ld a, $17
	call Predef
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, (hl)
	ld a, SFX_GO_INSIDE
	jp PlaySound
PrintCardKeyText.noCardKey:
	ld a, $02
	ldh (hTextID - $FF00), a
	jp PrintPredefTextID

SilphCoMapList:
	.DB SILPH_CO_2F
	.DB SILPH_CO_3F
	.DB SILPH_CO_4F
	.DB SILPH_CO_5F
	.DB SILPH_CO_6F
	.DB SILPH_CO_7F
	.DB SILPH_CO_8F
	.DB SILPH_CO_9F
	.DB SILPH_CO_10F
	.DB SILPH_CO_11F
	.DB -1 ; end

CardKeySuccessText:
	.DB $17
	.DW $4000
	.DB $20
	.DB $0b
	.DB $17
	.DW $4009
	.DB $20
	.DB $50

CardKeyFailText:
	.DB $17
	.DW $4029
	.DB $20
	.DB $50

; d = Y
; e = X
GetCoordsInFrontOfPlayer:
	ld a, (wYCoord)
	ld d, a
	ld a, (wXCoord)
	ld e, a
	ld a, (wSpritePlayerStateData1FacingDirection)
	and a
	jr nz, GetCoordsInFrontOfPlayer.notFacingDown
; facing down
	inc d
	ret
GetCoordsInFrontOfPlayer.notFacingDown:
	cp SPRITE_FACING_UP
	jr nz, GetCoordsInFrontOfPlayer.notFacingUp
; facing up
	dec d
	ret
GetCoordsInFrontOfPlayer.notFacingUp:
	cp SPRITE_FACING_LEFT
	jr nz, GetCoordsInFrontOfPlayer.notFacingLeft
; facing left
	dec e
	ret
GetCoordsInFrontOfPlayer.notFacingLeft:
; facing right
	inc e
	ret
CeladonPrizeMenu:
	ld b, COIN_CASE
	call IsItemInBag
	jr nz, CeladonPrizeMenu.havingCoinCase
	ld hl, RequireCoinCaseText
	jp PrintText
CeladonPrizeMenu.havingCoinCase:
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, (hl)
	ld hl, ExchangeCoinsForPrizesText
	call PrintText
; the following are the menu settings
	xor a
	ld (wCurrentMenuItem), a
	ld (wLastMenuItem), a
	ld a, PAD_A | PAD_B
	ld (wMenuWatchedKeys), a
	ld a, $03
	ld (wMaxMenuItem), a
	ld a, $04
	ld (wTopMenuItemY), a
	ld a, $01
	ld (wTopMenuItemX), a
	call PrintPrizePrice
	ld hl, wTileMap + (2 * 20) + 0
	ld b, 8
	ld c, 16
	call TextBoxBorder
	call GetPrizeMenuId
	call UpdateSprites
	ld hl, WhichPrizeText
	call PrintText
	call HandleMenuInput ; menu choice handler
	bit B_PAD_B, a
	jr nz, CeladonPrizeMenu.noChoice
	ld a, (wCurrentMenuItem)
	cp 3 ; "NO,THANKS" choice
	jr z, CeladonPrizeMenu.noChoice
	call HandlePrizeChoice
CeladonPrizeMenu.noChoice:
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, (hl)
	ret

RequireCoinCaseText:
	.DB $17
	.DW $628e
	.DB $22
	.DB $0d
	.DB $50

ExchangeCoinsForPrizesText:
	.DB $17
	.DW $62a9
	.DB $22
	.DB $50

WhichPrizeText:
	.DB $17
	.DW $62cd
	.DB $22
	.DB $50

GetPrizeMenuId:
; determine which one among the three prize texts has been selected using the text ID (stored in [hTextID])
; prize texts' IDs are TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_1-TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_3
; load the three prizes at wPrize1-wPrice3
; load the three prices at wPrize1Price-wPrize3Price
; display the three prizes' names, distinguishing between Pokemon names and item names (specifically TMs)
	ldh a, (hTextID - $FF00)
	sub TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_1
	ld (wWhichPrizeWindow), a ; prize texts' relative ID (i.e. 0-2)
	add a
	add a
	ld d, 0
	ld e, a
	ld hl, PrizeDifferentMenuPtrs
	add hl, de
	ld a, (HL+)
	ld d, (hl)
	ld e, a
	inc hl
	push hl
	ld hl, wPrize1
	call CopyString
	pop hl
	ld a, (HL+)
	ld h, (hl)
	ld l, a
	ld de, wPrize1Price
	ld bc, 6
	call CopyData
	ld a, (wWhichPrizeWindow)
	cp 2 ; is TM_menu?
	jr nz, GetPrizeMenuId.putMonName
	ld a, (wPrize1)
	ld (wNamedObjectIndex), a
	call GetItemName
	ld hl, wTileMap + (4 * 20) + 2
	call PlaceString
	ld a, (wPrize2)
	ld (wNamedObjectIndex), a
	call GetItemName
	ld hl, wTileMap + (6 * 20) + 2
	call PlaceString
	ld a, (wPrize3)
	ld (wNamedObjectIndex), a
	call GetItemName
	ld hl, wTileMap + (8 * 20) + 2
	call PlaceString
	jr GetPrizeMenuId.putNoThanksText
GetPrizeMenuId.putMonName:
	ld a, (wPrize1)
	ld (wNamedObjectIndex), a
	call GetMonName
	ld hl, wTileMap + (4 * 20) + 2
	call PlaceString
	ld a, (wPrize2)
	ld (wNamedObjectIndex), a
	call GetMonName
	ld hl, wTileMap + (6 * 20) + 2
	call PlaceString
	ld a, (wPrize3)
	ld (wNamedObjectIndex), a
	call GetMonName
	ld hl, wTileMap + (8 * 20) + 2
	call PlaceString
GetPrizeMenuId.putNoThanksText:
	ld hl, wTileMap + (10 * 20) + 2
	ld de, NoThanksText
	call PlaceString
; put prices on the right side of the textbox
	ld de, wPrize1Price
	ld hl, wTileMap + (5 * 20) + 13
	ld c, 2 | LEADING_ZEROES
	call PrintBCDNumber
	ld de, wPrize2Price
	ld hl, wTileMap + (7 * 20) + 13
	ld c, 2 | LEADING_ZEROES
	call PrintBCDNumber
	ld de, wPrize3Price
	ld hl, wTileMap + (9 * 20) + 13
	ld c, 2 | LEADING_ZEROES
	jp PrintBCDNumber

PrizeDifferentMenuPtrs:
	.DW PrizeMenuMon1Entries, PrizeMenuMon1Cost
	.DW PrizeMenuMon2Entries, PrizeMenuMon2Cost
	.DW PrizeMenuTMsEntries,  PrizeMenuTMsCost

NoThanksText:
	.STRINGMAP pokemon, "NO THANKS@"

PrizeMenuMon1Entries:
	.DB ABRA
	.DB CLEFAIRY
	.DB NIDORINA
	.STRINGMAP pokemon, "@"

PrizeMenuMon1Cost:
	.DB $01, $80
	.DB $05, $00
	.DB $12, $00
	.STRINGMAP pokemon, "@"

PrizeMenuMon2Entries:
	.DB DRATINI
	.DB SCYTHER
	.DB PORYGON
	.STRINGMAP pokemon, "@"

PrizeMenuMon2Cost:
	.DB $28, $00
	.DB $55, $00
	.DB $99, $99
	.STRINGMAP pokemon, "@"

PrizeMenuTMsEntries:
	.DB TM_DRAGON_RAGE
	.DB TM_HYPER_BEAM
	.DB TM_SUBSTITUTE
	.STRINGMAP pokemon, "@"

PrizeMenuTMsCost:
	.DB $33, $00
	.DB $55, $00
	.DB $77, $00
	.STRINGMAP pokemon, "@"

PrintPrizePrice:
	ld hl, wTileMap + (0 * 20) + 11
	ld b, 1
	ld c, 7
	call TextBoxBorder
	call UpdateSprites
	ld hl, wTileMap + (0 * 20) + 12
	ld de, PrintPrizePrice.CoinString
	call PlaceString
	ld hl, wTileMap + (1 * 20) + 13
	ld de, PrintPrizePrice.SixSpacesString
	call PlaceString
	ld hl, wTileMap + (1 * 20) + 13
	ld de, wPlayerCoins
	ld c, 2 | LEADING_ZEROES
	call PrintBCDNumber
	ret

PrintPrizePrice.CoinString:
	.STRINGMAP pokemon, "COIN@"

PrintPrizePrice.SixSpacesString:
	.STRINGMAP pokemon, "      @"

LoadCoinsToSubtract:
	ld a, (wWhichPrize)
	add a
	ld d, 0
	ld e, a
	ld hl, wPrize1Price
	add hl, de ; get selected prize's price
	xor a
	ldh (hUnusedCoinsByte - $FF00), a
	ld a, (HL+)
	ldh (hCoins - $FF00), a
	ld a, (hl)
	ldh (hCoins - $FF00 + 1), a
	ret

HandlePrizeChoice:
	ld a, (wCurrentMenuItem)
	ld (wWhichPrize), a
	ld d, 0
	ld e, a
	ld hl, wPrize1
	add hl, de
	ld a, (hl)
	ld (wNamedObjectIndex), a
	ld a, (wWhichPrizeWindow)
	cp 2 ; is prize a TM?
	jr nz, HandlePrizeChoice.getMonName
	call GetItemName
	jr HandlePrizeChoice.givePrize
HandlePrizeChoice.getMonName:
	call GetMonName
HandlePrizeChoice.givePrize:
	ld hl, SoYouWantPrizeText
	call PrintText
	call YesNoChoice
	ld a, (wCurrentMenuItem) ; yes/no answer (Y=0, N=1)
	and a
	jr nz, HandlePrizeChoice.printOhFineThen
	call LoadCoinsToSubtract
	call HasEnoughCoins
	jr c, HandlePrizeChoice.notEnoughCoins
	ld a, (wWhichPrizeWindow)
	cp 2 ; is prize a TM?
	jr nz, HandlePrizeChoice.giveMon
	ld a, (wNamedObjectIndex)
	ld b, a
	ld a, 1
	ld c, a
	call GiveItem
	jr nc, HandlePrizeChoice.bagFull
	jr HandlePrizeChoice.subtractCoins
HandlePrizeChoice.giveMon:
	ld a, (wNamedObjectIndex)
	ld (wCurPartySpecies), a
	push af
	call GetPrizeMonLevel
	ld c, a
	pop af
	ld b, a
	call GivePokemon

; If either the party or box was full, wait after displaying message.
	push af
	ld a, (wAddedToParty)
	and a
	call z, WaitForTextScrollButtonPress
	pop af

; If the mon couldn't be given to the player (because both the party and box
; were full), return without subtracting coins.
	ret nc

HandlePrizeChoice.subtractCoins:
	call LoadCoinsToSubtract
	ld hl, hCoins + 1
	ld de, wPlayerCoins + 1
	ld c, $02 ; how many bytes
	ld a, $0c
	call Predef
	jp PrintPrizePrice
HandlePrizeChoice.bagFull:
	ld hl, PrizeRoomBagIsFullText
	jp PrintText
HandlePrizeChoice.notEnoughCoins:
	ld hl, SorryNeedMoreCoinsText
	jp PrintText
HandlePrizeChoice.printOhFineThen:
	ld hl, OhFineThenText
	jp PrintText

UnknownPrizeData:
; XXX what's this?
	.DB $00,$01,$00,$01,$00,$01,$00,$00,$01

HereYouGoText: ; unreferenced
	.DB $17
	.DW $62e7
	.DB $22
	.DB $0d
	.DB $50

SoYouWantPrizeText:
	.DB $17
	.DW $62f6
	.DB $22
	.DB $50

SorryNeedMoreCoinsText:
	.DB $17
	.DW $630b
	.DB $22
	.DB $0d
	.DB $50

PrizeRoomBagIsFullText:
	.DB $17
	.DW $6329
	.DB $22
	.DB $0d
	.DB $50

OhFineThenText:
	.DB $17
	.DW $634c
	.DB $22
	.DB $0d
	.DB $50

GetPrizeMonLevel:
	ld a, (wCurPartySpecies)
	ld b, a
	ld hl, PrizeMonLevelDictionary
GetPrizeMonLevel.loop:
	ld a, (HL+)
	cp b
	jr z, GetPrizeMonLevel.matchFound
	inc hl
	jr GetPrizeMonLevel.loop
GetPrizeMonLevel.matchFound:
	ld a, (hl)
	ld (wCurEnemyLevel), a
	ret

PrizeMonLevelDictionary:
	.DB ABRA,      9
	.DB CLEFAIRY,  8
	.DB NIDORINA, 17

	.DB DRATINI,  18
	.DB SCYTHER,  25
	.DB PORYGON,  26

PrintNotebookText:
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld (wDoNotWaitForButtonPressAfterDisplayingText), a
	ld a, (wHiddenEventFunctionArgument)
	jp PrintPredefTextID

TMNotebook:
	.DB $17
	.DW $4bfd
	.DB $22
	.DB $0d
	.DB $50

ViridianSchoolNotebook:
	.DB $08
	ld hl, ViridianSchoolNotebookText1
	call PrintText
	call TurnPageSchoolNotebook
	jr nz, ViridianSchoolNotebook.doneReading
	ld hl, ViridianSchoolNotebookText2
	call PrintText
	call TurnPageSchoolNotebook
	jr nz, ViridianSchoolNotebook.doneReading
	ld hl, ViridianSchoolNotebookText3
	call PrintText
	call TurnPageSchoolNotebook
	jr nz, ViridianSchoolNotebook.doneReading
	ld hl, ViridianSchoolNotebookText4
	call PrintText
	ld hl, ViridianSchoolNotebookText5
	call PrintText
ViridianSchoolNotebook.doneReading:
	jp TextScriptEnd

TurnPageSchoolNotebook:
	ld hl, TurnPageText
	call PrintText
	call YesNoChoice
	ld a, (wCurrentMenuItem)
	and a
	ret

TurnPageText:
	.DB $17
	.DW $4c6f
	.DB $22
	.DB $50

ViridianSchoolNotebookText5:
	.DB $17
	.DW $4c7f
	.DB $22
	.DB $0d
	.DB $50

ViridianSchoolNotebookText1:
	.DB $17
	.DW $4ca3
	.DB $22
	.DB $50

ViridianSchoolNotebookText2:
	.DB $17
	.DW $4d46
	.DB $22
	.DB $50

ViridianSchoolNotebookText3:
	.DB $17
	.DW $4dbd
	.DB $22
	.DB $50

ViridianSchoolNotebookText4:
	.DB $17
	.DW $4e2c
	.DB $22
	.DB $50
PrintFightingDojoText2:
	call EnableAutoTextBoxDrawing
	ld a, $37
	jp PrintPredefTextID

EnemiesOnEverySideText:
	.DB $17
	.DW $4ec1
	.DB $22
	.DB $50

PrintFightingDojoText3:
	call EnableAutoTextBoxDrawing
	ld a, $38
	jp PrintPredefTextID

WhatGoesAroundComesAroundText:
	.DB $17
	.DW $4ed9
	.DB $22
	.DB $50

PrintFightingDojoText:
	call EnableAutoTextBoxDrawing
	ld a, $36
	jp PrintPredefTextID

FightingDojoText:
	.DB $17
	.DW $4ef9
	.DB $22
	.DB $50
PrintIndigoPlateauHQText:
	ld a, (wSpritePlayerStateData1FacingDirection)
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	ld a, $27
	jp PrintPredefTextID

IndigoPlateauHQText:
	.DB $17
	.DW $4f08
	.DB $22
	.DB $50
HiddenEvents2End:
