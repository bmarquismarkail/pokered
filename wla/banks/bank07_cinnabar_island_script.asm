; Native WLA-DX form of scripts/CinnabarIsland.asm.
CinnabarIsland_Script:
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, $D126 ; wCurrentMapScriptFlags
	SET 5, (HL) ; BIT_CUR_MAP_LOADED_1
	LD HL, $D796
	RES 0, (HL) ; EVENT_MANSION_SWITCH_ON
	LD HL, $D7A3
	RES 1, (HL) ; EVENT_LAB_STILL_REVIVING_FOSSIL
	LD HL, CinnabarIsland_ScriptPointers
	LD A, ($D639) ; wCinnabarIslandCurScript
	JP $3D97 ; CallFunctionInTable
CinnabarIslandScriptEnd:
.ASSERT CinnabarIslandScriptEnd - CinnabarIsland_Script == 27

CinnabarIsland_ScriptPointers:
	.DW CinnabarIslandDefaultScript,CinnabarIslandPlayerMovingScript
CinnabarIslandScriptPointersEnd:
.ASSERT CinnabarIslandScriptPointersEnd - CinnabarIsland_ScriptPointers == 4

CinnabarIslandDefaultScript:
	LD B, $2B ; SECRET_KEY
	CALL $3493 ; IsItemInBag
	RET NZ
	LD A, ($D361) ; wYCoord
	CP 4
	RET NZ
	LD A, ($D362) ; wXCoord
	CP 18
	RET NZ
	LD A, 8 ; PLAYER_DIR_UP
	LD ($D528), A ; wPlayerMovingDirection
	LD A, 8 ; TEXT_CINNABARISLAND_DOOR_IS_LOCKED
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	XOR A
	LDH ($B4), A ; hJoyHeld
	LD A, 1
	LD ($CD38), A ; wSimulatedJoypadStatesIndex
	LD A, $80 ; PAD_DOWN
	LD ($CCD3), A ; wSimulatedJoypadStatesEnd
	CALL $3486 ; StartSimulatingJoypadStates
	XOR A
	LD ($C109), A ; wSpritePlayerStateData1FacingDirection
	LD ($CD6B), A ; wJoyIgnore
	LD A, 1 ; SCRIPT_CINNABARISLAND_PLAYER_MOVING
	LD ($D639), A
	RET
CinnabarIslandDefaultEnd:
.ASSERT CinnabarIslandDefaultEnd - CinnabarIslandDefaultScript == 59

CinnabarIslandPlayerMovingScript:
	LD A, ($CD38) ; wSimulatedJoypadStatesIndex
	AND A
	RET NZ
	CALL $3DD7 ; Delay3
	LD A, 0 ; SCRIPT_CINNABARISLAND_DEFAULT
	LD ($D639), A
	RET
CinnabarIslandPlayerMovingEnd:
.ASSERT CinnabarIslandPlayerMovingEnd - CinnabarIslandPlayerMovingScript == 14

CinnabarIsland_TextPointers:
	.DW CinnabarIslandGirlText,CinnabarIslandGamblerText,CinnabarIslandSignText
	.DW $24EA,$24EF,CinnabarIslandPokemonLabSignText
	.DW CinnabarIslandGymSignText,CinnabarIslandDoorIsLockedText
CinnabarIslandTextPointersEnd:
.ASSERT CinnabarIslandTextPointersEnd - CinnabarIsland_TextPointers == 16

CinnabarIslandDoorIsLockedText:
	.DB $17
	.DW $61CF
	.DB $29,$50
CinnabarIslandGirlText:
	.DB $17
	.DW $61E6
	.DB $29,$50
CinnabarIslandGamblerText:
	.DB $17
	.DW $622A
	.DB $29,$50
CinnabarIslandSignText:
	.DB $17
	.DW $6266
	.DB $29,$50
CinnabarIslandPokemonLabSignText:
	.DB $17
	.DW $6298
	.DB $29,$50
CinnabarIslandGymSignText:
	.DB $17
	.DW $62A2
	.DB $29,$50
CinnabarIslandTextRecordsEnd:
.ASSERT CinnabarIslandTextRecordsEnd - CinnabarIslandDoorIsLockedText == 30
