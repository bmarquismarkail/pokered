; TradeTextPointers1-3 indexes
	const_def
	const TRADETEXT_WANNA_TRADE ; 0
	const TRADETEXT_NO_TRADE    ; 1
	const TRADETEXT_WRONG_MON   ; 2
	const TRADETEXT_THANKS      ; 3
	const TRADETEXT_AFTER_TRADE ; 4
.DEFINE NUM_TRADE_TEXTS const_value

DoInGameTradeDialogue:
; trigger the trade offer/action specified by wWhichTrade
	call SaveScreenTilesToBuffer2
	ld hl, TradeMons
	ld a, [wWhichTrade]
	ld b, a
	swap a
	sub b
	sub b
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld [wInGameTradeGiveMonSpecies], a
	ld a, [hli]
	ld [wInGameTradeReceiveMonSpecies], a
	ld a, [hli]
	push af
	ld de, wInGameTradeMonNick
	ld bc, NAME_LENGTH
	call CopyData
	pop af
	ld l, a
	ld h, 0
	ld de, InGameTradeTextPointers
	add hl, hl
	add hl, de
	ld a, [hli]
	ld [wInGameTradeTextPointerTablePointer], a
	ld a, [hl]
	ld [wInGameTradeTextPointerTablePointer + 1], a
	ld a, [wInGameTradeGiveMonSpecies]
	ld de, wInGameTradeGiveMonName
	call InGameTrade_GetMonName
	ld a, [wInGameTradeReceiveMonSpecies]
	ld de, wInGameTradeReceiveMonName
	call InGameTrade_GetMonName
	ld hl, wCompletedInGameTradeFlags
	ld a, [wWhichTrade]
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	ld a, TRADETEXT_AFTER_TRADE
	ld [wInGameTradeTextPointerTableIndex], a
	jr nz, DoInGameTradeDialogue.printText
; if the trade hasn't been done yet
	.ASSERT ((TRADETEXT_WANNA_TRADE)-(0)) < 1 && ((TRADETEXT_WANNA_TRADE)-(0)) > -1
	xor a
	ld [wInGameTradeTextPointerTableIndex], a
	call DoInGameTradeDialogue.printText
	ld a, TRADETEXT_NO_TRADE
	ld [wInGameTradeTextPointerTableIndex], a
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, DoInGameTradeDialogue.printText
	call InGameTrade_DoTrade
	jr c, DoInGameTradeDialogue.printText
	ld hl, TradedForText
	call PrintText
DoInGameTradeDialogue.printText
	ld hl, wInGameTradeTextPointerTableIndex
	ld a, [hld] ; wInGameTradeTextPointerTableIndex
	ld e, a
	ld d, 0
	ld a, [hld] ; wInGameTradeTextPointerTablePointer + 1
	ld l, [hl] ; wInGameTradeTextPointerTablePointer
	ld h, a
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PrintText

; copies name of species a to hl
InGameTrade_GetMonName:
	push de
	ld [wNamedObjectIndex], a
	call GetMonName
	ld hl, wNameBuffer
	pop de
	ld bc, NAME_LENGTH
	jp CopyData

.INCLUDE "data/events/trades.asm"

InGameTrade_DoTrade:
	xor a ; NORMAL_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	dec a
	ld [wUpdateSpritesEnabled], a
	call DisplayPartyMenu
	push af
	call InGameTrade_RestoreScreen
	pop af
	ld a, TRADETEXT_NO_TRADE
	jp c, InGameTrade_DoTrade.tradeFailed ; jump if the player didn't select a pokemon
	ld a, [wInGameTradeGiveMonSpecies]
	ld b, a
	ld a, [wCurPartySpecies]
	cp b
	ld a, TRADETEXT_WRONG_MON
	jr nz, InGameTrade_DoTrade.tradeFailed ; jump if the selected mon's species is not the required one
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hl]
	ld [wCurEnemyLevel], a
	ld hl, wCompletedInGameTradeFlags
	ld a, [wWhichTrade]
	ld c, a
	ld b, FLAG_SET
	predef FlagActionPredef
	ld hl, ConnectCableText
	call PrintText
	ld a, [wWhichPokemon]
	push af
	ld a, [wCurEnemyLevel]
	push af
	call LoadHpBarAndStatusTilePatterns
	call InGameTrade_PrepareTradeData
	predef InternalClockTradeAnim
	pop af
	ld [wCurEnemyLevel], a
	pop af
	ld [wWhichPokemon], a
	ld a, [wInGameTradeReceiveMonSpecies]
	ld [wCurPartySpecies], a
	xor a
	ld [wMonDataLocation], a ; not used
	ld [wRemoveMonFromBox], a
	call RemovePokemon
	ld a, $80 ; prevent the player from naming the mon
	ld [wMonDataLocation], a
	call AddPartyMon
	call InGameTrade_CopyDataToReceivedMon
	callfar InGameTrade_CheckForTradeEvo
	call ClearScreen
	call InGameTrade_RestoreScreen
	farcall RedrawMapView
	and a
	ld a, TRADETEXT_THANKS
	jr InGameTrade_DoTrade.tradeSucceeded
InGameTrade_DoTrade.tradeFailed
	scf
InGameTrade_DoTrade.tradeSucceeded
	ld [wInGameTradeTextPointerTableIndex], a
	ret

InGameTrade_RestoreScreen:
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call ReloadTilesetTilePatterns
	call LoadScreenTilesFromBuffer2
	call Delay3
	call LoadGBPal
	ld c, 10
	call DelayFrames
	farjp LoadWildData

InGameTrade_PrepareTradeData:
	ld hl, wTradedPlayerMonSpecies
	ld a, [wInGameTradeGiveMonSpecies]
	ld [hli], a ; wTradedPlayerMonSpecies
	ld a, [wInGameTradeReceiveMonSpecies]
	ld [hl], a ; wTradedEnemyMonSpecies
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld de, wTradedPlayerMonOT
	ld bc, NAME_LENGTH
	call InGameTrade_CopyData
	ld hl, InGameTrade_TrainerString
	ld de, wTradedEnemyMonOT
	call InGameTrade_CopyData
	ld de, wLinkEnemyTrainerName
	call InGameTrade_CopyData
	ld hl, wPartyMon1OTID
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld de, wTradedPlayerMonOTID
	ld bc, $2
	call InGameTrade_CopyData
	call Random
	ld hl, hRandomAdd
	ld de, wTradedEnemyMonOTID
	jp CopyData

InGameTrade_CopyData:
	push hl
	push bc
	call CopyData
	pop bc
	pop hl
	ret

InGameTrade_CopyDataToReceivedMon:
	ld hl, wPartyMonNicks
	ld bc, NAME_LENGTH
	call InGameTrade_GetReceivedMonPointer
	ld hl, wInGameTradeMonNick
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	call InGameTrade_GetReceivedMonPointer
	ld hl, InGameTrade_TrainerString
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wPartyMon1OTID
	ld bc, PARTYMON_STRUCT_LENGTH
	call InGameTrade_GetReceivedMonPointer
	ld hl, wTradedEnemyMonOTID
	ld bc, 2
	jp CopyData

; the received mon's index is (partyCount - 1),
; so this adds bc to hl (partyCount - 1) times and moves the result to de
InGameTrade_GetReceivedMonPointer:
	ld a, [wPartyCount]
	dec a
	call AddNTimes
	ld e, l
	ld d, h
	ret

InGameTrade_TrainerString:
	dname "<TRAINER>", NAME_LENGTH

InGameTradeTextPointers:
; entries correspond to TRADE_DIALOGSET_* constants
	table_width 2
	.DW TradeTextPointers1
	.DW TradeTextPointers2
	.DW TradeTextPointers3
	assert_table_length NUM_TRADE_DIALOGSETS

TradeTextPointers1:
	table_width 2
	.DW WannaTrade1Text
	.DW NoTrade1Text
	.DW WrongMon1Text
	.DW Thanks1Text
	.DW AfterTrade1Text
	assert_table_length NUM_TRADE_TEXTS

TradeTextPointers2:
	table_width 2
	.DW WannaTrade2Text
	.DW NoTrade2Text
	.DW WrongMon2Text
	.DW Thanks2Text
	.DW AfterTrade2Text
	assert_table_length NUM_TRADE_TEXTS

TradeTextPointers3:
	table_width 2
	.DW WannaTrade3Text
	.DW NoTrade3Text
	.DW WrongMon3Text
	.DW Thanks3Text
	.DW AfterTrade3Text
	assert_table_length NUM_TRADE_TEXTS

ConnectCableText:
	text_far WLA_GLOBAL_ConnectCableText
	text_end

TradedForText:
	text_far WLA_GLOBAL_TradedForText
	sound_get_key_item
	text_pause
	text_end

WannaTrade1Text:
	text_far WLA_GLOBAL_WannaTrade1Text
	text_end

NoTrade1Text:
	text_far WLA_GLOBAL_NoTrade1Text
	text_end

WrongMon1Text:
	text_far WLA_GLOBAL_WrongMon1Text
	text_end

Thanks1Text:
	text_far WLA_GLOBAL_Thanks1Text
	text_end

AfterTrade1Text:
	text_far WLA_GLOBAL_AfterTrade1Text
	text_end

WannaTrade2Text:
	text_far WLA_GLOBAL_WannaTrade2Text
	text_end

NoTrade2Text:
	text_far WLA_GLOBAL_NoTrade2Text
	text_end

WrongMon2Text:
	text_far WLA_GLOBAL_WrongMon2Text
	text_end

Thanks2Text:
	text_far WLA_GLOBAL_Thanks2Text
	text_end

AfterTrade2Text:
	text_far WLA_GLOBAL_AfterTrade2Text
	text_end

WannaTrade3Text:
	text_far WLA_GLOBAL_WannaTrade3Text
	text_end

NoTrade3Text:
	text_far WLA_GLOBAL_NoTrade3Text
	text_end

WrongMon3Text:
	text_far WLA_GLOBAL_WrongMon3Text
	text_end

Thanks3Text:
	text_far WLA_GLOBAL_Thanks3Text
	text_end

AfterTrade3Text:
	text_far WLA_GLOBAL_AfterTrade3Text
	text_end
