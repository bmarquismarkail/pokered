PokemonTower2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower2F_ScriptPointers
	ld a, [wPokemonTower2FCurScript]
	jp CallFunctionInTable

PokemonTower2FResetRivalEncounter:
	xor a ; SCRIPT_POKEMONTOWER2F_DEFAULT
	ld [wJoyIgnore], a
	ld [wPokemonTower2FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower2F_ScriptPointers:
	def_script_pointers
	dw_const PokemonTower2FDefaultScript,       SCRIPT_POKEMONTOWER2F_DEFAULT
	dw_const PokemonTower2FDefeatedRivalScript, SCRIPT_POKEMONTOWER2F_DEFEATED_RIVAL
	dw_const PokemonTower2FRivalExitsScript,    SCRIPT_POKEMONTOWER2F_RIVAL_EXITS

PokemonTower2FDefaultScript:
.IF defined(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
.ENDIF
	CheckEvent EVENT_BEAT_POKEMON_TOWER_RIVAL
	ret nz
	ld hl, PokemonTower2FRivalEncounterEventCoords
	call ArePlayerCoordsInArray
	ret nc
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld c, bank(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ResetEvent EVENT_POKEMON_TOWER_RIVAL_ON_LEFT
	ld a, [wCoordIndex]
	cp $1
	ld a, PLAYER_DIR_UP
	ld b, SPRITE_FACING_DOWN
	jr nz, PokemonTower2FDefaultScript.player_below_rival
; the rival is on the left side and the player is on the right side
	SetEvent EVENT_POKEMON_TOWER_RIVAL_ON_LEFT
	ld a, PLAYER_DIR_LEFT
	ld b, SPRITE_FACING_RIGHT
PokemonTower2FDefaultScript.player_below_rival
	ld [wPlayerMovingDirection], a
	ld a, POKEMONTOWER2F_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld a, b
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_POKEMONTOWER2F_RIVAL
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	xor a
	ldh [lobyte(hJoyHeld)], a
	ldh [lobyte(hJoyPressed)], a
	ret

PokemonTower2FRivalEncounterEventCoords:
	dbmapcoord 15,  5
	dbmapcoord 14,  6
	.DB $0F ; end? (should be $ff?)

PokemonTower2FDefeatedRivalScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonTower2FResetRivalEncounter
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_POKEMON_TOWER_RIVAL
	ld a, TEXT_POKEMONTOWER2F_RIVAL
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld de, PokemonTower2FRivalDownThenRightMovement
	CheckEvent EVENT_POKEMON_TOWER_RIVAL_ON_LEFT
	jr nz, PokemonTower2FDefeatedRivalScript.got_movement
	ld de, PokemonTower2FRivalRightThenDownMovement
PokemonTower2FDefeatedRivalScript.got_movement
	ld a, POKEMONTOWER2F_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	call MoveSprite
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	farcall Music_RivalAlternateStart
	ld a, SCRIPT_POKEMONTOWER2F_RIVAL_EXITS
	ld [wPokemonTower2FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower2FRivalRightThenDownMovement:
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB -1 ; end

PokemonTower2FRivalDownThenRightMovement:
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB -1 ; end

PokemonTower2FRivalExitsScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_POKEMON_TOWER_2F_RIVAL
	ld [wToggleableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	call PlayDefaultMusic
	ld a, SCRIPT_POKEMONTOWER2F_DEFAULT
	ld [wPokemonTower2FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower2F_TextPointers:
	def_text_pointers
	dw_const PokemonTower2FRivalText,     TEXT_POKEMONTOWER2F_RIVAL
	dw_const PokemonTower2FChannelerText, TEXT_POKEMONTOWER2F_CHANNELER

PokemonTower2FRivalText:
	text_asm
	CheckEvent EVENT_BEAT_POKEMON_TOWER_RIVAL
	jr z, PokemonTower2FRivalText.do_battle
	ld hl, PokemonTower2FRivalText.HowsYourDexText
	call PrintText
	jr PokemonTower2FRivalText.text_script_end
PokemonTower2FRivalText.do_battle
	ld hl, PokemonTower2FRivalText.WhatBringsYouHereText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, PokemonTower2FRivalText.DefeatedText
	ld de, PokemonTower2FRivalText.VictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL2
	ld [wCurOpponent], a

	; select which team to use during the encounter
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, PokemonTower2FRivalText.NotSquirtle
	ld a, $4
	jr PokemonTower2FRivalText.done
PokemonTower2FRivalText.NotSquirtle
	cp STARTER3
	jr nz, PokemonTower2FRivalText.Charmander
	ld a, $5
	jr PokemonTower2FRivalText.done
PokemonTower2FRivalText.Charmander
	ld a, $6
PokemonTower2FRivalText.done
	ld [wTrainerNo], a

	ld a, SCRIPT_POKEMONTOWER2F_DEFEATED_RIVAL
	ld [wPokemonTower2FCurScript], a
	ld [wCurMapScript], a
PokemonTower2FRivalText.text_script_end
	jp TextScriptEnd

PokemonTower2FRivalText.WhatBringsYouHereText:
	text_far WLA_GLOBAL_PokemonTower2FRivalWhatBringsYouHereText
	text_end

PokemonTower2FRivalText.DefeatedText:
	text_far WLA_GLOBAL_PokemonTower2FRivalDefeatedText
	text_end

PokemonTower2FRivalText.VictoryText:
	text_far WLA_GLOBAL_PokemonTower2FRivalVictoryText
	text_end

PokemonTower2FRivalText.HowsYourDexText:
	text_far WLA_GLOBAL_PokemonTower2FRivalHowsYourDexText
	text_end

PokemonTower2FChannelerText:
	text_far WLA_GLOBAL_PokemonTower2FChannelerText
	text_end
