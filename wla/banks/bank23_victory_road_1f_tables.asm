VictoryRoad1F_ScriptPointers:
	.DW VictoryRoad1FDefaultScript
	.DW $324C
	.DW $3275
VictoryRoad1FScriptPointersEnd:
.ASSERT VictoryRoad1FScriptPointersEnd - VictoryRoad1F_ScriptPointers == 6
VictoryRoad1FDefaultScript:
	LD A, ($D869)
	BIT 7, A
	JP NZ, $3219 ; CheckFightingMapTrainers
	LD HL, VictoryRoad1FDefaultScript.SwitchCoords
	CALL $34E4 ; CheckBoulderCoords
	JP NC, $3219
	LD HL, $D126
	SET 5, (HL)
	LD HL, $D869
	SET 7, (HL)
	RET
VictoryRoad1FDefaultScript.SwitchCoords:
	.DB $0D, $11, $FF
VictoryRoad1FDefaultEnd:
.ASSERT VictoryRoad1FDefaultEnd - VictoryRoad1FDefaultScript == 31
VictoryRoad1F_TextPointers:
	.DW VictoryRoad1FCooltrainerFText
	.DW VictoryRoad1FCooltrainerMText
	.DW $24F4,$24F4 ; PickUpItemText
	.DW $24E5,$24E5,$24E5 ; BoulderText
VictoryRoad1FTextPointersEnd:
.ASSERT VictoryRoad1FTextPointersEnd - VictoryRoad1F_TextPointers == 14
VictoryRoad1TrainerHeaders:
VictoryRoad1TrainerHeader0:
	.DB $01,$20,$69,$D8
	.DW VictoryRoad1FCooltrainerFBattleText,VictoryRoad1FCooltrainerFAfterBattleText,VictoryRoad1FCooltrainerFEndBattleText,VictoryRoad1FCooltrainerFEndBattleText
VictoryRoad1TrainerHeader1:
	.DB $02,$20,$69,$D8
	.DW VictoryRoad1FCooltrainerMBattleText,VictoryRoad1FCooltrainerMAfterBattleText,VictoryRoad1FCooltrainerMEndBattleText,VictoryRoad1FCooltrainerMEndBattleText
	.DB $FF
VictoryRoad1TrainerHeadersEnd:
.ASSERT VictoryRoad1TrainerHeadersEnd - VictoryRoad1TrainerHeaders == 25
