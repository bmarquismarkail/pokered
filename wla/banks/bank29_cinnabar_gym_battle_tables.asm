CinnabarGym_TextPointers:
	.DW CinnabarGymBlaineText,CinnabarGymSuperNerd1,CinnabarGymSuperNerd2,CinnabarGymSuperNerd3,CinnabarGymSuperNerd4,CinnabarGymSuperNerd5
	.DW CinnabarGymSuperNerd6,CinnabarGymSuperNerd7,CinnabarGymGymGuideText
	.DW CinnabarGymBlaineVolcanoBadgeInfoText,CinnabarGymBlaineReceivedTM38Text,CinnabarGymBlaineTM38NoRoomText
CinnabarGymTextPointersEnd:
.ASSERT CinnabarGymTextPointersEnd - CinnabarGym_TextPointers == 24

CinnabarGymStartBattleScript:
	LDH A, ($8C) ; hSpriteIndex
	LD ($CF13), A ; wSpriteIndex
	CALL $336A ; EngageMapTrainer
	CALL $32D7 ; InitBattleEnemyParameters
	LD HL, $D72D ; wStatusFlags3
	SET 6, (HL) ; BIT_TALKED_TO_TRAINER
	SET 7, (HL) ; BIT_PRINT_END_BATTLE_TEXT
	LD A, ($CF13)
	CP 1 ; CINNABARGYM_BLAINE
	JR Z, CinnabarGymStartBattleScript.blaine
	LD A, 2 ; SCRIPT_CINNABARGYM_OPEN_GATE
	JR CinnabarGymStartBattleScript.not_blaine
CinnabarGymStartBattleScript.blaine:
	LD A, 3 ; SCRIPT_CINNABARGYM_BLAINE_POST_BATTLE
CinnabarGymStartBattleScript.not_blaine:
	LD ($D65E), A ; wCinnabarGymCurScript
	LD ($DA39), A ; wCurMapScript
	JP $24D7 ; TextScriptEnd
CinnabarGymStartBattleEnd:
.ASSERT CinnabarGymStartBattleEnd - CinnabarGymStartBattleScript == 40
