DisplayPCMainMenu:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call SaveScreenTilesToBuffer2
	ld a, [wNumHoFTeams]
	and a
	jr nz, DisplayPCMainMenu.leaguePCAvailable
	CheckEvent EVENT_GOT_POKEDEX
	jr z, DisplayPCMainMenu.noOaksPC
	ld a, [wNumHoFTeams]
	and a
	jr nz, DisplayPCMainMenu.leaguePCAvailable
	hlcoord 0, 0
	ld b, 8
	ld c, 14
	jr DisplayPCMainMenu.next
DisplayPCMainMenu.noOaksPC
	hlcoord 0, 0
	ld b, 6
	ld c, 14
	jr DisplayPCMainMenu.next
DisplayPCMainMenu.leaguePCAvailable
	hlcoord 0, 0
	ld b, 10
	ld c, 14
DisplayPCMainMenu.next
	call TextBoxBorder
	call UpdateSprites
	ld a, 3
	ld [wMaxMenuItem], a
	CheckEvent EVENT_MET_BILL
	jr nz, DisplayPCMainMenu.metBill
	hlcoord 2, 2
	ld de, SomeonesPCText
	jr DisplayPCMainMenu.next2
DisplayPCMainMenu.metBill
	hlcoord 2, 2
	ld de, BillsPCText
DisplayPCMainMenu.next2
	call PlaceString
	hlcoord 2, 4
	ld de, wPlayerName
	call PlaceString
	ld l, c
	ld h, b
	ld de, PlayersPCText
	call PlaceString
	CheckEvent EVENT_GOT_POKEDEX
	jr z, DisplayPCMainMenu.noOaksPC2
	hlcoord 2, 6
	ld de, OaksPCText
	call PlaceString
	ld a, [wNumHoFTeams]
	and a
	jr z, DisplayPCMainMenu.noLeaguePC
	ld a, 4
	ld [wMaxMenuItem], a
	hlcoord 2, 8
	ld de, PKMNLeaguePCText
	call PlaceString
	hlcoord 2, 10
	ld de, LogOffPCText
	jr DisplayPCMainMenu.next3
DisplayPCMainMenu.noLeaguePC
	hlcoord 2, 8
	ld de, LogOffPCText
	jr DisplayPCMainMenu.next3
DisplayPCMainMenu.noOaksPC2
	ld a, $2
	ld [wMaxMenuItem], a
	hlcoord 2, 6
	ld de, LogOffPCText
DisplayPCMainMenu.next3
	call PlaceString
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, 1
	ldh [lobyte(hAutoBGTransferEnabled)], a
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
	set BIT_NO_TEXT_DELAY, [hl]
	xor a
	ld [wParentMenuItem], a
	inc a               ; MONSTER_NAME
	ld [wNameListType], a
	call LoadHpBarAndStatusTilePatterns
	ld a, [wListScrollOffset]
	push af
	ld a, [wMiscFlags]
	bit BIT_USING_GENERIC_PC, a
	jr nz, BillsPCMenu
; accessing it directly
	ld a, SFX_TURN_ON_PC
	call PlaySound
	ld hl, SwitchOnText
	call PrintText

BillsPCMenu:
	ld a, [wParentMenuItem]
	ld [wCurrentMenuItem], a
	ld hl, vChars2 + TILE_SIZE * $78
	ld de, PokeballTileGraphics
	lb "bc", bank(PokeballTileGraphics), 1
	call CopyVideoData
	call LoadScreenTilesFromBuffer2DisableBGTransfer
	hlcoord 0, 0
	ld b, 10
	ld c, 12
	call TextBoxBorder
	hlcoord 2, 2
	ld de, BillsPCMenuText
	call PlaceString
	ld hl, wTopMenuItemY
	ld a, 2
	ld [hli], a ; wTopMenuItemY
	dec a
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, 4
	ld [hli], a ; wMaxMenuItem
	ld a, PAD_A | PAD_B
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hli], a ; wLastMenuItem
	ld [hli], a ; wPartyAndBillsPCSavedMenuItem
	ld hl, wListScrollOffset
	ld [hli], a ; wListScrollOffset
	ld [hl], a ; wMenuWatchMovingOutOfBounds
	ld [wPlayerMonNumber], a
	ld hl, WhatText
	call PrintText
	hlcoord 9, 14
	ld b, 2
	ld c, 9
	call TextBoxBorder
	ld a, [wCurrentBoxNum]
	and BOX_NUM_MASK
	cp 9
	jr c, BillsPCMenu.singleDigitBoxNum
; two digit box num
	sub 9
	hlcoord 17, 16
	ld [hl], $f7
	add $f6
	jr BillsPCMenu.next
BillsPCMenu.singleDigitBoxNum
	add $f7
BillsPCMenu.next
	ldcoord_a 18, 16
	hlcoord 10, 16
	ld de, BoxNoPCText
	call PlaceString
	ld a, 1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call Delay3
	call HandleMenuInput
	bit B_PAD_B, a
	jp nz, ExitBillsPC
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	ld [wParentMenuItem], a
	and a
	jp z, BillsPCWithdraw ; withdraw
	cp $1
	jp z, BillsPCDeposit ; deposit
	cp $2
	jp z, BillsPCRelease ; release
	cp $3
	jp z, BillsPCChangeBox ; change box

ExitBillsPC:
	ld a, [wMiscFlags]
	bit BIT_USING_GENERIC_PC, a
	jr nz, ExitBillsPC.next
; accessing it directly
	call LoadTextBoxTilePatterns
	ld a, SFX_TURN_OFF_PC
	call PlaySound
	call WaitForSoundToFinish
ExitBillsPC.next
	ld hl, wMiscFlags
	res BIT_NO_MENU_BUTTON_SOUND, [hl]
	call LoadScreenTilesFromBuffer2
	pop af
	ld [wListScrollOffset], a
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ret

BillsPCDeposit:
	ld a, [wPartyCount]
	dec a
	jr nz, BillsPCDeposit.partyLargeEnough
	ld hl, CantDepositLastMonText
	call PrintText
	jp BillsPCMenu
BillsPCDeposit.partyLargeEnough
	ld a, [wBoxCount]
	cp MONS_PER_BOX
	jr nz, BillsPCDeposit.boxNotFull
	ld hl, BoxFullText
	call PrintText
	jp BillsPCMenu
BillsPCDeposit.boxNotFull
	ld hl, wPartyCount
	call DisplayMonListMenu
	jp c, BillsPCMenu
	call DisplayDepositWithdrawMenu
	jp nc, BillsPCMenu
	ld a, [wCurPartySpecies]
	call GetCryData
	call PlaySoundWaitForCurrent
	ld a, PARTY_TO_BOX
	ld [wMoveMonType], a
	call MoveMon
	xor a
	ld [wRemoveMonFromBox], a
	call RemovePokemon
	call WaitForSoundToFinish
	ld hl, wBoxNumString
	ld a, [wCurrentBoxNum]
	and BOX_NUM_MASK
	cp 9
	jr c, BillsPCDeposit.singleDigitBoxNum
	sub 9
	ld [hl], $f7
	inc hl
	add $f6
	jr BillsPCDeposit.next
BillsPCDeposit.singleDigitBoxNum
	add $f7
BillsPCDeposit.next
	ld [hli], a
	ld [hl], $50
	ld hl, MonWasStoredText
	call PrintText
	jp BillsPCMenu

BillsPCWithdraw:
	ld a, [wBoxCount]
	and a
	jr nz, BillsPCWithdraw.boxNotEmpty
	ld hl, NoMonText
	call PrintText
	jp BillsPCMenu
BillsPCWithdraw.boxNotEmpty
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jr nz, BillsPCWithdraw.partyNotFull
	ld hl, CantTakeMonText
	call PrintText
	jp BillsPCMenu
BillsPCWithdraw.partyNotFull
	ld hl, wBoxCount
	call DisplayMonListMenu
	jp c, BillsPCMenu
	call DisplayDepositWithdrawMenu
	jp nc, BillsPCMenu
	ld a, [wWhichPokemon]
	ld hl, wBoxMonNicks
	call GetPartyMonName
	ld a, [wCurPartySpecies]
	call GetCryData
	call PlaySoundWaitForCurrent
	xor a ; BOX_TO_PARTY
	ld [wMoveMonType], a
	call MoveMon
	ld a, 1
	ld [wRemoveMonFromBox], a
	call RemovePokemon
	call WaitForSoundToFinish
	ld hl, MonIsTakenOutText
	call PrintText
	jp BillsPCMenu

BillsPCRelease:
	ld a, [wBoxCount]
	and a
	jr nz, BillsPCRelease.loop
	ld hl, NoMonText
	call PrintText
	jp BillsPCMenu
BillsPCRelease.loop
	ld hl, wBoxCount
	call DisplayMonListMenu
	jp c, BillsPCMenu
	ld hl, OnceReleasedText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, BillsPCRelease.loop
	inc a
	ld [wRemoveMonFromBox], a
	call RemovePokemon
	call WaitForSoundToFinish
	ld a, [wCurPartySpecies]
	call PlayCry
	ld hl, MonWasReleasedText
	call PrintText
	jp BillsPCMenu

BillsPCChangeBox:
	farcall ChangeBox
	jp BillsPCMenu

DisplayMonListMenu:
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld [wListMenuID], a
	inc a                ; MONSTER_NAME
	ld [wNameListType], a
	ld a, [wPartyAndBillsPCSavedMenuItem]
	ld [wCurrentMenuItem], a
	call DisplayListMenuID
	ld a, [wCurrentMenuItem]
	ld [wPartyAndBillsPCSavedMenuItem], a
	ret

BillsPCMenuText:
		.STRINGMAP pokemon, "WITHDRAW <PKMN>"
	next "DEPOSIT <PKMN>"
	next "RELEASE <PKMN>"
	next "CHANGE BOX"
	next "SEE YA!"
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
KnowsHMMove.next
	ld a, [wWhichPokemon]
	call AddNTimes
	ld b, NUM_MOVES
KnowsHMMove.loop
	ld a, [hli]
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
.INCLUDE "data/moves/hm_moves.asm"

DisplayDepositWithdrawMenu:
	hlcoord 9, 10
	ld b, 6
	ld c, 9
	call TextBoxBorder
	ld a, [wParentMenuItem]
	and a ; was the Deposit or Withdraw item selected in the parent menu?
	ld de, DepositPCText
	jr nz, DisplayDepositWithdrawMenu.next
	ld de, WithdrawPCText
DisplayDepositWithdrawMenu.next
	hlcoord 11, 12
	call PlaceString
	hlcoord 11, 14
	ld de, StatsCancelPCText
	call PlaceString
	ld hl, wTopMenuItemY
	ld a, 12
	ld [hli], a ; wTopMenuItemY
	ld a, 10
	ld [hli], a ; wTopMenuItemX
	xor a
	ld [hli], a ; wCurrentMenuItem
	inc hl
	ld a, 2
	ld [hli], a ; wMaxMenuItem
	ld a, PAD_A | PAD_B
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hl], a ; wLastMenuItem
	ld hl, wListScrollOffset
	ld [hli], a ; wListScrollOffset
	ld [hl], a ; wMenuWatchMovingOutOfBounds
	ld [wPlayerMonNumber], a
	ld [wPartyAndBillsPCSavedMenuItem], a
DisplayDepositWithdrawMenu.loop
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, DisplayDepositWithdrawMenu.exit
	ld a, [wCurrentMenuItem]
	and a
	jr z, DisplayDepositWithdrawMenu.choseDepositWithdraw
	dec a
	jr z, DisplayDepositWithdrawMenu.viewStats
DisplayDepositWithdrawMenu.exit
	and a
	ret
DisplayDepositWithdrawMenu.choseDepositWithdraw
	scf
	ret
DisplayDepositWithdrawMenu.viewStats
	call SaveScreenTilesToBuffer1
	ld a, [wParentMenuItem]
	and a
	ld a, PLAYER_PARTY_DATA
	jr nz, DisplayDepositWithdrawMenu.next2
	ld a, BOX_DATA
DisplayDepositWithdrawMenu.next2
	ld [wMonDataLocation], a
	predef StatusScreen
	predef StatusScreen2
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
	next "CANCEL@"

SwitchOnText:
	text_far WLA_GLOBAL_SwitchOnText
	text_end

WhatText:
	text_far WLA_GLOBAL_WhatText
	text_end

DepositWhichMonText:
	text_far WLA_GLOBAL_DepositWhichMonText
	text_end

MonWasStoredText:
	text_far WLA_GLOBAL_MonWasStoredText
	text_end

CantDepositLastMonText:
	text_far WLA_GLOBAL_CantDepositLastMonText
	text_end

BoxFullText:
	text_far WLA_GLOBAL_BoxFullText
	text_end

MonIsTakenOutText:
	text_far WLA_GLOBAL_MonIsTakenOutText
	text_end

NoMonText:
	text_far WLA_GLOBAL_NoMonText
	text_end

CantTakeMonText:
	text_far WLA_GLOBAL_CantTakeMonText
	text_end

ReleaseWhichMonText:
	text_far WLA_GLOBAL_ReleaseWhichMonText
	text_end

OnceReleasedText:
	text_far WLA_GLOBAL_OnceReleasedText
	text_end

MonWasReleasedText:
	text_far WLA_GLOBAL_MonWasReleasedText
	text_end

CableClubLeftGameboy:
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_EXTERNAL_CLOCK
	ret z
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_RIGHT
	ret nz
	ld a, [wCurMap]
	cp TRADE_CENTER
	ld a, LINK_STATE_START_TRADE
	jr z, CableClubLeftGameboy.next
	inc a ; LINK_STATE_START_BATTLE
CableClubLeftGameboy.next
	ld [wLinkState], a
	call EnableAutoTextBoxDrawing
	tx_pre_jump JustAMomentText

CableClubRightGameboy:
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_INTERNAL_CLOCK
	ret z
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_LEFT
	ret nz
	ld a, [wCurMap]
	cp TRADE_CENTER
	ld a, LINK_STATE_START_TRADE
	jr z, CableClubRightGameboy.next
	inc a ; LINK_STATE_START_BATTLE
CableClubRightGameboy.next
	ld [wLinkState], a
	call EnableAutoTextBoxDrawing
	tx_pre_jump JustAMomentText

JustAMomentText:
	text_far WLA_GLOBAL_JustAMomentText
	text_end

UnusedOpenBillsPC: ; unreferenced
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre_jump OpenBillsPCText

OpenBillsPCText:
	script_bills_pc
