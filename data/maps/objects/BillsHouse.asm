	object_const_def
	const_export BILLSHOUSE_BILL_POKEMON
	const_export BILLSHOUSE_BILL1
	const_export BILLSHOUSE_BILL2

BillsHouse_Object:
	.DB $d ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1

	.DB 0
	.DB 3
	object_event  6,  5, SPRITE_MONSTER, STAY, NONE, TEXT_BILLSHOUSE_BILL_POKEMON
	object_event  4,  4, SPRITE_SUPER_NERD, STAY, NONE, TEXT_BILLSHOUSE_BILL_SS_TICKET
	object_event  6,  5, SPRITE_SUPER_NERD, STAY, NONE, TEXT_BILLSHOUSE_BILL_CHECK_OUT_MY_RARE_POKEMON

	event_displacement BILLS_HOUSE_WIDTH, 2, 7

	event_displacement BILLS_HOUSE_WIDTH, 3, 7