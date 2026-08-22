BillsHouse_Script:
	call EnableAutoTextBoxDrawing
	ld a, [wBillsHouseCurScript]
	ld hl, BillsHouse_ScriptPointers
	jp CallFunctionInTable

BillsHouse_ScriptPointers:
	def_script_pointers
	dw_const BillsHouseDefaultScript,              SCRIPT_BILLSHOUSE_DEFAULT
	dw_const BillsHousePokemonWalkToMachineScript, SCRIPT_BILLSHOUSE_POKEMON_WALK_TO_MACHINE
	dw_const BillsHousePokemonEntersMachineScript, SCRIPT_BILLSHOUSE_POKEMON_ENTERS_MACHINE
	dw_const BillsHouseBillExitsMachineScript,     SCRIPT_BILLSHOUSE_BILL_EXITS_MACHINE
	dw_const BillsHouseCleanupScript,              SCRIPT_BILLSHOUSE_CLEANUP
	dw_const BillsHousePCScript,                   SCRIPT_BILLSHOUSE_PC

BillsHouseDefaultScript:
	ret

BillsHousePokemonWalkToMachineScript:
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	ld de, BillsHousePokemonWalkToMachineScript.PokemonWalkToMachineMovement
	jr nz, BillsHousePokemonWalkToMachineScript.notDown
	ld de, BillsHousePokemonWalkToMachineScript.PokemonWalkAroundPlayerMovement
BillsHousePokemonWalkToMachineScript.notDown
	ld a, BILLSHOUSE_BILL_POKEMON
	ldh [lobyte(hSpriteIndex)], a
	call MoveSprite
	ld a, SCRIPT_BILLSHOUSE_POKEMON_ENTERS_MACHINE
	ld [wBillsHouseCurScript], a
	ret

BillsHousePokemonWalkToMachineScript.PokemonWalkToMachineMovement:
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_UP
	.DB -1 ; end

; make Bill walk around the player
BillsHousePokemonWalkToMachineScript.PokemonWalkAroundPlayerMovement:
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_LEFT
	.DB NPC_MOVEMENT_UP
	.DB -1 ; end

BillsHousePokemonEntersMachineScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_BILL_POKEMON
	ld [wToggleableObjectIndex], a
	predef HideObject
	SetEvent EVENT_BILL_SAID_USE_CELL_SEPARATOR
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_BILLSHOUSE_BILL_EXITS_MACHINE
	ld [wBillsHouseCurScript], a
	ret

BillsHouseBillExitsMachineScript:
	CheckEvent EVENT_USED_CELL_SEPARATOR_ON_BILL
	ret z
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, BILLSHOUSE_BILL1
	ld [wSpriteIndex], a
	ld a, $c
	ldh [lobyte(hSpriteScreenYCoord)], a
	ld a, $40
	ldh [lobyte(hSpriteScreenXCoord)], a
	ld a, 6
	ldh [lobyte(hSpriteMapYCoord)], a
	ld a, 5
	ldh [lobyte(hSpriteMapXCoord)], a
	call SetSpritePosition1
	ld a, TOGGLE_BILL_1
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld c, 8
	call DelayFrames
	ld a, BILLSHOUSE_BILL1
	ldh [lobyte(hSpriteIndex)], a
	ld de, BillsHouseBillExitsMachineScript.BillExitMachineMovement
	call MoveSprite
	ld a, SCRIPT_BILLSHOUSE_CLEANUP
	ld [wBillsHouseCurScript], a
	ret

BillsHouseBillExitsMachineScript.BillExitMachineMovement:
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_DOWN
	.DB -1 ; end

BillsHouseCleanupScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	SetEvent EVENT_MET_BILL_2 ; this event seems redundant
	SetEvent EVENT_MET_BILL
	ld a, SCRIPT_BILLSHOUSE_DEFAULT
	ld [wBillsHouseCurScript], a
	ret

BillsHousePCScript:
	ld a, TEXT_BILLSHOUSE_ACTIVATE_PC
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, SCRIPT_BILLSHOUSE_DEFAULT
	ld [wBillsHouseCurScript], a
	ret

BillsHouse_TextPointers:
	def_text_pointers
	dw_const BillsHouseBillPokemonText,               TEXT_BILLSHOUSE_BILL_POKEMON
	dw_const BillsHouseBillSSTicketText,              TEXT_BILLSHOUSE_BILL_SS_TICKET
	dw_const BillsHouseBillCheckOutMyRarePokemonText, TEXT_BILLSHOUSE_BILL_CHECK_OUT_MY_RARE_POKEMON
	dw_const BillsHouseActivatePCScript,              TEXT_BILLSHOUSE_ACTIVATE_PC

BillsHouseActivatePCScript:
	script_bills_pc

BillsHouseBillPokemonText:
	text_asm
	ld hl, BillsHouseBillPokemonText.ImNotAPokemonText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, BillsHouseBillPokemonText.answered_no
BillsHouseBillPokemonText.use_machine
	ld hl, BillsHouseBillPokemonText.UseSeparationSystemText
	call PrintText
	ld a, SCRIPT_BILLSHOUSE_POKEMON_WALK_TO_MACHINE
	ld [wBillsHouseCurScript], a
	jr BillsHouseBillPokemonText.text_script_end
BillsHouseBillPokemonText.answered_no
	ld hl, BillsHouseBillPokemonText.NoYouGottaHelpText
	call PrintText
	jr BillsHouseBillPokemonText.use_machine
BillsHouseBillPokemonText.text_script_end
	jp TextScriptEnd

BillsHouseBillPokemonText.ImNotAPokemonText:
	text_far WLA_GLOBAL_BillsHouseBillImNotAPokemonText
	text_end

BillsHouseBillPokemonText.UseSeparationSystemText:
	text_far WLA_GLOBAL_BillsHouseBillUseSeparationSystemText
	text_end

BillsHouseBillPokemonText.NoYouGottaHelpText:
	text_far WLA_GLOBAL_BillsHouseBillNoYouGottaHelpText
	text_end

BillsHouseBillSSTicketText:
	text_asm
	CheckEvent EVENT_GOT_SS_TICKET
	jr nz, BillsHouseBillSSTicketText.got_ss_ticket
	ld hl, BillsHouseBillSSTicketText.ThankYouText
	call PrintText
	lb "bc", S_S_TICKET, 1
	call GiveItem
	jr nc, BillsHouseBillSSTicketText.bag_full
	ld hl, BillsHouseBillSSTicketText.SSTicketReceivedText
	call PrintText
	SetEvent EVENT_GOT_SS_TICKET
	ld a, TOGGLE_CERULEAN_GUARD_1
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, TOGGLE_CERULEAN_GUARD_2
	ld [wToggleableObjectIndex], a
	predef HideObject
BillsHouseBillSSTicketText.got_ss_ticket
	ld hl, BillsHouseBillSSTicketText.WhyDontYouGoInsteadOfMeText
	call PrintText
	jr BillsHouseBillSSTicketText.text_script_end
BillsHouseBillSSTicketText.bag_full
	ld hl, BillsHouseBillSSTicketText.SSTicketNoRoomText
	call PrintText
BillsHouseBillSSTicketText.text_script_end
	jp TextScriptEnd

BillsHouseBillSSTicketText.ThankYouText:
	text_far WLA_GLOBAL_BillsHouseBillThankYouText
	text_end

BillsHouseBillSSTicketText.SSTicketReceivedText:
	text_far WLA_GLOBAL_SSTicketReceivedText
	sound_get_key_item
	text_promptbutton
	text_end

BillsHouseBillSSTicketText.SSTicketNoRoomText:
	text_far WLA_GLOBAL_SSTicketNoRoomText
	text_end

BillsHouseBillSSTicketText.WhyDontYouGoInsteadOfMeText:
	text_far WLA_GLOBAL_BillsHouseBillWhyDontYouGoInsteadOfMeText
	text_end

BillsHouseBillCheckOutMyRarePokemonText:
	text_asm
	ld hl, BillsHouseBillCheckOutMyRarePokemonText.Text
	call PrintText
	jp TextScriptEnd

BillsHouseBillCheckOutMyRarePokemonText.Text:
	text_far WLA_GLOBAL_BillsHouseBillCheckOutMyRarePokemonText
	text_end
