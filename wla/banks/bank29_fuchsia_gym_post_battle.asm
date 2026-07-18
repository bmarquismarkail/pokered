FuchsiaGymKogaPostBattleScript:
	LD A, ($D057) ; wIsInBattle
	CP $FF
	JP Z, FuchsiaGymResetScripts
	LD A, $F0 ; PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
FuchsiaGymReceiveTM06:
	LD A, 9 ; TEXT_FUCHSIAGYM_KOGA_SOUL_BADGE_INFO
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD HL, $D792
	SET 1, (HL) ; EVENT_BEAT_KOGA
	LD BC, $CE01 ; TM_TOXIC, 1
	CALL $3E2E ; GiveItem
	JR NC, FuchsiaGymReceiveTM06.BagFull
	LD A, 10 ; TEXT_FUCHSIAGYM_KOGA_RECEIVED_TM06
	LDH ($8C), A
	CALL $2920 ; DisplayTextID
	LD HL, $D792
	SET 0, (HL) ; EVENT_GOT_TM06
	JR FuchsiaGymReceiveTM06.gymVictory
FuchsiaGymReceiveTM06.BagFull:
	LD A, 11 ; TEXT_FUCHSIAGYM_KOGA_TM06_NO_ROOM
	LDH ($8C), A
	CALL $2920 ; DisplayTextID
FuchsiaGymReceiveTM06.gymVictory:
	LD HL, $D356 ; wObtainedBadges
	SET 4, (HL) ; BIT_SOULBADGE
	LD HL, $D72A ; wBeatGymFlags
	SET 4, (HL)
	LD A, ($D792)
	OR $FC ; EVENT_BEAT_FUCHSIA_GYM_TRAINER_0..5
	LD ($D792), A
	JP FuchsiaGymResetScripts
FuchsiaGymPostBattleEnd:
.ASSERT FuchsiaGymPostBattleEnd - FuchsiaGymKogaPostBattleScript == 75
