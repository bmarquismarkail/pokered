; Oak's Lab rival movement selection after the player chooses a starter.
OaksLabChoseStarterScript:
	LD A, ($D717) ; wPlayerStarter
	CP $B0 ; STARTER1
	JR Z, OaksLabChoseStarterScript.Charmander
	CP $B1 ; STARTER2
	JR Z, OaksLabChoseStarterScript.Squirtle
	JR OaksLabChoseStarterScript.Bulbasaur
OaksLabChoseStarterScript.Charmander:
	LD DE, OaksLabChoseStarterScript.MiddleBallMovement1
	LD A, ($D361) ; wYCoord
	CP 4
	JR Z, OaksLabChoseStarterScript.moveBlue
	LD DE, OaksLabChoseStarterScript.MiddleBallMovement2
	JR OaksLabChoseStarterScript.moveBlue

OaksLabChoseStarterScript.MiddleBallMovement1:
	.DB $00,$00,$C0,$C0,$C0,$40,$FF
OaksLabChoseStarterScript.MiddleBallMovement2:
	.DB $00,$C0,$C0,$C0,$FF

OaksLabChoseStarterScript.Squirtle:
	LD DE, OaksLabChoseStarterScript.RightBallMovement1
	LD A, ($D361) ; wYCoord
	CP 4
	JR Z, OaksLabChoseStarterScript.moveBlue
	LD DE, OaksLabChoseStarterScript.RightBallMovement2
	JR OaksLabChoseStarterScript.moveBlue

OaksLabChoseStarterScript.RightBallMovement1:
	.DB $00,$00,$C0,$C0,$C0,$C0,$40,$FF
OaksLabChoseStarterScript.RightBallMovement2:
	.DB $00,$C0,$C0,$C0,$C0,$FF

OaksLabChoseStarterScript.Bulbasaur:
	LD DE, OaksLabChoseStarterScript.LeftBallMovement1
	LD A, ($D362) ; wXCoord
	CP 9
	JR NZ, OaksLabChoseStarterScript.moveBlue
	PUSH HL
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A ; hSpriteIndex
	LD A, 4 ; SPRITESTATEDATA1_YPIXELS
	LDH ($8B), A ; hSpriteDataOffset
	CALL $34FC ; GetPointerWithinSpriteStateData1
	PUSH HL
	LD (HL), $4C
	INC HL
	INC HL
	LD (HL), 0
	POP HL
	INC H
	LD (HL), 8 ; SPRITESTATEDATA2_MAPY
	INC HL
	LD (HL), 9 ; SPRITESTATEDATA2_MAPX
	LD DE, OaksLabChoseStarterScript.LeftBallMovement2
	POP HL
	JR OaksLabChoseStarterScript.moveBlue

OaksLabChoseStarterScript.LeftBallMovement1:
	.DB $00,$C0
OaksLabChoseStarterScript.LeftBallMovement2:
	.DB $C0,$FF

OaksLabChoseStarterScript.moveBlue:
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A ; hSpriteIndex
	CALL $363A ; MoveSprite
	LD A, 9 ; SCRIPT_OAKSLAB_RIVAL_CHOOSES_STARTER
	LD ($D5F0), A ; wOaksLabCurScript
	RET
OaksLabChoseStarterEnd:
.ASSERT OaksLabChoseStarterEnd - OaksLabChoseStarterScript == 128
