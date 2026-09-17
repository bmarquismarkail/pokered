	object_const_def
	const_export BIKESHOP_CLERK
	const_export BIKESHOP_MIDDLE_AGED_WOMAN
	const_export BIKESHOP_YOUNGSTER

BikeShop_Object:
	.DB $e ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 5
	warp_event  3,  7, LAST_MAP, 5

	.DB 0
	.DB 3
	object_event  6,  2, SPRITE_BIKE_SHOP_CLERK, STAY, NONE, TEXT_BIKESHOP_CLERK
	object_event  5,  6, SPRITE_MIDDLE_AGED_WOMAN, WALK, UP_DOWN, TEXT_BIKESHOP_MIDDLE_AGED_WOMAN
	object_event  1,  3, SPRITE_YOUNGSTER, STAY, UP, TEXT_BIKESHOP_YOUNGSTER

	event_displacement BIKE_SHOP_WIDTH, 2, 7

	event_displacement BIKE_SHOP_WIDTH, 3, 7