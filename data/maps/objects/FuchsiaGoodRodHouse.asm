	object_const_def
	const_export FUCHSIAGOODRODHOUSE_FISHING_GURU

FuchsiaGoodRodHouse_Object:
	.DB $c ; border block

	.DB 3
	warp_event  2,  0, LAST_MAP, 9
	warp_event  2,  7, LAST_MAP, 8
	warp_event  3,  7, LAST_MAP, 8

	.DB 0
	.DB 1
	object_event  5,  3, SPRITE_FISHING_GURU, STAY, RIGHT, TEXT_FUCHSIAGOODRODHOUSE_FISHING_GURU

	event_displacement FUCHSIA_GOOD_ROD_HOUSE_WIDTH, 2, 0

	event_displacement FUCHSIA_GOOD_ROD_HOUSE_WIDTH, 2, 7

	event_displacement FUCHSIA_GOOD_ROD_HOUSE_WIDTH, 3, 7