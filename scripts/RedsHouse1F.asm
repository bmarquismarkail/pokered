RedsHouse1F_Script:
	jp EnableAutoTextBoxDrawing

RedsHouse1F_TextPointers:
	def_text_pointers
	dw_const RedsHouse1FMomText, TEXT_REDSHOUSE1F_MOM
	dw_const RedsHouse1FTVText,  TEXT_REDSHOUSE1F_TV

RedsHouse1FMomText:
	text_asm
	ld a, [wStatusFlags4]
	bit BIT_GOT_STARTER, a
	jr nz, RedsHouse1FMomText.heal
	ld hl, RedsHouse1FMomText.WakeUpText
	call PrintText
	jr RedsHouse1FMomText.done
RedsHouse1FMomText.heal
	call RedsHouse1FMomHealScript
RedsHouse1FMomText.done
	jp TextScriptEnd

RedsHouse1FMomText.WakeUpText:
	text_far WLA_GLOBAL_RedsHouse1FMomWakeUpText
	text_end

RedsHouse1FMomHealScript:
	ld hl, RedsHouse1FMomYouShouldRestText
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
RedsHouse1FMomHealScript.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, RedsHouse1FMomHealScript.next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite
	ld hl, RedsHouse1FMomLookingGreatText
	jp PrintText

RedsHouse1FMomYouShouldRestText:
	text_far WLA_GLOBAL_RedsHouse1FMomYouShouldRestText
	text_end
RedsHouse1FMomLookingGreatText:
	text_far WLA_GLOBAL_RedsHouse1FMomLookingGreatText
	text_end

RedsHouse1FTVText:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ld hl, RedsHouse1FTVText.WrongSideText
	jr nz, RedsHouse1FTVText.got_text
	ld hl, RedsHouse1FTVText.StandByMeMovieText
RedsHouse1FTVText.got_text
	call PrintText
	jp TextScriptEnd

RedsHouse1FTVText.StandByMeMovieText:
	text_far WLA_GLOBAL_RedsHouse1FTVStandByMeMovieText
	text_end

RedsHouse1FTVText.WrongSideText:
	text_far WLA_GLOBAL_RedsHouse1FTVWrongSideText
	text_end
