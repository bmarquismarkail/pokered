ChampionsRoom_Object:
	.DB $03,$04
	.DB $07,$03,$01,$71,$07,$04,$02,$71
	.DB $00,$03,$00,$76,$00,$04,$00,$76
	.DB $00,$02
	.DB $02,$06,$08,$FF,$D0,$01
	.DB $03,$0B,$07,$FF,$D1,$02
	.DB $12,$C7,$07,$03,$13,$C7,$07,$04
	.DB $F4,$C6,$00,$03,$F5,$C6,$00,$04
ChampionsRoomObjectEnd:
.ASSERT ChampionsRoomObjectEnd - ChampionsRoom_Object == 48

ChampionsRoom_Blocks:
.INCBIN "maps/ChampionsRoom.blk"
ChampionsRoomBlocksEnd:
.ASSERT ChampionsRoomBlocksEnd - ChampionsRoom_Blocks == 16
