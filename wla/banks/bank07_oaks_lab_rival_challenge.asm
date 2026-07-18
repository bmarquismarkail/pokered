; Rival challenge approach state from scripts/OaksLab.asm.
OaksLabRivalChallengesPlayerScript:
	LD A, ($D361) ; wYCoord
	CP 6
	RET NZ
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A ; hSpriteIndex
	XOR A ; SPRITE_FACING_DOWN
	LDH ($8D), A ; hSpriteFacingDirection
	CALL $34A6 ; SetSpriteFacingDirectionAndDelay
	LD A, 8 ; PLAYER_DIR_UP
	LD ($D528), A ; wPlayerMovingDirection
	LD C, 2 ; BANK(Music_MeetRival)
	LD A, $DE ; MUSIC_MEET_RIVAL
	CALL $23A1 ; PlayMusic
	LD A, $0F ; TEXT_OAKSLAB_RIVAL_ILL_TAKE_YOU_ON
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD A, 1
	LDH ($9B), A ; hNPCPlayerRelativePosPerspective
	LD A, 1
	SWAP A
	LDH ($95), A ; hNPCSpriteOffset
	LD A, $22 ; CalcPositionOfPlayerRelativeToNPC predef
	CALL $3E6D ; Predef
	LDH A, ($95) ; hNPCPlayerYDistance
	DEC A
	LDH ($95), A
	LD A, $20 ; FindPathToPlayer predef
	CALL $3E6D
	LD DE, $CC97 ; wNPCMovementDirections2
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A
	CALL $363A ; MoveSprite
	LD A, $0B ; SCRIPT_OAKSLAB_RIVAL_START_BATTLE
	LD ($D5F0), A ; wOaksLabCurScript
	RET
OaksLabRivalChallengesPlayerEnd:
.ASSERT OaksLabRivalChallengesPlayerEnd - OaksLabRivalChallengesPlayerScript == 76
