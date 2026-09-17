	object_const_def
	const_export SAFARIZONESECRETHOUSE_FISHING_GURU

SafariZoneSecretHouse_Object:
	.DB $17 ; border block

	.DB 2
	warp_event  2,  7, SAFARI_ZONE_WEST, 7
	warp_event  3,  7, SAFARI_ZONE_WEST, 7

	.DB 0
	.DB 1
	object_event  3,  3, SPRITE_FISHING_GURU, STAY, DOWN, TEXT_SAFARIZONESECRETHOUSE_FISHING_GURU

	event_displacement SAFARI_ZONE_SECRET_HOUSE_WIDTH, 2, 7

	event_displacement SAFARI_ZONE_SECRET_HOUSE_WIDTH, 3, 7