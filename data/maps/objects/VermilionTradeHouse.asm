	object_const_def
	const_export VERMILIONTRADEHOUSE_LITTLE_GIRL

VermilionTradeHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 8
	warp_event  3,  7, LAST_MAP, 8

	.DB 0
	.DB 1
	object_event  3,  5, SPRITE_LITTLE_GIRL, STAY, UP, TEXT_VERMILIONTRADEHOUSE_LITTLE_GIRL

	event_displacement VERMILION_TRADE_HOUSE_WIDTH, 2, 7

	event_displacement VERMILION_TRADE_HOUSE_WIDTH, 3, 7