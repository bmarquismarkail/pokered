; Oak's Lab player-entry and starter-choice introduction states.
OaksLabPlayerEntersLabScript:
	CALL $3DD7 ; Delay3
	LD HL, $CCD3 ; wSimulatedJoypadStatesEnd
	LD DE, PlayerEntryMovementRLE
	CALL $350C ; DecodeRLEList
	DEC A
	LD ($CD38), A ; wSimulatedJoypadStatesIndex
	CALL $3486 ; StartSimulatingJoypadStates
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A ; hSpriteIndex
	XOR A
	LDH ($8D), A ; hSpriteFacingDirection
	CALL $34A6 ; SetSpriteFacingDirectionAndDelay
	LD A, 5 ; OAKSLAB_OAK1
	LDH ($8C), A
	XOR A
	LDH ($8D), A
	CALL $34A6
	LD A, 4 ; SCRIPT_OAKSLAB_FOLLOWED_OAK
	LD ($D5F0), A ; wOaksLabCurScript
	RET
OaksLabPlayerEntersEnd:
.ASSERT OaksLabPlayerEntersEnd - OaksLabPlayerEntersLabScript == 45

PlayerEntryMovementRLE:
	.DB $40,$08,$FF ; PAD_UP, 8, end
PlayerEntryMovementRLEEnd:
.ASSERT PlayerEntryMovementRLEEnd - PlayerEntryMovementRLE == 3

OaksLabFollowedOakScript:
	LD A, ($CD38) ; wSimulatedJoypadStatesIndex
	AND A
	RET NZ
	LD HL, $D747
	SET 0, (HL) ; EVENT_FOLLOWED_OAK_INTO_LAB
	LD HL, $D74B
	SET 0, (HL) ; EVENT_FOLLOWED_OAK_INTO_LAB_2
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A ; hSpriteIndex
	LD A, 4 ; SPRITE_FACING_UP
	LDH ($8D), A ; hSpriteFacingDirection
	CALL $34A6 ; SetSpriteFacingDirectionAndDelay
	CALL $2429 ; UpdateSprites
	LD HL, $D733 ; wStatusFlags7
	RES 1, (HL) ; BIT_NO_MAP_MUSIC
	CALL $2307 ; PlayDefaultMusic
	LD A, 5 ; SCRIPT_OAKSLAB_OAK_CHOOSE_MON_SPEECH
	LD ($D5F0), A
	RET
OaksLabFollowedOakEnd:
.ASSERT OaksLabFollowedOakEnd - OaksLabFollowedOakScript == 43

OaksLabOakChooseMonSpeechScript:
	LD A, $FC ; PAD_SELECT | PAD_START | PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
	LD A, $11 ; TEXT_OAKSLAB_RIVAL_FED_UP_WITH_WAITING
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	CALL $3DD7 ; Delay3
	LD A, $12 ; TEXT_OAKSLAB_OAK_CHOOSE_MON
	LDH ($8C), A
	CALL $2920
	CALL $3DD7
	LD A, $13 ; TEXT_OAKSLAB_RIVAL_WHAT_ABOUT_ME
	LDH ($8C), A
	CALL $2920
	CALL $3DD7
	LD A, $14 ; TEXT_OAKSLAB_OAK_BE_PATIENT
	LDH ($8C), A
	CALL $2920
	LD HL, $D74B
	SET 1, (HL) ; EVENT_OAK_ASKED_TO_CHOOSE_MON
	XOR A
	LD ($CD6B), A
	LD A, 6 ; SCRIPT_OAKSLAB_PLAYER_DONT_GO_AWAY_SCRIPT
	LD ($D5F0), A
	RET
OaksLabOakChooseMonSpeechEnd:
.ASSERT OaksLabOakChooseMonSpeechEnd - OaksLabOakChooseMonSpeechScript == 57
