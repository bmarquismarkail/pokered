SeafoamIslandsB3F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wMiscFlags
	bit BIT_PUSHED_BOULDER, [hl]
	res BIT_PUSHED_BOULDER, [hl]
	jr z, SeafoamIslandsB3F_Script.noBoulderWasPushed
	ld hl, Seafoam4HolesCoords
	call CheckBoulderCoords
	ret nc
	EventFlagAddress "hl", EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE
	ld a, [wCoordIndex]
	cp $1
	jr nz, SeafoamIslandsB3F_Script.boulder2FellDownHole
	SetEventReuseHL EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE
	ld a, TOGGLE_SEAFOAM_ISLANDS_B3F_BOULDER_1
	ld [wObjectToHide], a
	ld a, TOGGLE_SEAFOAM_ISLANDS_B4F_BOULDER_1
	ld [wObjectToShow], a
	jr SeafoamIslandsB3F_Script.hideAndShowBoulderObjects
SeafoamIslandsB3F_Script.boulder2FellDownHole
	SetEventAfterBranchReuseHL EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE
	ld a, TOGGLE_SEAFOAM_ISLANDS_B3F_BOULDER_2
	ld [wObjectToHide], a
	ld a, TOGGLE_SEAFOAM_ISLANDS_B4F_BOULDER_2
	ld [wObjectToShow], a
SeafoamIslandsB3F_Script.hideAndShowBoulderObjects
	ld a, [wObjectToHide]
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, [wObjectToShow]
	ld [wToggleableObjectIndex], a
	predef ShowObject
	jr SeafoamIslandsB3F_Script.runCurrentMapScript
SeafoamIslandsB3F_Script.noBoulderWasPushed
	ld a, SEAFOAM_ISLANDS_B4F
	ld [wDungeonWarpDestinationMap], a
	ld hl, Seafoam4HolesCoords
	call IsPlayerOnDungeonWarp
	ld a, [wStatusFlags6]
	bit BIT_DUNGEON_WARP, a
	ret nz
SeafoamIslandsB3F_Script.runCurrentMapScript
	ld hl, SeafoamIslandsB3F_ScriptPointers
	ld a, [wSeafoamIslandsB3FCurScript]
	jp CallFunctionInTable

Seafoam4HolesCoords:
	dbmapcoord  3, 16
	dbmapcoord  6, 16
	.DB -1 ; end

SeafoamIslandsB3F_ScriptPointers:
	def_script_pointers
	dw_const SeafoamIslandsB3FDefaultScript,       SCRIPT_SEAFOAMISLANDSB3F_DEFAULT
	dw_const SeafoamIslandsB3FObjectMoving1Script, SCRIPT_SEAFOAMISLANDSB3F_OBJECT_MOVING1
	dw_const SeafoamIslandsB3FMoveObjectScript,    SCRIPT_SEAFOAMISLANDSB3F_MOVE_OBJECT
	dw_const SeafoamIslandsB3FObjectMoving2Script, SCRIPT_SEAFOAMISLANDSB3F_OBJECT_MOVING2
	.EXPORT SCRIPT_SEAFOAMISLANDSB3F_MOVE_OBJECT ; used by engine/overworld/player_state.asm

SeafoamIslandsB3FDefaultScript:
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	ret z
	ld a, [wYCoord]
	cp 8
	ret nz
	ld a, [wXCoord]
	cp 15
	ret nz
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEList_ForcedSurfingStrongCurrentNearSteps
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld hl, wStatusFlags7
	set BIT_FORCED_WARP, [hl]
	ld a, SCRIPT_SEAFOAMISLANDSB3F_OBJECT_MOVING1
	ld [wSeafoamIslandsB3FCurScript], a
	ret

RLEList_ForcedSurfingStrongCurrentNearSteps:
	.DB PAD_DOWN, 6
	.DB PAD_RIGHT, 5
	.DB PAD_DOWN, 3
	.DB -1 ; end

SeafoamIslandsB3FObjectMoving1Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, SCRIPT_SEAFOAMISLANDSB3F_DEFAULT
	ld [wSeafoamIslandsB3FCurScript], a
	ret

SeafoamIslandsB3FMoveObjectScript:
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	ret z
	ld a, [wXCoord]
	cp 18
	jr z, SeafoamIslandsB3FMoveObjectScript.playerFellThroughHoleLeft
	cp 19
	ld a, SCRIPT_SEAFOAMISLANDSB3F_DEFAULT
	jr nz, SeafoamIslandsB3FMoveObjectScript.playerNotInStrongCurrent
	ld de, SeafoamIslandsB3FMoveObjectScript.RLEList_StrongCurrentNearRightBoulder
	jr SeafoamIslandsB3FMoveObjectScript.forceSurfMovement
SeafoamIslandsB3FMoveObjectScript.playerFellThroughHoleLeft
	ld de, SeafoamIslandsB3FMoveObjectScript.RLEList_StrongCurrentNearLeftBoulder
SeafoamIslandsB3FMoveObjectScript.forceSurfMovement
	ld hl, wSimulatedJoypadStatesEnd
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	xor a
	ld [wSpritePlayerStateData2MovementByte1], a
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld hl, wStatusFlags7
	set BIT_FORCED_WARP, [hl]
	ld a, SCRIPT_SEAFOAMISLANDSB3F_OBJECT_MOVING2
SeafoamIslandsB3FMoveObjectScript.playerNotInStrongCurrent
	ld [wSeafoamIslandsB3FCurScript], a
	ret

SeafoamIslandsB3FMoveObjectScript.RLEList_StrongCurrentNearRightBoulder:
	.DB PAD_DOWN, 6
	.DB PAD_RIGHT, 2
	.DB PAD_DOWN, 4
	.DB PAD_LEFT, 1
	.DB -1 ; end

SeafoamIslandsB3FMoveObjectScript.RLEList_StrongCurrentNearLeftBoulder:
	.DB PAD_DOWN, 6
	.DB PAD_RIGHT, 2
	.DB PAD_DOWN, 4
	.DB -1 ; end

SeafoamIslandsB3FObjectMoving2Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, SCRIPT_SEAFOAMISLANDSB3F_DEFAULT
	ld [wSeafoamIslandsB3FCurScript], a
	ret

SeafoamIslandsB3F_TextPointers:
	def_text_pointers
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER1
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER2
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER3
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER4
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER5
	dw_const BoulderText, TEXT_SEAFOAMISLANDSB3F_BOULDER6
