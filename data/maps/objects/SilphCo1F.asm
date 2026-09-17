	object_const_def
	const_export SILPHCO1F_LINK_RECEPTIONIST

SilphCo1F_Object:
	.DB $2e ; border block

	.DB 5
	warp_event 10, 17, LAST_MAP, 6
	warp_event 11, 17, LAST_MAP, 6
	warp_event 26,  0, SILPH_CO_2F, 1
	warp_event 20,  0, SILPH_CO_ELEVATOR, 1
	warp_event 16, 10, SILPH_CO_3F, 7

	.DB 0
	.DB 1
	object_event  4,  2, SPRITE_LINK_RECEPTIONIST, STAY, DOWN, TEXT_SILPHCO1F_LINK_RECEPTIONIST

	event_displacement SILPH_CO_1F_WIDTH, 10, 17

	event_displacement SILPH_CO_1F_WIDTH, 11, 17

	event_displacement SILPH_CO_1F_WIDTH, 26, 0

	event_displacement SILPH_CO_1F_WIDTH, 20, 0

	event_displacement SILPH_CO_1F_WIDTH, 16, 10