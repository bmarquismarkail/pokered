CinnabarLabFossilRoom_h:
	.DB $14,$04,$04
	.DW CinnabarLabFossilRoom_Blocks
	.DW CinnabarLabFossilRoom_TextPointers
	.DW CinnabarLabFossilRoom_Script
	.DB $00
	.DW CinnabarLabFossilRoom_Object
CinnabarLabFossilRoomHeaderEnd:
.ASSERT CinnabarLabFossilRoomHeaderEnd - CinnabarLabFossilRoom_h == 12

CinnabarLabFossilRoom_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
CinnabarLabFossilRoomScriptEnd:
.ASSERT CinnabarLabFossilRoomScriptEnd - CinnabarLabFossilRoom_Script == 3

CinnabarLabFossilRoom_TextPointers:
	.DW CinnabarLabFossilRoomScientist1Text,CinnabarLabFossilRoomScientist2Text
CinnabarLabFossilRoomTextPointersEnd:
.ASSERT CinnabarLabFossilRoomTextPointersEnd - CinnabarLabFossilRoom_TextPointers == 4

Lab4Script_GetFossilsInBag:
	XOR A
	LD ($CD37), A ; wFilteredBagItemsCount
	LD DE, $CC5B ; wFilteredBagItems
	LD HL, FossilsList
Lab4Script_GetFossilsInBag.loop:
	LD A, (HL+)
	AND A
	JR Z, Lab4Script_GetFossilsInBag.done
	PUSH HL
	PUSH DE
	LD ($D11E), A ; wTempByteValue
	LD B, A
	LD A, $1C ; GetQuantityOfItemInBag predef
	CALL $3E6D ; Predef
	POP DE
	POP HL
	LD A, B
	AND A
	JR Z, Lab4Script_GetFossilsInBag.loop
	LD A, ($D11E)
	LD (DE), A
	INC DE
	PUSH HL
	LD HL, $CD37
	INC (HL)
	POP HL
	JR Lab4Script_GetFossilsInBag.loop
Lab4Script_GetFossilsInBag.done:
	LD A, $FF
	LD (DE), A
	RET
Lab4ScriptGetFossilsEnd:
.ASSERT Lab4ScriptGetFossilsEnd - Lab4Script_GetFossilsInBag == 48

FossilsList:
	.DB $29,$2A,$1F,$00
FossilsListEnd:
.ASSERT FossilsListEnd - FossilsList == 4

CinnabarLabFossilRoomScientist1Text:
	.DB $08 ; text_asm
	LD A, ($D7A3)
	BIT 0, A ; EVENT_GAVE_FOSSIL_TO_LAB
	JR NZ, CinnabarLabFossilRoomScientist1Text.checkDoneReviving
	LD HL, CinnabarLabFossilRoomScientist1Text.Text
	CALL $3C49 ; PrintText
	CALL Lab4Script_GetFossilsInBag
	LD A, ($CD37)
	AND A
	JR Z, CinnabarLabFossilRoomScientist1Text.noFossils
	LD B, $18
	LD HL, $5006 ; GiveFossilToCinnabarLab
	CALL $35D6 ; Bankswitch
	JR CinnabarLabFossilRoomScientist1Text.done
CinnabarLabFossilRoomScientist1Text.noFossils:
	LD HL, CinnabarLabFossilRoomScientist1Text.NoFossilsText
	CALL $3C49 ; PrintText
CinnabarLabFossilRoomScientist1Text.done:
	JP $24D7 ; TextScriptEnd
CinnabarLabFossilRoomScientist1Text.checkDoneReviving:
	BIT 1, A ; EVENT_LAB_STILL_REVIVING_FOSSIL
	JR Z, CinnabarLabFossilRoomScientist1Text.doneReviving
	LD HL, CinnabarLabFossilRoomScientist1Text.GoForAWalkText
	CALL $3C49 ; PrintText
	JR CinnabarLabFossilRoomScientist1Text.done
CinnabarLabFossilRoomScientist1Text.doneReviving:
	CALL LoadFossilItemAndMonNameBank1D
	LD HL, CinnabarLabFossilRoomScientist1Text.FossilIsBackToLifeText
	CALL $3C49 ; PrintText
	LD HL, $D7A3
	SET 2, (HL) ; EVENT_LAB_HANDING_OVER_FOSSIL_MON
	LD A, ($D710) ; wFossilMon
	LD B, A
	LD C, 30
	CALL $3E48 ; GivePokemon
	JR NC, CinnabarLabFossilRoomScientist1Text.done
	LD HL, $D7A3
	RES 0, (HL)
	RES 1, (HL)
	RES 2, (HL)
	JR CinnabarLabFossilRoomScientist1Text.done
CinnabarLabFossilRoomScientist1Text.Text:
	.DB $17
	.DW $50E8
	.DB $28,$50
CinnabarLabFossilRoomScientist1Text.NoFossilsText:
	.DB $17
	.DW $5145
	.DB $28,$50
CinnabarLabFossilRoomScientist1Text.GoForAWalkText:
	.DB $17
	.DW $5156
	.DB $28,$50
CinnabarLabFossilRoomScientist1Text.FossilIsBackToLifeText:
	.DB $17
	.DW $518D
	.DB $28,$50
CinnabarLabFossilRoomScientist1End:
.ASSERT CinnabarLabFossilRoomScientist1End - CinnabarLabFossilRoomScientist1Text == 110

CinnabarLabFossilRoomScientist2Text:
	.DB $08 ; text_asm
	LD A, 3 ; TRADE_FOR_SAILOR
	LD ($CD3D), A ; wWhichTrade
	LD A, $54 ; DoInGameTradeDialogue predef
	CALL $3E6D ; Predef
	JP $24D7 ; TextScriptEnd
CinnabarLabFossilRoomScientist2End:
.ASSERT CinnabarLabFossilRoomScientist2End - CinnabarLabFossilRoomScientist2Text == 14

LoadFossilItemAndMonNameBank1D:
	LD B, $18
	LD HL, $50EB ; LoadFossilItemAndMonName
	JP $35D6 ; Bankswitch
LoadFossilItemAndMonNameBank1DEnd:
.ASSERT LoadFossilItemAndMonNameBank1DEnd - LoadFossilItemAndMonNameBank1D == 8

CinnabarLabFossilRoom_Object:
	.DB $17,$02
	.DB $07,$02,$04,$A7,$07,$03,$04,$A7
	.DB $00,$02
	.DB $20,$06,$09,$FE,$02,$01
	.DB $20,$0A,$0B,$FF,$D1,$02
	.DB $12,$C7,$07,$02,$12,$C7,$07,$03
CinnabarLabFossilRoomObjectEnd:
.ASSERT CinnabarLabFossilRoomObjectEnd - CinnabarLabFossilRoom_Object == 32

CinnabarLabFossilRoom_Blocks:
.INCBIN "maps/CinnabarLabFossilRoom.blk"
CinnabarLabFossilRoomBlocksEnd:
.ASSERT CinnabarLabFossilRoomBlocksEnd - CinnabarLabFossilRoom_Blocks == 16
