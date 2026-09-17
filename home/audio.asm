PlayDefaultMusic:
	call WaitForSoundToFinish
	xor a
	ld c, a
	ld d, a
	ld [wLastMusicSoundID], a
	jr PlayDefaultMusicCommon

PlayDefaultMusicFadeOutCurrent:
; Fade out the current music and then play the default music.
	ld c, 10
	ld d, 0
	ld a, [wStatusFlags4]
	bit BIT_BATTLE_OVER_OR_BLACKOUT, a
	jr z, PlayDefaultMusicCommon
	xor a
	ld [wLastMusicSoundID], a
	ld c, 8
	ld d, c

PlayDefaultMusicCommon:
	ld a, [wWalkBikeSurfState]
	and a
	jr z, PlayDefaultMusicCommon.walking
	cp $2
	jr z, PlayDefaultMusicCommon.surfing
	ld a, MUSIC_BIKE_RIDING
	jr PlayDefaultMusicCommon.next

PlayDefaultMusicCommon.surfing
	ld a, MUSIC_SURFING

PlayDefaultMusicCommon.next
	ld b, a
	ld a, d
	and a ; should current music be faded out first?
	ld a, bank(Music_BikeRiding)
	jr nz, PlayDefaultMusicCommon.next2

; Only change the audio ROM bank if the current music isn't going to be faded
; out before the default music begins.
	ld [wAudioROMBank], a

PlayDefaultMusicCommon.next2
; [wAudioSavedROMBank] will be copied to [wAudioROMBank] after fading out the
; current music (if the current music is faded out).
	ld [wAudioSavedROMBank], a
	jr PlayDefaultMusicCommon.next3

PlayDefaultMusicCommon.walking
	ld a, [wMapMusicSoundID]
	ld b, a
	call CompareMapMusicBankWithCurrentBank
	jr c, PlayDefaultMusicCommon.next4

PlayDefaultMusicCommon.next3
	ld a, [wLastMusicSoundID]
	cp b ; is the default music already playing?
	ret z ; if so, do nothing

PlayDefaultMusicCommon.next4
	ld a, c
	ld [wAudioFadeOutControl], a
	ld a, b
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	jp PlaySound

UpdateMusic6Times:
; This is called when entering a map, before fading out the current music and
; playing the default music (i.e. the map's music or biking/surfing music).
	ld a, [wAudioROMBank]
	ld b, a
	cp bank(Audio1_UpdateMusic)
	jr nz, UpdateMusic6Times.checkForAudio2
; audio 1
	ld hl, Audio1_UpdateMusic
	jr UpdateMusic6Times.next

UpdateMusic6Times.checkForAudio2
	cp bank(Audio2_UpdateMusic)
	jr nz, UpdateMusic6Times.audio3
; audio 2
	ld hl, Audio2_UpdateMusic
	jr UpdateMusic6Times.next

UpdateMusic6Times.audio3
	ld hl, Audio3_UpdateMusic

UpdateMusic6Times.next
	ld c, 6
UpdateMusic6Times.loop
	push bc
	push hl
	call Bankswitch
	pop hl
	pop bc
	dec c
	jr nz, UpdateMusic6Times.loop
	ret

CompareMapMusicBankWithCurrentBank:
; Compares the map music's audio ROM bank with the current audio ROM bank
; and updates the audio ROM bank variables.
; Returns whether the banks are different in carry.
	ld a, [wMapMusicROMBank]
	ld e, a
	ld a, [wAudioROMBank]
	cp e
	jr nz, CompareMapMusicBankWithCurrentBank.differentBanks
	ld [wAudioSavedROMBank], a
	and a
	ret
CompareMapMusicBankWithCurrentBank.differentBanks
	ld a, c ; this is a fade-out counter value and it's always non-zero
	and a
	ld a, e
	jr nz, CompareMapMusicBankWithCurrentBank.next
; If the fade-counter is non-zero, we don't change the audio ROM bank because
; it's needed to keep playing the music as it fades out. The FadeOutAudio
; routine will take care of copying [wAudioSavedROMBank] to [wAudioROMBank]
; when the music has faded out.
	ld [wAudioROMBank], a
CompareMapMusicBankWithCurrentBank.next
	ld [wAudioSavedROMBank], a
	scf
	ret

PlayMusic:
	ld b, a
	ld [wNewSoundID], a
	xor a
	ld [wAudioFadeOutControl], a
	ld a, c
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, b

; plays music specified by a. If value is $ff, music is stopped
PlaySound:
	push hl
	push de
	push bc
	ld b, a
	ld a, [wNewSoundID]
	and a
	jr z, PlaySound.next
	xor a
	ld [wChannelSoundIDs + CHAN5], a
	ld [wChannelSoundIDs + CHAN6], a
	ld [wChannelSoundIDs + CHAN7], a
	ld [wChannelSoundIDs + CHAN8], a
PlaySound.next
	ld a, [wAudioFadeOutControl]
	and a ; has a fade-out length been specified?
	jr z, PlaySound.noFadeOut
	ld a, [wNewSoundID]
	and a ; is the new sound ID 0?
	jr z, PlaySound.done ; if so, do nothing
	xor a
	ld [wNewSoundID], a
	ld a, [wLastMusicSoundID]
	cp $ff ; has the music been stopped?
	jr nz, PlaySound.fadeOut ; if not, fade out the current music
; If it has been stopped, start playing the new music immediately.
	xor a
	ld [wAudioFadeOutControl], a
PlaySound.noFadeOut
	xor a
	ld [wNewSoundID], a
	ldh a, [lobyte(hLoadedROMBank)]
	ldh [lobyte(hSavedROMBank)], a
	ld a, [wAudioROMBank]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	cp bank(Audio1_PlaySound)
	jr nz, PlaySound.checkForAudio2
; audio 1
	ld a, b
	call Audio1_PlaySound
	jr PlaySound.next2

PlaySound.checkForAudio2
	cp bank(Audio2_PlaySound)
	jr nz, PlaySound.audio3
; audio 2
	ld a, b
	call Audio2_PlaySound
	jr PlaySound.next2

PlaySound.audio3
	ld a, b
	call Audio3_PlaySound

PlaySound.next2
	ldh a, [lobyte(hSavedROMBank)]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	jr PlaySound.done

PlaySound.fadeOut
	ld a, b
	ld [wLastMusicSoundID], a
	ld a, [wAudioFadeOutControl]
	ld [wAudioFadeOutCounterReloadValue], a
	ld [wAudioFadeOutCounter], a
	ld a, b
	ld [wAudioFadeOutControl], a

PlaySound.done
	pop bc
	pop de
	pop hl
	ret
