FightingDojo_Script:
	call EnableAutoTextBoxDrawing
	ld hl, FightingDojoTrainerHeaders
	ld de, FightingDojo_ScriptPointers
	ld a, [wFightingDojoCurScript]
	call ExecuteCurMapScriptInTable
	ld [wFightingDojoCurScript], a
	ret

FightingDojoResetScripts:
	xor a ; SCRIPT_FIGHTINGDOJO_DEFAULT
	ld [wJoyIgnore], a
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	ret

FightingDojo_ScriptPointers:
	def_script_pointers
	dw_const FightingDojoDefaultScript,                SCRIPT_FIGHTINGDOJO_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle,    SCRIPT_FIGHTINGDOJO_START_BATTLE
	dw_const EndTrainerBattle,                         SCRIPT_FIGHTINGDOJO_END_BATTLE
	dw_const FightingDojoKarateMasterPostBattleScript, SCRIPT_FIGHTINGDOJO_KARATE_MASTER_POST_BATTLE

FightingDojoDefaultScript:
	CheckEvent EVENT_DEFEATED_FIGHTING_DOJO
	ret nz
	call CheckFightingMapTrainers
	ld a, [wTrainerHeaderFlagBit]
	and a
	ret nz
	CheckEvent EVENT_BEAT_KARATE_MASTER
	ret nz
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld [wSavedCoordIndex], a
	ld a, [wYCoord]
	cp 3
	ret nz
	ld a, [wXCoord]
	cp 4
	ret nz
	ld a, 1
	ld [wSavedCoordIndex], a
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, FIGHTINGDOJO_KARATE_MASTER
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_LEFT
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_FIGHTINGDOJO_KARATE_MASTER
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ret

FightingDojoKarateMasterPostBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, FightingDojoResetScripts
	ld a, [wSavedCoordIndex]
	and a ; nz if the player was at (4, 3), left of the Karate Master
	jr z, FightingDojoKarateMasterPostBattleScript.already_facing
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, FIGHTINGDOJO_KARATE_MASTER
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_LEFT
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
FightingDojoKarateMasterPostBattleScript.already_facing
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEventRange EVENT_BEAT_KARATE_MASTER, EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	ld a, TEXT_FIGHTINGDOJO_KARATE_MASTER_I_WILL_GIVE_YOU_A_POKEMON
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	xor a ; SCRIPT_FIGHTINGDOJO_DEFAULT
	ld [wJoyIgnore], a
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	ret

FightingDojo_TextPointers:
	def_text_pointers
	dw_const FightingDojoKarateMasterText,                          TEXT_FIGHTINGDOJO_KARATE_MASTER
	dw_const FightingDojoBlackbelt1Text,                            TEXT_FIGHTINGDOJO_BLACKBELT1
	dw_const FightingDojoBlackbelt2Text,                            TEXT_FIGHTINGDOJO_BLACKBELT2
	dw_const FightingDojoBlackbelt3Text,                            TEXT_FIGHTINGDOJO_BLACKBELT3
	dw_const FightingDojoBlackbelt4Text,                            TEXT_FIGHTINGDOJO_BLACKBELT4
	dw_const FightingDojoHitmonleePokeBallText,                     TEXT_FIGHTINGDOJO_HITMONLEE_POKE_BALL
	dw_const FightingDojoHitmonchanPokeBallText,                    TEXT_FIGHTINGDOJO_HITMONCHAN_POKE_BALL
	dw_const FightingDojoKarateMasterText.IWillGiveYouAPokemonText, TEXT_FIGHTINGDOJO_KARATE_MASTER_I_WILL_GIVE_YOU_A_POKEMON

FightingDojoTrainerHeaders:
	def_trainers 2
FightingDojoTrainerHeader0:
	trainer EVENT_BEAT_FIGHTING_DOJO_TRAINER_0, 4, FightingDojoBlackbelt1BattleText, FightingDojoBlackbelt1EndBattleText, FightingDojoBlackbelt1AfterBattleText
FightingDojoTrainerHeader1:
	trainer EVENT_BEAT_FIGHTING_DOJO_TRAINER_1, 4, FightingDojoBlackbelt2BattleText, FightingDojoBlackbelt2EndBattleText, FightingDojoBlackbelt2AfterBattleText
FightingDojoTrainerHeader2:
	trainer EVENT_BEAT_FIGHTING_DOJO_TRAINER_2, 3, FightingDojoBlackbelt3BattleText, FightingDojoBlackbelt3EndBattleText, FightingDojoBlackbelt3AfterBattleText
FightingDojoTrainerHeader3:
	trainer EVENT_BEAT_FIGHTING_DOJO_TRAINER_3, 3, FightingDojoBlackbelt4BattleText, FightingDojoBlackbelt4EndBattleText, FightingDojoBlackbelt4AfterBattleText
	.DB -1 ; end

FightingDojoKarateMasterText:
	text_asm
	CheckEvent EVENT_DEFEATED_FIGHTING_DOJO
	jp nz, FightingDojoKarateMasterText.defeated_dojo
	CheckEventReuseA EVENT_BEAT_KARATE_MASTER
	jp nz, FightingDojoKarateMasterText.defeated_master
	ld hl, FightingDojoKarateMasterText.Text
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, FightingDojoKarateMasterText.DefeatedText
	ld de, FightingDojoKarateMasterText.DefeatedText
	call SaveEndBattleTextPointers
	ldh a, [lobyte(hSpriteIndex)]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_FIGHTINGDOJO_KARATE_MASTER_POST_BATTLE
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	jr FightingDojoKarateMasterText.end
FightingDojoKarateMasterText.defeated_dojo
	ld hl, FightingDojoKarateMasterText.StayAndTrainWithUsText
	call PrintText
	jr FightingDojoKarateMasterText.end
FightingDojoKarateMasterText.defeated_master
	ld hl, FightingDojoKarateMasterText.IWillGiveYouAPokemonText
	call PrintText
FightingDojoKarateMasterText.end
	jp TextScriptEnd

FightingDojoKarateMasterText.Text:
	text_far WLA_GLOBAL_FightingDojoKarateMasterText
	text_end

FightingDojoKarateMasterText.DefeatedText:
	text_far WLA_GLOBAL_FightingDojoKarateMasterDefeatedText
	text_end

FightingDojoKarateMasterText.IWillGiveYouAPokemonText:
	text_far WLA_GLOBAL_FightingDojoKarateMasterIWillGiveYouAPokemonText
	text_end

FightingDojoKarateMasterText.StayAndTrainWithUsText:
	text_far WLA_GLOBAL_FightingDojoKarateMasterStayAndTrainWithUsText
	text_end

FightingDojoBlackbelt1Text:
	text_asm
	ld hl, FightingDojoTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBlackbelt1BattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt1BattleText
	text_end

FightingDojoBlackbelt1EndBattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt1EndBattleText
	text_end

FightingDojoBlackbelt1AfterBattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt1AfterBattleText
	text_end

FightingDojoBlackbelt2Text:
	text_asm
	ld hl, FightingDojoTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBlackbelt2BattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt2BattleText
	text_end

FightingDojoBlackbelt2EndBattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt2EndBattleText
	text_end

FightingDojoBlackbelt2AfterBattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt2AfterBattleText
	text_end

FightingDojoBlackbelt3Text:
	text_asm
	ld hl, FightingDojoTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBlackbelt3BattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt3BattleText
	text_end

FightingDojoBlackbelt3EndBattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt3EndBattleText
	text_end

FightingDojoBlackbelt3AfterBattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt3AfterBattleText
	text_end

FightingDojoBlackbelt4Text:
	text_asm
	ld hl, FightingDojoTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBlackbelt4BattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt4BattleText
	text_end

FightingDojoBlackbelt4EndBattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt4EndBattleText
	text_end

FightingDojoBlackbelt4AfterBattleText:
	text_far WLA_GLOBAL_FightingDojoBlackbelt4AfterBattleText
	text_end

FightingDojoHitmonleePokeBallText:
	text_asm
	CheckEitherEventSet EVENT_GOT_HITMONLEE, EVENT_GOT_HITMONCHAN
	jr z, FightingDojoHitmonleePokeBallText.GetMon
	ld hl, FightingDojoBetterNotGetGreedyText
	call PrintText
	jr FightingDojoHitmonleePokeBallText.done
FightingDojoHitmonleePokeBallText.GetMon
	ld a, HITMONLEE
	call DisplayPokedex
	ld hl, FightingDojoHitmonleePokeBallText.Text
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, FightingDojoHitmonleePokeBallText.done
	ld a, [wCurPartySpecies]
	ld b, a
	ld c, 30
	call GivePokemon
	jr nc, FightingDojoHitmonleePokeBallText.done

	; once Poké Ball is taken, hide sprite
	ld a, TOGGLE_FIGHTING_DOJO_GIFT_1
	ld [wToggleableObjectIndex], a
	predef HideObject
	SetEvents EVENT_GOT_HITMONLEE, EVENT_DEFEATED_FIGHTING_DOJO
FightingDojoHitmonleePokeBallText.done
	jp TextScriptEnd

FightingDojoHitmonleePokeBallText.Text:
	text_far WLA_GLOBAL_FightingDojoHitmonleePokeBallText
	text_end

FightingDojoHitmonchanPokeBallText:
	text_asm
	CheckEitherEventSet EVENT_GOT_HITMONLEE, EVENT_GOT_HITMONCHAN
	jr z, FightingDojoHitmonchanPokeBallText.GetMon
	ld hl, FightingDojoBetterNotGetGreedyText
	call PrintText
	jr FightingDojoHitmonchanPokeBallText.done
FightingDojoHitmonchanPokeBallText.GetMon
	ld a, HITMONCHAN
	call DisplayPokedex
	ld hl, FightingDojoHitmonchanPokeBallText.Text
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, FightingDojoHitmonchanPokeBallText.done
	ld a, [wCurPartySpecies]
	ld b, a
	ld c, 30
	call GivePokemon
	jr nc, FightingDojoHitmonchanPokeBallText.done
	SetEvents EVENT_GOT_HITMONCHAN, EVENT_DEFEATED_FIGHTING_DOJO

	; once Poké Ball is taken, hide sprite
	ld a, TOGGLE_FIGHTING_DOJO_GIFT_2
	ld [wToggleableObjectIndex], a
	predef HideObject
FightingDojoHitmonchanPokeBallText.done
	jp TextScriptEnd

FightingDojoHitmonchanPokeBallText.Text:
	text_far WLA_GLOBAL_FightingDojoHitmonchanPokeBallText
	text_end

FightingDojoBetterNotGetGreedyText:
	text_far WLA_GLOBAL_FightingDojoBetterNotGetGreedyText
	text_end
