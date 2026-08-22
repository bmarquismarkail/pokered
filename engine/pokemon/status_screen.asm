DrawHP:
; Draws the HP bar in the stats screen
	call GetPredefRegisters
	ld a, $1
	jr DrawHP_

DrawHP2:
; Draws the HP bar in the party screen
	call GetPredefRegisters
	ld a, $2

DrawHP_:
	ld [wHPBarType], a
	push hl
	ld a, [wLoadedMonHP]
	ld b, a
	ld a, [wLoadedMonHP + 1]
	ld c, a
	or b
	jr nz, DrawHP_.nonzeroHP
	xor a
	ld c, a
	ld e, a
	ld a, $6
	ld d, a
	jp DrawHP_.drawHPBarAndPrintFraction
DrawHP_.nonzeroHP
	ld a, [wLoadedMonMaxHP]
	ld d, a
	ld a, [wLoadedMonMaxHP + 1]
	ld e, a
	predef HPBarLength
	ld a, $6
	ld d, a
	ld c, a
DrawHP_.drawHPBarAndPrintFraction
	pop hl
	push de
	push hl
	push hl
	call DrawHPBar
	pop hl
	ldh a, [lobyte(hUILayoutFlags)]
	bit BIT_PARTY_MENU_HP_BAR, a
	jr z, DrawHP_.printFractionBelowBar
	ld bc, $9 ; right of bar
	jr DrawHP_.printFraction
DrawHP_.printFractionBelowBar
	ld bc, SCREEN_WIDTH + 1 ; below bar
DrawHP_.printFraction
	add hl, bc
	ld de, wLoadedMonHP
	lb "bc", 2, 3
	call PrintNumber
	ld a, $f3
	ld [hli], a
	ld de, wLoadedMonMaxHP
	lb "bc", 2, 3
	call PrintNumber
	pop hl
	pop de
	ret

StatusScreen:
	call LoadMonData
	ld a, [wMonDataLocation]
	cp BOX_DATA
	jr c, StatusScreen.DontRecalculate
; mon is in a box or daycare
	ld a, [wLoadedMonBoxLevel]
	ld [wLoadedMonLevel], a
	ld [wCurEnemyLevel], a
	ld hl, wLoadedMonHPExp - 1
	ld de, wLoadedMonStats
	ld b, $1
	call CalcStats
StatusScreen.DontRecalculate
	ld hl, wStatusFlags2
	set BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $33
	ldh [lobyte(rAUDVOL)], a ; Reduce the volume
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	call LoadHpBarAndStatusTilePatterns
	ld de, BattleHudTiles1  ; source
	ld hl, vChars2 + TILE_SIZE * $6d ; dest
	lb "bc", bank(BattleHudTiles1), 3
	call CopyVideoDataDouble ; ·│ :L and halfarrow line end
	ld de, BattleHudTiles2
	ld hl, vChars2 + TILE_SIZE * $78
	lb "bc", bank(BattleHudTiles2), 1
	call CopyVideoDataDouble ; │
	ld de, BattleHudTiles3
	ld hl, vChars2 + TILE_SIZE * $76
	lb "bc", bank(BattleHudTiles3), 2
	call CopyVideoDataDouble ; ─ ┘
	ld de, PTile
	ld hl, vChars2 + TILE_SIZE * $72
	lb "bc", bank(PTile), 1
	call CopyVideoDataDouble ; bold P (for PP)
	ldh a, [lobyte(hTileAnimations)]
	push af
	xor a
	ldh [lobyte(hTileAnimations)], a
	hlcoord 19, 1
	lb "bc", 6, 10
	call DrawLineBox ; Draws the box around name, HP and status
	ld de, -6
	add hl, de
	ld [hl], $f2
	dec hl
	ld [hl], $74
	hlcoord 19, 9
	lb "bc", 8, 6
	call DrawLineBox ; Draws the box around types, ID No. and OT
	hlcoord 10, 9
	ld de, TypesIDNoOTText
	call PlaceString
	hlcoord 11, 3
	predef DrawHP
	ld hl, wStatusScreenHPBarColor
	call GetHealthBarColor
	ld b, SET_PAL_STATUS_SCREEN
	call RunPaletteCommand
	hlcoord 16, 6
	ld de, wLoadedMonStatus
	call PrintStatusCondition
	jr nz, StatusScreen.StatusWritten
	hlcoord 16, 6
	ld de, OKText
	call PlaceString ; "OK"
StatusScreen.StatusWritten
	hlcoord 9, 6
	ld de, StatusText
	call PlaceString ; "STATUS/"
	hlcoord 14, 2
	call PrintLevel
	ld a, [wMonHIndex]
	ld [wPokedexNum], a
	ld [wCurSpecies], a
	predef IndexToPokedex
	hlcoord 3, 7
	ld de, wPokedexNum
	lb "bc", LEADING_ZEROES | 1, 3
	call PrintNumber ; Pokémon no.
	hlcoord 11, 10
	predef PrintMonType
	ld hl, NamePointers2
	call StatusScreen.GetStringPointer
	ld d, h
	ld e, l
	hlcoord 9, 1
	call PlaceString ; Pokémon name
	ld hl, OTPointers
	call StatusScreen.GetStringPointer
	ld d, h
	ld e, l
	hlcoord 12, 16
	call PlaceString ; OT
	hlcoord 12, 14
	ld de, wLoadedMonOTID
	lb "bc", LEADING_ZEROES | 2, 5
	call PrintNumber ; ID Number
	ld d, STATUS_SCREEN_STATS_BOX
	call PrintStatsBox
	call Delay3
	call GBPalNormal
	hlcoord 1, 0
	call LoadFlippedFrontSpriteByMonIndex ; draw Pokémon picture
	ld a, [wCurPartySpecies]
	call PlayCry
	call WaitForTextScrollButtonPress
	pop af
	ldh [lobyte(hTileAnimations)], a
	ret

StatusScreen.GetStringPointer
	ld a, [wMonDataLocation]
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMonDataLocation]
	cp DAYCARE_DATA
	ret z
	ld a, [wWhichPokemon]
	jp SkipFixedLengthTextEntries

OTPointers:
	.DW wPartyMonOT
	.DW wEnemyMonOT
	.DW wBoxMonOT
	.DW wDayCareMonOT

NamePointers2:
	.DW wPartyMonNicks
	.DW wEnemyMonNicks
	.DW wBoxMonNicks
	.DW wDayCareMonName

TypesIDNoOTText:
		.STRINGMAP pokemon, "TYPE1/"
	next "TYPE2/"
	next "<ID>№/"
	next "OT/"
	next "@"

StatusText:
		.STRINGMAP pokemon, "STATUS/@"

OKText:
		.STRINGMAP pokemon, "OK@"

; Draws a line starting from hl high b and wide c
DrawLineBox:
	ld de, SCREEN_WIDTH ; New line
DrawLineBox.PrintVerticalLine
	ld [hl], $78 ; │
	add hl, de
	dec b
	jr nz, DrawLineBox.PrintVerticalLine
	ld [hl], $77 ; ┘
	dec hl
DrawLineBox.PrintHorizLine
	ld [hl], $76 ; ─
	dec hl
	dec c
	jr nz, DrawLineBox.PrintHorizLine
	ld [hl], $6f ; ← (halfarrow ending)
	ret

PTile: .INCBIN "gfx/font/P.1bpp"

PrintStatsBox:
	ld a, d
	.ASSERT ((STATUS_SCREEN_STATS_BOX)-(0)) < 1 && ((STATUS_SCREEN_STATS_BOX)-(0)) > -1
	and a
	jr nz, PrintStatsBox.LevelUpStatsBox ; battle or Rare Candy
	hlcoord 0, 8
	ld b, 8
	ld c, 8
	call TextBoxBorder
	hlcoord 1, 9
	ld bc, SCREEN_WIDTH + 5 ; one row down and 5 columns right
	jr PrintStatsBox.PrintStats
PrintStatsBox.LevelUpStatsBox
	hlcoord 9, 2
	ld b, 8
	ld c, 9
	call TextBoxBorder
	hlcoord 11, 3
	ld bc, SCREEN_WIDTH + 4 ; one row down and 4 columns right
PrintStatsBox.PrintStats
	push bc
	push hl
	ld de, PrintStatsBox.StatsText
	call PlaceString
	pop hl
	pop bc
	add hl, bc
	ld de, wLoadedMonAttack
	lb "bc", 2, 3
	call PrintStatsBox.PrintStat
	ld de, wLoadedMonDefense
	call PrintStatsBox.PrintStat
	ld de, wLoadedMonSpeed
	call PrintStatsBox.PrintStat
	ld de, wLoadedMonSpecial
	jp PrintNumber

PrintStatsBox.PrintStat:
	push hl
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

PrintStatsBox.StatsText:
		.STRINGMAP pokemon, "ATTACK"
	next "DEFENSE"
	next "SPEED"
	next "SPECIAL@"

StatusScreen2:
	ldh a, [lobyte(hTileAnimations)]
	push af
	xor a
	ldh [lobyte(hTileAnimations)], a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld bc, NUM_MOVES + 1
	ld hl, wMoves
	call FillMemory
	ld hl, wLoadedMonMoves
	ld de, wMoves
	ld bc, NUM_MOVES
	call CopyData
	callfar FormatMovesString
	hlcoord 9, 2
	lb "bc", 5, 10
	call ClearScreenArea ; Clear under name
	hlcoord 19, 3
	ld [hl], $78
	hlcoord 0, 8
	ld b, 8
	ld c, 18
	call TextBoxBorder ; Draw move container
	hlcoord 2, 9
	ld de, wMovesString
	call PlaceString ; Print moves
	ld a, [wNumMovesMinusOne]
	inc a
	ld c, a ; number of known moves
	ld a, NUM_MOVES
	sub c
	ld b, a ; number of blank moves
	hlcoord 11, 10
	ld de, SCREEN_WIDTH * 2
	ld a, $72
	call StatusScreen_PrintPP ; Print "PP"
	ld a, b
	and a
	jr z, StatusScreen2.InitPP
	ld c, a
	ld a, $e3
	call StatusScreen_PrintPP ; Fill the rest with --
StatusScreen2.InitPP
	ld hl, wLoadedMonMoves
	decoord 14, 10
	ld b, 0
StatusScreen2.PrintPP
	ld a, [hli]
	and a
	jr z, StatusScreen2.PPDone
	push bc
	push hl
	push de
	ld hl, wCurrentMenuItem
	ld a, [hl]
	push af
	ld a, b
	ld [hl], a
	push hl
	callfar GetMaxPP
	pop hl
	pop af
	ld [hl], a
	pop de
	pop hl
	push hl
	ld bc, MON_PP - MON_MOVES - 1
	add hl, bc
	ld a, [hl]
	and PP_MASK
	ld [wStatusScreenCurrentPP], a
	ld h, d
	ld l, e
	push hl
	ld de, wStatusScreenCurrentPP
	lb "bc", 1, 2
	call PrintNumber
	ld a, $f3
	ld [hli], a
	ld de, wMaxPP
	lb "bc", 1, 2
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ld d, h
	ld e, l
	pop hl
	pop bc
	inc b
	ld a, b
	cp NUM_MOVES
	jr nz, StatusScreen2.PrintPP
StatusScreen2.PPDone
	hlcoord 9, 3
	ld de, StatusScreenExpText
	call PlaceString
	ld a, [wLoadedMonLevel]
	push af
	cp MAX_LEVEL
	jr z, StatusScreen2.Level100
	inc a
	ld [wLoadedMonLevel], a ; Increase temporarily if not 100
StatusScreen2.Level100
	hlcoord 14, 6
	ld [hl], $70
	inc hl
	inc hl
	call PrintLevel
	pop af
	ld [wLoadedMonLevel], a
	ld de, wLoadedMonExp
	hlcoord 12, 4
	lb "bc", 3, 7
	call PrintNumber ; exp
	call CalcExpToLevelUp
	ld de, wLoadedMonExp
	hlcoord 7, 6
	lb "bc", 3, 7
	call PrintNumber ; exp needed to level up

	; unneeded, this clears the diacritic characters in JPN versions
	hlcoord 9, 0
	call StatusScreen_ClearName

	hlcoord 9, 1
	call StatusScreen_ClearName
	ld a, [wMonHIndex]
	ld [wNamedObjectIndex], a
	call GetMonName
	hlcoord 9, 1
	call PlaceString
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call Delay3
	call WaitForTextScrollButtonPress
	pop af
	ldh [lobyte(hTileAnimations)], a
	ld hl, wStatusFlags2
	res BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $77
	ldh [lobyte(rAUDVOL)], a
	call GBPalWhiteOut
	jp ClearScreen

CalcExpToLevelUp:
	ld a, [wLoadedMonLevel]
	cp MAX_LEVEL
	jr z, CalcExpToLevelUp.atMaxLevel
	inc a
	ld d, a
	callfar CalcExperience
	ld hl, wLoadedMonExp + 2
	ldh a, [lobyte(hExperience + 2)]
	sub [hl]
	ld [hld], a
	ldh a, [lobyte(hExperience + 1)]
	sbc [hl]
	ld [hld], a
	ldh a, [lobyte(hExperience)]
	sbc [hl]
	ld [hld], a
	ret
CalcExpToLevelUp.atMaxLevel
	ld hl, wLoadedMonExp
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

StatusScreenExpText:
		.STRINGMAP pokemon, "EXP POINTS"
	next "LEVEL UP@"

StatusScreen_ClearName:
	ld bc, NAME_LENGTH - 1
	ld a, $7f
	jp FillMemory

StatusScreen_PrintPP:
; print PP or -- c times, going down two rows each time
	ld [hli], a
	ld [hld], a
	add hl, de
	dec c
	jr nz, StatusScreen_PrintPP
	ret
