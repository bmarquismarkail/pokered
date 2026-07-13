; Native WLA-DX form of engine/battle/common_text.asm, engine/pokemon/experience.asm, engine/events/oaks_aide.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"
PrintBeginningBattleText:
	ld a, (wIsInBattle)
	dec a
	jr nz, PrintBeginningBattleText.trainerBattle
	ld a, (wCurMap)
	cp POKEMON_TOWER_3F
	jr c, PrintBeginningBattleText.notPokemonTower
	cp POKEMON_TOWER_7F + 1
	jr c, PrintBeginningBattleText.pokemonTower
PrintBeginningBattleText.notPokemonTower:
	ld a, (wEnemyMonSpecies2)
	call PlayCry
	ld hl, WildMonAppearedText
	ld a, (wMoveMissed)
	and a
	jr z, PrintBeginningBattleText.notFishing
	ld hl, HookedMonAttackedText
PrintBeginningBattleText.notFishing:
	jr PrintBeginningBattleText.wildBattle
PrintBeginningBattleText.trainerBattle:
	call PrintBeginningBattleText.playSFX
	ld c, 20
	call DelayFrames
	ld hl, TrainerWantsToFightText
PrintBeginningBattleText.wildBattle:
	push hl
	ld hl, $6849
	ld b, $0e
	call Bankswitch
	pop hl
	call PrintText
	jr PrintBeginningBattleText.done
PrintBeginningBattleText.pokemonTower:
	ld b, SILPH_SCOPE
	call IsItemInBag
	ld a, (wEnemyMonSpecies2)
	ld (wCurPartySpecies), a
	cp RESTLESS_SOUL
	jr z, PrintBeginningBattleText.isMarowak
	ld a, b
	and a
	jr z, PrintBeginningBattleText.noSilphScope
	ld hl, $6b01
	ld b, $0f
	call Bankswitch
	jr PrintBeginningBattleText.notPokemonTower
PrintBeginningBattleText.noSilphScope:
	ld hl, EnemyAppearedText
	call PrintText
	ld hl, GhostCantBeIDdText
	call PrintText
	jr PrintBeginningBattleText.done
PrintBeginningBattleText.isMarowak:
	ld a, b
	and a
	jr z, PrintBeginningBattleText.noSilphScope
	ld hl, EnemyAppearedText
	call PrintText
	ld hl, UnveiledGhostText
	call PrintText
	ld hl, $6b01
	ld b, $0f
	call Bankswitch
	ld hl, $48ca
	ld b, $1c
	call Bankswitch
	ld hl, WildMonAppearedText
	call PrintText

PrintBeginningBattleText.playSFX:
	xor a
	ld (wFrequencyModifier), a
	ld a, $80
	ld (wTempoModifier), a
	ld a, SFX_TRAINER_APPEARED
	call PlaySound
	jp WaitForSoundToFinish
PrintBeginningBattleText.done:
	ret

WildMonAppearedText:
	.DB $17
	.DW $5c1d
	.DB $22
	.DB $50

HookedMonAttackedText:
	.DB $17
	.DW $5c33
	.DB $22
	.DB $50

EnemyAppearedText:
	.DB $17
	.DW $5c4f
	.DB $22
	.DB $50

TrainerWantsToFightText:
	.DB $17
	.DW $5c5e
	.DB $22
	.DB $50

UnveiledGhostText:
	.DB $17
	.DW $5c73
	.DB $22
	.DB $50

GhostCantBeIDdText:
	.DB $17
	.DW $5c9e
	.DB $22
	.DB $50

PrintSendOutMonMessage:
	ld hl, wEnemyMonHP
	ld a, (HL+)
	or (hl)
	ld hl, GoText
	jr z, PrintSendOutMonMessage.printText
	xor a
	ldh (hMultiplicand - $FF00), a
	ld hl, wEnemyMonHP
	ld a, (HL+)
	ld (wLastSwitchInEnemyMonHP), a
	ldh (hMultiplicand - $FF00 + 1), a
	ld a, (hl)
	ld (wLastSwitchInEnemyMonHP + 1), a
	ldh (hMultiplicand - $FF00 + 2), a
	ld a, 25
	ldh (hMultiplier - $FF00), a
	call Multiply
	ld hl, wEnemyMonMaxHP
	ld a, (HL+)
	ld b, (hl)
	srl a
	rr b
	srl a
	rr b
	ld a, b
	ld b, 4
	ldh (hDivisor - $FF00), a ; enemy mon max HP divided by 4
	call Divide
	ldh a, (hQuotient - $FF00 + 3) ; a = (enemy mon current HP * 25) / (enemy max HP / 4); this approximates the current percentage of max HP
	ld hl, GoText ; 70% or greater
	cp 70
	jr nc, PrintSendOutMonMessage.printText
	ld hl, DoItText ; 40% - 69%
	cp 40
	jr nc, PrintSendOutMonMessage.printText
	ld hl, GetmText ; 10% - 39%
	cp 10
	jr nc, PrintSendOutMonMessage.printText
	ld hl, EnemysWeakText ; 0% - 9%
PrintSendOutMonMessage.printText:
	jp PrintText

GoText:
	.DB $17
	.DW $5cbc
	.DB $22
	.DB $08
	jr PrintPlayerMon1Text

DoItText:
	.DB $17
	.DW $5cc3
	.DB $22
	.DB $08
	jr PrintPlayerMon1Text

GetmText:
	.DB $17
	.DW $5ccd
	.DB $22
	.DB $08
	jr PrintPlayerMon1Text

EnemysWeakText:
	.DB $17
	.DW $5cd6
	.DB $22
	.DB $08

PrintPlayerMon1Text:
	ld hl, PlayerMon1Text
	ret

PlayerMon1Text:
	.DB $17
	.DW $5cf0
	.DB $22
	.DB $50

RetreatMon:
	ld hl, PlayerMon2Text
	jp PrintText

PlayerMon2Text:
	.DB $17
	.DW $5cf6
	.DB $22
	.DB $08
	push de
	push bc
	ld hl, wEnemyMonHP + 1
	ld de, wLastSwitchInEnemyMonHP + 1
	ld b, (hl)
	dec hl
	ld a, (de)
	sub b
	ldh (hMultiplicand - $FF00 + 2), a
	dec de
	ld b, (hl)
	ld a, (de)
	sbc b
	ldh (hMultiplicand - $FF00 + 1), a
	ld a, 25
	ldh (hMultiplier - $FF00), a
	call Multiply
	ld hl, wEnemyMonMaxHP
	ld a, (HL+)
	ld b, (hl)
	srl a
	rr b
	srl a
	rr b
	ld a, b
	ld b, 4
	ldh (hDivisor - $FF00), a
	call Divide
	pop bc
	pop de
	ldh a, (hQuotient - $FF00 + 3) ; a = ((LastSwitchInEnemyMonHP - CurrentEnemyMonHP) / 25) / (EnemyMonMaxHP / 4)
; Assuming that the enemy mon hasn't gained HP since the last switch in,
; a approximates the percentage that the enemy mon's total HP has decreased
; since the last switch in.
; If the enemy mon has gained HP, then a is garbage due to wrap-around and
; can fall in any of the ranges below.
	ld hl, EnoughText ; HP stayed the same
	and a
	ret z
	ld hl, ComeBackText ; HP went down 1% - 29%
	cp 30
	ret c
	ld hl, OKExclamationText ; HP went down 30% - 69%
	cp 70
	ret c
	ld hl, GoodText ; HP went down 70% or more
	ret

EnoughText:
	.DB $17
	.DW $5cfd
	.DB $22
	.DB $08
	jr PrintComeBackText

OKExclamationText:
	.DB $17
	.DW $5d07
	.DB $22
	.DB $08
	jr PrintComeBackText

GoodText:
	.DB $17
	.DW $5d0d
	.DB $22
	.DB $08
	jr PrintComeBackText

PrintComeBackText:
	ld hl, ComeBackText
	ret

ComeBackText:
	.DB $17
	.DW $5d15
	.DB $22
	.DB $50
; calculates the level a mon should be based on its current exp
CalcLevelFromExperience:
	ld a, (wLoadedMonSpecies)
	ld (wCurSpecies), a
	call GetMonHeader
	ld d, $1 ; init level to 1
CalcLevelFromExperience.loop:
	inc d ; increment level
	call CalcExperience
	push hl
	ld hl, wLoadedMonExp + 2 ; current exp
; compare exp needed for level d with current exp
	ldh a, (hExperience - $FF00 + 2)
	ld c, a
	ld a, (HL-)
	sub c
	ldh a, (hExperience - $FF00 + 1)
	ld c, a
	ld a, (HL-)
	sbc c
	ldh a, (hExperience - $FF00)
	ld c, a
	ld a, (hl)
	sbc c
	pop hl
	jr nc, CalcLevelFromExperience.loop ; if exp needed for level d is not greater than exp, try the next level
	dec d ; since the exp was too high on the last loop iteration, go back to the previous value and return
	ret

; calculates the amount of experience needed for level d
CalcExperience:
	ld a, (wMonHGrowthRate)
	add a
	add a
	ld c, a
	ld b, 0
	ld hl, GrowthRateTable
	add hl, bc
	call CalcDSquared
	ld a, d
	ldh (hMultiplier - $FF00), a
	call Multiply
	ld a, (hl)
	and $f0
	swap a
	ldh (hMultiplier - $FF00), a
	call Multiply
	ld a, (HL+)
	and $f
	ldh (hDivisor - $FF00), a
	ld b, $4
	call Divide
	ldh a, (hQuotient - $FF00 + 1)
	push af
	ldh a, (hQuotient - $FF00 + 2)
	push af
	ldh a, (hQuotient - $FF00 + 3)
	push af
	call CalcDSquared
	ld a, (hl)
	and $7f
	ldh (hMultiplier - $FF00), a
	call Multiply
	ldh a, (hProduct - $FF00 + 1)
	push af
	ldh a, (hProduct - $FF00 + 2)
	push af
	ldh a, (hProduct - $FF00 + 3)
	push af
	ld a, (HL+)
	push af
	xor a
	ldh (hMultiplicand - $FF00), a
	ldh (hMultiplicand - $FF00 + 1), a
	ld a, d
	ldh (hMultiplicand - $FF00 + 2), a
	ld a, (HL+)
	ldh (hMultiplier - $FF00), a
	call Multiply
	ld b, (hl)
	ldh a, (hProduct - $FF00 + 3)
	sub b
	ldh (hProduct - $FF00 + 3), a
	ld b, $0
	ldh a, (hProduct - $FF00 + 2)
	sbc b
	ldh (hProduct - $FF00 + 2), a
	ldh a, (hProduct - $FF00 + 1)
	sbc b
	ldh (hProduct - $FF00 + 1), a
; The difference of the linear term and the constant term consists of 3 bytes
; starting at hProduct + 1. Below, hExperience (an alias of that address) will
; be used instead for the further work of adding or subtracting the squared
; term and adding the cubed term.
	pop af
	and $80
	jr nz, CalcExperience.subtractSquaredTerm ; check sign
	pop bc
	ldh a, (hExperience - $FF00 + 2)
	add b
	ldh (hExperience - $FF00 + 2), a
	pop bc
	ldh a, (hExperience - $FF00 + 1)
	adc b
	ldh (hExperience - $FF00 + 1), a
	pop bc
	ldh a, (hExperience - $FF00)
	adc b
	ldh (hExperience - $FF00), a
	jr CalcExperience.addCubedTerm
CalcExperience.subtractSquaredTerm:
	pop bc
	ldh a, (hExperience - $FF00 + 2)
	sub b
	ldh (hExperience - $FF00 + 2), a
	pop bc
	ldh a, (hExperience - $FF00 + 1)
	sbc b
	ldh (hExperience - $FF00 + 1), a
	pop bc
	ldh a, (hExperience - $FF00)
	sbc b
	ldh (hExperience - $FF00), a
CalcExperience.addCubedTerm:
	pop bc
	ldh a, (hExperience - $FF00 + 2)
	add b
	ldh (hExperience - $FF00 + 2), a
	pop bc
	ldh a, (hExperience - $FF00 + 1)
	adc b
	ldh (hExperience - $FF00 + 1), a
	pop bc
	ldh a, (hExperience - $FF00)
	adc b
	ldh (hExperience - $FF00), a
	ret

; calculates d*d
CalcDSquared:
	xor a
	ldh (hMultiplicand - $FF00), a
	ldh (hMultiplicand - $FF00 + 1), a
	ld a, d
	ldh (hMultiplicand - $FF00 + 2), a
	ldh (hMultiplier - $FF00), a
	jp Multiply

; [1]/[2]*n**3 + [3]*n**2 + [4]*n - [5]

GrowthRateTable:
; entries correspond to GROWTH_* (see constants/pokemon_data_constants.asm)
; table_width 4
	.DB (1 << 4) | 1, 0, 0, 0 ; Medium Fast
	.DB (3 << 4) | 4, 10, 0, 30 ; Slightly Fast
	.DB (3 << 4) | 4, 20, 0, 70 ; Slightly Slow
	.DB (6 << 4) | 5, 15 | $80, 100, 140 ; Medium Slow
	.DB (4 << 4) | 5, 0, 0, 0 ; Fast
	.DB (5 << 4) | 4, 0, 0, 0 ; Slow
; assert_table_length NUM_GROWTH_RATES
OaksAideScript:
	ld hl, OaksAideHiText
	call PrintText
	call YesNoChoice
	ld a, (wCurrentMenuItem)
	and a
	jr nz, OaksAideScript.choseNo
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, (wNumSetBits)
	ldh (hOaksAideNumMonsOwned - $FF00), a
	ld b, a
	ldh a, (hOaksAideRequirement - $FF00)
	cp b
	jr z, OaksAideScript.giveItem
	jr nc, OaksAideScript.notEnoughOwnedMons
OaksAideScript.giveItem:
	ld hl, OaksAideHereYouGoText
	call PrintText
	ldh a, (hOaksAideRewardItem - $FF00)
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, OaksAideScript.bagFull
	ld hl, OaksAideGotItemText
	call PrintText
	ld a, OAKS_AIDE_GOT_ITEM
	jr OaksAideScript.done
OaksAideScript.bagFull:
	ld hl, OaksAideNoRoomText
	call PrintText
	xor a ; OAKS_AIDE_BAG_FULL
	jr OaksAideScript.done
OaksAideScript.notEnoughOwnedMons:
	ld hl, OaksAideUhOhText
	call PrintText
	ld a, OAKS_AIDE_NOT_ENOUGH_MONS
	jr OaksAideScript.done
OaksAideScript.choseNo:
	ld hl, OaksAideComeBackText
	call PrintText
	ld a, OAKS_AIDE_REFUSED
OaksAideScript.done:
	ldh (hOaksAideResult - $FF00), a
	ret

OaksAideHiText:
	.DB $17
	.DW $4143
	.DB $20
	.DB $50

OaksAideUhOhText:
	.DB $17
	.DW $41e4
	.DB $20
	.DB $50

OaksAideComeBackText:
	.DB $17
	.DW $4250
	.DB $20
	.DB $50

OaksAideHereYouGoText:
	.DB $17
	.DW $428c
	.DB $20
	.DB $50

OaksAideGotItemText:
	.DB $17
	.DW $42d9
	.DB $20
	.DB $0b
	.DB $50

OaksAideNoRoomText:
	.DB $17
	.DW $42ec
	.DB $20
	.DB $50
BattleEngine10End:
