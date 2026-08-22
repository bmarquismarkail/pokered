MtMoonPokecenter_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

MtMoonPokecenter_TextPointers:
	def_text_pointers
	dw_const MtMoonPokecenterNurseText,            TEXT_MTMOONPOKECENTER_NURSE
	dw_const MtMoonPokecenterYoungsterText,        TEXT_MTMOONPOKECENTER_YOUNGSTER
	dw_const MtMoonPokecenterGentlemanText,        TEXT_MTMOONPOKECENTER_GENTLEMAN
	dw_const MtMoonPokecenterMagikarpSalesmanText, TEXT_MTMOONPOKECENTER_MAGIKARP_SALESMAN
	dw_const MtMoonPokecenterClipboardText,        TEXT_MTMOONPOKECENTER_CLIPBOARD
	dw_const MtMoonPokecenterLinkReceptionistText, TEXT_MTMOONPOKECENTER_LINK_RECEPTIONIST

MtMoonPokecenterNurseText:
	script_pokecenter_nurse

MtMoonPokecenterYoungsterText:
	text_far WLA_GLOBAL_MtMoonPokecenterYoungsterText
	text_end

MtMoonPokecenterGentlemanText:
	text_far WLA_GLOBAL_MtMoonPokecenterGentlemanText
	text_end

MtMoonPokecenterMagikarpSalesmanText:
	text_asm
	CheckEvent EVENT_BOUGHT_MAGIKARP, 1
	jp c, MtMoonPokecenterMagikarpSalesmanText.alreadyBoughtMagikarp
	ld hl, MtMoonPokecenterMagikarpSalesmanText.IGotADealText
	call PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, MtMoonPokecenterMagikarpSalesmanText.choseNo
	ldh [lobyte(hMoney)], a
	ldh [lobyte(hMoney + 2)], a
	ld a, $5
	ldh [lobyte(hMoney + 1)], a
	call HasEnoughMoney
	jr nc, MtMoonPokecenterMagikarpSalesmanText.enoughMoney
	ld hl, MtMoonPokecenterMagikarpSalesmanText.NoMoneyText
	jr MtMoonPokecenterMagikarpSalesmanText.printText
MtMoonPokecenterMagikarpSalesmanText.enoughMoney
	lb "bc", MAGIKARP, 5
	call GivePokemon
	jr nc, MtMoonPokecenterMagikarpSalesmanText.done
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a
	ld a, $5
	ld [wPriceTemp + 1], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	SetEvent EVENT_BOUGHT_MAGIKARP
	jr MtMoonPokecenterMagikarpSalesmanText.done
MtMoonPokecenterMagikarpSalesmanText.choseNo
	ld hl, MtMoonPokecenterMagikarpSalesmanText.NoText
	jr MtMoonPokecenterMagikarpSalesmanText.printText
MtMoonPokecenterMagikarpSalesmanText.alreadyBoughtMagikarp
	ld hl, MtMoonPokecenterMagikarpSalesmanText.NoRefundsText
MtMoonPokecenterMagikarpSalesmanText.printText
	call PrintText
MtMoonPokecenterMagikarpSalesmanText.done
	jp TextScriptEnd

MtMoonPokecenterMagikarpSalesmanText.IGotADealText
	text_far WLA_GLOBAL_MtMoonPokecenterMagikarpSalesmanIGotADealText
	text_end

MtMoonPokecenterMagikarpSalesmanText.NoText
	text_far WLA_GLOBAL_MtMoonPokecenterMagikarpSalesmanNoText
	text_end

MtMoonPokecenterMagikarpSalesmanText.NoMoneyText
	text_far WLA_GLOBAL_MtMoonPokecenterMagikarpSalesmanNoMoneyText
	text_end

MtMoonPokecenterMagikarpSalesmanText.NoRefundsText
	text_far WLA_GLOBAL_MtMoonPokecenterMagikarpSalesmanNoRefundsText
	text_end

MtMoonPokecenterClipboardText:
	text_far WLA_GLOBAL_MtMoonPokecenterClipboardText
	text_end

MtMoonPokecenterLinkReceptionistText:
	script_cable_club_receptionist
