; Rival returns to Oak for the Pokédex request.
OaksLabRivalArrivesAtOaksRequestScript:
	XOR A
	LDH ($B4), A ; hJoyHeld
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD A, $FF ; SFX_STOP_ALL_MUSIC
	LD ($C0EE), A ; wNewSoundID
	CALL $23B1 ; PlaySound
	LD B, 2 ; BANK(Music_RivalAlternateStart)
	LD HL, $5B47 ; Music_RivalAlternateStart
	CALL $35D6 ; Bankswitch
	LD A, $15 ; TEXT_OAKSLAB_RIVAL_GRAMPS
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	CALL $502B ; OaksLabCalcRivalMovementScript
	LD A, $2A ; TOGGLE_OAKS_LAB_RIVAL
	LD ($CC4D), A ; wToggleableObjectIndex
	LD A, $15 ; ShowObject predef
	CALL $3E6D ; Predef
	LD A, ($CD37) ; wNPCMovementDirections2Index
	LD ($D157), A ; wSavedNPCMovementDirections2Index
	LD B, 0
	LD C, A
	LD HL, $CC97 ; wNPCMovementDirections2
	LD A, $40 ; NPC_MOVEMENT_UP
	CALL $36E0 ; FillMemory
	LD (HL), $FF
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A ; hSpriteIndex
	LD DE, $CC97
	CALL $363A ; MoveSprite
	LD A, $10 ; SCRIPT_OAKSLAB_OAK_GIVES_POKEDEX
	LD ($D5F0), A ; wOaksLabCurScript
	RET
OaksLabRivalArrivesAtRequestEnd:
.ASSERT OaksLabRivalArrivesAtRequestEnd - OaksLabRivalArrivesAtOaksRequestScript == 77

OaksLabRivalFaceUpOakFaceDownScript:
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A ; hSpriteIndex
	LD A, 4 ; SPRITE_FACING_UP
	LDH ($8D), A ; hSpriteFacingDirection
	CALL $34A6 ; SetSpriteFacingDirectionAndDelay
	LD A, 8 ; OAKSLAB_OAK2
	LDH ($8C), A
	XOR A ; SPRITE_FACING_DOWN
	LDH ($8D), A
	JP $34A6
OaksLabRivalFaceUpOakFaceDownEnd:
.ASSERT OaksLabRivalFaceUpOakFaceDownEnd - OaksLabRivalFaceUpOakFaceDownScript == 21
