ViridianGymGiovanniPostBattle:
	LD A, ($D057) ; wIsInBattle
	CP $FF
	JP Z, ViridianGymResetScripts
	LD A, $F0 ; PAD_CTRL_PAD
	LD ($CD6B), A
ViridianGymReceiveTM27:
	LD A, $0C
	LDH ($8C), A
	CALL $2920 ; DisplayTextID
	LD HL, $D751
	SET 1, (HL) ; EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	LD BC, $E301 ; TM_FISSURE, 1
	CALL $3E2E ; GiveItem
	JR NC, ViridianGymReceiveTM27.bag_full
	LD A, $0D
	LDH ($8C), A
	CALL $2920
	LD HL, $D751
	SET 0, (HL) ; EVENT_GOT_TM27
	JR ViridianGymReceiveTM27.gym_victory
ViridianGymReceiveTM27.bag_full:
	LD A, $0E
	LDH ($8C), A
	CALL $2920
ViridianGymReceiveTM27.gym_victory:
	LD HL, $D356 ; wObtainedBadges
	SET 7, (HL)
	LD HL, $D72A ; wBeatGymFlags
	SET 7, (HL)
	LD A, ($D751)
	OR $FC
	LD ($D751), A
	LD A, ($D752)
	OR $03
	LD ($D752), A
	LD A, $23 ; TOGGLE_ROUTE_22_RIVAL_2
	LD ($CC4D), A
	LD A, $15 ; ShowObject predef
	CALL $3E6D
	LD HL, $D7EB
	SET 1, (HL)
	SET 7, (HL)
	JP ViridianGymResetScripts
ViridianGymPostBattleEnd:
.ASSERT ViridianGymPostBattleEnd - ViridianGymGiovanniPostBattle == 100
