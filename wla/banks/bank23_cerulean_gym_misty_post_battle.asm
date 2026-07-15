CeruleanGymMistyPostBattleScript:
	LD A, ($D057) ; wIsInBattle
	CP $FF
	JP Z, CeruleanGymResetScripts
	LD A, $F0
	LD ($CD6B), A ; wJoyIgnore
CeruleanGymReceiveTM11:
	LD A, $05
	LDH ($8C), A
	CALL $2920 ; DisplayTextID
	LD HL, $D75E
	SET 7, (HL) ; EVENT_BEAT_MISTY
	LD BC, $D301 ; one TM_BUBBLEBEAM
	CALL $3E2E ; GiveItem
	JR NC, CeruleanGymReceiveTM11.BagFull
	LD A, $06
	LDH ($8C), A
	CALL $2920
	LD HL, $D75E
	SET 6, (HL) ; EVENT_GOT_TM11
	JR CeruleanGymReceiveTM11.gymVictory
CeruleanGymReceiveTM11.BagFull:
	LD A, $07
	LDH ($8C), A
	CALL $2920
CeruleanGymReceiveTM11.gymVictory:
	LD HL, $D356
	SET 1, (HL) ; BIT_CASCADEBADGE
	LD HL, $D72A
	SET 1, (HL)
	LD HL, $D75E
	SET 2, (HL) ; EVENT_BEAT_CERULEAN_GYM_TRAINER_0
	SET 3, (HL) ; EVENT_BEAT_CERULEAN_GYM_TRAINER_1
	JP CeruleanGymResetScripts
CeruleanGymMistyPostBattleEnd:
.ASSERT CeruleanGymMistyPostBattleEnd - CeruleanGymMistyPostBattleScript == 74
