Music_DoLowHealthAlarm:
	ld a, [wLowHealthAlarm]
	cp DISABLE_LOW_HEALTH_ALARM
	jr z, Music_DoLowHealthAlarm.disableAlarm

	bit BIT_LOW_HEALTH_ALARM, a
	ret z

	and LOW_HEALTH_TIMER_MASK
	jr nz, Music_DoLowHealthAlarm.notToneHi ;if timer > 0, play low tone.

	call Music_DoLowHealthAlarm.playToneHi
	ld a, 30 ;keep this tone for 30 frames.
	jr Music_DoLowHealthAlarm.resetTimer

Music_DoLowHealthAlarm.notToneHi
	cp 20
	jr nz, Music_DoLowHealthAlarm.noTone   ;if timer = 20,
	call Music_DoLowHealthAlarm.playToneLo ;actually set the sound registers.

Music_DoLowHealthAlarm.noTone
	ld a, CRY_SFX_END
	ld [wChannelSoundIDs + CHAN5], a ;disable sound channel?
	ld a, [wLowHealthAlarm]
	and LOW_HEALTH_TIMER_MASK
	dec a

Music_DoLowHealthAlarm.resetTimer
	; reset the timer and enable flag.
	set BIT_LOW_HEALTH_ALARM, a
	ld [wLowHealthAlarm], a
	ret

Music_DoLowHealthAlarm.disableAlarm
	xor a
	ld [wLowHealthAlarm], a  ;disable alarm
	ld [wChannelSoundIDs + CHAN5], a  ;re-enable sound channel?
	ld de, Music_DoLowHealthAlarm.toneDataSilence
	jr Music_DoLowHealthAlarm.playTone

;update the sound registers to change the frequency.
;the tone set here stays until we change it.
Music_DoLowHealthAlarm.playToneHi
	ld de, Music_DoLowHealthAlarm.toneDataHi
	jr Music_DoLowHealthAlarm.playTone

Music_DoLowHealthAlarm.playToneLo
	ld de, Music_DoLowHealthAlarm.toneDataLo

;update sound channel 1 to play the alarm, overriding all other sounds.
Music_DoLowHealthAlarm.playTone
	ld hl, rAUD1SWEEP ;channel 1 sound register
	ld c, $5
	xor a

Music_DoLowHealthAlarm.copyLoop
	ld [hli], a
	ld a, [de]
	inc de
	dec c
	jr nz, Music_DoLowHealthAlarm.copyLoop
	ret

.MACRO alarm_tone
	.DB \1 ; length
	.DB \2 ; envelope
	.DW \3 ; frequency
.ENDM

;bytes to write to sound channel 1 registers for health alarm.
;starting at FF11 (FF10 is always zeroed).
Music_DoLowHealthAlarm.toneDataHi
	alarm_tone $A0, $E2, $8750

Music_DoLowHealthAlarm.toneDataLo
	alarm_tone $B0, $E2, $86EE

;written to stop the alarm
Music_DoLowHealthAlarm.toneDataSilence
	alarm_tone $00, $00, $8000
