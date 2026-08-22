	object_const_def
	const_export ROUTE12GATE2F_BRUNETTE_GIRL

Route12Gate2F_Object:
	.DB $a ; border block

	.DB 1
	warp_event  7,  7, ROUTE_12_GATE_1F, 5

	.DB 2
	bg_event  1,  2, TEXT_ROUTE12GATE2F_LEFT_BINOCULARS
	bg_event  6,  2, TEXT_ROUTE12GATE2F_RIGHT_BINOCULARS

	.DB 1
	object_event  3,  4, SPRITE_BRUNETTE_GIRL, WALK, UP_DOWN, TEXT_ROUTE12GATE2F_BRUNETTE_GIRL

	event_displacement ROUTE_12_GATE_2F_WIDTH, 7, 7