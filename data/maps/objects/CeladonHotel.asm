	object_const_def
	const_export CELADONHOTEL_GRANNY
	const_export CELADONHOTEL_BEAUTY
	const_export CELADONHOTEL_SUPER_NERD

CeladonHotel_Object:
	.DB $0 ; border block

	.DB 2
	warp_event  3,  7, LAST_MAP, 13
	warp_event  4,  7, LAST_MAP, 13

	.DB 0
	.DB 3
	object_event  3,  1, SPRITE_GRANNY, STAY, DOWN, TEXT_CELADONHOTEL_GRANNY
	object_event  2,  4, SPRITE_BEAUTY, STAY, NONE, TEXT_CELADONHOTEL_BEAUTY
	object_event  8,  4, SPRITE_SUPER_NERD, WALK, LEFT_RIGHT, TEXT_CELADONHOTEL_SUPER_NERD

	event_displacement CELADON_HOTEL_WIDTH, 3, 7

	event_displacement CELADON_HOTEL_WIDTH, 4, 7