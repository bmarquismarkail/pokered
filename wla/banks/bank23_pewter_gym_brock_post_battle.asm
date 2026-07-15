; Brock's post-battle badge and TM-award script.
PewterGymBrockPostBattle:
	LD A, ($D057) ; wIsInBattle
	CP $FF
	JP Z, PewterGymResetScripts
	LD A, $F0 ; PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore

PewterGymScriptReceiveTM34:
	LD A, $04 ; TEXT_PEWTERGYM_BROCK_WAIT_TAKE_THIS
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD HL, $D755 ; event flag byte
	SET 7, (HL) ; EVENT_BEAT_BROCK
	LD BC, $EA01 ; one TM_BIDE
	CALL $3E2E ; GiveItem
	JR NC, PewterGymScriptReceiveTM34.BagFull
	LD A, $05 ; TEXT_PEWTERGYM_RECEIVED_TM34
	LDH ($8C), A
	CALL $2920 ; DisplayTextID
	LD HL, $D755
	SET 6, (HL) ; EVENT_GOT_TM34
	JR PewterGymScriptReceiveTM34.gymVictory
PewterGymScriptReceiveTM34.BagFull:
	LD A, $06 ; TEXT_PEWTERGYM_TM34_NO_ROOM
	LDH ($8C), A
	CALL $2920 ; DisplayTextID
PewterGymScriptReceiveTM34.gymVictory:
	LD HL, $D356 ; wObtainedBadges
	SET 0, (HL) ; BIT_BOULDERBADGE
	LD HL, $D72A ; wBeatGymFlags
	SET 0, (HL)

	LD A, $04 ; TOGGLE_GYM_GUY
	LD ($CC4D), A ; wToggleableObjectIndex
	LD A, $11 ; HideObject predef
	CALL $3E6D ; Predef
	LD A, $22 ; TOGGLE_ROUTE_22_RIVAL_1
	LD ($CC4D), A
	LD A, $11 ; HideObject predef
	CALL $3E6D ; Predef

	LD HL, $D7EB
	RES 0, (HL) ; EVENT_1ST_ROUTE22_RIVAL_BATTLE
	RES 7, (HL) ; EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	LD HL, $D755
	SET 2, (HL) ; EVENT_BEAT_PEWTER_GYM_TRAINER_0
	JP PewterGymResetScripts
PewterGymBrockPostBattleEnd:
.ASSERT PewterGymBrockPostBattleEnd - PewterGymBrockPostBattle == 99
