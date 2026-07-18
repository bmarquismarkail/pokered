FuchsiaGym_TextPointers:
	.DW FuchsiaGymKogaText,FuchsiaGymRocker1Text,FuchsiaGymRocker2Text,FuchsiaGymRocker3Text,FuchsiaGymRocker4Text,FuchsiaGymRocker5Text
	.DW FuchsiaGymRocker6Text,FuchsiaGymGymGuideText,FuchsiaGymKogaSoulBadgeInfoText,FuchsiaGymKogaReceivedTM06Text,FuchsiaGymKogaTM06NoRoomText
FuchsiaGymTextPointersEnd:
.ASSERT FuchsiaGymTextPointersEnd - FuchsiaGym_TextPointers == 22

FuchsiaGymTrainerHeaders:
FuchsiaGymTrainerHeader0:
	.DB $02,$20,$92,$D7
	.DW FuchsiaGymRocker1BattleText,FuchsiaGymRocker1AfterBattleText,FuchsiaGymRocker1EndBattleText,FuchsiaGymRocker1EndBattleText
FuchsiaGymTrainerHeader1:
	.DB $03,$20,$92,$D7
	.DW FuchsiaGymRocker2BattleText,FuchsiaGymRocker2AfterBattleText,FuchsiaGymRocker2EndBattleText,FuchsiaGymRocker2EndBattleText
FuchsiaGymTrainerHeader2:
	.DB $04,$40,$92,$D7
	.DW FuchsiaGymRocker3BattleText,FuchsiaGymRocker3AfterBattleText,FuchsiaGymRocker3EndBattleText,FuchsiaGymRocker3EndBattleText
FuchsiaGymTrainerHeader3:
	.DB $05,$20,$92,$D7
	.DW FuchsiaGymRocker4BattleText,FuchsiaGymRocker4AfterBattleText,FuchsiaGymRocker4EndBattleText,FuchsiaGymRocker4EndBattleText
FuchsiaGymTrainerHeader4:
	.DB $06,$20,$92,$D7
	.DW FuchsiaGymRocker5BattleText,FuchsiaGymRocker5AfterBattleText,FuchsiaGymRocker5EndBattleText,FuchsiaGymRocker5EndBattleText
FuchsiaGymTrainerHeader5:
	.DB $07,$20,$92,$D7
	.DW FuchsiaGymRocker6BattleText,FuchsiaGymRocker6AfterBattleText,FuchsiaGymRocker6EndBattleText,FuchsiaGymRocker6EndBattleText
	.DB $FF
FuchsiaGymTrainerHeadersEnd:
.ASSERT FuchsiaGymTrainerHeadersEnd - FuchsiaGymTrainerHeaders == 73
