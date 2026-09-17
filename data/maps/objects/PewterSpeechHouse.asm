	object_const_def
	const_export PEWTERSPEECHHOUSE_GAMBLER
	const_export PEWTERSPEECHHOUSE_YOUNGSTER

PewterSpeechHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 6
	warp_event  3,  7, LAST_MAP, 6

	.DB 0
	.DB 2
	object_event  2,  3, SPRITE_GAMBLER, STAY, RIGHT, TEXT_PEWTERSPEECHHOUSE_GAMBLER
	object_event  4,  5, SPRITE_YOUNGSTER, STAY, NONE, TEXT_PEWTERSPEECHHOUSE_YOUNGSTER

	event_displacement PEWTER_SPEECH_HOUSE_WIDTH, 2, 7

	event_displacement PEWTER_SPEECH_HOUSE_WIDTH, 3, 7