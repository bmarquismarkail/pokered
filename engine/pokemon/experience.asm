; calculates the level a mon should be based on its current exp
CalcLevelFromExperience:
	ld a, [wLoadedMonSpecies]
	ld [wCurSpecies], a
	call GetMonHeader
	ld d, $1 ; init level to 1
CalcLevelFromExperience.loop
	inc d ; increment level
	call CalcExperience
	push hl
	ld hl, wLoadedMonExp + 2 ; current exp
; compare exp needed for level d with current exp
	ldh a, [lobyte(hExperience + 2)]
	ld c, a
	ld a, [hld]
	sub c
	ldh a, [lobyte(hExperience + 1)]
	ld c, a
	ld a, [hld]
	sbc c
	ldh a, [lobyte(hExperience)]
	ld c, a
	ld a, [hl]
	sbc c
	pop hl
	jr nc, CalcLevelFromExperience.loop ; if exp needed for level d is not greater than exp, try the next level
	dec d ; since the exp was too high on the last loop iteration, go back to the previous value and return
	ret

; calculates the amount of experience needed for level d
CalcExperience:
	ld a, [wMonHGrowthRate]
	add a
	add a
	ld c, a
	ld b, 0
	ld hl, GrowthRateTable
	add hl, bc
	call CalcDSquared
	ld a, d
	ldh [lobyte(hMultiplier)], a
	call Multiply
	ld a, [hl]
	and $f0
	swap a
	ldh [lobyte(hMultiplier)], a
	call Multiply
	ld a, [hli]
	and $f
	ldh [lobyte(hDivisor)], a
	ld b, $4
	call Divide
	ldh a, [lobyte(hQuotient + 1)]
	push af
	ldh a, [lobyte(hQuotient + 2)]
	push af
	ldh a, [lobyte(hQuotient + 3)]
	push af
	call CalcDSquared
	ld a, [hl]
	and $7f
	ldh [lobyte(hMultiplier)], a
	call Multiply
	ldh a, [lobyte(hProduct + 1)]
	push af
	ldh a, [lobyte(hProduct + 2)]
	push af
	ldh a, [lobyte(hProduct + 3)]
	push af
	ld a, [hli]
	push af
	xor a
	ldh [lobyte(hMultiplicand)], a
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, d
	ldh [lobyte(hMultiplicand + 2)], a
	ld a, [hli]
	ldh [lobyte(hMultiplier)], a
	call Multiply
	ld b, [hl]
	ldh a, [lobyte(hProduct + 3)]
	sub b
	ldh [lobyte(hProduct + 3)], a
	ld b, $0
	ldh a, [lobyte(hProduct + 2)]
	sbc b
	ldh [lobyte(hProduct + 2)], a
	ldh a, [lobyte(hProduct + 1)]
	sbc b
	ldh [lobyte(hProduct + 1)], a
; The difference of the linear term and the constant term consists of 3 bytes
; starting at hProduct + 1. Below, hExperience (an alias of that address) will
; be used instead for the further work of adding or subtracting the squared
; term and adding the cubed term.
	pop af
	and $80
	jr nz, CalcExperience.subtractSquaredTerm ; check sign
	pop bc
	ldh a, [lobyte(hExperience + 2)]
	add b
	ldh [lobyte(hExperience + 2)], a
	pop bc
	ldh a, [lobyte(hExperience + 1)]
	adc b
	ldh [lobyte(hExperience + 1)], a
	pop bc
	ldh a, [lobyte(hExperience)]
	adc b
	ldh [lobyte(hExperience)], a
	jr CalcExperience.addCubedTerm
CalcExperience.subtractSquaredTerm
	pop bc
	ldh a, [lobyte(hExperience + 2)]
	sub b
	ldh [lobyte(hExperience + 2)], a
	pop bc
	ldh a, [lobyte(hExperience + 1)]
	sbc b
	ldh [lobyte(hExperience + 1)], a
	pop bc
	ldh a, [lobyte(hExperience)]
	sbc b
	ldh [lobyte(hExperience)], a
CalcExperience.addCubedTerm
	pop bc
	ldh a, [lobyte(hExperience + 2)]
	add b
	ldh [lobyte(hExperience + 2)], a
	pop bc
	ldh a, [lobyte(hExperience + 1)]
	adc b
	ldh [lobyte(hExperience + 1)], a
	pop bc
	ldh a, [lobyte(hExperience)]
	adc b
	ldh [lobyte(hExperience)], a
	ret

; calculates d*d
CalcDSquared:
	xor a
	ldh [lobyte(hMultiplicand)], a
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, d
	ldh [lobyte(hMultiplicand + 2)], a
	ldh [lobyte(hMultiplier)], a
	jp Multiply

.INCLUDE "data/growth_rates.asm"
