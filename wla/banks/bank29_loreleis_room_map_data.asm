LoreleisRoom_Object:
	.DB $03,$04
	.DB $0B,$04,$02,$AE,$0B,$05,$02,$AE
	.DB $00,$04,$00,$F6,$00,$05,$01,$F6
	.DB $00,$01
	.DB $3B,$06,$09,$FF,$D0,$41,$F4,$01
	.DB $2D,$C7,$0B,$04,$2D,$C7,$0B,$05
	.DB $F6,$C6,$00,$04,$F6,$C6,$00,$05
LoreleisRoomObjectEnd:
.ASSERT LoreleisRoomObjectEnd - LoreleisRoom_Object == 44

LoreleisRoom_Blocks:
.INCBIN "maps/LoreleisRoom.blk"
LoreleisRoomBlocksEnd:
.ASSERT LoreleisRoomBlocksEnd - LoreleisRoom_Blocks == 30
