	object_const_def
	const_export CELADONCHIEFHOUSE_CHIEF
	const_export CELADONCHIEFHOUSE_ROCKET
	const_export CELADONCHIEFHOUSE_SAILOR

CeladonChiefHouse_Object:
	.DB $f ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 12
	warp_event  3,  7, LAST_MAP, 12

	.DB 0
	.DB 3
	object_event  4,  2, SPRITE_GRAMPS, STAY, DOWN, TEXT_CELADONCHIEFHOUSE_CHIEF
	object_event  1,  4, SPRITE_ROCKET, WALK, ANY_DIR, TEXT_CELADONCHIEFHOUSE_ROCKET
	object_event  5,  6, SPRITE_SAILOR, STAY, LEFT, TEXT_CELADONCHIEFHOUSE_SAILOR

	event_displacement CELADON_CHIEF_HOUSE_WIDTH, 2, 7

	event_displacement CELADON_CHIEF_HOUSE_WIDTH, 3, 7