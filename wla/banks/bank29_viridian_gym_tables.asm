ViridianGym_TextPointers:
	.DW ViridianGymGiovanniText,$4AF3,$4B0C,$4B25,$4B3E,$4B57,$4B70
	.DW $4B89,$4BA2,$4BBB,$24F4,ViridianGymGiovanniEarthBadgeInfoText,ViridianGymGiovanniReceivedTM27Text,ViridianGymGiovanniTM27NoRoomText
ViridianGymTextPointersEnd:
.ASSERT ViridianGymTextPointersEnd - ViridianGym_TextPointers == 28
ViridianGymTrainerHeaders:
ViridianGymTrainerHeader0:
	.DB $02,$40,$51,$D7
	.DW $4AFD,$4B07,$4B02,$4B02
ViridianGymTrainerHeader1:
	.DB $03,$40,$51,$D7
	.DW $4B16,$4B20,$4B1B,$4B1B
ViridianGymTrainerHeader2:
	.DB $04,$40,$51,$D7
	.DW $4B2F,$4B39,$4B34,$4B34
ViridianGymTrainerHeader3:
	.DB $05,$20,$51,$D7
	.DW $4B48,$4B52,$4B4D,$4B4D
ViridianGymTrainerHeader4:
	.DB $06,$30,$51,$D7
	.DW $4B61,$4B6B,$4B66,$4B66
ViridianGymTrainerHeader5:
	.DB $07,$40,$51,$D7
	.DW $4B7A,$4B84,$4B7F,$4B7F
ViridianGymTrainerHeader6:
	.DB $08,$30,$51,$D7
	.DW $4B93,$4B9D,$4B98,$4B98
ViridianGymTrainerHeader7:
	.DB $09,$40,$51,$D7
	.DW $4BAC,$4BB6,$4BB1,$4BB1
	.DB $FF
ViridianGymTrainerHeadersEnd:
.ASSERT ViridianGymTrainerHeadersEnd - ViridianGymTrainerHeaders == 97
