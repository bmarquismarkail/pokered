; Native WLA-DX form of engine/events/cinnabar_lab.asm.
GiveFossilToCinnabarLab:
	LD HL, wStatusFlags5
	SET 6, (HL) ; BIT_NO_TEXT_DELAY
	XOR A
	LD (wCurrentMenuItem), A
	LD A, $03 ; PAD_A | PAD_B
	LD (wMenuWatchedKeys), A
	LD A, (wFilteredBagItemsCount)
	DEC A
	LD (wMaxMenuItem), A
	LD A, 2
	LD (wTopMenuItemY), A
	LD A, 1
	LD (wTopMenuItemX), A
	LD A, (wFilteredBagItemsCount)
	DEC A
	LD BC, 2
	LD HL, 3
	CALL AddNTimes
	DEC L
	LD B, L
	LD C, $0d
	LD HL, wTileMap
	CALL TextBoxBorder
	CALL UpdateSprites
	CALL PrintFossilsInBag
	LD HL, wStatusFlags5
	RES 6, (HL) ; BIT_NO_TEXT_DELAY
	CALL HandleMenuInput
	BIT 1, A ; B_PAD_B
	JR NZ, GiveFossilToCinnabarLab.cancelledGivingFossil
	LD HL, wFilteredBagItems
	LD A, (wCurrentMenuItem)
	LD D, 0
	LD E, A
	ADD HL, DE
	LD A, (HL)
	LDH ($db), A ; hItemToRemoveID
	CP $29 ; DOME_FOSSIL
	JR Z, GiveFossilToCinnabarLab.choseDomeFossil
	CP $2a ; HELIX_FOSSIL
	JR Z, GiveFossilToCinnabarLab.choseHelixFossil
	LD B, $ab ; AERODACTYL
	JR GiveFossilToCinnabarLab.fossilSelected
GiveFossilToCinnabarLab.choseHelixFossil:
	LD B, $62 ; OMANYTE
	JR GiveFossilToCinnabarLab.fossilSelected
GiveFossilToCinnabarLab.choseDomeFossil:
	LD B, $5a ; KABUTO
GiveFossilToCinnabarLab.fossilSelected:
	LD (wFossilItem), A
	LD A, B
	LD (wFossilMon), A
	CALL LoadFossilItemAndMonName
	LD HL, GiveFossilToCinnabarLab.ScientistSeesFossilText
	CALL PrintText
	CALL $35ec ; YesNoChoice
	LD A, (wCurrentMenuItem)
	AND A
	JR NZ, GiveFossilToCinnabarLab.cancelledGivingFossil
	LD HL, GiveFossilToCinnabarLab.ScientistTakesFossilText
	CALL PrintText
	LD A, (wFossilItem)
	LDH ($db), A ; hItemToRemoveID
	LD B, $05
	LD HL, $7f37 ; RemoveItemByID
	CALL Bankswitch
	LD HL, GiveFossilToCinnabarLab.GoForAWalkText
	CALL PrintText
	LD HL, wLabFossilEvents
	SET 0, (HL) ; EVENT_GAVE_FOSSIL_TO_LAB
	SET 1, (HL) ; EVENT_LAB_STILL_REVIVING_FOSSIL
	RET
GiveFossilToCinnabarLab.cancelledGivingFossil:
	LD HL, GiveFossilToCinnabarLab.ComeAgainText
	CALL PrintText
	RET

GiveFossilToCinnabarLab.ScientistSeesFossilText:
	.DB $17
	.DW $51d6
	.DB $28, $50
GiveFossilToCinnabarLab.ScientistTakesFossilText:
	.DB $17
	.DW $5259
	.DB $28, $50
GiveFossilToCinnabarLab.GoForAWalkText:
	.DB $17
	.DW $528f
	.DB $28, $50
GiveFossilToCinnabarLab.ComeAgainText:
	.DB $17
	.DW $52c6
	.DB $28, $50

PrintFossilsInBag:
	LD HL, wFilteredBagItems
	XOR A
	LDH ($db), A ; hItemCounter
PrintFossilsInBag.loop:
	LD A, (HL+)
	CP $ff
	RET Z
	PUSH HL
	LD (wNamedObjectIndex), A
	CALL $2fcf ; GetItemName
	LD HL, wTileMap + 2 * 20 + 2
	LDH A, ($db) ; hItemCounter
	LD BC, 20 * 2
	CALL AddNTimes
	LD DE, wNameBuffer
	CALL PlaceString
	LD HL, $ffdb ; hItemCounter
	INC (HL)
	POP HL
	JR PrintFossilsInBag.loop

LoadFossilItemAndMonName:
	LD A, (wFossilMon)
	LD (wNamedObjectIndex), A
	CALL GetMonName
	CALL $3826 ; CopyToStringBuffer
	LD A, (wFossilItem)
	LD (wNamedObjectIndex), A
	CALL $2fcf ; GetItemName
	RET
CinnabarLabFossilsEnd:
