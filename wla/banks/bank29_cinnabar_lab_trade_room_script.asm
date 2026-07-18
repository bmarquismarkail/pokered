CinnabarLabTradeRoom_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
CinnabarLabTradeRoomScriptEnd:
.ASSERT CinnabarLabTradeRoomScriptEnd - CinnabarLabTradeRoom_Script == 3

CinnabarLabTradeRoom_TextPointers:
	.DW CinnabarLabTradeRoomSuperNerdText,CinnabarLabTradeRoomGrampsText,CinnabarLabTradeRoomBeautyText
CinnabarLabTradeRoomTextPointersEnd:
.ASSERT CinnabarLabTradeRoomTextPointersEnd - CinnabarLabTradeRoom_TextPointers == 6

CinnabarLabTradeRoomSuperNerdText:
	.DB $17
	.DW $4EB5
	.DB $28,$50
CinnabarLabTradeRoomGrampsText:
	.DB $08 ; text_asm
	LD A, 7 ; TRADE_FOR_DORIS
	LD ($CD3D), A ; wWhichTrade
	JR CinnabarLabTradeRoomDoTrade
CinnabarLabTradeRoomBeautyText:
	.DB $08 ; text_asm
	LD A, 8 ; TRADE_FOR_CRINKLES
	LD ($CD3D), A ; wWhichTrade
CinnabarLabTradeRoomDoTrade:
	LD A, $54 ; DoInGameTradeDialogue predef
	CALL $3E6D ; Predef
	JP $24D7 ; TextScriptEnd
CinnabarLabTradeRoomTextsEnd:
.ASSERT CinnabarLabTradeRoomTextsEnd - CinnabarLabTradeRoomSuperNerdText == 27
