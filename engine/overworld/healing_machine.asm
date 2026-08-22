AnimateHealingMachine:
	ld de, PokeCenterFlashingMonitorAndHealBall
	ld hl, vChars0 + TILE_SIZE * $7c
	lb "bc", bank(PokeCenterFlashingMonitorAndHealBall), 3 ; should be 2
	call CopyVideoData
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	ldh a, [lobyte(rOBP1)]
	push af
	ld a, $e0
	ldh [lobyte(rOBP1)], a
	ld hl, wShadowOAMSprite33
	ld de, PokeCenterOAMData
	call CopyHealingMachineOAM
	ld a, 4
	ld [wAudioFadeOutControl], a
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
AnimateHealingMachine.waitLoop
	ld a, [wAudioFadeOutControl]
	and a ; is fade-out finished?
	jr nz, AnimateHealingMachine.waitLoop ; if not, check again
	ld a, [wPartyCount]
	ld b, a
AnimateHealingMachine.partyLoop
	call CopyHealingMachineOAM
	ld a, SFX_HEALING_MACHINE
	call PlaySound
	ld c, 30
	call DelayFrames
	dec b
	jr nz, AnimateHealingMachine.partyLoop
	ld a, [wAudioROMBank]
	cp $1f
	ld [wAudioSavedROMBank], a
	jr nz, AnimateHealingMachine.next
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld a, bank(Music_PkmnHealed)
	ld [wAudioROMBank], a
AnimateHealingMachine.next
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
	ld d, $28
	call FlashSprite8Times
AnimateHealingMachine.waitLoop2
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED ; is the healed music still playing?
	jr z, AnimateHealingMachine.waitLoop2 ; if so, check gain
	ld c, 32
	call DelayFrames
	pop af
	ldh [lobyte(rOBP1)], a
	pop hl
	pop af
	ld [hl], a
	jp UpdateSprites

PokeCenterFlashingMonitorAndHealBall:
	.INCBIN "gfx/overworld/heal_machine.2bpp"

PokeCenterOAMData:
	; heal machine monitor
	dbsprite  6,  4,  4,  4, $7c, OAM_PAL1
	; poke balls 1-6
	dbsprite  6,  5,  0,  3, $7d, OAM_PAL1
	dbsprite  7,  5,  0,  3, $7d, OAM_PAL1 | OAM_XFLIP
	dbsprite  6,  6,  0,  0, $7d, OAM_PAL1
	dbsprite  7,  6,  0,  0, $7d, OAM_PAL1 | OAM_XFLIP
	dbsprite  6,  6,  0,  5, $7d, OAM_PAL1
	dbsprite  7,  6,  0,  5, $7d, OAM_PAL1 | OAM_XFLIP

; d = value to xor with palette
FlashSprite8Times:
	ld b, 8
FlashSprite8Times.loop
	ldh a, [lobyte(rOBP1)]
	xor d
	ldh [lobyte(rOBP1)], a
	ld c, 10
	call DelayFrames
	dec b
	jr nz, FlashSprite8Times.loop
	ret

CopyHealingMachineOAM:
; copy one OAM entry and advance the pointers
.REPT 4
	ld a, [de]
	inc de
	ld [hli], a
.ENDR
	ret
