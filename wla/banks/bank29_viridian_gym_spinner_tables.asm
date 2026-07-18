ViridianGym_ScriptPointers:
	.DW ViridianGymDefaultScript
	.DW $324C,$3275,ViridianGymGiovanniPostBattle,ViridianGymPlayerSpinningScript
ViridianGymScriptPointersEnd:
.ASSERT ViridianGymScriptPointersEnd - ViridianGym_ScriptPointers == 10
ViridianGymDefaultScript:
	LD A, ($D361)
	LD B, A
	LD A, ($D362)
	LD C, A
	LD HL, ViridianGymArrowTilePlayerMovement
	CALL $3442 ; DecodeArrowMovementRLE
	CP $FF
	JP Z, $3219 ; CheckFightingMapTrainers
	CALL $3486 ; StartSimulatingJoypadStates
	LD HL, $D736 ; wMovementFlags
	SET 7, (HL) ; BIT_SPINNING
	LD A, $A7 ; SFX_ARROW_TILES
	CALL $23B1 ; PlaySound
	LD A, $FF
	LD ($CD6B), A ; wJoyIgnore
	LD A, 4 ; SCRIPT_VIRIDIANGYM_PLAYER_SPINNING
	LD ($DA39), A
	RET
ViridianGymDefaultEnd:
.ASSERT ViridianGymDefaultEnd - ViridianGymDefaultScript == 43
ViridianGymArrowTilePlayerMovement:
	.DB $0B,$13
	.DW ViridianGymArrowMovement1
	.DB $01,$13
	.DW ViridianGymArrowMovement2
	.DB $02,$12
	.DW ViridianGymArrowMovement3
	.DB $02,$0B
	.DW ViridianGymArrowMovement4
	.DB $0A,$10
	.DW ViridianGymArrowMovement5
	.DB $06,$04
	.DW ViridianGymArrowMovement6
	.DB $0D,$05
	.DW ViridianGymArrowMovement7
	.DB $0E,$04
	.DW ViridianGymArrowMovement8
	.DB $0F,$00
	.DW ViridianGymArrowMovement9
	.DB $0F,$01
	.DW ViridianGymArrowMovement10
	.DB $10,$0D
	.DW ViridianGymArrowMovement11
	.DB $11,$0D
	.DW ViridianGymArrowMovement12
	.DB $FF
ViridianGymArrowTileMovementEnd:
.ASSERT ViridianGymArrowTileMovementEnd - ViridianGymArrowTilePlayerMovement == 49
ViridianGymArrowMovement1:
	.DB $40,$09,$FF
ViridianGymArrowMovement2:
	.DB $20,$08,$FF
ViridianGymArrowMovement3:
	.DB $80,$09,$FF
ViridianGymArrowMovement4:
	.DB $10,$06,$FF
ViridianGymArrowMovement5:
	.DB $80,$02,$FF
ViridianGymArrowMovement6:
	.DB $80,$07,$FF
ViridianGymArrowMovement7:
	.DB $10,$08,$FF
ViridianGymArrowMovement8:
	.DB $10,$09,$FF
ViridianGymArrowMovement9:
	.DB $40,$08,$FF
ViridianGymArrowMovement10:
	.DB $40,$06,$FF
ViridianGymArrowMovement11:
	.DB $20,$06,$FF
ViridianGymArrowMovement12:
	.DB $20,$0C,$FF
ViridianGymArrowMovementsEnd:
.ASSERT ViridianGymArrowMovementsEnd - ViridianGymArrowMovement1 == 36
