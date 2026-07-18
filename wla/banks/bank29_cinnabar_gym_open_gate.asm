CinnabarGymOpenGateScript:
	LD A, ($D057) ; wIsInBattle
	CP $FF
	JP Z, CinnabarGymResetScripts
	LD A, ($CC55) ; wTrainerHeaderFlagBit
	LDH ($DB), A ; hGymGateIndex
	LD C, A
	LD B, 2 ; FLAG_TEST
	LD HL, $D79A
	CALL CinnabarGymFlagAction
	LD A, C
	AND A
	JR NZ, CinnabarGymOpenGateScript.no_sound
	CALL $3748 ; WaitForSoundToFinish
	LD A, $AD ; SFX_GO_INSIDE
	CALL $23B1 ; PlaySound
	CALL $3748 ; WaitForSoundToFinish
CinnabarGymOpenGateScript.no_sound:
	LD A, ($CC55)
	LDH ($DB), A ; hGymGateIndex
	LD C, A
	LD B, 1 ; FLAG_SET
	LD HL, $D79A
	CALL CinnabarGymFlagAction
	LD A, ($CC55)
	SUB 2
	LD C, A
	LD B, 1 ; FLAG_SET
	LD HL, $D79C
	CALL CinnabarGymFlagAction
	CALL $3EAD ; UpdateCinnabarGymGateTileBlocks
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD ($DA38), A ; wOpponentAfterWrongAnswer
	LD A, 0 ; SCRIPT_CINNABARGYM_DEFAULT
	LD ($D65E), A ; wCinnabarGymCurScript
	LD ($DA39), A ; wCurMapScript
	RET
CinnabarGymOpenGateEnd:
.ASSERT CinnabarGymOpenGateEnd - CinnabarGymOpenGateScript == 84
