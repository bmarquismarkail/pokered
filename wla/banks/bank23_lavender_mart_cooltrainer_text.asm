LavenderMartCooltrainerMText:
	.DB $08
	LD A, ($D7E0)
	BIT 7, A ; EVENT_RESCUED_MR_FUJI
	JR NZ, LavenderMartCooltrainerMText.Nugget
	LD HL, LavenderMartCooltrainerMText.ReviveText
	CALL PrintText
	JR LavenderMartCooltrainerMText.done
LavenderMartCooltrainerMText.Nugget:
	LD HL, LavenderMartCooltrainerMText.NuggetText
	CALL PrintText
LavenderMartCooltrainerMText.done:
	JP $24D7
LavenderMartCooltrainerMText.ReviveText:
	.DB $17
	.DW $61B4
	.DB $26, $50
LavenderMartCooltrainerMText.NuggetText:
	.DB $17
	.DW $61E3
	.DB $26, $50
LavenderMartCooltrainerTextEnd:
.ASSERT LavenderMartCooltrainerTextEnd - LavenderMartCooltrainerMText == 35
