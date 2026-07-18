ChampionsRoomRivalDefeatedScript:
	LD A, ($D057) ; wIsInBattle
	CP $FF
	JP Z, ResetRivalScript
	CALL $2429 ; UpdateSprites
	LD HL, $D867
	SET 1, (HL) ; EVENT_BEAT_CHAMPION_RIVAL
	LD A, $F0 ; PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
	LD A, 1 ; TEXT_CHAMPIONSROOM_RIVAL
	LDH ($8C), A ; hTextID
	CALL ChampionsRoom_DisplayTextID_AllowABSelectStart
	LD A, 1 ; CHAMPIONSROOM_RIVAL
	LDH ($8C), A ; hSpriteIndex
	CALL $3541 ; SetSpriteMovementBytesToFF
	LD A, 4 ; SCRIPT_CHAMPIONSROOM_OAK_ARRIVES
	LD ($D64C), A
	RET
ChampionsRoomRivalDefeatedEnd:
.ASSERT ChampionsRoomRivalDefeatedEnd - ChampionsRoomRivalDefeatedScript == 41

ChampionsRoomOakArrivesScript:
	LD B, $02
	LD HL, $5B81 ; Music_Cities1AlternateTempo
	CALL $35D6 ; Bankswitch
	LD A, 2 ; TEXT_CHAMPIONSROOM_OAK
	LDH ($8C), A
	CALL ChampionsRoom_DisplayTextID_AllowABSelectStart
	LD A, 2 ; CHAMPIONSROOM_OAK
	LDH ($8C), A
	CALL $3541 ; SetSpriteMovementBytesToFF
	LD DE, OakEntranceAfterVictoryMovement
	LD A, 2
	LDH ($8C), A
	CALL $363A ; MoveSprite
	LD A, $D6 ; TOGGLE_CHAMPIONS_ROOM_OAK
	LD ($CC4D), A ; wToggleableObjectIndex
	LD A, $15 ; ShowObject predef
	CALL $3E6D ; Predef
	LD A, 5 ; SCRIPT_CHAMPIONSROOM_OAK_CONGRATULATES_PLAYER
	LD ($D64C), A
	RET
ChampionsRoomOakArrivesEnd:
.ASSERT ChampionsRoomOakArrivesEnd - ChampionsRoomOakArrivesScript == 48

OakEntranceAfterVictoryMovement:
	.DB $40,$40,$40,$40,$40,$FF
OakEntranceAfterVictoryMovementEnd:
.ASSERT OakEntranceAfterVictoryMovementEnd - OakEntranceAfterVictoryMovement == 6
