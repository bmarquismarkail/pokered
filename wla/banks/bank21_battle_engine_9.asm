; Native WLA-DX form of engine/battle/experience.asm.
.DEFINE LINK_STATE_BATTLING $04
.DEFINE NUM_STATS 5
.DEFINE MAX_LEVEL 100
.DEFINE LEVEL_UP_STATS_BOX 1
.DEFINE TRANSFORMED 3
.DEFINE MON_SPECIES 0
.DEFINE MON_HP 1
.DEFINE MON_OTID 12
.DEFINE MON_EXP 14
.DEFINE MON_HP_EXP 17
.DEFINE MON_DVS 27
.DEFINE MON_LEVEL 33
.DEFINE MON_MAXHP 34
.DEFINE PARTYMON_STRUCT_LENGTH 44
.DEFINE Multiply $38ac
.DEFINE GetPartyMonName $15ba
.DEFINE LoadMonData $1372
.DEFINE CalcStats $3936

GainExperience:
	ld a, (wLinkState)
	cp LINK_STATE_BATTLING
	ret z ; return if link battle
	call DivideExpDataByNumMonsGainingExp
	ld hl, wPartyMon1
	xor a
	ld (wWhichPokemon), a
GainExperience.partyMonLoop: ; loop over each mon and add gained exp
	inc hl
	ld a, (HL+)
	or (hl) ; is mon's HP 0?
	jp z, GainExperience.nextMon ; if so, go to next mon
	push hl
	ld hl, wPartyGainExpFlags
	ld a, (wWhichPokemon)
	ld c, a
	ld b, FLAG_TEST
	ld a, $10
	call Predef
	ld a, c
	and a ; is mon's gain exp flag set?
	pop hl
	jp z, GainExperience.nextMon ; if mon's gain exp flag not set, go to next mon
	ld de, (MON_HP_EXP + 1) - (MON_HP + 1)
	add hl, de
	ld d, h
	ld e, l
	ld hl, wEnemyMonBaseStats
	ld c, NUM_STATS
GainExperience.gainStatExpLoop:
	ld a, (HL+)
	ld b, a ; enemy mon base stat
	ld a, (de) ; stat exp
	add b ; add enemy mon base state to stat exp
	ld (de), a
	jr nc, GainExperience.nextBaseStat
; if there was a carry, increment the upper byte
	dec de
	ld a, (de)
	inc a
	jr z, GainExperience.maxStatExp ; jump if the value overflowed
	ld (de), a
	inc de
	jr GainExperience.nextBaseStat
GainExperience.maxStatExp: ; if the upper byte also overflowed, then we have hit the max stat exp
	ld a, $ff
	ld (de), a
	inc de
	ld (de), a
GainExperience.nextBaseStat:
	dec c
	jr z, GainExperience.statExpDone
	inc de
	inc de
	jr GainExperience.gainStatExpLoop
GainExperience.statExpDone:
	xor a
	ldh (hMultiplicand - $FF00), a
	ldh (hMultiplicand - $FF00 + 1), a
	ld a, (wEnemyMonBaseExp)
	ldh (hMultiplicand - $FF00 + 2), a
	ld a, (wEnemyMonLevel)
	ldh (hMultiplier - $FF00), a
	call Multiply
	ld a, 7
	ldh (hDivisor - $FF00), a
	ld b, 4
	call Divide
	ld hl, MON_OTID - (MON_DVS - 1)
	add hl, de
	ld b, (hl) ; wPartyMon*OTID
	inc hl
	ld a, (wPlayerID)
	cp b
	jr nz, GainExperience.tradedMon
	ld b, (hl)
	ld a, (wPlayerID + 1)
	cp b
	ld a, 0
	jr z, GainExperience.next
GainExperience.tradedMon:
	call BoostExp ; traded mon exp boost
	ld a, 1
GainExperience.next:
	ld (wGainBoostedExp), a
	ld a, (wIsInBattle)
	dec a ; is it a trainer battle?
	call nz, BoostExp ; if so, boost exp
	inc hl
	inc hl
	inc hl
; add the gained exp to the party mon's exp
	ld b, (hl)
	ldh a, (hQuotient - $FF00 + 3)
	ld (wExpAmountGained + 1), a
	add b
	ld (HL-), a
	ld b, (hl)
	ldh a, (hQuotient - $FF00 + 2)
	ld (wExpAmountGained), a
	adc b
	ld (hl), a
	jr nc, GainExperience.noCarry
	dec hl
	inc (hl)
	inc hl
GainExperience.noCarry:
; calculate exp for the mon at max level, and cap the exp at that value
	inc hl
	push hl
	ld a, (wWhichPokemon)
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, (hl)
	ld (wCurSpecies), a
	call GetMonHeader
	ld d, MAX_LEVEL
	ld hl, $4f6a
	ld b, $16
	call Bankswitch ; get max exp
; compare max exp with current exp
	ldh a, (hExperience - $FF00)
	ld b, a
	ldh a, (hExperience - $FF00 + 1)
	ld c, a
	ldh a, (hExperience - $FF00 + 2)
	ld d, a
	pop hl
	ld a, (HL-)
	sub d
	ld a, (HL-)
	sbc c
	ld a, (hl)
	sbc b
	jr c, GainExperience.next2
; the mon's exp is greater than the max exp, so overwrite it with the max exp
	ld a, b
	ld (HL+), a
	ld a, c
	ld (HL+), a
	ld a, d
	ld (HL-), a
	dec hl
GainExperience.next2:
	push hl
	ld a, (wWhichPokemon)
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, GainedText
	call PrintText
	xor a ; PLAYER_PARTY_DATA
	ld (wMonDataLocation), a
	call LoadMonData
	pop hl
	ld bc, MON_LEVEL - MON_EXP
	add hl, bc
	push hl
	ld b, $16
	ld hl, $4f43
	call Bankswitch
	pop hl
	ld a, (hl) ; current level
	cp d
	jp z, GainExperience.nextMon ; if level didn't change, go to next mon
	ld a, (wCurEnemyLevel)
	push af
	push hl
	ld a, d
	ld (wCurEnemyLevel), a
	ld (hl), a
	ld bc, MON_SPECIES - MON_LEVEL
	add hl, bc
	ld a, (hl)
	ld (wCurSpecies), a
	ld (wPokedexNum), a
	call GetMonHeader
	ld bc, (MON_MAXHP + 1) - MON_SPECIES
	add hl, bc
	push hl
	ld a, (HL-)
	ld c, a
	ld b, (hl)
	push bc ; push max HP (from before levelling up)
	ld d, h
	ld e, l
	ld bc, (MON_HP_EXP - 1) - MON_MAXHP
	add hl, bc
	ld b, $1 ; consider stat exp when calculating stats
	call CalcStats
	pop bc ; pop max HP (from before levelling up)
	pop hl
	ld a, (HL-)
	sub c
	ld c, a
	ld a, (hl)
	sbc b
	ld b, a ; bc = difference between old max HP and new max HP after levelling
	ld de, (MON_HP + 1) - MON_MAXHP
	add hl, de
; add to the current HP the amount of max HP gained when levelling
	ld a, (hl) ; wPartyMon*HP + 1
	add c
	ld (HL-), a
	ld a, (hl) ; wPartyMon*HP + 1
	adc b
	ld (hl), a ; wPartyMon*HP
	ld a, (wPlayerMonNumber)
	ld b, a
	ld a, (wWhichPokemon)
	cp b ; is the current mon in battle?
	jr nz, GainExperience.printGrewLevelText
; current mon is in battle
	ld de, wBattleMonHP
; copy party mon HP to battle mon HP
	ld a, (HL+)
	ld (de), a
	inc de
	ld a, (hl)
	ld (de), a
; copy other stats from party mon to battle mon
	ld bc, MON_LEVEL - (MON_HP + 1)
	add hl, bc
	push hl
	ld de, wBattleMonLevel
	ld bc, 1 + NUM_STATS * 2 ; size of stats
	call CopyData
	pop hl
	ld a, (wPlayerBattleStatus3)
	bit TRANSFORMED, a
	jr nz, GainExperience.recalcStatChanges
; the mon is not transformed, so update the unmodified stats
	ld de, wPlayerMonUnmodifiedLevel
	ld bc, 1 + NUM_STATS * 2
	call CopyData
GainExperience.recalcStatChanges:
	xor a ; battle mon
	ld (wCalculateWhoseStats), a
	ld hl, $6d99
	ld b, $0f
	call Bankswitch
	ld hl, $6d1a
	ld b, $0f
	call Bankswitch
	ld hl, $6e19
	ld b, $0f
	call Bankswitch
	ld hl, $4d60
	ld b, $0f
	call Bankswitch
	ld hl, $6e94
	ld b, $0f
	call Bankswitch
	call SaveScreenTilesToBuffer1
GainExperience.printGrewLevelText:
	ld hl, GrewLevelText
	call PrintText
	xor a ; PLAYER_PARTY_DATA
	ld (wMonDataLocation), a
	call LoadMonData
	ld d, LEVEL_UP_STATS_BOX
	ld hl, $6ae4
	ld b, $04
	call Bankswitch
	call WaitForTextScrollButtonPress
	call LoadScreenTilesFromBuffer1
	xor a ; PLAYER_PARTY_DATA
	ld (wMonDataLocation), a
	ld a, (wCurSpecies)
	ld (wPokedexNum), a
	ld a, $1a
	call Predef
	ld hl, wCanEvolveFlags
	ld a, (wWhichPokemon)
	ld c, a
	ld b, FLAG_SET
	ld a, $10
	call Predef
	pop hl
	pop af
	ld (wCurEnemyLevel), a

GainExperience.nextMon:
	ld a, (wPartyCount)
	ld b, a
	ld a, (wWhichPokemon)
	inc a
	cp b
	jr z, GainExperience.done
	ld (wWhichPokemon), a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1
	call AddNTimes
	jp GainExperience.partyMonLoop
GainExperience.done:
	ld hl, wPartyGainExpFlags
	xor a
	ld (hl), a ; clear gain exp flags
	ld a, (wPlayerMonNumber)
	ld c, a
	ld b, FLAG_SET
	push bc
	ld a, $10
	call Predef ; set the gain exp flag for the mon that is currently out
	ld hl, wPartyFoughtCurrentEnemyFlags
	xor a
	ld (hl), a
	pop bc
	ld a, $10
	jp Predef ; set the fought current enemy flag for the mon that is currently out

; divide enemy base stats, catch rate, and base exp by the number of mons gaining exp
DivideExpDataByNumMonsGainingExp:
	ld a, (wPartyGainExpFlags)
	ld b, a
	xor a
	ld c, $8
	ld d, $0
DivideExpDataByNumMonsGainingExp.countSetBitsLoop: ; loop to count set bits in wPartyGainExpFlags
	xor a
	srl b
	adc d
	ld d, a
	dec c
	jr nz, DivideExpDataByNumMonsGainingExp.countSetBitsLoop
	cp $2
	ret c ; return if only one mon is gaining exp
	ld (wTempByteValue), a ; store number of mons gaining exp
	ld hl, wEnemyMonBaseStats
	ld c, wEnemyMonBaseExp + 1 - wEnemyMonBaseStats
DivideExpDataByNumMonsGainingExp.divideLoop:
	xor a
	ldh (hDividend - $FF00), a
	ld a, (hl)
	ldh (hDividend - $FF00 + 1), a
	ld a, (wTempByteValue)
	ldh (hDivisor - $FF00), a
	ld b, $2
	call Divide ; divide value by number of mons gaining exp
	ldh a, (hQuotient - $FF00 + 3)
	ld (HL+), a
	dec c
	jr nz, DivideExpDataByNumMonsGainingExp.divideLoop
	ret

; multiplies exp by 1.5
BoostExp:
	ldh a, (hQuotient - $FF00 + 2)
	ld b, a
	ldh a, (hQuotient - $FF00 + 3)
	ld c, a
	srl b
	rr c
	add c
	ldh (hQuotient - $FF00 + 3), a
	ldh a, (hQuotient - $FF00 + 2)
	adc b
	ldh (hQuotient - $FF00 + 2), a
	ret

GainedText:
	.DB $17
	.DW $5bc2
	.DB $22
	.DB $08
	ld a, (wBoostExpByExpAll)
	ld hl, WithExpAllText
	and a
	ret nz
	ld hl, ExpPointsText
	ld a, (wGainBoostedExp)
	and a
	ret z
	ld hl, BoostedText
	ret

WithExpAllText:
	.DB $17
	.DW $5bd0
	.DB $22
	.DB $08
	ld hl, ExpPointsText
	ret

BoostedText:
	.DB $17
	.DW $5be1
	.DB $22

ExpPointsText:
	.DB $17
	.DW $5bee
	.DB $22
	.DB $50

GrewLevelText:
	.DB $17
	.DW $5c01
	.DB $22
	.DB $0b
	.DB $50
BattleEngine9End:
