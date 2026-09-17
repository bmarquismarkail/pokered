PewterPokecenter_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

PewterPokecenter_TextPointers:
	def_text_pointers
	dw_const PewterPokecenterNurseText,            TEXT_PEWTERPOKECENTER_NURSE
	dw_const PewterPokecenterGentlemanText,        TEXT_PEWTERPOKECENTER_GENTLEMAN
	dw_const PewterPokecenterJigglypuffText,       TEXT_PEWTERPOKECENTER_JIGGLYPUFF
	dw_const PewterPokecenterLinkReceptionistText, TEXT_PEWTERPOKECENTER_LINK_RECEPTIONIST

PewterPokecenterNurseText:
	script_pokecenter_nurse

PewterPokecenterGentlemanText:
	text_far WLA_GLOBAL_PewterPokecenterGentlemanText
	text_end

PewterPokecenterJigglypuffText:
	text_asm
	ld a, TRUE
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, PewterPokecenterJigglypuffText.Text
	call PrintText

	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
	ld c, 32
	call DelayFrames

	ld hl, PewterPokecenterJigglypuffText.FacingDirections
	ld de, wJigglypuffFacingDirections
	ld bc, PewterPokecenterJigglypuffText.FacingDirectionsEnd - PewterPokecenterJigglypuffText.FacingDirections
	call CopyData

	ld a, [wSprite03StateData1ImageIndex]
	ld hl, wJigglypuffFacingDirections
PewterPokecenterJigglypuffText.findMatchingFacingDirectionLoop
	cp [hl]
	inc hl
	jr nz, PewterPokecenterJigglypuffText.findMatchingFacingDirectionLoop
	dec hl

	push hl
	ld c, bank(Music_JigglypuffSong)
	ld a, MUSIC_JIGGLYPUFF_SONG
	call PlayMusic
	pop hl

PewterPokecenterJigglypuffText.spinMovementLoop
	ld a, [hl]
	ld [wSprite03StateData1ImageIndex], a
; rotate the array
	push hl
	ld hl, wJigglypuffFacingDirections
	ld de, wJigglypuffFacingDirections - 1
	ld bc, PewterPokecenterJigglypuffText.FacingDirectionsEnd - PewterPokecenterJigglypuffText.FacingDirections
	call CopyData
	ld a, [wJigglypuffFacingDirections - 1]
	ld [wJigglypuffFacingDirections + 3], a
	pop hl
	ld c, 24
	call DelayFrames
	ld a, [wChannelSoundIDs]
	ld b, a
	ld a, [wChannelSoundIDs + CHAN2]
	or b
	jr nz, PewterPokecenterJigglypuffText.spinMovementLoop

	ld c, 48
	call DelayFrames
	call PlayDefaultMusic
	jp TextScriptEnd

PewterPokecenterJigglypuffText.Text:
	text_far WLA_GLOBAL_PewterPokecenterJigglypuffText
	text_end

PewterPokecenterJigglypuffText.FacingDirections:
	.DB $30 | SPRITE_FACING_DOWN
	.DB $30 | SPRITE_FACING_LEFT
	.DB $30 | SPRITE_FACING_UP
	.DB $30 | SPRITE_FACING_RIGHT
PewterPokecenterJigglypuffText.FacingDirectionsEnd:

PewterPokecenterLinkReceptionistText:
	script_cable_club_receptionist
