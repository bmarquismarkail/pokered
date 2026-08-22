	object_const_def
	const_export MRPSYCHICSHOUSE_MR_PSYCHIC

MrPsychicsHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 8
	warp_event  3,  7, LAST_MAP, 8

	.DB 0
	.DB 1
	object_event  5,  3, SPRITE_FISHING_GURU, STAY, LEFT, TEXT_MRPSYCHICSHOUSE_MR_PSYCHIC

	event_displacement MR_PSYCHICS_HOUSE_WIDTH, 2, 7

	event_displacement MR_PSYCHICS_HOUSE_WIDTH, 3, 7