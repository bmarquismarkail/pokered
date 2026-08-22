	object_const_def
	const_export LAVENDERCUBONEHOUSE_CUBONE
	const_export LAVENDERCUBONEHOUSE_BRUNETTE_GIRL

LavenderCuboneHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 5
	warp_event  3,  7, LAST_MAP, 5

	.DB 0
	.DB 2
	object_event  3,  5, SPRITE_MONSTER, STAY, UP, TEXT_LAVENDERCUBONEHOUSE_CUBONE
	object_event  2,  4, SPRITE_BRUNETTE_GIRL, STAY, RIGHT, TEXT_LAVENDERCUBONEHOUSE_BRUNETTE_GIRL

	event_displacement LAVENDER_CUBONE_HOUSE_WIDTH, 2, 7

	event_displacement LAVENDER_CUBONE_HOUSE_WIDTH, 3, 7