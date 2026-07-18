ChampionsRoom_h:
	.DB $07,$04,$04
	.DW ChampionsRoom_Blocks
	.DW ChampionsRoom_TextPointers
	.DW ChampionsRoom_Script
	.DB $00
	.DW ChampionsRoom_Object
ChampionsRoomHeaderEnd:
.ASSERT ChampionsRoomHeaderEnd - ChampionsRoom_h == 12

ChampionsRoom_Script:
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, ChampionsRoom_ScriptPointers
	LD A, ($D64C) ; wChampionsRoomCurScript
	JP $3D97 ; CallFunctionInTable
ChampionsRoomScriptEnd:
.ASSERT ChampionsRoomScriptEnd - ChampionsRoom_Script == 12

ResetRivalScript:
	XOR A ; SCRIPT_CHAMPIONSROOM_DEFAULT
	LD ($CD6B), A ; wJoyIgnore
	LD ($D64C), A ; wChampionsRoomCurScript
	RET
ResetRivalScriptEnd:
.ASSERT ResetRivalScriptEnd - ResetRivalScript == 8

ChampionsRoom_ScriptPointers:
	.DW ChampionsRoomDefaultScript,ChampionsRoomPlayerEntersScript
	.DW ChampionsRoomRivalReadyToBattleScript,ChampionsRoomRivalDefeatedScript,ChampionsRoomOakArrivesScript
	.DW ChampionsRoomOakCongratulatesPlayerScript,ChampionsRoomOakDisappointedWithRivalScript
	.DW ChampionsRoomOakComeWithMeScript,ChampionsRoomOakExitsScript
	.DW ChampionsRoomPlayerFollowsOakScript,ChampionsRoomCleanupScript
ChampionsRoomScriptPointersEnd:
.ASSERT ChampionsRoomScriptPointersEnd - ChampionsRoom_ScriptPointers == 22

ChampionsRoomDefaultScript:
	RET
ChampionsRoomDefaultEnd:
.ASSERT ChampionsRoomDefaultEnd - ChampionsRoomDefaultScript == 1

ChampionsRoomPlayerEntersScript:
	LD A, $FF ; PAD_BUTTONS | PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
	LD HL, $CCD3 ; wSimulatedJoypadStatesEnd
	LD DE, RivalEntrance_RLEMovement
	CALL $350C ; DecodeRLEList
	DEC A
	LD ($CD38), A ; wSimulatedJoypadStatesIndex
	CALL $3486 ; StartSimulatingJoypadStates
	LD A, 2 ; SCRIPT_CHAMPIONSROOM_RIVAL_READY_TO_BATTLE
	LD ($D64C), A
	RET
ChampionsRoomPlayerEntersEnd:
.ASSERT ChampionsRoomPlayerEntersEnd - ChampionsRoomPlayerEntersScript == 27

RivalEntrance_RLEMovement:
	.DB $40,$01 ; PAD_UP, 1
	.DB $10,$01 ; PAD_RIGHT, 1
	.DB $40,$03 ; PAD_UP, 3
	.DB $FF
RivalEntranceRLEEnd:
.ASSERT RivalEntranceRLEEnd - RivalEntrance_RLEMovement == 7
