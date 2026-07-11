; Native WLA-DX form of engine/play_time.asm.
TrackPlayTime:
	CALL CountDownIgnoreInputBitReset
	LD A, (wStatusFlags6)
	BIT 0, A
	RET Z
	LD A, (wPlayTimeMaxed)
	AND A
	RET NZ
	LD A, (wPlayTimeFrames)
	INC A
	LD (wPlayTimeFrames), A
	CP 60
	RET NZ
	XOR A
	LD (wPlayTimeFrames), A
	LD A, (wPlayTimeSeconds)
	INC A
	LD (wPlayTimeSeconds), A
	CP 60
	RET NZ
	XOR A
	LD (wPlayTimeSeconds), A
	LD A, (wPlayTimeMinutes)
	INC A
	LD (wPlayTimeMinutes), A
	CP 60
	RET NZ
	XOR A
	LD (wPlayTimeMinutes), A
	LD A, (wPlayTimeHours)
	INC A
	LD (wPlayTimeHours), A
	CP $ff
	RET NZ
	LD A, $ff
	LD (wPlayTimeMaxed), A
	RET
CountDownIgnoreInputBitReset:
	LD A, (wIgnoreInputCounter)
	AND A
	JR NZ, IgnoreInputDecrement
	LD A, $ff
	JR IgnoreInputContinue
IgnoreInputDecrement:
	DEC A
IgnoreInputContinue:
	LD (wIgnoreInputCounter), A
	AND A
	RET NZ
	LD A, (wStatusFlags5)
	RES 1, A
	RES 2, A
	BIT 5, A
	RES 5, A
	LD (wStatusFlags5), A
	RET Z
	XOR A
	LDH ($b3), A
	LDH ($b4), A
	RET
PlayTimeEnd:
