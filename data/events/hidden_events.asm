.DEFINE num_hidden_event_maps 0

.MACRO hidden_event_map
	.DB \1 ; map id
	.REDEFINE num_hidden_event_maps num_hidden_event_maps + (1)
.ENDM

HiddenEventMaps:
	hidden_event_map REDS_HOUSE_2F
	hidden_event_map BLUES_HOUSE
	hidden_event_map OAKS_LAB
	hidden_event_map VIRIDIAN_POKECENTER
	hidden_event_map VIRIDIAN_MART
	hidden_event_map VIRIDIAN_SCHOOL_HOUSE
	hidden_event_map VIRIDIAN_GYM
	hidden_event_map MUSEUM_1F
	hidden_event_map PEWTER_GYM
	hidden_event_map PEWTER_MART
	hidden_event_map PEWTER_POKECENTER
	hidden_event_map CERULEAN_POKECENTER
	hidden_event_map CERULEAN_GYM
	hidden_event_map CERULEAN_MART
	hidden_event_map LAVENDER_POKECENTER
	hidden_event_map VERMILION_POKECENTER
	hidden_event_map VERMILION_GYM
	hidden_event_map CELADON_MANSION_2F
	hidden_event_map CELADON_POKECENTER
	hidden_event_map CELADON_GYM
	hidden_event_map GAME_CORNER
	hidden_event_map CELADON_HOTEL
	hidden_event_map FUCHSIA_POKECENTER
	hidden_event_map FUCHSIA_GYM
	hidden_event_map CINNABAR_GYM
	hidden_event_map CINNABAR_POKECENTER
	hidden_event_map SAFFRON_GYM
	hidden_event_map MT_MOON_POKECENTER
	hidden_event_map ROCK_TUNNEL_POKECENTER
	hidden_event_map TRADE_CENTER
	hidden_event_map COLOSSEUM
	hidden_event_map VIRIDIAN_FOREST
	hidden_event_map MT_MOON_B2F
	hidden_event_map INDIGO_PLATEAU
	hidden_event_map ROUTE_25
	hidden_event_map ROUTE_9
	hidden_event_map SS_ANNE_KITCHEN
	hidden_event_map SS_ANNE_B1F_ROOMS
	hidden_event_map ROCKET_HIDEOUT_B1F
	hidden_event_map ROCKET_HIDEOUT_B3F
	hidden_event_map ROCKET_HIDEOUT_B4F
	hidden_event_map SAFFRON_POKECENTER
	hidden_event_map POKEMON_TOWER_5F
	hidden_event_map ROUTE_13
	hidden_event_map SAFARI_ZONE_GATE
	hidden_event_map SAFARI_ZONE_WEST
	hidden_event_map SILPH_CO_5F
	hidden_event_map SILPH_CO_9F
	hidden_event_map COPYCATS_HOUSE_2F
	hidden_event_map CERULEAN_CAVE_1F
	hidden_event_map CERULEAN_CAVE_B1F
	hidden_event_map POWER_PLANT
	hidden_event_map SEAFOAM_ISLANDS_B2F
	hidden_event_map SEAFOAM_ISLANDS_B4F
	hidden_event_map POKEMON_MANSION_1F
	hidden_event_map POKEMON_MANSION_3F
	hidden_event_map ROUTE_23
	hidden_event_map VICTORY_ROAD_2F
	hidden_event_map UNUSED_MAP_6F
	hidden_event_map BILLS_HOUSE
	hidden_event_map VIRIDIAN_CITY
	hidden_event_map SAFARI_ZONE_WEST_REST_HOUSE
	hidden_event_map SAFARI_ZONE_EAST_REST_HOUSE
	hidden_event_map SAFARI_ZONE_NORTH_REST_HOUSE
	hidden_event_map ROUTE_15_GATE_2F
	hidden_event_map MR_FUJIS_HOUSE
	hidden_event_map CELADON_MANSION_ROOF_HOUSE
	hidden_event_map FIGHTING_DOJO
	hidden_event_map ROUTE_10
	hidden_event_map INDIGO_PLATEAU_LOBBY
	hidden_event_map CINNABAR_LAB_FOSSIL_ROOM
	hidden_event_map BIKE_SHOP
	hidden_event_map ROUTE_11
	hidden_event_map ROUTE_12
	hidden_event_map POKEMON_MANSION_2F
	hidden_event_map POKEMON_MANSION_B1F
	hidden_event_map SILPH_CO_11F
	hidden_event_map ROUTE_17
	hidden_event_map UNDERGROUND_PATH_NORTH_SOUTH
	hidden_event_map UNDERGROUND_PATH_WEST_EAST
	hidden_event_map CELADON_CITY
	hidden_event_map SEAFOAM_ISLANDS_B3F
	hidden_event_map VERMILION_CITY
	hidden_event_map CERULEAN_CITY
	hidden_event_map ROUTE_4
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

.MACRO hidden_events_for
	; The qualified label is explicit at each call site for WLA.
.ENDM

.MACRO hidden_event
	.DB \2 ; y coord
	.DB \1 ; x coord
	.DB \4 ; function argument
	dba \3 ; event function
.ENDM

.MACRO hidden_text_predef
	.DB \2 ; y coord
	.DB \1 ; x coord
	db_tx_pre \4 ; text id
	dba \3 ; event function
.ENDM

; Some hidden events use SPRITE_FACING_* values,
; but these do not actually prevent the player
; from interacting with them in any direction.
.DEFINE ANY_FACING $d0

	HiddenEventsFor_TRADE_CENTER:

	hidden_events_for TRADE_CENTER
	hidden_event  5,  4, CableClubRightGameboy, ANY_FACING
	hidden_event  4,  4, CableClubLeftGameboy, ANY_FACING
	.DB -1 ; end

	HiddenEventsFor_COLOSSEUM:

	hidden_events_for COLOSSEUM
	hidden_event  5,  4, CableClubRightGameboy, ANY_FACING
	hidden_event  4,  4, CableClubLeftGameboy, ANY_FACING
	.DB -1 ; end

	HiddenEventsFor_REDS_HOUSE_2F:

	hidden_events_for REDS_HOUSE_2F
	hidden_event  0,  1, OpenRedsPC, SPRITE_FACING_UP
	hidden_event  3,  5, PrintRedSNESText, ANY_FACING
	.DB -1 ; end

	HiddenEventsFor_BLUES_HOUSE:

	hidden_events_for BLUES_HOUSE
	hidden_event  0,  1, PrintBookcaseText, SPRITE_FACING_UP
	hidden_event  1,  1, PrintBookcaseText, SPRITE_FACING_UP
	hidden_event  7,  1, PrintBookcaseText, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_OAKS_LAB:

	hidden_events_for OAKS_LAB
	hidden_event  4,  0, DisplayOakLabLeftPoster, SPRITE_FACING_UP
	hidden_event  5,  0, DisplayOakLabRightPoster, SPRITE_FACING_UP
	hidden_event  0,  1, DisplayOakLabEmailText, SPRITE_FACING_UP
	hidden_event  1,  1, DisplayOakLabEmailText, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_VIRIDIAN_POKECENTER:

	hidden_events_for VIRIDIAN_POKECENTER
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_VIRIDIAN_MART:

	hidden_events_for VIRIDIAN_MART
	.DB -1 ; end

	HiddenEventsFor_VIRIDIAN_SCHOOL_HOUSE:

	hidden_events_for VIRIDIAN_SCHOOL_HOUSE
	hidden_text_predef  3,  4, PrintNotebookText, ViridianSchoolNotebook
	hidden_text_predef  3,  0, PrintBlackboardLinkCableText, ViridianSchoolBlackboard
	.DB -1 ; end

	HiddenEventsFor_VIRIDIAN_GYM:

	hidden_events_for VIRIDIAN_GYM
	hidden_event 15, 15, GymStatues, SPRITE_FACING_UP
	hidden_event 18, 15, GymStatues, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_MUSEUM_1F:

	hidden_events_for MUSEUM_1F
	hidden_event  2,  3, AerodactylFossil, SPRITE_FACING_UP
	hidden_event  2,  6, KabutopsFossil, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_PEWTER_GYM:

	hidden_events_for PEWTER_GYM
	hidden_event  3, 10, GymStatues, SPRITE_FACING_UP
	hidden_event  6, 10, GymStatues, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_PEWTER_MART:

	hidden_events_for PEWTER_MART
	.DB -1 ; end

	HiddenEventsFor_PEWTER_POKECENTER:

	hidden_events_for PEWTER_POKECENTER
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_CERULEAN_POKECENTER:

	hidden_events_for CERULEAN_POKECENTER
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_CERULEAN_GYM:

	hidden_events_for CERULEAN_GYM
	hidden_event  3, 11, GymStatues, SPRITE_FACING_UP
	hidden_event  6, 11, GymStatues, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_CERULEAN_MART:

	hidden_events_for CERULEAN_MART
	.DB -1 ; end

	HiddenEventsFor_LAVENDER_POKECENTER:

	hidden_events_for LAVENDER_POKECENTER
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_VERMILION_POKECENTER:

	hidden_events_for VERMILION_POKECENTER
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_VERMILION_GYM:

	hidden_events_for VERMILION_GYM
	hidden_event  3, 14, GymStatues, SPRITE_FACING_UP
	hidden_event  6, 14, GymStatues, SPRITE_FACING_UP
	hidden_event  6,  1, PrintTrashText, SPRITE_FACING_DOWN
	; GymTrashScript argument: [wGymTrashCanIndex]
	hidden_event  1,  7, GymTrashScript,  0
	hidden_event  1,  9, GymTrashScript,  1
	hidden_event  1, 11, GymTrashScript,  2
	hidden_event  3,  7, GymTrashScript,  3
	hidden_event  3,  9, GymTrashScript,  4
	hidden_event  3, 11, GymTrashScript,  5
	hidden_event  5,  7, GymTrashScript,  6
	hidden_event  5,  9, GymTrashScript,  7
	hidden_event  5, 11, GymTrashScript,  8
	hidden_event  7,  7, GymTrashScript,  9
	hidden_event  7,  9, GymTrashScript, 10
	hidden_event  7, 11, GymTrashScript, 11
	hidden_event  9,  7, GymTrashScript, 12
	hidden_event  9,  9, GymTrashScript, 13
	hidden_event  9, 11, GymTrashScript, 14
	.DB -1 ; end

	HiddenEventsFor_CELADON_MANSION_2F:

	hidden_events_for CELADON_MANSION_2F
	hidden_event  0,  5, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_CELADON_POKECENTER:

	hidden_events_for CELADON_POKECENTER
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_CELADON_GYM:

	hidden_events_for CELADON_GYM
	hidden_event  3, 15, GymStatues, SPRITE_FACING_UP
	hidden_event  6, 15, GymStatues, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_GAME_CORNER:

	hidden_events_for GAME_CORNER
	hidden_event 18, 15, StartSlotMachine, ANY_FACING
	hidden_event 18, 14, StartSlotMachine, ANY_FACING
	hidden_event 18, 13, StartSlotMachine, ANY_FACING
	hidden_event 18, 12, StartSlotMachine, ANY_FACING
	hidden_event 18, 11, StartSlotMachine, ANY_FACING
	hidden_event 18, 10, StartSlotMachine, SLOTS_SOMEONESKEYS
	hidden_event 13, 10, StartSlotMachine, ANY_FACING
	hidden_event 13, 11, StartSlotMachine, ANY_FACING
	hidden_event 13, 12, StartSlotMachine, SLOTS_OUTTOLUNCH
	hidden_event 13, 13, StartSlotMachine, ANY_FACING
	hidden_event 13, 14, StartSlotMachine, ANY_FACING
	hidden_event 13, 15, StartSlotMachine, ANY_FACING
	hidden_event 12, 15, StartSlotMachine, ANY_FACING
	hidden_event 12, 14, StartSlotMachine, ANY_FACING
	hidden_event 12, 13, StartSlotMachine, ANY_FACING
	hidden_event 12, 12, StartSlotMachine, ANY_FACING
	hidden_event 12, 11, StartSlotMachine, ANY_FACING
	hidden_event 12, 10, StartSlotMachine, ANY_FACING
	hidden_event  7, 10, StartSlotMachine, ANY_FACING
	hidden_event  7, 11, StartSlotMachine, ANY_FACING
	hidden_event  7, 12, StartSlotMachine, ANY_FACING
	hidden_event  7, 13, StartSlotMachine, ANY_FACING
	hidden_event  7, 14, StartSlotMachine, ANY_FACING
	hidden_event  7, 15, StartSlotMachine, ANY_FACING
	hidden_event  6, 15, StartSlotMachine, ANY_FACING
	hidden_event  6, 14, StartSlotMachine, ANY_FACING
	hidden_event  6, 13, StartSlotMachine, ANY_FACING
	hidden_event  6, 12, StartSlotMachine, SLOTS_OUTOFORDER
	hidden_event  6, 11, StartSlotMachine, ANY_FACING
	hidden_event  6, 10, StartSlotMachine, ANY_FACING
	hidden_event  1, 10, StartSlotMachine, ANY_FACING
	hidden_event  1, 11, StartSlotMachine, ANY_FACING
	hidden_event  1, 12, StartSlotMachine, ANY_FACING
	hidden_event  1, 13, StartSlotMachine, ANY_FACING
	hidden_event  1, 14, StartSlotMachine, ANY_FACING
	hidden_event  1, 15, StartSlotMachine, ANY_FACING
	; HiddenCoins argument: COIN + <number of coins>
	hidden_event  0,  8, HiddenCoins, COIN + 10
	hidden_event  1, 16, HiddenCoins, COIN + 10
	hidden_event  3, 11, HiddenCoins, COIN + 20
	hidden_event  3, 14, HiddenCoins, COIN + 10
	hidden_event  4, 12, HiddenCoins, COIN + 10
	hidden_event  9, 12, HiddenCoins, COIN + 20
	hidden_event  9, 15, HiddenCoins, COIN + 10
	hidden_event 16, 14, HiddenCoins, COIN + 10
	hidden_event 10, 16, HiddenCoins, COIN + 10
	hidden_event 11,  7, HiddenCoins, COIN + 40
	hidden_event 15,  8, HiddenCoins, COIN + 100
	hidden_event 12, 15, HiddenCoins, COIN + 10
	.DB -1 ; end

	HiddenEventsFor_CELADON_HOTEL:

	hidden_events_for CELADON_HOTEL
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	.DB -1 ; end

	HiddenEventsFor_FUCHSIA_POKECENTER:

	hidden_events_for FUCHSIA_POKECENTER
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_FUCHSIA_GYM:

	hidden_events_for FUCHSIA_GYM
	hidden_event  3, 15, GymStatues, SPRITE_FACING_UP
	hidden_event  6, 15, GymStatues, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_CINNABAR_GYM:

	hidden_events_for CINNABAR_GYM
	hidden_event 17, 13, GymStatues, SPRITE_FACING_UP
	; PrintCinnabarQuiz argument: ([hGymGateAnswer] << 4) | [hGymGateIndex]
	hidden_event 15,  7, PrintCinnabarQuiz, (FALSE << 4) | 1
	hidden_event 10,  1, PrintCinnabarQuiz, (TRUE  << 4) | 2
	hidden_event  9,  7, PrintCinnabarQuiz, (TRUE  << 4) | 3
	hidden_event  9, 13, PrintCinnabarQuiz, (TRUE  << 4) | 4
	hidden_event  1, 13, PrintCinnabarQuiz, (FALSE << 4) | 5
	hidden_event  1,  7, PrintCinnabarQuiz, (TRUE  << 4) | 6
	.DB -1 ; end

	HiddenEventsFor_CINNABAR_POKECENTER:

	hidden_events_for CINNABAR_POKECENTER
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_UP
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_SAFFRON_GYM:

	hidden_events_for SAFFRON_GYM
	hidden_event  9, 15, GymStatues, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_MT_MOON_POKECENTER:

	hidden_events_for MT_MOON_POKECENTER
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_ROCK_TUNNEL_POKECENTER:

	hidden_events_for ROCK_TUNNEL_POKECENTER
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_VIRIDIAN_FOREST:

	hidden_events_for VIRIDIAN_FOREST
	hidden_event  1, 18, HiddenItems, POTION
	hidden_event 16, 42, HiddenItems, ANTIDOTE
	.DB -1 ; end

	HiddenEventsFor_MT_MOON_B2F:

	hidden_events_for MT_MOON_B2F
	hidden_event 18, 12, HiddenItems, MOON_STONE
	hidden_event 33,  9, HiddenItems, ETHER
	.DB -1 ; end

	HiddenEventsFor_INDIGO_PLATEAU:

	hidden_events_for INDIGO_PLATEAU
	hidden_event  8, 13, PrintIndigoPlateauHQText, $ff ; inaccessible
	hidden_event 11, 13, PrintIndigoPlateauHQText, SPRITE_FACING_DOWN ; inaccessible
	.DB -1 ; end

	HiddenEventsFor_ROUTE_25:

	hidden_events_for ROUTE_25
	hidden_event 38,  3, HiddenItems, ETHER
	hidden_event 10,  1, HiddenItems, ELIXER
	.DB -1 ; end

	HiddenEventsFor_ROUTE_9:

	hidden_events_for ROUTE_9
	hidden_event 14,  7, HiddenItems, ETHER
	.DB -1 ; end

	HiddenEventsFor_SS_ANNE_KITCHEN:

	hidden_events_for SS_ANNE_KITCHEN
	hidden_event 13,  5, PrintTrashText, SPRITE_FACING_DOWN
	hidden_event 13,  7, PrintTrashText, SPRITE_FACING_DOWN
	hidden_event 13,  9, HiddenItems, GREAT_BALL
	.DB -1 ; end

	HiddenEventsFor_SS_ANNE_B1F_ROOMS:

	hidden_events_for SS_ANNE_B1F_ROOMS
	hidden_event  3,  1, HiddenItems, HYPER_POTION
	.DB -1 ; end

	HiddenEventsFor_ROUTE_10:

	hidden_events_for ROUTE_10
	hidden_event  9, 17, HiddenItems, SUPER_POTION
	hidden_event 16, 53, HiddenItems, MAX_ETHER
	.DB -1 ; end

	HiddenEventsFor_ROCKET_HIDEOUT_B1F:

	hidden_events_for ROCKET_HIDEOUT_B1F
	hidden_event 21, 15, HiddenItems, PP_UP
	.DB -1 ; end

	HiddenEventsFor_ROCKET_HIDEOUT_B3F:

	hidden_events_for ROCKET_HIDEOUT_B3F
	hidden_event 27, 17, HiddenItems, NUGGET
	.DB -1 ; end

	HiddenEventsFor_ROCKET_HIDEOUT_B4F:

	hidden_events_for ROCKET_HIDEOUT_B4F
	hidden_event 25,  1, HiddenItems, SUPER_POTION
	.DB -1 ; end

	HiddenEventsFor_SAFFRON_POKECENTER:

	hidden_events_for SAFFRON_POKECENTER
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_UP
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_POKEMON_TOWER_5F:

	hidden_events_for POKEMON_TOWER_5F
	hidden_event  4, 12, HiddenItems, ELIXER
	.DB -1 ; end

	HiddenEventsFor_ROUTE_13:

	hidden_events_for ROUTE_13
	hidden_event  1, 14, HiddenItems, PP_UP
	hidden_event 16, 13, HiddenItems, CALCIUM
	.DB -1 ; end

	HiddenEventsFor_SAFARI_ZONE_GATE:

	hidden_events_for SAFARI_ZONE_GATE
	hidden_event 10,  1, HiddenItems, NUGGET ; inaccessible
	.DB -1 ; end

	HiddenEventsFor_SAFARI_ZONE_WEST:

	hidden_events_for SAFARI_ZONE_WEST
	hidden_event  6,  5, HiddenItems, REVIVE
	.DB -1 ; end

	HiddenEventsFor_SILPH_CO_5F:

	hidden_events_for SILPH_CO_5F
	hidden_event 12,  3, HiddenItems, ELIXER
	.DB -1 ; end

	HiddenEventsFor_SILPH_CO_9F:

	hidden_events_for SILPH_CO_9F
	hidden_event  2, 15, HiddenItems, MAX_POTION
	.DB -1 ; end

	HiddenEventsFor_COPYCATS_HOUSE_2F:

	hidden_events_for COPYCATS_HOUSE_2F
	hidden_event  1,  1, HiddenItems, NUGGET
	.DB -1 ; end

	HiddenEventsFor_CERULEAN_CAVE_1F:

	hidden_events_for CERULEAN_CAVE_1F
	hidden_event 14, 11, HiddenItems, RARE_CANDY
	.DB -1 ; end

	HiddenEventsFor_CERULEAN_CAVE_B1F:

	hidden_events_for CERULEAN_CAVE_B1F
	hidden_event 27,  3, HiddenItems, ULTRA_BALL
	.DB -1 ; end

	HiddenEventsFor_POWER_PLANT:

	hidden_events_for POWER_PLANT
	hidden_event 17, 16, HiddenItems, MAX_ELIXER
	hidden_event 12,  1, HiddenItems, PP_UP
	.DB -1 ; end

	HiddenEventsFor_SEAFOAM_ISLANDS_B2F:

	hidden_events_for SEAFOAM_ISLANDS_B2F
	hidden_event 15, 15, HiddenItems, NUGGET
	.DB -1 ; end

	HiddenEventsFor_SEAFOAM_ISLANDS_B4F:

	hidden_events_for SEAFOAM_ISLANDS_B4F
	hidden_event 25, 17, HiddenItems, ULTRA_BALL
	.DB -1 ; end

	HiddenEventsFor_POKEMON_MANSION_1F:

	hidden_events_for POKEMON_MANSION_1F
	hidden_event  8, 16, HiddenItems, MOON_STONE
	hidden_event  2,  5, Mansion1Script_Switches, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_POKEMON_MANSION_2F:

	hidden_events_for POKEMON_MANSION_2F
	hidden_event  2, 11, Mansion2Script_Switches, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_POKEMON_MANSION_3F:

	hidden_events_for POKEMON_MANSION_3F
	hidden_event  1,  9, HiddenItems, MAX_REVIVE
	hidden_event 10,  5, Mansion3Script_Switches, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_POKEMON_MANSION_B1F:

	hidden_events_for POKEMON_MANSION_B1F
	hidden_event  1,  9, HiddenItems, RARE_CANDY
	hidden_event 20,  3, Mansion4Script_Switches, SPRITE_FACING_UP
	hidden_event 18, 25, Mansion4Script_Switches, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_ROUTE_23:

	hidden_events_for ROUTE_23
	hidden_event  9, 44, HiddenItems, FULL_RESTORE
	hidden_event 19, 70, HiddenItems, ULTRA_BALL
	hidden_event  8, 90, HiddenItems, MAX_ETHER
	.DB -1 ; end

	HiddenEventsFor_VICTORY_ROAD_2F:

	hidden_events_for VICTORY_ROAD_2F
	hidden_event  5,  2, HiddenItems, ULTRA_BALL
	hidden_event 26,  7, HiddenItems, FULL_RESTORE
	.DB -1 ; end

	HiddenEventsFor_UNUSED_MAP_6F:

	hidden_events_for UNUSED_MAP_6F
	hidden_event 14, 11, HiddenItems, MAX_ELIXER
	.DB -1 ; end

	HiddenEventsFor_BILLS_HOUSE:

	hidden_events_for BILLS_HOUSE
	hidden_event  1,  4, BillsHousePC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_VIRIDIAN_CITY:

	hidden_events_for VIRIDIAN_CITY
	hidden_event 14,  4, HiddenItems, POTION
	.DB -1 ; end

	HiddenEventsFor_SAFARI_ZONE_WEST_REST_HOUSE:

	hidden_events_for SAFARI_ZONE_WEST_REST_HOUSE
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_SAFARI_ZONE_EAST_REST_HOUSE:

	hidden_events_for SAFARI_ZONE_EAST_REST_HOUSE
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_SAFARI_ZONE_NORTH_REST_HOUSE:

	hidden_events_for SAFARI_ZONE_NORTH_REST_HOUSE
	hidden_event  0,  4, PrintBenchGuyText, SPRITE_FACING_LEFT
	hidden_event 13,  3, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_ROUTE_15_GATE_2F:

	hidden_events_for ROUTE_15_GATE_2F
	hidden_event  1,  2, Route15GateLeftBinoculars, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_MR_FUJIS_HOUSE:

	hidden_events_for MR_FUJIS_HOUSE
	hidden_event  0,  1, PrintMagazinesText, SPRITE_FACING_DOWN
	hidden_event  1,  1, PrintMagazinesText, SPRITE_FACING_DOWN
	hidden_event  7,  1, PrintMagazinesText, SPRITE_FACING_DOWN
	.DB -1 ; end

	HiddenEventsFor_CELADON_MANSION_ROOF_HOUSE:

	hidden_events_for CELADON_MANSION_ROOF_HOUSE
	hidden_text_predef  3,  0, PrintBlackboardLinkCableText, LinkCableHelp
	hidden_text_predef  4,  0, PrintBlackboardLinkCableText, LinkCableHelp
	hidden_text_predef  3,  4, PrintNotebookText, TMNotebook
	.DB -1 ; end

	HiddenEventsFor_FIGHTING_DOJO:

	hidden_events_for FIGHTING_DOJO
	hidden_event  3,  9, PrintFightingDojoText, SPRITE_FACING_UP
	hidden_event  6,  9, PrintFightingDojoText, SPRITE_FACING_UP
	hidden_event  4,  0, PrintFightingDojoText2, SPRITE_FACING_UP
	hidden_event  5,  0, PrintFightingDojoText3, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_INDIGO_PLATEAU_LOBBY:

	hidden_events_for INDIGO_PLATEAU_LOBBY
	hidden_event 15,  7, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_CINNABAR_LAB_FOSSIL_ROOM:

	hidden_events_for CINNABAR_LAB_FOSSIL_ROOM
	hidden_event  0,  4, OpenPokemonCenterPC, SPRITE_FACING_UP
	hidden_event  2,  4, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_BIKE_SHOP:

	hidden_events_for BIKE_SHOP
	hidden_event  1,  0, PrintNewBikeText, ANY_FACING
	hidden_event  2,  1, PrintNewBikeText, ANY_FACING
	hidden_event  1,  2, PrintNewBikeText, ANY_FACING
	hidden_event  3,  2, PrintNewBikeText, ANY_FACING
	hidden_event  0,  4, PrintNewBikeText, ANY_FACING
	hidden_event  1,  5, PrintNewBikeText, ANY_FACING
	.DB -1 ; end

	HiddenEventsFor_ROUTE_11:

	hidden_events_for ROUTE_11
	hidden_event 48,  5, HiddenItems, ESCAPE_ROPE
	.DB -1 ; end

	HiddenEventsFor_ROUTE_12:

	hidden_events_for ROUTE_12
	hidden_event  2, 63, HiddenItems, HYPER_POTION
	.DB -1 ; end

	HiddenEventsFor_SILPH_CO_11F:

	hidden_events_for SILPH_CO_11F
	hidden_event 10, 12, OpenPokemonCenterPC, SPRITE_FACING_UP
	.DB -1 ; end

	HiddenEventsFor_ROUTE_17:

	hidden_events_for ROUTE_17
	hidden_event 15,  14, HiddenItems, RARE_CANDY
	hidden_event  8,  45, HiddenItems, FULL_RESTORE
	hidden_event 17,  72, HiddenItems, PP_UP
	hidden_event  4,  91, HiddenItems, MAX_REVIVE
	hidden_event  8, 121, HiddenItems, MAX_ELIXER
	.DB -1 ; end

	HiddenEventsFor_UNDERGROUND_PATH_NORTH_SOUTH:

	hidden_events_for UNDERGROUND_PATH_NORTH_SOUTH
	hidden_event  3,  4, HiddenItems, FULL_RESTORE
	hidden_event  4, 34, HiddenItems, X_SPECIAL
	.DB -1 ; end

	HiddenEventsFor_UNDERGROUND_PATH_WEST_EAST:

	hidden_events_for UNDERGROUND_PATH_WEST_EAST
	hidden_event 12,  2, HiddenItems, NUGGET
	hidden_event 21,  5, HiddenItems, ELIXER
	.DB -1 ; end

	HiddenEventsFor_CELADON_CITY:

	hidden_events_for CELADON_CITY
	hidden_event 48, 15, HiddenItems, PP_UP
	.DB -1 ; end

	HiddenEventsFor_SEAFOAM_ISLANDS_B3F:

	hidden_events_for SEAFOAM_ISLANDS_B3F
	hidden_event  9, 16, HiddenItems, MAX_ELIXER
	.DB -1 ; end

	HiddenEventsFor_VERMILION_CITY:

	hidden_events_for VERMILION_CITY
	hidden_event 14, 11, HiddenItems, MAX_ETHER
	.DB -1 ; end

	HiddenEventsFor_CERULEAN_CITY:

	hidden_events_for CERULEAN_CITY
	hidden_event 15,  8, HiddenItems, RARE_CANDY
	.DB -1 ; end

	HiddenEventsFor_ROUTE_4:

	hidden_events_for ROUTE_4
	hidden_event 40,  3, HiddenItems, GREAT_BALL
	.DB -1 ; end
