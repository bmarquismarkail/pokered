VermilionDock_Object:
	.DB $f ; border block

	.DB 2
	warp_event 14,  0, LAST_MAP, 6
	warp_event 14,  2, SS_ANNE_1F, 2

	.DB 0
	.DB 0
	event_displacement VERMILION_DOCK_WIDTH, 14, 0
	event_displacement VERMILION_DOCK_WIDTH, 14, 2