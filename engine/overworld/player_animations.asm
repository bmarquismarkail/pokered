EnterMapAnim:
	call InitFacingDirectionList
	ld a, $ec
	ld [wSpritePlayerStateData1YPixels], a
	call Delay3
	push hl
	call GBFadeInFromWhite
	ld hl, wStatusFlags7
	bit BIT_USED_FLY, [hl]
	res BIT_USED_FLY, [hl]
	jr nz, EnterMapAnim.flyAnimation
	ld a, SFX_TELEPORT_ENTER_1
	call PlaySound
	ld hl, wStatusFlags6
	bit BIT_DUNGEON_WARP, [hl]
	res BIT_DUNGEON_WARP, [hl]
	pop hl
	jr nz, EnterMapAnim.dungeonWarpAnimation
	call PlayerSpinWhileMovingDown
	ld a, SFX_TELEPORT_ENTER_2
	call PlaySound
	call IsPlayerStandingOnWarpPadOrHole
	ld a, b
	and a
	jr nz, EnterMapAnim.done
; if the player is not standing on a warp pad or hole
	ld hl, wPlayerSpinInPlaceAnimFrameDelay
	xor a
	ld [hli], a ; wPlayerSpinInPlaceAnimFrameDelay
	inc a
	ld [hli], a ; wPlayerSpinInPlaceAnimFrameDelayDelta
	ld a, $8
	ld [hli], a ; wPlayerSpinInPlaceAnimFrameDelayEndValue
	ld [hl], $ff ; wPlayerSpinInPlaceAnimSoundID
	ld hl, wFacingDirectionList
	call PlayerSpinInPlace
EnterMapAnim.restoreDefaultMusic
	call PlayDefaultMusic
EnterMapAnim.done
	jp RestoreFacingDirectionAndYScreenPos
EnterMapAnim.dungeonWarpAnimation
	ld c, 50
	call DelayFrames
	call PlayerSpinWhileMovingDown
	jr EnterMapAnim.done
EnterMapAnim.flyAnimation
	pop hl
	ld de, BirdSprite
	ld hl, vNPCSprites
	lb "bc", bank(BirdSprite), $0c
	call CopyVideoData
	call LoadBirdSpriteGraphics
	ld a, SFX_FLY
	call PlaySound
	ld hl, wFlyAnimUsingCoordList
	xor a ; is using coord list
	ld [hli], a ; wFlyAnimUsingCoordList
	ld a, 12
	ld [hli], a ; wFlyAnimCounter
	ld [hl], $8 ; wFlyAnimBirdSpriteImageIndex (facing right)
	ld de, FlyAnimationEnterScreenCoords
	call DoFlyAnimation
	call LoadPlayerSpriteGraphics
	jr EnterMapAnim.restoreDefaultMusic

FlyAnimationEnterScreenCoords:
; y, x pairs
; This is the sequence of screen coordinates used by the overworld
; Fly animation when the player is entering a map.
	.DB $05, $98
	.DB $0F, $90
	.DB $18, $88
	.DB $20, $80
	.DB $27, $78
	.DB $2D, $70
	.DB $32, $68
	.DB $36, $60
	.DB $39, $58
	.DB $3B, $50
	.DB $3C, $48
	.DB $3C, $40

PlayerSpinWhileMovingDown:
	ld hl, wPlayerSpinWhileMovingUpOrDownAnimDeltaY
	ld a, $10
	ld [hli], a ; wPlayerSpinWhileMovingUpOrDownAnimDeltaY
	ld a, $3c
	ld [hli], a ; wPlayerSpinWhileMovingUpOrDownAnimMaxY
	call GetPlayerTeleportAnimFrameDelay
	ld [hl], a ; wPlayerSpinWhileMovingUpOrDownAnimFrameDelay
	jp PlayerSpinWhileMovingUpOrDown

_LeaveMapAnim:
WLA_GLOBAL_LeaveMapAnim:
	call InitFacingDirectionList
	call IsPlayerStandingOnWarpPadOrHole
	ld a, b
	and a
	jr z, WLA_GLOBAL_LeaveMapAnim__playerNotStandingOnWarpPadOrHole
	dec a
	jp nz, LeaveMapThroughHoleAnim
_LeaveMapAnim.spinWhileMovingUp:
WLA_GLOBAL_LeaveMapAnim__spinWhileMovingUp:
	ld a, SFX_TELEPORT_EXIT_1
	call PlaySound
	ld hl, wPlayerSpinWhileMovingUpOrDownAnimDeltaY
	ld a, -$10
	ld [hli], a ; wPlayerSpinWhileMovingUpOrDownAnimDeltaY
	ld a, $ec
	ld [hli], a ; wPlayerSpinWhileMovingUpOrDownAnimMaxY
	call GetPlayerTeleportAnimFrameDelay
	ld [hl], a ; wPlayerSpinWhileMovingUpOrDownAnimFrameDelay
	call PlayerSpinWhileMovingUpOrDown
	call IsPlayerStandingOnWarpPadOrHole
	ld a, b
	dec a
	jr z, WLA_GLOBAL_LeaveMapAnim__playerStandingOnWarpPad
; if not standing on a warp pad, there is an extra delay
	ld c, 10
	call DelayFrames
_LeaveMapAnim.playerStandingOnWarpPad:
WLA_GLOBAL_LeaveMapAnim__playerStandingOnWarpPad:
	call GBFadeOutToWhite
	jp RestoreFacingDirectionAndYScreenPos
_LeaveMapAnim.playerNotStandingOnWarpPadOrHole:
WLA_GLOBAL_LeaveMapAnim__playerNotStandingOnWarpPadOrHole:
	ld a, $4
	call StopMusic
	ld a, [wStatusFlags6]
	bit BIT_ESCAPE_WARP, a
	jr z, WLA_GLOBAL_LeaveMapAnim__flyAnimation
; if going to the last used pokemon center
	ld hl, wPlayerSpinInPlaceAnimFrameDelay
	ld a, 16
	ld [hli], a ; wPlayerSpinInPlaceAnimFrameDelay
	ld a, -1
	ld [hli], a ; wPlayerSpinInPlaceAnimFrameDelayDelta
	xor a
	ld [hli], a ; wPlayerSpinInPlaceAnimFrameDelayEndValue
	ld [hl], SFX_TELEPORT_EXIT_2 ; wPlayerSpinInPlaceAnimSoundID
	ld hl, wFacingDirectionList
	call PlayerSpinInPlace
	jr WLA_GLOBAL_LeaveMapAnim__spinWhileMovingUp
_LeaveMapAnim.flyAnimation:
WLA_GLOBAL_LeaveMapAnim__flyAnimation:
	call LoadBirdSpriteGraphics
	ld hl, wFlyAnimUsingCoordList
	ld a, $ff ; is not using coord list (flap in place)
	ld [hli], a ; wFlyAnimUsingCoordList
	ld a, 8
	ld [hli], a ; wFlyAnimCounter
	ld [hl], $c ; wFlyAnimBirdSpriteImageIndex
	call DoFlyAnimation
	ld a, SFX_FLY
	call PlaySound
	ld hl, wFlyAnimUsingCoordList
	xor a ; is using coord list
	ld [hli], a ; wFlyAnimUsingCoordList
	ld a, $c
	ld [hli], a ; wFlyAnimCounter
	ld [hl], $c ; wFlyAnimBirdSpriteImageIndex (facing right)
	ld de, FlyAnimationScreenCoords1
	call DoFlyAnimation
	ld c, 40
	call DelayFrames
	ld hl, wFlyAnimCounter
	ld a, 11
	ld [hli], a ; wFlyAnimCounter
	ld [hl], $8 ; wFlyAnimBirdSpriteImageIndex (facing left)
	ld de, FlyAnimationScreenCoords2
	call DoFlyAnimation
	call GBFadeOutToWhite
	jp RestoreFacingDirectionAndYScreenPos

FlyAnimationScreenCoords1:
; y, x pairs
; This is the sequence of screen coordinates used by the first part
; of the Fly overworld animation.
	.DB $3C, $48
	.DB $3C, $50
	.DB $3B, $58
	.DB $3A, $60
	.DB $39, $68
	.DB $37, $70
	.DB $37, $78
	.DB $33, $80
	.DB $30, $88
	.DB $2D, $90
	.DB $2A, $98
	.DB $27, $A0

FlyAnimationScreenCoords2:
; y, x pairs
; This is the sequence of screen coordinates used by the second part
; of the Fly overworld animation.
	.DB $1A, $90
	.DB $19, $80
	.DB $17, $70
	.DB $15, $60
	.DB $12, $50
	.DB $0F, $40
	.DB $0C, $30
	.DB $09, $20
	.DB $05, $10
	.DB $00, $00

	.DB $F0, $00

LeaveMapThroughHoleAnim:
	ld a, $ff
	ld [wUpdateSpritesEnabled], a ; disable UpdateSprites
	; shift upper half of player's sprite down 8 pixels and hide lower half
	ld a, [wShadowOAMSprite00TileID]
	ld [wShadowOAMSprite02TileID], a
	ld a, [wShadowOAMSprite01TileID]
	ld [wShadowOAMSprite03TileID], a
	ld a, SCREEN_HEIGHT_PX + OAM_Y_OFS
	ld [wShadowOAMSprite00YCoord], a
	ld [wShadowOAMSprite01YCoord], a
	ld c, 2
	call DelayFrames
	; hide upper half of player's sprite
	ld a, SCREEN_HEIGHT_PX + OAM_Y_OFS
	ld [wShadowOAMSprite02YCoord], a
	ld [wShadowOAMSprite03YCoord], a
	call GBFadeOutToWhite
	ld a, $1
	ld [wUpdateSpritesEnabled], a ; enable UpdateSprites
	jp RestoreFacingDirectionAndYScreenPos

DoFlyAnimation:
	ld a, [wFlyAnimBirdSpriteImageIndex]
	xor $1 ; make the bird flap its wings
	ld [wFlyAnimBirdSpriteImageIndex], a
	ld [wSpritePlayerStateData1ImageIndex], a
	call Delay3
	ld a, [wFlyAnimUsingCoordList]
	cp $ff
	jr z, DoFlyAnimation.skipCopyingCoords ; if the bird is flapping its wings in place
	ld hl, wSpritePlayerStateData1YPixels
	ld a, [de]
	inc de
	ld [hli], a ; y
	inc hl
	ld a, [de]
	inc de
	ld [hl], a ; x
DoFlyAnimation.skipCopyingCoords
	ld a, [wFlyAnimCounter]
	dec a
	ld [wFlyAnimCounter], a
	jr nz, DoFlyAnimation
	ret

LoadBirdSpriteGraphics:
	ld de, BirdSprite
	ld hl, vNPCSprites
	lb "bc", bank(BirdSprite), 12
	call CopyVideoData
	ld de, BirdSprite + TILE_SIZE * 12 ; moving animation sprite
	ld hl, vNPCSprites2
	lb "bc", bank(BirdSprite), 12
	jp CopyVideoData

InitFacingDirectionList:
	ld a, [wSpritePlayerStateData1ImageIndex] ; (image index is locked to standing images)
	ld [wSavedPlayerFacingDirection], a
	ld a, [wSpritePlayerStateData1YPixels]
	ld [wSavedPlayerScreenY], a
	ld hl, PlayerSpinningFacingOrder
	ld de, wFacingDirectionList
	ld bc, OBJ_SIZE
	call CopyData
	ld a, [wSpritePlayerStateData1ImageIndex] ; (image index is locked to standing images)
	ld hl, wFacingDirectionList
; find the place in the list that matches the current facing direction
InitFacingDirectionList.loop
	cp [hl]
	inc hl
	jr nz, InitFacingDirectionList.loop
	dec hl
	ret

PlayerSpinningFacingOrder:
; The order of the direction the player's sprite is facing when teleporting
; away. Creates a spinning effect.
	.DB SPRITE_FACING_DOWN, SPRITE_FACING_LEFT, SPRITE_FACING_UP, SPRITE_FACING_RIGHT

SpinPlayerSprite:
; copy the current value from the list into the sprite data and rotate the list
	ld a, [hl]
	ld [wSpritePlayerStateData1ImageIndex], a ; (image index is locked to standing images)
	push hl
	ld hl, wFacingDirectionList
	ld de, wFacingDirectionList - 1
	ld bc, OBJ_SIZE
	call CopyData
	ld a, [wFacingDirectionList - 1]
	ld [wFacingDirectionList + 3], a
	pop hl
	ret

PlayerSpinInPlace:
	call SpinPlayerSprite
	ld a, [wPlayerSpinInPlaceAnimFrameDelay]
	ld c, a
	and $3
	jr nz, PlayerSpinInPlace.skipPlayingSound
; when the last delay was a multiple of 4, play a sound if there is one
	ld a, [wPlayerSpinInPlaceAnimSoundID]
	cp $ff
	call nz, PlaySound
PlayerSpinInPlace.skipPlayingSound
	ld a, [wPlayerSpinInPlaceAnimFrameDelayDelta]
	add c
	ld [wPlayerSpinInPlaceAnimFrameDelay], a
	ld c, a
	ld a, [wPlayerSpinInPlaceAnimFrameDelayEndValue]
	cp c
	ret z
	call DelayFrames
	jr PlayerSpinInPlace

PlayerSpinWhileMovingUpOrDown:
	call SpinPlayerSprite
	ld a, [wPlayerSpinWhileMovingUpOrDownAnimDeltaY]
	ld c, a
	ld a, [wSpritePlayerStateData1YPixels]
	add c
	ld [wSpritePlayerStateData1YPixels], a
	ld c, a
	ld a, [wPlayerSpinWhileMovingUpOrDownAnimMaxY]
	cp c
	ret z
	ld a, [wPlayerSpinWhileMovingUpOrDownAnimFrameDelay]
	ld c, a
	call DelayFrames
	jr PlayerSpinWhileMovingUpOrDown

RestoreFacingDirectionAndYScreenPos:
	ld a, [wSavedPlayerScreenY]
	ld [wSpritePlayerStateData1YPixels], a
	ld a, [wSavedPlayerFacingDirection]
	ld [wSpritePlayerStateData1ImageIndex], a ; (image index is locked to standing images)
	ret

; if SGB, 2 frames, else 3 frames
GetPlayerTeleportAnimFrameDelay:
	ld a, [wOnSGB]
	xor $1
	inc a
	inc a
	ret

IsPlayerStandingOnWarpPadOrHole:
	ld b, 0
	ld hl, WarpPadAndHoleData
	ld a, [wCurMapTileset]
	ld c, a
IsPlayerStandingOnWarpPadOrHole.loop
	ld a, [hli]
	cp $ff
	jr z, IsPlayerStandingOnWarpPadOrHole.done
	cp c
	jr nz, IsPlayerStandingOnWarpPadOrHole.nextEntry
	lda_coord 8, 9
	cp [hl]
	jr z, IsPlayerStandingOnWarpPadOrHole.foundMatch
IsPlayerStandingOnWarpPadOrHole.nextEntry
	inc hl
	inc hl
	jr IsPlayerStandingOnWarpPadOrHole.loop
IsPlayerStandingOnWarpPadOrHole.foundMatch
	inc hl
	ld b, [hl]
IsPlayerStandingOnWarpPadOrHole.done
	ld a, b
	ld [wStandingOnWarpPadOrHole], a
	ret

.INCLUDE "data/tilesets/warp_pad_hole_tile_ids.asm"

FishingAnim:
	ld c, 10
	call DelayFrames
	ld hl, wMovementFlags
	set BIT_LEDGE_OR_FISHING, [hl]
	ld de, RedSprite
	ld hl, vNPCSprites + TILE_SIZE * $00
	lb "bc", bank(RedSprite), 12
	call CopyVideoData
	ld a, $4
	ld hl, RedFishingTiles
	call LoadAnimSpriteGfx
	ld a, [wSpritePlayerStateData1ImageIndex]
	ld c, a
	ld b, $0
	ld hl, FishingRodOAM
	add hl, bc
	ld de, wShadowOAMSprite39
	ld bc, OBJ_SIZE
	call CopyData
	ld c, 100
	call DelayFrames
	ld a, [wRodResponse]
	and a
	ld hl, NoNibbleText
	jr z, FishingAnim.done
	cp $2
	ld hl, NothingHereText
	jr z, FishingAnim.done

; there was a bite

; shake the player's sprite vertically
	ld b, 10
FishingAnim.loop
	ld hl, wSpritePlayerStateData1YPixels
	call FishingAnim.ShakePlayerSprite
	ld hl, wShadowOAMSprite39
	call FishingAnim.ShakePlayerSprite
	call Delay3
	dec b
	jr nz, FishingAnim.loop

; If the player is facing up, hide the fishing rod so it doesn't overlap with
; the exclamation bubble that will be shown next.
	ld a, [wSpritePlayerStateData1ImageIndex] ; (image index is locked to standing images)
	cp SPRITE_FACING_UP
	jr nz, FishingAnim.skipHidingFishingRod
	ld a, SCREEN_HEIGHT_PX + OAM_Y_OFS
	ld [wShadowOAMSprite39YCoord], a

FishingAnim.skipHidingFishingRod
	ld hl, wEmotionBubbleSpriteIndex
	xor a
	ld [hli], a ; player's sprite
	ld [hl], a ; EXCLAMATION_BUBBLE
	predef EmotionBubble

; If the player is facing up, unhide the fishing rod.
	ld a, [wSpritePlayerStateData1ImageIndex] ; (image index is locked to standing images)
	cp SPRITE_FACING_UP
	jr nz, FishingAnim.skipUnhidingFishingRod
	ld a, $44
	ld [wShadowOAMSprite39YCoord], a

FishingAnim.skipUnhidingFishingRod
	ld hl, ItsABiteText

FishingAnim.done
	call PrintText
	ld hl, wMovementFlags
	res BIT_LEDGE_OR_FISHING, [hl]
	call LoadFontTilePatterns
	ret

FishingAnim.ShakePlayerSprite
	ld a, [hl]
	xor $1
	ld [hl], a
	ret

NoNibbleText:
	text_far WLA_GLOBAL_NoNibbleText
	text_end

NothingHereText:
	text_far WLA_GLOBAL_NothingHereText
	text_end

ItsABiteText:
	text_far WLA_GLOBAL_ItsABiteText
	text_end

FishingRodOAM:
; specifies how the fishing rod should be drawn on the screen
	dbsprite  9, 11,  4,  3, $fd, 0         ; down
	dbsprite  9,  8,  4,  4, $fd, 0         ; up
	dbsprite  8, 10,  0,  0, $fe, 0         ; left
	dbsprite 11, 10,  0,  0, $fe, OAM_XFLIP ; right

.MACRO fishing_gfx
	.DW \1
	.DB \2
	.DB bank(\1)
	.DW vNPCSprites + TILE_SIZE * \3
.ENDM

RedFishingTiles:
	fishing_gfx RedFishingTilesFront, 2, $02
	fishing_gfx RedFishingTilesBack,  2, $06
	fishing_gfx RedFishingTilesSide,  2, $0a
	fishing_gfx RedFishingRodTiles,   3, $fd

HandleMidJumpFar:
_HandleMidJump:
WLA_GLOBAL_HandleMidJump:
	ld a, [wPlayerJumpingYScreenCoordsIndex]
	ld c, a
	inc a
	cp $10
	jr nc, WLA_GLOBAL_HandleMidJump__finishedJump
	ld [wPlayerJumpingYScreenCoordsIndex], a
	ld b, 0
	ld hl, PlayerJumpingYScreenCoords
	add hl, bc
	ld a, [hl]
	ld [wSpritePlayerStateData1YPixels], a
	ret
_HandleMidJump.finishedJump:
WLA_GLOBAL_HandleMidJump__finishedJump:
	ld a, [wWalkCounter]
	cp 0
	ret nz
	call UpdateSprites
	call Delay3
	xor a
	ldh [lobyte(hJoyHeld)], a
	ldh [lobyte(hJoyPressed)], a
	ldh [lobyte(hJoyReleased)], a
	ld [wPlayerJumpingYScreenCoordsIndex], a
	ld hl, wMovementFlags
	res BIT_LEDGE_OR_FISHING, [hl]
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	xor a
	ld [wJoyIgnore], a
	ret

PlayerJumpingYScreenCoords:
; Sequence of y screen coordinates for player's sprite when jumping over a ledge.
	.DB $38, $36, $34, $32, $31, $30, $30, $30, $31, $32, $33, $34, $36, $38, $3C, $3C
