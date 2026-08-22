	object_const_def
	const_export CERULEANBADGEHOUSE_MIDDLE_AGED_MAN

CeruleanBadgeHouse_Object:
	.DB $c ; border block

	.DB 3
	warp_event  2,  0, LAST_MAP, 10
	warp_event  2,  7, LAST_MAP, 9
	warp_event  3,  7, LAST_MAP, 9

	.DB 0
	.DB 1
	object_event  5,  3, SPRITE_MIDDLE_AGED_MAN, STAY, RIGHT, TEXT_CERULEANBADGEHOUSE_MIDDLE_AGED_MAN

	event_displacement CERULEAN_BADGE_HOUSE_WIDTH, 2, 0

	event_displacement CERULEAN_BADGE_HOUSE_WIDTH, 2, 7

	event_displacement CERULEAN_BADGE_HOUSE_WIDTH, 3, 7