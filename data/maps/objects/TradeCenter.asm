	object_const_def
	const_export TRADECENTER_OPPONENT

TradeCenter_Object:
	.DB $e ; border block

	.DB 0
	.DB 0
	.DB 1
	object_event  2,  2, SPRITE_RED, STAY, ANY_DIR, TEXT_TRADECENTER_OPPONENT
