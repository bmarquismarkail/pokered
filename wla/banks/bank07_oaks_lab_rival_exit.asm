; Oak's Lab rival exit setup and movement list.
OaksLabRivalStartsExitScript:
	LD C, 20
	CALL $3739 ; DelayFrames
	LD A, $10 ; TEXT_OAKSLAB_RIVAL_SMELL_YOU_LATER
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD B, 2 ; BANK(Music_RivalAlternateStart)
	LD HL, $5B47 ; Music_RivalAlternateStart
	CALL $35D6 ; Bankswitch
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A ; hSpriteIndex
	LD DE, OaksLabRivalStartsExitScript.RivalExitMovement
	CALL $363A ; MoveSprite
	LD A, ($D362) ; wXCoord
	CP 4
	JR NZ, OaksLabRivalStartsExitScript.moveLeft
	LD A, $C0 ; NPC_MOVEMENT_RIGHT
	JR OaksLabRivalStartsExitScript.next
OaksLabRivalStartsExitScript.moveLeft:
	LD A, $80 ; NPC_MOVEMENT_LEFT
OaksLabRivalStartsExitScript.next:
	LD ($CC5B), A ; wNPCMovementDirections
	LD A, $0E ; SCRIPT_OAKSLAB_PLAYER_WATCH_RIVAL_EXIT
	LD ($D5F0), A ; wOaksLabCurScript
	RET
OaksLabRivalStartsExitEnd:
.ASSERT OaksLabRivalStartsExitEnd - OaksLabRivalStartsExitScript == 52

OaksLabRivalStartsExitScript.RivalExitMovement:
	.DB $E0,$00,$00,$00,$00,$00,$FF
OaksLabRivalExitMovementEnd:
.ASSERT OaksLabRivalExitMovementEnd - OaksLabRivalStartsExitScript.RivalExitMovement == 7
