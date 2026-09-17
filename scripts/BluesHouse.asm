BluesHouse_Script:
	call EnableAutoTextBoxDrawing
	ld hl, BluesHouse_ScriptPointers
	ld a, [wBluesHouseCurScript]
	jp CallFunctionInTable

BluesHouse_ScriptPointers:
	def_script_pointers
	dw_const BluesHouseDefaultScript, SCRIPT_BLUESHOUSE_DEFAULT
	dw_const BluesHouseNoopScript,    SCRIPT_BLUESHOUSE_NOOP

BluesHouseDefaultScript:
	SetEvent EVENT_ENTERED_BLUES_HOUSE
	ld a, SCRIPT_BLUESHOUSE_NOOP
	ld [wBluesHouseCurScript], a
	ret

BluesHouseNoopScript:
	ret

BluesHouse_TextPointers:
	def_text_pointers
	dw_const BluesHouseDaisySittingText, TEXT_BLUESHOUSE_DAISY_SITTING
	dw_const BluesHouseDaisyWalkingText, TEXT_BLUESHOUSE_DAISY_WALKING
	dw_const BluesHouseTownMapText,      TEXT_BLUESHOUSE_TOWN_MAP

BluesHouseDaisySittingText:
	text_asm
	CheckEvent EVENT_GOT_TOWN_MAP
	jr nz, BluesHouseDaisySittingText.got_town_map
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, BluesHouseDaisySittingText.give_town_map
	ld hl, BluesHouseDaisyRivalAtLabText
	call PrintText
	jr BluesHouseDaisySittingText.done

BluesHouseDaisySittingText.give_town_map
	ld hl, BluesHouseDaisyOfferMapText
	call PrintText
	lb "bc", TOWN_MAP, 1
	call GiveItem
	jr nc, BluesHouseDaisySittingText.bag_full
	ld a, TOGGLE_TOWN_MAP
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld hl, GotMapText
	call PrintText
	SetEvent EVENT_GOT_TOWN_MAP
	jr BluesHouseDaisySittingText.done

BluesHouseDaisySittingText.got_town_map
	ld hl, BluesHouseDaisyUseMapText
	call PrintText
	jr BluesHouseDaisySittingText.done

BluesHouseDaisySittingText.bag_full
	ld hl, BluesHouseDaisyBagFullText
	call PrintText
BluesHouseDaisySittingText.done
	jp TextScriptEnd

BluesHouseDaisyRivalAtLabText:
	text_far WLA_GLOBAL_BluesHouseDaisyRivalAtLabText
	text_end

BluesHouseDaisyOfferMapText:
	text_far WLA_GLOBAL_BluesHouseDaisyOfferMapText
	text_end

GotMapText:
	text_far WLA_GLOBAL_GotMapText
	sound_get_key_item
	text_end

BluesHouseDaisyBagFullText:
	text_far WLA_GLOBAL_BluesHouseDaisyBagFullText
	text_end

BluesHouseDaisyUseMapText:
	text_far WLA_GLOBAL_BluesHouseDaisyUseMapText
	text_end

BluesHouseDaisyWalkingText:
	text_far WLA_GLOBAL_BluesHouseDaisyWalkingText
	text_end

BluesHouseTownMapText:
	text_far WLA_GLOBAL_BluesHouseTownMapText
	text_end
