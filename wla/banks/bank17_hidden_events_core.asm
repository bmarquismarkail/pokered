; Native WLA-DX form of engine/overworld/hidden_events.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"
IsPlayerOnDungeonWarp:
	xor a
	ld (wWhichDungeonWarp), a
	ld a, (wStatusFlags3)
	bit BIT_ON_DUNGEON_WARP, a
	ret nz
	call ArePlayerCoordsInArray
	ret nc
	ld a, (wCoordIndex)
	ld (wWhichDungeonWarp), a
	ld hl, wStatusFlags3
	set BIT_ON_DUNGEON_WARP, (hl)
	ld hl, wStatusFlags6
	set BIT_DUNGEON_WARP, (hl)
	ret

; if a hidden event was found, stores $00 in [hDidntFindAnyHiddenEvent], else stores $ff
CheckForHiddenEvent:
	ld hl, hItemAlreadyFound
	xor a
	ld (HL+), a ; [hItemAlreadyFound]
	ld (HL+), a ; [hSavedMapTextPtr]
	ld (HL+), a ; [hSavedMapTextPtr + 1]
	ld (hl), a ; [hDidntFindAnyHiddenEvent]
	ld de, $0
	ld hl, HiddenEventMaps
CheckForHiddenEvent.hiddenMapLoop:
	ld a, (HL+)
	ld b, a
	cp $ff
	jr z, CheckForHiddenEvent.noMatch
	ld a, (wCurMap)
	cp b
	jr z, CheckForHiddenEvent.foundMatchingMap
	inc de
	inc de
	jr CheckForHiddenEvent.hiddenMapLoop
CheckForHiddenEvent.foundMatchingMap:
	ld hl, HiddenEventPointers
	add hl, de
	ld a, (HL+)
	ld h, (hl)
	ld l, a
	push hl
	ld hl, wHiddenEventFunctionArgument
	xor a
	ld (HL+), a
	ld (HL+), a
	ld (hl), a
	pop hl
CheckForHiddenEvent.hiddenEventLoop:
	ld a, (HL+)
	cp $ff
	jr z, CheckForHiddenEvent.noMatch
	ld (wHiddenEventY), a
	ld b, a
	ld a, (HL+)
	ld (wHiddenEventX), a
	ld c, a
	call CheckIfCoordsInFrontOfPlayerMatch
	ldh a, (hCoordsInFrontOfPlayerMatch - $FF00)
	and a
	jr z, CheckForHiddenEvent.foundMatchingEvent
	inc hl
	inc hl
	inc hl
	inc hl
	push hl
	ld hl, wHiddenEventIndex
	inc (hl)
	pop hl
	jr CheckForHiddenEvent.hiddenEventLoop
CheckForHiddenEvent.foundMatchingEvent:
	ld a, (HL+)
	ld (wHiddenEventFunctionArgument), a
	ld a, (HL+)
	ld (wHiddenEventFunctionRomBank), a
	ld a, (HL+)
	ld h, (hl)
	ld l, a
	ret
CheckForHiddenEvent.noMatch:
	ld a, $ff
	ldh (hDidntFindAnyHiddenEvent - $FF00), a
	ret

; checks if the coordinates in front of the player's sprite match Y in b and X in c
; [hCoordsInFrontOfPlayerMatch] = $00 if they match, $ff if they don't match
CheckIfCoordsInFrontOfPlayerMatch:
	ld a, (wSpritePlayerStateData1FacingDirection)
	cp SPRITE_FACING_UP
	jr z, CheckIfCoordsInFrontOfPlayerMatch.facingUp
	cp SPRITE_FACING_LEFT
	jr z, CheckIfCoordsInFrontOfPlayerMatch.facingLeft
	cp SPRITE_FACING_RIGHT
	jr z, CheckIfCoordsInFrontOfPlayerMatch.facingRight
; facing down
	ld a, (wYCoord)
	inc a
	jr CheckIfCoordsInFrontOfPlayerMatch.upDownCommon
CheckIfCoordsInFrontOfPlayerMatch.facingUp:
	ld a, (wYCoord)
	dec a
CheckIfCoordsInFrontOfPlayerMatch.upDownCommon:
	cp b
	jr nz, CheckIfCoordsInFrontOfPlayerMatch.didNotMatch
	ld a, (wXCoord)
	cp c
	jr nz, CheckIfCoordsInFrontOfPlayerMatch.didNotMatch
	jr CheckIfCoordsInFrontOfPlayerMatch.matched
CheckIfCoordsInFrontOfPlayerMatch.facingLeft:
	ld a, (wXCoord)
	dec a
	jr CheckIfCoordsInFrontOfPlayerMatch.leftRightCommon
CheckIfCoordsInFrontOfPlayerMatch.facingRight:
	ld a, (wXCoord)
	inc a
CheckIfCoordsInFrontOfPlayerMatch.leftRightCommon:
	cp c
	jr nz, CheckIfCoordsInFrontOfPlayerMatch.didNotMatch
	ld a, (wYCoord)
	cp b
	jr nz, CheckIfCoordsInFrontOfPlayerMatch.didNotMatch
CheckIfCoordsInFrontOfPlayerMatch.matched:
	xor a
	jr CheckIfCoordsInFrontOfPlayerMatch.done
CheckIfCoordsInFrontOfPlayerMatch.didNotMatch:
	ld a, $ff
CheckIfCoordsInFrontOfPlayerMatch.done:
	ldh (hCoordsInFrontOfPlayerMatch - $FF00), a
	ret

; DEF num_hidden_event_maps = 0


HiddenEventMaps:
	.DB REDS_HOUSE_2F
	.DB BLUES_HOUSE
	.DB OAKS_LAB
	.DB VIRIDIAN_POKECENTER
	.DB VIRIDIAN_MART
	.DB VIRIDIAN_SCHOOL_HOUSE
	.DB VIRIDIAN_GYM
	.DB MUSEUM_1F
	.DB PEWTER_GYM
	.DB PEWTER_MART
	.DB PEWTER_POKECENTER
	.DB CERULEAN_POKECENTER
	.DB CERULEAN_GYM
	.DB CERULEAN_MART
	.DB LAVENDER_POKECENTER
	.DB VERMILION_POKECENTER
	.DB VERMILION_GYM
	.DB CELADON_MANSION_2F
	.DB CELADON_POKECENTER
	.DB CELADON_GYM
	.DB GAME_CORNER
	.DB CELADON_HOTEL
	.DB FUCHSIA_POKECENTER
	.DB FUCHSIA_GYM
	.DB CINNABAR_GYM
	.DB CINNABAR_POKECENTER
	.DB SAFFRON_GYM
	.DB MT_MOON_POKECENTER
	.DB ROCK_TUNNEL_POKECENTER
	.DB TRADE_CENTER
	.DB COLOSSEUM
	.DB VIRIDIAN_FOREST
	.DB MT_MOON_B2F
	.DB INDIGO_PLATEAU
	.DB ROUTE_25
	.DB ROUTE_9
	.DB SS_ANNE_KITCHEN
	.DB SS_ANNE_B1F_ROOMS
	.DB ROCKET_HIDEOUT_B1F
	.DB ROCKET_HIDEOUT_B3F
	.DB ROCKET_HIDEOUT_B4F
	.DB SAFFRON_POKECENTER
	.DB POKEMON_TOWER_5F
	.DB ROUTE_13
	.DB SAFARI_ZONE_GATE
	.DB SAFARI_ZONE_WEST
	.DB SILPH_CO_5F
	.DB SILPH_CO_9F
	.DB COPYCATS_HOUSE_2F
	.DB CERULEAN_CAVE_1F
	.DB CERULEAN_CAVE_B1F
	.DB POWER_PLANT
	.DB SEAFOAM_ISLANDS_B2F
	.DB SEAFOAM_ISLANDS_B4F
	.DB POKEMON_MANSION_1F
	.DB POKEMON_MANSION_3F
	.DB ROUTE_23
	.DB VICTORY_ROAD_2F
	.DB UNUSED_MAP_6F
	.DB BILLS_HOUSE
	.DB VIRIDIAN_CITY
	.DB SAFARI_ZONE_WEST_REST_HOUSE
	.DB SAFARI_ZONE_EAST_REST_HOUSE
	.DB SAFARI_ZONE_NORTH_REST_HOUSE
	.DB ROUTE_15_GATE_2F
	.DB MR_FUJIS_HOUSE
	.DB CELADON_MANSION_ROOF_HOUSE
	.DB FIGHTING_DOJO
	.DB ROUTE_10
	.DB INDIGO_PLATEAU_LOBBY
	.DB CINNABAR_LAB_FOSSIL_ROOM
	.DB BIKE_SHOP
	.DB ROUTE_11
	.DB ROUTE_12
	.DB POKEMON_MANSION_2F
	.DB POKEMON_MANSION_B1F
	.DB SILPH_CO_11F
	.DB ROUTE_17
	.DB UNDERGROUND_PATH_NORTH_SOUTH
	.DB UNDERGROUND_PATH_WEST_EAST
	.DB CELADON_CITY
	.DB SEAFOAM_ISLANDS_B3F
	.DB VERMILION_CITY
	.DB CERULEAN_CITY
	.DB ROUTE_4
	.DB -1 ; end

HiddenEventPointers:
; each of these pointers is for the corresponding map in HiddenEventMaps
	.DW HiddenEventsFor_REDS_HOUSE_2F
	.DW HiddenEventsFor_BLUES_HOUSE
	.DW HiddenEventsFor_OAKS_LAB
	.DW HiddenEventsFor_VIRIDIAN_POKECENTER
	.DW HiddenEventsFor_VIRIDIAN_MART
	.DW HiddenEventsFor_VIRIDIAN_SCHOOL_HOUSE
	.DW HiddenEventsFor_VIRIDIAN_GYM
	.DW HiddenEventsFor_MUSEUM_1F
	.DW HiddenEventsFor_PEWTER_GYM
	.DW HiddenEventsFor_PEWTER_MART
	.DW HiddenEventsFor_PEWTER_POKECENTER
	.DW HiddenEventsFor_CERULEAN_POKECENTER
	.DW HiddenEventsFor_CERULEAN_GYM
	.DW HiddenEventsFor_CERULEAN_MART
	.DW HiddenEventsFor_LAVENDER_POKECENTER
	.DW HiddenEventsFor_VERMILION_POKECENTER
	.DW HiddenEventsFor_VERMILION_GYM
	.DW HiddenEventsFor_CELADON_MANSION_2F
	.DW HiddenEventsFor_CELADON_POKECENTER
	.DW HiddenEventsFor_CELADON_GYM
	.DW HiddenEventsFor_GAME_CORNER
	.DW HiddenEventsFor_CELADON_HOTEL
	.DW HiddenEventsFor_FUCHSIA_POKECENTER
	.DW HiddenEventsFor_FUCHSIA_GYM
	.DW HiddenEventsFor_CINNABAR_GYM
	.DW HiddenEventsFor_CINNABAR_POKECENTER
	.DW HiddenEventsFor_SAFFRON_GYM
	.DW HiddenEventsFor_MT_MOON_POKECENTER
	.DW HiddenEventsFor_ROCK_TUNNEL_POKECENTER
	.DW HiddenEventsFor_TRADE_CENTER
	.DW HiddenEventsFor_COLOSSEUM
	.DW HiddenEventsFor_VIRIDIAN_FOREST
	.DW HiddenEventsFor_MT_MOON_B2F
	.DW HiddenEventsFor_INDIGO_PLATEAU
	.DW HiddenEventsFor_ROUTE_25
	.DW HiddenEventsFor_ROUTE_9
	.DW HiddenEventsFor_SS_ANNE_KITCHEN
	.DW HiddenEventsFor_SS_ANNE_B1F_ROOMS
	.DW HiddenEventsFor_ROCKET_HIDEOUT_B1F
	.DW HiddenEventsFor_ROCKET_HIDEOUT_B3F
	.DW HiddenEventsFor_ROCKET_HIDEOUT_B4F
	.DW HiddenEventsFor_SAFFRON_POKECENTER
	.DW HiddenEventsFor_POKEMON_TOWER_5F
	.DW HiddenEventsFor_ROUTE_13
	.DW HiddenEventsFor_SAFARI_ZONE_GATE
	.DW HiddenEventsFor_SAFARI_ZONE_WEST
	.DW HiddenEventsFor_SILPH_CO_5F
	.DW HiddenEventsFor_SILPH_CO_9F
	.DW HiddenEventsFor_COPYCATS_HOUSE_2F
	.DW HiddenEventsFor_CERULEAN_CAVE_1F
	.DW HiddenEventsFor_CERULEAN_CAVE_B1F
	.DW HiddenEventsFor_POWER_PLANT
	.DW HiddenEventsFor_SEAFOAM_ISLANDS_B2F
	.DW HiddenEventsFor_SEAFOAM_ISLANDS_B4F
	.DW HiddenEventsFor_POKEMON_MANSION_1F
	.DW HiddenEventsFor_POKEMON_MANSION_3F
	.DW HiddenEventsFor_ROUTE_23
	.DW HiddenEventsFor_VICTORY_ROAD_2F
	.DW HiddenEventsFor_UNUSED_MAP_6F
	.DW HiddenEventsFor_BILLS_HOUSE
	.DW HiddenEventsFor_VIRIDIAN_CITY
	.DW HiddenEventsFor_SAFARI_ZONE_WEST_REST_HOUSE
	.DW HiddenEventsFor_SAFARI_ZONE_EAST_REST_HOUSE
	.DW HiddenEventsFor_SAFARI_ZONE_NORTH_REST_HOUSE
	.DW HiddenEventsFor_ROUTE_15_GATE_2F
	.DW HiddenEventsFor_MR_FUJIS_HOUSE
	.DW HiddenEventsFor_CELADON_MANSION_ROOF_HOUSE
	.DW HiddenEventsFor_FIGHTING_DOJO
	.DW HiddenEventsFor_ROUTE_10
	.DW HiddenEventsFor_INDIGO_PLATEAU_LOBBY
	.DW HiddenEventsFor_CINNABAR_LAB_FOSSIL_ROOM
	.DW HiddenEventsFor_BIKE_SHOP
	.DW HiddenEventsFor_ROUTE_11
	.DW HiddenEventsFor_ROUTE_12
	.DW HiddenEventsFor_POKEMON_MANSION_2F
	.DW HiddenEventsFor_POKEMON_MANSION_B1F
	.DW HiddenEventsFor_SILPH_CO_11F
	.DW HiddenEventsFor_ROUTE_17
	.DW HiddenEventsFor_UNDERGROUND_PATH_NORTH_SOUTH
	.DW HiddenEventsFor_UNDERGROUND_PATH_WEST_EAST
	.DW HiddenEventsFor_CELADON_CITY
	.DW HiddenEventsFor_SEAFOAM_ISLANDS_B3F
	.DW HiddenEventsFor_VERMILION_CITY
	.DW HiddenEventsFor_CERULEAN_CITY
	.DW HiddenEventsFor_ROUTE_4




; Some hidden events use SPRITE_FACING_* values,
; but these do not actually prevent the player
; from interacting with them in any direction.
.DEFINE ANY_FACING $d0

HiddenEventsFor_TRADE_CENTER:
	.DB 4, 5, ANY_FACING
	.DB $08
	.DW $5845
	.DB 4, 4, ANY_FACING
	.DB $08
	.DW $5825
	.DB -1 ; end

HiddenEventsFor_COLOSSEUM:
	.DB 4, 5, ANY_FACING
	.DB $08
	.DW $5845
	.DB 4, 4, ANY_FACING
	.DB $08
	.DW $5825
	.DB -1 ; end

HiddenEventsFor_REDS_HOUSE_2F:
	.DB 1, 0, SPRITE_FACING_UP
	.DB $17
	.DW $5b86
	.DB 5, 3, ANY_FACING
	.DB $17
	.DW $5b79
	.DB -1 ; end

HiddenEventsFor_BLUES_HOUSE:
	.DB 1, 0, SPRITE_FACING_UP
	.DB $18
	.DW $6509
	.DB 1, 1, SPRITE_FACING_UP
	.DB $18
	.DW $6509
	.DB 1, 7, SPRITE_FACING_UP
	.DB $18
	.DW $6509
	.DB -1 ; end

HiddenEventsFor_OAKS_LAB:
	.DB 0, 4, SPRITE_FACING_UP
	.DB $07
	.DW $6958
	.DB 0, 5, SPRITE_FACING_UP
	.DB $07
	.DW $6965
	.DB 1, 0, SPRITE_FACING_UP
	.DB $07
	.DW $6caf
	.DB 1, 1, SPRITE_FACING_UP
	.DB $07
	.DW $6caf
	.DB -1 ; end

HiddenEventsFor_VIRIDIAN_POKECENTER:
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_VIRIDIAN_MART:
	.DB -1 ; end

HiddenEventsFor_VIRIDIAN_SCHOOL_HOUSE:
	.DB 4, 3, $20
	.DB $14
	.DW $6996
	.DB 0, 3, $21
	.DB $17
	.DW $5c1a
	.DB -1 ; end

HiddenEventsFor_VIRIDIAN_GYM:
	.DB 15, 15, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB 15, 18, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB -1 ; end

HiddenEventsFor_MUSEUM_1F:
	.DB 3, 2, SPRITE_FACING_UP
	.DB $17
	.DW $5bad
	.DB 6, 2, SPRITE_FACING_UP
	.DB $17
	.DW $5bc3
	.DB -1 ; end

HiddenEventsFor_PEWTER_GYM:
	.DB 10, 3, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB 10, 6, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB -1 ; end

HiddenEventsFor_PEWTER_MART:
	.DB -1 ; end

HiddenEventsFor_PEWTER_POKECENTER:
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_CERULEAN_POKECENTER:
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_CERULEAN_GYM:
	.DB 11, 3, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB 11, 6, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB -1 ; end

HiddenEventsFor_CERULEAN_MART:
	.DB -1 ; end

HiddenEventsFor_LAVENDER_POKECENTER:
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_VERMILION_POKECENTER:
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB 4, 0, SPRITE_FACING_UP
	.DB $18
	.DW $645d
	.DB -1 ; end

HiddenEventsFor_VERMILION_GYM:
	.DB 14, 3, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB 14, 6, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB 1, 6, SPRITE_FACING_DOWN
	.DB $17
	.DW $5def
	; GymTrashScript argument: [wGymTrashCanIndex]
	.DB 7, 1, 0
	.DB $17
	.DW $5dfc
	.DB 9, 1, 1
	.DB $17
	.DW $5dfc
	.DB 11, 1, 2
	.DB $17
	.DW $5dfc
	.DB 7, 3, 3
	.DB $17
	.DW $5dfc
	.DB 9, 3, 4
	.DB $17
	.DW $5dfc
	.DB 11, 3, 5
	.DB $17
	.DW $5dfc
	.DB 7, 5, 6
	.DB $17
	.DW $5dfc
	.DB 9, 5, 7
	.DB $17
	.DW $5dfc
	.DB 11, 5, 8
	.DB $17
	.DW $5dfc
	.DB 7, 7, 9
	.DB $17
	.DW $5dfc
	.DB 9, 7, 10
	.DB $17
	.DW $5dfc
	.DB 11, 7, 11
	.DB $17
	.DW $5dfc
	.DB 7, 9, 12
	.DB $17
	.DW $5dfc
	.DB 9, 9, 13
	.DB $17
	.DW $5dfc
	.DB 11, 9, 14
	.DB $17
	.DW $5dfc
	.DB -1 ; end

HiddenEventsFor_CELADON_MANSION_2F:
	.DB 5, 0, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_CELADON_POKECENTER:
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_CELADON_GYM:
	.DB 15, 3, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB 15, 6, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB -1 ; end

HiddenEventsFor_GAME_CORNER:
	.DB 15, 18, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 14, 18, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 13, 18, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 12, 18, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 11, 18, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 10, 18, SLOTS_SOMEONESKEYS
	.DB $0d
	.DW $7e2d
	.DB 10, 13, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 11, 13, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 12, 13, SLOTS_OUTTOLUNCH
	.DB $0d
	.DW $7e2d
	.DB 13, 13, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 14, 13, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 15, 13, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 15, 12, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 14, 12, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 13, 12, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 12, 12, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 11, 12, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 10, 12, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 10, 7, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 11, 7, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 12, 7, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 13, 7, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 14, 7, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 15, 7, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 15, 6, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 14, 6, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 13, 6, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 12, 6, SLOTS_OUTOFORDER
	.DB $0d
	.DW $7e2d
	.DB 11, 6, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 10, 6, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 10, 1, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 11, 1, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 12, 1, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 13, 1, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 14, 1, ANY_FACING
	.DB $0d
	.DW $7e2d
	.DB 15, 1, ANY_FACING
	.DB $0d
	.DW $7e2d
	; HiddenCoins argument: COIN + <number of coins>
	.DB 8, 0, COIN + 10
	.DB $1d
	.DW $6799
	.DB 16, 1, COIN + 10
	.DB $1d
	.DW $6799
	.DB 11, 3, COIN + 20
	.DB $1d
	.DW $6799
	.DB 14, 3, COIN + 10
	.DB $1d
	.DW $6799
	.DB 12, 4, COIN + 10
	.DB $1d
	.DW $6799
	.DB 12, 9, COIN + 20
	.DB $1d
	.DW $6799
	.DB 15, 9, COIN + 10
	.DB $1d
	.DW $6799
	.DB 14, 16, COIN + 10
	.DB $1d
	.DW $6799
	.DB 16, 10, COIN + 10
	.DB $1d
	.DW $6799
	.DB 7, 11, COIN + 40
	.DB $1d
	.DW $6799
	.DB 8, 15, COIN + 100
	.DB $1d
	.DW $6799
	.DB 15, 12, COIN + 10
	.DB $1d
	.DW $6799
	.DB -1 ; end

HiddenEventsFor_CELADON_HOTEL:
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB -1 ; end

HiddenEventsFor_FUCHSIA_POKECENTER:
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB 4, 0, SPRITE_FACING_UP
	.DB $18
	.DW $645d
	.DB -1 ; end

HiddenEventsFor_FUCHSIA_GYM:
	.DB 15, 3, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB 15, 6, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB -1 ; end

HiddenEventsFor_CINNABAR_GYM:
	.DB 13, 17, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	; PrintCinnabarQuiz argument: ([hGymGateAnswer] << 4) | [hGymGateIndex]
	.DB 7, 15, (FALSE << 4) | 1
	.DB $07
	.DW $6a17
	.DB 1, 10, (TRUE  << 4) | 2
	.DB $07
	.DW $6a17
	.DB 7, 9, (TRUE  << 4) | 3
	.DB $07
	.DW $6a17
	.DB 13, 9, (TRUE  << 4) | 4
	.DB $07
	.DW $6a17
	.DB 13, 1, (FALSE << 4) | 5
	.DB $07
	.DW $6a17
	.DB 7, 1, (TRUE  << 4) | 6
	.DB $07
	.DW $6a17
	.DB -1 ; end

HiddenEventsFor_CINNABAR_POKECENTER:
	.DB 4, 0, SPRITE_FACING_UP
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_SAFFRON_GYM:
	.DB 15, 9, SPRITE_FACING_UP
	.DB $18
	.DW $6419
	.DB -1 ; end

HiddenEventsFor_MT_MOON_POKECENTER:
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_ROCK_TUNNEL_POKECENTER:
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_VIRIDIAN_FOREST:
	.DB 18, 1, POTION
	.DB $1d
	.DW $6688
	.DB 42, 16, ANTIDOTE
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_MT_MOON_B2F:
	.DB 12, 18, MOON_STONE
	.DB $1d
	.DW $6688
	.DB 9, 33, ETHER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_INDIGO_PLATEAU:
	.DB 13, 8, $ff
	.DB $14
	.DW $6a2f ; inaccessible
	.DB 13, 11, SPRITE_FACING_DOWN
	.DB $14
	.DW $6a2f ; inaccessible
	.DB -1 ; end

HiddenEventsFor_ROUTE_25:
	.DB 3, 38, ETHER
	.DB $1d
	.DW $6688
	.DB 1, 10, ELIXER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_ROUTE_9:
	.DB 7, 14, ETHER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SS_ANNE_KITCHEN:
	.DB 5, 13, SPRITE_FACING_DOWN
	.DB $17
	.DW $5def
	.DB 7, 13, SPRITE_FACING_DOWN
	.DB $17
	.DW $5def
	.DB 9, 13, GREAT_BALL
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SS_ANNE_B1F_ROOMS:
	.DB 1, 3, HYPER_POTION
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_ROUTE_10:
	.DB 17, 9, SUPER_POTION
	.DB $1d
	.DW $6688
	.DB 53, 16, MAX_ETHER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_ROCKET_HIDEOUT_B1F:
	.DB 15, 21, PP_UP
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_ROCKET_HIDEOUT_B3F:
	.DB 17, 27, NUGGET
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_ROCKET_HIDEOUT_B4F:
	.DB 1, 25, SUPER_POTION
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SAFFRON_POKECENTER:
	.DB 4, 0, SPRITE_FACING_UP
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_POKEMON_TOWER_5F:
	.DB 12, 4, ELIXER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_ROUTE_13:
	.DB 14, 1, PP_UP
	.DB $1d
	.DW $6688
	.DB 13, 16, CALCIUM
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SAFARI_ZONE_GATE:
	.DB 1, 10, NUGGET
	.DB $1d
	.DW $6688 ; inaccessible
	.DB -1 ; end

HiddenEventsFor_SAFARI_ZONE_WEST:
	.DB 5, 6, REVIVE
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SILPH_CO_5F:
	.DB 3, 12, ELIXER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SILPH_CO_9F:
	.DB 15, 2, MAX_POTION
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_COPYCATS_HOUSE_2F:
	.DB 1, 1, NUGGET
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_CERULEAN_CAVE_1F:
	.DB 11, 14, RARE_CANDY
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_CERULEAN_CAVE_B1F:
	.DB 3, 27, ULTRA_BALL
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_POWER_PLANT:
	.DB 16, 17, MAX_ELIXER
	.DB $1d
	.DW $6688
	.DB 1, 12, PP_UP
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SEAFOAM_ISLANDS_B2F:
	.DB 15, 15, NUGGET
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SEAFOAM_ISLANDS_B4F:
	.DB 17, 25, ULTRA_BALL
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_POKEMON_MANSION_1F:
	.DB 16, 8, MOON_STONE
	.DB $1d
	.DW $6688
	.DB 5, 2, SPRITE_FACING_UP
	.DB $11
	.DW $4316
	.DB -1 ; end

HiddenEventsFor_POKEMON_MANSION_2F:
	.DB 11, 2, SPRITE_FACING_UP
	.DB $14
	.DW $6037
	.DB -1 ; end

HiddenEventsFor_POKEMON_MANSION_3F:
	.DB 9, 1, MAX_REVIVE
	.DB $1d
	.DW $6688
	.DB 5, 10, SPRITE_FACING_UP
	.DB $14
	.DW $627a
	.DB -1 ; end

HiddenEventsFor_POKEMON_MANSION_B1F:
	.DB 9, 1, RARE_CANDY
	.DB $1d
	.DW $6688
	.DB 3, 20, SPRITE_FACING_UP
	.DB $14
	.DW $6420
	.DB 25, 18, SPRITE_FACING_UP
	.DB $14
	.DW $6420
	.DB -1 ; end

HiddenEventsFor_ROUTE_23:
	.DB 44, 9, FULL_RESTORE
	.DB $1d
	.DW $6688
	.DB 70, 19, ULTRA_BALL
	.DB $1d
	.DW $6688
	.DB 90, 8, MAX_ETHER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_VICTORY_ROAD_2F:
	.DB 2, 5, ULTRA_BALL
	.DB $1d
	.DW $6688
	.DB 7, 26, FULL_RESTORE
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_UNUSED_MAP_6F:
	.DB 11, 14, MAX_ELIXER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_BILLS_HOUSE:
	.DB 4, 1, SPRITE_FACING_UP
	.DB $07
	.DW $6b6e
	.DB -1 ; end

HiddenEventsFor_VIRIDIAN_CITY:
	.DB 4, 14, POTION
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SAFARI_ZONE_WEST_REST_HOUSE:
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_SAFARI_ZONE_EAST_REST_HOUSE:
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_SAFARI_ZONE_NORTH_REST_HOUSE:
	.DB 4, 0, SPRITE_FACING_LEFT
	.DB $18
	.DW $645d
	.DB 3, 13, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_ROUTE_15_GATE_2F:
	.DB 2, 1, SPRITE_FACING_UP
	.DB $17
	.DW $5b8f
	.DB -1 ; end

HiddenEventsFor_MR_FUJIS_HOUSE:
	.DB 1, 0, SPRITE_FACING_DOWN
	.DB $07
	.DW $6b60
	.DB 1, 1, SPRITE_FACING_DOWN
	.DB $07
	.DW $6b60
	.DB 1, 7, SPRITE_FACING_DOWN
	.DB $07
	.DW $6b60
	.DB -1 ; end

HiddenEventsFor_CELADON_MANSION_ROOF_HOUSE:
	.DB 0, 3, $34
	.DB $17
	.DW $5c1a
	.DB 0, 4, $34
	.DB $17
	.DW $5c1a
	.DB 4, 3, $35
	.DB $14
	.DW $6996
	.DB -1 ; end

HiddenEventsFor_FIGHTING_DOJO:
	.DB 9, 3, SPRITE_FACING_UP
	.DB $14
	.DW $6a22
	.DB 9, 6, SPRITE_FACING_UP
	.DB $14
	.DW $6a22
	.DB 0, 4, SPRITE_FACING_UP
	.DB $14
	.DW $6a08
	.DB 0, 5, SPRITE_FACING_UP
	.DB $14
	.DW $6a15
	.DB -1 ; end

HiddenEventsFor_INDIGO_PLATEAU_LOBBY:
	.DB 7, 15, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_CINNABAR_LAB_FOSSIL_ROOM:
	.DB 4, 0, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB 4, 2, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_BIKE_SHOP:
	.DB 0, 1, ANY_FACING
	.DB $07
	.DW $694b
	.DB 1, 2, ANY_FACING
	.DB $07
	.DW $694b
	.DB 2, 1, ANY_FACING
	.DB $07
	.DW $694b
	.DB 2, 3, ANY_FACING
	.DB $07
	.DW $694b
	.DB 4, 0, ANY_FACING
	.DB $07
	.DW $694b
	.DB 5, 1, ANY_FACING
	.DB $07
	.DW $694b
	.DB -1 ; end

HiddenEventsFor_ROUTE_11:
	.DB 5, 48, ESCAPE_ROPE
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_ROUTE_12:
	.DB 63, 2, HYPER_POTION
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SILPH_CO_11F:
	.DB 12, 10, SPRITE_FACING_UP
	.DB $18
	.DW $6516
	.DB -1 ; end

HiddenEventsFor_ROUTE_17:
	.DB 14, 15, RARE_CANDY
	.DB $1d
	.DW $6688
	.DB 45, 8, FULL_RESTORE
	.DB $1d
	.DW $6688
	.DB 72, 17, PP_UP
	.DB $1d
	.DW $6688
	.DB 91, 4, MAX_REVIVE
	.DB $1d
	.DW $6688
	.DB 121, 8, MAX_ELIXER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_UNDERGROUND_PATH_NORTH_SOUTH:
	.DB 4, 3, FULL_RESTORE
	.DB $1d
	.DW $6688
	.DB 34, 4, X_SPECIAL
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_UNDERGROUND_PATH_WEST_EAST:
	.DB 2, 12, NUGGET
	.DB $1d
	.DW $6688
	.DB 5, 21, ELIXER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_CELADON_CITY:
	.DB 15, 48, PP_UP
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_SEAFOAM_ISLANDS_B3F:
	.DB 16, 9, MAX_ELIXER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_VERMILION_CITY:
	.DB 11, 14, MAX_ETHER
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_CERULEAN_CITY:
	.DB 8, 15, RARE_CANDY
	.DB $1d
	.DW $6688
	.DB -1 ; end

HiddenEventsFor_ROUTE_4:
	.DB 3, 40, GREAT_BALL
	.DB $1d
	.DW $6688
	.DB -1 ; end
HiddenEventsCoreEnd:
