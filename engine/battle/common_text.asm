PrintBeginningBattleText:
	ld a, [wIsInBattle]
	dec a
	jr nz, PrintBeginningBattleText.trainerBattle
	ld a, [wCurMap]
	cp POKEMON_TOWER_3F
	jr c, PrintBeginningBattleText.notPokemonTower
	cp POKEMON_TOWER_7F + 1
	jr c, PrintBeginningBattleText.pokemonTower
PrintBeginningBattleText.notPokemonTower
	ld a, [wEnemyMonSpecies2]
	call PlayCry
	ld hl, WildMonAppearedText
	ld a, [wMoveMissed]
	and a
	jr z, PrintBeginningBattleText.notFishing
	ld hl, HookedMonAttackedText
PrintBeginningBattleText.notFishing
	jr PrintBeginningBattleText.wildBattle
PrintBeginningBattleText.trainerBattle
	call PrintBeginningBattleText.playSFX
	ld c, 20
	call DelayFrames
	ld hl, TrainerWantsToFightText
PrintBeginningBattleText.wildBattle
	push hl
	callfar DrawAllPokeballs
	pop hl
	call PrintText
	jr PrintBeginningBattleText.done
PrintBeginningBattleText.pokemonTower
	ld b, SILPH_SCOPE
	call IsItemInBag
	ld a, [wEnemyMonSpecies2]
	ld [wCurPartySpecies], a
	cp RESTLESS_SOUL
	jr z, PrintBeginningBattleText.isMarowak
	ld a, b
	and a
	jr z, PrintBeginningBattleText.noSilphScope
	callfar LoadEnemyMonData
	jr PrintBeginningBattleText.notPokemonTower
PrintBeginningBattleText.noSilphScope
	ld hl, EnemyAppearedText
	call PrintText
	ld hl, GhostCantBeIDdText
	call PrintText
	jr PrintBeginningBattleText.done
PrintBeginningBattleText.isMarowak
	ld a, b
	and a
	jr z, PrintBeginningBattleText.noSilphScope
	ld hl, EnemyAppearedText
	call PrintText
	ld hl, UnveiledGhostText
	call PrintText
	callfar LoadEnemyMonData
	callfar MarowakAnim
	ld hl, WildMonAppearedText
	call PrintText

PrintBeginningBattleText.playSFX
	xor a
	ld [wFrequencyModifier], a
	ld a, $80
	ld [wTempoModifier], a
	ld a, SFX_TRAINER_APPEARED
	call PlaySound
	jp WaitForSoundToFinish
PrintBeginningBattleText.done
	ret

WildMonAppearedText:
	text_far WLA_GLOBAL_WildMonAppearedText
	text_end

HookedMonAttackedText:
	text_far WLA_GLOBAL_HookedMonAttackedText
	text_end

EnemyAppearedText:
	text_far WLA_GLOBAL_EnemyAppearedText
	text_end

TrainerWantsToFightText:
	text_far WLA_GLOBAL_TrainerWantsToFightText
	text_end

UnveiledGhostText:
	text_far WLA_GLOBAL_UnveiledGhostText
	text_end

GhostCantBeIDdText:
	text_far WLA_GLOBAL_GhostCantBeIDdText
	text_end

PrintSendOutMonMessage:
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	ld hl, GoText
	jr z, PrintSendOutMonMessage.printText
	xor a
	ldh [lobyte(hMultiplicand)], a
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [wLastSwitchInEnemyMonHP], a
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, [hl]
	ld [wLastSwitchInEnemyMonHP + 1], a
	ldh [lobyte(hMultiplicand + 2)], a
	ld a, 25
	ldh [lobyte(hMultiplier)], a
	call Multiply
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b
	ld a, b
	ld b, 4
	ldh [lobyte(hDivisor)], a ; enemy mon max HP divided by 4
	call Divide
	ldh a, [lobyte(hQuotient + 3)] ; a = (enemy mon current HP * 25) / (enemy max HP / 4); this approximates the current percentage of max HP
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
PrintSendOutMonMessage.printText
	jp PrintText

GoText:
	text_far WLA_GLOBAL_GoText
	text_asm
	jr PrintPlayerMon1Text

DoItText:
	text_far WLA_GLOBAL_DoItText
	text_asm
	jr PrintPlayerMon1Text

GetmText:
	text_far WLA_GLOBAL_GetmText
	text_asm
	jr PrintPlayerMon1Text

EnemysWeakText:
	text_far WLA_GLOBAL_EnemysWeakText
	text_asm

PrintPlayerMon1Text:
	ld hl, PlayerMon1Text
	ret

PlayerMon1Text:
	text_far WLA_GLOBAL_PlayerMon1Text
	text_end

RetreatMon:
	ld hl, PlayerMon2Text
	jp PrintText

PlayerMon2Text:
	text_far WLA_GLOBAL_PlayerMon2Text
	text_asm
	push de
	push bc
	ld hl, wEnemyMonHP + 1
	ld de, wLastSwitchInEnemyMonHP + 1
	ld b, [hl]
	dec hl
	ld a, [de]
	sub b
	ldh [lobyte(hMultiplicand + 2)], a
	dec de
	ld b, [hl]
	ld a, [de]
	sbc b
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, 25
	ldh [lobyte(hMultiplier)], a
	call Multiply
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b
	ld a, b
	ld b, 4
	ldh [lobyte(hDivisor)], a
	call Divide
	pop bc
	pop de
	ldh a, [lobyte(hQuotient + 3)] ; a = ((LastSwitchInEnemyMonHP - CurrentEnemyMonHP) / 25) / (EnemyMonMaxHP / 4)
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
	text_far WLA_GLOBAL_EnoughText
	text_asm
	jr PrintComeBackText

OKExclamationText:
	text_far WLA_GLOBAL_OKExclamationText
	text_asm
	jr PrintComeBackText

GoodText:
	text_far WLA_GLOBAL_GoodText
	text_asm
	jr PrintComeBackText

PrintComeBackText:
	ld hl, ComeBackText
	ret

ComeBackText:
	text_far WLA_GLOBAL_ComeBackText
	text_end
