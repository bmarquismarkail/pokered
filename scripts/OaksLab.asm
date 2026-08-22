OaksLab_Script:
	CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
	call nz, OaksLabLoadTextPointers2Script
	ld a, 1 << BIT_NO_AUTO_TEXT_BOX
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLab_ScriptPointers
	ld a, [wOaksLabCurScript]
	jp CallFunctionInTable

OaksLab_ScriptPointers:
	def_script_pointers
	dw_const OaksLabDefaultScript,                   SCRIPT_OAKSLAB_DEFAULT
	dw_const OaksLabOakEntersLabScript,              SCRIPT_OAKSLAB_OAK_ENTERS_LAB
	dw_const OaksLabToggleOaksScript,                SCRIPT_OAKSLAB_TOGGLE_OAKS
	dw_const OaksLabPlayerEntersLabScript,           SCRIPT_OAKSLAB_PLAYER_ENTERS_LAB
	dw_const OaksLabFollowedOakScript,               SCRIPT_OAKSLAB_FOLLOWED_OAK
	dw_const OaksLabOakChooseMonSpeechScript,        SCRIPT_OAKSLAB_OAK_CHOOSE_MON_SPEECH
	dw_const OaksLabPlayerDontGoAwayScript,          SCRIPT_OAKSLAB_PLAYER_DONT_GO_AWAY_SCRIPT
	dw_const OaksLabPlayerForcedToWalkBackScript,    SCRIPT_OAKSLAB_PLAYER_FORCED_TO_WALK_BACK_SCRIPT
	dw_const OaksLabChoseStarterScript,              SCRIPT_OAKSLAB_CHOSE_STARTER_SCRIPT
	dw_const OaksLabRivalChoosesStarterScript,       SCRIPT_OAKSLAB_RIVAL_CHOOSES_STARTER
	dw_const OaksLabRivalChallengesPlayerScript,     SCRIPT_OAKSLAB_RIVAL_CHALLENGES_PLAYER
	dw_const OaksLabRivalStartBattleScript,          SCRIPT_OAKSLAB_RIVAL_START_BATTLE
	dw_const OaksLabRivalEndBattleScript,            SCRIPT_OAKSLAB_RIVAL_END_BATTLE
	dw_const OaksLabRivalStartsExitScript,           SCRIPT_OAKSLAB_RIVAL_STARTS_EXIT
	dw_const OaksLabPlayerWatchRivalExitScript,      SCRIPT_OAKSLAB_PLAYER_WATCH_RIVAL_EXIT
	dw_const OaksLabRivalArrivesAtOaksRequestScript, SCRIPT_OAKSLAB_RIVAL_ARRIVES_AT_OAKS_REQUEST
	dw_const OaksLabOakGivesPokedexScript,           SCRIPT_OAKSLAB_OAK_GIVES_POKEDEX
	dw_const OaksLabRivalLeavesWithPokedexScript,    SCRIPT_OAKSLAB_RIVAL_LEAVES_WITH_POKEDEX
	dw_const OaksLabNoopScript,                      SCRIPT_OAKSLAB_NOOP

OaksLabDefaultScript:
	CheckEvent EVENT_OAK_APPEARED_IN_PALLET
	ret z
	ld a, [wNPCMovementScriptFunctionNum]
	and a
	ret nz
	ld a, TOGGLE_OAKS_LAB_OAK_2
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld hl, wStatusFlags4
	res BIT_NO_BATTLES, [hl]

	ld a, SCRIPT_OAKSLAB_OAK_ENTERS_LAB
	ld [wOaksLabCurScript], a
	ret

OaksLabOakEntersLabScript:
	ld a, OAKSLAB_OAK2
	ldh [lobyte(hSpriteIndex)], a
	ld de, OakEntryMovement
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_TOGGLE_OAKS
	ld [wOaksLabCurScript], a
	ret

OakEntryMovement:
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_UP
	.DB -1 ; end

OaksLabToggleOaksScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_OAKS_LAB_OAK_2
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_OAKS_LAB_OAK_1
	ld [wToggleableObjectIndex], a
	predef ShowObject

	ld a, SCRIPT_OAKSLAB_PLAYER_ENTERS_LAB
	ld [wOaksLabCurScript], a
	ret

OaksLabPlayerEntersLabScript:
	call Delay3
	ld hl, wSimulatedJoypadStatesEnd
	ld de, PlayerEntryMovementRLE
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	xor a
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, OAKSLAB_OAK1
	ldh [lobyte(hSpriteIndex)], a
	xor a
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay

	ld a, SCRIPT_OAKSLAB_FOLLOWED_OAK
	ld [wOaksLabCurScript], a
	ret

PlayerEntryMovementRLE:
	.DB PAD_UP, 8
	.DB -1 ; end

OaksLabFollowedOakScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_UP
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	ld hl, wStatusFlags7
	res BIT_NO_MAP_MUSIC, [hl]
	call PlayDefaultMusic

	ld a, SCRIPT_OAKSLAB_OAK_CHOOSE_MON_SPEECH
	ld [wOaksLabCurScript], a
	ret

OaksLabOakChooseMonSpeechScript:
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_OAKSLAB_RIVAL_FED_UP_WITH_WAITING
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	call Delay3
	ld a, TEXT_OAKSLAB_OAK_CHOOSE_MON
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	call Delay3
	ld a, TEXT_OAKSLAB_RIVAL_WHAT_ABOUT_ME
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	call Delay3
	ld a, TEXT_OAKSLAB_OAK_BE_PATIENT
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	SetEvent EVENT_OAK_ASKED_TO_CHOOSE_MON
	xor a
	ld [wJoyIgnore], a

	ld a, SCRIPT_OAKSLAB_PLAYER_DONT_GO_AWAY_SCRIPT
	ld [wOaksLabCurScript], a
	ret

OaksLabPlayerDontGoAwayScript:
	ld a, [wYCoord]
	cp 6
	ret nz
	ld a, OAKSLAB_OAK1
	ldh [lobyte(hSpriteIndex)], a
	xor a ; SPRITE_FACING_DOWN
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	xor a ; SPRITE_FACING_DOWN
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	ld a, TEXT_OAKSLAB_OAK_DONT_GO_AWAY_YET
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a

	ld a, SCRIPT_OAKSLAB_PLAYER_FORCED_TO_WALK_BACK_SCRIPT
	ld [wOaksLabCurScript], a
	ret

OaksLabPlayerForcedToWalkBackScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3

	ld a, SCRIPT_OAKSLAB_PLAYER_DONT_GO_AWAY_SCRIPT
	ld [wOaksLabCurScript], a
	ret

OaksLabChoseStarterScript:
	ld a, [wPlayerStarter]
	cp STARTER1
	jr z, OaksLabChoseStarterScript.Charmander
	cp STARTER2
	jr z, OaksLabChoseStarterScript.Squirtle
	jr OaksLabChoseStarterScript.Bulbasaur
OaksLabChoseStarterScript.Charmander
	ld de, OaksLabChoseStarterScript.MiddleBallMovement1
	ld a, [wYCoord]
	cp 4 ; is the player standing below the table?
	jr z, OaksLabChoseStarterScript.moveBlue
	ld de, OaksLabChoseStarterScript.MiddleBallMovement2
	jr OaksLabChoseStarterScript.moveBlue

OaksLabChoseStarterScript.MiddleBallMovement1
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_UP
	.DB -1 ; end

OaksLabChoseStarterScript.MiddleBallMovement2
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB -1 ; end

OaksLabChoseStarterScript.Squirtle
	ld de, OaksLabChoseStarterScript.RightBallMovement1
	ld a, [wYCoord]
	cp 4 ; is the player standing below the table?
	jr z, OaksLabChoseStarterScript.moveBlue
	ld de, OaksLabChoseStarterScript.RightBallMovement2
	jr OaksLabChoseStarterScript.moveBlue

OaksLabChoseStarterScript.RightBallMovement1
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_UP
	.DB -1 ; end

OaksLabChoseStarterScript.RightBallMovement2
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB -1 ; end

OaksLabChoseStarterScript.Bulbasaur
	ld de, OaksLabChoseStarterScript.LeftBallMovement1
	ld a, [wXCoord]
	cp 9 ; is the player standing to the right of the table?
	jr nz, OaksLabChoseStarterScript.moveBlue
	push hl
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITESTATEDATA1_YPIXELS
	ldh [lobyte(hSpriteDataOffset)], a
	call GetPointerWithinSpriteStateData1
	push hl
	ld [hl], $4c ; SPRITESTATEDATA1_YPIXELS
	inc hl
	inc hl
	ld [hl], $0 ; SPRITESTATEDATA1_XPIXELS
	pop hl
	inc h
	ld [hl], 8 ; SPRITESTATEDATA2_MAPY
	inc hl
	ld [hl], 9 ; SPRITESTATEDATA2_MAPX
	ld de, OaksLabChoseStarterScript.LeftBallMovement2 ; the rival is not currently onscreen, so account for that
	pop hl
	jr OaksLabChoseStarterScript.moveBlue

OaksLabChoseStarterScript.LeftBallMovement1
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_RIGHT
OaksLabChoseStarterScript.LeftBallMovement2
	.DB NPC_MOVEMENT_RIGHT
	.DB -1 ; end

OaksLabChoseStarterScript.moveBlue
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_RIVAL_CHOOSES_STARTER
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalChoosesStarterScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_UP
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_OAKSLAB_RIVAL_ILL_TAKE_THIS_ONE
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, [wRivalStarterBallSpriteIndex]
	cp OAKSLAB_CHARMANDER_POKE_BALL
	jr nz, OaksLabRivalChoosesStarterScript.not_charmander
	ld a, TOGGLE_STARTER_BALL_1
	jr OaksLabRivalChoosesStarterScript.hideBallAndContinue
OaksLabRivalChoosesStarterScript.not_charmander
	cp OAKSLAB_SQUIRTLE_POKE_BALL
	jr nz, OaksLabRivalChoosesStarterScript.not_squirtle
	ld a, TOGGLE_STARTER_BALL_2
	jr OaksLabRivalChoosesStarterScript.hideBallAndContinue
OaksLabRivalChoosesStarterScript.not_squirtle
	ld a, TOGGLE_STARTER_BALL_3
OaksLabRivalChoosesStarterScript.hideBallAndContinue
	ld [wToggleableObjectIndex], a
	predef HideObject
	call Delay3
	ld a, [wRivalStarterTemp]
	ld [wRivalStarter], a
	ld [wCurPartySpecies], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_UP
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_OAKSLAB_RIVAL_RECEIVED_MON
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	SetEvent EVENT_GOT_STARTER
	xor a
	ld [wJoyIgnore], a

	ld a, SCRIPT_OAKSLAB_RIVAL_CHALLENGES_PLAYER
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalChallengesPlayerScript:
	ld a, [wYCoord]
	cp 6
	ret nz
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	xor a ; SPRITE_FACING_DOWN
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld c, bank(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld a, TEXT_OAKSLAB_RIVAL_ILL_TAKE_YOU_ON
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, $1
	ldh [lobyte(hNPCPlayerRelativePosPerspective)], a
	ld a, $1
	swap a
	ldh [lobyte(hNPCSpriteOffset)], a
	predef CalcPositionOfPlayerRelativeToNPC
	ldh a, [lobyte(hNPCPlayerYDistance)]
	dec a
	ldh [lobyte(hNPCPlayerYDistance)], a
	predef FindPathToPlayer
	ld de, wNPCMovementDirections2
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_RIVAL_START_BATTLE
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalStartBattleScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; define which team rival uses, and fight it
	ld a, OPP_RIVAL1
	ld [wCurOpponent], a
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, OaksLabRivalStartBattleScript.not_squirtle
	ld a, $1
	jr OaksLabRivalStartBattleScript.done
OaksLabRivalStartBattleScript.not_squirtle
	cp STARTER3
	jr nz, OaksLabRivalStartBattleScript.not_bulbasaur
	ld a, $2
	jr OaksLabRivalStartBattleScript.done
OaksLabRivalStartBattleScript.not_bulbasaur
	ld a, $3
OaksLabRivalStartBattleScript.done
	ld [wTrainerNo], a
	ld a, OAKSLAB_RIVAL
	ld [wSpriteIndex], a
	call GetSpritePosition1
	ld hl, OaksLabRivalIPickedTheWrongPokemonText
	ld de, OaksLabRivalAmIGreatOrWhatText
	call SaveEndBattleTextPointers
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	xor a
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, SCRIPT_OAKSLAB_RIVAL_END_BATTLE
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalEndBattleScript:
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld a, OAKSLAB_RIVAL
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	xor a ; SPRITE_FACING_DOWN
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	predef HealParty
	SetEvent EVENT_BATTLED_RIVAL_IN_OAKS_LAB

	ld a, SCRIPT_OAKSLAB_RIVAL_STARTS_EXIT
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalStartsExitScript:
	ld c, 20
	call DelayFrames
	ld a, TEXT_OAKSLAB_RIVAL_SMELL_YOU_LATER
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	farcall Music_RivalAlternateStart
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld de, OaksLabRivalStartsExitScript.RivalExitMovement
	call MoveSprite
	ld a, [wXCoord]
	cp 4
	; move left or right depending on where the player is standing
	jr nz, OaksLabRivalStartsExitScript.moveLeft
	ld a, NPC_MOVEMENT_RIGHT
	jr OaksLabRivalStartsExitScript.next
OaksLabRivalStartsExitScript.moveLeft
	ld a, NPC_MOVEMENT_LEFT
OaksLabRivalStartsExitScript.next
	ld [wNPCMovementDirections], a

	ld a, SCRIPT_OAKSLAB_PLAYER_WATCH_RIVAL_EXIT
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalStartsExitScript.RivalExitMovement
	.DB NPC_CHANGE_FACING
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB -1 ; end

OaksLabPlayerWatchRivalExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	jr nz, OaksLabPlayerWatchRivalExitScript.checkRivalPosition
	ld a, TOGGLE_OAKS_LAB_RIVAL
	ld [wToggleableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	call PlayDefaultMusic ; reset to map music
	ld a, SCRIPT_OAKSLAB_NOOP
	ld [wOaksLabCurScript], a
	jr OaksLabPlayerWatchRivalExitScript.done
; make the player keep facing the rival as he walks away
OaksLabPlayerWatchRivalExitScript.checkRivalPosition
	ld a, [wNPCNumScriptedSteps]
	cp $5
	jr nz, OaksLabPlayerWatchRivalExitScript.turnPlayerDown
	ld a, [wXCoord]
	cp 4
	jr nz, OaksLabPlayerWatchRivalExitScript.turnPlayerLeft
	ld a, SPRITE_FACING_RIGHT
	ld [wSpritePlayerStateData1FacingDirection], a
	jr OaksLabPlayerWatchRivalExitScript.done
OaksLabPlayerWatchRivalExitScript.turnPlayerLeft
	ld a, SPRITE_FACING_LEFT
	ld [wSpritePlayerStateData1FacingDirection], a
	jr OaksLabPlayerWatchRivalExitScript.done
OaksLabPlayerWatchRivalExitScript.turnPlayerDown
	cp $4
	ret nz
	xor a ; ld a, SPRITE_FACING_DOWN
	ld [wSpritePlayerStateData1FacingDirection], a
OaksLabPlayerWatchRivalExitScript.done
	ret

OaksLabRivalArrivesAtOaksRequestScript:
	xor a
	ldh [lobyte(hJoyHeld)], a
	call EnableAutoTextBoxDrawing
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	farcall Music_RivalAlternateStart
	ld a, TEXT_OAKSLAB_RIVAL_GRAMPS
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	call OaksLabCalcRivalMovementScript
	ld a, TOGGLE_OAKS_LAB_RIVAL
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, [wNPCMovementDirections2Index]
	ld [wSavedNPCMovementDirections2Index], a
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	ld a, NPC_MOVEMENT_UP
	call FillMemory
	ld [hl], $ff
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_OAK_GIVES_POKEDEX
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalFaceUpOakFaceDownScript:
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_UP
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, OAKSLAB_OAK2
	ldh [lobyte(hSpriteIndex)], a
	xor a ; SPRITE_FACING_DOWN
	ldh [lobyte(hSpriteFacingDirection)], a
	jp SetSpriteFacingDirectionAndDelay

OaksLabOakGivesPokedexScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	call EnableAutoTextBoxDrawing
	call PlayDefaultMusic
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	call OaksLabRivalFaceUpOakFaceDownScript
	ld a, TEXT_OAKSLAB_RIVAL_WHAT_DID_YOU_CALL_ME_FOR
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	call DelayFrame
	call OaksLabRivalFaceUpOakFaceDownScript
	ld a, TEXT_OAKSLAB_OAK_I_HAVE_A_REQUEST
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	call DelayFrame
	call OaksLabRivalFaceUpOakFaceDownScript
	ld a, TEXT_OAKSLAB_OAK_MY_INVENTION_POKEDEX
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	call DelayFrame
	ld a, TEXT_OAKSLAB_OAK_GOT_POKEDEX
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	call Delay3
	ld a, TOGGLE_POKEDEX_1
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_POKEDEX_2
	ld [wToggleableObjectIndex], a
	predef HideObject
	call OaksLabRivalFaceUpOakFaceDownScript
	ld a, TEXT_OAKSLAB_OAK_THAT_WAS_MY_DREAM
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_RIGHT
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	ld a, TEXT_OAKSLAB_RIVAL_LEAVE_IT_ALL_TO_ME
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	SetEvent EVENT_GOT_POKEDEX
	SetEvent EVENT_OAK_GOT_PARCEL
	ld a, TOGGLE_LYING_OLD_MAN
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_OLD_MAN
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, [wSavedNPCMovementDirections2Index]
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	xor a ; NPC_MOVEMENT_DOWN
	call FillMemory
	ld [hl], $ff
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	farcall Music_RivalAlternateStart
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_RIVAL_LEAVES_WITH_POKEDEX
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalLeavesWithPokedexScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	call PlayDefaultMusic
	ld a, TOGGLE_OAKS_LAB_RIVAL
	ld [wToggleableObjectIndex], a
	predef HideObject
	SetEvent EVENT_1ST_ROUTE22_RIVAL_BATTLE
	ResetEventReuseHL EVENT_2ND_ROUTE22_RIVAL_BATTLE
	SetEventReuseHL EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	ld a, TOGGLE_ROUTE_22_RIVAL_1
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, SCRIPT_PALLETTOWN_DAISY
	ld [wPalletTownCurScript], a
	xor a
	ld [wJoyIgnore], a

	ld a, SCRIPT_OAKSLAB_NOOP
	ld [wOaksLabCurScript], a
	ret

OaksLabNoopScript:
	ret

OaksLabScript_RemoveParcel:
	ld hl, wBagItems
	ld bc, 0
OaksLabScript_RemoveParcel.loop
	ld a, [hli]
	cp $ff
	ret z
	cp OAKS_PARCEL
	jr z, OaksLabScript_RemoveParcel.foundParcel
	inc hl
	inc c
	jr OaksLabScript_RemoveParcel.loop
OaksLabScript_RemoveParcel.foundParcel
	ld hl, wNumBagItems
	ld a, c
	ld [wWhichPokemon], a
	ld a, 1
	ld [wItemQuantity], a
	jp RemoveItemFromInventory

OaksLabCalcRivalMovementScript:
	ld a, $7c
	ldh [lobyte(hSpriteScreenYCoord)], a
	ld a, 8
	ldh [lobyte(hSpriteMapXCoord)], a
	ld a, [wYCoord]
	cp 3
	jr nz, OaksLabCalcRivalMovementScript.not_below_oak
	ld a, $4
	ld [wNPCMovementDirections2Index], a
	ld a, $30
	ld b, 11
	jr OaksLabCalcRivalMovementScript.done
OaksLabCalcRivalMovementScript.not_below_oak
	cp 1
	jr nz, OaksLabCalcRivalMovementScript.not_above_oak
	ld a, $2
	ld [wNPCMovementDirections2Index], a
	ld a, $30
	ld b, 9
	jr OaksLabCalcRivalMovementScript.done
OaksLabCalcRivalMovementScript.not_above_oak
	ld a, $3
	ld [wNPCMovementDirections2Index], a
	ld b, 10
	ld a, [wXCoord]
	cp 4
	jr nz, OaksLabCalcRivalMovementScript.not_left_of_oak
	ld a, $40
	jr OaksLabCalcRivalMovementScript.done
OaksLabCalcRivalMovementScript.not_left_of_oak
	ld a, $20
OaksLabCalcRivalMovementScript.done
	ldh [lobyte(hSpriteScreenXCoord)], a
	ld a, b
	ldh [lobyte(hSpriteMapYCoord)], a
	ld a, OAKSLAB_RIVAL
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ret

OaksLabLoadTextPointers2Script:
	ld hl, OaksLab_TextPointers2
	ld a, l
	ld [wCurMapTextPtr], a
	ld a, h
	ld [wCurMapTextPtr + 1], a
	ret

OaksLab_TextPointers:
	def_text_pointers
	dw_const OaksLabRivalText,                    TEXT_OAKSLAB_RIVAL
	dw_const OaksLabCharmanderPokeBallText,       TEXT_OAKSLAB_CHARMANDER_POKE_BALL
	dw_const OaksLabSquirtlePokeBallText,         TEXT_OAKSLAB_SQUIRTLE_POKE_BALL
	dw_const OaksLabBulbasaurPokeBallText,        TEXT_OAKSLAB_BULBASAUR_POKE_BALL
	dw_const OaksLabOak1Text,                     TEXT_OAKSLAB_OAK1
	dw_const OaksLabPokedexText,                  TEXT_OAKSLAB_POKEDEX1
	dw_const OaksLabPokedexText,                  TEXT_OAKSLAB_POKEDEX2
	dw_const OaksLabOak2Text,                     TEXT_OAKSLAB_OAK2
	dw_const OaksLabGirlText,                     TEXT_OAKSLAB_GIRL
	dw_const OaksLabScientistText,                TEXT_OAKSLAB_SCIENTIST1
	dw_const OaksLabScientistText,                TEXT_OAKSLAB_SCIENTIST2
	dw_const OaksLabOakDontGoAwayYetText,         TEXT_OAKSLAB_OAK_DONT_GO_AWAY_YET
	dw_const OaksLabRivalIllTakeThisOneText,      TEXT_OAKSLAB_RIVAL_ILL_TAKE_THIS_ONE
	dw_const OaksLabRivalReceivedMonText,         TEXT_OAKSLAB_RIVAL_RECEIVED_MON
	dw_const OaksLabRivalIllTakeYouOnText,        TEXT_OAKSLAB_RIVAL_ILL_TAKE_YOU_ON
	dw_const OaksLabRivalSmellYouLaterText,       TEXT_OAKSLAB_RIVAL_SMELL_YOU_LATER
	dw_const OaksLabRivalFedUpWithWaitingText,    TEXT_OAKSLAB_RIVAL_FED_UP_WITH_WAITING
	dw_const OaksLabOakChooseMonText,             TEXT_OAKSLAB_OAK_CHOOSE_MON
	dw_const OaksLabRivalWhatAboutMeText,         TEXT_OAKSLAB_RIVAL_WHAT_ABOUT_ME
	dw_const OaksLabOakBePatientText,             TEXT_OAKSLAB_OAK_BE_PATIENT
	dw_const OaksLabRivalGrampsText,              TEXT_OAKSLAB_RIVAL_GRAMPS
	dw_const OaksLabRivalWhatDidYouCallMeForText, TEXT_OAKSLAB_RIVAL_WHAT_DID_YOU_CALL_ME_FOR
	dw_const OaksLabOakIHaveARequestText,         TEXT_OAKSLAB_OAK_I_HAVE_A_REQUEST
	dw_const OaksLabOakMyInventionPokedexText,    TEXT_OAKSLAB_OAK_MY_INVENTION_POKEDEX
	dw_const OaksLabOakGotPokedexText,            TEXT_OAKSLAB_OAK_GOT_POKEDEX
	dw_const OaksLabOakThatWasMyDreamText,        TEXT_OAKSLAB_OAK_THAT_WAS_MY_DREAM
	dw_const OaksLabRivalLeaveItAllToMeText,      TEXT_OAKSLAB_RIVAL_LEAVE_IT_ALL_TO_ME

OaksLab_TextPointers2:
	.DW OaksLabRivalText
	.DW OaksLabCharmanderPokeBallText
	.DW OaksLabSquirtlePokeBallText
	.DW OaksLabBulbasaurPokeBallText
	.DW OaksLabOak1Text
	.DW OaksLabPokedexText
	.DW OaksLabPokedexText
	.DW OaksLabOak2Text
	.DW OaksLabGirlText
	.DW OaksLabScientistText
	.DW OaksLabScientistText

OaksLabRivalText:
	text_asm
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
	jr nz, OaksLabRivalText.beforeChooseMon
	ld hl, OaksLabRivalText.GrampsIsntAroundText
	call PrintText
	jr OaksLabRivalText.done
OaksLabRivalText.beforeChooseMon
	CheckEventReuseA EVENT_GOT_STARTER
	jr nz, OaksLabRivalText.afterChooseMon
	ld hl, OaksLabRivalText.GoAheadAndChooseText
	call PrintText
	jr OaksLabRivalText.done
OaksLabRivalText.afterChooseMon
	ld hl, OaksLabRivalText.MyPokemonLooksStrongerText
	call PrintText
OaksLabRivalText.done
	jp TextScriptEnd

OaksLabRivalText.GrampsIsntAroundText:
	text_far WLA_GLOBAL_OaksLabRivalGrampsIsntAroundText
	text_end

OaksLabRivalText.GoAheadAndChooseText:
	text_far WLA_GLOBAL_OaksLabRivalGoAheadAndChooseText
	text_end

OaksLabRivalText.MyPokemonLooksStrongerText:
	text_far WLA_GLOBAL_OaksLabRivalMyPokemonLooksStrongerText
	text_end

OaksLabCharmanderPokeBallText:
	text_asm
	ld a, STARTER2
	ld [wRivalStarterTemp], a
	ld a, OAKSLAB_SQUIRTLE_POKE_BALL
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER1
	ld b, OAKSLAB_CHARMANDER_POKE_BALL
	jr OaksLabSelectedPokeBallScript

OaksLabSquirtlePokeBallText:
	text_asm
	ld a, STARTER3
	ld [wRivalStarterTemp], a
	ld a, OAKSLAB_BULBASAUR_POKE_BALL
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER2
	ld b, OAKSLAB_SQUIRTLE_POKE_BALL
	jr OaksLabSelectedPokeBallScript

OaksLabBulbasaurPokeBallText:
	text_asm
	ld a, STARTER1
	ld [wRivalStarterTemp], a
	ld a, OAKSLAB_CHARMANDER_POKE_BALL
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER3
	ld b, OAKSLAB_BULBASAUR_POKE_BALL

OaksLabSelectedPokeBallScript:
	ld [wCurPartySpecies], a
	ld [wPokedexNum], a
	ld a, b
	ld [wSpriteIndex], a
	CheckEvent EVENT_GOT_STARTER
	jp nz, OaksLabLastMonScript
	CheckEventReuseA EVENT_OAK_ASKED_TO_CHOOSE_MON
	jr nz, OaksLabShowPokeBallPokemonScript
	ld hl, OaksLabThoseArePokeBallsText
	call PrintText
	jp TextScriptEnd

OaksLabThoseArePokeBallsText:
	text_far WLA_GLOBAL_OaksLabThoseArePokeBallsText
	text_end

OaksLabShowPokeBallPokemonScript:
	ld a, OAKSLAB_OAK1
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [lobyte(hSpriteDataOffset)], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_DOWN
	ld a, OAKSLAB_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [lobyte(hSpriteDataOffset)], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_RIGHT
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	predef StarterDex
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call ReloadMapData
	ld c, 10
	call DelayFrames
	ld a, [wSpriteIndex]
	cp OAKSLAB_CHARMANDER_POKE_BALL
	jr z, OaksLabYouWantCharmanderText
	cp OAKSLAB_SQUIRTLE_POKE_BALL
	jr z, OaksLabYouWantSquirtleText
	jr OaksLabYouWantBulbasaurText

OaksLabYouWantCharmanderText:
	ld hl, OaksLabYouWantCharmanderText.Text
	jr OaksLabMonChoiceMenu
OaksLabYouWantCharmanderText.Text:
	text_far WLA_GLOBAL_OaksLabYouWantCharmanderText
	text_end

OaksLabYouWantSquirtleText:
	ld hl, OaksLabYouWantSquirtleText.Text
	jr OaksLabMonChoiceMenu
OaksLabYouWantSquirtleText.Text:
	text_far WLA_GLOBAL_OaksLabYouWantSquirtleText
	text_end

OaksLabYouWantBulbasaurText:
	ld hl, OaksLabYouWantBulbasaurText.Text
	jr OaksLabMonChoiceMenu
OaksLabYouWantBulbasaurText.Text:
	text_far WLA_GLOBAL_OaksLabYouWantBulbasaurText
	text_end

OaksLabMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, OaksLabMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, [wSpriteIndex]
	cp OAKSLAB_CHARMANDER_POKE_BALL
	jr nz, OaksLabMonChoiceMenu.not_charmander
	ld a, TOGGLE_STARTER_BALL_1
	jr OaksLabMonChoiceMenu.continue
OaksLabMonChoiceMenu.not_charmander
	cp OAKSLAB_SQUIRTLE_POKE_BALL
	jr nz, OaksLabMonChoiceMenu.not_squirtle
	ld a, TOGGLE_STARTER_BALL_2
	jr OaksLabMonChoiceMenu.continue
OaksLabMonChoiceMenu.not_squirtle
	ld a, TOGGLE_STARTER_BALL_3
OaksLabMonChoiceMenu.continue
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLabMonEnergeticText
	call PrintText
	ld hl, OaksLabReceivedMonText
	call PrintText
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	ld a, 5
	ld [wCurEnemyLevel], a
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
	call AddPartyMon
	ld hl, wStatusFlags4
	set BIT_GOT_STARTER, [hl]
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_OAKSLAB_CHOSE_STARTER_SCRIPT
	ld [wOaksLabCurScript], a
OaksLabMonChoiceEnd:
	jp TextScriptEnd

OaksLabMonEnergeticText:
	text_far WLA_GLOBAL_OaksLabMonEnergeticText
	text_end

OaksLabReceivedMonText:
	text_far WLA_GLOBAL_OaksLabReceivedMonText
	sound_get_key_item
	text_end

OaksLabLastMonScript:
	ld a, OAKSLAB_OAK1
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [lobyte(hSpriteDataOffset)], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_DOWN
	ld hl, OaksLabLastMonText
	call PrintText
	jp TextScriptEnd

OaksLabLastMonText:
	text_far WLA_GLOBAL_OaksLabLastMonText
	text_end

OaksLabOak1Text:
	text_asm
	CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
	jr nz, OaksLabOak1Text.already_got_poke_balls
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 2
	jr c, OaksLabOak1Text.check_for_poke_balls
	CheckEvent EVENT_GOT_POKEDEX
	jr z, OaksLabOak1Text.check_for_poke_balls
OaksLabOak1Text.already_got_poke_balls
	ld hl, OaksLabOak1Text.HowIsYourPokedexComingText
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	predef DisplayDexRating
	jp OaksLabOak1Text.done
OaksLabOak1Text.check_for_poke_balls
	ld b, POKE_BALL
	call IsItemInBag
	jr nz, OaksLabOak1Text.come_see_me_sometimes
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	jr nz, OaksLabOak1Text.give_poke_balls
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, OaksLabOak1Text.mon_around_the_world
	CheckEventReuseA EVENT_BATTLED_RIVAL_IN_OAKS_LAB
	jr nz, OaksLabOak1Text.check_got_parcel
	ld a, [wStatusFlags4]
	bit BIT_GOT_STARTER, a
	jr nz, OaksLabOak1Text.already_got_pokemon
	ld hl, OaksLabOak1Text.WhichPokemonDoYouWantText
	call PrintText
	jr OaksLabOak1Text.done
OaksLabOak1Text.already_got_pokemon
	ld hl, OaksLabOak1Text.YourPokemonCanFightText
	call PrintText
	jr OaksLabOak1Text.done
OaksLabOak1Text.check_got_parcel
	ld b, OAKS_PARCEL
	call IsItemInBag
	jr nz, OaksLabOak1Text.got_parcel
	ld hl, OaksLabOak1Text.RaiseYourYoungPokemonText
	call PrintText
	jr OaksLabOak1Text.done
OaksLabOak1Text.got_parcel
	ld hl, OaksLabOak1Text.DeliverParcelText
	call PrintText
	call OaksLabScript_RemoveParcel
	ld a, SCRIPT_OAKSLAB_RIVAL_ARRIVES_AT_OAKS_REQUEST
	ld [wOaksLabCurScript], a
	jr OaksLabOak1Text.done
OaksLabOak1Text.mon_around_the_world
	ld hl, OaksLabOak1Text.PokemonAroundTheWorldText
	call PrintText
	jr OaksLabOak1Text.done
OaksLabOak1Text.give_poke_balls
	CheckAndSetEvent EVENT_GOT_POKEBALLS_FROM_OAK
	jr nz, OaksLabOak1Text.come_see_me_sometimes
	lb "bc", POKE_BALL, 5
	call GiveItem
	ld hl, OaksLabOak1Text.GivePokeballsText
	call PrintText
	jr OaksLabOak1Text.done
OaksLabOak1Text.come_see_me_sometimes
	ld hl, OaksLabOak1Text.ComeSeeMeSometimesText
	call PrintText
OaksLabOak1Text.done
	jp TextScriptEnd

OaksLabOak1Text.WhichPokemonDoYouWantText:
	text_far WLA_GLOBAL_OaksLabOak1WhichPokemonDoYouWantText
	text_end

OaksLabOak1Text.YourPokemonCanFightText:
	text_far WLA_GLOBAL_OaksLabOak1YourPokemonCanFightText
	text_end

OaksLabOak1Text.RaiseYourYoungPokemonText:
	text_far WLA_GLOBAL_OaksLabOak1RaiseYourYoungPokemonText
	text_end

OaksLabOak1Text.DeliverParcelText:
	text_far WLA_GLOBAL_OaksLabOak1DeliverParcelText
	sound_get_key_item
	text_far WLA_GLOBAL_OaksLabOak1ParcelThanksText
	text_end

OaksLabOak1Text.PokemonAroundTheWorldText:
	text_far WLA_GLOBAL_OaksLabOak1PokemonAroundTheWorldText
	text_end

OaksLabOak1Text.GivePokeballsText:
	text_far WLA_GLOBAL_OaksLabOak1ReceivedPokeballsText
	sound_get_key_item
	text_far WLA_GLOBAL_OaksLabGivePokeballsExplanationText
	text_end

OaksLabOak1Text.ComeSeeMeSometimesText:
	text_far WLA_GLOBAL_OaksLabOak1ComeSeeMeSometimesText
	text_end

OaksLabOak1Text.HowIsYourPokedexComingText:
	text_far WLA_GLOBAL_OaksLabOak1HowIsYourPokedexComingText
	text_end

OaksLabPokedexText:
	text_asm
	ld hl, OaksLabPokedexText.Text
	call PrintText
	jp TextScriptEnd

OaksLabPokedexText.Text:
	text_far WLA_GLOBAL_OaksLabPokedexText
	text_end

OaksLabOak2Text:
	text_far WLA_GLOBAL_OaksLabOak2Text
	text_end

OaksLabGirlText:
	text_asm
	ld hl, OaksLabGirlText.Text
	call PrintText
	jp TextScriptEnd

OaksLabGirlText.Text:
	text_far WLA_GLOBAL_OaksLabGirlText
	text_end

OaksLabRivalFedUpWithWaitingText:
	text_asm
	ld hl, OaksLabRivalFedUpWithWaitingText.Text
	call PrintText
	jp TextScriptEnd

OaksLabRivalFedUpWithWaitingText.Text:
	text_far WLA_GLOBAL_OaksLabRivalFedUpWithWaitingText
	text_end

OaksLabOakChooseMonText:
	text_asm
	ld hl, OaksLabOakChooseMonText.Text
	call PrintText
	jp TextScriptEnd

OaksLabOakChooseMonText.Text:
	text_far WLA_GLOBAL_OaksLabOakChooseMonText
	text_end

OaksLabRivalWhatAboutMeText:
	text_asm
	ld hl, OaksLabRivalWhatAboutMeText.Text
	call PrintText
	jp TextScriptEnd

OaksLabRivalWhatAboutMeText.Text:
	text_far WLA_GLOBAL_OaksLabRivalWhatAboutMeText
	text_end

OaksLabOakBePatientText:
	text_asm
	ld hl, OaksLabOakBePatientText.Text
	call PrintText
	jp TextScriptEnd

OaksLabOakBePatientText.Text:
	text_far WLA_GLOBAL_OaksLabOakBePatientText
	text_end

OaksLabOakDontGoAwayYetText:
	text_asm
	ld hl, OaksLabOakDontGoAwayYetText.Text
	call PrintText
	jp TextScriptEnd

OaksLabOakDontGoAwayYetText.Text:
	text_far WLA_GLOBAL_OaksLabOakDontGoAwayYetText
	text_end

OaksLabRivalIllTakeThisOneText:
	text_asm
	ld hl, OaksLabRivalIllTakeThisOneText.Text
	call PrintText
	jp TextScriptEnd

OaksLabRivalIllTakeThisOneText.Text:
	text_far WLA_GLOBAL_OaksLabRivalIllTakeThisOneText
	text_end

OaksLabRivalReceivedMonText:
	text_asm
	ld hl, OaksLabRivalReceivedMonText.Text
	call PrintText
	jp TextScriptEnd

OaksLabRivalReceivedMonText.Text:
	text_far WLA_GLOBAL_OaksLabRivalReceivedMonText
	sound_get_key_item
	text_end

OaksLabRivalIllTakeYouOnText:
	text_asm
	ld hl, OaksLabRivalIllTakeYouOnText.Text
	call PrintText
	jp TextScriptEnd

OaksLabRivalIllTakeYouOnText.Text:
	text_far WLA_GLOBAL_OaksLabRivalIllTakeYouOnText
	text_end

OaksLabRivalIPickedTheWrongPokemonText:
	text_far WLA_GLOBAL_OaksLabRivalIPickedTheWrongPokemonText
	text_end

OaksLabRivalAmIGreatOrWhatText:
	text_far WLA_GLOBAL_OaksLabRivalAmIGreatOrWhatText
	text_end

OaksLabRivalSmellYouLaterText:
	text_asm
	ld hl, OaksLabRivalSmellYouLaterText.Text
	call PrintText
	jp TextScriptEnd

OaksLabRivalSmellYouLaterText.Text:
	text_far WLA_GLOBAL_OaksLabRivalSmellYouLaterText
	text_end

OaksLabRivalGrampsText:
	text_far WLA_GLOBAL_OaksLabRivalGrampsText
	text_end

OaksLabRivalWhatDidYouCallMeForText:
	text_far WLA_GLOBAL_OaksLabRivalWhatDidYouCallMeForText
	text_end

OaksLabOakIHaveARequestText:
	text_far WLA_GLOBAL_OaksLabOakIHaveARequestText
	text_end

OaksLabOakMyInventionPokedexText:
	text_far WLA_GLOBAL_OaksLabOakMyInventionPokedexText
	text_end

OaksLabOakGotPokedexText:
	text_far WLA_GLOBAL_OaksLabOakGotPokedexText
	sound_get_key_item
	text_end

OaksLabOakThatWasMyDreamText:
	text_far WLA_GLOBAL_OaksLabOakThatWasMyDreamText
	text_end

OaksLabRivalLeaveItAllToMeText:
	text_far WLA_GLOBAL_OaksLabRivalLeaveItAllToMeText
	text_end

OaksLabScientistText:
	text_asm
	ld hl, OaksLabScientistText.Text
	call PrintText
	jp TextScriptEnd

OaksLabScientistText.Text:
	text_far WLA_GLOBAL_OaksLabScientistText
	text_end
