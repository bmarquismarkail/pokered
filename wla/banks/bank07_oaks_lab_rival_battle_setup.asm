; Initial rival battle setup from scripts/OaksLab.asm.
OaksLabRivalStartBattleScript:
	LD A, ($D730) ; wStatusFlags5
	BIT 0, A ; BIT_SCRIPTED_NPC_MOVEMENT
	RET NZ
	LD A, $E1 ; OPP_RIVAL1
	LD ($D059), A ; wCurOpponent
	LD A, ($D715) ; wRivalStarter
	CP $B1 ; STARTER2
	JR NZ, OaksLabRivalStartBattleScript.not_squirtle
	LD A, 1
	JR OaksLabRivalStartBattleScript.done
OaksLabRivalStartBattleScript.not_squirtle:
	CP $99 ; STARTER3
	JR NZ, OaksLabRivalStartBattleScript.not_bulbasaur
	LD A, 2
	JR OaksLabRivalStartBattleScript.done
OaksLabRivalStartBattleScript.not_bulbasaur:
	LD A, 3
OaksLabRivalStartBattleScript.done:
	LD ($D05D), A ; wTrainerNo
	LD A, 1 ; OAKSLAB_RIVAL
	LD ($CF13), A ; wSpriteIndex
	CALL $32EF ; GetSpritePosition1
	LD HL, $53BE ; OaksLabRivalIPickedTheWrongPokemonText
	LD DE, $53C3 ; OaksLabRivalAmIGreatOrWhatText
	CALL $3354 ; SaveEndBattleTextPointers
	LD HL, $D72D ; wStatusFlags3
	SET 6, (HL) ; BIT_TALKED_TO_TRAINER
	SET 7, (HL) ; BIT_PRINT_END_BATTLE_TEXT
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD A, 8 ; PLAYER_DIR_UP
	LD ($D528), A ; wPlayerMovingDirection
	LD A, $0C ; SCRIPT_OAKSLAB_RIVAL_END_BATTLE
	LD ($D5F0), A ; wOaksLabCurScript
	RET
OaksLabRivalStartBattleEnd:
.ASSERT OaksLabRivalStartBattleEnd - OaksLabRivalStartBattleScript == 74
