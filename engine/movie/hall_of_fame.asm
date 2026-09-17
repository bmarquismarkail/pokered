AnimateHallOfFame:
	call HoFFadeOutScreenAndMusic
	call ClearScreen
	ld c, 100
	call DelayFrames
	call LoadFontTilePatterns
	call LoadTextBoxTilePatterns
	call DisableLCD
	ld hl, vBGMap0
	ld bc, 2 * TILEMAP_AREA
	ld a, $7f
	call FillMemory
	call EnableLCD
	ld hl, rLCDC
	set B_LCDC_BG_MAP, [hl]
	xor a
	ld hl, wHallOfFame
	ld bc, HOF_TEAM
	call FillMemory
	xor a
	ld [wUpdateSpritesEnabled], a
	ldh [lobyte(hTileAnimations)], a
	ld [wSpriteFlipped], a
	ld [wLetterPrintingDelayFlags], a ; no delay
	ld [wHoFMonOrPlayer], a ; mon
	inc a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld hl, wNumHoFTeams
	ld a, [hl]
	inc a
	jr z, AnimateHallOfFame.skipInc ; don't wrap around to 0
	inc [hl]
AnimateHallOfFame.skipInc
	ld a, $90
	ldh [lobyte(hWY)], a
	ld c, bank(Music_HallOfFame)
	ld a, MUSIC_HALL_OF_FAME
	call PlayMusic
	ld hl, wPartySpecies
	ld c, $ff
AnimateHallOfFame.partyMonLoop
	ld a, [hli]
	cp $ff
	jr z, AnimateHallOfFame.doneShowingParty
	inc c
	push hl
	push bc
	ld [wHoFMonSpecies], a
	ld a, c
	ld [wHoFPartyMonIndex], a
	ld hl, wPartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hl]
	ld [wHoFMonLevel], a
	call HoFShowMonOrPlayer
	call HoFDisplayAndRecordMonInfo
	ld c, 80
	call DelayFrames
	hlcoord 2, 13
	ld b, 3
	ld c, 14
	call TextBoxBorder
	hlcoord 4, 15
	ld de, HallOfFameText
	call PlaceString
	ld c, 180
	call DelayFrames
	call GBFadeOutToWhite
	pop bc
	pop hl
	jr AnimateHallOfFame.partyMonLoop
AnimateHallOfFame.doneShowingParty
	ld a, c
	inc a
	ld hl, wHallOfFame
	ld bc, HOF_MON
	call AddNTimes
	ld [hl], $ff
	call SaveHallOfFameTeams
	xor a
	ld [wHoFMonSpecies], a
	inc a
	ld [wHoFMonOrPlayer], a ; player
	call HoFShowMonOrPlayer
	call HoFDisplayPlayerStats
	call HoFFadeOutScreenAndMusic
	xor a
	ldh [lobyte(hWY)], a
	ld hl, rLCDC
	res B_LCDC_BG_MAP, [hl]
	ret

HallOfFameText:
		.STRINGMAP pokemon, "HALL OF FAME@"

HoFShowMonOrPlayer:
	call ClearScreen
	ld a, $d0
	ldh [lobyte(hSCY)], a
	ld a, $c0
	ldh [lobyte(hSCX)], a
	ld a, [wHoFMonSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	ld [wBattleMonSpecies2], a
	ld [wWholeScreenPaletteMonSpecies], a
	ld a, [wHoFMonOrPlayer]
	and a
	jr z, HoFShowMonOrPlayer.showMon
; show player
	call HoFLoadPlayerPics
	jr HoFShowMonOrPlayer.next1
HoFShowMonOrPlayer.showMon
	hlcoord 12, 5
	call GetMonHeader
	call LoadFrontSpriteByMonIndex
	predef LoadMonBackPic
HoFShowMonOrPlayer.next1
	ld b, SET_PAL_POKEMON_WHOLE_SCREEN
	ld c, 0
	call RunPaletteCommand
	ld a, %11100100
	ldh [lobyte(rBGP)], a
	ld c, $31 ; back pic
	call HoFLoadMonPlayerPicTileIDs
	ld d, $a0
	ld e, 4
	ld a, [wOnSGB]
	and a
	jr z, HoFShowMonOrPlayer.next2
	sla e ; scroll more slowly on SGB
HoFShowMonOrPlayer.next2
	call HoFShowMonOrPlayer.ScrollPic ; scroll back pic left
	xor a
	ldh [lobyte(hSCY)], a
	ld c, a ; front pic
	call HoFLoadMonPlayerPicTileIDs
	ld d, 0
	ld e, -4
; scroll front pic right

HoFShowMonOrPlayer.ScrollPic
	call DelayFrame
	ldh a, [lobyte(hSCX)]
	add e
	ldh [lobyte(hSCX)], a
	cp d
	jr nz, HoFShowMonOrPlayer.ScrollPic
	ret

HoFDisplayAndRecordMonInfo:
	ld a, [wHoFPartyMonIndex]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	call HoFDisplayMonInfo
	jp HoFRecordMonInfo

HoFDisplayMonInfo:
	hlcoord 0, 2
	ld b, 9
	ld c, 10
	call TextBoxBorder
	hlcoord 2, 6
	ld de, HoFMonInfoText
	call PlaceString
	hlcoord 1, 4
	ld de, wNameBuffer
	call PlaceString
	ld a, [wHoFMonLevel]
	hlcoord 8, 7
	call PrintLevelCommon
	ld a, [wHoFMonSpecies]
	ld [wCurSpecies], a
	hlcoord 3, 9
	predef PrintMonType
	ld a, [wHoFMonSpecies]
	jp PlayCry

HoFMonInfoText:
		.STRINGMAP pokemon, "LEVEL/"
	next "TYPE1/"
	next "TYPE2/@"

HoFLoadPlayerPics:
	ld de, RedPicFront
	ld a, bank(RedPicFront)
	call UncompressSpriteFromDE
	ld hl, sSpriteBuffer1
	ld de, sSpriteBuffer0
	ld bc, 2 * SPRITEBUFFERSIZE
	call CopyData
	ld de, vFrontPic
	call InterlaceMergeSpriteBuffers
	ld de, RedPicBack
	ld a, bank(RedPicBack)
	call UncompressSpriteFromDE
	predef ScaleSpriteByTwo
	ld de, vBackPic
	call InterlaceMergeSpriteBuffers
	ld c, $1

HoFLoadMonPlayerPicTileIDs:
; c = base tile ID
	ld b, TILEMAP_MON_PIC
	hlcoord 12, 5
	predef_jump CopyTileIDsFromList

HoFDisplayPlayerStats:
	SetEvent EVENT_HALL_OF_FAME_DEX_RATING
	predef DisplayDexRating
	hlcoord 0, 4
	ld b, 6
	ld c, 10
	call TextBoxBorder
	hlcoord 5, 0
	ld b, 2
	ld c, 9
	call TextBoxBorder
	hlcoord 7, 2
	ld de, wPlayerName
	call PlaceString
	hlcoord 1, 6
	ld de, HoFPlayTimeText
	call PlaceString
	hlcoord 5, 7
	ld de, wPlayTimeHours
	lb "bc", 1, 3
	call PrintNumber
	ld [hl], $6d
	inc hl
	ld de, wPlayTimeMinutes
	lb "bc", LEADING_ZEROES | 1, 2
	call PrintNumber
	hlcoord 1, 9
	ld de, HoFMoneyText
	call PlaceString
	hlcoord 4, 10
	ld de, wPlayerMoney
	ld c, 3 | LEADING_ZEROES | MONEY_SIGN
	call PrintBCDNumber
	ld hl, DexSeenOwnedText
	call HoFPrintTextAndDelay
	ld hl, DexRatingText
	call HoFPrintTextAndDelay
	ld hl, wDexRatingText

HoFPrintTextAndDelay:
	call PrintText
	ld c, 120
	jp DelayFrames

HoFPlayTimeText:
		.STRINGMAP pokemon, "PLAY TIME@"

HoFMoneyText:
		.STRINGMAP pokemon, "MONEY@"

DexSeenOwnedText:
	text_far WLA_GLOBAL_DexSeenOwnedText
	text_end

DexRatingText:
	text_far WLA_GLOBAL_DexRatingText
	text_end

HoFRecordMonInfo:
	ld hl, wHallOfFame
	ld bc, HOF_MON
	ld a, [wHoFPartyMonIndex]
	call AddNTimes
	ld a, [wHoFMonSpecies]
	ld [hli], a
	ld a, [wHoFMonLevel]
	ld [hli], a
	ld e, l
	ld d, h
	ld hl, wNameBuffer
	ld bc, NAME_LENGTH
	jp CopyData

HoFFadeOutScreenAndMusic:
	ld a, 10
	ld [wAudioFadeOutCounterReloadValue], a
	ld [wAudioFadeOutCounter], a
	ld a, $ff
	ld [wAudioFadeOutControl], a
	jp GBFadeOutToWhite
