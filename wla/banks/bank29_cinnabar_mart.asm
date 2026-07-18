CinnabarMart_h:
	.DB $02,$04,$04
	.DW CinnabarMart_Blocks
	.DW CinnabarMart_TextPointers
	.DW CinnabarMart_Script
	.DB $00
	.DW CinnabarMart_Object
CinnabarMartHeaderEnd:
.ASSERT CinnabarMartHeaderEnd - CinnabarMart_h == 12

CinnabarMart_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
CinnabarMartScriptEnd:
.ASSERT CinnabarMartScriptEnd - CinnabarMart_Script == 3

CinnabarMart_TextPointers:
	.DW $24B9 ; CinnabarMartClerkText
	.DW CinnabarMartSilphWorkerFText,CinnabarMartScientistText
CinnabarMartTextPointersEnd:
.ASSERT CinnabarMartTextPointersEnd - CinnabarMart_TextPointers == 6

CinnabarMartSilphWorkerFText:
	.DB $17
	.DW $539B
	.DB $28,$50
CinnabarMartScientistText:
	.DB $17
	.DW $53CB
	.DB $28,$50
CinnabarMartTextsEnd:
.ASSERT CinnabarMartTextsEnd - CinnabarMartSilphWorkerFText == 10

CinnabarMart_Object:
	.DB $00,$02
	.DB $07,$03,$04,$FF,$07,$04,$04,$FF
	.DB $00,$03
	.DB $26,$09,$04,$FF,$D3,$01
	.DB $1B,$06,$0A,$FF,$FF,$02
	.DB $20,$08,$07,$FF,$FF,$03
	.DB $12,$C7,$07,$03,$13,$C7,$07,$04
CinnabarMartObjectEnd:
.ASSERT CinnabarMartObjectEnd - CinnabarMart_Object == 38
