	object_const_def
	const_export DAYCARE_GENTLEMAN

Daycare_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 5
	warp_event  3,  7, LAST_MAP, 5

	.DB 0
	.DB 1
	object_event  2,  3, SPRITE_GENTLEMAN, STAY, RIGHT, TEXT_DAYCARE_GENTLEMAN

	event_displacement DAYCARE_WIDTH, 2, 7

	event_displacement DAYCARE_WIDTH, 3, 7