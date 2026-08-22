LoadMonData_:
; Load monster [wWhichPokemon] from list [wMonDataLocation]:
;  0: partymon
;  1: enemymon
;  2: boxmon
;  3: daycaremon
; Return monster id at wCurPartySpecies and its data at wLoadedMon.
; Also load base stats at wMonHeader for convenience.

	ld a, [wDayCareMonSpecies]
	ld [wCurPartySpecies], a
	ld a, [wMonDataLocation]
	cp DAYCARE_DATA
	jr z, LoadMonData_.GetMonHeader

	ld a, [wWhichPokemon]
	ld e, a
	callfar GetMonSpecies

LoadMonData_.GetMonHeader
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetMonHeader

	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wMonDataLocation]
	cp ENEMY_PARTY_DATA
	jr c, LoadMonData_.getMonEntry

	ld hl, wEnemyMons
	jr z, LoadMonData_.getMonEntry

	cp BOX_DATA
	ld hl, wBoxMons
	ld bc, BOXMON_STRUCT_LENGTH
	jr z, LoadMonData_.getMonEntry

	ld hl, wDayCareMon
	jr LoadMonData_.copyMonData

LoadMonData_.getMonEntry
	ld a, [wWhichPokemon]
	call AddNTimes

LoadMonData_.copyMonData
	ld de, wLoadedMon
	ld bc, PARTYMON_STRUCT_LENGTH
	jp CopyData
