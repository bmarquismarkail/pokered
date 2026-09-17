; super rod encounters
SuperRodData:
	; map, fishing group
	dbw PALLET_TOWN,         SuperRodData.Group1
	dbw VIRIDIAN_CITY,       SuperRodData.Group1
	dbw CERULEAN_CITY,       SuperRodData.Group3
	dbw VERMILION_CITY,      SuperRodData.Group4
	dbw CELADON_CITY,        SuperRodData.Group5
	dbw FUCHSIA_CITY,        SuperRodData.Group10
	dbw CINNABAR_ISLAND,     SuperRodData.Group8
	dbw ROUTE_4,             SuperRodData.Group3
	dbw ROUTE_6,             SuperRodData.Group4
	dbw ROUTE_10,            SuperRodData.Group5
	dbw ROUTE_11,            SuperRodData.Group4
	dbw ROUTE_12,            SuperRodData.Group7
	dbw ROUTE_13,            SuperRodData.Group7
	dbw ROUTE_17,            SuperRodData.Group7
	dbw ROUTE_18,            SuperRodData.Group7
	dbw ROUTE_19,            SuperRodData.Group8
	dbw ROUTE_20,            SuperRodData.Group8
	dbw ROUTE_21,            SuperRodData.Group8
	dbw ROUTE_22,            SuperRodData.Group2
	dbw ROUTE_23,            SuperRodData.Group9
	dbw ROUTE_24,            SuperRodData.Group3
	dbw ROUTE_25,            SuperRodData.Group3
	dbw CERULEAN_GYM,        SuperRodData.Group3
	dbw VERMILION_DOCK,      SuperRodData.Group4
	dbw SEAFOAM_ISLANDS_B3F, SuperRodData.Group8
	dbw SEAFOAM_ISLANDS_B4F, SuperRodData.Group8
	dbw SAFARI_ZONE_EAST,    SuperRodData.Group6
	dbw SAFARI_ZONE_NORTH,   SuperRodData.Group6
	dbw SAFARI_ZONE_WEST,    SuperRodData.Group6
	dbw SAFARI_ZONE_CENTER,  SuperRodData.Group6
	dbw CERULEAN_CAVE_2F,    SuperRodData.Group9
	dbw CERULEAN_CAVE_B1F,   SuperRodData.Group9
	dbw CERULEAN_CAVE_1F,    SuperRodData.Group9
	.DB -1 ; end

; fishing groups
; number of monsters, followed by level/monster pairs

SuperRodData.Group1:
	.DB 2
	.DB 15, TENTACOOL
	.DB 15, POLIWAG

SuperRodData.Group2:
	.DB 2
	.DB 15, GOLDEEN
	.DB 15, POLIWAG

SuperRodData.Group3:
	.DB 3
	.DB 15, PSYDUCK
	.DB 15, GOLDEEN
	.DB 15, KRABBY

SuperRodData.Group4:
	.DB 2
	.DB 15, KRABBY
	.DB 15, SHELLDER

SuperRodData.Group5:
	.DB 2
	.DB 23, POLIWHIRL
	.DB 15, SLOWPOKE

SuperRodData.Group6:
	.DB 4
	.DB 15, DRATINI
	.DB 15, KRABBY
	.DB 15, PSYDUCK
	.DB 15, SLOWPOKE

SuperRodData.Group7:
	.DB 4
	.DB 5, TENTACOOL
	.DB 15, KRABBY
	.DB 15, GOLDEEN
	.DB 15, MAGIKARP

SuperRodData.Group8:
	.DB 4
	.DB 15, STARYU
	.DB 15, HORSEA
	.DB 15, SHELLDER
	.DB 15, GOLDEEN

SuperRodData.Group9:
	.DB 4
	.DB 23, SLOWBRO
	.DB 23, SEAKING
	.DB 23, KINGLER
	.DB 23, SEADRA

SuperRodData.Group10:
	.DB 4
	.DB 23, SEAKING
	.DB 15, KRABBY
	.DB 15, GOLDEEN
	.DB 15, MAGIKARP
