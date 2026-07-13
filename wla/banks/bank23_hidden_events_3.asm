; Native WLA-DX form of engine/pokemon/set_types.asm, engine/events/hidden_events/reds_room.asm, engine/events/hidden_events/route_15_binoculars.asm, engine/events/hidden_events/museum_fossils.asm, engine/events/hidden_events/school_blackboard.asm, engine/events/hidden_events/vermilion_gym_trash.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"
; updates the types of a party mon (pointed to in hl) to the ones of the mon specified in [wPokedexNum]
SetPartyMonTypes:
	call GetPredefRegisters
	ld bc, MON_TYPE
	add hl, bc
	ld a, (wPokedexNum)
	ld (wCurSpecies), a
	push hl
	call GetMonHeader
	pop hl
	ld a, (wMonHType1)
	ld (HL+), a
	ld a, (wMonHType2)
	ld (hl), a
	ret
PrintRedSNESText:
	call EnableAutoTextBoxDrawing
	ld a, $04
	jp PrintPredefTextID

RedBedroomSNESText:
	.DB $17
	.DW $4f27
	.DB $22
	.DB $50

OpenRedsPC:
	call EnableAutoTextBoxDrawing
	ld a, $03
	jp PrintPredefTextID

RedBedroomPCText:
	.DB $fc
Route15GateLeftBinoculars:
	ld a, (wSpritePlayerStateData1FacingDirection)
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	ld a, $0a
	call PrintPredefTextID
	ld a, ARTICUNO
	ld (wCurPartySpecies), a
	call PlayCry
	jp DisplayMonFrontSpriteInBox

Route15UpstairsBinocularsText:
	.DB $17
	.DW $4f58
	.DB $22
	.DB $50
AerodactylFossil:
	ld a, FOSSIL_AERODACTYL
	ld (wCurPartySpecies), a
	call DisplayMonFrontSpriteInBox
	call EnableAutoTextBoxDrawing
	ld a, $09
	call PrintPredefTextID
	ret

AerodactylFossilText:
	.DB $17
	.DW $4fa7
	.DB $22
	.DB $50

KabutopsFossil:
	ld a, FOSSIL_KABUTOPS
	ld (wCurPartySpecies), a
	call DisplayMonFrontSpriteInBox
	call EnableAutoTextBoxDrawing
	ld a, $0b
	call PrintPredefTextID
	ret

KabutopsFossilText:
	.DB $17
	.DW $4fd5
	.DB $22
	.DB $50

DisplayMonFrontSpriteInBox:
; Displays a pokemon's front sprite in a pop-up window.
	ld a, 1
	ldh (hAutoBGTransferEnabled - $FF00), a
	call Delay3
	xor a
	ldh (hWY - $FF00), a
	call SaveScreenTilesToBuffer1
	ld a, MON_SPRITE_POPUP
	ld (wTextBoxID), a
	call DisplayTextBoxID
	call UpdateSprites
	ld a, (wCurPartySpecies)
	ld (wCurSpecies), a
	call GetMonHeader
	ld de, vChars1 + ($31) * 16
	call LoadMonFrontSprite
	ld a, $80
	ldh (hStartTileID - $FF00), a
	ld hl, wTileMap + (11 * 20) + 10
	ld a, $02
	call Predef
	call WaitForTextScrollButtonPress
	call LoadScreenTilesFromBuffer1
	call Delay3
	ld a, $90
	ldh (hWY - $FF00), a
	ret
PrintBlackboardLinkCableText:
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld (wDoNotWaitForButtonPressAfterDisplayingText), a
	ld a, (wHiddenEventFunctionArgument)
	call PrintPredefTextID
	ret

LinkCableHelp:
	.DB $08
	call SaveScreenTilesToBuffer1
	ld hl, LinkCableHelpText1
	call PrintText
	xor a
	ld (wMenuItemOffset), a ; not used
	ld (wCurrentMenuItem), a
	ld (wLastMenuItem), a
	ld a, PAD_A | PAD_B
	ld (wMenuWatchedKeys), a
	ld a, 3
	ld (wMaxMenuItem), a
	ld a, 2
	ld (wTopMenuItemY), a
	ld a, 1
	ld (wTopMenuItemX), a
LinkCableHelp.linkHelpLoop:
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, (hl)
	ld hl, wTileMap + (0 * 20) + 0
	ld b, 8
	ld c, 13
	call TextBoxBorder
	ld hl, wTileMap + (2 * 20) + 2
	ld de, HowToLinkText
	call PlaceString
	ld hl, LinkCableHelpText2
	call PrintText
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, LinkCableHelp.exit
	ld a, (wCurrentMenuItem)
	cp 3 ; pressed a on "STOP READING"
	jr z, LinkCableHelp.exit
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, (hl)
	ld hl, LinkCableInfoTexts
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, (HL+)
	ld h, (hl)
	ld l, a
	call PrintText
	jp LinkCableHelp.linkHelpLoop
LinkCableHelp.exit:
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, (hl)
	call LoadScreenTilesFromBuffer1
	jp TextScriptEnd

LinkCableHelpText1:
	.DB $17
	.DW $5001
	.DB $22
	.DB $50

LinkCableHelpText2:
	.DB $17
	.DW $5027
	.DB $22
	.DB $50

HowToLinkText:
	.STRINGMAP pokemon, "HOW TO LINK"
	.DB $4e
	.STRINGMAP pokemon, "COLOSSEUM"
	.DB $4e
	.STRINGMAP pokemon, "TRADE CENTER"
	.DB $4e
	.STRINGMAP pokemon, "STOP READING@"

LinkCableInfoTexts:
	.DW LinkCableInfoText1
	.DW LinkCableInfoText2
	.DW LinkCableInfoText3

LinkCableInfoText1:
	.DB $17
	.DW $504b
	.DB $22
	.DB $50

LinkCableInfoText2:
	.DB $17
	.DW $50bd
	.DB $22
	.DB $50

LinkCableInfoText3:
	.DB $17
	.DW $50e8
	.DB $22
	.DB $50

ViridianSchoolBlackboard:
	.DB $08
	call SaveScreenTilesToBuffer1
	ld hl, ViridianSchoolBlackboardText1
	call PrintText
	xor a
	ld (wMenuItemOffset), a
	ld (wCurrentMenuItem), a
	ld (wLastMenuItem), a
	ld a, PAD_LEFT | PAD_RIGHT | PAD_A | PAD_B
	ld (wMenuWatchedKeys), a
	ld a, 2
	ld (wMaxMenuItem), a
	ld a, 2
	ld (wTopMenuItemY), a
	ld a, 1
	ld (wTopMenuItemX), a
ViridianSchoolBlackboard.blackboardLoop:
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, (hl)
	ld hl, wTileMap + (0 * 20) + 0
	ld bc, ((6) << 8) | (10)
	call TextBoxBorder
	ld hl, wTileMap + (2 * 20) + 1
	ld de, StatusAilmentText1
	call PlaceString
	ld hl, wTileMap + (2 * 20) + 6
	ld de, StatusAilmentText2
	call PlaceString
	ld hl, ViridianSchoolBlackboardText2
	call PrintText
	call HandleMenuInput ; pressing up and down is handled in here
	bit B_PAD_B, a ; pressed b
	jr nz, ViridianSchoolBlackboard.exitBlackboard
	bit B_PAD_RIGHT, a
	jr z, ViridianSchoolBlackboard.didNotPressRight
	; move cursor to right column
	ld a, 2
	ld (wMaxMenuItem), a
	ld a, 2
	ld (wTopMenuItemY), a
	ld a, 6
	ld (wTopMenuItemX), a
	ld a, 3 ; in the the right column, use an offset to prevent overlap
	ld (wMenuItemOffset), a
	jr ViridianSchoolBlackboard.blackboardLoop
ViridianSchoolBlackboard.didNotPressRight:
	bit B_PAD_LEFT, a
	jr z, ViridianSchoolBlackboard.didNotPressLeftOrRight
	; move cursor to left column
	ld a, 2
	ld (wMaxMenuItem), a
	ld a, 2
	ld (wTopMenuItemY), a
	ld a, 1
	ld (wTopMenuItemX), a
	xor a
	ld (wMenuItemOffset), a
	jr ViridianSchoolBlackboard.blackboardLoop
ViridianSchoolBlackboard.didNotPressLeftOrRight:
	ld a, (wCurrentMenuItem)
	ld b, a
	ld a, (wMenuItemOffset)
	add b
	cp 5 ; cursor is pointing to "QUIT"
	jr z, ViridianSchoolBlackboard.exitBlackboard
	; we must have pressed a on a status condition
	; so print the text
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, (hl)
	ld hl, ViridianBlackboardStatusPointers
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, (HL+)
	ld h, (hl)
	ld l, a
	call PrintText
	jp ViridianSchoolBlackboard.blackboardLoop
ViridianSchoolBlackboard.exitBlackboard:
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, (hl)
	call LoadScreenTilesFromBuffer1
	jp TextScriptEnd

ViridianSchoolBlackboardText1:
	.DB $17
	.DW $5110
	.DB $22
	.DB $50

ViridianSchoolBlackboardText2:
	.DB $17
	.DW $514e
	.DB $22
	.DB $50

StatusAilmentText1:
	.STRINGMAP pokemon, " SLP"
	.DB $4e
	.STRINGMAP pokemon, " PSN"
	.DB $4e
	.STRINGMAP pokemon, " PAR@"

StatusAilmentText2:
	.STRINGMAP pokemon, " BRN"
	.DB $4e
	.STRINGMAP pokemon, " FRZ"
	.DB $4e
	.STRINGMAP pokemon, " QUIT@"

	.STRINGMAP pokemon, "@" ; unused

ViridianBlackboardStatusPointers:
	.DW ViridianBlackboardSleepText
	.DW ViridianBlackboardPoisonText
	.DW ViridianBlackboardPrlzText
	.DW ViridianBlackboardBurnText
	.DW ViridianBlackboardFrozenText

ViridianBlackboardSleepText:
	.DB $17
	.DW $5172
	.DB $22
	.DB $50

ViridianBlackboardPoisonText:
	.DB $17
	.DW $51de
	.DB $22
	.DB $50

ViridianBlackboardPrlzText:
	.DB $17
	.DW $524b
	.DB $22
	.DB $50

ViridianBlackboardBurnText:
	.DB $17
	.DW $52b5
	.DB $22
	.DB $50

ViridianBlackboardFrozenText:
	.DB $17
	.DW $532f
	.DB $22
	.DB $50
PrintTrashText:
	call EnableAutoTextBoxDrawing
	ld a, $26
	jp PrintPredefTextID

VermilionGymTrashText:
	.DB $17
	.DW $53a7
	.DB $22
	.DB $50

GymTrashScript:
	call EnableAutoTextBoxDrawing
	ld a, (wHiddenEventFunctionArgument)
	ld (wGymTrashCanIndex), a

; Don't do the trash can puzzle if it's already been done.
	ld a, (wEventFlags + (EVENT_2ND_LOCK_OPENED / 8))
	bit EVENT_2ND_LOCK_OPENED & 7, a
	jr z, GymTrashScript.ok

	ld a, $26
	jp PrintPredefTextID

GymTrashScript.ok:
	bit EVENT_1ST_LOCK_OPENED & 7, a
	jr nz, GymTrashScript.trySecondLock

	ld a, (wFirstLockTrashCanIndex)
	ld b, a
	ld a, (wGymTrashCanIndex)
	cp b
	jr z, GymTrashScript.openFirstLock

	ld a, $26
	jr GymTrashScript.done

GymTrashScript.openFirstLock:
; Next can is trying for the second switch.
	ld hl, wEventFlags + (EVENT_1ST_LOCK_OPENED / 8)
	set EVENT_1ST_LOCK_OPENED & 7, (hl)

	ld hl, GymTrashCans
	ld a, (wGymTrashCanIndex)
	; * 5
	ld b, a
	add a
	add a
	add b

	ld d, 0
	ld e, a
	add hl, de
	ld a, (HL+)

; Bug: This code should calculate a value in the range [0, 3],
; but if the mask and random number don't have any 1 bits in common, then
; the result of the AND will be 0. When 1 is subtracted from that, the value
; will become $ff. This will result in 255 being added to hl, which will cause
; hl to point to one of the zero bytes that pad the end of the ROM bank.
; Trash can 0 was intended to be able to have the second lock only when the
; first lock was in trash can 1 or 3. However, due to this bug, trash can 0 can
; have the second lock regardless of which trash can had the first lock.

	ldh (hGymTrashCanRandNumMask - $FF00), a
	push hl
	call Random
	swap a
	ld b, a
	ldh a, (hGymTrashCanRandNumMask - $FF00)
	and b
	dec a
	pop hl

	ld d, 0
	ld e, a
	add hl, de
	ld a, (hl)
	and $f
	ld (wSecondLockTrashCanIndex), a

	ld a, $3b
	jr GymTrashScript.done

GymTrashScript.trySecondLock:
	ld a, (wSecondLockTrashCanIndex)
	ld b, a
	ld a, (wGymTrashCanIndex)
	cp b
	jr z, GymTrashScript.openSecondLock

; Reset the cans.
	ld hl, wEventFlags + (EVENT_1ST_LOCK_OPENED / 8)
	res EVENT_1ST_LOCK_OPENED & 7, (hl)
	call Random

	and $e
	ld (wFirstLockTrashCanIndex), a

	ld a, $3e
	jr GymTrashScript.done

GymTrashScript.openSecondLock:
; Completed the trash can puzzle.
	ld hl, wEventFlags + (EVENT_2ND_LOCK_OPENED / 8)
	set EVENT_2ND_LOCK_OPENED & 7, (hl)
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_2, (hl)

	ld a, $3d

GymTrashScript.done:
	jp PrintPredefTextID

GymTrashCans:
; byte 0: mask for random number
; bytes 1-4: indices of the trash cans that can have the second lock
;            (but see the comment above explaining a bug regarding this)
; Note that the mask is simply the number of valid trash can indices that
; follow. The remaining bytes are filled with 0 to pad the length of each entry
; to 5 bytes.
	.DB 2,  1,  3,  0,  0 ; 0
	.DB 3,  0,  2,  4,  0 ; 1
	.DB 2,  1,  5,  0,  0 ; 2
	.DB 3,  0,  4,  6,  0 ; 3
	.DB 4,  1,  3,  5,  7 ; 4
	.DB 3,  2,  4,  8,  0 ; 5
	.DB 3,  3,  7,  9,  0 ; 6
	.DB 4,  4,  6,  8, 10 ; 7
	.DB 3,  5,  7, 11,  0 ; 8
	.DB 3,  6, 10, 12,  0 ; 9
	.DB 4,  7,  9, 11, 13 ; 10
	.DB 3,  8, 10, 14,  0 ; 11
	.DB 2,  9, 13,  0,  0 ; 12
	.DB 3, 10, 12, 14,  0 ; 13
	.DB 2, 11, 13,  0,  0 ; 14

VermilionGymTrashSuccessText1:
	.DB $17
	.DW $53c6
	.DB $22
	.DB $08
	call WaitForSoundToFinish
	ld a, SFX_SWITCH
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

; unused
VermilionGymTrashSuccessText2:
	.DB $17
	.DW $5418
	.DB $22
	.DB $50

; unused
VermilionGymTrashSuccessPlaySfx:
	.DB $08
	call WaitForSoundToFinish
	ld a, SFX_SWITCH
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

VermilionGymTrashSuccessText3:
	.DB $17
	.DW $5451
	.DB $22
	.DB $08
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

VermilionGymTrashFailText:
	.DB $17
	.DW $548c
	.DB $22
	.DB $08
	call WaitForSoundToFinish
	ld a, SFX_DENIED
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd
HiddenEvents3End:
