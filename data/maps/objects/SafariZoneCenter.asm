	object_const_def
	const_export SAFARIZONECENTER_NUGGET

SafariZoneCenter_Object:
	.DB $0 ; border block

	.DB 9
	warp_event 14, 25, SAFARI_ZONE_GATE, 3
	warp_event 15, 25, SAFARI_ZONE_GATE, 4
	warp_event  0, 10, SAFARI_ZONE_WEST, 5
	warp_event  0, 11, SAFARI_ZONE_WEST, 6
	warp_event 14,  0, SAFARI_ZONE_NORTH, 5
	warp_event 15,  0, SAFARI_ZONE_NORTH, 6
	warp_event 29, 10, SAFARI_ZONE_EAST, 3
	warp_event 29, 11, SAFARI_ZONE_EAST, 4
	warp_event 17, 19, SAFARI_ZONE_CENTER_REST_HOUSE, 1

	.DB 2
	bg_event 18, 20, TEXT_SAFARIZONECENTER_REST_HOUSE_SIGN
	bg_event 14, 22, TEXT_SAFARIZONECENTER_TRAINER_TIPS_SIGN

	.DB 1
	object_event 14, 10, SPRITE_POKE_BALL, STAY, NONE, TEXT_SAFARIZONECENTER_NUGGET, NUGGET

	event_displacement SAFARI_ZONE_CENTER_WIDTH, 14, 25

	event_displacement SAFARI_ZONE_CENTER_WIDTH, 15, 25

	event_displacement SAFARI_ZONE_CENTER_WIDTH, 0, 10

	event_displacement SAFARI_ZONE_CENTER_WIDTH, 0, 11

	event_displacement SAFARI_ZONE_CENTER_WIDTH, 14, 0

	event_displacement SAFARI_ZONE_CENTER_WIDTH, 15, 0

	event_displacement SAFARI_ZONE_CENTER_WIDTH, 29, 10

	event_displacement SAFARI_ZONE_CENTER_WIDTH, 29, 11

	event_displacement SAFARI_ZONE_CENTER_WIDTH, 17, 19