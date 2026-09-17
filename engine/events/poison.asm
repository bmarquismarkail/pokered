ApplyOutOfBattlePoisonDamage:
	ld a, [wStatusFlags5]
	.ASSERT ((BIT_SCRIPTED_MOVEMENT_STATE)-(7)) < 1 && ((BIT_SCRIPTED_MOVEMENT_STATE)-(7)) > -1
	add a ; overflows scripted movement state bit into carry flag
	jp c, ApplyOutOfBattlePoisonDamage.noBlackOut ; no black out if joypad states are being simulated
	ld a, [wPartyCount]
	and a
	jp z, ApplyOutOfBattlePoisonDamage.noBlackOut
	call IncrementDayCareMonExp
	ld a, [wStepCounter]
	and $3 ; is the counter a multiple of 4?
	jp nz, ApplyOutOfBattlePoisonDamage.noBlackOut ; only apply poison damage every fourth step
	ld [wWhichPokemon], a
	ld hl, wPartyMon1Status
	ld de, wPartySpecies
ApplyOutOfBattlePoisonDamage.applyDamageLoop
	ld a, [hl]
	and 1 << PSN
	jr z, ApplyOutOfBattlePoisonDamage.nextMon2 ; not poisoned
	dec hl
	dec hl
	ld a, [hld]
	ld b, a
	ld a, [hli]
	or b
	jr z, ApplyOutOfBattlePoisonDamage.nextMon ; already fainted
; subtract 1 from HP
	ld a, [hl]
	dec a
	ld [hld], a
	inc a
	jr nz, ApplyOutOfBattlePoisonDamage.noBorrow
; borrow 1 from upper byte of HP
	dec [hl]
	inc hl
	jr ApplyOutOfBattlePoisonDamage.nextMon
ApplyOutOfBattlePoisonDamage.noBorrow
	ld a, [hli]
	or [hl]
	jr nz, ApplyOutOfBattlePoisonDamage.nextMon ; didn't faint from damage
; the mon fainted from the damage
	push hl
	inc hl
	inc hl
	ld [hl], a
	ld a, [de]
	ld [wPokedexNum], a
	push de
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	xor a
	ld [wJoyIgnore], a
	call EnableAutoTextBoxDrawing
	ld a, TEXT_MON_FAINTED
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	pop de
	pop hl
ApplyOutOfBattlePoisonDamage.nextMon
	inc hl
	inc hl
ApplyOutOfBattlePoisonDamage.nextMon2
	inc de
	ld a, [de]
	inc a
	jr z, ApplyOutOfBattlePoisonDamage.applyDamageLoopDone
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	push hl
	ld hl, wWhichPokemon
	inc [hl]
	pop hl
	jr ApplyOutOfBattlePoisonDamage.applyDamageLoop
ApplyOutOfBattlePoisonDamage.applyDamageLoopDone
	ld hl, wPartyMon1Status
	ld a, [wPartyCount]
	ld d, a
	ld e, 0
ApplyOutOfBattlePoisonDamage.countPoisonedLoop
	ld a, [hl]
	and 1 << PSN
	or e
	ld e, a
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	dec d
	jr nz, ApplyOutOfBattlePoisonDamage.countPoisonedLoop
	ld a, e
	and a ; are any party members poisoned?
	jr z, ApplyOutOfBattlePoisonDamage.skipPoisonEffectAndSound
	ld b, $2
	predef ChangeBGPalColor0_4Frames ; change BG white to dark gray for 4 frames
	ld a, SFX_POISONED
	call PlaySound
ApplyOutOfBattlePoisonDamage.skipPoisonEffectAndSound
	predef AnyPartyAlive
	ld a, d
	and a
	jr nz, ApplyOutOfBattlePoisonDamage.noBlackOut
	call EnableAutoTextBoxDrawing
	ld a, TEXT_BLACKED_OUT
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld hl, wStatusFlags4
	set BIT_BATTLE_OVER_OR_BLACKOUT, [hl]
	ld a, $ff
	jr ApplyOutOfBattlePoisonDamage.done
ApplyOutOfBattlePoisonDamage.noBlackOut
	xor a
ApplyOutOfBattlePoisonDamage.done
	ld [wOutOfBattleBlackout], a
	ret
