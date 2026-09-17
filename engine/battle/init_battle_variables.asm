InitBattleVariables:
	ldh a, [lobyte(hTileAnimations)]
	ld [wSavedTileAnimations], a
	xor a
	ld [wActionResultOrTookBattleTurn], a
	ld [wBattleResult], a
	ld hl, wPartyAndBillsPCSavedMenuItem
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wListScrollOffset], a
	ld [wCriticalHitOrOHKO], a
	ld [wBattleMonSpecies], a
	ld [wPartyGainExpFlags], a
	ld [wPlayerMonNumber], a
	ld [wEscapedFromBattle], a
	ld [wMapPalOffset], a
	ld hl, wPlayerHPBarColor
	ld [hli], a ; wPlayerHPBarColor
	ld [hl], a ; wEnemyHPBarColor
	ld hl, wCanEvolveFlags
	ld b, wMiscBattleDataEnd - wMiscBattleData
InitBattleVariables.loop
	ld [hli], a
	dec b
	jr nz, InitBattleVariables.loop
	inc a ; POUND
	ld [wTestBattlePlayerSelectedMove], a
	ld a, [wCurMap]
	cp SAFARI_ZONE_EAST
	jr c, InitBattleVariables.notSafariBattle
	cp SAFARI_ZONE_CENTER_REST_HOUSE
	jr nc, InitBattleVariables.notSafariBattle
	ld a, BATTLE_TYPE_SAFARI
	ld [wBattleType], a
InitBattleVariables.notSafariBattle
	jpfar PlayBattleMusic
