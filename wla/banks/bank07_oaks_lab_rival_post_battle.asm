; Oak's Lab post-rival-battle recovery state.
OaksLabRivalEndBattleScript:
	LD A, $F0 ; PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
	LD A, 8 ; PLAYER_DIR_UP
	LD ($D528), A ; wPlayerMovingDirection
	CALL $2429 ; UpdateSprites
	LD A, 1 ; OAKSLAB_RIVAL
	LD ($CF13), A ; wSpriteIndex
	CALL $32F9 ; SetSpritePosition1
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A ; hSpriteIndex
	XOR A ; SPRITE_FACING_DOWN
	LDH ($8D), A ; hSpriteFacingDirection
	CALL $34A6 ; SetSpriteFacingDirectionAndDelay
	LD A, 7 ; HealParty predef
	CALL $3E6D ; Predef
	LD HL, $D74B
	SET 3, (HL) ; EVENT_BATTLED_RIVAL_IN_OAKS_LAB
	LD A, $0D ; SCRIPT_OAKSLAB_RIVAL_STARTS_EXIT
	LD ($D5F0), A ; wOaksLabCurScript
	RET
OaksLabRivalEndBattleEnd:
.ASSERT OaksLabRivalEndBattleEnd - OaksLabRivalEndBattleScript == 47
