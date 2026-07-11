; Native WLA-DX form of decrement_pp.asm and the Red version graphic.
DecrementPP:
	LD A, (DE)
	CP $a5 ; STRUGGLE
	RET Z
	LD HL, wPlayerBattleStatus1
	LD A, (HL+)
	AND $07
	RET NZ
	BIT 6, (HL) ; USING_RAGE
	RET NZ
	LD HL, wBattleMonPP
	CALL DecrementPPAtIndex
	LD A, (wPlayerBattleStatus3)
	BIT 3, A ; TRANSFORMED
	RET NZ
	LD HL, wPartyMon1PP
	LD A, (wPlayerMonNumber)
	LD BC, 44 ; PARTYMON_STRUCT_LENGTH
	CALL AddNTimes
DecrementPPAtIndex:
	LD A, (wPlayerMoveListIndex)
	LD C, A
	LD B, 0
	ADD HL, BC
	DEC (HL)
	RET
Version_GFX:
	.INCBIN "gfx/title/red_version.1bpp"
Version_GFXEnd:
BattleEngine11End:
