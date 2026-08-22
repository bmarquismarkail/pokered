EndOfBattle:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, EndOfBattle.notLinkBattle
; link battle
	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1Status
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [wEnemyMonStatus]
	ld [hl], a
	call ClearScreen
	callfar DisplayLinkBattleVersusTextBox
	ld a, [wBattleResult]
	cp $1
	ld de, YouWinText
	jr c, EndOfBattle.placeWinOrLoseString
	ld de, YouLoseText
	jr z, EndOfBattle.placeWinOrLoseString
	ld de, DrawText
EndOfBattle.placeWinOrLoseString
	hlcoord 6, 8
	call PlaceString
	ld c, 200
	call DelayFrames
	jr EndOfBattle.evolution
EndOfBattle.notLinkBattle
	ld a, [wBattleResult]
	and a
	jr nz, EndOfBattle.resetVariables
	ld hl, wTotalPayDayMoney
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	jr z, EndOfBattle.evolution ; if pay day money is 0, jump
	ld de, wPlayerMoney + 2
	ld c, $3
	predef AddBCDPredef
	ld hl, PickUpPayDayMoneyText
	call PrintText
EndOfBattle.evolution
	xor a
	ld [wForceEvolution], a
	predef EvolutionAfterBattle
EndOfBattle.resetVariables
	xor a
	ld [wLowHealthAlarm], a ;disable low health alarm
	ld [wChannelSoundIDs + CHAN5], a
	ld [wIsInBattle], a
	ld [wBattleType], a
	ld [wMoveMissed], a
	ld [wCurOpponent], a
	ld [wForcePlayerToChooseMon], a
	ld [wNumRunAttempts], a
	ld [wEscapedFromBattle], a
	ld hl, wPartyAndBillsPCSavedMenuItem
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wListScrollOffset], a
	ld hl, wBattleStatusData
	ld b, wBattleStatusDataEnd - wBattleStatusData
EndOfBattle.loop
	ld [hli], a
	dec b
	jr nz, EndOfBattle.loop
	ld hl, wStatusFlags2
	set BIT_WILD_ENCOUNTER_COOLDOWN, [hl]
	call WaitForSoundToFinish
	call GBPalWhiteOut
	ld a, $ff
	ld [wDestinationWarpID], a
	ret

YouWinText:
		.STRINGMAP pokemon, "YOU WIN@"

YouLoseText:
		.STRINGMAP pokemon, "YOU LOSE@"

DrawText:
		.STRINGMAP pokemon, "  DRAW@"

PickUpPayDayMoneyText:
	text_far WLA_GLOBAL_PickUpPayDayMoneyText
	text_end
