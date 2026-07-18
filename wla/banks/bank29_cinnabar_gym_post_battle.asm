CinnabarGymBlainePostBattleScript:
	LD A, ($D057) ; wIsInBattle
	CP $FF
	JP Z, CinnabarGymResetScripts
	LD A, $F0 ; PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
CinnabarGymReceiveTM38:
	LD A, 10 ; TEXT_CINNABARGYM_BLAINE_VOLCANO_BADGE_INFO
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD HL, $D79A
	SET 1, (HL) ; EVENT_BEAT_BLAINE
	LD BC, $EE01 ; TM_FIRE_BLAST, 1
	CALL $3E2E ; GiveItem
	JR NC, CinnabarGymReceiveTM38.BagFull
	LD A, 11 ; TEXT_CINNABARGYM_BLAINE_RECEIVED_TM38
	LDH ($8C), A
	CALL $2920
	LD HL, $D79A
	SET 0, (HL) ; EVENT_GOT_TM38
	JR CinnabarGymReceiveTM38.gymVictory
CinnabarGymReceiveTM38.BagFull:
	LD A, 12 ; TEXT_CINNABARGYM_BLAINE_TM38_NO_ROOM
	LDH ($8C), A
	CALL $2920
CinnabarGymReceiveTM38.gymVictory:
	LD HL, $D356 ; wObtainedBadges
	SET 6, (HL) ; BIT_VOLCANOBADGE
	LD HL, $D72A ; wBeatGymFlags
	SET 6, (HL)
	LD A, ($D79A)
	OR $FC
	LD ($D79A), A
	LD HL, $D79B
	SET 0, (HL) ; EVENT_BEAT_CINNABAR_GYM_TRAINER_6
	LD HL, $D126 ; wCurrentMapScriptFlags
	SET 5, (HL) ; BIT_CUR_MAP_LOADED_1
	JP CinnabarGymResetScripts
CinnabarGymPostBattleEnd:
.ASSERT CinnabarGymPostBattleEnd - CinnabarGymBlainePostBattleScript == 85
