Daycare_Script:
	jp EnableAutoTextBoxDrawing

Daycare_TextPointers:
	def_text_pointers
	dw_const DaycareGentlemanText, TEXT_DAYCARE_GENTLEMAN

DaycareGentlemanText:
	text_asm
	call SaveScreenTilesToBuffer2
	ld a, [wDayCareInUse]
	and a
	jp nz, DaycareGentlemanText.daycareInUse
	ld hl, DaycareGentlemanText.IntroText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, DaycareGentlemanText.ComeAgainText
	jp nz, DaycareGentlemanText.done
	ld a, [wPartyCount]
	dec a
	ld hl, DaycareGentlemanText.OnlyHaveOneMonText
	jp z, DaycareGentlemanText.done
	ld hl, DaycareGentlemanText.WhichMonText
	call PrintText
	xor a
	ld [wUpdateSpritesEnabled], a
	ld [wPartyMenuTypeOrMessageID], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	pop af
	ld hl, DaycareGentlemanText.AllRightThenText
	jp c, DaycareGentlemanText.done
	callfar KnowsHMMove
	ld hl, DaycareGentlemanText.CantAcceptMonWithHMText
	jp c, DaycareGentlemanText.done
	xor a
	ld [wPartyAndBillsPCSavedMenuItem], a
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, DaycareGentlemanText.WillLookAfterMonText
	call PrintText
	ld a, 1
	ld [wDayCareInUse], a
	ld a, PARTY_TO_DAYCARE
	ld [wMoveMonType], a
	call MoveMon
	xor a
	ld [wRemoveMonFromBox], a
	call RemovePokemon
	ld a, [wCurPartySpecies]
	call PlayCry
	ld hl, DaycareGentlemanText.ComeSeeMeInAWhileText
	jp DaycareGentlemanText.done

DaycareGentlemanText.daycareInUse
	xor a
	ld hl, wDayCareMonName
	call GetPartyMonName
	ld a, DAYCARE_DATA
	ld [wMonDataLocation], a
	call LoadMonData
	callfar CalcLevelFromExperience
	ld a, d
	cp MAX_LEVEL
	jr c, DaycareGentlemanText.skipCalcExp

	ld d, MAX_LEVEL
	callfar CalcExperience
	ld hl, wDayCareMonExp
	ldh a, [lobyte(hExperience)]
	ld [hli], a
	ldh a, [lobyte(hExperience + 1)]
	ld [hli], a
	ldh a, [lobyte(hExperience + 2)]
	ld [hl], a
	ld d, MAX_LEVEL

DaycareGentlemanText.skipCalcExp
	xor a
	ld [wDayCareNumLevelsGrown], a
	ld hl, wDayCareMonBoxLevel
	ld a, [hl]
	ld [wDayCareStartLevel], a
	cp d
	ld [hl], d
	ld hl, DaycareGentlemanText.MonNeedsMoreTimeText
	jr z, DaycareGentlemanText.next
	ld a, [wDayCareStartLevel]
	ld b, a
	ld a, d
	sub b
	ld [wDayCareNumLevelsGrown], a
	ld hl, DaycareGentlemanText.MonHasGrownText

DaycareGentlemanText.next
	call PrintText
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	ld hl, DaycareGentlemanText.NoRoomForMonText
	jp z, DaycareGentlemanText.leaveMonInDayCare
	ld de, wDayCareTotalCost
	xor a
	ld [de], a
	inc de
	ld [de], a
	ld hl, wDayCarePerLevelCost
	ld a, $1
	ld [hli], a
	ld [hl], $0
	ld a, [wDayCareNumLevelsGrown]
	inc a
	ld b, a
	ld c, 2
DaycareGentlemanText.calcPriceLoop
	push hl
	push de
	push bc
	predef AddBCDPredef
	pop bc
	pop de
	pop hl
	dec b
	jr nz, DaycareGentlemanText.calcPriceLoop
	ld hl, DaycareGentlemanText.OweMoneyText
	call PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	ld hl, DaycareGentlemanText.AllRightThenText
	ld a, [wCurrentMenuItem]
	and a
	jp nz, DaycareGentlemanText.leaveMonInDayCare
	ld hl, wDayCareTotalCost
	ldh [lobyte(hMoney)], a
	ld a, [hli]
	ldh [lobyte(hMoney + 1)], a
	ld a, [hl]
	ldh [lobyte(hMoney + 2)], a
	call HasEnoughMoney
	jr nc, DaycareGentlemanText.enoughMoney
	ld hl, DaycareGentlemanText.NotEnoughMoneyText
	jp DaycareGentlemanText.leaveMonInDayCare

DaycareGentlemanText.enoughMoney
	xor a
	ld [wDayCareInUse], a
	ld hl, wDayCareNumLevelsGrown
	ld [hli], a
	inc hl
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, DaycareGentlemanText.HeresYourMonText
	call PrintText
	ld a, DAYCARE_TO_PARTY
	ld [wMoveMonType], a
	call MoveMon
	ld a, [wDayCareMonSpecies]
	ld [wCurPartySpecies], a
	ld a, [wPartyCount]
	dec a
	push af
	ld bc, PARTYMON_STRUCT_LENGTH
	push bc
	ld hl, wPartyMon1Moves
	call AddNTimes
	ld d, h
	ld e, l
	ld a, 1
	ld [wLearningMovesFromDayCare], a
	predef WriteMonMoves
	pop bc
	pop af

; set mon's HP to max
	ld hl, wPartyMon1HP
	call AddNTimes
	ld d, h
	ld e, l
	ld bc, MON_MAXHP - MON_HP
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	ld a, [wCurPartySpecies]
	call PlayCry
	ld hl, DaycareGentlemanText.GotMonBackText
	jr DaycareGentlemanText.done

DaycareGentlemanText.leaveMonInDayCare
	ld a, [wDayCareStartLevel]
	ld [wDayCareMonBoxLevel], a

DaycareGentlemanText.done
	call PrintText
	jp TextScriptEnd

DaycareGentlemanText.IntroText:
	text_far WLA_GLOBAL_DaycareGentlemanIntroText
	text_end

DaycareGentlemanText.WhichMonText:
	text_far WLA_GLOBAL_DaycareGentlemanWhichMonText
	text_end

DaycareGentlemanText.WillLookAfterMonText:
	text_far WLA_GLOBAL_DaycareGentlemanWillLookAfterMonText
	text_end

DaycareGentlemanText.ComeSeeMeInAWhileText:
	text_far WLA_GLOBAL_DaycareGentlemanComeSeeMeInAWhileText
	text_end

DaycareGentlemanText.MonHasGrownText:
	text_far WLA_GLOBAL_DaycareGentlemanMonHasGrownText
	text_end

DaycareGentlemanText.OweMoneyText:
	text_far WLA_GLOBAL_DaycareGentlemanOweMoneyText
	text_end

DaycareGentlemanText.GotMonBackText:
	text_far WLA_GLOBAL_DaycareGentlemanGotMonBackText
	text_end

DaycareGentlemanText.MonNeedsMoreTimeText:
	text_far WLA_GLOBAL_DaycareGentlemanMonNeedsMoreTimeText
	text_end

DaycareGentlemanText.AllRightThenText:
	text_far WLA_GLOBAL_DaycareGentlemanAllRightThenText
DaycareGentlemanText.ComeAgainText:
	text_far WLA_GLOBAL_DaycareGentlemanComeAgainText
	text_end

DaycareGentlemanText.NoRoomForMonText:
	text_far WLA_GLOBAL_DaycareGentlemanNoRoomForMonText
	text_end

DaycareGentlemanText.OnlyHaveOneMonText:
	text_far WLA_GLOBAL_DaycareGentlemanOnlyHaveOneMonText
	text_end

DaycareGentlemanText.CantAcceptMonWithHMText:
	text_far WLA_GLOBAL_DaycareGentlemanCantAcceptMonWithHMText
	text_end

DaycareGentlemanText.HeresYourMonText:
	text_far WLA_GLOBAL_DaycareGentlemanHeresYourMonText
	text_end

DaycareGentlemanText.NotEnoughMoneyText:
	text_far WLA_GLOBAL_DaycareGentlemanNotEnoughMoneyText
	text_end
