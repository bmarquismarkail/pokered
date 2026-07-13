; Native WLA-DX form of engine/menus/league_pc.asm, engine/events/hidden_items.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"
PKMNLeaguePC:
	ld hl, AccessedHoFPCText
	call PrintText
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, (hl)
	push hl
	ld a, (wUpdateSpritesEnabled)
	push af
	ldh a, (hTileAnimations - $FF00)
	push af
	xor a
	ldh (hTileAnimations - $FF00), a
	ld (wSpriteFlipped), a
	ld (wUpdateSpritesEnabled), a
	ld (wHoFTeamIndex2), a
	ld (wHoFTeamNo), a
	ld a, (wNumHoFTeams)
	ld b, a
	cp HOF_TEAM_CAPACITY + 1
	jr c, PKMNLeaguePC.loop
; If the total number of hall of fame teams is greater than the storage
; capacity, then calculate the number of the first team that is still recorded.
	ld b, HOF_TEAM_CAPACITY
	sub b
	ld (wHoFTeamNo), a
PKMNLeaguePC.loop:
	ld hl, wHoFTeamNo
	inc (hl)
	push bc
	ld a, (wHoFTeamIndex2)
	ld (wHoFTeamIndex), a
	ld b, $1c
	ld hl, $7b3f
	call Bankswitch
	call LeaguePCShowTeam
	pop bc
	jr c, PKMNLeaguePC.doneShowingTeams
	ld hl, wHoFTeamIndex2
	inc (hl)
	ld a, (hl)
	cp b
	jr nz, PKMNLeaguePC.loop
PKMNLeaguePC.doneShowingTeams:
	pop af
	ldh (hTileAnimations - $FF00), a
	pop af
	ld (wUpdateSpritesEnabled), a
	pop hl
	res BIT_NO_TEXT_DELAY, (hl)
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call RunDefaultPaletteCommand
	jp GBPalNormal

LeaguePCShowTeam:
	ld c, PARTY_LENGTH
LeaguePCShowTeam.loop:
	push bc
	call LeaguePCShowMon
	call WaitForTextScrollButtonPress
	ldh a, (hJoyHeld - $FF00)
	bit B_PAD_B, a
	jr nz, LeaguePCShowTeam.exit
	ld hl, wHallOfFame + HOF_MON
	ld de, wHallOfFame
	ld bc, HOF_TEAM - HOF_MON
	call CopyData
	pop bc
	ld a, (wHallOfFame + 0)
	cp $ff
	jr z, LeaguePCShowTeam.done
	dec c
	jr nz, LeaguePCShowTeam.loop
LeaguePCShowTeam.done:
	and a
	ret
LeaguePCShowTeam.exit:
	pop bc
	scf
	ret

LeaguePCShowMon:
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	ld hl, wHallOfFame
	ld a, (HL+)
	ld (wHoFMonSpecies), a
	ld (wCurPartySpecies), a
	ld (wCurSpecies), a
	ld (wBattleMonSpecies2), a
	ld (wWholeScreenPaletteMonSpecies), a
	ld a, (HL+)
	ld (wHoFMonLevel), a
	ld de, wNameBuffer
	ld bc, NAME_LENGTH
	call CopyData
	ld b, SET_PAL_POKEMON_WHOLE_SCREEN
	ld c, 0
	call RunPaletteCommand
	ld hl, wTileMap + (5 * 20) + 12
	call GetMonHeader
	call LoadFrontSpriteByMonIndex
	call GBPalNormal
	ld hl, wTileMap + (13 * 20) + 0
	ld b, 2
	ld c, $12
	call TextBoxBorder
	ld hl, wTileMap + (15 * 20) + 1
	ld de, HallOfFameNoText
	call PlaceString
	ld hl, wTileMap + (15 * 20) + 16
	ld de, wHoFTeamNo
	ld bc, ((1) << 8) | (3)
	call PrintNumber
	ld b, $1c
	ld hl, $42f0
	jp Bankswitch

HallOfFameNoText:
	.STRINGMAP pokemon, "HALL OF FAME No   @"

AccessedHoFPCText:
	.DB $17
	.DW $60f4
	.DB $22
	.DB $50
HiddenItems:
	ld hl, HiddenItemCoords
	call FindHiddenItemOrCoinsIndex
	ld (wHiddenItemOrCoinsIndex), a
	ld hl, wObtainedHiddenItemsFlags
	ld a, (wHiddenItemOrCoinsIndex)
	ld c, a
	ld b, FLAG_TEST
	ld a, $10
	call Predef
	ld a, c
	and a
	ret nz
	call EnableAutoTextBoxDrawing
	ld a, 1
	ld (wDoNotWaitForButtonPressAfterDisplayingText), a
	ld a, (wHiddenEventFunctionArgument) ; item ID
	ld (wNamedObjectIndex), a
	call GetItemName
	ld a, $24
	jp PrintPredefTextID


HiddenItemCoords:
; table_width 3
	; map id, x, y
	.DB VIRIDIAN_FOREST, 18, 1
	.DB VIRIDIAN_FOREST, 42, 16
	.DB MT_MOON_B2F, 12, 18
	.DB ROUTE_25, 3, 38
	.DB ROUTE_9, 7, 14
	.DB SS_ANNE_KITCHEN, 9, 13
	.DB SS_ANNE_B1F_ROOMS, 1, 3
	.DB ROUTE_10, 17, 9
	.DB ROUTE_10, 53, 16
	.DB ROCKET_HIDEOUT_B1F, 15, 21
	.DB ROCKET_HIDEOUT_B3F, 17, 27
	.DB ROCKET_HIDEOUT_B4F, 1, 25
	.DB POKEMON_TOWER_5F, 12, 4
	.DB ROUTE_13, 14, 1
	.DB ROUTE_13, 13, 16
	.DB POKEMON_MANSION_B1F, 9, 1
	.DB SAFARI_ZONE_GATE, 1, 10 ; inaccessible
	.DB SAFARI_ZONE_WEST, 5, 6
	.DB SILPH_CO_5F, 3, 12
	.DB SILPH_CO_9F, 15, 2
	.DB COPYCATS_HOUSE_2F, 1, 1
	.DB CERULEAN_CAVE_1F, 11, 14
	.DB CERULEAN_CAVE_B1F, 3, 27
	.DB POWER_PLANT, 16, 17
	.DB POWER_PLANT, 1, 12
	.DB SEAFOAM_ISLANDS_B2F, 15, 15
	.DB SEAFOAM_ISLANDS_B4F, 17, 25
	.DB POKEMON_MANSION_1F, 16, 8
	.DB POKEMON_MANSION_3F, 9, 1
	.DB ROUTE_23, 44, 9
	.DB ROUTE_23, 70, 19
	.DB ROUTE_23, 90, 8
	.DB VICTORY_ROAD_2F, 2, 5
	.DB VICTORY_ROAD_2F, 7, 26
	.DB UNUSED_MAP_6F, 11, 14
	.DB VIRIDIAN_CITY, 4, 14
	.DB ROUTE_11, 5, 48
	.DB ROUTE_12, 63, 2
	.DB ROUTE_17, 14, 15
	.DB ROUTE_17, 45, 8
	.DB ROUTE_17, 72, 17
	.DB ROUTE_17, 91, 4
	.DB ROUTE_17, 121, 8
	.DB UNDERGROUND_PATH_NORTH_SOUTH, 4, 3
	.DB UNDERGROUND_PATH_NORTH_SOUTH, 34, 4
	.DB UNDERGROUND_PATH_WEST_EAST, 2, 12
	.DB UNDERGROUND_PATH_WEST_EAST, 5, 21
	.DB CELADON_CITY, 15, 48
	.DB ROUTE_25, 1, 10
	.DB MT_MOON_B2F, 9, 33
	.DB SEAFOAM_ISLANDS_B3F, 16, 9
	.DB VERMILION_CITY, 11, 14
	.DB CERULEAN_CITY, 8, 15
	.DB ROUTE_4, 3, 40
; assert_max_table_length MAX_HIDDEN_ITEMS
	.DB -1 ; end

FoundHiddenItemText:
	.DB $17
	.DW $54d0
	.DB $22
	.DB $08
	ld a, (wHiddenEventFunctionArgument) ; item ID
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, FoundHiddenItemText.bagFull
	ld hl, wObtainedHiddenItemsFlags
	ld a, (wHiddenItemOrCoinsIndex)
	ld c, a
	ld b, FLAG_SET
	ld a, $10
	call Predef
	ld a, SFX_GET_ITEM_2
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	jp TextScriptEnd
FoundHiddenItemText.bagFull:
	call WaitForTextScrollButtonPress ; wait for button press
	xor a
	ld (wDoNotWaitForButtonPressAfterDisplayingText), a
	ld hl, HiddenItemBagFullText
	call PrintText
	jp TextScriptEnd

HiddenItemBagFullText:
	.DB $17
	.DW $54e1
	.DB $22
	.DB $50

HiddenCoins:
	ld b, COIN_CASE
	ld a, $1c
	call Predef
	ld a, b
	and a
	ret z
	ld hl, HiddenCoinCoords
	call FindHiddenItemOrCoinsIndex
	ld (wHiddenItemOrCoinsIndex), a
	ld hl, wObtainedHiddenCoinsFlags
	ld a, (wHiddenItemOrCoinsIndex)
	ld c, a
	ld b, FLAG_TEST
	ld a, $10
	call Predef
	ld a, c
	and a
	ret nz
	xor a
	ldh (hUnusedCoinsByte - $FF00), a
	ldh (hCoins - $FF00), a
	ldh (hCoins - $FF00 + 1), a
	ld a, (wHiddenEventFunctionArgument)
	sub COIN
	cp 10
	jr z, HiddenCoins.bcd10
	cp 20
	jr z, HiddenCoins.bcd20
	cp 40
	jr z, HiddenCoins.bcd20 ; should be bcd40
	jr HiddenCoins.bcd100
HiddenCoins.bcd10:
	ld a, $10
	ldh (hCoins - $FF00 + 1), a
	jr HiddenCoins.bcdDone
HiddenCoins.bcd20:
	ld a, $20
	ldh (hCoins - $FF00 + 1), a
	jr HiddenCoins.bcdDone
HiddenCoins.bcd40: ; due to a typo, this is never used
	ld a, $40
	ldh (hCoins - $FF00 + 1), a
	jr HiddenCoins.bcdDone
HiddenCoins.bcd100:
	ld a, $1
	ldh (hCoins - $FF00), a
HiddenCoins.bcdDone:
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2
	ld a, $0b
	call Predef
	ld hl, wObtainedHiddenCoinsFlags
	ld a, (wHiddenItemOrCoinsIndex)
	ld c, a
	ld b, FLAG_SET
	ld a, $10
	call Predef
	call EnableAutoTextBoxDrawing
	ld a, (wPlayerCoins)
	cp $99
	jr nz, HiddenCoins.roomInCoinCase
	ld a, (wPlayerCoins + 1)
	cp $99
	jr nz, HiddenCoins.roomInCoinCase
	ld a, $2c
	jr HiddenCoins.done
HiddenCoins.roomInCoinCase:
	ld a, $2b
HiddenCoins.done:
	jp PrintPredefTextID


HiddenCoinCoords:
; table_width 3
	; map id, x, y
	.DB GAME_CORNER, 8, 0
	.DB GAME_CORNER, 16, 1
	.DB GAME_CORNER, 11, 3
	.DB GAME_CORNER, 14, 3
	.DB GAME_CORNER, 12, 4
	.DB GAME_CORNER, 12, 9
	.DB GAME_CORNER, 15, 9
	.DB GAME_CORNER, 14, 16
	.DB GAME_CORNER, 16, 10
	.DB GAME_CORNER, 7, 11
	.DB GAME_CORNER, 8, 15
	.DB GAME_CORNER, 15, 12
; assert_max_table_length MAX_HIDDEN_COINS
	.DB -1 ; end

FoundHiddenCoinsText:
	.DB $17
	.DW $550b
	.DB $22
	.DB $10
	.DB $50

DroppedHiddenCoinsText:
	.DB $17
	.DW $5523
	.DB $22
	.DB $10
	.DB $17
	.DW $553b
	.DB $22
	.DB $50

FindHiddenItemOrCoinsIndex:
	ld a, (wHiddenEventY)
	ld d, a
	ld a, (wHiddenEventX)
	ld e, a
	ld a, (wCurMap)
	ld b, a
	ld c, -1
FindHiddenItemOrCoinsIndex.loop:
	inc c
	ld a, (HL+)
	cp -1 ; end of the list?
	ret z ; if so, we're done here
	cp b
	jr nz, FindHiddenItemOrCoinsIndex.next1
	ld a, (HL+)
	cp d
	jr nz, FindHiddenItemOrCoinsIndex.next2
	ld a, (HL+)
	cp e
	jr nz, FindHiddenItemOrCoinsIndex.loop
	ld a, c
	ret
FindHiddenItemOrCoinsIndex.next1:
	inc hl
FindHiddenItemOrCoinsIndex.next2:
	inc hl
	jr FindHiddenItemOrCoinsIndex.loop
Itemfinder2End:
