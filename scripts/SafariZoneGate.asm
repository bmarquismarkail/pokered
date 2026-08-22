SafariZoneGate_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SafariZoneGate_ScriptPointers
	ld a, [wSafariZoneGateCurScript]
	jp CallFunctionInTable

SafariZoneGate_ScriptPointers:
	def_script_pointers
	dw_const SafariZoneGateDefaultScript,                SCRIPT_SAFARIZONEGATE_DEFAULT
	dw_const SafariZoneGatePlayerMovingRightScript,      SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_RIGHT
	dw_const SafariZoneGateWouldYouLikeToJoinScript,     SCRIPT_SAFARIZONEGATE_WOULD_YOU_LIKE_TO_JOIN
	dw_const SafariZoneGatePlayerMovingUpScript,         SCRIPT_SAFARIZONEGATE_PLAYER_MOVING
	dw_const SafariZoneGatePlayerMovingDownScript,       SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_DOWN
	dw_const SafariZoneGateLeavingSafariScript,          SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI
	dw_const SafariZoneGateSetScriptAfterMoveScript,     SCRIPT_SAFARIZONEGATE_SET_SCRIPT_AFTER_MOVE
	.EXPORT SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI ; used by engine/events/hidden_events/safari_game.asm

SafariZoneGateDefaultScript:
	ld hl, SafariZoneGateDefaultScript.PlayerNextToSafariZoneWorker1CoordsArray
	call ArePlayerCoordsInArray
	ret nc
	ld a, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_1
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld a, SPRITE_FACING_RIGHT
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, [wCoordIndex]
	cp 1 ; index of second, lower entry in .PlayerNextToSafariZoneWorker1CoordsArray
	jr z, SafariZoneGateDefaultScript.player_not_next_to_worker
	ld a, SCRIPT_SAFARIZONEGATE_WOULD_YOU_LIKE_TO_JOIN
	ld [wSafariZoneGateCurScript], a
	ret
SafariZoneGateDefaultScript.player_not_next_to_worker
	ld a, PAD_RIGHT
	ld c, 1
	call SafariZoneEntranceAutoWalk
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_RIGHT
	ld [wSafariZoneGateCurScript], a
	ret

SafariZoneGateDefaultScript.PlayerNextToSafariZoneWorker1CoordsArray:
	dbmapcoord  3,  2
	dbmapcoord  4,  2
	.DB -1 ; end

SafariZoneGatePlayerMovingRightScript:
	call SafariZoneGateReturnSimulatedJoypadStateScript
	ret nz
SafariZoneGateWouldYouLikeToJoinScript:
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld [wJoyIgnore], a
	call UpdateSprites
	ld a, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_WOULD_YOU_LIKE_TO_JOIN
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ret

SafariZoneGatePlayerMovingUpScript:
	call SafariZoneGateReturnSimulatedJoypadStateScript
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI
	ld [wSafariZoneGateCurScript], a
	ret

SafariZoneGateLeavingSafariScript:
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	CheckAndResetEvent EVENT_SAFARI_GAME_OVER
	jr z, SafariZoneGateLeavingSafariScript.leaving_early
	ResetEventReuseHL EVENT_IN_SAFARI_ZONE
	call UpdateSprites
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_GOOD_HAUL_COME_AGAIN
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	xor a
	ld [wNumSafariBalls], a
	ld a, PAD_DOWN
	ld c, 3
	call SafariZoneEntranceAutoWalk
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_DOWN
	ld [wSafariZoneGateCurScript], a
	jr SafariZoneGateLeavingSafariScript.return
SafariZoneGateLeavingSafariScript.leaving_early
	ld a, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_LEAVING_EARLY
	ldh [lobyte(hTextID)], a
	call DisplayTextID
SafariZoneGateLeavingSafariScript.return
	ret

SafariZoneGatePlayerMovingDownScript:
	call SafariZoneGateReturnSimulatedJoypadStateScript
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_SAFARIZONEGATE_DEFAULT
	ld [wSafariZoneGateCurScript], a
	ret

SafariZoneGateSetScriptAfterMoveScript:
	call SafariZoneGateReturnSimulatedJoypadStateScript
	ret nz
	call Delay3
	ld a, [wNextSafariZoneGateScript]
	ld [wSafariZoneGateCurScript], a
	ret

SafariZoneEntranceAutoWalk:
	push af
	ld b, 0
	ld a, c
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wSimulatedJoypadStatesEnd
	pop af
	call FillMemory
	jp StartSimulatingJoypadStates

SafariZoneGateReturnSimulatedJoypadStateScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret

SafariZoneGate_TextPointers:
	def_text_pointers
	dw_const SafariZoneGateSafariZoneWorker1Text,                   TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1
	dw_const SafariZoneGateSafariZoneWorker2Text,                   TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER2
	dw_const SafariZoneGateSafariZoneWorker1Text,                   TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_1
	dw_const SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText, TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_WOULD_YOU_LIKE_TO_JOIN
	dw_const SafariZoneGateSafariZoneWorker1LeavingEarlyText,       TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_LEAVING_EARLY
	dw_const SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText,  TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_GOOD_HAUL_COME_AGAIN

SafariZoneGateSafariZoneWorker1Text:
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker1Text
	text_end

SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText:
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText
	text_asm
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.PleaseComeAgain
	xor a
	ldh [lobyte(hMoney)], a
	ld a, $05
	ldh [lobyte(hMoney + 1)], a
	ld a, $00
	ldh [lobyte(hMoney + 2)], a
	call HasEnoughMoney
	jr nc, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.success
	ld hl, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.NotEnoughMoneyText
	call PrintText
	jr SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.CantPayWalkDown

SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.success
	xor a
	ld [wPriceTemp], a
	ld a, $05
	ld [wPriceTemp + 1], a
	ld a, $00
	ld [wPriceTemp + 2], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, 3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.MakePaymentText
	call PrintText
	ld a, 30
	ld [wNumSafariBalls], a
	ld a, hibyte(502)
	ld [wSafariSteps], a
	ld a, lobyte(502)
	ld [wSafariSteps + 1], a
	ld a, PAD_UP
	ld c, 3
	call SafariZoneEntranceAutoWalk
	SetEvent EVENT_IN_SAFARI_ZONE
	ResetEventReuseHL EVENT_SAFARI_GAME_OVER
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING
	ld [wSafariZoneGateCurScript], a
	jr SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.done

SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.PleaseComeAgain
	ld hl, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.PleaseComeAgainText
	call PrintText
SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.CantPayWalkDown
	ld a, PAD_DOWN
	ld c, 1
	call SafariZoneEntranceAutoWalk
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_DOWN
	ld [wSafariZoneGateCurScript], a
SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.done
	jp TextScriptEnd

SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.MakePaymentText
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker1ThatllBe500PleaseText
	sound_get_item_1
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker1CallYouOnThePAText
	text_end

SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.PleaseComeAgainText
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker1PleaseComeAgainText
	text_end

SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.NotEnoughMoneyText
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker1NotEnoughMoneyText
	text_end

SafariZoneGateSafariZoneWorker1LeavingEarlyText:
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker1LeavingEarlyText
	text_asm
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, SafariZoneGateSafariZoneWorker1LeavingEarlyText.not_ready_to_leave
	ld hl, SafariZoneGateSafariZoneWorker1LeavingEarlyText.ReturnSafariBallsText
	call PrintText
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, PAD_DOWN
	ld c, 3
	call SafariZoneEntranceAutoWalk
	ResetEvents EVENT_SAFARI_GAME_OVER, EVENT_IN_SAFARI_ZONE
	ld a, SCRIPT_SAFARIZONEGATE_DEFAULT
	ld [wNextSafariZoneGateScript], a
	jr SafariZoneGateSafariZoneWorker1LeavingEarlyText.set_current_script
SafariZoneGateSafariZoneWorker1LeavingEarlyText.not_ready_to_leave
	ld hl, SafariZoneGateSafariZoneWorker1LeavingEarlyText.GoodLuckText
	call PrintText
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, PAD_UP
	ld c, 1
	call SafariZoneEntranceAutoWalk
	ld a, SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI
	ld [wNextSafariZoneGateScript], a
SafariZoneGateSafariZoneWorker1LeavingEarlyText.set_current_script
	ld a, SCRIPT_SAFARIZONEGATE_SET_SCRIPT_AFTER_MOVE
	ld [wSafariZoneGateCurScript], a
	jp TextScriptEnd

SafariZoneGateSafariZoneWorker1LeavingEarlyText.ReturnSafariBallsText
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker1ReturnSafariBallsText
	text_end

SafariZoneGateSafariZoneWorker1LeavingEarlyText.GoodLuckText
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker1GoodLuckText
	text_end

SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText:
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText
	text_end

SafariZoneGateSafariZoneWorker2Text:
	text_asm
	ld hl, SafariZoneGateSafariZoneWorker2Text.FirstTimeHereText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, SafariZoneGateSafariZoneWorker2Text.YoureARegularHereText
	jr nz, SafariZoneGateSafariZoneWorker2Text.print_text
	ld hl, SafariZoneGateSafariZoneWorker2Text.SafariZoneExplanationText
SafariZoneGateSafariZoneWorker2Text.print_text
	call PrintText
	jp TextScriptEnd

SafariZoneGateSafariZoneWorker2Text.FirstTimeHereText
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker2FirstTimeHereText
	text_end

SafariZoneGateSafariZoneWorker2Text.SafariZoneExplanationText
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker2SafariZoneExplanationText
	text_end

SafariZoneGateSafariZoneWorker2Text.YoureARegularHereText
	text_far WLA_GLOBAL_SafariZoneGateSafariZoneWorker2YoureARegularHereText
	text_end
