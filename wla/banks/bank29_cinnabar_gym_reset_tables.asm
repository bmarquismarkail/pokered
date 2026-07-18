CinnabarGymResetScripts:
	XOR A ; SCRIPT_CINNABARGYM_DEFAULT
	LD ($CD6B), A ; wJoyIgnore
	LD ($D65E), A ; wCinnabarGymCurScript
	LD ($DA39), A ; wCurMapScript
	LD ($DA38), A ; wOpponentAfterWrongAnswer
	RET
CinnabarGymResetScriptsEnd:
.ASSERT CinnabarGymResetScriptsEnd - CinnabarGymResetScripts == 14

CinnabarGymSetTrainerHeader:
	LDH A, ($8C) ; hTextID
	LD ($CC55), A ; wTrainerHeaderFlagBit
	RET
CinnabarGymSetTrainerHeaderEnd:
.ASSERT CinnabarGymSetTrainerHeaderEnd - CinnabarGymSetTrainerHeader == 6

CinnabarGym_ScriptPointers:
	.DW CinnabarGymDefaultScript
	.DW CinnabarGymGetOpponentTextScript
	.DW CinnabarGymOpenGateScript
	.DW CinnabarGymBlainePostBattleScript
CinnabarGymScriptPointersEnd:
.ASSERT CinnabarGymScriptPointersEnd - CinnabarGym_ScriptPointers == 8
