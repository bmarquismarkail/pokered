	object_const_def
	const_export VERMILIONMART_CLERK
	const_export VERMILIONMART_COOLTRAINER_M
	const_export VERMILIONMART_COOLTRAINER_F

VermilionMart_Object:
	.DB $0 ; border block

	.DB 2
	warp_event  3,  7, LAST_MAP, 3
	warp_event  4,  7, LAST_MAP, 3

	.DB 0
	.DB 3
	object_event  0,  5, SPRITE_CLERK, STAY, RIGHT, TEXT_VERMILIONMART_CLERK
	object_event  5,  6, SPRITE_COOLTRAINER_M, STAY, NONE, TEXT_VERMILIONMART_COOLTRAINER_M
	object_event  3,  3, SPRITE_COOLTRAINER_F, WALK, LEFT_RIGHT, TEXT_VERMILIONMART_COOLTRAINER_F

	event_displacement VERMILION_MART_WIDTH, 3, 7

	event_displacement VERMILION_MART_WIDTH, 4, 7