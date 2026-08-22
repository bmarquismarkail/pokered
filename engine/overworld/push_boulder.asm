TryPushingBoulder:
	ld a, [wStatusFlags1]
	bit BIT_STRENGTH_ACTIVE, a
	ret z
	ld a, [wMiscFlags]
	bit BIT_BOULDER_DUST, a
	ret nz
	xor a
	ldh [lobyte(hSpriteIndex)], a
	call IsSpriteInFrontOfPlayer
	ldh a, [lobyte(hSpriteIndex)]
	ld [wBoulderSpriteIndex], a
	and a
	jp z, ResetBoulderPushFlags
	ld hl, wSpritePlayerStateData1MovementStatus
	ld d, $0
	ldh a, [lobyte(hSpriteIndex)]
	swap a
	ld e, a
	add hl, de
	res BIT_FACE_PLAYER, [hl]
	call GetSpriteMovementByte2Pointer
	ld a, [hl]
	cp BOULDER_MOVEMENT_BYTE_2
	jp nz, ResetBoulderPushFlags
	ld hl, wMiscFlags
	bit BIT_TRIED_PUSH_BOULDER, [hl]
	set BIT_TRIED_PUSH_BOULDER, [hl]
	ret z ; the player must try pushing twice before the boulder will move
	ldh a, [lobyte(hJoyHeld)]
	and PAD_CTRL_PAD
	ret z
	predef CheckForCollisionWhenPushingBoulder
	ld a, [wTileInFrontOfBoulderAndBoulderCollisionResult]
	and a ; was there a collision?
	jp nz, ResetBoulderPushFlags
	ldh a, [lobyte(hJoyHeld)]
	ld b, a
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr z, TryPushingBoulder.pushBoulderUp
	cp SPRITE_FACING_LEFT
	jr z, TryPushingBoulder.pushBoulderLeft
	cp SPRITE_FACING_RIGHT
	jr z, TryPushingBoulder.pushBoulderRight
; push boulder down
	bit B_PAD_DOWN, b
	ret z
	ld de, PushBoulderDownMovementData
	jr TryPushingBoulder.done
TryPushingBoulder.pushBoulderUp
	bit B_PAD_UP, b
	ret z
	ld de, PushBoulderUpMovementData
	jr TryPushingBoulder.done
TryPushingBoulder.pushBoulderLeft
	bit B_PAD_LEFT, b
	ret z
	ld de, PushBoulderLeftMovementData
	jr TryPushingBoulder.done
TryPushingBoulder.pushBoulderRight
	bit B_PAD_RIGHT, b
	ret z
	ld de, PushBoulderRightMovementData
TryPushingBoulder.done
	call MoveSprite
	ld a, SFX_PUSH_BOULDER
	call PlaySound
	ld hl, wMiscFlags
	set BIT_BOULDER_DUST, [hl]
	ret

PushBoulderUpMovementData:
	.DB NPC_MOVEMENT_UP
	.DB -1 ; end

PushBoulderDownMovementData:
	.DB NPC_MOVEMENT_DOWN
	.DB -1 ; end

PushBoulderLeftMovementData:
	.DB NPC_MOVEMENT_LEFT
	.DB -1 ; end

PushBoulderRightMovementData:
	.DB NPC_MOVEMENT_RIGHT
	.DB -1 ; end

DoBoulderDustAnimation:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	callfar AnimateBoulderDust
	call DiscardButtonPresses
	ld [wJoyIgnore], a
	call ResetBoulderPushFlags
	set BIT_PUSHED_BOULDER, [hl]
	ld a, [wBoulderSpriteIndex]
	ldh [lobyte(hSpriteIndex)], a
	call GetSpriteMovementByte2Pointer
	ld [hl], $10
	ld a, SFX_CUT
	jp PlaySound

ResetBoulderPushFlags:
	ld hl, wMiscFlags
	res BIT_BOULDER_DUST, [hl]
	res BIT_TRIED_PUSH_BOULDER, [hl]
	ret
