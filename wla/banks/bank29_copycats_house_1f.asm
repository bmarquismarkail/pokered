CopycatsHouse1F_h:
	.DB $01,$04,$04
	.DW CopycatsHouse1F_Blocks
	.DW CopycatsHouse1F_TextPointers
	.DW CopycatsHouse1F_Script
	.DB $00
	.DW CopycatsHouse1F_Object
CopycatsHouse1FHeaderEnd:
.ASSERT CopycatsHouse1FHeaderEnd - CopycatsHouse1F_h == 12

CopycatsHouse1F_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
CopycatsHouse1FScriptEnd:
.ASSERT CopycatsHouse1FScriptEnd - CopycatsHouse1F_Script == 3

CopycatsHouse1F_TextPointers:
	.DW CopycatsHouse1FMiddleAgedWomanText,CopycatsHouse1FMiddleAgedManText,CopycatsHouse1FChanseyText
CopycatsHouse1FTextPointersEnd:
.ASSERT CopycatsHouse1FTextPointersEnd - CopycatsHouse1F_TextPointers == 6

CopycatsHouse1FMiddleAgedWomanText:
	.DB $17
	.DW $54F7
	.DB $28,$50
CopycatsHouse1FMiddleAgedManText:
	.DB $17
	.DW $5535
	.DB $28,$50
CopycatsHouse1FChanseyText:
	.DB $17
	.DW $5596
	.DB $28
	.DB $08 ; text_asm
	LD A, $28 ; CHANSEY
	CALL $13D0 ; PlayCry
	JP $24D7 ; TextScriptEnd
CopycatsHouse1FTextsEnd:
.ASSERT CopycatsHouse1FTextsEnd - CopycatsHouse1FMiddleAgedWomanText == 23

CopycatsHouse1F_Object:
	.DB $0A,$03
	.DB $07,$02,$00,$FF,$07,$03,$00,$FF,$01,$07,$00,$B0
	.DB $00,$03
	.DB $1C,$06,$06,$FF,$D0,$01
	.DB $0A,$08,$09,$FF,$D2,$02
	.DB $38,$08,$05,$FE,$01,$03
	.DB $12,$C7,$07,$02,$12,$C7,$07,$03,$F6,$C6,$01,$07
CopycatsHouse1FObjectEnd:
.ASSERT CopycatsHouse1FObjectEnd - CopycatsHouse1F_Object == 46
