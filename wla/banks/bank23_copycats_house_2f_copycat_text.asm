CopycatsHouse2FCopycatText:
	.DB $08
	LD A, ($D7AF)
	BIT 0, A
	JR NZ, CopycatsHouse2FCopycatText.got_item
	LD A, $01
	LD ($CC3C), A
	LD HL, CopycatsHouse2FCopycatText.DoYouLikePokemonText
	CALL PrintText
	LD B, $33
	CALL $3493
	JR Z, CopycatsHouse2FCopycatText.done
	LD HL, CopycatsHouse2FCopycatText.TM31PreReceiveText
	CALL PrintText
	LD BC, $E701
	CALL $3E2E
	JR NC, CopycatsHouse2FCopycatText.bag_full
	LD HL, CopycatsHouse2FCopycatText.ReceivedTM31Text
	CALL PrintText
	LD A, $33
	LDH ($DB), A
	LD B, $05
	LD HL, $7F37
	CALL $35D6
	LD HL, $D7AF
	SET 0, (HL)
	JR CopycatsHouse2FCopycatText.done
CopycatsHouse2FCopycatText.bag_full:
	LD HL, CopycatsHouse2FCopycatText.TM31NoRoomText
	CALL PrintText
	JR CopycatsHouse2FCopycatText.done
CopycatsHouse2FCopycatText.got_item:
	LD HL, CopycatsHouse2FCopycatText.TM31Explanation2Text
	CALL PrintText
CopycatsHouse2FCopycatText.done:
	JP $24D7
CopycatsHouse2FCopycatText.DoYouLikePokemonText:
	.DB $17
	.DW $55AD
	.DB $28, $50
CopycatsHouse2FCopycatText.TM31PreReceiveText:
	.DB $17
	.DW $5636
	.DB $28, $50
CopycatsHouse2FCopycatText.ReceivedTM31Text:
	.DB $17
	.DW $5675
	.DB $28, $0B
CopycatsHouse2FCopycatText.TM31Explanation1Text:
	.DB $17
	.DW $5689
	.DB $28, $0D, $50
CopycatsHouse2FCopycatText.TM31Explanation2Text:
	.DB $17
	.DW $56C5
	.DB $28, $50
CopycatsHouse2FCopycatText.TM31NoRoomText:
	.DB $17
	.DW $5733
	.DB $28, $0D, $50
CopycatsHouse2FCopycatTextEnd:
.ASSERT CopycatsHouse2FCopycatTextEnd - CopycatsHouse2FCopycatText == 114
