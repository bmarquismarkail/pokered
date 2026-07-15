Museum1FDefaultScript:
	LD A, ($D361) ; wYCoord
	CP $04
	RET NZ
	LD A, ($D362) ; wXCoord
	CP $09
	JR Z, Museum1FDefaultScriptContinue
	LD A, ($D362)
	CP $0A
	RET NZ
Museum1FDefaultScriptContinue:
	XOR A
	LDH ($B4), A ; hJoyHeld
	LD A, $01 ; TEXT_MUSEUM1F_SCIENTIST1
	LDH ($8C), A ; hTextID
	JP $2920 ; DisplayTextID
Museum1FNoopScript:
	RET
Museum1FDefaultScriptsEnd:
.ASSERT Museum1FDefaultScriptsEnd - Museum1FDefaultScript == 30
