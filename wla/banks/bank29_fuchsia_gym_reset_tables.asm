FuchsiaGymResetScripts:
	XOR A ; SCRIPT_FUCHSIAGYM_DEFAULT
	LD ($CD6B), A ; wJoyIgnore
	LD ($D65B), A ; wFuchsiaGymCurScript
	LD ($DA39), A ; wCurMapScript
	RET
FuchsiaGymResetScriptsEnd:
.ASSERT FuchsiaGymResetScriptsEnd - FuchsiaGymResetScripts == 11

FuchsiaGym_ScriptPointers:
	.DW $3219 ; CheckFightingMapTrainers
	.DW $324C ; DisplayEnemyTrainerTextAndStartBattle
	.DW $3275 ; EndTrainerBattle
	.DW FuchsiaGymKogaPostBattleScript
FuchsiaGymScriptPointersEnd:
.ASSERT FuchsiaGymScriptPointersEnd - FuchsiaGym_ScriptPointers == 8
