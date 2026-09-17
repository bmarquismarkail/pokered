EvolveMon:
	push hl
	push de
	push bc
	ld a, [wCurPartySpecies]
	push af
	ld a, [wCurSpecies]
	push af
	xor a
	ld [wLowHealthAlarm], a
	ld [wChannelSoundIDs + CHAN5], a
	dec a ; SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld a, SFX_TINK
	call PlaySound
	call Delay3
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ldh [lobyte(hTileAnimations)], a
	ld a, [wEvoOldSpecies]
	ld [wWholeScreenPaletteMonSpecies], a
	ld c, 0
	call EvolutionSetWholeScreenPalette
	ld a, [wEvoNewSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call Evolution_LoadPic
	ld de, vFrontPic
	ld hl, vBackPic
	ld bc, PIC_SIZE
	call CopyVideoData
	ld a, [wEvoOldSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call Evolution_LoadPic
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld a, [wEvoOldSpecies]
	call PlayCry
	call WaitForSoundToFinish
	ld c, bank(Music_SafariZone)
	ld a, MUSIC_SAFARI_ZONE
	call PlayMusic
	ld c, 80
	call DelayFrames
	ld c, 1 ; set PAL_BLACK instead of mon palette
	call EvolutionSetWholeScreenPalette
	lb "bc", $1, $10
EvolveMon.animLoop
	push bc
	call Evolution_CheckForCancel
	jr c, EvolveMon.evolutionCancelled
	call Evolution_BackAndForthAnim
	pop bc
	inc b
	dec c
	dec c
	jr nz, EvolveMon.animLoop
	xor a
	ld [wEvoCancelled], a
	ld a, $31
	ld [wEvoMonTileOffset], a
	call Evolution_ChangeMonPic ; show the new species pic
	ld a, [wEvoNewSpecies]
EvolveMon.done
	ld [wWholeScreenPaletteMonSpecies], a
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld a, [wWholeScreenPaletteMonSpecies]
	call PlayCry
	ld c, 0
	call EvolutionSetWholeScreenPalette
	pop af
	ld [wCurSpecies], a
	pop af
	ld [wCurPartySpecies], a
	pop bc
	pop de
	pop hl
	ld a, [wEvoCancelled]
	and a
	ret z
	scf
	ret
EvolveMon.evolutionCancelled
	pop bc
	ld a, 1
	ld [wEvoCancelled], a
	ld a, [wEvoOldSpecies]
	jr EvolveMon.done

EvolutionSetWholeScreenPalette:
	ld b, SET_PAL_POKEMON_WHOLE_SCREEN
	jp RunPaletteCommand

Evolution_LoadPic:
	call GetMonHeader
	hlcoord 7, 2
	jp LoadFlippedFrontSpriteByMonIndex

Evolution_BackAndForthAnim:
; show the mon change back and forth between the new and old species b times
	ld a, $31
	ld [wEvoMonTileOffset], a
	call Evolution_ChangeMonPic
	ld a, -$31
	ld [wEvoMonTileOffset], a
	call Evolution_ChangeMonPic
	dec b
	jr nz, Evolution_BackAndForthAnim
	ret

Evolution_ChangeMonPic:
	push bc
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	hlcoord 7, 2
	lb "bc", 7, 7
	ld de, SCREEN_WIDTH - 7
Evolution_ChangeMonPic.loop
	push bc
Evolution_ChangeMonPic.innerLoop
	ld a, [wEvoMonTileOffset]
	add [hl]
	ld [hli], a
	dec c
	jr nz, Evolution_ChangeMonPic.innerLoop
	pop bc
	add hl, de
	dec b
	jr nz, Evolution_ChangeMonPic.loop
	ld a, 1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call Delay3
	pop bc
	ret

Evolution_CheckForCancel:
	call DelayFrame
	push bc
	call JoypadLowSensitivity
	ldh a, [lobyte(hJoy5)]
	pop bc
	and PAD_B
	jr nz, Evolution_CheckForCancel.pressedB
Evolution_CheckForCancel.notAllowedToCancel
	dec c
	jr nz, Evolution_CheckForCancel
	and a
	ret
Evolution_CheckForCancel.pressedB
	ld a, [wForceEvolution]
	and a
	jr nz, Evolution_CheckForCancel.notAllowedToCancel
	scf
	ret
