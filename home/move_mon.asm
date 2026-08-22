; Copies [hl, bc) to [de, de + bc - hl).
; In other words, the source data is from hl up to but not including bc,
; and the destination is de.
CopyDataUntil:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, h
	cp b
	jr nz, CopyDataUntil
	ld a, l
	cp c
	jr nz, CopyDataUntil
	ret

; Function to remove a pokemon from the party or the current box.
; wWhichPokemon determines the pokemon.
; [wRemoveMonFromBox] = 0 specifies the party.
; [wRemoveMonFromBox] != 0 specifies the current box.
RemovePokemon:
	jpfar WLA_GLOBAL_RemovePokemon

AddPartyMon:
	push hl
	push de
	push bc
	farcall WLA_GLOBAL_AddPartyMon
	pop bc
	pop de
	pop hl
	ret

; calculates all 5 stats of current mon and writes them to [de]
CalcStats:
	ld c, $0
CalcStats.statsLoop
	inc c
	call CalcStat
	ldh a, [lobyte(hMultiplicand+1)]
	ld [de], a
	inc de
	ldh a, [lobyte(hMultiplicand+2)]
	ld [de], a
	inc de
	ld a, c
	cp NUM_STATS
	jr nz, CalcStats.statsLoop
	ret

; calculates stat c of current mon
; c: stat to calc (HP=1,Atk=2,Def=3,Spd=4,Spc=5)
; b: consider stat exp?
; hl: base ptr to stat exp values ([hl + 2*c - 1] and [hl + 2*c])
CalcStat:
	push hl
	push de
	push bc
	ld a, b
	ld d, a
	push hl
	ld hl, wMonHeader
	ld b, $0
	add hl, bc
	ld a, [hl]          ; read base value of stat
	ld e, a
	pop hl
	push hl
	sla c
	ld a, d
	and a
	jr z, CalcStat.statExpDone  ; consider stat exp?
	add hl, bc          ; skip to corresponding stat exp value
CalcStat.statExpLoop            ; calculates ceil(Sqrt(stat exp)) in b
	xor a
	ldh [lobyte(hMultiplicand)], a
	ldh [lobyte(hMultiplicand+1)], a
	inc b               ; increment current stat exp bonus
	ld a, b
	cp $ff
	jr z, CalcStat.statExpDone
	ldh [lobyte(hMultiplicand+2)], a
	ldh [lobyte(hMultiplier)], a
	call Multiply
	ld a, [hld]
	ld d, a
	ldh a, [lobyte(hProduct + 3)]
	sub d
	ld a, [hli]
	ld d, a
	ldh a, [lobyte(hProduct + 2)]
	sbc d               ; test if (current stat exp bonus)^2 < stat exp
	jr c, CalcStat.statExpLoop
CalcStat.statExpDone
	srl c
	pop hl
	push bc
	ld bc, MON_DVS - (MON_HP_EXP - 1)
	add hl, bc
	pop bc
	ld a, c
	cp $2
	jr z, CalcStat.getAttackIV
	cp $3
	jr z, CalcStat.getDefenseIV
	cp $4
	jr z, CalcStat.getSpeedIV
	cp $5
	jr z, CalcStat.getSpecialIV
; get HP IV
	push bc
	ld a, [hl]  ; Atk IV
	swap a
	and $1
	sla a
	sla a
	sla a
	ld b, a
	ld a, [hli] ; Def IV
	and $1
	sla a
	sla a
	add b
	ld b, a
	ld a, [hl] ; Spd IV
	swap a
	and $1
	sla a
	add b
	ld b, a
	ld a, [hl] ; Spc IV
	and $1
	add b      ; HP IV: LSB of the other 4 IVs
	pop bc
	jr CalcStat.calcStatFromIV
CalcStat.getAttackIV
	ld a, [hl]
	swap a
	and $f
	jr CalcStat.calcStatFromIV
CalcStat.getDefenseIV
	ld a, [hl]
	and $f
	jr CalcStat.calcStatFromIV
CalcStat.getSpeedIV
	inc hl
	ld a, [hl]
	swap a
	and $f
	jr CalcStat.calcStatFromIV
CalcStat.getSpecialIV
	inc hl
	ld a, [hl]
	and $f
CalcStat.calcStatFromIV
	ld d, $0
	add e
	ld e, a
	jr nc, CalcStat.noCarry
	inc d                     ; de = Base + IV
CalcStat.noCarry
	sla e
	rl d                      ; de = (Base + IV) * 2
	srl b
	srl b                     ; b = ceil(Sqrt(stat exp)) / 4
	ld a, b
	add e
	jr nc, CalcStat.noCarry2
	inc d                     ; de = (Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4
CalcStat.noCarry2
	ldh [lobyte(hMultiplicand+2)], a
	ld a, d
	ldh [lobyte(hMultiplicand+1)], a
	xor a
	ldh [lobyte(hMultiplicand)], a
	ld a, [wCurEnemyLevel]
	ldh [lobyte(hMultiplier)], a
	call Multiply            ; ((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level
	ldh a, [lobyte(hMultiplicand)]
	ldh [lobyte(hDividend)], a
	ldh a, [lobyte(hMultiplicand+1)]
	ldh [lobyte(hDividend+1)], a
	ldh a, [lobyte(hMultiplicand+2)]
	ldh [lobyte(hDividend+2)], a
	ld a, $64
	ldh [lobyte(hDivisor)], a
	ld a, $3
	ld b, a
	call Divide             ; (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100
	ld a, c
	cp $1
	ld a, 5 ; + 5 for non-HP stat
	jr nz, CalcStat.notHPStat
	ld a, [wCurEnemyLevel]
	ld b, a
	ldh a, [lobyte(hMultiplicand+2)]
	add b
	ldh [lobyte(hMultiplicand+2)], a
	jr nc, CalcStat.noCarry3
	ldh a, [lobyte(hMultiplicand+1)]
	inc a
	ldh [lobyte(hMultiplicand+1)], a ; HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + Level
CalcStat.noCarry3
	ld a, 10 ; +10 for HP stat
CalcStat.notHPStat
	ld b, a
	ldh a, [lobyte(hMultiplicand+2)]
	add b
	ldh [lobyte(hMultiplicand+2)], a
	jr nc, CalcStat.noCarry4
	ldh a, [lobyte(hMultiplicand+1)]
	inc a                    ; non-HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + 5
	ldh [lobyte(hMultiplicand+1)], a ; HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + Level + 10
CalcStat.noCarry4
	ldh a, [lobyte(hMultiplicand+1)] ; check for overflow (>999)
	cp hibyte(MAX_STAT_VALUE) + 1
	jr nc, CalcStat.overflow
	cp hibyte(MAX_STAT_VALUE)
	jr c, CalcStat.noOverflow
	ldh a, [lobyte(hMultiplicand+2)]
	cp lobyte(MAX_STAT_VALUE) + 1
	jr c, CalcStat.noOverflow
CalcStat.overflow
	ld a, hibyte(MAX_STAT_VALUE) ; overflow: cap at 999
	ldh [lobyte(hMultiplicand+1)], a
	ld a, lobyte(MAX_STAT_VALUE)
	ldh [lobyte(hMultiplicand+2)], a
CalcStat.noOverflow
	pop bc
	pop de
	pop hl
	ret

AddEnemyMonToPlayerParty:
	homecall_sf WLA_GLOBAL_AddEnemyMonToPlayerParty
	ret

MoveMon:
	homecall_sf WLA_GLOBAL_MoveMon
	ret
