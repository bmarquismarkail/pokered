; pitch
; Audio[1|2|3]_Pitches indexes (see audio/notes.asm)
	const_def
	const C_ ; 0
	const C_SHARP ; 1
	const D_ ; 2
	const D_SHARP ; 3
	const E_ ; 4
	const F_ ; 5
	const F_SHARP ; 6
	const G_ ; 7
	const G_SHARP ; 8
	const A_ ; 9
	const A_SHARP ; A
	const B_ ; B
.DEFINE NUM_NOTES const_value

; channel
; Audio[1|2|3]_HWChannelBaseAddresses, Audio[1|2|3]_HWChannelDisableMasks,
; and Audio[1|2|3]_HWChannelEnableMasks indexes (see audio/engine_[1|2|3].asm)
	const_def
	const CHAN1 ; 0
	const CHAN2 ; 1
	const CHAN3 ; 2
	const CHAN4 ; 3
.DEFINE NUM_MUSIC_CHANS const_value
	const CHAN5 ; 4
	const CHAN6 ; 5
	const CHAN7 ; 6
	const CHAN8 ; 7
.DEFINE NUM_NOISE_CHANS const_value - NUM_MUSIC_CHANS
.DEFINE NUM_CHANNELS const_value

; HW sound channel register base addresses
.DEFINE HW_CH1_BASE lobyte(rAUD1SWEEP)
.DEFINE HW_CH2_BASE lobyte(rAUD2LEN) - 1
.DEFINE HW_CH3_BASE lobyte(rAUD3ENA)
.DEFINE HW_CH4_BASE lobyte(rAUD4LEN) - 1

; HW sound channel enable bit masks
.DEFINE HW_CH1_ENABLE_MASK %00010001
.DEFINE HW_CH2_ENABLE_MASK %00100010
.DEFINE HW_CH3_ENABLE_MASK %01000100
.DEFINE HW_CH4_ENABLE_MASK %10001000

; HW sound channel disable bit masks
.DEFINE HW_CH1_DISABLE_MASK $ee
.DEFINE HW_CH2_DISABLE_MASK $dd
.DEFINE HW_CH3_DISABLE_MASK $bb
.DEFINE HW_CH4_DISABLE_MASK $77

	const_def 1
	const REG_DUTY_SOUND_LEN  ; 1
	const REG_VOLUME_ENVELOPE ; 2
	const REG_FREQUENCY_LO    ; 3

; wChannelFlags1 constants
	const_def
	const BIT_PERFECT_PITCH          ; 0 ; controlled by toggle_perfect_pitch command
	const BIT_SOUND_CALL             ; 1 ; if in sound call
	const BIT_NOISE_OR_SFX           ; 2 ; if channel is the music noise channel or an SFX channel
	const BIT_VIBRATO_DIRECTION      ; 3 ; if the pitch is above or below normal (cycles)
	const BIT_PITCH_SLIDE_ON         ; 4 ; if pitch slide is active
	const BIT_PITCH_SLIDE_DECREASING ; 5 ; if the pitch slide frequency is decreasing (instead of increasing)
	const BIT_ROTATE_DUTY_CYCLE      ; 6 ; if rotating duty cycle

; wChannelFlags2 constant (only has one flag)
.DEFINE BIT_EXECUTE_MUSIC 0 ; if in execute music

; wMuteAudioAndPauseMusic
.DEFINE BIT_MUTE_AUDIO 7

; wLowHealthAlarm
.DEFINE BIT_LOW_HEALTH_ALARM 7
.DEFINE LOW_HEALTH_TIMER_MASK %01111111
.DEFINE DISABLE_LOW_HEALTH_ALARM $ff
