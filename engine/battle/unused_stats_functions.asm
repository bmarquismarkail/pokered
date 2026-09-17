; does nothing since no stats are ever selected (barring glitches)
DoubleSelectedStats:
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld a, [wPlayerStatsToDouble]
	ld hl, wBattleMonAttack + 1
	jr z, DoubleSelectedStats.notEnemyTurn
	ld a, [wEnemyStatsToDouble]
	ld hl, wEnemyMonAttack + 1
DoubleSelectedStats.notEnemyTurn
	ld c, 4
	ld b, a
DoubleSelectedStats.loop
	srl b
	call c, DoubleSelectedStats.doubleStat
	inc hl
	inc hl
	dec c
	ret z
	jr DoubleSelectedStats.loop

DoubleSelectedStats.doubleStat
	ld a, [hl]
	add a
	ld [hld], a
	ld a, [hl]
	rl a
	ld [hli], a
	ret

; does nothing since no stats are ever selected (barring glitches)
HalveSelectedStats:
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld a, [wPlayerStatsToHalve]
	ld hl, wBattleMonAttack
	jr z, HalveSelectedStats.notEnemyTurn
	ld a, [wEnemyStatsToHalve]
	ld hl, wEnemyMonAttack
HalveSelectedStats.notEnemyTurn
	ld c, 4
	ld b, a
HalveSelectedStats.loop
	srl b
	call c, HalveSelectedStats.halveStat
	inc hl
	inc hl
	dec c
	ret z
	jr HalveSelectedStats.loop

HalveSelectedStats.halveStat
	ld a, [hl]
	srl a
	ld [hli], a
	rr [hl]
	or [hl]
	jr nz, HalveSelectedStats.nonzeroStat
	ld [hl], 1
HalveSelectedStats.nonzeroStat
	dec hl
	ret
