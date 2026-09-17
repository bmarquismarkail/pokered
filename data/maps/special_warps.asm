; Format: (size 2 bytes)
; 00: target map ID
; 01: which dungeon warp in the source map was used
DungeonWarpList:
	.DB SEAFOAM_ISLANDS_B1F, 1
	.DB SEAFOAM_ISLANDS_B1F, 2
	.DB SEAFOAM_ISLANDS_B2F, 1
	.DB SEAFOAM_ISLANDS_B2F, 2
	.DB SEAFOAM_ISLANDS_B3F, 1
	.DB SEAFOAM_ISLANDS_B3F, 2
	.DB SEAFOAM_ISLANDS_B4F, 1
	.DB SEAFOAM_ISLANDS_B4F, 2
	.DB VICTORY_ROAD_2F,     2
	.DB POKEMON_MANSION_1F,  1
	.DB POKEMON_MANSION_1F,  2
	.DB POKEMON_MANSION_2F,  3
	.DB -1 ; end


.MACRO fly_warp
	.ARRAYOUT NAME map_widths INDEX \1 DEFINITION _fly_warp_width
	event_displacement _fly_warp_width, \2, \3
	.DB ((\3) & $01) ;sub-block Y
	.DB ((\2) & $01) ;sub-block X
.ENDM

DungeonWarpData:
	fly_warp SEAFOAM_ISLANDS_B1F, 18,  7
	fly_warp SEAFOAM_ISLANDS_B1F, 23,  7
	fly_warp SEAFOAM_ISLANDS_B2F, 19,  7
	fly_warp SEAFOAM_ISLANDS_B2F, 22,  7
	fly_warp SEAFOAM_ISLANDS_B3F, 18,  7
	fly_warp SEAFOAM_ISLANDS_B3F, 19,  7
	fly_warp SEAFOAM_ISLANDS_B4F,  4, 14
	fly_warp SEAFOAM_ISLANDS_B4F,  5, 14
	fly_warp VICTORY_ROAD_2F,     22, 16
	fly_warp POKEMON_MANSION_1F,  16, 14
	fly_warp POKEMON_MANSION_1F,  16, 14
	fly_warp POKEMON_MANSION_2F,  18, 14


.MACRO special_warp_spec
	.DB \1
	fly_warp \1, \2, \3
	.DB \4
.ENDM

NewGameWarp:
	special_warp_spec REDS_HOUSE_2F, 3, 6, REDS_HOUSE_2
TradeCenterPlayerWarp:
	special_warp_spec TRADE_CENTER,  3, 4, CLUB
TradeCenterFriendWarp:
	special_warp_spec TRADE_CENTER,  6, 4, CLUB
ColosseumPlayerWarp:
	special_warp_spec COLOSSEUM,     3, 4, CLUB
ColosseumFriendWarp:
	special_warp_spec COLOSSEUM,     6, 4, CLUB


.MACRO fly_warp_spec
	.DB \1, 0
	.DW \2
.ENDM

FlyWarpDataPtr:
	fly_warp_spec PALLET_TOWN,     FlyWarpDataPtr.PalletTown
	fly_warp_spec VIRIDIAN_CITY,   FlyWarpDataPtr.ViridianCity
	fly_warp_spec PEWTER_CITY,     FlyWarpDataPtr.PewterCity
	fly_warp_spec CERULEAN_CITY,   FlyWarpDataPtr.CeruleanCity
	fly_warp_spec LAVENDER_TOWN,   FlyWarpDataPtr.LavenderTown
	fly_warp_spec VERMILION_CITY,  FlyWarpDataPtr.VermilionCity
	fly_warp_spec CELADON_CITY,    FlyWarpDataPtr.CeladonCity
	fly_warp_spec FUCHSIA_CITY,    FlyWarpDataPtr.FuchsiaCity
	fly_warp_spec CINNABAR_ISLAND, FlyWarpDataPtr.CinnabarIsland
	fly_warp_spec INDIGO_PLATEAU,  FlyWarpDataPtr.IndigoPlateau
	fly_warp_spec SAFFRON_CITY,    FlyWarpDataPtr.SaffronCity
	fly_warp_spec ROUTE_4,         FlyWarpDataPtr.Route4
	fly_warp_spec ROUTE_10,        FlyWarpDataPtr.Route10

FlyWarpDataPtr.PalletTown:     fly_warp PALLET_TOWN,      5,  6
FlyWarpDataPtr.ViridianCity:   fly_warp VIRIDIAN_CITY,   23, 26
FlyWarpDataPtr.PewterCity:     fly_warp PEWTER_CITY,     13, 26
FlyWarpDataPtr.CeruleanCity:   fly_warp CERULEAN_CITY,   19, 18
FlyWarpDataPtr.LavenderTown:   fly_warp LAVENDER_TOWN,    3,  6
FlyWarpDataPtr.VermilionCity:  fly_warp VERMILION_CITY,  11,  4
FlyWarpDataPtr.CeladonCity:    fly_warp CELADON_CITY,    41, 10
FlyWarpDataPtr.FuchsiaCity:    fly_warp FUCHSIA_CITY,    19, 28
FlyWarpDataPtr.CinnabarIsland: fly_warp CINNABAR_ISLAND, 11, 12
FlyWarpDataPtr.IndigoPlateau:  fly_warp INDIGO_PLATEAU,   9,  6
FlyWarpDataPtr.SaffronCity:    fly_warp SAFFRON_CITY,     9, 30
FlyWarpDataPtr.Route4:         fly_warp ROUTE_4,         11,  6
FlyWarpDataPtr.Route10:        fly_warp ROUTE_10,        11, 20
