CeladonMansionRoof_Object:
	.DB $9 ; border block

	.DB 3
	warp_event  6,  1, CELADON_MANSION_3F, 2
	warp_event  2,  1, CELADON_MANSION_3F, 3
	warp_event  2,  7, CELADON_MANSION_ROOF_HOUSE, 1

	.DB 1
	bg_event  3,  7, TEXT_CELADONMANSIONROOF_HOUSE_SIGN

	.DB 0
	event_displacement CELADON_MANSION_ROOF_WIDTH, 6, 1
	event_displacement CELADON_MANSION_ROOF_WIDTH, 2, 1
	event_displacement CELADON_MANSION_ROOF_WIDTH, 2, 7