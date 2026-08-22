	object_const_def
	const_export ROUTE1_YOUNGSTER1
	const_export ROUTE1_YOUNGSTER2

Route1_Object:
	.DB $b ; border block

	.DB 0
	.DB 1
	bg_event  9, 27, TEXT_ROUTE1_SIGN

	.DB 2
	object_event  5, 24, SPRITE_YOUNGSTER, WALK, UP_DOWN, TEXT_ROUTE1_YOUNGSTER1
	object_event 15, 13, SPRITE_YOUNGSTER, WALK, LEFT_RIGHT, TEXT_ROUTE1_YOUNGSTER2

	; unused
	warp_to 2, 7, 4
