; try to initiate a wild pokemon encounter
; returns success in Z
TryDoWildEncounter:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, [wMovementFlags]
	and a ; is player exiting a door, jumping over a ledge, or fishing?
	ret nz
	callfar IsPlayerStandingOnDoorTileOrWarpTile
	jr nc, TryDoWildEncounter.notStandingOnDoorOrWarpTile
TryDoWildEncounter.CantEncounter
	ld a, $1
	and a
	ret
TryDoWildEncounter.notStandingOnDoorOrWarpTile
	callfar IsPlayerJustOutsideMap
	jr z, TryDoWildEncounter.CantEncounter
	ld a, [wRepelRemainingSteps]
	and a
	jr z, TryDoWildEncounter.next
	dec a
	jr z, TryDoWildEncounter.lastRepelStep
	ld [wRepelRemainingSteps], a
TryDoWildEncounter.next
; determine if wild pokemon can appear in the half-block we're standing in
; is the bottom right tile (9,9) of the half-block we're standing in a grass/water tile?
	hlcoord 9, 9
	ld c, [hl]
	ld a, [wGrassTile]
	cp c
	ld a, [wGrassRate]
	jr z, TryDoWildEncounter.CanEncounter
	ld a, $14 ; in all tilesets with a water tile, this is its id
	cp c
	ld a, [wWaterRate]
	jr z, TryDoWildEncounter.CanEncounter
; even if not in grass/water, standing anywhere we can encounter pokemon
; so long as the map is "indoor" and has wild pokemon defined.
; ...as long as it's not Viridian Forest or Safari Zone.
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP ; is this an indoor map?
	jr c, TryDoWildEncounter.CantEncounter2
	ld a, [wCurMapTileset]
	cp FOREST ; Viridian Forest/Safari Zone
	jr z, TryDoWildEncounter.CantEncounter2
	ld a, [wGrassRate]
TryDoWildEncounter.CanEncounter
; compare encounter chance with a random number to determine if there will be an encounter
	ld b, a
	ldh a, [lobyte(hRandomAdd)]
	cp b
	jr nc, TryDoWildEncounter.CantEncounter2
	ldh a, [lobyte(hRandomSub)]
	ld b, a
	ld hl, WildMonEncounterSlotChances
TryDoWildEncounter.determineEncounterSlot
	ld a, [hli]
	cp b
	jr nc, TryDoWildEncounter.gotEncounterSlot
	inc hl
	jr TryDoWildEncounter.determineEncounterSlot
TryDoWildEncounter.gotEncounterSlot
; determine which wild pokemon (grass or water) can appear in the half-block we're standing in
	ld c, [hl]
	ld hl, wGrassMons
	lda_coord 8, 9
	cp $14 ; is the bottom left tile (8,9) of the half-block we're standing in a water tile?
	jr nz, TryDoWildEncounter.gotWildEncounterType ; else, it's treated as a grass tile by default
	ld hl, wWaterMons
; since the bottom right tile of a "left shore" half-block is $14 but the bottom left tile is not,
; "left shore" half-blocks (such as the one in the east coast of Cinnabar) load grass encounters.
TryDoWildEncounter.gotWildEncounterType
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld [wCurEnemyLevel], a
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [wEnemyMonSpecies2], a
	ld a, [wRepelRemainingSteps]
	and a
	jr z, TryDoWildEncounter.willEncounter
	ld a, [wPartyMon1Level]
	ld b, a
	ld a, [wCurEnemyLevel]
	cp b
	jr c, TryDoWildEncounter.CantEncounter2 ; repel prevents encounters if the leading party mon's level is higher than the wild mon
	jr TryDoWildEncounter.willEncounter
TryDoWildEncounter.lastRepelStep
	ld [wRepelRemainingSteps], a
	ld a, TEXT_REPEL_WORE_OFF
	ldh [lobyte(hTextID)], a
	call EnableAutoTextBoxDrawing
	call DisplayTextID
TryDoWildEncounter.CantEncounter2
	ld a, $1
	and a
	ret
TryDoWildEncounter.willEncounter
	xor a
	ret

.INCLUDE "data/wild/probabilities.asm"
