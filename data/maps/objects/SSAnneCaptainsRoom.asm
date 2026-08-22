	object_const_def
	const_export SSANNECAPTAINSROOM_CAPTAIN

SSAnneCaptainsRoom_Object:
	.DB $c ; border block

	.DB 1
	warp_event  0,  7, SS_ANNE_2F, 9

	.DB 2
	bg_event  4,  1, TEXT_SSANNECAPTAINSROOM_TRASH
	bg_event  1,  2, TEXT_SSANNECAPTAINSROOM_SEASICK_BOOK

	.DB 1
	object_event  4,  2, SPRITE_CAPTAIN, STAY, UP, TEXT_SSANNECAPTAINSROOM_CAPTAIN

	event_displacement SS_ANNE_CAPTAINS_ROOM_WIDTH, 0, 7