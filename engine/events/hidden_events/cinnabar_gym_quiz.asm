PrintCinnabarQuiz:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre_jump CinnabarGymQuiz

CinnabarGymQuiz:
	text_asm
	xor a
	ld [wOpponentAfterWrongAnswer], a
	ld a, [wHiddenEventFunctionArgument]
	push af
	and $f
	ldh [lobyte(hGymGateIndex)], a
	pop af
	and $f0
	swap a
	ldh [lobyte(hGymGateAnswer)], a
	ld hl, CinnabarGymQuizIntroText
	call PrintText
	ldh a, [lobyte(hGymGateIndex)]
	dec a
	add a
	ld d, 0
	ld e, a
	ld hl, CinnabarQuizQuestions
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call CinnabarGymQuiz_AskQuestion
	jp TextScriptEnd

CinnabarGymQuizIntroText:
	text_far WLA_GLOBAL_CinnabarGymQuizIntroText
	text_end

CinnabarQuizQuestions:
	.DW CinnabarQuizQuestionsText1
	.DW CinnabarQuizQuestionsText2
	.DW CinnabarQuizQuestionsText3
	.DW CinnabarQuizQuestionsText4
	.DW CinnabarQuizQuestionsText5
	.DW CinnabarQuizQuestionsText6

CinnabarQuizQuestionsText1:
	text_far WLA_GLOBAL_CinnabarQuizQuestionsText1
	text_end

CinnabarQuizQuestionsText2:
	text_far WLA_GLOBAL_CinnabarQuizQuestionsText2
	text_end

CinnabarQuizQuestionsText3:
	text_far WLA_GLOBAL_CinnabarQuizQuestionsText3
	text_end

CinnabarQuizQuestionsText4:
	text_far WLA_GLOBAL_CinnabarQuizQuestionsText4
	text_end

CinnabarQuizQuestionsText5:
	text_far WLA_GLOBAL_CinnabarQuizQuestionsText5
	text_end

CinnabarQuizQuestionsText6:
	text_far WLA_GLOBAL_CinnabarQuizQuestionsText6
	text_end

CinnabarGymGateFlagAction:
	EventFlagAddress "hl", EVENT_CINNABAR_GYM_GATE0_UNLOCKED
	predef_jump FlagActionPredef

CinnabarGymQuiz_AskQuestion:
	call YesNoChoice
	ldh a, [lobyte(hGymGateAnswer)]
	ld c, a
	ld a, [wCurrentMenuItem]
	cp c
	jr nz, CinnabarGymQuiz_AskQuestion.wrongAnswer
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	ldh a, [lobyte(hGymGateIndex)]
	ldh [lobyte(hBackupGymGateIndex)], a
	ld hl, CinnabarGymQuizCorrectText
	call PrintText
	ldh a, [lobyte(hBackupGymGateIndex)]
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_SET
	call CinnabarGymGateFlagAction
	jp UpdateCinnabarGymGateTileBlocks_
CinnabarGymQuiz_AskQuestion.wrongAnswer
	call WaitForSoundToFinish
	ld a, SFX_DENIED
	call PlaySound
	call WaitForSoundToFinish
	ld hl, CinnabarGymQuizIncorrectText
	call PrintText
	ldh a, [lobyte(hGymGateIndex)]
	add $2
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_TEST
	EventFlagAddress "hl", EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	predef FlagActionPredef
	ld a, c
	and a
	ret nz
	ldh a, [lobyte(hGymGateIndex)]
	add $2
	ld [wOpponentAfterWrongAnswer], a
	ret

CinnabarGymQuizCorrectText:
	sound_get_item_1
	text_far WLA_GLOBAL_CinnabarGymQuizCorrectText
	text_promptbutton
	text_asm

	ldh a, [lobyte(hBackupGymGateIndex)]
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_TEST
	call CinnabarGymGateFlagAction
	ld a, c
	and a
	jp nz, TextScriptEnd
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

CinnabarGymQuizIncorrectText:
	text_far WLA_GLOBAL_CinnabarGymQuizIncorrectText
	text_end

UpdateCinnabarGymGateTileBlocks_:
; Update the overworld map with open floor blocks or locked gate blocks
; depending on event flags.
	ld a, 6
	ldh [lobyte(hGymGateIndex)], a
UpdateCinnabarGymGateTileBlocks_.loop
	ldh a, [lobyte(hGymGateIndex)]
	dec a
	add a
	add a
	ld d, 0
	ld e, a
	ld hl, CinnabarGymGateCoords
	add hl, de
	ld a, [hli]
	ld b, [hl]
	ld c, a
	inc hl
	ld a, [hl]
	ld [wGymGateTileBlock], a
	push bc
	ldh a, [lobyte(hGymGateIndex)]
	ldh [lobyte(hBackupGymGateIndex)], a
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_TEST
	call CinnabarGymGateFlagAction
	ld a, c
	and a
	jr nz, UpdateCinnabarGymGateTileBlocks_.unlocked
	ld a, [wGymGateTileBlock]
	jr UpdateCinnabarGymGateTileBlocks_.next
UpdateCinnabarGymGateTileBlocks_.unlocked
	ld a, $e
UpdateCinnabarGymGateTileBlocks_.next
	pop bc
	ld [wNewTileBlockID], a
	predef ReplaceTileBlock
	ld hl, hGymGateIndex
	dec [hl]
	jr nz, UpdateCinnabarGymGateTileBlocks_.loop
	ret

.MACRO gym_gate_coord
	.DB \1, \2, \3, 0
.ENDM

.DEFINE HORIZONTAL_GATE_BLOCK $54
.DEFINE VERTICAL_GATE_BLOCK $5f

CinnabarGymGateCoords:
	; x coord, y coord, block id
	gym_gate_coord 9, 3, HORIZONTAL_GATE_BLOCK
	gym_gate_coord 6, 3, HORIZONTAL_GATE_BLOCK
	gym_gate_coord 6, 6, HORIZONTAL_GATE_BLOCK
	gym_gate_coord 3, 8, VERTICAL_GATE_BLOCK
	gym_gate_coord 2, 6, HORIZONTAL_GATE_BLOCK
	gym_gate_coord 2, 3, HORIZONTAL_GATE_BLOCK
