Museum1FScientist1Text:
	.DB $08
	LD A, ($D361) ; wYCoord
	CP 4
	JR NZ, Museum1FScientist1Text.not_right_of_scientist
	LD A, ($D362) ; wXCoord
	CP 13
	JP Z, Museum1FScientist1Text.behind_counter
	JR Museum1FScientist1Text.check_ticket
Museum1FScientist1Text.not_right_of_scientist:
	CP 3
	JR NZ, Museum1FScientist1Text.not_behind_counter
	LD A, ($D362)
	CP 12
	JP Z, Museum1FScientist1Text.behind_counter
Museum1FScientist1Text.not_behind_counter:
	LD A, ($D754)
	BIT 0, A ; EVENT_BOUGHT_MUSEUM_TICKET
	JR NZ, Museum1FScientist1Text.already_bought_ticket
	LD HL, Museum1FScientist1Text.GoToOtherSideText
	CALL $3C49 ; PrintText
	JP Museum1FScientist1Text.done
Museum1FScientist1Text.check_ticket:
	LD A, ($D754)
	BIT 0, A
	JR Z, Museum1FScientist1Text.no_ticket
Museum1FScientist1Text.already_bought_ticket:
	LD HL, Museum1FScientist1Text.TakePlentyOfTimeText
	CALL $3C49
	JP Museum1FScientist1Text.done
Museum1FScientist1Text.no_ticket:
	LD A, $13 ; MONEY_BOX
	LD ($D125), A ; wTextBoxID
	CALL $30E8 ; DisplayTextBoxID
	XOR A
	LDH ($B4), A ; hJoyHeld
	LD HL, Museum1FScientist1Text.WouldYouLikeToComeInText
	CALL $3C49
	CALL $35EC ; YesNoChoice
	LD A, ($CC26) ; wCurrentMenuItem
	AND A
	JR NZ, Museum1FScientist1Text.deny_entry
	XOR A
	LDH ($9F), A
	LDH ($A0), A
	LD A, $50
	LDH ($A1), A
	CALL $35A6 ; HasEnoughMoney
	JR NC, Museum1FScientist1Text.buy_ticket
	LD HL, Museum1FScientist1Text.DontHaveEnoughMoneyText
	CALL $3C49
	JP Museum1FScientist1Text.deny_entry
Museum1FScientist1Text.buy_ticket:
	LD HL, Museum1FScientist1Text.ThankYouText
	CALL $3C49
	LD HL, $D754
	SET 0, (HL)
	XOR A
	LD ($CD3D), A ; wPriceTemp
	LD ($CD3E), A
	LD A, $50
	LD ($CD3F), A
	LD HL, $CD3F
	LD DE, $D349 ; wPlayerMoney + 2
	LD C, 3
	LD A, $0C ; SubBCDPredef
	CALL $3E6D
	LD A, $13
	LD ($D125), A
	CALL $30E8
	LD A, $B2 ; SFX_PURCHASE
	CALL $3740 ; PlaySoundWaitForCurrent
	CALL $3748 ; WaitForSoundToFinish
	JR Museum1FScientist1Text.allow_entry
Museum1FScientist1Text.deny_entry:
	LD HL, Museum1FScientist1Text.ComeAgainText
	CALL $3C49
	LD A, 1
	LD ($CD38), A ; wSimulatedJoypadStatesIndex
	LD A, $80 ; PAD_DOWN
	LD ($CCD3), A ; wSimulatedJoypadStatesEnd
	CALL $3486 ; StartSimulatingJoypadStates
	CALL $2429 ; UpdateSprites
	JR Museum1FScientist1Text.done
Museum1FScientist1Text.allow_entry:
	LD A, 1 ; SCRIPT_MUSEUM1F_NOOP
	LD ($D619), A ; wMuseum1FCurScript
	JR Museum1FScientist1Text.done
Museum1FScientist1Text.behind_counter:
	LD HL, Museum1FScientist1Text.DoYouKnowWhatAmberIsText
	CALL $3C49
	CALL $35EC
	LD A, ($CC26)
	CP 0
	JR NZ, Museum1FScientist1Text.explain_amber
	LD HL, Museum1FScientist1Text.TheresALabSomewhereText
	CALL $3C49
	JR Museum1FScientist1Text.done
Museum1FScientist1Text.explain_amber:
	LD HL, Museum1FScientist1Text.AmberIsFossilizedTreeSapText
	CALL $3C49
Museum1FScientist1Text.done:
	JP $24D7 ; TextScriptEnd
Museum1FScientist1Text.ComeAgainText:
	.DB $17
	.DW $652C
	.DB $25,$50
Museum1FScientist1Text.WouldYouLikeToComeInText:
	.DB $17
	.DW $6539
	.DB $25,$50
Museum1FScientist1Text.ThankYouText:
	.DB $17
	.DW $6572
	.DB $25,$50
Museum1FScientist1Text.DontHaveEnoughMoneyText:
	.DB $17
	.DW $658A
	.DB $25,$50
Museum1FScientist1Text.DoYouKnowWhatAmberIsText:
	.DB $17
	.DW $65A7
	.DB $25,$50
Museum1FScientist1Text.TheresALabSomewhereText:
	.DB $17
	.DW $65F1
	.DB $25,$50
Museum1FScientist1Text.AmberIsFossilizedTreeSapText:
	.DB $17
	.DW $6636
	.DB $25,$50
Museum1FScientist1Text.GoToOtherSideText:
	.DB $17
	.DW $6657
	.DB $25,$50
Museum1FScientist1Text.TakePlentyOfTimeText:
	.DB $17
	.DW $6675
	.DB $25,$50
Museum1FScientist1TextEnd:
.ASSERT Museum1FScientist1TextEnd - Museum1FScientist1Text == 274
