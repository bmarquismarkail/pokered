CopycatsHouse2FDoduoText:
	.DB $17
	.DW $5749
	.DB $28, $50
CopycatsHouse2FRareDollText:
	.DB $17
	.DW $5792
	.DB $28, $50
CopycatsHouse2FSNESText:
	.DB $17
	.DW $57BE
	.DB $28, $50
CopycatsHouse2FPCText:
	.DB $08
	LD A, ($C109)
	CP $04
	LD HL, CopycatsHouse2FPCText.CantSeeText
	JR NZ, CopycatsHouse2FPCText.notUp
	LD HL, CopycatsHouse2FPCText.MySecretsText
CopycatsHouse2FPCText.notUp:
	CALL PrintText
	JP $24D7
CopycatsHouse2FPCText.MySecretsText:
	.DB $17
	.DW $57EF
	.DB $28, $50
CopycatsHouse2FPCText.CantSeeText:
	.DB $17
	.DW $5842
	.DB $28, $50
CopycatsHouse2FRoomTextsEnd:
.ASSERT CopycatsHouse2FRoomTextsEnd - CopycatsHouse2FDoduoText == 45
