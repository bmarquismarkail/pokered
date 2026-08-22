	object_const_def
	const_export CERULEANTRADEHOUSE_GRANNY
	const_export CERULEANTRADEHOUSE_GAMBLER

CeruleanTradeHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 2
	warp_event  3,  7, LAST_MAP, 2

	.DB 0
	.DB 2
	object_event  5,  4, SPRITE_GRANNY, STAY, LEFT, TEXT_CERULEANTRADEHOUSE_GRANNY
	object_event  1,  2, SPRITE_GAMBLER, STAY, NONE, TEXT_CERULEANTRADEHOUSE_GAMBLER

	event_displacement CERULEAN_TRADE_HOUSE_WIDTH, 2, 7

	event_displacement CERULEAN_TRADE_HOUSE_WIDTH, 3, 7