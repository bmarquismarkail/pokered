; Loads tile patterns for map's sprites.
; For outside maps, it loads one of several fixed sets of sprites.
; For inside maps, it loads each sprite picture ID used in the map header.
; This is also called after displaying text because loading
; text tile patterns overwrites half of the sprite tile pattern data.
; Note on notation:
; x#SPRITESTATEDATA1_* and x#SPRITESTATEDATA2_* are used to denote wSpriteStateData1 and
; wSpriteStateData2 sprite slot, respectively, within loops. The X is the loop index.
; If there is an inner loop, Y is the inner loop index, i.e. y#SPRITESTATEDATA1_* and
; y#SPRITESTATEDATA2_* denote fields of the sprite slots iterated over in the inner loop.
InitMapSprites:
	call InitOutsideMapSprites
	ret c ; return if the map is an outside map (already handled by above call)
; if the map is an inside map (i.e. mapID >= FIRST_INDOOR_MAP)
	ld hl, wSpritePlayerStateData1PictureID
	ld de, wSpritePlayerStateData2PictureID
; Loop to copy picture IDs from [x#SPRITESTATEDATA1_PICTUREID]
; to [x#SPRITESTATEDATA2_PICTUREID] for LoadMapSpriteTilePatterns.
InitMapSprites.copyPictureIDLoop
	ld a, [hl] ; a = [x#SPRITESTATEDATA1_PICTUREID]
	ld [de], a ; [x#SPRITESTATEDATA2_PICTUREID] = a
	ld a, SPRITESTATEDATA1_LENGTH
	add e
	ld e, a
	ld a, SPRITESTATEDATA1_LENGTH
	add l
	ld l, a
	jr nz, InitMapSprites.copyPictureIDLoop

; This is used for both inside and outside maps, since it is called by
; InitOutsideMapSprites.
; Loads tile pattern data for sprites into VRAM.
LoadMapSpriteTilePatterns:
	ld a, [wNumSprites]
	and a ; are there any sprites?
	jr nz, LoadMapSpriteTilePatterns.spritesExist
	ret
LoadMapSpriteTilePatterns.spritesExist
	ld c, a ; c = [wNumSprites]
	ld b, NUM_SPRITESTATEDATA_STRUCTS
	ld hl, wSpritePlayerStateData2PictureID
	xor a
	ldh [lobyte(hFourTileSpriteCount)], a
; Loop to copy picture IDs from [x#SPRITESTATEDATA2_PICTUREID]
; to [x#SPRITESTATEDATA2_IMAGEBASEOFFSET].
LoadMapSpriteTilePatterns.copyPictureIDLoop
	ld a, [hli] ; a = [x#SPRITESTATEDATA2_PICTUREID]
	ld [hld], a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET] = a
	ld a, l
	add SPRITESTATEDATA1_LENGTH
	ld l, a
	dec b
	jr nz, LoadMapSpriteTilePatterns.copyPictureIDLoop
	ld hl, wSprite01StateData2ImageBaseOffset
LoadMapSpriteTilePatterns.loadTilePatternLoop
	ld de, wSprite01StateData2PictureID
; Check if the current picture ID has already had its tile patterns loaded.
; This done by looping through the previous sprite slots and seeing if any of
; their picture ID's match that of the current sprite slot.
LoadMapSpriteTilePatterns.checkIfAlreadyLoadedLoop
	ld a, e
	and $f0
	ld b, a ; b = offset of the wSpriteStateData2 sprite slot being checked against
	ld a, l
	and $f0 ; a = offset of current wSpriteStateData2 sprite slot
	cp b ; done checking all previous sprite slots?
	jr z, LoadMapSpriteTilePatterns.notAlreadyLoaded
	ld a, [de] ; picture ID of the wSpriteStateData2 sprite slot being checked against
	cp [hl] ; do the picture ID's match?
	jp z, LoadMapSpriteTilePatterns.alreadyLoaded
	ld a, e
	add SPRITESTATEDATA1_LENGTH
	ld e, a
	jr LoadMapSpriteTilePatterns.checkIfAlreadyLoadedLoop
LoadMapSpriteTilePatterns.notAlreadyLoaded
	ld de, wSpritePlayerStateData2ImageBaseOffset
	ld b, 1
; loop to find the highest tile pattern VRAM slot (among the first 10 slots) used by a previous sprite slot
; this is done in order to find the first free VRAM slot available
LoadMapSpriteTilePatterns.findNextVRAMSlotLoop
	ld a, e
	add SPRITESTATEDATA1_LENGTH
	ld e, a
	ld a, l
	cp e ; reached current slot?
	jr z, LoadMapSpriteTilePatterns.foundNextVRAMSlot
	ld a, [de] ; y#SPRITESTATEDATA2_IMAGEBASEOFFSET
	cp 11 ; is it one of the first 10 slots?
	jr nc, LoadMapSpriteTilePatterns.findNextVRAMSlotLoop
	cp b ; compare the slot being checked to the current max
	jr c, LoadMapSpriteTilePatterns.findNextVRAMSlotLoop ; if the slot being checked is less than the current max
; if the slot being checked is greater than or equal to the current max
	ld b, a ; store new max VRAM slot
	jr LoadMapSpriteTilePatterns.findNextVRAMSlotLoop
LoadMapSpriteTilePatterns.foundNextVRAMSlot
	inc b ; increment previous max value to get next VRAM tile pattern slot
	ld a, b ; a = next VRAM tile pattern slot
	push af
	ld a, [hl] ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ld b, a ; b = current sprite picture ID
	cp FIRST_STILL_SPRITE ; is it a 4-tile sprite?
	jr c, LoadMapSpriteTilePatterns.notFourTileSprite
	pop af
	ldh a, [lobyte(hFourTileSpriteCount)]
	add 11
	jr LoadMapSpriteTilePatterns.storeVRAMSlot
LoadMapSpriteTilePatterns.notFourTileSprite
	pop af
LoadMapSpriteTilePatterns.storeVRAMSlot
	ld [hl], a ; store VRAM slot at [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ldh [lobyte(hVRAMSlot)], a ; used to determine if it's 4-tile sprite later
	ld a, b ; a = current sprite picture ID
	dec a
	add a
	add a
	push bc
	push hl
	ld hl, SpriteSheetPointerTable
	jr nc, LoadMapSpriteTilePatterns.noCarry
	inc h
LoadMapSpriteTilePatterns.noCarry
	add l
	ld l, a
	jr nc, LoadMapSpriteTilePatterns.noCarry2
	inc h
LoadMapSpriteTilePatterns.noCarry2
	push hl
	call ReadSpriteSheetData
	push af
	push de
	push bc
	ld hl, vNPCSprites ; VRAM base address
	ld bc, 12 * TILE_SIZE ; number of bytes per VRAM slot
	ldh a, [lobyte(hVRAMSlot)]
	cp 11 ; is it a 4-tile sprite?
	jr nc, LoadMapSpriteTilePatterns.fourTileSpriteVRAMAddr
	ld d, a
	dec d
; hl = vSprites + [hVRAMSlot] * 12 * TILE_SIZE
LoadMapSpriteTilePatterns.calculateVRAMAddrLoop
	add hl, bc
	dec d
	jr nz, LoadMapSpriteTilePatterns.calculateVRAMAddrLoop
	jr LoadMapSpriteTilePatterns.loadStillTilePattern
LoadMapSpriteTilePatterns.fourTileSpriteVRAMAddr
	ld hl, vSprites + TILE_SIZE * $7c ; address for second 4-tile sprite
	ldh a, [lobyte(hFourTileSpriteCount)]
	and a
	jr nz, LoadMapSpriteTilePatterns.loadStillTilePattern
; if it's the first 4-tile sprite
	ld hl, vSprites + TILE_SIZE * $78 ; address for first 4-tile sprite
	inc a
	ldh [lobyte(hFourTileSpriteCount)], a
LoadMapSpriteTilePatterns.loadStillTilePattern
	pop bc
	pop de
	pop af
	push hl
	push hl
	ld h, d
	ld l, e
	pop de
	ld b, a
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a ; reloading upper half of tile patterns after displaying text?
	jr nz, LoadMapSpriteTilePatterns.skipFirstLoad ; if so, skip loading data into the lower half
	ld a, b
	ld b, 0
	call FarCopyData2 ; load tile pattern data for sprite when standing still
LoadMapSpriteTilePatterns.skipFirstLoad
	pop de
	pop hl
	ldh a, [lobyte(hVRAMSlot)]
	cp 11 ; is it a 4-tile sprite?
	jr nc, LoadMapSpriteTilePatterns.skipSecondLoad ; if so, there is no second block
	push de
	call ReadSpriteSheetData
	push af
	ld a, $c0
	add e
	ld e, a
	jr nc, LoadMapSpriteTilePatterns.noCarry3
	inc d
LoadMapSpriteTilePatterns.noCarry3
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a ; reloading upper half of tile patterns after displaying text?
	jr nz, LoadMapSpriteTilePatterns.loadWhileLCDOn
	pop af
	pop hl
	set 3, h ; add $800 ($80 * TILE_SIZE) to hl (1 << 3 = $8)
	push hl
	ld h, d
	ld l, e
	pop de
	call FarCopyData2 ; load tile pattern data for sprite when walking
	jr LoadMapSpriteTilePatterns.skipSecondLoad
; When reloading the upper half of tile patterns after displaying text, the LCD
; will be on, so CopyVideoData (which writes to VRAM only during V-blank) must
; be used instead of FarCopyData2.
LoadMapSpriteTilePatterns.loadWhileLCDOn
	pop af
	pop hl
	set 3, h ; add $800 ($80 * TILE_SIZE) to hl (1 << 3 = $8)
	ld b, a
	swap c
	call CopyVideoData ; load tile pattern data for sprite when walking
LoadMapSpriteTilePatterns.skipSecondLoad
	pop hl
	pop bc
	jr LoadMapSpriteTilePatterns.nextSpriteSlot
LoadMapSpriteTilePatterns.alreadyLoaded ; if the current picture ID has already had its tile patterns loaded
	inc de
	ld a, [de] ; a = [y#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ld [hl], a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET] = a
LoadMapSpriteTilePatterns.nextSpriteSlot
	ld a, l
	add SPRITESTATEDATA2_LENGTH
	ld l, a
	dec c
	jp nz, LoadMapSpriteTilePatterns.loadTilePatternLoop
	ld hl, wSpritePlayerStateData2PictureID
	ld b, NUM_SPRITESTATEDATA_STRUCTS
; the pictures IDs stored at [x#SPRITESTATEDATA2_PICTUREID] are no longer needed,
; so zero them
LoadMapSpriteTilePatterns.zeroStoredPictureIDLoop
	xor a
	ld [hl], a ; [x#SPRITESTATEDATA2_PICTUREID]
	ld a, SPRITESTATEDATA2_LENGTH
	add l
	ld l, a
	dec b
	jr nz, LoadMapSpriteTilePatterns.zeroStoredPictureIDLoop
	ret

; reads data from SpriteSheetPointerTable
; INPUT:
; hl = address of sprite sheet entry
; OUTPUT:
; de = pointer to sprite sheet
; bc = length in bytes
; a = ROM bank
ReadSpriteSheetData:
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	xor a
	ld b, a
	ld a, [hli]
	ret

; Loads sprite set for outside maps (cities and routes) and sets VRAM slots.
; sets carry if the map is a city or route, unsets carry if not
InitOutsideMapSprites:
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP ; is the map a city or a route?
	ret nc ; if not, return
	ld hl, MapSpriteSets
	add l
	ld l, a
	jr nc, InitOutsideMapSprites.noCarry
	inc h
InitOutsideMapSprites.noCarry
	ld a, [hl] ; a = spriteSetID
	cp FIRST_SPLIT_SET - 1 ; does the map have 2 sprite sets?
	call nc, GetSplitMapSpriteSetID ; if so, choose the appropriate one
	ld b, a ; b = spriteSetID
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a ; reloading upper half of tile patterns after displaying text?
	jr nz, InitOutsideMapSprites.loadSpriteSet ; if so, forcibly reload the sprite set
	ld a, [wSpriteSetID]
	cp b ; has the sprite set ID changed?
	jr z, InitOutsideMapSprites.skipLoadingSpriteSet ; if not, don't load it again
InitOutsideMapSprites.loadSpriteSet
	ld a, b
	ld [wSpriteSetID], a
	dec a
	ld b, a
	sla a
	ld c, a
	sla a
	sla a
	add c
	add b ; a = (spriteSetID - 1) * SPRITE_SET_LENGTH
	ld de, SpriteSets
; add a to de to get offset of sprite set
	add e
	ld e, a
	jr nc, InitOutsideMapSprites.noCarry2
	inc d
InitOutsideMapSprites.noCarry2
	ld hl, wSpritePlayerStateData2PictureID
	ld a, SPRITE_RED
	ld [hl], a
	ld bc, wSpriteSet
; Load the sprite set into RAM.
; This loop also fills [x#SPRITESTATEDATA2_PICTUREID] where X is from $0 to $A
; with picture IDs. This is done so that LoadMapSpriteTilePatterns will
; load tile patterns for all sprite pictures in the sprite set.
InitOutsideMapSprites.loadSpriteSetLoop
	ld a, SPRITESTATEDATA2_LENGTH
	add l
	ld l, a
	ld a, [de] ; sprite picture ID from sprite set
	ld [hl], a ; [x#SPRITESTATEDATA2_PICTUREID]
	ld [bc], a
	inc de
	inc bc
	ld a, l
	cp 11 * SPRITESTATEDATA2_LENGTH + SPRITESTATEDATA2_PICTUREID ; reached 11th sprite slot?
	jr nz, InitOutsideMapSprites.loadSpriteSetLoop
	ld b, 4 ; 4 remaining sprite slots
InitOutsideMapSprites.zeroRemainingSlotsLoop ; loop to zero the picture ID's of the remaining sprite slots
	ld a, SPRITESTATEDATA2_LENGTH
	add l
	ld l, a
	xor a
	ld [hl], a ; [x#SPRITESTATEDATA2_PICTUREID]
	dec b
	jr nz, InitOutsideMapSprites.zeroRemainingSlotsLoop
	ld a, [wNumSprites]
	push af ; save number of sprites
	ld a, SPRITE_SET_LENGTH ; 11 sprites in sprite set
	ld [wNumSprites], a
	call LoadMapSpriteTilePatterns
	pop af
	ld [wNumSprites], a ; restore number of sprites
	ld hl, wSprite01StateData2ImageBaseOffset
	ld b, NUM_SPRITESTATEDATA_STRUCTS - 1
; The VRAM tile pattern slots that LoadMapSpriteTilePatterns set are in the
; order of the map's sprite set, not the order of the actual sprites loaded
; for the current map. So, they are not needed and are zeroed by this loop.
InitOutsideMapSprites.zeroVRAMSlotsLoop
	xor a
	ld [hl], a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ld a, SPRITESTATEDATA2_LENGTH
	add l
	ld l, a
	dec b
	jr nz, InitOutsideMapSprites.zeroVRAMSlotsLoop
InitOutsideMapSprites.skipLoadingSpriteSet
	ld hl, wSprite01StateData1
; This loop stores the correct VRAM tile pattern slots according the sprite
; data from the map's header. Since the VRAM tile pattern slots are filled in
; the order of the sprite set, in order to find the VRAM tile pattern slot
; for a sprite slot, the picture ID for the sprite is looked up within the
; sprite set. The index of the picture ID within the sprite set plus one
; (since the Red sprite always has the first VRAM tile pattern slot) is the
; VRAM tile pattern slot.
InitOutsideMapSprites.storeVRAMSlotsLoop
	ld c, 0
	ld a, [hl] ; [x#SPRITESTATEDATA1_PICTUREID] (zero if sprite slot is not used)
	and a ; is the sprite slot used?
	jr z, InitOutsideMapSprites.skipGettingPictureIndex ; if the sprite slot is not used
	ld b, a ; b = picture ID
	ld de, wSpriteSet
; Loop to find the index of the sprite's picture ID within the sprite set.
InitOutsideMapSprites.getPictureIndexLoop
	inc c
	ld a, [de]
	inc de
	cp b ; does the picture ID match?
	jr nz, InitOutsideMapSprites.getPictureIndexLoop
	inc c
InitOutsideMapSprites.skipGettingPictureIndex
	push hl
	inc h ; hibyte(wSpriteStateData2)
	ld a, SPRITESTATEDATA2_IMAGEBASEOFFSET - SPRITESTATEDATA1_PICTUREID
	add l
	ld l, a
	ld a, c ; a = VRAM slot (zero if sprite slot is not used)
	ld [hl], a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	pop hl
	ld a, SPRITESTATEDATA1_LENGTH
	add l
	ld l, a
	and a
	jr nz, InitOutsideMapSprites.storeVRAMSlotsLoop
	scf
	ret

; Chooses the correct sprite set ID depending on the player's position within
; the map for maps with two sprite sets.
GetSplitMapSpriteSetID:
	cp SPLITSET_ROUTE_20
	jr z, GetSplitMapSpriteSetID.route20
	ld hl, SplitMapSpriteSets
	and $0f
	dec a
	sla a
	sla a
	add l
	ld l, a
	jr nc, GetSplitMapSpriteSetID.noCarry
	inc h
GetSplitMapSpriteSetID.noCarry
	ld a, [hli] ; whether the map is split EAST_WEST or NORTH_SOUTH
	cp EAST_WEST
	ld a, [hli] ; position of dividing line
	ld b, a
	jr z, GetSplitMapSpriteSetID.eastWestDivide
GetSplitMapSpriteSetID.northSouthDivide
	ld a, [wYCoord]
	jr GetSplitMapSpriteSetID.compareCoord
GetSplitMapSpriteSetID.eastWestDivide
	ld a, [wXCoord]
GetSplitMapSpriteSetID.compareCoord
	cp b
	jr c, GetSplitMapSpriteSetID.loadSpriteSetID
; if in the east side or south side
	inc hl
GetSplitMapSpriteSetID.loadSpriteSetID
	ld a, [hl]
	ret
; Uses sprite set SPRITESET_PALLET_VIRIDIAN for west side and SPRITESET_FUCHSIA for east side.
; Route 20 is a special case because the two map sections have a more complex
; shape instead of the map simply being split horizontally or vertically.
GetSplitMapSpriteSetID.route20
	ld hl, wXCoord
	; Use SPRITESET_PALLET_VIRIDIAN if X < 43
	ld a, [hl]
	cp 43
	ld a, SPRITESET_PALLET_VIRIDIAN
	ret c
	; Use SPRITESET_FUCHSIA if X >= 62.
	ld a, [hl]
	cp 62
	ld a, SPRITESET_FUCHSIA
	ret nc
	; If 55 <= X < 62, split Y at 8; else 43 <= X < 55, so split Y at 13
	ld a, [hl]
	cp 55
	ld b, 8
	jr nc, GetSplitMapSpriteSetID.next
	ld b, 13
GetSplitMapSpriteSetID.next
	; Use SPRITESET_FUCHSIA if Y < split; else use SPRITESET_PALLET_VIRIDIAN
	ld a, [wYCoord]
	cp b
	ld a, SPRITESET_FUCHSIA
	ret c
	ld a, SPRITESET_PALLET_VIRIDIAN
	ret

.INCLUDE "data/maps/sprite_sets.asm"

.INCLUDE "data/sprites/sprites.asm"
