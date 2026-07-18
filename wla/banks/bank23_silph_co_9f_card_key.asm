SilphCo9F_SetCardKeyDoorYScript:
	PUSH HL
	LD HL, $D73F ; wCardKeyDoorY
	LD A, (HL+)
	LD B, A
	LD A, (HL)
	LD C, A
	XOR A
	LDH ($E0), A ; hUnlockedSilphCoDoors
	POP HL
SilphCo9F_SetCardKeyDoorYScript.loop_card_key_doors:
	LD A, (HL+)
	CP $FF
	JR Z, SilphCo9F_SetCardKeyDoorYScript.exit_loop
	PUSH HL
	LD HL, $FFE0
	INC (HL)
	POP HL
	CP B
	JR Z, SilphCo9F_SetCardKeyDoorYScript.check_door
	INC HL
	JR SilphCo9F_SetCardKeyDoorYScript.loop_card_key_doors
SilphCo9F_SetCardKeyDoorYScript.check_door:
	LD A, (HL+)
	CP C
	JR NZ, SilphCo9F_SetCardKeyDoorYScript.loop_card_key_doors
	LD HL, $D73F
	XOR A
	LD (HL+), A
	LD (HL), A
	RET
SilphCo9F_SetCardKeyDoorYScript.exit_loop:
	XOR A
	LDH ($E0), A
	RET
SilphCo9FSetCardKeyDoorEnd:
.ASSERT SilphCo9FSetCardKeyDoorEnd - SilphCo9F_SetCardKeyDoorYScript == 44
SilphCo9F_SetUnlockedSilphCoDoorsScript:
	LD HL, $D834 ; EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	LDH A, ($E0)
	AND A
	RET Z
	CP 1
	JR NZ, SilphCo9F_SetUnlockedSilphCoDoorsScript.unlock_door1
	SET 0, (HL)
	RET
SilphCo9F_SetUnlockedSilphCoDoorsScript.unlock_door1:
	CP 2
	JR NZ, SilphCo9F_SetUnlockedSilphCoDoorsScript.unlock_door2
	SET 1, (HL)
	RET
SilphCo9F_SetUnlockedSilphCoDoorsScript.unlock_door2:
	CP 3
	JR NZ, SilphCo9F_SetUnlockedSilphCoDoorsScript.unlock_door3
	SET 2, (HL)
	RET
SilphCo9F_SetUnlockedSilphCoDoorsScript.unlock_door3:
	CP 4
	RET NZ
	SET 3, (HL)
	RET
SilphCo9FSetUnlockedDoorsEnd:
.ASSERT SilphCo9FSetUnlockedDoorsEnd - SilphCo9F_SetUnlockedSilphCoDoorsScript == 34
