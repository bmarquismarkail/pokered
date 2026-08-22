Museum1F_Script:
	ld a, 1 << BIT_NO_AUTO_TEXT_BOX
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, Museum1F_ScriptPointers
	ld a, [wMuseum1FCurScript]
	jp CallFunctionInTable

Museum1F_ScriptPointers:
	def_script_pointers
	dw_const Museum1FDefaultScript, SCRIPT_MUSEUM1F_DEFAULT
	dw_const Museum1FNoopScript,    SCRIPT_MUSEUM1F_NOOP

Museum1FDefaultScript:
	ld a, [wYCoord]
	cp 4
	ret nz
	ld a, [wXCoord]
	cp 9
	jr z, Museum1FDefaultScript.continue
	ld a, [wXCoord]
	cp 10
	ret nz
Museum1FDefaultScript.continue
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld a, TEXT_MUSEUM1F_SCIENTIST1
	ldh [lobyte(hTextID)], a
	jp DisplayTextID

Museum1FNoopScript:
	ret

Museum1F_TextPointers:
	def_text_pointers
	dw_const Museum1FScientist1Text, TEXT_MUSEUM1F_SCIENTIST1
	dw_const Museum1FGamblerText,    TEXT_MUSEUM1F_GAMBLER
	dw_const Museum1FScientist2Text, TEXT_MUSEUM1F_SCIENTIST2
	dw_const Museum1FScientist3Text, TEXT_MUSEUM1F_SCIENTIST3
	dw_const Museum1FOldAmberText,   TEXT_MUSEUM1F_OLD_AMBER

Museum1FScientist1Text:
	text_asm
	ld a, [wYCoord]
	cp 4
	jr nz, Museum1FScientist1Text.not_right_of_scientist
	ld a, [wXCoord]
	cp 13
	jp z, Museum1FScientist1Text.behind_counter
	jr Museum1FScientist1Text.check_ticket
Museum1FScientist1Text.not_right_of_scientist
	cp 3
	jr nz, Museum1FScientist1Text.not_behind_counter
	ld a, [wXCoord]
	cp 12
	jp z, Museum1FScientist1Text.behind_counter
Museum1FScientist1Text.not_behind_counter
	CheckEvent EVENT_BOUGHT_MUSEUM_TICKET
	jr nz, Museum1FScientist1Text.already_bought_ticket
	ld hl, Museum1FScientist1Text.GoToOtherSideText
	call PrintText
	jp Museum1FScientist1Text.done
Museum1FScientist1Text.check_ticket
	CheckEvent EVENT_BOUGHT_MUSEUM_TICKET
	jr z, Museum1FScientist1Text.no_ticket
Museum1FScientist1Text.already_bought_ticket
	ld hl, Museum1FScientist1Text.TakePlentyOfTimeText
	call PrintText
	jp Museum1FScientist1Text.done
Museum1FScientist1Text.no_ticket
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld hl, Museum1FScientist1Text.WouldYouLikeToComeInText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, Museum1FScientist1Text.deny_entry
	xor a
	ldh [lobyte(hMoney)], a
	ldh [lobyte(hMoney + 1)], a
	ld a, $50
	ldh [lobyte(hMoney + 2)], a
	call HasEnoughMoney
	jr nc, Museum1FScientist1Text.buy_ticket
	ld hl, Museum1FScientist1Text.DontHaveEnoughMoneyText
	call PrintText
	jp Museum1FScientist1Text.deny_entry
Museum1FScientist1Text.buy_ticket
	ld hl, Museum1FScientist1Text.ThankYouText
	call PrintText
	SetEvent EVENT_BOUGHT_MUSEUM_TICKET
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 1], a
	ld a, $50
	ld [wPriceTemp + 2], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	jr Museum1FScientist1Text.allow_entry
Museum1FScientist1Text.deny_entry
	ld hl, Museum1FScientist1Text.ComeAgainText
	call PrintText
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	call UpdateSprites
	jr Museum1FScientist1Text.done
Museum1FScientist1Text.allow_entry
	ld a, SCRIPT_MUSEUM1F_NOOP
	ld [wMuseum1FCurScript], a
	jr Museum1FScientist1Text.done

Museum1FScientist1Text.behind_counter
	ld hl, Museum1FScientist1Text.DoYouKnowWhatAmberIsText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	cp $0
	jr nz, Museum1FScientist1Text.explain_amber
	ld hl, Museum1FScientist1Text.TheresALabSomewhereText
	call PrintText
	jr Museum1FScientist1Text.done
Museum1FScientist1Text.explain_amber
	ld hl, Museum1FScientist1Text.AmberIsFossilizedTreeSapText
	call PrintText
Museum1FScientist1Text.done
	jp TextScriptEnd

Museum1FScientist1Text.ComeAgainText:
	text_far WLA_GLOBAL_Museum1FScientist1ComeAgainText
	text_end

Museum1FScientist1Text.WouldYouLikeToComeInText:
	text_far WLA_GLOBAL_Museum1FScientist1WouldYouLikeToComeInText
	text_end

Museum1FScientist1Text.ThankYouText:
	text_far WLA_GLOBAL_Museum1FScientist1ThankYouText
	text_end

Museum1FScientist1Text.DontHaveEnoughMoneyText:
	text_far WLA_GLOBAL_Museum1FScientist1DontHaveEnoughMoneyText
	text_end

Museum1FScientist1Text.DoYouKnowWhatAmberIsText:
	text_far WLA_GLOBAL_Museum1FScientist1DoYouKnowWhatAmberIsText
	text_end

Museum1FScientist1Text.TheresALabSomewhereText:
	text_far WLA_GLOBAL_Museum1FScientist1TheresALabSomewhereText
	text_end

Museum1FScientist1Text.AmberIsFossilizedTreeSapText:
	text_far WLA_GLOBAL_Museum1FScientist1AmberIsFossilizedTreeSapText
	text_end

Museum1FScientist1Text.GoToOtherSideText:
	text_far WLA_GLOBAL_Museum1FScientist1GoToOtherSideText
	text_end

Museum1FScientist1Text.TakePlentyOfTimeText:
	text_far WLA_GLOBAL_Museum1FScientist1TakePlentyOfTimeText
	text_end

Museum1FGamblerText:
	text_asm
	ld hl, Museum1FGamblerText.Text
	call PrintText
	jp TextScriptEnd

Museum1FGamblerText.Text:
	text_far WLA_GLOBAL_Museum1FGamblerText
	text_end

Museum1FScientist2Text:
	text_asm
	CheckEvent EVENT_GOT_OLD_AMBER
	jr nz, Museum1FScientist2Text.got_item
	ld hl, Museum1FScientist2Text.TakeThisToAPokemonLabText
	call PrintText
	lb "bc", OLD_AMBER, 1
	call GiveItem
	jr nc, Museum1FScientist2Text.bag_full
	SetEvent EVENT_GOT_OLD_AMBER
	ld a, TOGGLE_OLD_AMBER
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld hl, Museum1FScientist2Text.ReceivedOldAmberText
	jr Museum1FScientist2Text.done
Museum1FScientist2Text.bag_full
	ld hl, Museum1FScientist2Text.YouDontHaveSpaceText
	jr Museum1FScientist2Text.done
Museum1FScientist2Text.got_item
	ld hl, Museum1FScientist2Text.GetTheOldAmberCheckText
Museum1FScientist2Text.done
	call PrintText
	jp TextScriptEnd

Museum1FScientist2Text.TakeThisToAPokemonLabText:
	text_far WLA_GLOBAL_Museum1FScientist2TakeThisToAPokemonLabText
	text_end

Museum1FScientist2Text.ReceivedOldAmberText:
	text_far WLA_GLOBAL_Museum1FScientist2ReceivedOldAmberText
	sound_get_item_1
	text_end

Museum1FScientist2Text.GetTheOldAmberCheckText:
	text_far WLA_GLOBAL_Museum1FScientist2GetTheOldAmberCheckText
	text_end

Museum1FScientist2Text.YouDontHaveSpaceText:
	text_far WLA_GLOBAL_Museum1FScientist2YouDontHaveSpaceText
	text_end

Museum1FScientist3Text:
	text_asm
	ld hl, Museum1FScientist3Text.Text
	call PrintText
	jp TextScriptEnd

Museum1FScientist3Text.Text:
	text_far WLA_GLOBAL_Museum1FScientist3Text
	text_end

Museum1FOldAmberText:
	text_asm
	ld hl, Museum1FOldAmberText.Text
	call PrintText
	jp TextScriptEnd

Museum1FOldAmberText.Text:
	text_far WLA_GLOBAL_Museum1FOldAmberText
	text_end
