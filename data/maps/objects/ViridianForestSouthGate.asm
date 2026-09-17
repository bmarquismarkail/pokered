	object_const_def
	const_export VIRIDIANFORESTSOUTHGATE_GIRL
	const_export VIRIDIANFORESTSOUTHGATE_LITTLE_GIRL

ViridianForestSouthGate_Object:
	.DB $a ; border block

	.DB 4
	warp_event  4,  0, VIRIDIAN_FOREST, 4
	warp_event  5,  0, VIRIDIAN_FOREST, 5
	warp_event  4,  7, LAST_MAP, 6
	warp_event  5,  7, LAST_MAP, 6

	.DB 0
	.DB 2
	object_event  8,  4, SPRITE_GIRL, STAY, LEFT, TEXT_VIRIDIANFORESTSOUTHGATE_GIRL
	object_event  2,  4, SPRITE_LITTLE_GIRL, WALK, UP_DOWN, TEXT_VIRIDIANFORESTSOUTHGATE_LITTLE_GIRL

	event_displacement VIRIDIAN_FOREST_SOUTH_GATE_WIDTH, 4, 0

	event_displacement VIRIDIAN_FOREST_SOUTH_GATE_WIDTH, 5, 0

	event_displacement VIRIDIAN_FOREST_SOUTH_GATE_WIDTH, 4, 7

	event_displacement VIRIDIAN_FOREST_SOUTH_GATE_WIDTH, 5, 7