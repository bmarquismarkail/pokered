; Native WLA-DX form of engine/events/diploma.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"

DisplayDiploma:
	CALL SaveScreenTilesToBuffer2
	CALL GBPalWhiteOutWithDelay3
	CALL ClearScreen
	XOR A
	LD (wUpdateSpritesEnabled), A
	LD HL, wStatusFlags5
	SET 6, (HL) ; BIT_NO_TEXT_DELAY
	CALL DisableLCD
	LD HL, $7d88 ; CircleTile
	LD DE, $9700 ; vChars2 tile $70
	LD BC, 16
	LD A, $0b ; BANK(CircleTile)
	CALL FarCopyData2
	LD HL, wTileMap
	LD BC, $1012 ; 16 rows, 18 columns
	LD A, $27 ; Diploma_TextBoxBorder predef
	CALL Predef
	LD HL, DiplomaTextPointersAndCoords
	LD C, 5
DisplayDiploma.placeTextLoop:
	PUSH BC
	LD A, (HL+)
	LD E, A
	LD A, (HL+)
	LD D, A
	LD A, (HL+)
	PUSH HL
	LD H, (HL)
	LD L, A
	CALL PlaceString
	POP HL
	INC HL
	POP BC
	DEC C
	JR NZ, DisplayDiploma.placeTextLoop
	LD HL, wTileMap + 4 * 20 + 10
	LD DE, wPlayerName
	CALL PlaceString
	LD B, $01
	LD HL, $44dd ; DrawPlayerCharacter
	CALL Bankswitch
	LD HL, wShadowOAMSprite00XCoord
	LD BC, $8028
DisplayDiploma.adjustPlayerGfxLoop:
	LD A, (HL)
	ADD 33
	LD (HL+), A
	INC HL
	LD A, B
	LD (HL+), A
	INC HL
	DEC C
	JR NZ, DisplayDiploma.adjustPlayerGfxLoop
	CALL EnableLCD
	LD B, $01
	LD HL, $5ae6 ; LoadTrainerInfoTextBoxTiles
	CALL Bankswitch
	LD B, $08 ; SET_PAL_GENERIC
	CALL RunPaletteCommand
	CALL Delay3
	CALL GBPalNormal
	LD A, $90
	LDH ($48), A ; rOBP0
	CALL WaitForTextScrollButtonPress
	LD HL, wStatusFlags5
	RES 6, (HL) ; BIT_NO_TEXT_DELAY
	CALL GBPalWhiteOutWithDelay3
	CALL $3dbe ; RestoreScreenTilesAndReloadTilePatterns
	CALL Delay3
	JP GBPalNormal

UnusedPlayerNameLengthFunc:
	LD HL, wPlayerName
	LD BC, $ff00
UnusedPlayerNameLengthFunc.loop:
	LD A, (HL+)
	CP $50 ; "@"
	RET Z
	DEC C
	JR UnusedPlayerNameLengthFunc.loop

DiplomaTextPointersAndCoords:
	.DW DiplomaText, wTileMap + 2 * 20 + 5
	.DW DiplomaPlayer, wTileMap + 4 * 20 + 3
	.DW DiplomaEmptyText, wTileMap + 4 * 20 + 15
	.DW DiplomaCongrats, wTileMap + 6 * 20 + 2
	.DW DiplomaGameFreak, wTileMap + 16 * 20 + 9

DiplomaText:
	.DB $70
	.STRINGMAP pokemon, "Diploma"
	.DB $70, $50
DiplomaPlayer:
	.STRINGMAP pokemon, "Player"
	.DB $50
DiplomaEmptyText:
	.DB $50
DiplomaCongrats:
	.STRINGMAP pokemon, "Congrats! This"
	.DB $4e
	.STRINGMAP pokemon, "diploma certifies"
	.DB $4e
	.STRINGMAP pokemon, "that you have"
	.DB $4e
	.STRINGMAP pokemon, "completed your"
	.DB $4e
	.STRINGMAP pokemon, "#DEX."
	.DB $50
DiplomaGameFreak:
	.STRINGMAP pokemon, "GAME FREAK"
	.DB $50
DiplomaEnd:
