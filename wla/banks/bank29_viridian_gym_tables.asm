ViridianGym_TextPointers:
	.DW ViridianGymGiovanniText,ViridianGymCooltrainerM1Text,ViridianGymHiker1Text,ViridianGymRocker1Text,ViridianGymHiker2Text,ViridianGymCooltrainerM2Text,ViridianGymHiker3Text
	.DW ViridianGymRocker2Text,ViridianGymCooltrainerM3Text,ViridianGymGymGuideText,$24F4,ViridianGymGiovanniEarthBadgeInfoText,ViridianGymGiovanniReceivedTM27Text,ViridianGymGiovanniTM27NoRoomText
ViridianGymTextPointersEnd:
.ASSERT ViridianGymTextPointersEnd - ViridianGym_TextPointers == 28
ViridianGymTrainerHeaders:
ViridianGymTrainerHeader0:
	.DB $02,$40,$51,$D7
	.DW ViridianGymCooltrainerM1BattleText,ViridianGymCooltrainerM1AfterBattleText,ViridianGymCooltrainerM1EndBattleText,ViridianGymCooltrainerM1EndBattleText
ViridianGymTrainerHeader1:
	.DB $03,$40,$51,$D7
	.DW ViridianGymHiker1BattleText,ViridianGymHiker1AfterBattleText,ViridianGymHiker1EndBattleText,ViridianGymHiker1EndBattleText
ViridianGymTrainerHeader2:
	.DB $04,$40,$51,$D7
	.DW ViridianGymRocker1BattleText,ViridianGymRocker1AfterBattleText,ViridianGymRocker1EndBattleText,ViridianGymRocker1EndBattleText
ViridianGymTrainerHeader3:
	.DB $05,$20,$51,$D7
	.DW ViridianGymHiker2BattleText,ViridianGymHiker2AfterBattleText,ViridianGymHiker2EndBattleText,ViridianGymHiker2EndBattleText
ViridianGymTrainerHeader4:
	.DB $06,$30,$51,$D7
	.DW ViridianGymCooltrainerM2BattleText,ViridianGymCooltrainerM2AfterBattleText,ViridianGymCooltrainerM2EndBattleText,ViridianGymCooltrainerM2EndBattleText
ViridianGymTrainerHeader5:
	.DB $07,$40,$51,$D7
	.DW ViridianGymHiker3BattleText,ViridianGymHiker3AfterBattleText,ViridianGymHiker3EndBattleText,ViridianGymHiker3EndBattleText
ViridianGymTrainerHeader6:
	.DB $08,$30,$51,$D7
	.DW ViridianGymRocker2BattleText,ViridianGymRocker2AfterBattleText,ViridianGymRocker2EndBattleText,ViridianGymRocker2EndBattleText
ViridianGymTrainerHeader7:
	.DB $09,$40,$51,$D7
	.DW ViridianGymCooltrainerM3BattleText,ViridianGymCooltrainerM3AfterBattleText,ViridianGymCooltrainerM3EndBattleText,ViridianGymCooltrainerM3EndBattleText
	.DB $FF
ViridianGymTrainerHeadersEnd:
.ASSERT ViridianGymTrainerHeadersEnd - ViridianGymTrainerHeaders == 97
