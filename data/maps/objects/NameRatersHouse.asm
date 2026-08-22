	object_const_def
	const_export NAMERATERSHOUSE_NAME_RATER

NameRatersHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 6
	warp_event  3,  7, LAST_MAP, 6

	.DB 0
	.DB 1
	object_event  5,  3, SPRITE_SILPH_PRESIDENT, STAY, LEFT, TEXT_NAMERATERSHOUSE_NAME_RATER

	event_displacement NAME_RATERS_HOUSE_WIDTH, 2, 7

	event_displacement NAME_RATERS_HOUSE_WIDTH, 3, 7