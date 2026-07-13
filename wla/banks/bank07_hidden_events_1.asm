; Native WLA-DX form of engine/menus/oaks_pc.asm, engine/events/hidden_events/new_bike.asm, engine/events/hidden_events/oaks_lab_posters.asm, engine/events/hidden_events/safari_game.asm, engine/events/hidden_events/cinnabar_gym_quiz.asm, engine/events/hidden_events/magazines.asm, engine/events/hidden_events/bills_house_pc.asm, engine/events/hidden_events/oaks_lab_email.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"
OpenOaksPC:
	call SaveScreenTilesToBuffer2
	ld hl, AccessedOaksPCText
	call PrintText
	ld hl, GetDexRatedText
	call PrintText
	call YesNoChoice
	ld a, (wCurrentMenuItem)
	and a
	jr nz, OpenOaksPC.closePC
	ld a, $56
	call Predef
OpenOaksPC.closePC:
	ld hl, ClosedOaksPCText
	call PrintText
	jp LoadScreenTilesFromBuffer2

GetDexRatedText:
	.DB $17
	.DW $635d
	.DB $22
	.DB $50

ClosedOaksPCText:
	.DB $17
	.DW $637b
	.DB $22
	.DB $0d
	.DB $50

AccessedOaksPCText:
	.DB $17
	.DW $639a
	.DB $22
	.DB $50
PrintNewBikeText:
	call EnableAutoTextBoxDrawing
	ld a, $39
	jp PrintPredefTextID

NewBicycleText:
	.DB $17
	.DW $46e6
	.DB $22
	.DB $50
DisplayOakLabLeftPoster:
	call EnableAutoTextBoxDrawing
	ld a, $05
	jp PrintPredefTextID

PushStartText:
	.DB $17
	.DW $46fc
	.DB $22
	.DB $50

DisplayOakLabRightPoster:
	call EnableAutoTextBoxDrawing
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, (wNumSetBits)
	cp 2
	ld a, $06
	jr c, DisplayOakLabRightPoster.ownLessThanTwo
	; own two or more mon
	ld a, $07
DisplayOakLabRightPoster.ownLessThanTwo:
	jp PrintPredefTextID

SaveOptionText:
	.DB $17
	.DW $471a
	.DB $22
	.DB $50

StrengthsAndWeaknessesText:
	.DB $17
	.DW $4742
	.DB $22
	.DB $50
SafariZoneCheck:
	ld hl, wEventFlags + (EVENT_IN_SAFARI_ZONE / 8)
	bit EVENT_IN_SAFARI_ZONE & 7, (hl) ; if we are not in the Safari Zone,
	jr z, SafariZoneGameStillGoing ; don't bother printing game over text
	ld a, (wNumSafariBalls)
	and a
	jr z, SafariZoneGameOver
	jr SafariZoneGameStillGoing

SafariZoneCheckSteps:
	ld a, (wSafariSteps)
	ld b, a
	ld a, (wSafariSteps + 1)
	ld c, a
	or b
	jr z, SafariZoneGameOver
	dec bc
	ld a, b
	ld (wSafariSteps), a
	ld a, c
	ld (wSafariSteps + 1), a
SafariZoneGameStillGoing:
	xor a
	ld (wSafariZoneGameOver), a
	ret

SafariZoneGameOver:
	call EnableAutoTextBoxDrawing
	xor a
	ld (wAudioFadeOutControl), a
	dec a ; SFX_STOP_ALL_MUSIC
	call PlaySound
	ld c, $02
	ld a, SFX_SAFARI_ZONE_PA
	call PlayMusic
SafariZoneGameOver.waitForMusicToPlay:
	ld a, (wChannelSoundIDs + CHAN5)
	cp SFX_SAFARI_ZONE_PA
	jr nz, SafariZoneGameOver.waitForMusicToPlay
	ld a, TEXT_SAFARI_GAME_OVER
	ldh (hTextID - $FF00), a
	call DisplayTextID
	xor a
	ld (wPlayerMovingDirection), a
	ld a, SAFARI_ZONE_GATE
	ldh (hWarpDestinationMap - $FF00), a
	ld a, $3
	ld (wDestinationWarpID), a
	ld a, SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI
	ld (wSafariZoneGateCurScript), a
	ld hl, wEventFlags + (EVENT_SAFARI_GAME_OVER / 8)
	set EVENT_SAFARI_GAME_OVER & 7, (hl)
	ld a, 1
	ld (wSafariZoneGameOver), a
	ret

PrintSafariGameOverText:
	xor a
	ld (wJoyIgnore), a
	ld hl, SafariGameOverText
	jp PrintText

SafariGameOverText:
	.DB $08
	ld a, (wNumSafariBalls)
	and a
	jr z, SafariGameOverText.noMoreSafariBalls
	ld hl, TimesUpText
	call PrintText
SafariGameOverText.noMoreSafariBalls:
	ld hl, GameOverText
	call PrintText
	jp TextScriptEnd

TimesUpText:
	.DB $17
	.DW $477e
	.DB $22
	.DB $50

GameOverText:
	.DB $17
	.DW $4798
	.DB $22
	.DB $50
PrintCinnabarQuiz:
	ld a, (wSpritePlayerStateData1FacingDirection)
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	ld a, $31
	jp PrintPredefTextID

CinnabarGymQuiz:
	.DB $08
	xor a
	ld (wOpponentAfterWrongAnswer), a
	ld a, (wHiddenEventFunctionArgument)
	push af
	and $f
	ldh (hGymGateIndex - $FF00), a
	pop af
	and $f0
	swap a
	ldh (hGymGateAnswer - $FF00), a
	ld hl, CinnabarGymQuizIntroText
	call PrintText
	ldh a, (hGymGateIndex - $FF00)
	dec a
	add a
	ld d, 0
	ld e, a
	ld hl, CinnabarQuizQuestions
	add hl, de
	ld a, (HL+)
	ld h, (hl)
	ld l, a
	call PrintText
	ld a, 1
	ld (wDoNotWaitForButtonPressAfterDisplayingText), a
	call CinnabarGymQuiz_AskQuestion
	jp TextScriptEnd

CinnabarGymQuizIntroText:
	.DB $17
	.DW $47b7
	.DB $22
	.DB $50

CinnabarQuizQuestions:
	.DW CinnabarQuizQuestionsText1
	.DW CinnabarQuizQuestionsText2
	.DW CinnabarQuizQuestionsText3
	.DW CinnabarQuizQuestionsText4
	.DW CinnabarQuizQuestionsText5
	.DW CinnabarQuizQuestionsText6

CinnabarQuizQuestionsText1:
	.DB $17
	.DW $486d
	.DB $22
	.DB $50

CinnabarQuizQuestionsText2:
	.DB $17
	.DW $4890
	.DB $22
	.DB $50

CinnabarQuizQuestionsText3:
	.DB $17
	.DW $48bb
	.DB $22
	.DB $50

CinnabarQuizQuestionsText4:
	.DB $17
	.DW $48d5
	.DB $22
	.DB $50

CinnabarQuizQuestionsText5:
	.DB $17
	.DW $4915
	.DB $22
	.DB $50

CinnabarQuizQuestionsText6:
	.DB $17
	.DW $4949
	.DB $22
	.DB $50

CinnabarGymGateFlagAction:
	ld hl, wEventFlags + (EVENT_CINNABAR_GYM_GATE0_UNLOCKED / 8)
	ld a, $10
	jp Predef

CinnabarGymQuiz_AskQuestion:
	call YesNoChoice
	ldh a, (hGymGateAnswer - $FF00)
	ld c, a
	ld a, (wCurrentMenuItem)
	cp c
	jr nz, CinnabarGymQuiz_AskQuestion.wrongAnswer
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, (hl)
	ldh a, (hGymGateIndex - $FF00)
	ldh (hBackupGymGateIndex - $FF00), a
	ld hl, CinnabarGymQuizCorrectText
	call PrintText
	ldh a, (hBackupGymGateIndex - $FF00)
; AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0 (no adjustment)
	ld c, a
	ld b, FLAG_SET
	call CinnabarGymGateFlagAction
	jp UpdateCinnabarGymGateTileBlocks_
CinnabarGymQuiz_AskQuestion.wrongAnswer:
	call WaitForSoundToFinish
	ld a, SFX_DENIED
	call PlaySound
	call WaitForSoundToFinish
	ld hl, CinnabarGymQuizIncorrectText
	call PrintText
	ldh a, (hGymGateIndex - $FF00)
	add $2
; AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2 (no adjustment)
	ld c, a
	ld b, FLAG_TEST
	ld hl, wEventFlags + (EVENT_BEAT_CINNABAR_GYM_TRAINER_0 / 8)
	ld a, $10
	call Predef
	ld a, c
	and a
	ret nz
	ldh a, (hGymGateIndex - $FF00)
	add $2
	ld (wOpponentAfterWrongAnswer), a
	ret

CinnabarGymQuizCorrectText:
	.DB $0b
	.DB $17
	.DW $4964
	.DB $22
	.DB $06
	.DB $08

	ldh a, (hBackupGymGateIndex - $FF00)
; AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0 (no adjustment)
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
	.DB $17
	.DW $498f
	.DB $22
	.DB $50

UpdateCinnabarGymGateTileBlocks_:
; Update the overworld map with open floor blocks or locked gate blocks
; depending on event flags.
	ld a, 6
	ldh (hGymGateIndex - $FF00), a
UpdateCinnabarGymGateTileBlocks_.loop:
	ldh a, (hGymGateIndex - $FF00)
	dec a
	add a
	add a
	ld d, 0
	ld e, a
	ld hl, CinnabarGymGateCoords
	add hl, de
	ld a, (HL+)
	ld b, (hl)
	ld c, a
	inc hl
	ld a, (hl)
	ld (wGymGateTileBlock), a
	push bc
	ldh a, (hGymGateIndex - $FF00)
	ldh (hBackupGymGateIndex - $FF00), a
; AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0 (no adjustment)
	ld c, a
	ld b, FLAG_TEST
	call CinnabarGymGateFlagAction
	ld a, c
	and a
	jr nz, UpdateCinnabarGymGateTileBlocks_.unlocked
	ld a, (wGymGateTileBlock)
	jr UpdateCinnabarGymGateTileBlocks_.next
UpdateCinnabarGymGateTileBlocks_.unlocked:
	ld a, $e
UpdateCinnabarGymGateTileBlocks_.next:
	pop bc
	ld (wNewTileBlockID), a
	ld a, $17
	call Predef
	ld hl, hGymGateIndex
	dec (hl)
	jr nz, UpdateCinnabarGymGateTileBlocks_.loop
	ret


.DEFINE HORIZONTAL_GATE_BLOCK $54
.DEFINE VERTICAL_GATE_BLOCK $5f

CinnabarGymGateCoords:
	; x coord, y coord, block id
	.DB 9, 3, HORIZONTAL_GATE_BLOCK, 0
	.DB 6, 3, HORIZONTAL_GATE_BLOCK, 0
	.DB 6, 6, HORIZONTAL_GATE_BLOCK, 0
	.DB 3, 8, VERTICAL_GATE_BLOCK, 0
	.DB 2, 6, HORIZONTAL_GATE_BLOCK, 0
	.DB 2, 3, HORIZONTAL_GATE_BLOCK, 0
PrintMagazinesText:
	call EnableAutoTextBoxDrawing
	ld a, $30
	call PrintPredefTextID
	ret

MagazinesText:
	.DB $17
	.DW $49a1
	.DB $22
	.DB $50
BillsHousePC:
	call EnableAutoTextBoxDrawing
	ld a, (wSpritePlayerStateData1FacingDirection)
	cp SPRITE_FACING_UP
	ret nz
	ld a, (wEventFlags + (EVENT_LEFT_BILLS_HOUSE_AFTER_HELPING / 8))
	bit EVENT_LEFT_BILLS_HOUSE_AFTER_HELPING & 7, a
	jr nz, BillsHousePC.displayBillsHousePokemonList
	bit EVENT_USED_CELL_SEPARATOR_ON_BILL & 7, a
	jr nz, BillsHousePC.displayBillsHouseMonitorText
	bit EVENT_BILL_SAID_USE_CELL_SEPARATOR & 7, a
	jr nz, BillsHousePC.doCellSeparator
BillsHousePC.displayBillsHouseMonitorText:
	ld a, $2d
	jp PrintPredefTextID
BillsHousePC.doCellSeparator:
	ld a, $1
	ld (wDoNotWaitForButtonPressAfterDisplayingText), a
	ld a, $2e
	call PrintPredefTextID
	ld c, 32
	call DelayFrames
	ld a, SFX_TINK
	call PlaySound
	call WaitForSoundToFinish
	ld c, 80
	call DelayFrames
	ld a, SFX_SHRINK
	call PlaySound
	call WaitForSoundToFinish
	ld c, 48
	call DelayFrames
	ld a, SFX_TINK
	call PlaySound
	call WaitForSoundToFinish
	ld c, 32
	call DelayFrames
	ld a, SFX_GET_ITEM_1
	call PlaySound
	call WaitForSoundToFinish
	call PlayDefaultMusic
	ld hl, wEventFlags + (EVENT_USED_CELL_SEPARATOR_ON_BILL / 8)
	set EVENT_USED_CELL_SEPARATOR_ON_BILL & 7, (hl)
	ret
BillsHousePC.displayBillsHousePokemonList:
	ld a, $1
	ld (wDoNotWaitForButtonPressAfterDisplayingText), a
	ld a, $2f
	call PrintPredefTextID
	ret

BillsHouseMonitorText:
	.DB $17
	.DW $49cf
	.DB $22
	.DB $50

BillsHouseInitiatedText:
	.DB $17
	.DW $49fb
	.DB $22
	.DB $06
	.DB $08
	ld a, SFX_STOP_ALL_MUSIC
	ld (wNewSoundID), a
	call PlaySound
	ld c, 16
	call DelayFrames
	ld a, SFX_SWITCH
	call PlaySound
	call WaitForSoundToFinish
	ld c, 60
	call DelayFrames
	jp TextScriptEnd

BillsHousePokemonList:
	.DB $08
	call SaveScreenTilesToBuffer1
	ld hl, BillsHousePokemonListText1
	call PrintText
	xor a
	ld (wMenuItemOffset), a ; not used
	ld (wCurrentMenuItem), a
	ld (wLastMenuItem), a
	ld a, PAD_A | PAD_B
	ld (wMenuWatchedKeys), a
	ld a, 4
	ld (wMaxMenuItem), a
	ld a, 2
	ld (wTopMenuItemY), a
	ld a, 1
	ld (wTopMenuItemX), a
BillsHousePokemonList.billsPokemonLoop:
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, (hl)
	ld hl, wTileMap + (0 * 20) + 0
	ld b, 10
	ld c, 9
	call TextBoxBorder
	ld hl, wTileMap + (2 * 20) + 2
	ld de, BillsMonListText
	call PlaceString
	ld hl, BillsHousePokemonListText2
	call PrintText
	call SaveScreenTilesToBuffer2
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, BillsHousePokemonList.cancel
	ld a, (wCurrentMenuItem)
	add EEVEE
	cp EEVEE
	jr z, BillsHousePokemonList.displayPokedex
	cp FLAREON
	jr z, BillsHousePokemonList.displayPokedex
	cp JOLTEON
	jr z, BillsHousePokemonList.displayPokedex
	cp VAPOREON
	jr z, BillsHousePokemonList.displayPokedex
	jr BillsHousePokemonList.cancel
BillsHousePokemonList.displayPokedex:
	call DisplayPokedex
	call LoadScreenTilesFromBuffer2
	jr BillsHousePokemonList.billsPokemonLoop
BillsHousePokemonList.cancel:
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, (hl)
	call LoadScreenTilesFromBuffer2
	jp TextScriptEnd

BillsHousePokemonListText1:
	.DB $17
	.DW $4a25
	.DB $22
	.DB $50

BillsMonListText:
	.STRINGMAP pokemon, "EEVEE"
	.DB $4e
	.STRINGMAP pokemon, "FLAREON"
	.DB $4e
	.STRINGMAP pokemon, "JOLTEON"
	.DB $4e
	.STRINGMAP pokemon, "VAPOREON"
	.DB $4e
	.STRINGMAP pokemon, "CANCEL@"

BillsHousePokemonListText2:
	.DB $17
	.DW $4a40
	.DB $22
	.DB $50
DisplayOakLabEmailText:
	ld a, (wSpritePlayerStateData1FacingDirection)
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	ld a, $08
	jp PrintPredefTextID

OakLabEmailText:
	.DB $17
	.DW $4a60
	.DB $22
	.DB $50
HiddenEvents1End:
