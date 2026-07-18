; Warden's House border, warps, displays, objects, and warp-to records.
WardensHouse_Object:
	.DB $17 ; border block
	.DB $02 ; warp count
	.DB $07,$04,$03,$FF
	.DB $07,$05,$03,$FF
	.DB $02 ; background-event count
	.DB $03,$04,$04
	.DB $03,$05,$05
	.DB $03 ; object count
	.DB $2D,$07,$06,$FF,$FF,$01
	.DB $3D,$07,$0C,$FF,$FF,$82,$28
	.DB $3F,$08,$0C,$FF,$10,$03
	.DB $17,$C7,$07,$04
	.DB $17,$C7,$07,$05
WardensHouseObjectEnd:
.ASSERT WardensHouseObjectEnd - WardensHouse_Object == 45
