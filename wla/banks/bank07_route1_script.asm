; Native WLA-DX form of scripts/Route1.asm.
Route1_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
Route1ScriptEnd:
.ASSERT Route1ScriptEnd - Route1_Script == 3

Route1_TextPointers:
	.DW Route1Youngster1Text,Route1Youngster2Text,Route1SignText
Route1TextPointersEnd:
.ASSERT Route1TextPointersEnd - Route1_TextPointers == 6

Route1Youngster1Text:
	.DB $08 ; text_asm
	LD HL, $D7BF
	BIT 0, (HL) ; EVENT_GOT_POTION_SAMPLE
	SET 0, (HL)
	JR NZ, Route1Youngster1Text.got_item
	LD HL, Route1Youngster1Text.MartSampleText
	CALL $3C49 ; PrintText
	LD BC, $1401 ; POTION, 1
	CALL $3E2E ; GiveItem
	JR NC, Route1Youngster1Text.bag_full
	LD HL, Route1Youngster1Text.GotPotionText
	JR Route1Youngster1Text.done
Route1Youngster1Text.bag_full:
	LD HL, Route1Youngster1Text.NoRoomText
	JR Route1Youngster1Text.done
Route1Youngster1Text.got_item:
	LD HL, Route1Youngster1Text.AlsoGotPokeballsText
Route1Youngster1Text.done:
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
Route1Youngster1TextEnd:
.ASSERT Route1Youngster1TextEnd - Route1Youngster1Text == 43

Route1Youngster1Text.MartSampleText:
	.DB $17
	.DW $55BF
	.DB $23,$50
Route1Youngster1Text.GotPotionText:
	.DB $17
	.DW $5643
	.DB $23,$0B,$50 ; sound_get_item_1, text_end
Route1Youngster1Text.AlsoGotPokeballsText:
	.DB $17
	.DW $5652
	.DB $23,$50
Route1Youngster1Text.NoRoomText:
	.DB $17
	.DW $567C
	.DB $23,$50
Route1Youngster2Text:
	.DB $17
	.DW $569F
	.DB $23,$50
Route1SignText:
	.DB $17
	.DW $5720
	.DB $23,$50
Route1TextRecordsEnd:
.ASSERT Route1TextRecordsEnd - Route1Youngster1Text.MartSampleText == 31
