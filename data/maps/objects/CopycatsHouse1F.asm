	object_const_def
	const_export COPYCATSHOUSE1F_MIDDLE_AGED_WOMAN
	const_export COPYCATSHOUSE1F_MIDDLE_AGED_MAN
	const_export COPYCATSHOUSE1F_CHANSEY

CopycatsHouse1F_Object:
	.DB $a ; border block

	.DB 3
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1
	warp_event  7,  1, COPYCATS_HOUSE_2F, 1

	.DB 0
	.DB 3
	object_event  2,  2, SPRITE_MIDDLE_AGED_WOMAN, STAY, DOWN, TEXT_COPYCATSHOUSE1F_MIDDLE_AGED_WOMAN
	object_event  5,  4, SPRITE_MIDDLE_AGED_MAN, STAY, LEFT, TEXT_COPYCATSHOUSE1F_MIDDLE_AGED_MAN
	object_event  1,  4, SPRITE_FAIRY, WALK, UP_DOWN, TEXT_COPYCATSHOUSE1F_CHANSEY

	event_displacement COPYCATS_HOUSE_1F_WIDTH, 2, 7

	event_displacement COPYCATS_HOUSE_1F_WIDTH, 3, 7

	event_displacement COPYCATS_HOUSE_1F_WIDTH, 7, 1