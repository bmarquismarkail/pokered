	object_const_def
	const_export VIRIDIANSCHOOLHOUSE_BRUNETTE_GIRL
	const_export VIRIDIANSCHOOLHOUSE_COOLTRAINER_F

ViridianSchoolHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 3
	warp_event  3,  7, LAST_MAP, 3

	.DB 0
	.DB 2
	object_event  3,  5, SPRITE_BRUNETTE_GIRL, STAY, UP, TEXT_VIRIDIANSCHOOLHOUSE_BRUNETTE_GIRL
	object_event  4,  1, SPRITE_COOLTRAINER_F, STAY, DOWN, TEXT_VIRIDIANSCHOOLHOUSE_COOLTRAINER_F

	event_displacement VIRIDIAN_SCHOOL_HOUSE_WIDTH, 2, 7

	event_displacement VIRIDIAN_SCHOOL_HOUSE_WIDTH, 3, 7