PrintSafariZoneBattleText:
	ld hl, wSafariBaitFactor
	ld a, [hl]
	and a
	jr z, PrintSafariZoneBattleText.no_bait
	dec [hl]
	ld hl, SafariZoneEatingText
	jr PrintSafariZoneBattleText.done
PrintSafariZoneBattleText.no_bait
	dec hl
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ld hl, SafariZoneAngryText
	jr nz, PrintSafariZoneBattleText.done
	push hl
	ld a, [wEnemyMonSpecies]
	ld [wCurSpecies], a
	call GetMonHeader
	ld a, [wMonHCatchRate]
	ld [wEnemyMonActualCatchRate], a
	pop hl
PrintSafariZoneBattleText.done
	push hl
	call LoadScreenTilesFromBuffer1
	pop hl
	jp PrintText

SafariZoneEatingText:
	text_far WLA_GLOBAL_SafariZoneEatingText
	text_end

SafariZoneAngryText:
	text_far WLA_GLOBAL_SafariZoneAngryText
	text_end
