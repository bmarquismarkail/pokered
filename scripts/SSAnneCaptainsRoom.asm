SSAnneCaptainsRoom_Script:
	call SSAnneCaptainsRoomEventScript
	jp EnableAutoTextBoxDrawing

SSAnneCaptainsRoomEventScript:
	CheckEvent EVENT_RUBBED_CAPTAINS_BACK
	ret nz
	ld hl, wStatusFlags3
	set BIT_NO_NPC_FACE_PLAYER, [hl]
	ret

SSAnneCaptainsRoom_TextPointers:
	def_text_pointers
	dw_const SSAnneCaptainsRoomCaptainText,     TEXT_SSANNECAPTAINSROOM_CAPTAIN
	dw_const SSAnneCaptainsRoomTrashText,       TEXT_SSANNECAPTAINSROOM_TRASH
	dw_const SSAnneCaptainsRoomSeasickBookText, TEXT_SSANNECAPTAINSROOM_SEASICK_BOOK

SSAnneCaptainsRoomCaptainText:
	text_asm
	CheckEvent EVENT_GOT_HM01
	jr nz, SSAnneCaptainsRoomCaptainText.got_item
	ld hl, SSAnneCaptainsRoomRubCaptainsBackText
	call PrintText
	ld hl, SSAnneCaptainsRoomCaptainIFeelMuchBetterText
	call PrintText
	lb "bc", HM_CUT, 1
	call GiveItem
	jr nc, SSAnneCaptainsRoomCaptainText.bag_full
	ld hl, SSAnneCaptainsRoomCaptainReceivedHM01Text
	call PrintText
	SetEvent EVENT_GOT_HM01
	jr SSAnneCaptainsRoomCaptainText.done
SSAnneCaptainsRoomCaptainText.bag_full
	ld hl, SSAnneCaptainsRoomCaptainHM01NoRoomText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_NO_NPC_FACE_PLAYER, [hl]
	jr SSAnneCaptainsRoomCaptainText.done
SSAnneCaptainsRoomCaptainText.got_item
	ld hl, SSAnneCaptainsRoomCaptainNotSickAnymoreText
	call PrintText
SSAnneCaptainsRoomCaptainText.done
	jp TextScriptEnd

SSAnneCaptainsRoomRubCaptainsBackText:
	text_far WLA_GLOBAL_SSAnneCaptainsRoomRubCaptainsBackText
	text_asm
	ld a, [wAudioROMBank]
	cp $1f
	ld [wAudioSavedROMBank], a
	jr nz, SSAnneCaptainsRoomRubCaptainsBackText.not_audio_engine_3
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld a, bank(Music_PkmnHealed)
	ld [wAudioROMBank], a
SSAnneCaptainsRoomRubCaptainsBackText.not_audio_engine_3
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
SSAnneCaptainsRoomRubCaptainsBackText.loop
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, SSAnneCaptainsRoomRubCaptainsBackText.loop
	call PlayDefaultMusic
	SetEvent EVENT_RUBBED_CAPTAINS_BACK
	ld hl, wStatusFlags3
	res BIT_NO_NPC_FACE_PLAYER, [hl]
	jp TextScriptEnd

SSAnneCaptainsRoomCaptainIFeelMuchBetterText:
	text_far WLA_GLOBAL_SSAnneCaptainsRoomCaptainIFeelMuchBetterText
	text_end

SSAnneCaptainsRoomCaptainReceivedHM01Text:
	text_far WLA_GLOBAL_SSAnneCaptainsRoomCaptainReceivedHM01Text
	sound_get_key_item
	text_end

SSAnneCaptainsRoomCaptainNotSickAnymoreText:
	text_far WLA_GLOBAL_SSAnneCaptainsRoomCaptainNotSickAnymoreText
	text_end

SSAnneCaptainsRoomCaptainHM01NoRoomText:
	text_far WLA_GLOBAL_SSAnneCaptainsRoomCaptainHM01NoRoomText
	text_end

SSAnneCaptainsRoomTrashText:
	text_far WLA_GLOBAL_SSAnneCaptainsRoomTrashText
	text_end

SSAnneCaptainsRoomSeasickBookText:
	text_far WLA_GLOBAL_SSAnneCaptainsRoomSeasickBookText
	text_end
