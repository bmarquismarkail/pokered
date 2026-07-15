; Jigglypuff interaction, song animation, and supporting data.
PewterPokecenterJigglypuffText:
	.DB $08 ; text_asm
	LD A, $01
	LD ($CC3C), A ; wDoNotWaitForButtonPressAfterDisplayingText
	LD HL, PewterPokecenterJigglypuffText.Text
	CALL PrintText
	LD A, $FF ; SFX_STOP_ALL_MUSIC
	CALL $23B1 ; PlaySound
	LD C, 32
	CALL $3739 ; DelayFrames

	LD HL, PewterPokecenterJigglypuffText.FacingDirections
	LD DE, $CD3F ; wJigglypuffFacingDirections
	LD BC, 4
	CALL $00B5 ; CopyData
	LD A, ($C132) ; wSprite03StateData1ImageIndex
	LD HL, $CD3F
PewterPokecenterJigglypuffText.findMatchingFacingDirectionLoop:
	CP (HL)
	INC HL
	JR NZ, PewterPokecenterJigglypuffText.findMatchingFacingDirectionLoop
	DEC HL

	PUSH HL
	LD C, $1F ; BANK(Music_JigglypuffSong)
	LD A, $D0 ; MUSIC_JIGGLYPUFF_SONG
	CALL $23A1 ; PlayMusic
	POP HL
PewterPokecenterJigglypuffText.spinMovementLoop:
	LD A, (HL)
	LD ($C132), A
	PUSH HL
	LD HL, $CD3F
	LD DE, $CD3E
	LD BC, 4
	CALL $00B5 ; CopyData
	LD A, ($CD3E)
	LD ($CD42), A
	POP HL
	LD C, 24
	CALL $3739 ; DelayFrames
	LD A, ($C026) ; wChannelSoundIDs
	LD B, A
	LD A, ($C027) ; channel 2
	OR B
	JR NZ, PewterPokecenterJigglypuffText.spinMovementLoop
	LD C, 48
	CALL $3739 ; DelayFrames
	CALL $2307 ; PlayDefaultMusic
	JP $24D7 ; TextScriptEnd

PewterPokecenterJigglypuffText.Text:
	.DB $17
	.DW $4744 ; _PewterPokecenterJigglypuffText
	.DB $26, $50
PewterPokecenterJigglypuffText.FacingDirections:
	.DB $30, $38, $34, $3C
PewterPokecenterJigglypuffText.FacingDirectionsEnd:
PewterPokecenterJigglypuffTextEnd:
.ASSERT PewterPokecenterJigglypuffTextEnd - PewterPokecenterJigglypuffText == 113
