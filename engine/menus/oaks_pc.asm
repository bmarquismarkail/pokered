OpenOaksPC:
	call SaveScreenTilesToBuffer2
	ld hl, AccessedOaksPCText
	call PrintText
	ld hl, GetDexRatedText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, OpenOaksPC.closePC
	predef DisplayDexRating
OpenOaksPC.closePC
	ld hl, ClosedOaksPCText
	call PrintText
	jp LoadScreenTilesFromBuffer2

GetDexRatedText:
	text_far WLA_GLOBAL_GetDexRatedText
	text_end

ClosedOaksPCText:
	text_far WLA_GLOBAL_ClosedOaksPCText
	text_waitbutton
	text_end

AccessedOaksPCText:
	text_far WLA_GLOBAL_AccessedOaksPCText
	text_end
