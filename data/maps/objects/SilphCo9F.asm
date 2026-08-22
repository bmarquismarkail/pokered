	object_const_def
	const_export SILPHCO9F_NURSE
	const_export SILPHCO9F_ROCKET1
	const_export SILPHCO9F_SCIENTIST
	const_export SILPHCO9F_ROCKET2

SilphCo9F_Object:
	.DB $2e ; border block

	.DB 5
	warp_event 14,  0, SILPH_CO_10F, 1
	warp_event 16,  0, SILPH_CO_8F, 1
	warp_event 18,  0, SILPH_CO_ELEVATOR, 1
	warp_event  9,  3, SILPH_CO_3F, 8
	warp_event 17, 15, SILPH_CO_5F, 5

	.DB 0
	.DB 4
	object_event  3, 14, SPRITE_NURSE, STAY, DOWN, TEXT_SILPHCO9F_NURSE
	object_event  2,  4, SPRITE_ROCKET, STAY, UP, TEXT_SILPHCO9F_ROCKET1, OPP_ROCKET, 37
	object_event 21, 13, SPRITE_SCIENTIST, STAY, DOWN, TEXT_SILPHCO9F_SCIENTIST, OPP_SCIENTIST, 10
	object_event 13, 16, SPRITE_ROCKET, STAY, UP, TEXT_SILPHCO9F_ROCKET2, OPP_ROCKET, 38

	event_displacement SILPH_CO_9F_WIDTH, 14, 0

	event_displacement SILPH_CO_9F_WIDTH, 16, 0

	event_displacement SILPH_CO_9F_WIDTH, 18, 0

	event_displacement SILPH_CO_9F_WIDTH, 9, 3

	event_displacement SILPH_CO_9F_WIDTH, 17, 15