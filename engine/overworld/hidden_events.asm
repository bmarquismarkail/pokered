IsPlayerOnDungeonWarp:
	xor a
	ld [wWhichDungeonWarp], a
	ld a, [wStatusFlags3]
	bit BIT_ON_DUNGEON_WARP, a
	ret nz
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wCoordIndex]
	ld [wWhichDungeonWarp], a
	ld hl, wStatusFlags3
	set BIT_ON_DUNGEON_WARP, [hl]
	ld hl, wStatusFlags6
	set BIT_DUNGEON_WARP, [hl]
	ret

; if a hidden event was found, stores $00 in [hDidntFindAnyHiddenEvent], else stores $ff
CheckForHiddenEvent:
	ld hl, hItemAlreadyFound
	xor a
	ld [hli], a ; [hItemAlreadyFound]
	ld [hli], a ; [hSavedMapTextPtr]
	ld [hli], a ; [hSavedMapTextPtr + 1]
	ld [hl], a  ; [hDidntFindAnyHiddenEvent]
	ld de, $0
	ld hl, HiddenEventMaps
CheckForHiddenEvent.hiddenMapLoop
	ld a, [hli]
	ld b, a
	cp $ff
	jr z, CheckForHiddenEvent.noMatch
	ld a, [wCurMap]
	cp b
	jr z, CheckForHiddenEvent.foundMatchingMap
	inc de
	inc de
	jr CheckForHiddenEvent.hiddenMapLoop
CheckForHiddenEvent.foundMatchingMap
	ld hl, HiddenEventPointers
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld hl, wHiddenEventFunctionArgument
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop hl
CheckForHiddenEvent.hiddenEventLoop
	ld a, [hli]
	cp $ff
	jr z, CheckForHiddenEvent.noMatch
	ld [wHiddenEventY], a
	ld b, a
	ld a, [hli]
	ld [wHiddenEventX], a
	ld c, a
	call CheckIfCoordsInFrontOfPlayerMatch
	ldh a, [lobyte(hCoordsInFrontOfPlayerMatch)]
	and a
	jr z, CheckForHiddenEvent.foundMatchingEvent
	inc hl
	inc hl
	inc hl
	inc hl
	push hl
	ld hl, wHiddenEventIndex
	inc [hl]
	pop hl
	jr CheckForHiddenEvent.hiddenEventLoop
CheckForHiddenEvent.foundMatchingEvent
	ld a, [hli]
	ld [wHiddenEventFunctionArgument], a
	ld a, [hli]
	ld [wHiddenEventFunctionRomBank], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
CheckForHiddenEvent.noMatch
	ld a, $ff
	ldh [lobyte(hDidntFindAnyHiddenEvent)], a
	ret

; checks if the coordinates in front of the player's sprite match Y in b and X in c
; [hCoordsInFrontOfPlayerMatch] = $00 if they match, $ff if they don't match
CheckIfCoordsInFrontOfPlayerMatch:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr z, CheckIfCoordsInFrontOfPlayerMatch.facingUp
	cp SPRITE_FACING_LEFT
	jr z, CheckIfCoordsInFrontOfPlayerMatch.facingLeft
	cp SPRITE_FACING_RIGHT
	jr z, CheckIfCoordsInFrontOfPlayerMatch.facingRight
; facing down
	ld a, [wYCoord]
	inc a
	jr CheckIfCoordsInFrontOfPlayerMatch.upDownCommon
CheckIfCoordsInFrontOfPlayerMatch.facingUp
	ld a, [wYCoord]
	dec a
CheckIfCoordsInFrontOfPlayerMatch.upDownCommon
	cp b
	jr nz, CheckIfCoordsInFrontOfPlayerMatch.didNotMatch
	ld a, [wXCoord]
	cp c
	jr nz, CheckIfCoordsInFrontOfPlayerMatch.didNotMatch
	jr CheckIfCoordsInFrontOfPlayerMatch.matched
CheckIfCoordsInFrontOfPlayerMatch.facingLeft
	ld a, [wXCoord]
	dec a
	jr CheckIfCoordsInFrontOfPlayerMatch.leftRightCommon
CheckIfCoordsInFrontOfPlayerMatch.facingRight
	ld a, [wXCoord]
	inc a
CheckIfCoordsInFrontOfPlayerMatch.leftRightCommon
	cp c
	jr nz, CheckIfCoordsInFrontOfPlayerMatch.didNotMatch
	ld a, [wYCoord]
	cp b
	jr nz, CheckIfCoordsInFrontOfPlayerMatch.didNotMatch
CheckIfCoordsInFrontOfPlayerMatch.matched
	xor a
	jr CheckIfCoordsInFrontOfPlayerMatch.done
CheckIfCoordsInFrontOfPlayerMatch.didNotMatch
	ld a, $ff
CheckIfCoordsInFrontOfPlayerMatch.done
	ldh [lobyte(hCoordsInFrontOfPlayerMatch)], a
	ret

.INCLUDE "data/events/hidden_events.asm"
