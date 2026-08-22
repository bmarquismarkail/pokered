FadeOutAudio:
	ld a, [wAudioFadeOutControl]
	and a ; currently fading out audio?
	jr nz, FadeOutAudio.fadingOut
	ld a, [wStatusFlags2]
	bit BIT_NO_AUDIO_FADE_OUT, a
	ret nz
	ld a, $77
	ldh [lobyte(rAUDVOL)], a
	ret
FadeOutAudio.fadingOut
	ld a, [wAudioFadeOutCounter]
	and a
	jr z, FadeOutAudio.counterReachedZero
	dec a
	ld [wAudioFadeOutCounter], a
	ret
FadeOutAudio.counterReachedZero
	ld a, [wAudioFadeOutCounterReloadValue]
	ld [wAudioFadeOutCounter], a
	ldh a, [lobyte(rAUDVOL)]
	and a ; has the volume reached 0?
	jr z, FadeOutAudio.fadeOutComplete
	ld b, a
	and $f
	dec a
	ld c, a
	ld a, b
	and $f0
	swap a
	dec a
	swap a
	or c
	ldh [lobyte(rAUDVOL)], a
	ret
FadeOutAudio.fadeOutComplete
	ld a, [wAudioFadeOutControl]
	ld b, a
	xor a
	ld [wAudioFadeOutControl], a
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, b
	ld [wNewSoundID], a
	jp PlaySound
