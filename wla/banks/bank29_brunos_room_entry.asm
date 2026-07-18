BrunosRoom_h:
	.DB $07,$06,$05
	.DW BrunosRoom_Blocks
	.DW BrunosRoom_TextPointers
	.DW BrunosRoom_Script
	.DB $00
	.DW BrunosRoom_Object
BrunosRoomHeaderEnd:
.ASSERT BrunosRoomHeaderEnd - BrunosRoom_h == 12

BrunosRoom_Script:
	CALL BrunoShowOrHideExitBlock
	CALL $3C3C
	LD HL, BrunosRoomTrainerHeaders
	LD DE, BrunosRoom_ScriptPointers
	LD A, ($D64E)
	CALL $3160
	LD ($D64E), A
	RET
BrunosRoomScriptEnd:
.ASSERT BrunosRoomScriptEnd - BrunosRoom_Script == 22

BrunoShowOrHideExitBlock:
	LD HL, $D126
	BIT 5, (HL)
	RES 5, (HL)
	RET Z
	LD A, ($D864)
	BIT 1, A ; EVENT_BEAT_BRUNOS_ROOM_TRAINER_0
	JR Z, BrunoShowOrHideExitBlock.blockExit
	LD A, 5
	JP BrunoShowOrHideExitBlock.setExitBlock
BrunoShowOrHideExitBlock.blockExit:
	LD A, $24
BrunoShowOrHideExitBlock.setExitBlock:
	LD ($D09F), A
	LD BC, $0002
	LD A, $17
	JP $3E6D
BrunoShowOrHideExitBlockEnd:
.ASSERT BrunoShowOrHideExitBlockEnd - BrunoShowOrHideExitBlock == 33

ResetBrunoScript:
	XOR A
	LD ($D64E), A
	RET
ResetBrunoScriptEnd:
.ASSERT ResetBrunoScriptEnd - ResetBrunoScript == 5

BrunosRoom_ScriptPointers:
	.DW BrunosRoomDefaultScript,$324C,BrunosRoomBrunoEndBattleScript
	.DW BrunosRoomPlayerIsMovingScript,BrunosRoomNoopScript
BrunosRoomScriptPointersEnd:
.ASSERT BrunosRoomScriptPointersEnd - BrunosRoom_ScriptPointers == 10

BrunosRoomNoopScript:
	RET
BrunosRoomNoopEnd:
.ASSERT BrunosRoomNoopEnd - BrunosRoomNoopScript == 1
