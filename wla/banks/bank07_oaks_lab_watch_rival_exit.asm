; Keep the player facing the rival while he leaves Oak's Lab.
OaksLabPlayerWatchRivalExitScript:
	LD A, ($D730) ; wStatusFlags5
	BIT 0, A ; BIT_SCRIPTED_NPC_MOVEMENT
	JR NZ, OaksLabPlayerWatchRivalExitScript.checkRivalPosition
	LD A, $2A ; TOGGLE_OAKS_LAB_RIVAL
	LD ($CC4D), A ; wToggleableObjectIndex
	LD A, $11 ; HideObject predef
	CALL $3E6D ; Predef
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	CALL $2307 ; PlayDefaultMusic
	LD A, $12 ; SCRIPT_OAKSLAB_NOOP
	LD ($D5F0), A ; wOaksLabCurScript
	JR OaksLabPlayerWatchRivalExitScript.done
OaksLabPlayerWatchRivalExitScript.checkRivalPosition:
	LD A, ($CF0F) ; wNPCNumScriptedSteps
	CP 5
	JR NZ, OaksLabPlayerWatchRivalExitScript.turnPlayerDown
	LD A, ($D362) ; wXCoord
	CP 4
	JR NZ, OaksLabPlayerWatchRivalExitScript.turnPlayerLeft
	LD A, $0C ; SPRITE_FACING_RIGHT
	LD ($C109), A ; wSpritePlayerStateData1FacingDirection
	JR OaksLabPlayerWatchRivalExitScript.done
OaksLabPlayerWatchRivalExitScript.turnPlayerLeft:
	LD A, 8 ; SPRITE_FACING_LEFT
	LD ($C109), A
	JR OaksLabPlayerWatchRivalExitScript.done
OaksLabPlayerWatchRivalExitScript.turnPlayerDown:
	CP 4
	RET NZ
	XOR A ; SPRITE_FACING_DOWN
	LD ($C109), A
OaksLabPlayerWatchRivalExitScript.done:
	RET
OaksLabPlayerWatchRivalExitEnd:
.ASSERT OaksLabPlayerWatchRivalExitEnd - OaksLabPlayerWatchRivalExitScript == 67
