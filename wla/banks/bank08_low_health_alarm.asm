; Native WLA-DX form of audio/low_health_alarm.asm.
Music_DoLowHealthAlarm:
	LD A, (wLowHealthAlarm)
	CP $ff
	JR Z, LowHealthDisableAlarm
	BIT 7, A
	RET Z
	AND $7f
	JR NZ, LowHealthNotToneHi
	CALL LowHealthPlayToneHi
	LD A, 30
	JR LowHealthResetTimer
LowHealthNotToneHi:
	CP 20
	JR NZ, LowHealthNoTone
	CALL LowHealthPlayToneLo
LowHealthNoTone:
	LD A, $86
	LD (wChannelSoundIDs + 4), A
	LD A, (wLowHealthAlarm)
	AND $7f
	DEC A
LowHealthResetTimer:
	SET 7, A
	LD (wLowHealthAlarm), A
	RET
LowHealthDisableAlarm:
	XOR A
	LD (wLowHealthAlarm), A
	LD (wChannelSoundIDs + 4), A
	LD DE, LowHealthToneDataSilence
	JR LowHealthPlayTone
LowHealthPlayToneHi:
	LD DE, LowHealthToneDataHi
	JR LowHealthPlayTone
LowHealthPlayToneLo:
	LD DE, LowHealthToneDataLo
LowHealthPlayTone:
	LD HL, $ff10 ; rAUD1SWEEP
	LD C, $05
	XOR A
LowHealthCopyLoop:
	LD (HL+), A
	LD A, (DE)
	INC DE
	DEC C
	JR NZ, LowHealthCopyLoop
	RET
LowHealthToneDataHi:
	.DB $a0, $e2
	.DW $8750
LowHealthToneDataLo:
	.DB $b0, $e2
	.DW $86ee
LowHealthToneDataSilence:
	.DB $00, $00
	.DW $8000
LowHealthAlarmEnd:
