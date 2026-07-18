SilphCo9F_ScriptPointers:
	.DW $3219 ; CheckFightingMapTrainers
	.DW $324C ; DisplayEnemyTrainerTextAndStartBattle
	.DW $3275 ; EndTrainerBattle
SilphCo9FScriptPointersEnd:
.ASSERT SilphCo9FScriptPointersEnd - SilphCo9F_ScriptPointers == 6
SilphCo9F_TextPointers:
	.DW SilphCo9FNurseText
	.DW SilphCo9FRocket1Text
	.DW SilphCo9FScientistText
	.DW SilphCo9FRocket2Text
SilphCo9FTextPointersEnd:
.ASSERT SilphCo9FTextPointersEnd - SilphCo9F_TextPointers == 8
SilphCo9TrainerHeaders:
SilphCo9TrainerHeader0:
	.DB $02,$40,$33,$D8
	.DW SilphCo9FRocket1BattleText,SilphCo9FRocket1AfterBattleText,SilphCo9FRocket1EndBattleText,SilphCo9FRocket1EndBattleText
SilphCo9TrainerHeader1:
	.DB $03,$20,$33,$D8
	.DW SilphCo9FScientistBattleText,SilphCo9FScientistAfterBattleText,SilphCo9FScientistEndBattleText,SilphCo9FScientistEndBattleText
SilphCo9TrainerHeader2:
	.DB $04,$40,$33,$D8
	.DW SilphCo9FRocket2BattleText,SilphCo9FRocket2AfterBattleText,SilphCo9FRocket2EndBattleText,SilphCo9FRocket2EndBattleText
	.DB $FF
SilphCo9TrainerHeadersEnd:
.ASSERT SilphCo9TrainerHeadersEnd - SilphCo9TrainerHeaders == 37
