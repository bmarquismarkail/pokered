TransformEffect_:
	ld hl, wBattleMonSpecies
	ld de, wEnemyMonSpecies
	ld bc, wEnemyBattleStatus3
	; bug: on enemy's turn, a is overloaded with hWhoseTurn,
	; before the check for INVULNERABLE
	ld a, [wEnemyBattleStatus1]
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr nz, TransformEffect_.hitTest
; player's turn
	ld hl, wEnemyMonSpecies
	ld de, wBattleMonSpecies
	ld bc, wPlayerBattleStatus3
	ld [wPlayerMoveListIndex], a
	; bug: this should be target's BattleStatus1 (i.e. wEnemyBattleStatus1)
	ld a, [wPlayerBattleStatus1]
TransformEffect_.hitTest
	bit INVULNERABLE, a ; is mon invulnerable to typical attacks? (fly/dig)
	                    ; this check doesn't work due to above bugs
	jp nz, TransformEffect_.failed
	push hl
	push de
	push bc
	ld hl, wPlayerBattleStatus2
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, TransformEffect_.transformEffect
	ld hl, wEnemyBattleStatus2
TransformEffect_.transformEffect
; animation(s) played are different if target has Substitute up
	bit HAS_SUBSTITUTE_UP, [hl]
	push af
	ld hl, HideSubstituteShowMonAnim
	ld b, bank(HideSubstituteShowMonAnim)
	call nz, Bankswitch
	ld a, [wOptions]
	add a
	ld hl, PlayCurrentMoveAnimation
	ld b, bank(PlayCurrentMoveAnimation)
	jr nc, TransformEffect_.gotAnimToPlay
	ld hl, AnimationTransformMon
	ld b, bank(AnimationTransformMon)
TransformEffect_.gotAnimToPlay
	call Bankswitch
	ld hl, ReshowSubstituteAnim
	ld b, bank(ReshowSubstituteAnim)
	pop af
	call nz, Bankswitch
	pop bc
	ld a, [bc]
	set TRANSFORMED, a ; mon is now transformed
	ld [bc], a
	pop de
	pop hl
	push hl
; transform user into opposing Pokemon
; species
	ld a, [hl]
	ld [de], a
; type 1, type 2, catch rate, and moves
	ld bc, $5
	add hl, bc
	inc de
	inc de
	inc de
	inc de
	inc de
	inc bc
	inc bc
	call CopyData
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, TransformEffect_.next
; save enemy mon DVs at wTransformedEnemyMonOriginalDVs
	ld a, [de]
	ld [wTransformedEnemyMonOriginalDVs], a
	inc de
	ld a, [de]
	ld [wTransformedEnemyMonOriginalDVs + 1], a
	dec de
TransformEffect_.next
; DVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
; Skip level and max HP
	inc hl
	inc hl
	inc hl
	inc de
	inc de
	inc de
; Attack, Defense, Speed, and Special stats
	ld bc, (NUM_STATS - 1) * 2
	call CopyData
	ld bc, wBattleMonMoves - wBattleMonPP
	add hl, bc ; ld hl, wBattleMonMoves
	ld b, NUM_MOVES
TransformEffect_.copyPPLoop
; 5 PP for all moves
	ld a, [hli]
	and a
	jr z, TransformEffect_.lessThanFourMoves
	ld a, 5
	ld [de], a
	inc de
	dec b
	jr nz, TransformEffect_.copyPPLoop
	jr TransformEffect_.copyStats
TransformEffect_.lessThanFourMoves
; 0 PP for blank moves
	xor a
	ld [de], a
	inc de
	dec b
	jr nz, TransformEffect_.lessThanFourMoves
TransformEffect_.copyStats
; original (unmodified) stats and stat mods
	pop hl
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetMonName
	ld hl, wEnemyMonUnmodifiedAttack
	ld de, wPlayerMonUnmodifiedAttack
	call TransformEffect_.copyBasedOnTurn ; original (unmodified) stats
	ld hl, wEnemyMonStatMods
	ld de, wPlayerMonStatMods
	call TransformEffect_.copyBasedOnTurn ; stat mods
	ld hl, TransformedText
	jp PrintText

TransformEffect_.copyBasedOnTurn
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, TransformEffect_.gotStatsOrModsToCopy
	push hl
	ld h, d
	ld l, e
	pop de
TransformEffect_.gotStatsOrModsToCopy
	ld bc, (NUM_STATS - 1) * 2
	jp CopyData

TransformEffect_.failed
	ld hl, PrintButItFailedText_
	jp EffectCallBattleCore

TransformedText:
	text_far WLA_GLOBAL_TransformedText
	text_end
