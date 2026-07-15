; Native WLA-DX form of engine/gfx/load_pokedex_tiles.asm, engine/overworld/map_sprites.asm, engine/overworld/emotion_bubbles.asm, engine/events/evolve_trade.asm, engine/battle/move_effects/substitute.asm, engine/menus/pc.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"
; Loads tile patterns for tiles used in the pokedex.
LoadPokedexTilePatterns:
	call LoadHpBarAndStatusTilePatterns
	ld de, PokedexTileGraphics
	ld hl, vChars2 + ($60) * 16
	ld bc, (($04) << 8) | ((PokedexTileGraphicsEnd - PokedexTileGraphics) / TILE_SIZE)
	call CopyVideoData
	ld de, PokeballTileGraphics
	ld hl, vChars2 + ($72) * 16
	ld bc, (($0e) << 8) | (1)
	jp CopyVideoData ; load pokeball tile for marking caught mons
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
InitMapSprites.copyPictureIDLoop:
	ld a, (hl) ; a = [x#SPRITESTATEDATA1_PICTUREID]
	ld (de), a ; [x#SPRITESTATEDATA2_PICTUREID] = a
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
	ld a, (wNumSprites)
	and a ; are there any sprites?
	jr nz, LoadMapSpriteTilePatterns.spritesExist
	ret
LoadMapSpriteTilePatterns.spritesExist:
	ld c, a ; c = [wNumSprites]
	ld b, NUM_SPRITESTATEDATA_STRUCTS
	ld hl, wSpritePlayerStateData2PictureID
	xor a
	ldh (hFourTileSpriteCount - $FF00), a
; Loop to copy picture IDs from [x#SPRITESTATEDATA2_PICTUREID]
; to [x#SPRITESTATEDATA2_IMAGEBASEOFFSET].
LoadMapSpriteTilePatterns.copyPictureIDLoop:
	ld a, (HL+) ; a = [x#SPRITESTATEDATA2_PICTUREID]
	ld (HL-), a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET] = a
	ld a, l
	add SPRITESTATEDATA1_LENGTH
	ld l, a
	dec b
	jr nz, LoadMapSpriteTilePatterns.copyPictureIDLoop
	ld hl, wSprite01StateData2ImageBaseOffset
LoadMapSpriteTilePatterns.loadTilePatternLoop:
	ld de, wSprite01StateData2PictureID
; Check if the current picture ID has already had its tile patterns loaded.
; This done by looping through the previous sprite slots and seeing if any of
; their picture ID's match that of the current sprite slot.
LoadMapSpriteTilePatterns.checkIfAlreadyLoadedLoop:
	ld a, e
	and $f0
	ld b, a ; b = offset of the wSpriteStateData2 sprite slot being checked against
	ld a, l
	and $f0 ; a = offset of current wSpriteStateData2 sprite slot
	cp b ; done checking all previous sprite slots?
	jr z, LoadMapSpriteTilePatterns.notAlreadyLoaded
	ld a, (de) ; picture ID of the wSpriteStateData2 sprite slot being checked against
	cp (hl) ; do the picture ID's match?
	jp z, LoadMapSpriteTilePatterns.alreadyLoaded
	ld a, e
	add SPRITESTATEDATA1_LENGTH
	ld e, a
	jr LoadMapSpriteTilePatterns.checkIfAlreadyLoadedLoop
LoadMapSpriteTilePatterns.notAlreadyLoaded:
	ld de, wSpritePlayerStateData2ImageBaseOffset
	ld b, 1
; loop to find the highest tile pattern VRAM slot (among the first 10 slots) used by a previous sprite slot
; this is done in order to find the first free VRAM slot available
LoadMapSpriteTilePatterns.findNextVRAMSlotLoop:
	ld a, e
	add SPRITESTATEDATA1_LENGTH
	ld e, a
	ld a, l
	cp e ; reached current slot?
	jr z, LoadMapSpriteTilePatterns.foundNextVRAMSlot
	ld a, (de) ; y#SPRITESTATEDATA2_IMAGEBASEOFFSET
	cp 11 ; is it one of the first 10 slots?
	jr nc, LoadMapSpriteTilePatterns.findNextVRAMSlotLoop
	cp b ; compare the slot being checked to the current max
	jr c, LoadMapSpriteTilePatterns.findNextVRAMSlotLoop ; if the slot being checked is less than the current max
; if the slot being checked is greater than or equal to the current max
	ld b, a ; store new max VRAM slot
	jr LoadMapSpriteTilePatterns.findNextVRAMSlotLoop
LoadMapSpriteTilePatterns.foundNextVRAMSlot:
	inc b ; increment previous max value to get next VRAM tile pattern slot
	ld a, b ; a = next VRAM tile pattern slot
	push af
	ld a, (hl) ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ld b, a ; b = current sprite picture ID
	cp FIRST_STILL_SPRITE ; is it a 4-tile sprite?
	jr c, LoadMapSpriteTilePatterns.notFourTileSprite
	pop af
	ldh a, (hFourTileSpriteCount - $FF00)
	add 11
	jr LoadMapSpriteTilePatterns.storeVRAMSlot
LoadMapSpriteTilePatterns.notFourTileSprite:
	pop af
LoadMapSpriteTilePatterns.storeVRAMSlot:
	ld (hl), a ; store VRAM slot at [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ldh (hVRAMSlot - $FF00), a ; used to determine if it's 4-tile sprite later
	ld a, b ; a = current sprite picture ID
	dec a
	add a
	add a
	push bc
	push hl
	ld hl, SpriteSheetPointerTable
	jr nc, LoadMapSpriteTilePatterns.noCarry
	inc h
LoadMapSpriteTilePatterns.noCarry:
	add l
	ld l, a
	jr nc, LoadMapSpriteTilePatterns.noCarry2
	inc h
LoadMapSpriteTilePatterns.noCarry2:
	push hl
	call ReadSpriteSheetData
	push af
	push de
	push bc
	ld hl, vNPCSprites ; VRAM base address
	ld bc, (12 * 16) ; number of bytes per VRAM slot
	ldh a, (hVRAMSlot - $FF00)
	cp 11 ; is it a 4-tile sprite?
	jr nc, LoadMapSpriteTilePatterns.fourTileSpriteVRAMAddr
	ld d, a
	dec d
; hl = vSprites + [hVRAMSlot] * 12 tiles
LoadMapSpriteTilePatterns.calculateVRAMAddrLoop:
	add hl, bc
	dec d
	jr nz, LoadMapSpriteTilePatterns.calculateVRAMAddrLoop
	jr LoadMapSpriteTilePatterns.loadStillTilePattern
LoadMapSpriteTilePatterns.fourTileSpriteVRAMAddr:
	ld hl, vSprites + ($7c) * 16 ; address for second 4-tile sprite
	ldh a, (hFourTileSpriteCount - $FF00)
	and a
	jr nz, LoadMapSpriteTilePatterns.loadStillTilePattern
; if it's the first 4-tile sprite
	ld hl, vSprites + ($78) * 16 ; address for first 4-tile sprite
	inc a
	ldh (hFourTileSpriteCount - $FF00), a
LoadMapSpriteTilePatterns.loadStillTilePattern:
	pop bc
	pop de
	pop af
	push hl
	push hl
	ld h, d
	ld l, e
	pop de
	ld b, a
	ld a, (wFontLoaded)
	bit BIT_FONT_LOADED, a ; reloading upper half of tile patterns after displaying text?
	jr nz, LoadMapSpriteTilePatterns.skipFirstLoad ; if so, skip loading data into the lower half
	ld a, b
	ld b, 0
	call FarCopyData2 ; load tile pattern data for sprite when standing still
LoadMapSpriteTilePatterns.skipFirstLoad:
	pop de
	pop hl
	ldh a, (hVRAMSlot - $FF00)
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
LoadMapSpriteTilePatterns.noCarry3:
	ld a, (wFontLoaded)
	bit BIT_FONT_LOADED, a ; reloading upper half of tile patterns after displaying text?
	jr nz, LoadMapSpriteTilePatterns.loadWhileLCDOn
	pop af
	pop hl
	set 3, h ; add $800 ($80 tiles) to hl (1 << 3 == $8)
	push hl
	ld h, d
	ld l, e
	pop de
	call FarCopyData2 ; load tile pattern data for sprite when walking
	jr LoadMapSpriteTilePatterns.skipSecondLoad
; When reloading the upper half of tile patterns after displaying text, the LCD
; will be on, so CopyVideoData (which writes to VRAM only during V-blank) must
; be used instead of FarCopyData2.
LoadMapSpriteTilePatterns.loadWhileLCDOn:
	pop af
	pop hl
	set 3, h ; add $800 ($80 tiles) to hl (1 << 3 == $8)
	ld b, a
	swap c
	call CopyVideoData ; load tile pattern data for sprite when walking
LoadMapSpriteTilePatterns.skipSecondLoad:
	pop hl
	pop bc
	jr LoadMapSpriteTilePatterns.nextSpriteSlot
LoadMapSpriteTilePatterns.alreadyLoaded: ; if the current picture ID has already had its tile patterns loaded
	inc de
	ld a, (de) ; a = [y#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ld (hl), a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET] = a
LoadMapSpriteTilePatterns.nextSpriteSlot:
	ld a, l
	add SPRITESTATEDATA2_LENGTH
	ld l, a
	dec c
	jp nz, LoadMapSpriteTilePatterns.loadTilePatternLoop
	ld hl, wSpritePlayerStateData2PictureID
	ld b, NUM_SPRITESTATEDATA_STRUCTS
; the pictures IDs stored at [x#SPRITESTATEDATA2_PICTUREID] are no longer needed,
; so zero them
LoadMapSpriteTilePatterns.zeroStoredPictureIDLoop:
	xor a
	ld (hl), a ; [x#SPRITESTATEDATA2_PICTUREID]
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
	ld a, (HL+)
	ld e, a
	ld a, (HL+)
	ld d, a
	ld a, (HL+)
	ld c, a
	xor a
	ld b, a
	ld a, (HL+)
	ret

; Loads sprite set for outside maps (cities and routes) and sets VRAM slots.
; sets carry if the map is a city or route, unsets carry if not
InitOutsideMapSprites:
	ld a, (wCurMap)
	cp FIRST_INDOOR_MAP ; is the map a city or a route?
	ret nc ; if not, return
	ld hl, MapSpriteSets
	add l
	ld l, a
	jr nc, InitOutsideMapSprites.noCarry
	inc h
InitOutsideMapSprites.noCarry:
	ld a, (hl) ; a = spriteSetID
	cp FIRST_SPLIT_SET - 1 ; does the map have 2 sprite sets?
	call nc, GetSplitMapSpriteSetID ; if so, choose the appropriate one
	ld b, a ; b = spriteSetID
	ld a, (wFontLoaded)
	bit BIT_FONT_LOADED, a ; reloading upper half of tile patterns after displaying text?
	jr nz, InitOutsideMapSprites.loadSpriteSet ; if so, forcibly reload the sprite set
	ld a, (wSpriteSetID)
	cp b ; has the sprite set ID changed?
	jr z, InitOutsideMapSprites.skipLoadingSpriteSet ; if not, don't load it again
InitOutsideMapSprites.loadSpriteSet:
	ld a, b
	ld (wSpriteSetID), a
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
InitOutsideMapSprites.noCarry2:
	ld hl, wSpritePlayerStateData2PictureID
	ld a, SPRITE_RED
	ld (hl), a
	ld bc, wSpriteSet
; Load the sprite set into RAM.
; This loop also fills [x#SPRITESTATEDATA2_PICTUREID] where X is from $0 to $A
; with picture IDs. This is done so that LoadMapSpriteTilePatterns will
; load tile patterns for all sprite pictures in the sprite set.
InitOutsideMapSprites.loadSpriteSetLoop:
	ld a, SPRITESTATEDATA2_LENGTH
	add l
	ld l, a
	ld a, (de) ; sprite picture ID from sprite set
	ld (hl), a ; [x#SPRITESTATEDATA2_PICTUREID]
	ld (bc), a
	inc de
	inc bc
	ld a, l
	cp 11 * SPRITESTATEDATA2_LENGTH + SPRITESTATEDATA2_PICTUREID ; reached 11th sprite slot?
	jr nz, InitOutsideMapSprites.loadSpriteSetLoop
	ld b, 4 ; 4 remaining sprite slots
InitOutsideMapSprites.zeroRemainingSlotsLoop: ; loop to zero the picture ID's of the remaining sprite slots
	ld a, SPRITESTATEDATA2_LENGTH
	add l
	ld l, a
	xor a
	ld (hl), a ; [x#SPRITESTATEDATA2_PICTUREID]
	dec b
	jr nz, InitOutsideMapSprites.zeroRemainingSlotsLoop
	ld a, (wNumSprites)
	push af ; save number of sprites
	ld a, SPRITE_SET_LENGTH ; 11 sprites in sprite set
	ld (wNumSprites), a
	call LoadMapSpriteTilePatterns
	pop af
	ld (wNumSprites), a ; restore number of sprites
	ld hl, wSprite01StateData2ImageBaseOffset
	ld b, NUM_SPRITESTATEDATA_STRUCTS - 1
; The VRAM tile pattern slots that LoadMapSpriteTilePatterns set are in the
; order of the map's sprite set, not the order of the actual sprites loaded
; for the current map. So, they are not needed and are zeroed by this loop.
InitOutsideMapSprites.zeroVRAMSlotsLoop:
	xor a
	ld (hl), a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
	ld a, SPRITESTATEDATA2_LENGTH
	add l
	ld l, a
	dec b
	jr nz, InitOutsideMapSprites.zeroVRAMSlotsLoop
InitOutsideMapSprites.skipLoadingSpriteSet:
	ld hl, wSprite01StateData1
; This loop stores the correct VRAM tile pattern slots according the sprite
; data from the map's header. Since the VRAM tile pattern slots are filled in
; the order of the sprite set, in order to find the VRAM tile pattern slot
; for a sprite slot, the picture ID for the sprite is looked up within the
; sprite set. The index of the picture ID within the sprite set plus one
; (since the Red sprite always has the first VRAM tile pattern slot) is the
; VRAM tile pattern slot.
InitOutsideMapSprites.storeVRAMSlotsLoop:
	ld c, 0
	ld a, (hl) ; [x#SPRITESTATEDATA1_PICTUREID] (zero if sprite slot is not used)
	and a ; is the sprite slot used?
	jr z, InitOutsideMapSprites.skipGettingPictureIndex ; if the sprite slot is not used
	ld b, a ; b = picture ID
	ld de, wSpriteSet
; Loop to find the index of the sprite's picture ID within the sprite set.
InitOutsideMapSprites.getPictureIndexLoop:
	inc c
	ld a, (de)
	inc de
	cp b ; does the picture ID match?
	jr nz, InitOutsideMapSprites.getPictureIndexLoop
	inc c
InitOutsideMapSprites.skipGettingPictureIndex:
	push hl
	inc h ; HIGH(wSpriteStateData2)
	ld a, SPRITESTATEDATA2_IMAGEBASEOFFSET - SPRITESTATEDATA1_PICTUREID
	add l
	ld l, a
	ld a, c ; a = VRAM slot (zero if sprite slot is not used)
	ld (hl), a ; [x#SPRITESTATEDATA2_IMAGEBASEOFFSET]
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
GetSplitMapSpriteSetID.noCarry:
	ld a, (HL+) ; whether the map is split EAST_WEST or NORTH_SOUTH
	cp EAST_WEST
	ld a, (HL+) ; position of dividing line
	ld b, a
	jr z, GetSplitMapSpriteSetID.eastWestDivide
GetSplitMapSpriteSetID.northSouthDivide:
	ld a, (wYCoord)
	jr GetSplitMapSpriteSetID.compareCoord
GetSplitMapSpriteSetID.eastWestDivide:
	ld a, (wXCoord)
GetSplitMapSpriteSetID.compareCoord:
	cp b
	jr c, GetSplitMapSpriteSetID.loadSpriteSetID
; if in the east side or south side
	inc hl
GetSplitMapSpriteSetID.loadSpriteSetID:
	ld a, (hl)
	ret
; Uses sprite set SPRITESET_PALLET_VIRIDIAN for west side and SPRITESET_FUCHSIA for east side.
; Route 20 is a special case because the two map sections have a more complex
; shape instead of the map simply being split horizontally or vertically.
GetSplitMapSpriteSetID.route20:
	ld hl, wXCoord
	; Use SPRITESET_PALLET_VIRIDIAN if X < 43
	ld a, (hl)
	cp 43
	ld a, SPRITESET_PALLET_VIRIDIAN
	ret c
	; Use SPRITESET_FUCHSIA if X >= 62.
	ld a, (hl)
	cp 62
	ld a, SPRITESET_FUCHSIA
	ret nc
	; If 55 <= X < 62, split Y at 8; else 43 <= X < 55, so split Y at 13
	ld a, (hl)
	cp 55
	ld b, 8
	jr nc, GetSplitMapSpriteSetID.next
	ld b, 13
GetSplitMapSpriteSetID.next:
	; Use SPRITESET_FUCHSIA if Y < split; else use SPRITESET_PALLET_VIRIDIAN
	ld a, (wYCoord)
	cp b
	ld a, SPRITESET_FUCHSIA
	ret c
	ld a, SPRITESET_PALLET_VIRIDIAN
	ret

; Valid sprite IDs for each outdoor map.

MapSpriteSets:
; table_width 1
	.DB SPRITESET_PALLET_VIRIDIAN ; PALLET_TOWN
	.DB SPRITESET_PALLET_VIRIDIAN ; VIRIDIAN_CITY
	.DB SPRITESET_PEWTER_CERULEAN ; PEWTER_CITY
	.DB SPRITESET_PEWTER_CERULEAN ; CERULEAN_CITY
	.DB SPRITESET_LAVENDER ; LAVENDER_TOWN
	.DB SPRITESET_VERMILION ; VERMILION_CITY
	.DB SPRITESET_CELADON ; CELADON_CITY
	.DB SPRITESET_FUCHSIA ; FUCHSIA_CITY
	.DB SPRITESET_PALLET_VIRIDIAN ; CINNABAR_ISLAND
	.DB SPRITESET_INDIGO ; INDIGO_PLATEAU
	.DB SPRITESET_SAFFRON ; SAFFRON_CITY
	.DB SPRITESET_PALLET_VIRIDIAN ; UNUSED_MAP_0B
	.DB SPRITESET_PALLET_VIRIDIAN ; ROUTE_1
	.DB SPLITSET_ROUTE_2 ; ROUTE_2
	.DB SPRITESET_PEWTER_CERULEAN ; ROUTE_3
	.DB SPRITESET_PEWTER_CERULEAN ; ROUTE_4
	.DB SPLITSET_ROUTE_5 ; ROUTE_5
	.DB SPLITSET_ROUTE_6 ; ROUTE_6
	.DB SPLITSET_ROUTE_7 ; ROUTE_7
	.DB SPLITSET_ROUTE_8 ; ROUTE_8
	.DB SPRITESET_PEWTER_CERULEAN ; ROUTE_9
	.DB SPLITSET_ROUTE_10 ; ROUTE_10
	.DB SPLITSET_ROUTE_11 ; ROUTE_11
	.DB SPLITSET_ROUTE_12 ; ROUTE_12
	.DB SPRITESET_SILENCE_BRIDGE ; ROUTE_13
	.DB SPRITESET_SILENCE_BRIDGE ; ROUTE_14
	.DB SPLITSET_ROUTE_15 ; ROUTE_15
	.DB SPLITSET_ROUTE_16 ; ROUTE_16
	.DB SPRITESET_CYCLING_ROAD ; ROUTE_17
	.DB SPLITSET_ROUTE_18 ; ROUTE_18
	.DB SPRITESET_FUCHSIA ; ROUTE_19
	.DB SPLITSET_ROUTE_20 ; ROUTE_20
	.DB SPRITESET_PALLET_VIRIDIAN ; ROUTE_21
	.DB SPRITESET_PALLET_VIRIDIAN ; ROUTE_22
	.DB SPRITESET_INDIGO ; ROUTE_23
	.DB SPRITESET_PEWTER_CERULEAN ; ROUTE_24
	.DB SPRITESET_PEWTER_CERULEAN ; ROUTE_25
; assert_table_length FIRST_INDOOR_MAP

; Format:
; #1: whether the map is split EAST_WEST or NORTH_SOUTH
; #2: coordinate of dividing line
; #3: sprite set ID if on the west or north side
; #4: sprite set ID if on the east or south side
SplitMapSpriteSets:
; table_width 4
	.DB NORTH_SOUTH, 37, SPRITESET_PEWTER_CERULEAN, SPRITESET_PALLET_VIRIDIAN ; SPLITSET_ROUTE_2
	.DB NORTH_SOUTH, 50, SPRITESET_PEWTER_CERULEAN, SPRITESET_LAVENDER ; SPLITSET_ROUTE_10
	.DB EAST_WEST,   57, SPRITESET_VERMILION,       SPRITESET_SILENCE_BRIDGE ; SPLITSET_ROUTE_11
	.DB NORTH_SOUTH, 21, SPRITESET_LAVENDER,        SPRITESET_SILENCE_BRIDGE ; SPLITSET_ROUTE_12
	.DB EAST_WEST,    8, SPRITESET_FUCHSIA,         SPRITESET_SILENCE_BRIDGE ; SPLITSET_ROUTE_15
	.DB EAST_WEST,   24, SPRITESET_CYCLING_ROAD,    SPRITESET_CELADON ; SPLITSET_ROUTE_16
	.DB EAST_WEST,   34, SPRITESET_CYCLING_ROAD,    SPRITESET_FUCHSIA ; SPLITSET_ROUTE_18
	.DB EAST_WEST,   53, SPRITESET_PALLET_VIRIDIAN, SPRITESET_FUCHSIA ; SPLITSET_ROUTE_20
	.DB NORTH_SOUTH, 33, SPRITESET_PEWTER_CERULEAN, SPRITESET_SAFFRON ; SPLITSET_ROUTE_5
	.DB NORTH_SOUTH,  2, SPRITESET_SAFFRON,         SPRITESET_VERMILION ; SPLITSET_ROUTE_6
	.DB EAST_WEST,   17, SPRITESET_CELADON,         SPRITESET_SAFFRON ; SPLITSET_ROUTE_7
	.DB EAST_WEST,    3, SPRITESET_SAFFRON,         SPRITESET_LAVENDER ; SPLITSET_ROUTE_8
; assert_table_length NUM_SPLIT_SETS

SpriteSets:
; table_width SPRITE_SET_LENGTH

; SPRITESET_PALLET_VIRIDIAN
	.DB SPRITE_BLUE
	.DB SPRITE_YOUNGSTER
	.DB SPRITE_GIRL
	.DB SPRITE_FISHER
	.DB SPRITE_COOLTRAINER_M
	.DB SPRITE_GAMBLER
	.DB SPRITE_SEEL
	.DB SPRITE_OAK
	.DB SPRITE_SWIMMER
	.DB SPRITE_POKE_BALL
	.DB SPRITE_GAMBLER_ASLEEP

; SPRITESET_PEWTER_CERULEAN
	.DB SPRITE_YOUNGSTER
	.DB SPRITE_ROCKET
	.DB SPRITE_SUPER_NERD
	.DB SPRITE_HIKER
	.DB SPRITE_MONSTER
	.DB SPRITE_BLUE
	.DB SPRITE_GUARD
	.DB SPRITE_COOLTRAINER_F
	.DB SPRITE_COOLTRAINER_M
	.DB SPRITE_POKE_BALL
	.DB SPRITE_UNUSED_GAMBLER_ASLEEP_2

; SPRITESET_LAVENDER
	.DB SPRITE_LITTLE_GIRL
	.DB SPRITE_GIRL
	.DB SPRITE_SUPER_NERD
	.DB SPRITE_HIKER
	.DB SPRITE_GAMBLER
	.DB SPRITE_MONSTER
	.DB SPRITE_COOLTRAINER_F
	.DB SPRITE_COOLTRAINER_M
	.DB SPRITE_GUARD
	.DB SPRITE_POKE_BALL
	.DB SPRITE_UNUSED_GAMBLER_ASLEEP_2

; SPRITESET_VERMILION
	.DB SPRITE_BEAUTY
	.DB SPRITE_SUPER_NERD
	.DB SPRITE_YOUNGSTER
	.DB SPRITE_GAMBLER
	.DB SPRITE_MONSTER
	.DB SPRITE_GUARD
	.DB SPRITE_SAILOR
	.DB SPRITE_COOLTRAINER_F
	.DB SPRITE_COOLTRAINER_M
	.DB SPRITE_POKE_BALL
	.DB SPRITE_UNUSED_GAMBLER_ASLEEP_2

; SPRITESET_CELADON
	.DB SPRITE_LITTLE_GIRL
	.DB SPRITE_LITTLE_BOY
	.DB SPRITE_GIRL
	.DB SPRITE_FISHER
	.DB SPRITE_MIDDLE_AGED_MAN
	.DB SPRITE_GRAMPS
	.DB SPRITE_MONSTER
	.DB SPRITE_GUARD
	.DB SPRITE_ROCKET
	.DB SPRITE_POKE_BALL
	.DB SPRITE_SNORLAX

; SPRITESET_INDIGO
	.DB SPRITE_YOUNGSTER
	.DB SPRITE_GYM_GUIDE
	.DB SPRITE_MONSTER
	.DB SPRITE_BLUE
	.DB SPRITE_COOLTRAINER_F
	.DB SPRITE_COOLTRAINER_M
	.DB SPRITE_SWIMMER
	.DB SPRITE_GUARD
	.DB SPRITE_GAMBLER
	.DB SPRITE_POKE_BALL
	.DB SPRITE_UNUSED_GAMBLER_ASLEEP_2

; SPRITESET_SAFFRON
	.DB SPRITE_ROCKET
	.DB SPRITE_SCIENTIST
	.DB SPRITE_SILPH_WORKER_M
	.DB SPRITE_SILPH_WORKER_F
	.DB SPRITE_GENTLEMAN
	.DB SPRITE_BIRD
	.DB SPRITE_ROCKER
	.DB SPRITE_COOLTRAINER_M
	.DB SPRITE_MONSTER
	.DB SPRITE_POKE_BALL
	.DB SPRITE_UNUSED_GAMBLER_ASLEEP_2

; SPRITESET_SILENCE_BRIDGE
	.DB SPRITE_BIKER
	.DB SPRITE_SUPER_NERD
	.DB SPRITE_MIDDLE_AGED_MAN
	.DB SPRITE_COOLTRAINER_F
	.DB SPRITE_COOLTRAINER_M
	.DB SPRITE_BEAUTY
	.DB SPRITE_FISHER
	.DB SPRITE_ROCKER
	.DB SPRITE_MONSTER
	.DB SPRITE_POKE_BALL
	.DB SPRITE_SNORLAX

; SPRITESET_CYCLING_ROAD
	.DB SPRITE_BIKER
	.DB SPRITE_COOLTRAINER_M
	.DB SPRITE_SILPH_WORKER_M
	.DB SPRITE_FISHER
	.DB SPRITE_ROCKER
	.DB SPRITE_HIKER
	.DB SPRITE_GAMBLER
	.DB SPRITE_MIDDLE_AGED_MAN
	.DB SPRITE_SUPER_NERD
	.DB SPRITE_POKE_BALL
	.DB SPRITE_SNORLAX

; SPRITESET_FUCHSIA
	.DB SPRITE_BIRD
	.DB SPRITE_COOLTRAINER_M
	.DB SPRITE_FAIRY
	.DB SPRITE_FISHER
	.DB SPRITE_GAMBLER
	.DB SPRITE_MONSTER
	.DB SPRITE_SEEL
	.DB SPRITE_SWIMMER
	.DB SPRITE_YOUNGSTER
	.DB SPRITE_POKE_BALL
	.DB SPRITE_FOSSIL

; assert_table_length NUM_SPRITE_SETS


SpriteSheetPointerTable:
; table_width 4
	; graphics, tile count
	.DW $4180
	.DB 12 * 16, $05 ; SPRITE_RED
	.DW $4300
	.DB 12 * 16, $05 ; SPRITE_BLUE
	.DW $4480
	.DB 12 * 16, $05 ; SPRITE_OAK
	.DW $4600
	.DB 12 * 16, $05 ; SPRITE_YOUNGSTER
	.DW $4780
	.DB 12 * 16, $05 ; SPRITE_MONSTER
	.DW $4900
	.DB 12 * 16, $05 ; SPRITE_COOLTRAINER_F
	.DW $4a80
	.DB 12 * 16, $05 ; SPRITE_COOLTRAINER_M
	.DW $4c00
	.DB 12 * 16, $05 ; SPRITE_LITTLE_GIRL
	.DW $4d80
	.DB 12 * 16, $05 ; SPRITE_BIRD
	.DW $4f00
	.DB 12 * 16, $05 ; SPRITE_MIDDLE_AGED_MAN
	.DW $5080
	.DB 12 * 16, $05 ; SPRITE_GAMBLER
	.DW $5200
	.DB 12 * 16, $05 ; SPRITE_SUPER_NERD
	.DW $5380
	.DB 12 * 16, $05 ; SPRITE_GIRL
	.DW $5500
	.DB 12 * 16, $05 ; SPRITE_HIKER
	.DW $5680
	.DB 12 * 16, $05 ; SPRITE_BEAUTY
	.DW $5800
	.DB 12 * 16, $05 ; SPRITE_GENTLEMAN
	.DW $5980
	.DB 12 * 16, $05 ; SPRITE_DAISY
	.DW $5b00
	.DB 12 * 16, $05 ; SPRITE_BIKER
	.DW $5c80
	.DB 12 * 16, $05 ; SPRITE_SAILOR
	.DW $5e00
	.DB 12 * 16, $05 ; SPRITE_COOK
	.DW $5f80
	.DB 12 * 16, $05 ; SPRITE_BIKE_SHOP_CLERK
	.DW $6040
	.DB 12 * 16, $05 ; SPRITE_MR_FUJI
	.DW $61c0
	.DB 12 * 16, $05 ; SPRITE_GIOVANNI
	.DW $6340
	.DB 12 * 16, $05 ; SPRITE_ROCKET
	.DW $64c0
	.DB 12 * 16, $05 ; SPRITE_CHANNELER
	.DW $6640
	.DB 12 * 16, $05 ; SPRITE_WAITER
	.DW $67c0
	.DB 12 * 16, $05 ; SPRITE_SILPH_WORKER_F
	.DW $6940
	.DB 12 * 16, $05 ; SPRITE_MIDDLE_AGED_WOMAN
	.DW $6ac0
	.DB 12 * 16, $05 ; SPRITE_BRUNETTE_GIRL
	.DW $6c40
	.DB 12 * 16, $05 ; SPRITE_LANCE
	.DW $4000
	.DB 12 * 16, $04 ; SPRITE_UNUSED_SCIENTIST
	.DW $4000
	.DB 12 * 16, $04 ; SPRITE_SCIENTIST
	.DW $4180
	.DB 12 * 16, $04 ; SPRITE_ROCKER
	.DW $4300
	.DB 12 * 16, $04 ; SPRITE_SWIMMER
	.DW $4480
	.DB 12 * 16, $04 ; SPRITE_SAFARI_ZONE_WORKER
	.DW $4540
	.DB 12 * 16, $04 ; SPRITE_GYM_GUIDE
	.DW $4600
	.DB 12 * 16, $04 ; SPRITE_GRAMPS
	.DW $46c0
	.DB 12 * 16, $04 ; SPRITE_CLERK
	.DW $4780
	.DB 12 * 16, $04 ; SPRITE_FISHING_GURU
	.DW $4840
	.DB 12 * 16, $04 ; SPRITE_GRANNY
	.DW $4900
	.DB 12 * 16, $04 ; SPRITE_NURSE
	.DW $49c0
	.DB 12 * 16, $04 ; SPRITE_LINK_RECEPTIONIST
	.DW $4a80
	.DB 12 * 16, $04 ; SPRITE_SILPH_PRESIDENT
	.DW $4b40
	.DB 12 * 16, $04 ; SPRITE_SILPH_WORKER_M
	.DW $4c00
	.DB 12 * 16, $04 ; SPRITE_WARDEN
	.DW $4cc0
	.DB 12 * 16, $04 ; SPRITE_CAPTAIN
	.DW $4d80
	.DB 12 * 16, $04 ; SPRITE_FISHER
	.DW $4f00
	.DB 12 * 16, $04 ; SPRITE_KOGA
	.DW $5080
	.DB 12 * 16, $04 ; SPRITE_GUARD
	.DW $5080
	.DB 12 * 16, $04 ; SPRITE_UNUSED_GUARD
	.DW $6dc0
	.DB 12 * 16, $05 ; SPRITE_MOM
	.DW $6e80
	.DB 12 * 16, $05 ; SPRITE_BALDING_GUY
	.DW $6f40
	.DB 12 * 16, $05 ; SPRITE_LITTLE_BOY
	.DW $7000
	.DB 12 * 16, $05 ; SPRITE_UNUSED_GAMEBOY_KID
	.DW $7000
	.DB 12 * 16, $05 ; SPRITE_GAMEBOY_KID
	.DW $70c0
	.DB 12 * 16, $05 ; SPRITE_FAIRY
	.DW $7240
	.DB 12 * 16, $05 ; SPRITE_AGATHA
	.DW $73c0
	.DB 12 * 16, $05 ; SPRITE_BRUNO
	.DW $7540
	.DB 12 * 16, $05 ; SPRITE_LORELEI
	.DW $76c0
	.DB 12 * 16, $05 ; SPRITE_SEEL
	.DW $5140
	.DB 4 * 16, $04 ; SPRITE_POKE_BALL
	.DW $5180
	.DB 4 * 16, $04 ; SPRITE_FOSSIL
	.DW $51c0
	.DB 4 * 16, $04 ; SPRITE_BOULDER
	.DW $5200
	.DB 4 * 16, $04 ; SPRITE_PAPER
	.DW $5240
	.DB 4 * 16, $04 ; SPRITE_POKEDEX
	.DW $5280
	.DB 4 * 16, $04 ; SPRITE_CLIPBOARD
	.DW $52c0
	.DB 4 * 16, $04 ; SPRITE_SNORLAX
	.DW $5300
	.DB 4 * 16, $04 ; SPRITE_UNUSED_OLD_AMBER
	.DW $5300
	.DB 4 * 16, $04 ; SPRITE_OLD_AMBER
	.DW $5340
	.DB 4 * 16, $04 ; SPRITE_UNUSED_GAMBLER_ASLEEP_1
	.DW $5340
	.DB 4 * 16, $04 ; SPRITE_UNUSED_GAMBLER_ASLEEP_2
	.DW $5340
	.DB 4 * 16, $04 ; SPRITE_GAMBLER_ASLEEP
; assert_table_length NUM_SPRITES
EmotionBubble:
	ld a, (wWhichEmotionBubble)
	ld c, a
	ld b, 0
	ld hl, EmotionBubblesPointerTable
	add hl, bc
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld hl, vChars1 + ($78) * 16
	ld bc, (($05) << 8) | (4)
	call CopyVideoData
	ld a, (wUpdateSpritesEnabled)
	push af
	ld a, $ff
	ld (wUpdateSpritesEnabled), a
	ld a, (wMovementFlags)
	bit BIT_LEDGE_OR_FISHING, a ; are the last 4 OAM entries reserved for a shadow or fishing rod?
	ld hl, wShadowOAMSprite35Attributes
	ld de, wShadowOAMSprite39Attributes
	jr z, EmotionBubble.next
	ld hl, wShadowOAMSprite31Attributes
	ld de, wShadowOAMSprite35Attributes

; Copy OAM data 16 bytes forward to make room for emotion bubble OAM data at the
; start of the OAM buffer.
EmotionBubble.next:
	ld bc, $90
EmotionBubble.loop:
	ld a, (hl)
	ld (de), a
	dec hl
	dec de
	dec bc
	ld a, c
	or b
	jr nz, EmotionBubble.loop

; get the screen coordinates of the sprite the bubble is to be displayed above
	ld hl, wSpritePlayerStateData1YPixels
	ld a, (wEmotionBubbleSpriteIndex)
	swap a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, (HL+)
	ld b, a
	inc hl
	ld a, (hl)
	add $8
	ld c, a

	ld de, EmotionBubblesOAMBlock
	xor a
	call WriteOAMBlock
	ld c, 60
	call DelayFrames
	pop af
	ld (wUpdateSpritesEnabled), a
	call DelayFrame
	jp UpdateSprites

EmotionBubblesPointerTable:
; entries correspond to *_BUBBLE constants
	.DW ShockEmote
	.DW QuestionEmote
	.DW HappyEmote

EmotionBubblesOAMBlock:
; tile ID, attributes
	.DB $f8, 0
	.DB $f9, 0
	.DB $fa, 0
	.DB $fb, 0

EmotionBubbles:
ShockEmote:
	.INCBIN "gfx/emotes/shock.2bpp"
QuestionEmote:
	.INCBIN "gfx/emotes/question.2bpp"
HappyEmote:
	.INCBIN "gfx/emotes/happy.2bpp"
InGameTrade_CheckForTradeEvo:
; In Japanese Blue, TradeMons include a Graveler and a Haunter,
; both of which have Japanese names that start with "ゴ",
; which is what this routine originally checked in that game.
; For English Red and Blue, this routine was adjusted for
; Graveler's English name and Haunter's early English name "Spectre".
; The final release replaced Graveler and Haunter in TradeMons.
	ld a, (wInGameTradeReceiveMonName)
	cp $86 ; GRAVELER
	jr z, InGameTrade_CheckForTradeEvo.nameMatched
	; "SPECTRE" (HAUNTER)
	cp $92
	ret nz
	ld a, (wInGameTradeReceiveMonName + 1)
	cp $8f
	ret nz
InGameTrade_CheckForTradeEvo.nameMatched:
	ld a, (wPartyCount)
	dec a
	ld (wWhichPokemon), a
	ld a, TRUE
	ld (wForceEvolution), a
	ld a, LINK_STATE_TRADING
	ld (wLinkState), a
	ld hl, $6d0e
	ld b, $0e
	call Bankswitch
	xor a ; LINK_STATE_NONE
	ld (wLinkState), a
	jp PlayDefaultMusic
SubstituteEffect_:
	ld c, 50
	call DelayFrames
	ld hl, wBattleMonMaxHP
	ld de, wPlayerSubstituteHP
	ld bc, wPlayerBattleStatus2
	ldh a, (hWhoseTurn - $FF00)
	and a
	jr z, SubstituteEffect_.notEnemy
	ld hl, wEnemyMonMaxHP
	ld de, wEnemySubstituteHP
	ld bc, wEnemyBattleStatus2
SubstituteEffect_.notEnemy:
	ld a, (bc)
	bit HAS_SUBSTITUTE_UP, a ; user already has substitute?
	jr nz, SubstituteEffect_.alreadyHasSubstitute
; quarter health to remove from user
; assumes max HP is 1023 or lower
	push bc
	ld a, (HL+)
	ld b, (hl)
	srl a
	rr b
	srl a
	rr b ; max hp / 4
	push de
	ld de, wBattleMonHP - wBattleMonMaxHP
	add hl, de ; point hl to current HP low byte
	pop de
	ld a, b
	ld (de), a ; save copy of HP to subtract in wPlayerSubstituteHP/wEnemySubstituteHP
	ld a, (HL-)
; subtract [max hp / 4] to current HP
	sub b
	ld d, a
	ld a, (hl)
	sbc 0
	pop bc
	jr c, SubstituteEffect_.notEnoughHP ; underflow means user would be left with negative health
                       ; bug: since it only branches on carry, it will possibly leave user with 0 HP
; user has 0 or more HP
	ld (HL+), a ; save resulting HP after subtraction into current HP
	ld (hl), d
	ld h, b
	ld l, c
	set HAS_SUBSTITUTE_UP, (hl)
	ld a, (wOptions)
	bit BIT_BATTLE_ANIMATION, a
	ld hl, PlayCurrentMoveAnimation
	ld b, $0f
	jr z, SubstituteEffect_.animationEnabled
	ld hl, AnimationSubstitute
	ld b, $1e
SubstituteEffect_.animationEnabled:
	call Bankswitch ; jump to routine depending on animation setting
	ld hl, SubstituteText
	call PrintText
	ld hl, $4d5a
	ld b, $0f
	jp Bankswitch
SubstituteEffect_.alreadyHasSubstitute:
	ld hl, HasSubstituteText
	jr SubstituteEffect_.printText
SubstituteEffect_.notEnoughHP:
	ld hl, TooWeakSubstituteText
SubstituteEffect_.printText:
	jp PrintText

SubstituteText:
	.DB $17
	.DW $492f
	.DB $25
	.DB $50

HasSubstituteText:
	.DB $17
	.DW $4949
	.DB $25
	.DB $50

TooWeakSubstituteText:
	.DB $17
	.DW $495e
	.DB $25
	.DB $50
ActivatePC:
	call SaveScreenTilesToBuffer2
	ld a, SFX_TURN_ON_PC
	call PlaySound
	ld hl, TurnedOnPC1Text
	call PrintText
	call WaitForSoundToFinish
	ld hl, wMiscFlags
	set BIT_USING_GENERIC_PC, (hl)
	call LoadScreenTilesFromBuffer2
	call Delay3
PCMainMenu:
	ld b, $08
	ld hl, $53c8
	call Bankswitch
	ld hl, wMiscFlags
	set BIT_NO_MENU_BUTTON_SOUND, (hl)
	call HandleMenuInput
	bit B_PAD_B, a
	jp nz, LogOff
	ld a, (wMaxMenuItem)
	cp 2
	jr nz, PCMainMenu.next ;if not 2 menu items (not counting log off) (2 occurs before you get the pokedex)
	ld a, (wCurrentMenuItem)
	and a
	jp z, BillsPC ;if current menu item id is 0, it's bills pc
	cp 1
	jr z, PCMainMenu.playersPC ;if current menu item id is 1, it's players pc
	jp LogOff ;otherwise, it's 2, and you're logging off
PCMainMenu.next:
	cp 3
	jr nz, PCMainMenu.next2 ;if not 3 menu items (not counting log off) (3 occurs after you get the pokedex, before you beat the pokemon league)
	ld a, (wCurrentMenuItem)
	and a
	jp z, BillsPC ;if current menu item id is 0, it's bills pc
	cp 1
	jr z, PCMainMenu.playersPC ;if current menu item id is 1, it's players pc
	cp 2
	jp z, OaksPC ;if current menu item id is 2, it's oaks pc
	jp LogOff ;otherwise, it's 3, and you're logging off
PCMainMenu.next2:
	ld a, (wCurrentMenuItem)
	and a
	jp z, BillsPC ;if current menu item id is 0, it's bills pc
	cp 1
	jr z, PCMainMenu.playersPC ;if current menu item id is 1, it's players pc
	cp 2
	jp z, OaksPC ;if current menu item id is 2, it's oaks pc
	cp 3
	jp z, PKMNLeague ;if current menu item id is 3, it's pkmnleague
	jp LogOff ;otherwise, it's 4, and you're logging off
PCMainMenu.playersPC:
	ld hl, wMiscFlags
	res BIT_NO_MENU_BUTTON_SOUND, (hl)
	set BIT_USING_GENERIC_PC, (hl)
	ld a, SFX_ENTER_PC
	call PlaySound
	call WaitForSoundToFinish
	ld hl, AccessedMyPCText
	call PrintText
	ld b, $01
	ld hl, $78e6
	call Bankswitch
	jr ReloadMainMenu
OaksPC:
	ld a, SFX_ENTER_PC
	call PlaySound
	call WaitForSoundToFinish
	ld b, $07
	ld hl, $6915
	call Bankswitch
	jr ReloadMainMenu
PKMNLeague:
	ld a, SFX_ENTER_PC
	call PlaySound
	call WaitForSoundToFinish
	ld b, $1d
	ld hl, $657e
	call Bankswitch
	jr ReloadMainMenu
BillsPC:
	ld a, SFX_ENTER_PC
	call PlaySound
	call WaitForSoundToFinish
	ld a, (wEventFlags + (EVENT_MET_BILL / 8))
	bit EVENT_MET_BILL & 7, a
	jr nz, BillsPC.billsPC ;if you've met bill, use that bill's instead of someone's
	ld hl, AccessedSomeonesPCText
	jr BillsPC.printText
BillsPC.billsPC:
	ld hl, AccessedBillsPCText
BillsPC.printText:
	call PrintText
	ld b, $08
	ld hl, $54c2
	call Bankswitch
ReloadMainMenu:
	xor a
	ld (wDoNotWaitForButtonPressAfterDisplayingText), a
	call ReloadMapData
	call UpdateSprites
	jp PCMainMenu
LogOff:
	ld a, SFX_TURN_OFF_PC
	call PlaySound
	call WaitForSoundToFinish
	ld hl, wMiscFlags
	res BIT_USING_GENERIC_PC, (hl)
	res BIT_NO_MENU_BUTTON_SOUND, (hl)
	ret

TurnedOnPC1Text:
	.DB $17
	.DW $5efe
	.DB $22
	.DB $50

AccessedBillsPCText:
	.DB $17
	.DW $5f13
	.DB $22
	.DB $50

AccessedSomeonesPCText:
	.DB $17
	.DW $5f45
	.DB $22
	.DB $50

AccessedMyPCText:
	.DB $17
	.DW $5f7a
	.DB $22
	.DB $50

; removes one of the specified item ID [hItemToRemoveID] from bag (if existent)
RemoveItemByID:
	ld hl, wBagItems
	ldh a, (hItemToRemoveID - $FF00)
	ld b, a
	xor a
	ldh (hItemToRemoveIndex - $FF00), a
RemoveItemByID.loop:
	ld a, (HL+)
	cp -1 ; reached terminator?
	ret z
	cp b
	jr z, RemoveItemByID.foundItem
	inc hl
	ldh a, (hItemToRemoveIndex - $FF00)
	inc a
	ldh (hItemToRemoveIndex - $FF00), a
	jr RemoveItemByID.loop
RemoveItemByID.foundItem:
	ld a, $1
	ld (wItemQuantity), a
	ldh a, (hItemToRemoveIndex - $FF00)
	ld (wWhichPokemon), a
	ld hl, wNumBagItems
	jp RemoveItemFromInventory
BattleEngine2End:
