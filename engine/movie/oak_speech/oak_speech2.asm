ChoosePlayerName:
	call OakSpeechSlidePicRight
	ld de, DefaultNamesPlayer
	call DisplayIntroNameTextBox
	ld a, [wCurrentMenuItem]
	and a
	jr z, ChoosePlayerName.customName
	ld hl, DefaultNamesPlayerList
	call GetDefaultName
	ld de, wPlayerName
	call OakSpeechSlidePicLeft
	jr ChoosePlayerName.done
ChoosePlayerName.customName
	ld hl, wPlayerName
	xor a ; NAME_PLAYER_SCREEN
	ld [wNamingScreenType], a
	call DisplayNamingScreen
	ld a, [wStringBuffer]
	cp $50
	jr z, ChoosePlayerName.customName
	call ClearScreen
	call Delay3
	ld de, RedPicFront
	ld b, bank(RedPicFront)
	call IntroDisplayPicCenteredOrUpperRight
ChoosePlayerName.done
	ld hl, YourNameIsText
	jp PrintText

YourNameIsText:
	text_far WLA_GLOBAL_YourNameIsText
	text_end

ChooseRivalName:
	call OakSpeechSlidePicRight
	ld de, DefaultNamesRival
	call DisplayIntroNameTextBox
	ld a, [wCurrentMenuItem]
	and a
	jr z, ChooseRivalName.customName
	ld hl, DefaultNamesRivalList
	call GetDefaultName
	ld de, wRivalName
	call OakSpeechSlidePicLeft
	jr ChooseRivalName.done
ChooseRivalName.customName
	ld hl, wRivalName
	ld a, NAME_RIVAL_SCREEN
	ld [wNamingScreenType], a
	call DisplayNamingScreen
	ld a, [wStringBuffer]
	cp $50
	jr z, ChooseRivalName.customName
	call ClearScreen
	call Delay3
	ld de, Rival1Pic
	ld b, bank(Rival1Pic)
	call IntroDisplayPicCenteredOrUpperRight
ChooseRivalName.done
	ld hl, HisNameIsText
	jp PrintText

HisNameIsText:
	text_far WLA_GLOBAL_HisNameIsText
	text_end

OakSpeechSlidePicLeft:
	push de
	hlcoord 0, 0
	lb "bc", 12, 11
	call ClearScreenArea ; clear the name list text box
	ld c, 10
	call DelayFrames
	pop de
	ld hl, wNameBuffer
	ld bc, NAME_LENGTH
	call CopyData
	call Delay3
	hlcoord 12, 4
	lb "de", 6, 6 * SCREEN_WIDTH + 5
	ld a, $ff
	jr OakSpeechSlidePicCommon

OakSpeechSlidePicRight:
	hlcoord 5, 4
	lb "de", 6, 6 * SCREEN_WIDTH + 5
	xor a

OakSpeechSlidePicCommon:
	push hl
	push de
	push bc
	ldh [lobyte(hSlideDirection)], a
	ld a, d
	ldh [lobyte(hSlideAmount)], a
	ld a, e
	ldh [lobyte(hSlidingRegionSize)], a
	ld c, a
	ldh a, [lobyte(hSlideDirection)]
	and a
	jr nz, OakSpeechSlidePicCommon.next
; If sliding right, point hl to the end of the pic's tiles.
	ld d, 0
	add hl, de
OakSpeechSlidePicCommon.next
	ld d, h
	ld e, l
OakSpeechSlidePicCommon.loop
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ldh a, [lobyte(hSlideDirection)]
	and a
	jr nz, OakSpeechSlidePicCommon.slideLeft
; sliding right
	ld a, [hli]
	ld [hld], a
	dec hl
	jr OakSpeechSlidePicCommon.next2
OakSpeechSlidePicCommon.slideLeft
	ld a, [hld]
	ld [hli], a
	inc hl
OakSpeechSlidePicCommon.next2
	dec c
	jr nz, OakSpeechSlidePicCommon.loop
	ldh a, [lobyte(hSlideDirection)]
	and a
	jr z, OakSpeechSlidePicCommon.next3
; If sliding left, we need to zero the last tile in the pic (there is no need
; to take a corresponding action when sliding right because hl initially points
; to a 0 tile in that case).
	xor a
	dec hl
	ld [hl], a
OakSpeechSlidePicCommon.next3
	ld a, 1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call Delay3
	ldh a, [lobyte(hSlidingRegionSize)]
	ld c, a
	ld h, d
	ld l, e
	ldh a, [lobyte(hSlideDirection)]
	and a
	jr nz, OakSpeechSlidePicCommon.slideLeft2
	inc hl
	jr OakSpeechSlidePicCommon.next4
OakSpeechSlidePicCommon.slideLeft2
	dec hl
OakSpeechSlidePicCommon.next4
	ld d, h
	ld e, l
	ldh a, [lobyte(hSlideAmount)]
	dec a
	ldh [lobyte(hSlideAmount)], a
	jr nz, OakSpeechSlidePicCommon.loop
	pop bc
	pop de
	pop hl
	ret

DisplayIntroNameTextBox:
	push de
	hlcoord 0, 0
	ld b, $a
	ld c, $9
	call TextBoxBorder
	hlcoord 3, 0
	ld de, DisplayIntroNameTextBox.namestring
	call PlaceString
	pop de
	hlcoord 2, 2
	call PlaceString
	call UpdateSprites
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	inc a
	ld [wTopMenuItemX], a
	ld [wMenuWatchedKeys], a ; PAD_A
	inc a
	ld [wTopMenuItemY], a
	inc a
	ld [wMaxMenuItem], a
	jp HandleMenuInput

DisplayIntroNameTextBox.namestring
		.STRINGMAP pokemon, "NAME@"

.INCLUDE "data/player/names.asm"

GetDefaultName:
; a = name index
; hl = name list
	ld b, a
	ld c, 0
GetDefaultName.loop
	ld d, h
	ld e, l
GetDefaultName.innerLoop
	ld a, [hli]
	cp $50
	jr nz, GetDefaultName.innerLoop
	ld a, b
	cp c
	jr z, GetDefaultName.foundName
	inc c
	jr GetDefaultName.loop
GetDefaultName.foundName
	ld h, d
	ld l, e
	ld de, wNameBuffer
	ld bc, NAME_BUFFER_LENGTH
	jp CopyData

.INCLUDE "data/player/names_list.asm"

LinkMenuEmptyText:
	text_end
