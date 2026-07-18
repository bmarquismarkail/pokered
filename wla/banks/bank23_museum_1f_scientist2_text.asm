Museum1FScientist2Text:
	.DB $08
	LD A, ($D754)
	BIT 1, A ; EVENT_GOT_OLD_AMBER
	JR NZ, Museum1FScientist2Text.got_item
	LD HL, Museum1FScientist2Text.TakeThisToAPokemonLabText
	CALL $3C49 ; PrintText
	LD BC, $1F01 ; OLD_AMBER, 1
	CALL $3E2E ; GiveItem
	JR NC, Museum1FScientist2Text.bag_full
	LD HL, $D754
	SET 1, (HL)
	LD A, $34 ; TOGGLE_OLD_AMBER
	LD ($CC4D), A
	LD A, $11 ; HideObject predef
	CALL $3E6D
	LD HL, Museum1FScientist2Text.ReceivedOldAmberText
	JR Museum1FScientist2Text.done
Museum1FScientist2Text.bag_full:
	LD HL, Museum1FScientist2Text.YouDontHaveSpaceText
	JR Museum1FScientist2Text.done
Museum1FScientist2Text.got_item:
	LD HL, Museum1FScientist2Text.GetTheOldAmberCheckText
Museum1FScientist2Text.done:
	CALL $3C49
	JP $24D7
Museum1FScientist2Text.TakeThisToAPokemonLabText:
	.DB $17
	.DW $66B4
	.DB $25,$50
Museum1FScientist2Text.ReceivedOldAmberText:
	.DB $17
	.DW $6790
	.DB $25,$0B,$50
Museum1FScientist2Text.GetTheOldAmberCheckText:
	.DB $17
	.DW $67A8
	.DB $25,$50
Museum1FScientist2Text.YouDontHaveSpaceText:
	.DB $17
	.DW $67C9
	.DB $25,$50
Museum1FScientist2TextEnd:
.ASSERT Museum1FScientist2TextEnd - Museum1FScientist2Text == 77
