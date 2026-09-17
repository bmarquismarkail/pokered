; formats a string at wMovesString that lists the moves at wMoves
FormatMovesString:
	ld hl, wMoves
	ld de, wMovesString
	ld b, $0
FormatMovesString.printMoveNameLoop
	ld a, [hli]
	and a ; end of move list?
	jr z, FormatMovesString.printDashLoop ; print dashes when no moves are left
	push hl
	ld [wNameListIndex], a
	ld a, bank(MoveNames)
	ld [wPredefBank], a
	ld a, MOVE_NAME
	ld [wNameListType], a
	call GetName
	ld hl, wNameBuffer
FormatMovesString.copyNameLoop
	ld a, [hli]
	cp $50
	jr z, FormatMovesString.doneCopyingName
	ld [de], a
	inc de
	jr FormatMovesString.copyNameLoop
FormatMovesString.doneCopyingName
	ld a, b
	ld [wNumMovesMinusOne], a
	inc b
	ld a, $4e
	ld [de], a
	inc de
	pop hl
	ld a, b
	cp NUM_MOVES
	jr z, FormatMovesString.done
	jr FormatMovesString.printMoveNameLoop
FormatMovesString.printDashLoop
	ld a, $e3
	ld [de], a
	inc de
	inc b
	ld a, b
	cp NUM_MOVES
	jr z, FormatMovesString.done
	ld a, $4e
	ld [de], a
	inc de
	jr FormatMovesString.printDashLoop
FormatMovesString.done
	ld a, $50
	ld [de], a
	ret

; XXX this is called in a few places, but it doesn't appear to do anything useful
InitList:
	ld a, [wInitListType]
	cp INIT_ENEMYOT_LIST
	jr nz, InitList.notEnemy
	ld hl, wEnemyPartyCount
	ld de, wEnemyMonOT
	ld a, ENEMYOT_NAME
	jr InitList.done
InitList.notEnemy
	cp INIT_PLAYEROT_LIST
	jr nz, InitList.notPlayer
	ld hl, wPartyCount
	ld de, wPartyMonOT
	ld a, PLAYEROT_NAME
	jr InitList.done
InitList.notPlayer
	cp INIT_MON_LIST
	jr nz, InitList.notMonster
	ld hl, wItemList
	ld de, MonsterNames
	ld a, MONSTER_NAME
	jr InitList.done
InitList.notMonster
	cp INIT_BAG_ITEM_LIST
	jr nz, InitList.notBag
	ld hl, wNumBagItems
	ld de, ItemNames
	ld a, ITEM_NAME
	jr InitList.done
InitList.notBag
	ld hl, wItemList
	ld de, ItemNames
	ld a, ITEM_NAME
InitList.done
	ld [wNameListType], a
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	ld a, e
	ld [wUnusedNamePointer], a
	ld a, d
	ld [wUnusedNamePointer + 1], a
	ld bc, ItemPrices
	ld a, c
	ld [wItemPrices], a
	ld a, b
	ld [wItemPrices + 1], a
	ret

; get species of mon e in list [wMonDataLocation] for LoadMonData
GetMonSpecies:
	ld hl, wPartySpecies
	ld a, [wMonDataLocation]
	and a
	jr z, GetMonSpecies.getSpecies
	dec a
	jr z, GetMonSpecies.enemyParty
	ld hl, wBoxSpecies
	jr GetMonSpecies.getSpecies
GetMonSpecies.enemyParty
	ld hl, wEnemyPartySpecies
GetMonSpecies.getSpecies
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [wCurPartySpecies], a
	ret
