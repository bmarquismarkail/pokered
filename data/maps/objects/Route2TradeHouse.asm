	object_const_def
	const_export ROUTE2TRADEHOUSE_SCIENTIST
	const_export ROUTE2TRADEHOUSE_GAMEBOY_KID

Route2TradeHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 3
	warp_event  3,  7, LAST_MAP, 3

	.DB 0
	.DB 2
	object_event  2,  4, SPRITE_SCIENTIST, STAY, RIGHT, TEXT_ROUTE2TRADEHOUSE_SCIENTIST
	object_event  4,  1, SPRITE_GAMEBOY_KID, STAY, DOWN, TEXT_ROUTE2TRADEHOUSE_GAMEBOY_KID

	event_displacement ROUTE_2_TRADE_HOUSE_WIDTH, 2, 7

	event_displacement ROUTE_2_TRADE_HOUSE_WIDTH, 3, 7