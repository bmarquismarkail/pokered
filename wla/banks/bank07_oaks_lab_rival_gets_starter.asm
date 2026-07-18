; Rival starter acquisition state from scripts/OaksLab.asm.
OaksLabRivalChoosesStarterScript:
	LD A, ($D730) ; wStatusFlags5
	BIT 0, A ; BIT_SCRIPTED_NPC_MOVEMENT
	RET NZ
	LD A, $FC ; PAD_SELECT | PAD_START | PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A ; hSpriteIndex
	LD A, 4 ; SPRITE_FACING_UP
	LDH ($8D), A ; hSpriteFacingDirection
	CALL $34A6 ; SetSpriteFacingDirectionAndDelay
	LD A, $0D ; TEXT_OAKSLAB_RIVAL_ILL_TAKE_THIS_ONE
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD A, ($CD3E) ; wRivalStarterBallSpriteIndex
	CP 2 ; OAKSLAB_CHARMANDER_POKE_BALL
	JR NZ, OaksLabRivalChoosesStarterScript.not_charmander
	LD A, $2B ; TOGGLE_STARTER_BALL_1
	JR OaksLabRivalChoosesStarterScript.hideBallAndContinue
OaksLabRivalChoosesStarterScript.not_charmander:
	CP 3 ; OAKSLAB_SQUIRTLE_POKE_BALL
	JR NZ, OaksLabRivalChoosesStarterScript.not_squirtle
	LD A, $2C ; TOGGLE_STARTER_BALL_2
	JR OaksLabRivalChoosesStarterScript.hideBallAndContinue
OaksLabRivalChoosesStarterScript.not_squirtle:
	LD A, $2D ; TOGGLE_STARTER_BALL_3
OaksLabRivalChoosesStarterScript.hideBallAndContinue:
	LD ($CC4D), A ; wToggleableObjectIndex
	LD A, $11 ; HideObject predef
	CALL $3E6D ; Predef
	CALL $3DD7 ; Delay3
	LD A, ($CD3D) ; wRivalStarterTemp
	LD ($D715), A ; wRivalStarter
	LD ($CF91), A ; wCurPartySpecies
	LD ($D11E), A ; wNamedObjectIndex
	CALL $2F9E ; GetMonName
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A
	LD A, 4 ; SPRITE_FACING_UP
	LDH ($8D), A
	CALL $34A6
	LD A, $0E ; TEXT_OAKSLAB_RIVAL_RECEIVED_MON
	LDH ($8C), A
	CALL $2920
	LD HL, $D74B
	SET 2, (HL) ; EVENT_GOT_STARTER
	XOR A
	LD ($CD6B), A
	LD A, $0A ; SCRIPT_OAKSLAB_RIVAL_CHALLENGES_PLAYER
	LD ($D5F0), A ; wOaksLabCurScript
	RET
OaksLabRivalChoosesStarterEnd:
.ASSERT OaksLabRivalChoosesStarterEnd - OaksLabRivalChoosesStarterScript == 109
