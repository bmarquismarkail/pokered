	object_const_def
	const_export SAFARIZONEGATE_SAFARI_ZONE_WORKER1
	const_export SAFARIZONEGATE_SAFARI_ZONE_WORKER2

SafariZoneGate_Object:
	.DB $a ; border block

	.DB 4
	warp_event  3,  5, LAST_MAP, 5
	warp_event  4,  5, LAST_MAP, 5
	warp_event  3,  0, SAFARI_ZONE_CENTER, 1
	warp_event  4,  0, SAFARI_ZONE_CENTER, 2

	.DB 0
	.DB 2
	object_event  6,  2, SPRITE_SAFARI_ZONE_WORKER, STAY, LEFT, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1
	object_event  1,  4, SPRITE_SAFARI_ZONE_WORKER, STAY, RIGHT, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER2

	event_displacement SAFARI_ZONE_GATE_WIDTH, 3, 5

	event_displacement SAFARI_ZONE_GATE_WIDTH, 4, 5

	event_displacement SAFARI_ZONE_GATE_WIDTH, 3, 0

	event_displacement SAFARI_ZONE_GATE_WIDTH, 4, 0