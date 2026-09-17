FindPathToPlayer:
	xor a
	ld hl, hFindPathNumSteps
	ld [hli], a ; hFindPathNumSteps
	ld [hli], a ; hFindPathFlags
	ld [hli], a ; hFindPathYProgress
	ld [hl], a  ; hFindPathXProgress
	ld hl, wNPCMovementDirections2
	ld de, $0
FindPathToPlayer.loop
	ldh a, [lobyte(hFindPathYProgress)]
	ld b, a
	ldh a, [lobyte(hNPCPlayerYDistance)] ; Y distance in steps
	call CalcDifference
	ld d, a
	and a
	jr nz, FindPathToPlayer.stillHasYProgress
	ldh a, [lobyte(hFindPathFlags)]
	set BIT_PATH_FOUND_Y, a
	ldh [lobyte(hFindPathFlags)], a
FindPathToPlayer.stillHasYProgress
	ldh a, [lobyte(hFindPathXProgress)]
	ld b, a
	ldh a, [lobyte(hNPCPlayerXDistance)] ; X distance in steps
	call CalcDifference
	ld e, a
	and a
	jr nz, FindPathToPlayer.stillHasXProgress
	ldh a, [lobyte(hFindPathFlags)]
	set BIT_PATH_FOUND_X, a
	ldh [lobyte(hFindPathFlags)], a
FindPathToPlayer.stillHasXProgress
	ldh a, [lobyte(hFindPathFlags)]
	cp (1 << BIT_PATH_FOUND_X) | (1 << BIT_PATH_FOUND_Y)
	jr z, FindPathToPlayer.done
; Compare whether the X distance between the player and the current of the path
; is greater or if the Y distance is. Then, try to reduce whichever is greater.
	ld a, e
	cp d
	jr c, FindPathToPlayer.yDistanceGreater
; x distance is greater
	ldh a, [lobyte(hNPCPlayerRelativePosFlags)]
	bit BIT_PLAYER_LOWER_X, a
	jr nz, FindPathToPlayer.playerIsLeftOfNPC
	ld d, NPC_MOVEMENT_RIGHT
	jr FindPathToPlayer.next1
FindPathToPlayer.playerIsLeftOfNPC
	ld d, NPC_MOVEMENT_LEFT
FindPathToPlayer.next1
	ldh a, [lobyte(hFindPathXProgress)]
	add 1
	ldh [lobyte(hFindPathXProgress)], a
	jr FindPathToPlayer.storeDirection
FindPathToPlayer.yDistanceGreater
	ldh a, [lobyte(hNPCPlayerRelativePosFlags)]
	bit BIT_PLAYER_LOWER_Y, a
	jr nz, FindPathToPlayer.playerIsAboveNPC
	ld d, NPC_MOVEMENT_DOWN
	jr FindPathToPlayer.next2
FindPathToPlayer.playerIsAboveNPC
	ld d, NPC_MOVEMENT_UP
FindPathToPlayer.next2
	ldh a, [lobyte(hFindPathYProgress)]
	add 1
	ldh [lobyte(hFindPathYProgress)], a
FindPathToPlayer.storeDirection
	ld a, d
	ld [hli], a
	ldh a, [lobyte(hFindPathNumSteps)]
	inc a
	ldh [lobyte(hFindPathNumSteps)], a
	jp FindPathToPlayer.loop
FindPathToPlayer.done
	ld [hl], $ff
	ret

CalcPositionOfPlayerRelativeToNPC:
	xor a
	ldh [lobyte(hNPCPlayerRelativePosFlags)], a
	ld a, [wSpritePlayerStateData1YPixels]
	ld d, a
	ld a, [wSpritePlayerStateData1XPixels]
	ld e, a
	ld hl, wSpriteStateData1
	ldh a, [lobyte(hNPCSpriteOffset)]
	add l
	add SPRITESTATEDATA1_YPIXELS
	ld l, a
	jr nc, CalcPositionOfPlayerRelativeToNPC.noCarry
	inc h
CalcPositionOfPlayerRelativeToNPC.noCarry
	ld a, d
	ld b, a
	ld a, [hli] ; NPC sprite screen Y position in pixels
	call CalcDifference
	jr nc, CalcPositionOfPlayerRelativeToNPC.NPCSouthOfOrAlignedWithPlayer
; NPC north of player
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit BIT_PLAYER_LOWER_Y, [hl]
	set BIT_PLAYER_LOWER_Y, [hl]
	pop hl
	jr CalcPositionOfPlayerRelativeToNPC.divideYDistance
CalcPositionOfPlayerRelativeToNPC.NPCSouthOfOrAlignedWithPlayer
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit BIT_PLAYER_LOWER_Y, [hl]
	res BIT_PLAYER_LOWER_Y, [hl]
	pop hl
CalcPositionOfPlayerRelativeToNPC.divideYDistance
	push hl
	ld hl, hDividend2
	ld [hli], a
	ld a, 16
	ld [hli], a
	call DivideBytes ; divide Y absolute distance by 16
	ld a, [hl] ; quotient
	ldh [lobyte(hNPCPlayerYDistance)], a
	pop hl
	inc hl
	ld b, e
	ld a, [hl] ; NPC sprite screen X position in pixels
	call CalcDifference
	jr nc, CalcPositionOfPlayerRelativeToNPC.NPCEastOfOrAlignedWithPlayer
; NPC west of player
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit BIT_PLAYER_LOWER_X, [hl]
	set BIT_PLAYER_LOWER_X, [hl]
	pop hl
	jr CalcPositionOfPlayerRelativeToNPC.divideXDistance
CalcPositionOfPlayerRelativeToNPC.NPCEastOfOrAlignedWithPlayer
	push hl
	ld hl, hNPCPlayerRelativePosFlags
	bit BIT_PLAYER_LOWER_X, [hl]
	res BIT_PLAYER_LOWER_X, [hl]
	pop hl
CalcPositionOfPlayerRelativeToNPC.divideXDistance
	ldh [lobyte(hDividend2)], a
	ld a, 16
	ldh [lobyte(hDivisor2)], a
	call DivideBytes ; divide X absolute distance by 16
	ldh a, [lobyte(hQuotient2)]
	ldh [lobyte(hNPCPlayerXDistance)], a
	ldh a, [lobyte(hNPCPlayerRelativePosPerspective)]
	and a
	ret z
	ldh a, [lobyte(hNPCPlayerRelativePosFlags)]
	cpl
	and $3
	ldh [lobyte(hNPCPlayerRelativePosFlags)], a
	ret

ConvertNPCMovementDirectionsToJoypadMasks:
	ldh a, [lobyte(hNPCMovementDirections2Index)]
	ld [wNPCMovementDirections2Index], a
	dec a
	ld de, wSimulatedJoypadStatesEnd
	ld hl, wNPCMovementDirections2
	add l
	ld l, a
	jr nc, ConvertNPCMovementDirectionsToJoypadMasks.loop
	inc h
ConvertNPCMovementDirectionsToJoypadMasks.loop
	ld a, [hld]
	call ConvertNPCMovementDirectionToJoypadMask
	ld [de], a
	inc de
	ldh a, [lobyte(hNPCMovementDirections2Index)]
	dec a
	ldh [lobyte(hNPCMovementDirections2Index)], a
	jr nz, ConvertNPCMovementDirectionsToJoypadMasks.loop
	ret

ConvertNPCMovementDirectionToJoypadMask:
	push hl
	ld b, a
	ld hl, NPCMovementDirectionsToJoypadMasksTable
ConvertNPCMovementDirectionToJoypadMask.loop
	ld a, [hli]
	cp $ff
	jr z, ConvertNPCMovementDirectionToJoypadMask.done
	cp b
	jr z, ConvertNPCMovementDirectionToJoypadMask.loadJoypadMask
	inc hl
	jr ConvertNPCMovementDirectionToJoypadMask.loop
ConvertNPCMovementDirectionToJoypadMask.loadJoypadMask
	ld a, [hl]
ConvertNPCMovementDirectionToJoypadMask.done
	pop hl
	ret

NPCMovementDirectionsToJoypadMasksTable:
	.DB NPC_MOVEMENT_UP, PAD_UP
	.DB NPC_MOVEMENT_DOWN, PAD_DOWN
	.DB NPC_MOVEMENT_LEFT, PAD_LEFT
	.DB NPC_MOVEMENT_RIGHT, PAD_RIGHT
	.DB $ff

; unreferenced
	ret
