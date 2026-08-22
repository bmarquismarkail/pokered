UsedCut:
	xor a
	ld [wActionResultOrTookBattleTurn], a ; initialise to failure value
	ld a, [wCurMapTileset]
	and a ; OVERWORLD
	jr z, UsedCut.overworld
	cp GYM
	jr nz, UsedCut.nothingToCut
	ld a, [wTileInFrontOfPlayer]
	cp $50 ; gym cut tree
	jr nz, UsedCut.nothingToCut
	jr UsedCut.canCut
UsedCut.overworld
	dec a
	ld a, [wTileInFrontOfPlayer]
	cp $3d ; cut tree
	jr z, UsedCut.canCut
	cp $52 ; grass
	jr z, UsedCut.canCut
UsedCut.nothingToCut
	ld hl, UsedCut.NothingToCutText
	jp PrintText

UsedCut.NothingToCutText
	text_far WLA_GLOBAL_NothingToCutText
	text_end

UsedCut.canCut
	ld [wCutTile], a
	ld a, 1
	ld [wActionResultOrTookBattleTurn], a ; used cut
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	call GBPalWhiteOutWithDelay3
	call ClearSprites
	call RestoreScreenTilesAndReloadTilePatterns
	ld a, SCREEN_HEIGHT_PX
	ldh [lobyte(hWY)], a
	call Delay3
	call LoadGBPal
	call LoadCurrentMapView
	call SaveScreenTilesToBuffer2
	call Delay3
	xor a
	ldh [lobyte(hWY)], a
	ld hl, UsedCutText
	call PrintText
	call LoadScreenTilesFromBuffer2
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	call InitCutAnimOAM
	ld de, CutTreeBlockSwaps
	call ReplaceTreeTileBlock
	call RedrawMapView
	farcall AnimCut
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	ld a, SFX_CUT
	call PlaySound
	ld a, $90
	ldh [lobyte(hWY)], a
	call UpdateSprites
	jp RedrawMapView

UsedCutText:
	text_far WLA_GLOBAL_UsedCutText
	text_end

InitCutAnimOAM:
	xor a
	ld [wWhichAnimationOffsets], a
	ld a, %11100100
	ldh [lobyte(rOBP1)], a
	ld a, [wCutTile]
	cp $52
	jr z, InitCutAnimOAM.grass
; tree
	ld de, Overworld_GFX + TILE_SIZE * $2d ; cuttable tree sprite top row
	ld hl, vChars1 + TILE_SIZE * $7c
	lb "bc", bank(Overworld_GFX), 2
	call CopyVideoData
	ld de, Overworld_GFX + TILE_SIZE * $3d ; cuttable tree sprite bottom row
	ld hl, vChars1 + TILE_SIZE * $7e
	lb "bc", bank(Overworld_GFX), 2
	call CopyVideoData
	jr WriteCutOrBoulderDustAnimationOAMBlock
InitCutAnimOAM.grass
	ld hl, vChars1 + TILE_SIZE * $7c
	call LoadCutGrassAnimationTilePattern
	ld hl, vChars1 + TILE_SIZE * $7d
	call LoadCutGrassAnimationTilePattern
	ld hl, vChars1 + TILE_SIZE * $7e
	call LoadCutGrassAnimationTilePattern
	ld hl, vChars1 + TILE_SIZE * $7f
	call LoadCutGrassAnimationTilePattern
	call WriteCutOrBoulderDustAnimationOAMBlock
	ld hl, wShadowOAMSprite36Attributes
	ld de, OBJ_SIZE
	ld a, OAM_XFLIP | OAM_PAL1
	ld c, e
InitCutAnimOAM.loop
	ld [hl], a
	add hl, de
	xor OAM_YFLIP | OAM_XFLIP
	dec c
	jr nz, InitCutAnimOAM.loop
	ret

LoadCutGrassAnimationTilePattern:
	ld de, MoveAnimationTiles1 + TILE_SIZE * 6 ; + TILE_SIZE * depicting a leaf
	lb "bc", bank(MoveAnimationTiles1), 1
	jp CopyVideoData

WriteCutOrBoulderDustAnimationOAMBlock:
	call GetCutOrBoulderDustAnimationOffsets
	ld a, $9
	ld de, WriteCutOrBoulderDustAnimationOAMBlock.OAMBlock
	jp WriteOAMBlock

WriteCutOrBoulderDustAnimationOAMBlock.OAMBlock:
; + TILE_SIZE * ID, attributes
	.DB $fc, OAM_PAL1
	.DB $fd, OAM_PAL1
	.DB $fe, OAM_PAL1
	.DB $ff, OAM_PAL1

GetCutOrBoulderDustAnimationOffsets:
	ld hl, wSpritePlayerStateData1YPixels
	ld a, [hli] ; player's sprite screen Y position
	ld b, a
	inc hl
	ld a, [hli] ; player's sprite screen X position
	ld c, a ; bc holds ypos/xpos of player's sprite
	inc hl
	inc hl
	ld a, [hl] ; a holds direction of player (00: down, 04: up, 08: left, 0C: right)
	srl a
	ld e, a
	ld d, $0 ; de holds direction (00: down, 02: up, 04: left, 06: right)
	ld a, [wWhichAnimationOffsets]
	and a
	ld hl, CutAnimationOffsets
	jr z, GetCutOrBoulderDustAnimationOffsets.next
	ld hl, BoulderDustAnimationOffsets
GetCutOrBoulderDustAnimationOffsets.next
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, b
	add d
	ld b, a
	ld a, c
	add e
	ld c, a
	ret

CutAnimationOffsets:
; Each pair represents the x and y pixels offsets from the player of where the cut tree animation should be drawn
	.DB  8, 36 ; player is facing down
	.DB  8,  4 ; player is facing up
	.DB -8, 20 ; player is facing left
	.DB 24, 20 ; player is facing right

BoulderDustAnimationOffsets:
; Each pair represents the x and y pixels offsets from the player of where the cut tree animation should be drawn
; These offsets represent 2 blocks away from the player
	.DB  8,  52 ; player is facing down
	.DB  8, -12 ; player is facing up
	.DB -24, 20 ; player is facing left
	.DB 40,  20 ; player is facing right

ReplaceTreeTileBlock:
; Determine the address of the + TILE_SIZE * block that contains the + TILE_SIZE * in front of the
; player (i.e. where the tree is) and replace it with the corresponding + TILE_SIZE * ; block that doesn't have the tree.
	push de
	ld a, [wCurMapWidth]
	add 6
	ld c, a
	ld b, 0
	ld d, 0
	ld hl, wCurrentTileBlockMapViewPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a
	jr z, ReplaceTreeTileBlock.down
	cp SPRITE_FACING_UP
	jr z, ReplaceTreeTileBlock.up
	cp SPRITE_FACING_LEFT
	jr z, ReplaceTreeTileBlock.left
; right
	ld a, [wXBlockCoord]
	and a
	jr z, ReplaceTreeTileBlock.centerTileBlock
	jr ReplaceTreeTileBlock.rightOfCenter
ReplaceTreeTileBlock.down
	ld a, [wYBlockCoord]
	and a
	jr z, ReplaceTreeTileBlock.centerTileBlock
	jr ReplaceTreeTileBlock.belowCenter
ReplaceTreeTileBlock.up
	ld a, [wYBlockCoord]
	and a
	jr z, ReplaceTreeTileBlock.aboveCenter
	jr ReplaceTreeTileBlock.centerTileBlock
ReplaceTreeTileBlock.left
	ld a, [wXBlockCoord]
	and a
	jr z, ReplaceTreeTileBlock.leftOfCenter
	jr ReplaceTreeTileBlock.centerTileBlock
ReplaceTreeTileBlock.belowCenter
	add hl, bc
ReplaceTreeTileBlock.centerTileBlock
	add hl, bc
ReplaceTreeTileBlock.aboveCenter
	ld e, $2
	add hl, de
	jr ReplaceTreeTileBlock.next
ReplaceTreeTileBlock.leftOfCenter
	ld e, $1
	add hl, bc
	add hl, de
	jr ReplaceTreeTileBlock.next
ReplaceTreeTileBlock.rightOfCenter
	ld e, $3
	add hl, bc
	add hl, de
ReplaceTreeTileBlock.next
	pop de
	ld a, [hl]
	ld c, a
ReplaceTreeTileBlock.loop ; find the matching + TILE_SIZE * block in the array
	ld a, [de]
	inc de
	inc de
	cp $ff
	ret z
	cp c
	jr nz, ReplaceTreeTileBlock.loop
	dec de
	ld a, [de] ; replacement + TILE_SIZE * block from matching array entry
	ld [hl], a
	ret

.INCLUDE "data/tilesets/cut_tree_blocks.asm"
