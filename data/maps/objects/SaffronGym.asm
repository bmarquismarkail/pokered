	object_const_def
	const_export SAFFRONGYM_SABRINA
	const_export SAFFRONGYM_CHANNELER1
	const_export SAFFRONGYM_YOUNGSTER1
	const_export SAFFRONGYM_CHANNELER2
	const_export SAFFRONGYM_YOUNGSTER2
	const_export SAFFRONGYM_CHANNELER3
	const_export SAFFRONGYM_YOUNGSTER3
	const_export SAFFRONGYM_YOUNGSTER4
	const_export SAFFRONGYM_GYM_GUIDE

SaffronGym_Object:
	.DB $2e ; border block

	.DB 32
	warp_event  8, 17, LAST_MAP, 3
	warp_event  9, 17, LAST_MAP, 3
	warp_event  1,  3, SAFFRON_GYM, 23
	warp_event  5,  3, SAFFRON_GYM, 16
	warp_event  1,  5, SAFFRON_GYM, 19
	warp_event  5,  5, SAFFRON_GYM, 9
	warp_event  1,  9, SAFFRON_GYM, 28
	warp_event  5,  9, SAFFRON_GYM, 17
	warp_event  1, 11, SAFFRON_GYM, 6
	warp_event  5, 11, SAFFRON_GYM, 14
	warp_event  1, 15, SAFFRON_GYM, 24
	warp_event  5, 15, SAFFRON_GYM, 31
	warp_event  1, 17, SAFFRON_GYM, 18
	warp_event  5, 17, SAFFRON_GYM, 10
	warp_event  9,  3, SAFFRON_GYM, 27
	warp_event 11,  3, SAFFRON_GYM, 4
	warp_event  9,  5, SAFFRON_GYM, 8
	warp_event 11,  5, SAFFRON_GYM, 13
	warp_event 11, 11, SAFFRON_GYM, 5
	warp_event 11, 15, SAFFRON_GYM, 32
	warp_event 15,  3, SAFFRON_GYM, 25
	warp_event 19,  3, SAFFRON_GYM, 29
	warp_event 15,  5, SAFFRON_GYM, 3
	warp_event 19,  5, SAFFRON_GYM, 11
	warp_event 15,  9, SAFFRON_GYM, 21
	warp_event 19,  9, SAFFRON_GYM, 30
	warp_event 15, 11, SAFFRON_GYM, 15
	warp_event 19, 11, SAFFRON_GYM, 7
	warp_event 15, 15, SAFFRON_GYM, 22
	warp_event 19, 15, SAFFRON_GYM, 26
	warp_event 15, 17, SAFFRON_GYM, 12
	warp_event 19, 17, SAFFRON_GYM, 20

	.DB 0
	.DB 9
	object_event  9,  8, SPRITE_GIRL, STAY, DOWN, TEXT_SAFFRONGYM_SABRINA, OPP_SABRINA, 1
	object_event 10,  1, SPRITE_CHANNELER, STAY, DOWN, TEXT_SAFFRONGYM_CHANNELER1, OPP_CHANNELER, 22
	object_event 17,  1, SPRITE_YOUNGSTER, STAY, DOWN, TEXT_SAFFRONGYM_YOUNGSTER1, OPP_PSYCHIC_TR, 1
	object_event  3,  7, SPRITE_CHANNELER, STAY, DOWN, TEXT_SAFFRONGYM_CHANNELER2, OPP_CHANNELER, 23
	object_event 17,  7, SPRITE_YOUNGSTER, STAY, DOWN, TEXT_SAFFRONGYM_YOUNGSTER2, OPP_PSYCHIC_TR, 2
	object_event  3, 13, SPRITE_CHANNELER, STAY, DOWN, TEXT_SAFFRONGYM_CHANNELER3, OPP_CHANNELER, 24
	object_event 17, 13, SPRITE_YOUNGSTER, STAY, DOWN, TEXT_SAFFRONGYM_YOUNGSTER3, OPP_PSYCHIC_TR, 3
	object_event  3,  1, SPRITE_YOUNGSTER, STAY, DOWN, TEXT_SAFFRONGYM_YOUNGSTER4, OPP_PSYCHIC_TR, 4
	object_event 10, 15, SPRITE_GYM_GUIDE, STAY, DOWN, TEXT_SAFFRONGYM_GYM_GUIDE

	event_displacement SAFFRON_GYM_WIDTH, 8, 17

	event_displacement SAFFRON_GYM_WIDTH, 9, 17

	event_displacement SAFFRON_GYM_WIDTH, 1, 3

	event_displacement SAFFRON_GYM_WIDTH, 5, 3

	event_displacement SAFFRON_GYM_WIDTH, 1, 5

	event_displacement SAFFRON_GYM_WIDTH, 5, 5

	event_displacement SAFFRON_GYM_WIDTH, 1, 9

	event_displacement SAFFRON_GYM_WIDTH, 5, 9

	event_displacement SAFFRON_GYM_WIDTH, 1, 11

	event_displacement SAFFRON_GYM_WIDTH, 5, 11

	event_displacement SAFFRON_GYM_WIDTH, 1, 15

	event_displacement SAFFRON_GYM_WIDTH, 5, 15

	event_displacement SAFFRON_GYM_WIDTH, 1, 17

	event_displacement SAFFRON_GYM_WIDTH, 5, 17

	event_displacement SAFFRON_GYM_WIDTH, 9, 3

	event_displacement SAFFRON_GYM_WIDTH, 11, 3

	event_displacement SAFFRON_GYM_WIDTH, 9, 5

	event_displacement SAFFRON_GYM_WIDTH, 11, 5

	event_displacement SAFFRON_GYM_WIDTH, 11, 11

	event_displacement SAFFRON_GYM_WIDTH, 11, 15

	event_displacement SAFFRON_GYM_WIDTH, 15, 3

	event_displacement SAFFRON_GYM_WIDTH, 19, 3

	event_displacement SAFFRON_GYM_WIDTH, 15, 5

	event_displacement SAFFRON_GYM_WIDTH, 19, 5

	event_displacement SAFFRON_GYM_WIDTH, 15, 9

	event_displacement SAFFRON_GYM_WIDTH, 19, 9

	event_displacement SAFFRON_GYM_WIDTH, 15, 11

	event_displacement SAFFRON_GYM_WIDTH, 19, 11

	event_displacement SAFFRON_GYM_WIDTH, 15, 15

	event_displacement SAFFRON_GYM_WIDTH, 19, 15

	event_displacement SAFFRON_GYM_WIDTH, 15, 17

	event_displacement SAFFRON_GYM_WIDTH, 19, 17