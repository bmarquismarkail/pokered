ChampionsRoomRivalReadyToBattleScript:
	LD A, ($CD38) ; wSimulatedJoypadStatesIndex
	AND A
	RET NZ
	CALL $3DD7 ; Delay3
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD HL, $D355 ; wOptions
	RES 7, (HL) ; BIT_BATTLE_ANIMATION
	LD A, 1 ; TEXT_CHAMPIONSROOM_RIVAL
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	CALL $3DD7 ; Delay3
	LD HL, $D72D ; wStatusFlags3
	SET 6, (HL) ; BIT_TALKED_TO_TRAINER
	SET 7, (HL) ; BIT_PRINT_END_BATTLE_TEXT
	LD HL, $60F9 ; RivalDefeatedText
	LD DE, $60FE ; RivalVictoryText
	CALL $3354 ; SaveEndBattleTextPointers
	LD A, $F3 ; OPP_RIVAL3
	LD ($D059), A ; wCurOpponent
	LD A, ($D715) ; wRivalStarter
	CP $B1 ; STARTER2
	JR NZ, ChampionsRoomRivalReadyToBattleScript.notStarter2
	LD A, 1
	JR ChampionsRoomRivalReadyToBattleScript.saveTrainerId
ChampionsRoomRivalReadyToBattleScript.notStarter2:
	CP $99 ; STARTER3
	JR NZ, ChampionsRoomRivalReadyToBattleScript.notStarter3
	LD A, 2
	JR ChampionsRoomRivalReadyToBattleScript.saveTrainerId
ChampionsRoomRivalReadyToBattleScript.notStarter3:
	LD A, 3
ChampionsRoomRivalReadyToBattleScript.saveTrainerId:
	LD ($D05D), A ; wTrainerNo
	XOR A
	LDH ($B4), A ; hJoyHeld
	LD A, 3 ; SCRIPT_CHAMPIONSROOM_RIVAL_DEFEATED
	LD ($D64C), A
	RET
ChampionsRoomRivalReadyEnd:
.ASSERT ChampionsRoomRivalReadyEnd - ChampionsRoomRivalReadyToBattleScript == 81
