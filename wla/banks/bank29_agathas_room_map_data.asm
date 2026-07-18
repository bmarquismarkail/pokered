AgathasRoom_Object:
	.DB $00,$04
	.DB $0B,$04,$02,$F6,$0B,$05,$03,$F6
	.DB $00,$04,$00,$71,$00,$05,$00,$71
	.DB $00,$01
	.DB $39,$06,$09,$FF,$D0,$41,$F6,$01
	.DB $2D,$C7,$0B,$04,$2D,$C7,$0B,$05
	.DB $F6,$C6,$00,$04,$F6,$C6,$00,$05
AgathasRoomObjectEnd:
.ASSERT AgathasRoomObjectEnd - AgathasRoom_Object == 44

AgathasRoom_Blocks:
.INCBIN "maps/AgathasRoom.blk"
AgathasRoomBlocksEnd:
.ASSERT AgathasRoomBlocksEnd - AgathasRoom_Blocks == 30
