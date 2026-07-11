; Native WLA-DX form of engine/gfx/screen_effects.asm.
.DEFINE GetPredefRegisters $3e94
ChangeBGPalColor0_4Frames:
	CALL GetPredefRegisters
	LDH A, ($47)
	OR B
	LDH ($47), A
	LD C, 4
	CALL DelayFrames
	LDH A, ($47)
	AND $fc
	LDH ($47), A
	RET
PredefShakeScreenVertically:
	CALL GetPredefRegisters
	LD A, 1
	LD (wDisableVBlankWYUpdate), A
	XOR A
ShakeScreenVerticalLoop:
	LDH ($96), A
	CALL ShakeScreenMutateWY
	CALL ShakeScreenMutateWY
	DEC B
	LD A, B
	JR NZ, ShakeScreenVerticalLoop
	XOR A
	LD (wDisableVBlankWYUpdate), A
	RET
ShakeScreenMutateWY:
	LDH A, ($96)
	XOR B
	LDH ($96), A
	LDH ($4a), A
	LD C, 3
	JP DelayFrames
PredefShakeScreenHorizontally:
	CALL GetPredefRegisters
	XOR A
ShakeScreenHorizontalLoop:
	LDH ($97), A
	CALL ShakeScreenMutateWX
	LD C, 1
	CALL DelayFrames
	CALL ShakeScreenMutateWX
	DEC B
	LD A, B
	JR NZ, ShakeScreenHorizontalLoop
	LD A, 7
	LDH ($4b), A
	RET
ShakeScreenMutateWX:
	LDH A, ($97)
	XOR B
	LDH ($97), A
	BIT 7, A
	JR Z, ShakeScreenSkipZeroing
	XOR A
ShakeScreenSkipZeroing:
	ADD 7
	LDH ($4b), A
	LD C, 4
	JP DelayFrames
ScreenEffectsEnd:
