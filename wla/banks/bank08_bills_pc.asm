; Native WLA-DX form of engine/pokemon/bills_pc.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"
DisplayPCMainMenu:
	xor a
	ldh (hAutoBGTransferEnabled - $FF00), a
	call SaveScreenTilesToBuffer2
	ld a, (wNumHoFTeams)
	and a
	jr nz, DisplayPCMainMenu.leaguePCAvailable
	ld a, (wEventFlags + (EVENT_GOT_POKEDEX / 8))
	bit EVENT_GOT_POKEDEX & 7, a
	jr z, DisplayPCMainMenu.noOaksPC
	ld a, (wNumHoFTeams)
	and a
	jr nz, DisplayPCMainMenu.leaguePCAvailable
	ld hl, wTileMap + (0 * 20) + 0
	ld b, 8
	ld c, 14
	jr DisplayPCMainMenu.next
DisplayPCMainMenu.noOaksPC:
	ld hl, wTileMap + (0 * 20) + 0
	ld b, 6
	ld c, 14
	jr DisplayPCMainMenu.next
DisplayPCMainMenu.leaguePCAvailable:
	ld hl, wTileMap + (0 * 20) + 0
	ld b, 10
	ld c, 14
DisplayPCMainMenu.next:
	call TextBoxBorder
	call UpdateSprites
	ld a, 3
	ld (wMaxMenuItem), a
	ld a, (wEventFlags + (EVENT_MET_BILL / 8))
	bit EVENT_MET_BILL & 7, a
	jr nz, DisplayPCMainMenu.metBill
	ld hl, wTileMap + (2 * 20) + 2
	ld de, SomeonesPCText
	jr DisplayPCMainMenu.next2
DisplayPCMainMenu.metBill:
	ld hl, wTileMap + (2 * 20) + 2
	ld de, BillsPCText
DisplayPCMainMenu.next2:
	call PlaceString
	ld hl, wTileMap + (4 * 20) + 2
	ld de, wPlayerName
	call PlaceString
	ld l, c
	ld h, b
	ld de, PlayersPCText
	call PlaceString
	ld a, (wEventFlags + (EVENT_GOT_POKEDEX / 8))
	bit EVENT_GOT_POKEDEX & 7, a
	jr z, DisplayPCMainMenu.noOaksPC2
	ld hl, wTileMap + (6 * 20) + 2
	ld de, OaksPCText
	call PlaceString
	ld a, (wNumHoFTeams)
	and a
	jr z, DisplayPCMainMenu.noLeaguePC
	ld a, 4
	ld (wMaxMenuItem), a
	ld hl, wTileMap + (8 * 20) + 2
	ld de, PKMNLeaguePCText
	call PlaceString
	ld hl, wTileMap + (10 * 20) + 2
	ld de, LogOffPCText
	jr DisplayPCMainMenu.next3
DisplayPCMainMenu.noLeaguePC:
	ld hl, wTileMap + (8 * 20) + 2
	ld de, LogOffPCText
	jr DisplayPCMainMenu.next3
DisplayPCMainMenu.noOaksPC2:
	ld a, $2
	ld (wMaxMenuItem), a
	ld hl, wTileMap + (6 * 20) + 2
	ld de, LogOffPCText
DisplayPCMainMenu.next3:
	call PlaceString
	ld a, PAD_A | PAD_B
	ld (wMenuWatchedKeys), a
	ld a, 2
	ld (wTopMenuItemY), a
	ld a, 1
	ld (wTopMenuItemX), a
	xor a
	ld (wCurrentMenuItem), a
	ld (wLastMenuItem), a
	ld a, 1
	ldh (hAutoBGTransferEnabled - $FF00), a
	ret

SomeonesPCText:
	.STRINGMAP pokemon, "SOMEONE's PC@"
BillsPCText:
	.STRINGMAP pokemon, "BILL's PC@"
PlayersPCText:
	.STRINGMAP pokemon, "'s PC@"
OaksPCText:
	.STRINGMAP pokemon, "PROF.OAK's PC@"
PKMNLeaguePCText:
	.STRINGMAP pokemon, "<PKMN>LEAGUE@"
LogOffPCText:
	.STRINGMAP pokemon, "LOG OFF@"

BillsPC_:
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, (hl)
	xor a
	ld (wParentMenuItem), a
	inc a ; MONSTER_NAME
	ld (wNameListType), a
	call LoadHpBarAndStatusTilePatterns
	ld a, (wListScrollOffset)
	push af
	ld a, (wMiscFlags)
	bit BIT_USING_GENERIC_PC, a
	jr nz, BillsPCMenu
; accessing it directly
	ld a, SFX_TURN_ON_PC
	call PlaySound
	ld hl, SwitchOnText
	call PrintText

BillsPCMenu:
	ld a, (wParentMenuItem)
	ld (wCurrentMenuItem), a
	ld hl, vChars2 + ($78) * 16
	ld de, PokeballTileGraphics
	ld bc, (($0e) << 8) | (1)
	call CopyVideoData
	call LoadScreenTilesFromBuffer2DisableBGTransfer
	ld hl, wTileMap + (0 * 20) + 0
	ld b, 10
	ld c, 12
	call TextBoxBorder
	ld hl, wTileMap + (2 * 20) + 2
	ld de, BillsPCMenuText
	call PlaceString
	ld hl, wTopMenuItemY
	ld a, 2
	ld (HL+), a ; wTopMenuItemY
	dec a
	ld (HL+), a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, 4
	ld (HL+), a ; wMaxMenuItem
	ld a, PAD_A | PAD_B
	ld (HL+), a ; wMenuWatchedKeys
	xor a
	ld (HL+), a ; wLastMenuItem
	ld (HL+), a ; wPartyAndBillsPCSavedMenuItem
	ld hl, wListScrollOffset
	ld (HL+), a ; wListScrollOffset
	ld (hl), a ; wMenuWatchMovingOutOfBounds
	ld (wPlayerMonNumber), a
	ld hl, WhatText
	call PrintText
	ld hl, wTileMap + (14 * 20) + 9
	ld b, 2
	ld c, 9
	call TextBoxBorder
	ld a, (wCurrentBoxNum)
	and BOX_NUM_MASK
	cp 9
	jr c, BillsPCMenu.singleDigitBoxNum
; two digit box num
	sub 9
	ld hl, wTileMap + (16 * 20) + 17
	ld (hl), $f7
	add $f6
	jr BillsPCMenu.next
BillsPCMenu.singleDigitBoxNum:
	add $f7
BillsPCMenu.next:
	ld (wTileMap + (16 * 20) + 18), a
	ld hl, wTileMap + (16 * 20) + 10
	ld de, BoxNoPCText
	call PlaceString
	ld a, 1
	ldh (hAutoBGTransferEnabled - $FF00), a
	call Delay3
	call HandleMenuInput
	bit B_PAD_B, a
	jp nz, ExitBillsPC
	call PlaceUnfilledArrowMenuCursor
	ld a, (wCurrentMenuItem)
	ld (wParentMenuItem), a
	and a
	jp z, BillsPCWithdraw ; withdraw
	cp $1
	jp z, BillsPCDeposit ; deposit
	cp $2
	jp z, BillsPCRelease ; release
	cp $3
	jp z, BillsPCChangeBox ; change box

ExitBillsPC:
	ld a, (wMiscFlags)
	bit BIT_USING_GENERIC_PC, a
	jr nz, ExitBillsPC.next
; accessing it directly
	call LoadTextBoxTilePatterns
	ld a, SFX_TURN_OFF_PC
	call PlaySound
	call WaitForSoundToFinish
ExitBillsPC.next:
	ld hl, wMiscFlags
	res BIT_NO_MENU_BUTTON_SOUND, (hl)
	call LoadScreenTilesFromBuffer2
	pop af
	ld (wListScrollOffset), a
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, (hl)
	ret

BillsPCDeposit:
	ld a, (wPartyCount)
	dec a
	jr nz, BillsPCDeposit.partyLargeEnough
	ld hl, CantDepositLastMonText
	call PrintText
	jp BillsPCMenu
BillsPCDeposit.partyLargeEnough:
	ld a, (wBoxCount)
	cp MONS_PER_BOX
	jr nz, BillsPCDeposit.boxNotFull
	ld hl, BoxFullText
	call PrintText
	jp BillsPCMenu
BillsPCDeposit.boxNotFull:
	ld hl, wPartyCount
	call DisplayMonListMenu
	jp c, BillsPCMenu
	call DisplayDepositWithdrawMenu
	jp nc, BillsPCMenu
	ld a, (wCurPartySpecies)
	call GetCryData
	call PlaySoundWaitForCurrent
	ld a, PARTY_TO_BOX
	ld (wMoveMonType), a
	call MoveMon
	xor a
	ld (wRemoveMonFromBox), a
	call RemovePokemon
	call WaitForSoundToFinish
	ld hl, wBoxNumString
	ld a, (wCurrentBoxNum)
	and BOX_NUM_MASK
	cp 9
	jr c, BillsPCDeposit.singleDigitBoxNum
	sub 9
	ld (hl), $f7
	inc hl
	add $f6
	jr BillsPCDeposit.next
BillsPCDeposit.singleDigitBoxNum:
	add $f7
BillsPCDeposit.next:
	ld (HL+), a
	ld (hl), $50
	ld hl, MonWasStoredText
	call PrintText
	jp BillsPCMenu

BillsPCWithdraw:
	ld a, (wBoxCount)
	and a
	jr nz, BillsPCWithdraw.boxNotEmpty
	ld hl, NoMonText
	call PrintText
	jp BillsPCMenu
BillsPCWithdraw.boxNotEmpty:
	ld a, (wPartyCount)
	cp PARTY_LENGTH
	jr nz, BillsPCWithdraw.partyNotFull
	ld hl, CantTakeMonText
	call PrintText
	jp BillsPCMenu
BillsPCWithdraw.partyNotFull:
	ld hl, wBoxCount
	call DisplayMonListMenu
	jp c, BillsPCMenu
	call DisplayDepositWithdrawMenu
	jp nc, BillsPCMenu
	ld a, (wWhichPokemon)
	ld hl, wBoxMonNicks
	call GetPartyMonName
	ld a, (wCurPartySpecies)
	call GetCryData
	call PlaySoundWaitForCurrent
	xor a ; BOX_TO_PARTY
	ld (wMoveMonType), a
	call MoveMon
	ld a, 1
	ld (wRemoveMonFromBox), a
	call RemovePokemon
	call WaitForSoundToFinish
	ld hl, MonIsTakenOutText
	call PrintText
	jp BillsPCMenu

BillsPCRelease:
	ld a, (wBoxCount)
	and a
	jr nz, BillsPCRelease.loop
	ld hl, NoMonText
	call PrintText
	jp BillsPCMenu
BillsPCRelease.loop:
	ld hl, wBoxCount
	call DisplayMonListMenu
	jp c, BillsPCMenu
	ld hl, OnceReleasedText
	call PrintText
	call YesNoChoice
	ld a, (wCurrentMenuItem)
	and a
	jr nz, BillsPCRelease.loop
	inc a
	ld (wRemoveMonFromBox), a
	call RemovePokemon
	call WaitForSoundToFinish
	ld a, (wCurPartySpecies)
	call PlayCry
	ld hl, MonWasReleasedText
	call PrintText
	jp BillsPCMenu

BillsPCChangeBox:
	ld b, $1c
	ld hl, $78a1
	call Bankswitch
	jp BillsPCMenu

DisplayMonListMenu:
	ld a, l
	ld (wListPointer), a
	ld a, h
	ld (wListPointer + 1), a
	xor a
	ld (wPrintItemPrices), a
	ld (wListMenuID), a
	inc a ; MONSTER_NAME
	ld (wNameListType), a
	ld a, (wPartyAndBillsPCSavedMenuItem)
	ld (wCurrentMenuItem), a
	call DisplayListMenuID
	ld a, (wCurrentMenuItem)
	ld (wPartyAndBillsPCSavedMenuItem), a
	ret

BillsPCMenuText:
	.STRINGMAP pokemon, "WITHDRAW <PKMN>"
	.DB $4e
	.STRINGMAP pokemon, "DEPOSIT <PKMN>"
	.DB $4e
	.STRINGMAP pokemon, "RELEASE <PKMN>"
	.DB $4e
	.STRINGMAP pokemon, "CHANGE BOX"
	.DB $4e
	.STRINGMAP pokemon, "SEE YA!"
	.STRINGMAP pokemon, "@"

BoxNoPCText:
	.STRINGMAP pokemon, "BOX No.@"

KnowsHMMove:
; returns whether mon with party index [wWhichPokemon] knows an HM move
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	jr KnowsHMMove.next
; unreachable
	ld hl, wBoxMon1Moves
	ld bc, BOXMON_STRUCT_LENGTH
KnowsHMMove.next:
	ld a, (wWhichPokemon)
	call AddNTimes
	ld b, NUM_MOVES
KnowsHMMove.loop:
	ld a, (HL+)
	push hl
	push bc
	ld hl, HMMoveArray
	ld de, 1
	call IsInArray
	pop bc
	pop hl
	ret c
	dec b
	jr nz, KnowsHMMove.loop
	and a
	ret

HMMoveArray:
; This file is INCLUDEd twice:
; - for HMMoves in home/names.asm
; - for HMMoveArray in engine/pokemon/bills_pc.asm

	.DB CUT
	.DB FLY
	.DB SURF
	.DB STRENGTH
	.DB FLASH
	.DB -1 ; end

DisplayDepositWithdrawMenu:
	ld hl, wTileMap + (10 * 20) + 9
	ld b, 6
	ld c, 9
	call TextBoxBorder
	ld a, (wParentMenuItem)
	and a ; was the Deposit or Withdraw item selected in the parent menu?
	ld de, DepositPCText
	jr nz, DisplayDepositWithdrawMenu.next
	ld de, WithdrawPCText
DisplayDepositWithdrawMenu.next:
	ld hl, wTileMap + (12 * 20) + 11
	call PlaceString
	ld hl, wTileMap + (14 * 20) + 11
	ld de, StatsCancelPCText
	call PlaceString
	ld hl, wTopMenuItemY
	ld a, 12
	ld (HL+), a ; wTopMenuItemY
	ld a, 10
	ld (HL+), a ; wTopMenuItemX
	xor a
	ld (HL+), a ; wCurrentMenuItem
	inc hl
	ld a, 2
	ld (HL+), a ; wMaxMenuItem
	ld a, PAD_A | PAD_B
	ld (HL+), a ; wMenuWatchedKeys
	xor a
	ld (hl), a ; wLastMenuItem
	ld hl, wListScrollOffset
	ld (HL+), a ; wListScrollOffset
	ld (hl), a ; wMenuWatchMovingOutOfBounds
	ld (wPlayerMonNumber), a
	ld (wPartyAndBillsPCSavedMenuItem), a
DisplayDepositWithdrawMenu.loop:
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, DisplayDepositWithdrawMenu.exit
	ld a, (wCurrentMenuItem)
	and a
	jr z, DisplayDepositWithdrawMenu.choseDepositWithdraw
	dec a
	jr z, DisplayDepositWithdrawMenu.viewStats
DisplayDepositWithdrawMenu.exit:
	and a
	ret
DisplayDepositWithdrawMenu.choseDepositWithdraw:
	scf
	ret
DisplayDepositWithdrawMenu.viewStats:
	call SaveScreenTilesToBuffer1
	ld a, (wParentMenuItem)
	and a
	ld a, PLAYER_PARTY_DATA
	jr nz, DisplayDepositWithdrawMenu.next2
	ld a, BOX_DATA
DisplayDepositWithdrawMenu.next2:
	ld (wMonDataLocation), a
	ld a, $36
	call Predef
	ld a, $37
	call Predef
	call LoadScreenTilesFromBuffer1
	call ReloadTilesetTilePatterns
	call RunDefaultPaletteCommand
	call LoadGBPal
	jr DisplayDepositWithdrawMenu.loop

DepositPCText:
	.STRINGMAP pokemon, "DEPOSIT@"
WithdrawPCText:
	.STRINGMAP pokemon, "WITHDRAW@"
StatsCancelPCText:
	.STRINGMAP pokemon, "STATS"
	.DB $4e
	.STRINGMAP pokemon, "CANCEL@"

SwitchOnText:
	.DB $17
	.DW $6131
	.DB $22
	.DB $50

WhatText:
	.DB $17
	.DW $613d
	.DB $22
	.DB $50

DepositWhichMonText:
	.DB $17
	.DW $6144
	.DB $22
	.DB $50

MonWasStoredText:
	.DB $17
	.DW $6159
	.DB $22
	.DB $50

CantDepositLastMonText:
	.DB $17
	.DW $6177
	.DB $22
	.DB $50

BoxFullText:
	.DB $17
	.DW $6198
	.DB $22
	.DB $50

MonIsTakenOutText:
	.DB $17
	.DW $61b9
	.DB $22
	.DB $50

NoMonText:
	.DB $17
	.DW $61d7
	.DB $22
	.DB $50

CantTakeMonText:
	.DB $17
	.DW $61f6
	.DB $22
	.DB $50

ReleaseWhichMonText:
	.DB $17
	.DW $6228
	.DB $22
	.DB $50

OnceReleasedText:
	.DB $17
	.DW $623d
	.DB $22
	.DB $50

MonWasReleasedText:
	.DB $17
	.DW $6268
	.DB $22
	.DB $50

CableClubLeftGameboy:
	ldh a, (hSerialConnectionStatus - $FF00)
	cp USING_EXTERNAL_CLOCK
	ret z
	ld a, (wSpritePlayerStateData1FacingDirection)
	cp SPRITE_FACING_RIGHT
	ret nz
	ld a, (wCurMap)
	cp TRADE_CENTER
	ld a, LINK_STATE_START_TRADE
	jr z, CableClubLeftGameboy.next
	inc a ; LINK_STATE_START_BATTLE
CableClubLeftGameboy.next:
	ld (wLinkState), a
	call EnableAutoTextBoxDrawing
	ld a, $22
	jp PrintPredefTextID

CableClubRightGameboy:
	ldh a, (hSerialConnectionStatus - $FF00)
	cp USING_INTERNAL_CLOCK
	ret z
	ld a, (wSpritePlayerStateData1FacingDirection)
	cp SPRITE_FACING_LEFT
	ret nz
	ld a, (wCurMap)
	cp TRADE_CENTER
	ld a, LINK_STATE_START_TRADE
	jr z, CableClubRightGameboy.next
	inc a ; LINK_STATE_START_BATTLE
CableClubRightGameboy.next:
	ld (wLinkState), a
	call EnableAutoTextBoxDrawing
	ld a, $22
	jp PrintPredefTextID

JustAMomentText:
	.DB $17
	.DW $4bed
	.DB $22
	.DB $50

UnusedOpenBillsPC: ; unreferenced
	ld a, (wSpritePlayerStateData1FacingDirection)
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	ld a, $23
	jp PrintPredefTextID

OpenBillsPCText:
	.DB $fd
BillsPCEnd:
