PrintWaitingText:
	hlcoord 3, 10
	ld b, 1
	ld c, 11
	ld a, [wIsInBattle]
	and a
	jr z, PrintWaitingText.trade
; battle
	call TextBoxBorder
	jr PrintWaitingText.border_done
PrintWaitingText.trade
	call CableClub_TextBoxBorder
PrintWaitingText.border_done
	hlcoord 4, 11
	ld de, WaitingText
	call PlaceString
	ld c, 50
	jp DelayFrames

WaitingText:
		.STRINGMAP pokemon, "Waiting...!@"
