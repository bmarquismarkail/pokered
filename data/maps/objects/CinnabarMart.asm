	object_const_def
	const_export CINNABARMART_CLERK
	const_export CINNABARMART_SILPH_WORKER_F
	const_export CINNABARMART_SCIENTIST

CinnabarMart_Object:
	.DB $0 ; border block

	.DB 2
	warp_event  3,  7, LAST_MAP, 5
	warp_event  4,  7, LAST_MAP, 5

	.DB 0
	.DB 3
	object_event  0,  5, SPRITE_CLERK, STAY, RIGHT, TEXT_CINNABARMART_CLERK
	object_event  6,  2, SPRITE_SILPH_WORKER_F, STAY, NONE, TEXT_CINNABARMART_SILPH_WORKER_F
	object_event  3,  4, SPRITE_SCIENTIST, STAY, NONE, TEXT_CINNABARMART_SCIENTIST

	event_displacement CINNABAR_MART_WIDTH, 3, 7

	event_displacement CINNABAR_MART_WIDTH, 4, 7