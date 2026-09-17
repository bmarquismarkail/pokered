RocketHideoutB2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, RocketHideout2TrainerHeaders
	ld de, RocketHideoutB2F_ScriptPointers
	ld a, [wRocketHideoutB2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wRocketHideoutB2FCurScript], a
	ret

RocketHideoutB2F_ScriptPointers:
	def_script_pointers
	dw_const RocketHideoutB2FDefaultScript,         SCRIPT_ROCKETHIDEOUTB2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROCKETHIDEOUTB2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROCKETHIDEOUTB2F_END_BATTLE
	dw_const RocketHideoutB2FPlayerSpinningScript,  SCRIPT_ROCKETHIDEOUTB2F_PLAYER_SPINNING

RocketHideoutB2FDefaultScript:
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld hl, RocketHideout2ArrowTilePlayerMovement
	call DecodeArrowMovementRLE
	cp $ff
	jp z, CheckFightingMapTrainers
	ld hl, wMovementFlags
	set BIT_SPINNING, [hl]
	call StartSimulatingJoypadStates
	ld a, SFX_ARROW_TILES
	call PlaySound
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_ROCKETHIDEOUTB2F_PLAYER_SPINNING
	ld [wCurMapScript], a
	ret

RocketHideout2ArrowTilePlayerMovement:
	map_coord_movement  4,  9, RocketHideout2ArrowMovement1
	map_coord_movement  4, 11, RocketHideout2ArrowMovement2
	map_coord_movement  4, 15, RocketHideout2ArrowMovement3
	map_coord_movement  4, 16, RocketHideout2ArrowMovement4
	map_coord_movement  4, 19, RocketHideout2ArrowMovement1
	map_coord_movement  4, 22, RocketHideout2ArrowMovement5
	map_coord_movement  5, 14, RocketHideout2ArrowMovement6
	map_coord_movement  6, 22, RocketHideout2ArrowMovement7
	map_coord_movement  6, 24, RocketHideout2ArrowMovement8
	map_coord_movement  8,  9, RocketHideout2ArrowMovement9
	map_coord_movement  8, 12, RocketHideout2ArrowMovement10
	map_coord_movement  8, 15, RocketHideout2ArrowMovement8
	map_coord_movement  8, 19, RocketHideout2ArrowMovement9
	map_coord_movement  8, 23, RocketHideout2ArrowMovement11
	map_coord_movement  9, 14, RocketHideout2ArrowMovement12
	map_coord_movement  9, 22, RocketHideout2ArrowMovement12
	map_coord_movement 10,  9, RocketHideout2ArrowMovement13
	map_coord_movement 10, 10, RocketHideout2ArrowMovement14
	map_coord_movement 10, 15, RocketHideout2ArrowMovement15
	map_coord_movement 10, 17, RocketHideout2ArrowMovement16
	map_coord_movement 10, 19, RocketHideout2ArrowMovement17
	map_coord_movement 10, 25, RocketHideout2ArrowMovement2
	map_coord_movement 11, 14, RocketHideout2ArrowMovement18
	map_coord_movement 11, 16, RocketHideout2ArrowMovement19
	map_coord_movement 11, 18, RocketHideout2ArrowMovement12
	map_coord_movement 12,  9, RocketHideout2ArrowMovement20
	map_coord_movement 12, 11, RocketHideout2ArrowMovement21
	map_coord_movement 12, 13, RocketHideout2ArrowMovement22
	map_coord_movement 12, 17, RocketHideout2ArrowMovement23
	map_coord_movement 13, 10, RocketHideout2ArrowMovement24
	map_coord_movement 13, 12, RocketHideout2ArrowMovement25
	map_coord_movement 13, 16, RocketHideout2ArrowMovement26
	map_coord_movement 13, 18, RocketHideout2ArrowMovement27
	map_coord_movement 13, 19, RocketHideout2ArrowMovement28
	map_coord_movement 13, 22, RocketHideout2ArrowMovement29
	map_coord_movement 13, 23, RocketHideout2ArrowMovement30
	map_coord_movement 14, 17, RocketHideout2ArrowMovement31
	map_coord_movement 15, 16, RocketHideout2ArrowMovement12
	map_coord_movement 16, 14, RocketHideout2ArrowMovement32
	map_coord_movement 16, 16, RocketHideout2ArrowMovement33
	map_coord_movement 16, 18, RocketHideout2ArrowMovement34
	map_coord_movement 17, 10, RocketHideout2ArrowMovement35
	map_coord_movement 17, 11, RocketHideout2ArrowMovement36
	.DB -1 ; end

;format: direction, count
;each list is read starting from the $FF and working backwards
RocketHideout2ArrowMovement1:
	.DB PAD_LEFT, 2
	.DB -1 ; end

RocketHideout2ArrowMovement2:
	.DB PAD_RIGHT, 4
	.DB -1 ; end

RocketHideout2ArrowMovement3:
	.DB PAD_UP, 4
	.DB PAD_RIGHT, 4
	.DB -1 ; end

RocketHideout2ArrowMovement4:
	.DB PAD_UP, 4
	.DB PAD_RIGHT, 4
	.DB PAD_UP, 1
	.DB -1 ; end

RocketHideout2ArrowMovement5:
	.DB PAD_LEFT, 2
	.DB PAD_UP, 3
	.DB -1 ; end

RocketHideout2ArrowMovement6:
	.DB PAD_DOWN, 2
	.DB PAD_RIGHT, 4
	.DB -1 ; end

RocketHideout2ArrowMovement7:
	.DB PAD_UP, 2
	.DB -1 ; end

RocketHideout2ArrowMovement8:
	.DB PAD_UP, 4
	.DB -1 ; end

RocketHideout2ArrowMovement9:
	.DB PAD_LEFT, 6
	.DB -1 ; end

RocketHideout2ArrowMovement10:
	.DB PAD_UP, 1
	.DB -1 ; end

RocketHideout2ArrowMovement11:
	.DB PAD_LEFT, 6
	.DB PAD_UP, 4
	.DB -1 ; end

RocketHideout2ArrowMovement12:
	.DB PAD_DOWN, 2
	.DB -1 ; end

RocketHideout2ArrowMovement13:
	.DB PAD_LEFT, 8
	.DB -1 ; end

RocketHideout2ArrowMovement14:
	.DB PAD_LEFT, 8
	.DB PAD_UP, 1
	.DB -1 ; end

RocketHideout2ArrowMovement15:
	.DB PAD_LEFT, 8
	.DB PAD_UP, 6
	.DB -1 ; end

RocketHideout2ArrowMovement16:
	.DB PAD_UP, 2
	.DB PAD_RIGHT, 4
	.DB -1 ; end

RocketHideout2ArrowMovement17:
	.DB PAD_UP, 2
	.DB PAD_RIGHT, 4
	.DB PAD_UP, 2
	.DB -1 ; end

RocketHideout2ArrowMovement18:
	.DB PAD_DOWN, 2
	.DB PAD_RIGHT, 4
	.DB PAD_DOWN, 2
	.DB -1 ; end

RocketHideout2ArrowMovement19:
	.DB PAD_DOWN, 2
	.DB PAD_RIGHT, 4
	.DB -1 ; end

RocketHideout2ArrowMovement20:
	.DB PAD_LEFT, 10
	.DB -1 ; end

RocketHideout2ArrowMovement21:
	.DB PAD_LEFT, 10
	.DB PAD_UP, 2
	.DB -1 ; end

RocketHideout2ArrowMovement22:
	.DB PAD_LEFT, 10
	.DB PAD_UP, 4
	.DB -1 ; end

RocketHideout2ArrowMovement23:
	.DB PAD_UP, 2
	.DB PAD_RIGHT, 2
	.DB -1 ; end

RocketHideout2ArrowMovement24:
	.DB PAD_RIGHT, 1
	.DB PAD_DOWN, 2
	.DB -1 ; end

RocketHideout2ArrowMovement25:
	.DB PAD_RIGHT, 1
	.DB -1 ; end

RocketHideout2ArrowMovement26:
	.DB PAD_DOWN, 2
	.DB PAD_RIGHT, 2
	.DB -1 ; end

RocketHideout2ArrowMovement27:
	.DB PAD_DOWN, 2
	.DB PAD_LEFT, 2
	.DB -1 ; end

RocketHideout2ArrowMovement28:
	.DB PAD_UP, 2
	.DB PAD_RIGHT, 4
	.DB PAD_UP, 2
	.DB PAD_LEFT, 3
	.DB -1 ; end

RocketHideout2ArrowMovement29:
	.DB PAD_DOWN, 2
	.DB PAD_LEFT, 4
	.DB -1 ; end

RocketHideout2ArrowMovement30:
	.DB PAD_LEFT, 6
	.DB PAD_UP, 4
	.DB PAD_LEFT, 5
	.DB -1 ; end

RocketHideout2ArrowMovement31:
	.DB PAD_UP, 2
	.DB -1 ; end

RocketHideout2ArrowMovement32:
	.DB PAD_UP, 1
	.DB -1 ; end

RocketHideout2ArrowMovement33:
	.DB PAD_UP, 3
	.DB -1 ; end

RocketHideout2ArrowMovement34:
	.DB PAD_UP, 5
	.DB -1 ; end

RocketHideout2ArrowMovement35:
	.DB PAD_RIGHT, 1
	.DB PAD_DOWN, 2
	.DB PAD_LEFT, 4
	.DB -1 ; end

RocketHideout2ArrowMovement36:
	.DB PAD_LEFT, 10
	.DB PAD_UP, 2
	.DB PAD_LEFT, 5
	.DB -1 ; end

RocketHideoutB2FPlayerSpinningScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	jr nz, LoadSpinnerArrowTiles
	xor a
	ld [wJoyIgnore], a
	ld hl, wMovementFlags
	res BIT_SPINNING, [hl]
	ld a, SCRIPT_ROCKETHIDEOUTB2F_DEFAULT
	ld [wCurMapScript], a
	ret

.INCLUDE "engine/overworld/spinners.asm"

RocketHideoutB2F_TextPointers:
	def_text_pointers
	dw_const RocketHideoutB2FRocketText, TEXT_ROCKETHIDEOUTB2F_ROCKET
	dw_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_MOON_STONE
	dw_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_NUGGET
	dw_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_TM_HORN_DRILL
	dw_const PickUpItemText,             TEXT_ROCKETHIDEOUTB2F_SUPER_POTION

RocketHideout2TrainerHeaders:
	def_trainers
RocketHideout2TrainerHeader0:
	trainer EVENT_BEAT_ROCKET_HIDEOUT_2_TRAINER_0, 4, RocketHideoutB2FRocketBattleText, RocketHideoutB2FRocketEndBattleText, RocketHideoutB2FRocketAfterBattleText
	.DB -1 ; end

RocketHideoutB2FRocketText:
	text_asm
	ld hl, RocketHideout2TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

RocketHideoutB2FRocketBattleText:
	text_far WLA_GLOBAL_RocketHideoutB2FRocketBattleText
	text_end

RocketHideoutB2FRocketEndBattleText:
	text_far WLA_GLOBAL_RocketHideoutB2FRocketEndBattleText
	text_end

RocketHideoutB2FRocketAfterBattleText:
	text_far WLA_GLOBAL_RocketHideoutB2FRocketAfterBattleText
	text_end
