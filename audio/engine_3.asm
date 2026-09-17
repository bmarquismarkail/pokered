; The third of three duplicated sound engines.

Audio3_UpdateMusic:
	ld c, CHAN1
Audio3_UpdateMusic.loop
	ld b, 0
	ld hl, wChannelSoundIDs
	add hl, bc
	ld a, [hl]
	and a
	jr z, Audio3_UpdateMusic.nextChannel
	ld a, c
	cp CHAN5
	jr nc, Audio3_UpdateMusic.applyAffects ; if sfx channel
	ld a, [wMuteAudioAndPauseMusic]
	and a
	jr z, Audio3_UpdateMusic.applyAffects
	bit BIT_MUTE_AUDIO, a
	jr nz, Audio3_UpdateMusic.nextChannel
	set BIT_MUTE_AUDIO, a
	ld [wMuteAudioAndPauseMusic], a
	xor a ; disable all channels' output
	ldh [lobyte(rAUDTERM)], a
	ldh [lobyte(rAUD3ENA)], a
	ld a, AUD3ENA_ON
	ldh [lobyte(rAUD3ENA)], a
	jr Audio3_UpdateMusic.nextChannel
Audio3_UpdateMusic.applyAffects
	call Audio3_ApplyMusicAffects
Audio3_UpdateMusic.nextChannel
	ld a, c
	inc c ; inc channel number
	cp CHAN8
	jr nz, Audio3_UpdateMusic.loop
	ret

; this routine checks flags for music effects currently applied
; to the channel and calls certain functions based on flags.
Audio3_ApplyMusicAffects:
	ld b, $0
	ld hl, wChannelNoteDelayCounters ; delay until next note
	add hl, bc
	ld a, [hl]
	cp 1 ; if the delay is 1, play next note
	jp z, Audio3_PlayNextNote
	dec a ; otherwise, decrease the delay timer
	ld [hl], a
	ld a, c
	cp CHAN5
	jr nc, Audio3_ApplyMusicAffects.startChecks ; if a sfx channel
	ld hl, wChannelSoundIDs + CHAN5
	add hl, bc
	ld a, [hl]
	and a
	jr z, Audio3_ApplyMusicAffects.startChecks
	ret
Audio3_ApplyMusicAffects.startChecks
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_ROTATE_DUTY_CYCLE, [hl]
	jr z, Audio3_ApplyMusicAffects.checkForExecuteMusic
	call Audio3_ApplyDutyCyclePattern
Audio3_ApplyMusicAffects.checkForExecuteMusic
	ld b, 0
	ld hl, wChannelFlags2
	add hl, bc
	bit BIT_EXECUTE_MUSIC, [hl]
	jr nz, Audio3_ApplyMusicAffects.checkForPitchSlide
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_NOISE_OR_SFX, [hl]
	jr nz, Audio3_ApplyMusicAffects.skipPitchSlideVibrato
Audio3_ApplyMusicAffects.checkForPitchSlide
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_PITCH_SLIDE_ON, [hl]
	jr z, Audio3_ApplyMusicAffects.checkVibratoDelay
	jp Audio3_ApplyPitchSlide
Audio3_ApplyMusicAffects.checkVibratoDelay
	ld hl, wChannelVibratoDelayCounters
	add hl, bc
	ld a, [hl]
	and a ; check if delay is over
	jr z, Audio3_ApplyMusicAffects.checkForVibrato
	dec [hl] ; otherwise, dec delay
Audio3_ApplyMusicAffects.skipPitchSlideVibrato
	ret
Audio3_ApplyMusicAffects.checkForVibrato
	ld hl, wChannelVibratoExtents
	add hl, bc
	ld a, [hl]
	and a
	jr nz, Audio3_ApplyMusicAffects.vibrato
	ret ; no vibrato
Audio3_ApplyMusicAffects.vibrato
	ld d, a
	ld hl, wChannelVibratoRates
	add hl, bc
	ld a, [hl]
	and $f
	and a
	jr z, Audio3_ApplyMusicAffects.applyVibrato
	dec [hl] ; decrement counter
	ret
Audio3_ApplyMusicAffects.applyVibrato
	ld a, [hl]
	swap [hl]
	or [hl]
	ld [hl], a ; reload the counter
	ld hl, wChannelFrequencyLowBytes
	add hl, bc
	ld e, [hl] ; get note pitch
	ld hl, wChannelFlags1
	add hl, bc
; This is the only code that sets/resets the vibrato direction bit, so it
; continuously alternates which path it takes.
	bit BIT_VIBRATO_DIRECTION, [hl]
	jr z, Audio3_ApplyMusicAffects.unset
	res BIT_VIBRATO_DIRECTION, [hl]
	ld a, d
	and $f
	ld d, a
	ld a, e
	sub d
	jr nc, Audio3_ApplyMusicAffects.noCarry
	ld a, 0
Audio3_ApplyMusicAffects.noCarry
	jr Audio3_ApplyMusicAffects.done
Audio3_ApplyMusicAffects.unset
	set BIT_VIBRATO_DIRECTION, [hl]
	ld a, d
	and $f0
	swap a
	add e
	jr nc, Audio3_ApplyMusicAffects.done
	ld a, $ff
Audio3_ApplyMusicAffects.done
	ld d, a
	ld b, REG_FREQUENCY_LO
	call Audio3_GetRegisterPointer
	ld [hl], d
	ret

; this routine executes all music commands that take up no time,
; like tempo changes, duty cycle changes etc. and doesn't return
; until the first note is reached
Audio3_PlayNextNote:
; reload the vibrato delay counter
	ld hl, wChannelVibratoDelayCounterReloadValues
	add hl, bc
	ld a, [hl]
	ld hl, wChannelVibratoDelayCounters
	add hl, bc
	ld [hl], a

	ld hl, wChannelFlags1
	add hl, bc
	res BIT_PITCH_SLIDE_ON, [hl]
	res BIT_PITCH_SLIDE_DECREASING, [hl]
	call Audio3_sound_ret
	ret

Audio3_sound_ret:
	call Audio3_GetNextMusicByte
	ld d, a
	cp sound_ret_cmd
	jp nz, Audio3_sound_call
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_SOUND_CALL, [hl]
	jr nz, Audio3_sound_ret.returnFromCall
	ld a, c
	cp CHAN4
	jr nc, Audio3_sound_ret.noiseOrSfxChannel
	jr Audio3_sound_ret.disableChannelOutput
Audio3_sound_ret.noiseOrSfxChannel
	res BIT_NOISE_OR_SFX, [hl]
	ld hl, wChannelFlags2
	add hl, bc
	res BIT_EXECUTE_MUSIC, [hl]
	cp CHAN7
	jr nz, Audio3_sound_ret.skipSfxChannel3
; restart hardware channel 3 (wave channel) output
	ld a, AUD3ENA_OFF
	ldh [lobyte(rAUD3ENA)], a
	ld a, AUD3ENA_ON
	ldh [lobyte(rAUD3ENA)], a
Audio3_sound_ret.skipSfxChannel3
	jr nz, Audio3_sound_ret.dontDisable
	ld a, [wDisableChannelOutputWhenSfxEnds]
	and a
	jr z, Audio3_sound_ret.dontDisable
	xor a
	ld [wDisableChannelOutputWhenSfxEnds], a
	jr Audio3_sound_ret.disableChannelOutput
Audio3_sound_ret.dontDisable
	jr Audio3_sound_ret.afterDisable
Audio3_sound_ret.returnFromCall
	res BIT_SOUND_CALL, [hl]
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, wChannelCommandPointers
	add hl, de
	push hl ; store current channel address
	ld hl, wChannelReturnAddresses
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a ; loads channel address to return to
	jp Audio3_sound_ret
Audio3_sound_ret.disableChannelOutput
	ld hl, Audio3_HWChannelDisableMasks
	add hl, bc
	ldh a, [lobyte(rAUDTERM)]
	and [hl]
	ldh [lobyte(rAUDTERM)], a
Audio3_sound_ret.afterDisable
	ld a, [wChannelSoundIDs + CHAN5]
	cp CRY_SFX_START
	jr nc, Audio3_sound_ret.maybeCry
	jr Audio3_sound_ret.skipCry
Audio3_sound_ret.maybeCry
	ld a, [wChannelSoundIDs + CHAN5]
	cp CRY_SFX_END
	jr z, Audio3_sound_ret.skipCry
	jr c, Audio3_sound_ret.cry
	jr Audio3_sound_ret.skipCry
Audio3_sound_ret.cry
	ld a, c
	cp CHAN5
	jr z, Audio3_sound_ret.skipRewind
	call Audio3_GoBackOneCommandIfCry
	ret c
Audio3_sound_ret.skipRewind
	ld a, [wSavedVolume]
	ldh [lobyte(rAUDVOL)], a
	xor a
	ld [wSavedVolume], a
Audio3_sound_ret.skipCry
	ld hl, wChannelSoundIDs
	add hl, bc
	ld [hl], b
	ret

Audio3_sound_call:
	cp sound_call_cmd
	jp nz, Audio3_sound_loop
	call Audio3_GetNextMusicByte
	push af
	call Audio3_GetNextMusicByte
	ld d, a
	pop af
	ld e, a
	push de ; store pointer
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, wChannelCommandPointers
	add hl, de
	push hl
	ld hl, wChannelReturnAddresses
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hld]
	ld [de], a ; copy current channel address
	pop de
	ld [hl], e
	inc hl
	ld [hl], d ; overwrite current address with pointer
	ld b, $0
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_SOUND_CALL, [hl] ; set the call flag
	jp Audio3_sound_ret

Audio3_sound_loop:
	cp sound_loop_cmd
	jp nz, Audio3_note_type
	call Audio3_GetNextMusicByte
	ld e, a
	and a
	jr z, Audio3_sound_loop.infiniteLoop
	ld b, 0
	ld hl, wChannelLoopCounters
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, Audio3_sound_loop.loopAgain
	ld a, $1 ; if no more loops to make,
	ld [hl], a
	call Audio3_GetNextMusicByte ; skip pointer
	call Audio3_GetNextMusicByte
	jp Audio3_sound_ret
Audio3_sound_loop.loopAgain ; inc loop count
	inc a
	ld [hl], a
	; fall through
Audio3_sound_loop.infiniteLoop ; overwrite current address with pointer
	call Audio3_GetNextMusicByte
	push af
	call Audio3_GetNextMusicByte
	ld b, a
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, wChannelCommandPointers
	add hl, de
	pop af
	ld [hli], a
	ld [hl], b
	jp Audio3_sound_ret

Audio3_note_type:
	and $f0
	cp note_type_cmd
	jp nz, Audio3_toggle_perfect_pitch
	ld a, d
	and $f
	ld b, $0
	ld hl, wChannelNoteSpeeds
	add hl, bc
	ld [hl], a ; store low nibble as speed
	ld a, c
	cp CHAN4
	jr z, Audio3_note_type.noiseChannel ; noise channel has 0 params
	call Audio3_GetNextMusicByte
	ld d, a
	ld a, c
	cp CHAN3
	jr z, Audio3_note_type.musicChannel3
	cp CHAN7
	jr nz, Audio3_note_type.skipChannel3
	ld hl, wSfxWaveInstrument
	jr Audio3_note_type.channel3
Audio3_note_type.musicChannel3
	ld hl, wMusicWaveInstrument
Audio3_note_type.channel3
	ld a, d
	and $f
	ld [hl], a ; store low nibble of param as wave instrument
	ld a, d
	and $30
	sla a
	ld d, a
	; fall through

	; if channel 3, store high nibble as volume
	; else, store volume (high nibble) and fade (low nibble)
Audio3_note_type.skipChannel3
	ld b, 0
	ld hl, wChannelVolumes
	add hl, bc
	ld [hl], d
Audio3_note_type.noiseChannel
	jp Audio3_sound_ret

Audio3_toggle_perfect_pitch:
	ld a, d
	cp toggle_perfect_pitch_cmd
	jr nz, Audio3_vibrato
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	ld a, [hl]
	xor 1 << BIT_PERFECT_PITCH
	ld [hl], a
	jp Audio3_sound_ret

Audio3_vibrato:
	cp vibrato_cmd
	jr nz, Audio3_pitch_slide
	call Audio3_GetNextMusicByte
	ld b, 0
	ld hl, wChannelVibratoDelayCounters
	add hl, bc
	ld [hl], a ; store delay
	ld hl, wChannelVibratoDelayCounterReloadValues
	add hl, bc
	ld [hl], a ; store delay
	call Audio3_GetNextMusicByte
	ld d, a

; The high nybble of the command byte is the extent of the vibrato.
; Let n be the extent.
; The upper nybble of the channel's byte in the wChannelVibratoExtents
; array will store the extent above the note: (n / 2) + (n % 2).
; The lower nybble will store the extent below the note: (n / 2).
; These two values add to the total extent, n.
	and $f0
	swap a
	ld b, 0
	ld hl, wChannelVibratoExtents
	add hl, bc
	srl a
	ld e, a
	adc b
	swap a
	or e
	ld [hl], a

; The low nybble of the command byte is the rate of the vibrato.
; The high and low nybbles of the channel's byte in the wChannelVibratoRates
; array are both initialised to this value because the high nybble is the
; counter reload value and the low nybble is the counter itself, which should
; start at its value upon reload.
	ld a, d
	and $f
	ld d, a
	ld hl, wChannelVibratoRates
	add hl, bc
	swap a
	or d
	ld [hl], a

	jp Audio3_sound_ret

Audio3_pitch_slide:
	cp pitch_slide_cmd
	jr nz, Audio3_duty_cycle
	call Audio3_GetNextMusicByte
	ld b, 0
	ld hl, wChannelPitchSlideLengthModifiers
	add hl, bc
	ld [hl], a
	call Audio3_GetNextMusicByte
	ld d, a
	and $f0
	swap a
	ld b, a
	ld a, d
	and $f
	call Audio3_CalculateFrequency
	ld b, 0
	ld hl, wChannelPitchSlideTargetFrequencyHighBytes
	add hl, bc
	ld [hl], d
	ld hl, wChannelPitchSlideTargetFrequencyLowBytes
	add hl, bc
	ld [hl], e
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_PITCH_SLIDE_ON, [hl]
	call Audio3_GetNextMusicByte
	ld d, a
	jp Audio3_note_length

Audio3_duty_cycle:
	cp duty_cycle_cmd
	jr nz, Audio3_tempo
	call Audio3_GetNextMusicByte
	rrca
	rrca
	and $c0
	ld b, 0
	ld hl, wChannelDutyCycles
	add hl, bc
	ld [hl], a ; store duty cycle
	jp Audio3_sound_ret

Audio3_tempo:
	cp tempo_cmd
	jr nz, Audio3_stereo_panning
	ld a, c
	cp CHAN5
	jr nc, Audio3_tempo.sfxChannel
	call Audio3_GetNextMusicByte
	ld [wMusicTempo], a ; store first param
	call Audio3_GetNextMusicByte
	ld [wMusicTempo + 1], a ; store second param
	xor a
	ld [wChannelNoteDelayCountersFractionalPart], a ; clear RAM
	ld [wChannelNoteDelayCountersFractionalPart + 1], a
	ld [wChannelNoteDelayCountersFractionalPart + 2], a
	ld [wChannelNoteDelayCountersFractionalPart + 3], a
	jr Audio3_tempo.musicChannelDone
Audio3_tempo.sfxChannel
	call Audio3_GetNextMusicByte
	ld [wSfxTempo], a ; store first param
	call Audio3_GetNextMusicByte
	ld [wSfxTempo + 1], a ; store second param
	xor a
	ld [wChannelNoteDelayCountersFractionalPart + 4], a ; clear RAM
	ld [wChannelNoteDelayCountersFractionalPart + 5], a
	ld [wChannelNoteDelayCountersFractionalPart + 6], a
	ld [wChannelNoteDelayCountersFractionalPart + 7], a
Audio3_tempo.musicChannelDone
	jp Audio3_sound_ret

Audio3_stereo_panning:
	cp stereo_panning_cmd
	jr nz, Audio3_unknownmusic0xef
	call Audio3_GetNextMusicByte
	ld [wStereoPanning], a ; store panning
	jp Audio3_sound_ret

; this appears to never be used
Audio3_unknownmusic0xef:
	cp unknownmusic0xef_cmd
	jr nz, Audio3_duty_cycle_pattern
	call Audio3_GetNextMusicByte
	push bc
	call Audio3_PlaySound
	pop bc
	ld a, [wDisableChannelOutputWhenSfxEnds]
	and a
	jr nz, Audio3_unknownmusic0xef.skip
	ld a, [wChannelSoundIDs + CHAN8]
	ld [wDisableChannelOutputWhenSfxEnds], a
	xor a
	ld [wChannelSoundIDs + CHAN8], a
Audio3_unknownmusic0xef.skip
	jp Audio3_sound_ret

Audio3_duty_cycle_pattern:
	cp duty_cycle_pattern_cmd
	jr nz, Audio3_volume
	call Audio3_GetNextMusicByte
	ld b, 0
	ld hl, wChannelDutyCyclePatterns
	add hl, bc
	ld [hl], a ; store full pattern
	and %11000000
	ld hl, wChannelDutyCycles
	add hl, bc
	ld [hl], a ; store first duty cycle
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_ROTATE_DUTY_CYCLE, [hl]
	jp Audio3_sound_ret

Audio3_volume:
	cp volume_cmd
	jr nz, Audio3_execute_music
	call Audio3_GetNextMusicByte
	ldh [lobyte(rAUDVOL)], a ; store volume
	jp Audio3_sound_ret

Audio3_execute_music:
	cp execute_music_cmd
	jr nz, Audio3_octave
	ld b, $0
	ld hl, wChannelFlags2
	add hl, bc
	set BIT_EXECUTE_MUSIC, [hl]
	jp Audio3_sound_ret

Audio3_octave:
	and $f0
	cp octave_cmd
	jr nz, Audio3_sfx_note
	ld hl, wChannelOctaves
	ld b, 0
	add hl, bc
	ld a, d
	and $f
	ld [hl], a ; store low nibble as octave
	jp Audio3_sound_ret

; sfx_note is either square_note or noise_note depending on the channel
Audio3_sfx_note:
	cp sfx_note_cmd
	jr nz, Audio3_pitch_sweep
	ld a, c
	cp CHAN4 ; is this a noise or sfx channel?
	jr c, Audio3_pitch_sweep ; no
	ld b, 0
	ld hl, wChannelFlags2
	add hl, bc
	bit BIT_EXECUTE_MUSIC, [hl] ; is execute_music being used?
	jr nz, Audio3_pitch_sweep ; yes
	call Audio3_note_length

; This code seems to do the same thing as what Audio3_ApplyDutyCycleAndSoundLength
; does below.
	ld d, a
	ld b, 0
	ld hl, wChannelDutyCycles
	add hl, bc
	ld a, [hl]
	or d
	ld d, a
	ld b, REG_DUTY_SOUND_LEN
	call Audio3_GetRegisterPointer
	ld [hl], d

	call Audio3_GetNextMusicByte
	ld d, a
	ld b, REG_VOLUME_ENVELOPE
	call Audio3_GetRegisterPointer
	ld [hl], d
	call Audio3_GetNextMusicByte
	ld e, a
	ld a, c
	cp CHAN8
	ld a, 0
	jr z, Audio3_sfx_note.skip
; Channels 1 through 3 have 2 registers that control frequency, but the noise
; channel a single register (the polynomial counter) that controls frequency,
; so this command has one less byte on the noise channel.
	push de
	call Audio3_GetNextMusicByte
	pop de
Audio3_sfx_note.skip
	ld d, a
	push de
	call Audio3_ApplyDutyCycleAndSoundLength
	call Audio3_EnableChannelOutput
	pop de
	call Audio3_ApplyWavePatternAndFrequency
	ret

Audio3_pitch_sweep:
	ld a, c
	cp CHAN5
	jr c, Audio3_note ; if not a sfx
	ld a, d
	cp pitch_sweep_cmd
	jr nz, Audio3_note
	ld b, $0
	ld hl, wChannelFlags2
	add hl, bc
	bit BIT_EXECUTE_MUSIC, [hl]
	jr nz, Audio3_note ; no
	call Audio3_GetNextMusicByte
	ldh [lobyte(rAUD1SWEEP)], a
	jp Audio3_sound_ret

Audio3_note:
	ld a, c
	cp CHAN4
	jr nz, Audio3_note_length ; if not noise channel
	ld a, d
	and $f0
	cp drum_note_cmd
	jr z, Audio3_note.drum_note
	jr nc, Audio3_note_length

	; this executes when on the noise channel and
	; the command id is less than drum_note_cmd ($b0)
	; in this case, the upper nybble is used as the noise instrument ($1-$a)
	; and the lower nybble is the length minus 1 (0-15)
	; however, this doesn't work for instrument #2 because the command id
	; is captured by the noise_note command (command id $2x)
	; this essentially acts like a drum_note command that is only 1 byte
	; instead of 2 and can only be used with instruments 1 and 3 through 10
	; this is unused by the game
	swap a
	ld b, a
	ld a, d
	and $f
	ld d, a
	ld a, b
	push de
	push bc
	jr Audio3_note.playDnote

Audio3_note.drum_note
	ld a, d
	and $f
	push af
	push bc
	call Audio3_GetNextMusicByte ; get drum_note instrument
Audio3_note.playDnote
	ld d, a
	ld a, [wDisableChannelOutputWhenSfxEnds]
	and a
	jr nz, Audio3_note.skipDnote
	ld a, d
	call Audio3_PlaySound
Audio3_note.skipDnote
	pop bc
	pop de

Audio3_note_length:
	ld a, d
	push af
	and $f
	inc a
	ld b, 0
	ld e, a  ; store note length (in 16ths)
	ld d, b
	ld hl, wChannelNoteSpeeds
	add hl, bc
	ld a, [hl]
	ld l, b
	call Audio3_MultiplyAdd
	ld a, c
	cp CHAN5
	jr nc, Audio3_note_length.sfxChannel
	ld a, [wMusicTempo]
	ld d, a
	ld a, [wMusicTempo + 1]
	ld e, a
	jr Audio3_note_length.skip
Audio3_note_length.sfxChannel
	ld d, $1
	ld e, $0
	cp CHAN8
	jr z, Audio3_note_length.skip ; if noise channel
	call Audio3_SetSfxTempo
	ld a, [wSfxTempo]
	ld d, a
	ld a, [wSfxTempo + 1]
	ld e, a
Audio3_note_length.skip
	ld a, l ; a = note_length * note_speed
	ld b, 0
	ld hl, wChannelNoteDelayCountersFractionalPart
	add hl, bc
	ld l, [hl]
	call Audio3_MultiplyAdd
	ld e, l
	ld d, h ; de = note_delay_frac_part + (note_length * note_speed * tempo)
	ld hl, wChannelNoteDelayCountersFractionalPart
	add hl, bc
	ld [hl], e
	ld a, d
	ld hl, wChannelNoteDelayCounters
	add hl, bc
	ld [hl], a
	ld hl, wChannelFlags2
	add hl, bc
	bit BIT_EXECUTE_MUSIC, [hl]
	jr nz, Audio3_note_pitch
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_NOISE_OR_SFX, [hl]
	jr z, Audio3_note_pitch
	pop hl
	ret

Audio3_note_pitch:
	pop af
	and $f0
	cp rest_cmd
	jr nz, Audio3_note_pitch.notRest
	ld a, c
	cp CHAN5
	jr nc, Audio3_note_pitch.next
; If this isn't an SFX channel, try the corresponding SFX channel.
	ld hl, wChannelSoundIDs + CHAN5
	add hl, bc
	ld a, [hl]
	and a
	jr nz, Audio3_note_pitch.done
	; fall through
Audio3_note_pitch.next
	ld a, c
	cp CHAN3
	jr z, Audio3_note_pitch.channel3
	cp CHAN7
	jr nz, Audio3_note_pitch.notChannel3
Audio3_note_pitch.channel3
	ld b, 0
	ld hl, Audio3_HWChannelDisableMasks
	add hl, bc
	ldh a, [lobyte(rAUDTERM)]
	and [hl]
	ldh [lobyte(rAUDTERM)], a ; disable hardware channel 3's output
	jr Audio3_note_pitch.done
Audio3_note_pitch.notChannel3
	ld b, REG_VOLUME_ENVELOPE
	call Audio3_GetRegisterPointer
	ld a, $8 ; fade in sound
	ld [hli], a
	inc hl
	ld a, $80 ; restart sound
	ld [hl], a
Audio3_note_pitch.done
	ret
Audio3_note_pitch.notRest
	swap a
	ld b, 0
	ld hl, wChannelOctaves
	add hl, bc
	ld b, [hl]
	call Audio3_CalculateFrequency
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_PITCH_SLIDE_ON, [hl]
	jr z, Audio3_note_pitch.skipPitchSlide
	call Audio3_InitPitchSlideVars
Audio3_note_pitch.skipPitchSlide
	push de
	ld a, c
	cp CHAN5
	jr nc, Audio3_note_pitch.sfxChannel ; if sfx channel
; If this isn't an SFX channel, try the corresponding SFX channel.
	ld hl, wChannelSoundIDs + CHAN5
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	and a
	jr nz, Audio3_note_pitch.noSfx
	jr Audio3_note_pitch.sfxChannel
Audio3_note_pitch.noSfx
	pop de
	ret
Audio3_note_pitch.sfxChannel
	ld b, 0
	ld hl, wChannelVolumes
	add hl, bc
	ld d, [hl]
	ld b, REG_VOLUME_ENVELOPE
	call Audio3_GetRegisterPointer
	ld [hl], d
	call Audio3_ApplyDutyCycleAndSoundLength
	call Audio3_EnableChannelOutput
	pop de
	ld b, $0
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_PERFECT_PITCH, [hl] ; has toggle_perfect_pitch been used?
	jr z, Audio3_note_pitch.skipFrequencyInc
	inc e                       ; if yes, increment the frequency by 1
	jr nc, Audio3_note_pitch.skipFrequencyInc    ; Likely a mistake, because `inc` does not set flag C.
	                            ; Fortunately this does not seem to affect any notes that actually occur.
	inc d
Audio3_note_pitch.skipFrequencyInc
	ld hl, wChannelFrequencyLowBytes
	add hl, bc
	ld [hl], e
	call Audio3_ApplyWavePatternAndFrequency
	ret

Audio3_EnableChannelOutput:
	ld b, 0
	ld hl, Audio3_HWChannelEnableMasks
	add hl, bc
	ldh a, [lobyte(rAUDTERM)]
	or [hl] ; set this channel's bits
	ld d, a
	ld a, c
	cp CHAN8
	jr z, Audio3_EnableChannelOutput.noiseChannelOrNoSfx
	cp CHAN5
	jr nc, Audio3_EnableChannelOutput.skip ; if sfx channel
; If this isn't an SFX channel, try the corresponding SFX channel.
	ld hl, wChannelSoundIDs + CHAN5
	add hl, bc
	ld a, [hl]
	and a
	jr nz, Audio3_EnableChannelOutput.skip
Audio3_EnableChannelOutput.noiseChannelOrNoSfx
; If this is the SFX noise channel or a music channel whose corresponding
; SFX channel is off, apply stereo panning.
	ld a, [wStereoPanning]
	ld hl, Audio3_HWChannelEnableMasks
	add hl, bc
	and [hl]
	ld d, a
	ldh a, [lobyte(rAUDTERM)]
	ld hl, Audio3_HWChannelDisableMasks
	add hl, bc
	and [hl] ; reset this channel's output bits
	or d ; set this channel's output bits that enabled in [wStereoPanning]
	ld d, a
Audio3_EnableChannelOutput.skip
	ld a, d
	ldh [lobyte(rAUDTERM)], a
	ret

Audio3_ApplyDutyCycleAndSoundLength:
	ld b, 0
	ld hl, wChannelNoteDelayCounters ; use the note delay as sound length
	add hl, bc
	ld d, [hl]
	ld a, c
	cp CHAN3
	jr z, Audio3_ApplyDutyCycleAndSoundLength.skipDuty ; if music channel 3
	cp CHAN7
	jr z, Audio3_ApplyDutyCycleAndSoundLength.skipDuty ; if sfx channel 3
; include duty cycle (except on channel 3 which doesn't have it)
	ld a, d
	and $3f
	ld d, a
	ld hl, wChannelDutyCycles
	add hl, bc
	ld a, [hl]
	or d
	ld d, a
Audio3_ApplyDutyCycleAndSoundLength.skipDuty
	ld b, REG_DUTY_SOUND_LEN
	call Audio3_GetRegisterPointer
	ld [hl], d
	ret

Audio3_ApplyWavePatternAndFrequency:
	ld a, c
	cp CHAN3
	jr z, Audio3_ApplyWavePatternAndFrequency.channel3
	cp CHAN7
	jr nz, Audio3_ApplyWavePatternAndFrequency.notChannel3
	; fall through
Audio3_ApplyWavePatternAndFrequency.channel3
	push de
	ld de, wMusicWaveInstrument
	cp CHAN3
	jr z, Audio3_ApplyWavePatternAndFrequency.next
	ld de, wSfxWaveInstrument
Audio3_ApplyWavePatternAndFrequency.next
	ld a, [de]
	add a
	ld d, 0
	ld e, a
	ld hl, Audio3_WavePointers
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, _AUD3WAVERAM
	ld b, AUD3WAVE_SIZE - 1
	ld a, $0 ; stop hardware channel 3
	ldh [lobyte(rAUD3ENA)], a
Audio3_ApplyWavePatternAndFrequency.loop
	ld a, [de]
	inc de
	ld [hli], a
	ld a, b
	dec b
	and a
	jr nz, Audio3_ApplyWavePatternAndFrequency.loop
	ld a, AUD3ENA_ON ; start hardware channel 3
	ldh [lobyte(rAUD3ENA)], a
	pop de
Audio3_ApplyWavePatternAndFrequency.notChannel3
	ld a, d
	or $80 ; use counter mode (i.e. disable output when the counter reaches 0)
	and $c7 ; zero the unused bits in the register
	ld d, a
	ld b, REG_FREQUENCY_LO
	call Audio3_GetRegisterPointer
	ld [hl], e ; store frequency low byte
	inc hl
	ld [hl], d ; store frequency high byte
	call Audio3_ApplyFrequencyModifier
	ret

Audio3_SetSfxTempo:
	call Audio3_IsCry
	jr nc, Audio3_SetSfxTempo.notCry
	ld d, 0
	ld a, [wTempoModifier]
	add $80
	jr nc, Audio3_SetSfxTempo.next
	inc d
Audio3_SetSfxTempo.next
	ld [wSfxTempo + 1], a
	ld a, d
	ld [wSfxTempo], a
	jr Audio3_SetSfxTempo.done
Audio3_SetSfxTempo.notCry
	xor a
	ld [wSfxTempo + 1], a
	ld a, $1
	ld [wSfxTempo], a
Audio3_SetSfxTempo.done
	ret

Audio3_ApplyFrequencyModifier:
	call Audio3_IsCry
	jr nc, Audio3_ApplyFrequencyModifier.done
; if playing a cry, add the cry's frequency modifier
	ld a, [wFrequencyModifier]
	add e
	jr nc, Audio3_ApplyFrequencyModifier.noCarry
	inc d
Audio3_ApplyFrequencyModifier.noCarry
	dec hl
	ld e, a
	ld [hl], e
	inc hl
	ld [hl], d
Audio3_ApplyFrequencyModifier.done
	ret

Audio3_GoBackOneCommandIfCry:
	call Audio3_IsCry
	jr nc, Audio3_GoBackOneCommandIfCry.done
	ld hl, wChannelCommandPointers
	ld e, c
	ld d, 0
	sla e
	rl d
	add hl, de
	ld a, [hl]
	sub 1
	ld [hl], a
	inc hl
	ld a, [hl]
	sbc 0
	ld [hl], a
	scf
	ret
Audio3_GoBackOneCommandIfCry.done
	scf
	ccf
	ret

Audio3_IsCry:
; Returns whether the currently playing audio is a cry in carry.
	ld a, [wChannelSoundIDs + CHAN5]
	cp CRY_SFX_START
	jr nc, Audio3_IsCry.next
	jr Audio3_IsCry.no
Audio3_IsCry.next
	cp CRY_SFX_END
	jr z, Audio3_IsCry.no
	jr c, Audio3_IsCry.yes
Audio3_IsCry.no
	scf
	ccf
	ret
Audio3_IsCry.yes
	scf
	ret

Audio3_ApplyPitchSlide:
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_PITCH_SLIDE_DECREASING, [hl]
	jp nz, Audio3_ApplyPitchSlide.frequencyDecreasing
; frequency increasing
	ld hl, wChannelPitchSlideCurrentFrequencyLowBytes
	add hl, bc
	ld e, [hl]
	ld hl, wChannelPitchSlideCurrentFrequencyHighBytes
	add hl, bc
	ld d, [hl]
	ld hl, wChannelPitchSlideFrequencySteps
	add hl, bc
	ld l, [hl]
	ld h, b
	add hl, de
	ld d, h
	ld e, l
	ld hl, wChannelPitchSlideCurrentFrequencyFractionalPart
	add hl, bc
	push hl
	ld hl, wChannelPitchSlideFrequencyStepsFractionalPart
	add hl, bc
	ld a, [hl]
	pop hl
	add [hl]
	ld [hl], a
	ld a, 0
	adc e
	ld e, a
	ld a, 0
	adc d
	ld d, a
	ld hl, wChannelPitchSlideTargetFrequencyHighBytes
	add hl, bc
	ld a, [hl]
	cp d
	jp c, Audio3_ApplyPitchSlide.reachedTargetFrequency
	jr nz, Audio3_ApplyPitchSlide.applyUpdatedFrequency
	ld hl, wChannelPitchSlideTargetFrequencyLowBytes
	add hl, bc
	ld a, [hl]
	cp e
	jp c, Audio3_ApplyPitchSlide.reachedTargetFrequency
	jr Audio3_ApplyPitchSlide.applyUpdatedFrequency
Audio3_ApplyPitchSlide.frequencyDecreasing
	ld hl, wChannelPitchSlideCurrentFrequencyLowBytes
	add hl, bc
	ld a, [hl]
	ld hl, wChannelPitchSlideCurrentFrequencyHighBytes
	add hl, bc
	ld d, [hl]
	ld hl, wChannelPitchSlideFrequencySteps
	add hl, bc
	ld e, [hl]
	sub e
	ld e, a
	ld a, d
	sbc b
	ld d, a
	ld hl, wChannelPitchSlideFrequencyStepsFractionalPart
	add hl, bc
	ld a, [hl]
	add a
	ld [hl], a
	ld a, e
	sbc b
	ld e, a
	ld a, d
	sbc b
	ld d, a
	ld hl, wChannelPitchSlideTargetFrequencyHighBytes
	add hl, bc
	ld a, d
	cp [hl]
	jr c, Audio3_ApplyPitchSlide.reachedTargetFrequency
	jr nz, Audio3_ApplyPitchSlide.applyUpdatedFrequency
	ld hl, wChannelPitchSlideTargetFrequencyLowBytes
	add hl, bc
	ld a, e
	cp [hl]
	jr c, Audio3_ApplyPitchSlide.reachedTargetFrequency
Audio3_ApplyPitchSlide.applyUpdatedFrequency
	ld hl, wChannelPitchSlideCurrentFrequencyLowBytes
	add hl, bc
	ld [hl], e
	ld hl, wChannelPitchSlideCurrentFrequencyHighBytes
	add hl, bc
	ld [hl], d
	ld b, REG_FREQUENCY_LO
	call Audio3_GetRegisterPointer
	ld a, e
	ld [hli], a
	ld [hl], d
	ret
Audio3_ApplyPitchSlide.reachedTargetFrequency
; Turn off pitch slide when the target frequency has been reached.
	ld hl, wChannelFlags1
	add hl, bc
	res BIT_PITCH_SLIDE_ON, [hl]
	res BIT_PITCH_SLIDE_DECREASING, [hl]
	ret

Audio3_InitPitchSlideVars:
	ld hl, wChannelPitchSlideCurrentFrequencyHighBytes
	add hl, bc
	ld [hl], d
	ld hl, wChannelPitchSlideCurrentFrequencyLowBytes
	add hl, bc
	ld [hl], e
	ld hl, wChannelNoteDelayCounters
	add hl, bc
	ld a, [hl]
	ld hl, wChannelPitchSlideLengthModifiers
	add hl, bc
	sub [hl]
	jr nc, Audio3_InitPitchSlideVars.next
	ld a, 1
Audio3_InitPitchSlideVars.next
	ld [hl], a
	ld hl, wChannelPitchSlideTargetFrequencyLowBytes
	add hl, bc
	ld a, e
	sub [hl]
	ld e, a
	ld a, d
	sbc b
	ld hl, wChannelPitchSlideTargetFrequencyHighBytes
	add hl, bc
	sub [hl]
	jr c, Audio3_InitPitchSlideVars.targetFrequencyGreater
	ld d, a
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_PITCH_SLIDE_DECREASING, [hl]
	jr Audio3_InitPitchSlideVars.next2
Audio3_InitPitchSlideVars.targetFrequencyGreater
; If the target frequency is greater, subtract the current frequency from
; the target frequency to get the absolute difference.
	ld hl, wChannelPitchSlideCurrentFrequencyHighBytes
	add hl, bc
	ld d, [hl]
	ld hl, wChannelPitchSlideCurrentFrequencyLowBytes
	add hl, bc
	ld e, [hl]
	ld hl, wChannelPitchSlideTargetFrequencyLowBytes
	add hl, bc
	ld a, [hl]
	sub e
	ld e, a

; Bug. Instead of borrowing from the high byte of the target frequency as it
; should, it borrows from the high byte of the current frequency instead.
; This means that the result will be 0x200 greater than it should be if the
; low byte of the current frequency is greater than the low byte of the
; target frequency.
	ld a, d
	sbc b
	ld d, a

	ld hl, wChannelPitchSlideTargetFrequencyHighBytes
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	res BIT_PITCH_SLIDE_DECREASING, [hl]

Audio3_InitPitchSlideVars.next2
	ld hl, wChannelPitchSlideLengthModifiers
	add hl, bc
Audio3_InitPitchSlideVars.divideLoop
	inc b
	ld a, e
	sub [hl]
	ld e, a
	jr nc, Audio3_InitPitchSlideVars.divideLoop
	ld a, d
	and a
	jr z, Audio3_InitPitchSlideVars.doneDividing
	dec a
	ld d, a
	jr Audio3_InitPitchSlideVars.divideLoop
Audio3_InitPitchSlideVars.doneDividing
	ld a, e ; a = remainder - dividend
	add [hl]
	ld d, b ; d = quotient + 1
	ld b, 0
	ld hl, wChannelPitchSlideFrequencySteps
	add hl, bc
	ld [hl], d ; store quotient + 1
	ld hl, wChannelPitchSlideFrequencyStepsFractionalPart
	add hl, bc
	ld [hl], a ; store remainder - dividend
	ld hl, wChannelPitchSlideCurrentFrequencyFractionalPart
	add hl, bc
	ld [hl], a ; store remainder - dividend
	ret

Audio3_ApplyDutyCyclePattern:
	ld b, 0
	ld hl, wChannelDutyCyclePatterns
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	ld [hl], a
	and $c0
	ld d, a
	ld b, REG_DUTY_SOUND_LEN
	call Audio3_GetRegisterPointer
	ld a, [hl]
	and $3f
	or d
	ld [hl], a
	ret

Audio3_GetNextMusicByte:
	ld d, 0
	ld a, c
	add a
	ld e, a
	ld hl, wChannelCommandPointers
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	ld a, [de] ; get next music command
	inc de
	ld [hl], e ; store address of next command
	inc hl
	ld [hl], d
	ret

Audio3_GetRegisterPointer:
; hl = address of hardware sound register b for software channel c
	ld a, c
	ld hl, Audio3_HWChannelBaseAddresses
	add l
	jr nc, Audio3_GetRegisterPointer.noCarry
	inc h
Audio3_GetRegisterPointer.noCarry
	ld l, a
	ld a, [hl]
	add b
	ld l, a
	ld h, $ff
	ret

Audio3_MultiplyAdd:
; hl = l + (a * de)
	ld h, 0
Audio3_MultiplyAdd.loop
	srl a
	jr nc, Audio3_MultiplyAdd.skipAdd
	add hl, de
Audio3_MultiplyAdd.skipAdd
	sla e
	rl d
	and a
	jr z, Audio3_MultiplyAdd.done
	jr Audio3_MultiplyAdd.loop
Audio3_MultiplyAdd.done
	ret

Audio3_CalculateFrequency:
; return the frequency for note a, octave b in de
	ld h, 0
	ld l, a
	add hl, hl
	ld d, h
	ld e, l
	ld hl, Audio3_Pitches
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, b
Audio3_CalculateFrequency.loop
	cp 7
	jr z, Audio3_CalculateFrequency.done
	sra d
	rr e
	inc a
	jr Audio3_CalculateFrequency.loop
Audio3_CalculateFrequency.done
	ld a, 8
	add d
	ld d, a
	ret

Audio3_PlaySound:
	ld [wSoundID], a
	cp SFX_STOP_ALL_MUSIC
	jp z, Audio3_PlaySound.stopAllAudio
	cp MAX_SFX_ID_3
	jp z, Audio3_PlaySound.playSfx
	jp c, Audio3_PlaySound.playSfx
	cp $fe
	jr z, Audio3_PlaySound.playMusic
	jp nc, Audio3_PlaySound.playSfx

Audio3_PlaySound.playMusic
	xor a
	ld [wUnusedMusicByte], a
	ld [wDisableChannelOutputWhenSfxEnds], a
	ld [wMusicTempo + 1], a
	ld [wMusicWaveInstrument], a
	ld [wSfxWaveInstrument], a
	ld d, NUM_CHANNELS
	ld hl, wChannelReturnAddresses
	call Audio3_PlaySound.FillMem
	ld hl, wChannelCommandPointers
	call Audio3_PlaySound.FillMem
	ld d, NUM_MUSIC_CHANS
	ld hl, wChannelSoundIDs
	call Audio3_PlaySound.FillMem
	ld hl, wChannelFlags1
	call Audio3_PlaySound.FillMem
	ld hl, wChannelDutyCycles
	call Audio3_PlaySound.FillMem
	ld hl, wChannelDutyCyclePatterns
	call Audio3_PlaySound.FillMem
	ld hl, wChannelVibratoDelayCounters
	call Audio3_PlaySound.FillMem
	ld hl, wChannelVibratoExtents
	call Audio3_PlaySound.FillMem
	ld hl, wChannelVibratoRates
	call Audio3_PlaySound.FillMem
	ld hl, wChannelFrequencyLowBytes
	call Audio3_PlaySound.FillMem
	ld hl, wChannelVibratoDelayCounterReloadValues
	call Audio3_PlaySound.FillMem
	ld hl, wChannelFlags2
	call Audio3_PlaySound.FillMem
	ld hl, wChannelPitchSlideLengthModifiers
	call Audio3_PlaySound.FillMem
	ld hl, wChannelPitchSlideFrequencySteps
	call Audio3_PlaySound.FillMem
	ld hl, wChannelPitchSlideFrequencyStepsFractionalPart
	call Audio3_PlaySound.FillMem
	ld hl, wChannelPitchSlideCurrentFrequencyFractionalPart
	call Audio3_PlaySound.FillMem
	ld hl, wChannelPitchSlideCurrentFrequencyHighBytes
	call Audio3_PlaySound.FillMem
	ld hl, wChannelPitchSlideCurrentFrequencyLowBytes
	call Audio3_PlaySound.FillMem
	ld hl, wChannelPitchSlideTargetFrequencyHighBytes
	call Audio3_PlaySound.FillMem
	ld hl, wChannelPitchSlideTargetFrequencyLowBytes
	call Audio3_PlaySound.FillMem
	ld a, $1
	ld hl, wChannelLoopCounters
	call Audio3_PlaySound.FillMem
	ld hl, wChannelNoteDelayCounters
	call Audio3_PlaySound.FillMem
	ld hl, wChannelNoteSpeeds
	call Audio3_PlaySound.FillMem
	ld [wMusicTempo], a
	ld a, $ff
	ld [wStereoPanning], a
	xor a
	ldh [lobyte(rAUDVOL)], a
	ld a, AUD1SWEEP_DOWN
	ldh [lobyte(rAUD1SWEEP)], a
	ld a, 0
	ldh [lobyte(rAUDTERM)], a
	xor a
	ldh [lobyte(rAUD3ENA)], a
	ld a, AUD3ENA_ON
	ldh [lobyte(rAUD3ENA)], a
	ld a, $77
	ldh [lobyte(rAUDVOL)], a
	jp Audio3_PlaySound.playSoundCommon

Audio3_PlaySound.playSfx
	ld l, a
	ld e, a
	ld h, 0
	ld d, h
	add hl, hl
	add hl, de
	ld de, SFX_Headers_3
	add hl, de
	ld a, h
	ld [wSfxHeaderPointer], a
	ld a, l
	ld [wSfxHeaderPointer + 1], a
	ld a, [hl]
	and $c0
	rlca
	rlca
	ld c, a
Audio3_PlaySound.sfxChannelLoop
	ld d, c
	ld a, c
	add a
	add c
	ld c, a
	ld b, 0
	ld a, [wSfxHeaderPointer]
	ld h, a
	ld a, [wSfxHeaderPointer + 1]
	ld l, a
	add hl, bc
	ld c, d
	ld a, [hl]
	and $f
	ld e, a ; software channel ID
	ld d, 0
	ld hl, wChannelSoundIDs
	add hl, de
	ld a, [hl]
	and a
	jr z, Audio3_PlaySound.playChannel
	ld a, e
	cp CHAN8
	jr nz, Audio3_PlaySound.notNoiseChannel
	ld a, [wSoundID]
	cp NOISE_INSTRUMENTS_END
	jr nc, Audio3_PlaySound.notNoiseInstrument
	ret
Audio3_PlaySound.notNoiseInstrument
	ld a, [hl]
	cp NOISE_INSTRUMENTS_END
	jr z, Audio3_PlaySound.playChannel
	jr c, Audio3_PlaySound.playChannel
Audio3_PlaySound.notNoiseChannel
	ld a, [wSoundID]
	cp [hl]
	jr z, Audio3_PlaySound.playChannel
	jr c, Audio3_PlaySound.playChannel
	ret
Audio3_PlaySound.playChannel
	xor a
	push de
	ld h, d
	ld l, e
	add hl, hl
	ld d, h
	ld e, l
	ld hl, wChannelReturnAddresses
	add hl, de
	ld [hli], a
	ld [hl], a
	ld hl, wChannelCommandPointers
	add hl, de
	ld [hli], a
	ld [hl], a
	pop de
	ld hl, wChannelSoundIDs
	add hl, de
	ld [hl], a
	ld hl, wChannelFlags1
	add hl, de
	ld [hl], a
	ld hl, wChannelDutyCycles
	add hl, de
	ld [hl], a
	ld hl, wChannelDutyCyclePatterns
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoDelayCounters
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoExtents
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoRates
	add hl, de
	ld [hl], a
	ld hl, wChannelFrequencyLowBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoDelayCounterReloadValues
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideLengthModifiers
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideFrequencySteps
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideFrequencyStepsFractionalPart
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideCurrentFrequencyFractionalPart
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideCurrentFrequencyHighBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideCurrentFrequencyLowBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideTargetFrequencyHighBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchSlideTargetFrequencyLowBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelFlags2
	add hl, de
	ld [hl], a
	ld a, $1
	ld hl, wChannelLoopCounters
	add hl, de
	ld [hl], a
	ld hl, wChannelNoteDelayCounters
	add hl, de
	ld [hl], a
	ld hl, wChannelNoteSpeeds
	add hl, de
	ld [hl], a
	ld a, e
	cp CHAN5
	jr nz, Audio3_PlaySound.skipSweepDisable
	ld a, AUD1SWEEP_DOWN
	ldh [lobyte(rAUD1SWEEP)], a ; sweep off
Audio3_PlaySound.skipSweepDisable
	ld a, c
	and a
	jp z, Audio3_PlaySound.playSoundCommon
	dec c
	jp Audio3_PlaySound.sfxChannelLoop

Audio3_PlaySound.stopAllAudio
	ld a, AUDENA_ON
	ldh [lobyte(rAUDENA)], a ; sound hardware on
	ldh [lobyte(rAUD3ENA)], a ; wave playback on
	xor a
	ldh [lobyte(rAUDTERM)], a ; no sound output
	ldh [lobyte(rAUD3LEVEL)], a ; mute channel 3 (wave channel)
	ld a, AUD1SWEEP_DOWN
	ldh [lobyte(rAUD1SWEEP)], a ; sweep off
	ldh [lobyte(rAUD1ENV)], a ; mute channel 1 (pulse channel 1)
	ldh [lobyte(rAUD2ENV)], a ; mute channel 2 (pulse channel 2)
	ldh [lobyte(rAUD4ENV)], a ; mute channel 4 (noise channel)
	ld a, AUD1HIGH_LENGTH_ON
	ldh [lobyte(rAUD1HIGH)], a ; counter mode
	ldh [lobyte(rAUD2HIGH)], a
	ldh [lobyte(rAUD4GO)], a
	ld a, $77
	ldh [lobyte(rAUDVOL)], a ; full volume
	xor a
	ld [wUnusedMusicByte], a
	ld [wDisableChannelOutputWhenSfxEnds], a
	ld [wMuteAudioAndPauseMusic], a
	ld [wMusicTempo + 1], a
	ld [wSfxTempo + 1], a
	ld [wMusicWaveInstrument], a
	ld [wSfxWaveInstrument], a
	ld d, $a0
	ld hl, wChannelCommandPointers
	call Audio3_PlaySound.FillMem
	ld a, $1
	ld d, $18
	ld hl, wChannelNoteDelayCounters
	call Audio3_PlaySound.FillMem
	ld [wMusicTempo], a
	ld [wSfxTempo], a
	ld a, $ff
	ld [wStereoPanning], a
	ret

; fills d bytes at hl with a
Audio3_PlaySound.FillMem
	ld b, d
Audio3_PlaySound.loop
	ld [hli], a
	dec b
	jr nz, Audio3_PlaySound.loop
	ret

Audio3_PlaySound.playSoundCommon
	ld a, [wSoundID]
	ld l, a
	ld e, a
	ld h, 0
	ld d, h
	add hl, hl
	add hl, de
	ld de, SFX_Headers_3
	add hl, de
	ld e, l
	ld d, h
	ld hl, wChannelCommandPointers
	ld a, [de] ; get channel number
	ld b, a
	rlca
	rlca
	and $3
	ld c, a
	ld a, b
	and $f
	ld b, c
	inc b
	inc de
	ld c, 0
Audio3_PlaySound.commandPointerLoop
	cp c
	jr z, Audio3_PlaySound.next
	inc c
	inc hl
	inc hl
	jr Audio3_PlaySound.commandPointerLoop
Audio3_PlaySound.next
	push hl
	push bc
	push af
	ld b, 0
	ld c, a
	ld hl, wChannelSoundIDs
	add hl, bc
	ld a, [wSoundID]
	ld [hl], a
	pop af
	cp CHAN4
	jr c, Audio3_PlaySound.skipSettingFlag
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_NOISE_OR_SFX, [hl]
Audio3_PlaySound.skipSettingFlag
	pop bc
	pop hl
	ld a, [de] ; get channel pointer
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	inc c
	dec b
	ld a, b
	and a
	ld a, [de]
	inc de
	jr nz, Audio3_PlaySound.commandPointerLoop
	ld a, [wSoundID]
	cp CRY_SFX_START
	jr nc, Audio3_PlaySound.maybeCry
	jr Audio3_PlaySound.done
Audio3_PlaySound.maybeCry
	ld a, [wSoundID]
	cp CRY_SFX_END
	jr z, Audio3_PlaySound.done
	jr c, Audio3_PlaySound.cry
	jr Audio3_PlaySound.done
Audio3_PlaySound.cry
	ld hl, wChannelSoundIDs + CHAN5
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wChannelCommandPointers + CHAN7 * 2 ; sfx wave channel pointer
	ld de, Audio3_CryRet
	ld [hl], e
	inc hl
	ld [hl], d ; overwrite pointer to point to sound_ret
	ld a, [wSavedVolume]
	and a
	jr nz, Audio3_PlaySound.done
	ldh a, [lobyte(rAUDVOL)]
	ld [wSavedVolume], a
	ld a, $77
	ldh [lobyte(rAUDVOL)], a ; full volume
Audio3_PlaySound.done
	ret

Audio3_CryRet:
	sound_ret

Audio3_HWChannelBaseAddresses:
; the low bytes of each HW channel's base address
	.DB HW_CH1_BASE, HW_CH2_BASE, HW_CH3_BASE, HW_CH4_BASE ; channels 0-3
	.DB HW_CH1_BASE, HW_CH2_BASE, HW_CH3_BASE, HW_CH4_BASE ; channels 4-7

Audio3_HWChannelDisableMasks:
	.DB HW_CH1_DISABLE_MASK, HW_CH2_DISABLE_MASK, HW_CH3_DISABLE_MASK, HW_CH4_DISABLE_MASK ; channels 0-3
	.DB HW_CH1_DISABLE_MASK, HW_CH2_DISABLE_MASK, HW_CH3_DISABLE_MASK, HW_CH4_DISABLE_MASK ; channels 4-7

Audio3_HWChannelEnableMasks:
	.DB HW_CH1_ENABLE_MASK, HW_CH2_ENABLE_MASK, HW_CH3_ENABLE_MASK, HW_CH4_ENABLE_MASK ; channels 0-3
	.DB HW_CH1_ENABLE_MASK, HW_CH2_ENABLE_MASK, HW_CH3_ENABLE_MASK, HW_CH4_ENABLE_MASK ; channels 4-7

Audio3_Pitches:
.INCLUDE "audio/notes.asm"
