CopycatsHouse2F_Script:
	jp EnableAutoTextBoxDrawing

CopycatsHouse2F_TextPointers:
	def_text_pointers
	dw_const CopycatsHouse2FCopycatText,      TEXT_COPYCATSHOUSE2F_COPYCAT
	dw_const CopycatsHouse2FDoduoText,        TEXT_COPYCATSHOUSE2F_DODUO
	dw_const CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_MONSTER
	dw_const CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_BIRD
	dw_const CopycatsHouse2FRareDollText,     TEXT_COPYCATSHOUSE2F_FAIRY
	dw_const CopycatsHouse2FSNESText,         TEXT_COPYCATSHOUSE2F_SNES
	dw_const CopycatsHouse2FPCText,           TEXT_COPYCATSHOUSE2F_PC

CopycatsHouse2FCopycatText:
	text_asm
	CheckEvent EVENT_GOT_TM31
	jr nz, CopycatsHouse2FCopycatText.got_item
	ld a, TRUE
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CopycatsHouse2FCopycatText.DoYouLikePokemonText
	call PrintText
	ld b, POKE_DOLL
	call IsItemInBag
	jr z, CopycatsHouse2FCopycatText.done
	ld hl, CopycatsHouse2FCopycatText.TM31PreReceiveText
	call PrintText
	lb "bc", TM_MIMIC, 1
	call GiveItem
	jr nc, CopycatsHouse2FCopycatText.bag_full
	ld hl, CopycatsHouse2FCopycatText.ReceivedTM31Text
	call PrintText
	ld a, POKE_DOLL
	ldh [lobyte(hItemToRemoveID)], a
	farcall RemoveItemByID
	SetEvent EVENT_GOT_TM31
	jr CopycatsHouse2FCopycatText.done
CopycatsHouse2FCopycatText.bag_full
	ld hl, CopycatsHouse2FCopycatText.TM31NoRoomText
	call PrintText
	jr CopycatsHouse2FCopycatText.done
CopycatsHouse2FCopycatText.got_item
	ld hl, CopycatsHouse2FCopycatText.TM31Explanation2Text
	call PrintText
CopycatsHouse2FCopycatText.done
	jp TextScriptEnd

CopycatsHouse2FCopycatText.DoYouLikePokemonText:
	text_far WLA_GLOBAL_CopycatsHouse2FCopycatDoYouLikePokemonText
	text_end

CopycatsHouse2FCopycatText.TM31PreReceiveText:
	text_far WLA_GLOBAL_CopycatsHouse2FCopycatTM31PreReceiveText
	text_end

CopycatsHouse2FCopycatText.ReceivedTM31Text:
	text_far WLA_GLOBAL_CopycatsHouse2FCopycatReceivedTM31Text
	sound_get_item_1
CopycatsHouse2FCopycatText.TM31Explanation1Text:
	text_far WLA_GLOBAL_CopycatsHouse2FCopycatTM31Explanation1Text
	text_waitbutton
	text_end

CopycatsHouse2FCopycatText.TM31Explanation2Text:
	text_far WLA_GLOBAL_CopycatsHouse2FCopycatTM31Explanation2Text
	text_end

CopycatsHouse2FCopycatText.TM31NoRoomText:
	text_far WLA_GLOBAL_CopycatsHouse2FCopycatTM31NoRoomText
	text_waitbutton
	text_end

CopycatsHouse2FDoduoText:
	text_far WLA_GLOBAL_CopycatsHouse2FDoduoText
	text_end

CopycatsHouse2FRareDollText:
	text_far WLA_GLOBAL_CopycatsHouse2FRareDollText
	text_end

CopycatsHouse2FSNESText:
	text_far WLA_GLOBAL_CopycatsHouse2FSNESText
	text_end

CopycatsHouse2FPCText:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ld hl, CopycatsHouse2FPCText.CantSeeText
	jr nz, CopycatsHouse2FPCText.notUp
	ld hl, CopycatsHouse2FPCText.MySecretsText
CopycatsHouse2FPCText.notUp
	call PrintText
	jp TextScriptEnd

CopycatsHouse2FPCText.MySecretsText:
	text_far WLA_GLOBAL_CopycatsHouse2FPCMySecretsText
	text_end

CopycatsHouse2FPCText.CantSeeText:
	text_far WLA_GLOBAL_CopycatsHouse2FPCCantSeeText
	text_end
