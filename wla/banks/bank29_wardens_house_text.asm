WardensHouseWardenText:
	.DB $08 ; text_asm
	LD A, ($D78E)
	BIT 0, A ; EVENT_GOT_HM04
	JR NZ, WardensHouseWardenText.got_item
	LD B, $40 ; GOLD_TEETH
	CALL $3493 ; IsItemInBag
	JR NZ, WardensHouseWardenText.have_gold_teeth
	LD A, ($D78E)
	BIT 1, A ; EVENT_GAVE_GOLD_TEETH
	JR NZ, WardensHouseWardenText.gave_gold_teeth
	LD HL, WardensHouseWardenText.Gibberish1Text
	CALL $3C49 ; PrintText
	CALL $35EC ; YesNoChoice
	LD A, ($CC26) ; wCurrentMenuItem
	AND A
	LD HL, WardensHouseWardenText.Gibberish3Text
	JR NZ, WardensHouseWardenText.refused
	LD HL, WardensHouseWardenText.Gibberish2Text
WardensHouseWardenText.refused:
	CALL $3C49 ; PrintText
	JR WardensHouseWardenText.done
WardensHouseWardenText.have_gold_teeth:
	LD HL, WardensHouseWardenText.GaveTheGoldTeethText
	CALL $3C49 ; PrintText
	LD A, $40 ; GOLD_TEETH
	LDH ($DB), A ; hItemToRemoveID
	LD B, $05 ; BANK(RemoveItemByID)
	LD HL, $7F37 ; RemoveItemByID
	CALL $35D6 ; Bankswitch
	LD HL, $D78E
	SET 1, (HL) ; EVENT_GAVE_GOLD_TEETH
WardensHouseWardenText.gave_gold_teeth:
	LD HL, WardensHouseWardenText.ThanksText
	CALL $3C49 ; PrintText
	LD BC, $C701 ; HM_STRENGTH, 1
	CALL $3E2E ; GiveItem
	JR NC, WardensHouseWardenText.bag_full
	LD HL, WardensHouseWardenText.ReceivedHM04Text
	CALL $3C49 ; PrintText
	LD HL, $D78E
	SET 0, (HL) ; EVENT_GOT_HM04
	JR WardensHouseWardenText.done
WardensHouseWardenText.got_item:
	LD HL, WardensHouseWardenText.HM04ExplanationText
	CALL $3C49 ; PrintText
	JR WardensHouseWardenText.done
WardensHouseWardenText.bag_full:
	LD HL, WardensHouseWardenText.HM04NoRoomText
	CALL $3C49 ; PrintText
WardensHouseWardenText.done:
	JP $24D7 ; TextScriptEnd

WardensHouseWardenText.Gibberish1Text:
	.DB $17
	.DW $6444
	.DB $27,$50
WardensHouseWardenText.Gibberish2Text:
	.DB $17
	.DW $648B
	.DB $27,$50
WardensHouseWardenText.Gibberish3Text:
	.DB $17
	.DW $64B0
	.DB $27,$50
WardensHouseWardenText.GaveTheGoldTeethText:
	.DB $17
	.DW $64D2
	.DB $27,$0B
WardensHouseWardenText.PoppedInHisTeethText:
	.DB $17
	.DW $64F9
	.DB $27,$50
WardensHouseWardenText.ThanksText:
	.DB $17
	.DW $651B
	.DB $27,$50
WardensHouseWardenText.ReceivedHM04Text:
	.DB $17
	.DW $65A2
	.DB $27,$0B,$50
WardensHouseWardenText.HM04ExplanationText:
	.DB $17
	.DW $65B6
	.DB $27,$50
WardensHouseWardenText.HM04NoRoomText:
	.DB $17
	.DW $667A
	.DB $27,$50

WardensHouseDisplayText:
	.DB $08 ; text_asm
	LDH A, ($8C) ; hTextID
	CP 4 ; TEXT_WARDENSHOUSE_DISPLAY_LEFT
	LD HL, WardensHouseDisplayText.MerchandiseText
	JR NZ, WardensHouseDisplayText.print_text
	LD HL, WardensHouseDisplayText.PhotosAndFossilsText
WardensHouseDisplayText.print_text:
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
WardensHouseDisplayText.PhotosAndFossilsText:
	.DB $17
	.DW $6696
	.DB $27,$50
WardensHouseDisplayText.MerchandiseText:
	.DB $17
	.DW $66B0
	.DB $27,$50
WardensHouseTextEnd:
.ASSERT WardensHouseTextEnd - WardensHouseWardenText == 190
