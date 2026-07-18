BrunosRoom_Object:
	.DB $03,$04
	.DB $0B,$04,$02,$F5,$0B,$05,$03,$F5
	.DB $00,$04,$00,$F7,$00,$05,$01,$F7
	.DB $00,$01
	.DB $3A,$06,$09,$FF,$D0,$41,$E9,$01
	.DB $2D,$C7,$0B,$04,$2D,$C7,$0B,$05
	.DB $F6,$C6,$00,$04,$F6,$C6,$00,$05
BrunosRoomObjectEnd:
.ASSERT BrunosRoomObjectEnd - BrunosRoom_Object == 44

BrunosRoom_Blocks:
.INCBIN "maps/BrunosRoom.blk"
BrunosRoomBlocksEnd:
.ASSERT BrunosRoomBlocksEnd - BrunosRoom_Blocks == 30
