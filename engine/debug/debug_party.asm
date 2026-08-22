SetDebugNewGameParty: ; unreferenced except in _DEBUG
	ld de, DebugNewGameParty
SetDebugNewGameParty.loop
	ld a, [de]
	cp -1
	ret z
	ld [wCurPartySpecies], a
	inc de
	ld a, [de]
	ld [wCurEnemyLevel], a
	inc de
	call AddPartyMon
	jr SetDebugNewGameParty.loop

DebugNewGameParty: ; unreferenced except in _DEBUG
	; Exeggutor is the only debug party member shared with Red, Green, and Japanese Blue.
	; "Tsunekazu Ishihara: Exeggutor is my favorite. That's because I was
	; always using this character while I was debugging the program."
	; From https://web.archive.org/web/20000607152840/http://pocket.ign.com/news/14973.html
	.DB EXEGGUTOR, 90
.IF defined(_DEBUG)
	.DB MEW, 5
.ELSE
	.DB MEW, 20
.ENDIF
	.DB JOLTEON, 56
	.DB DUGTRIO, 56
	.DB ARTICUNO, 57
.IF defined(_DEBUG)
	.DB PIKACHU, 5
.ENDIF
	.DB -1 ; end

PrepareNewGameDebug: ; dummy except in _DEBUG
.IF defined(_DEBUG)
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a

	; Fly anywhere.
	dec a ; $ff (all bits)
	ld [wTownVisitedFlag], a
	ld [wTownVisitedFlag + 1], a

	; Get all badges except Earth Badge.
	ld a, ~(1 << BIT_EARTHBADGE)
	ld [wObtainedBadges], a

	call SetDebugNewGameParty

	; Exeggutor gets four HM moves.
	ld hl, wPartyMon1Moves
	ld a, FLY
	ld [hli], a
	ld a, CUT
	ld [hli], a
	ld a, SURF
	ld [hli], a
	ld a, STRENGTH
	ld [hl], a
	ld hl, wPartyMon1PP
	ld a, 15
	ld [hli], a
	ld a, 30
	ld [hli], a
	ld a, 15
	ld [hli], a
	ld [hl], a

	; Jolteon gets Thunderbolt.
	ld hl, wPartyMon3Moves + 3
	ld a, THUNDERBOLT
	ld [hl], a
	ld hl, wPartyMon3PP + 3
	ld a, 15
	ld [hl], a

	; Articuno gets Fly.
	ld hl, wPartyMon5Moves
	ld a, FLY
	ld [hl], a
	ld hl, wPartyMon5PP
	ld a, 15
	ld [hl], a

	; Pikachu gets Surf.
	ld hl, wPartyMon6Moves + 2
	ld a, SURF
	ld [hl], a
	ld hl, wPartyMon6PP + 2
	ld a, 15
	ld [hl], a

	; Get some debug items.
	ld hl, wNumBagItems
	ld de, DebugNewGameItemsList
PrepareNewGameDebug.items_loop
	ld a, [de]
	cp -1
	jr z, PrepareNewGameDebug.items_end
	ld [wCurItem], a
	inc de
	ld a, [de]
	inc de
	ld [wItemQuantity], a
	call AddItemToInventory
	jr PrepareNewGameDebug.items_loop
PrepareNewGameDebug.items_end

	; Complete the Pokédex.
	ld hl, wPokedexOwned
	call DebugSetPokedexEntries
	ld hl, wPokedexSeen
	call DebugSetPokedexEntries
	SetEvent EVENT_GOT_POKEDEX

	; Rival chose Squirtle,
	; Player chose Charmander.
	ld hl, wRivalStarter
	ld a, STARTER2
	ld [hli], a
	inc hl
	ld a, STARTER1
	ld [hl], a

	ret

DebugSetPokedexEntries:
.IF NUM_POKEMON / 8 > 0
	ld b, NUM_POKEMON / 8 ; 151 / 8 = 18
	ld a, %11111111
DebugSetPokedexEntries.loop
	ld [hli], a
	dec b
	jr nz, DebugSetPokedexEntries.loop
.ENDIF
.IF NUM_POKEMON # 8 > 0
	ld [hl], (1 << (NUM_POKEMON # 8)) - 1 ; (1 << 151 # 8)) - 1 = %01111111
.ENDIF
	ret

DebugNewGameItemsList:
	.DB BICYCLE, 1
	.DB FULL_RESTORE, 99
	.DB FULL_HEAL, 99
	.DB ESCAPE_ROPE, 99
	.DB RARE_CANDY, 99
	.DB MASTER_BALL, 99
	.DB TOWN_MAP, 1
	.DB SECRET_KEY, 1
	.DB CARD_KEY, 1
	.DB S_S_TICKET, 1
	.DB LIFT_KEY, 1
	.DB -1 ; end

DebugUnusedList: ; unreferenced
	.DB -1 ; end
.ELSE
	ret
.ENDIF
