Route2Gate_h:
	.DB $0C, $04, $05
	.DW $4090
	.DW Route2Gate_TextPointers
	.DW Route2Gate_Script
	.DB $00
	.DW Route2Gate_Object
Route2GateHeaderEnd:
.ASSERT Route2GateHeaderEnd - Route2Gate_h == 12
Route2Gate_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
Route2GateScriptEnd:
.ASSERT Route2GateScriptEnd - Route2Gate_Script == 3
Route2Gate_TextPointers:
	.DW Route2GateOaksAideText
	.DW Route2GateYoungsterText
Route2GateTextPointersEnd:
.ASSERT Route2GateTextPointersEnd - Route2Gate_TextPointers == 4
Route2GateOaksAideText:
	.DB $08
	LD A, ($D7C2)
	BIT 0, A ; EVENT_GOT_HM05
	JR NZ, Route2GateOaksAideText.got_item
	LD A, 10
	LDH ($DB), A ; hOaksAideRequirement
	LD A, $C8 ; HM_FLASH
	LDH ($DC), A ; hOaksAideRewardItem
	LD ($D11E), A ; wNamedObjectIndex
	CALL $2FCF ; GetItemName
	LD HL, $CD6D ; wNameBuffer
	LD DE, $CC5B ; wOaksAideRewardItemName
	LD BC, 13 ; ITEM_NAME_LENGTH
	CALL $00B5 ; CopyData
	LD A, $62 ; OaksAideScript predef
	CALL $3E6D
	LDH A, ($DB) ; hOaksAideResult
	CP 1 ; OAKS_AIDE_GOT_ITEM
	JR NZ, Route2GateOaksAideText.no_item
	LD HL, $D7C2
	SET 0, (HL) ; EVENT_GOT_HM05
Route2GateOaksAideText.got_item:
	LD HL, Route2GateOaksAideText.FlashExplanationText
	CALL $3C49 ; PrintText
Route2GateOaksAideText.no_item:
	JP $24D7 ; TextScriptEnd
Route2GateOaksAideText.FlashExplanationText:
	.DB $17
	.DW $67FC
	.DB $22, $50
Route2GateYoungsterText:
	.DB $17
	.DW $682C
	.DB $22, $50
Route2GateTextEnd:
.ASSERT Route2GateTextEnd - Route2GateOaksAideText == 69
; Object layout translated from data/maps/objects/Route2Gate.asm.
Route2Gate_Object:
	.DB $0A, $04
	.DB $00,$04,$03,$FF
	.DB $00,$05,$03,$FF
	.DB $07,$04,$04,$FF
	.DB $07,$05,$04,$FF
	.DB $00, $02
	.DB $20,$08,$05,$FF,$D2,$01
	.DB $04,$08,$09,$FE,$02,$02
	.DB $F6,$C6,$00,$04
	.DB $F6,$C6,$00,$05
	.DB $17,$C7,$07,$04
	.DB $17,$C7,$07,$05
Route2GateObjectEnd:
.ASSERT Route2GateObjectEnd - Route2Gate_Object == 48
