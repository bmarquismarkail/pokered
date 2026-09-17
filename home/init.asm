SoftReset:
	call StopAllSounds
	call GBPalWhiteOut
	ld c, 32
	call DelayFrames
	; fallthrough

Init:
;  Program init.
	di

	xor a
	ldh [lobyte(rIF)], a
	ldh [lobyte(rIE)], a
	ldh [lobyte(rSCX)], a
	ldh [lobyte(rSCY)], a
	ldh [lobyte(rSB)], a
	ldh [lobyte(rSC)], a
	ldh [lobyte(rWX)], a
	ldh [lobyte(rWY)], a
	ldh [lobyte(rTMA)], a
	ldh [lobyte(rTAC)], a
	ldh [lobyte(rBGP)], a
	ldh [lobyte(rOBP0)], a
	ldh [lobyte(rOBP1)], a

	ld a, LCDC_ON
	ldh [lobyte(rLCDC)], a
	call DisableLCD

	ld sp, wStack

	ld hl, $c000
	ld bc, $2000
Init.loop
	ld [hl], 0
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, Init.loop

	call ClearVram

	ld hl, $ff80
	ld bc, $007f
	call FillMemory

	call ClearSprites

	ld a, bank(WriteDMACodeToHRAM)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	call WriteDMACodeToHRAM

	xor a
	ldh [lobyte(hTileAnimations)], a
	ldh [lobyte(rSTAT)], a
	ldh [lobyte(hSCX)], a
	ldh [lobyte(hSCY)], a
	ldh [lobyte(rIF)], a
	ld a, IE_VBLANK | IE_TIMER | IE_SERIAL
	ldh [lobyte(rIE)], a

	ld a, 144 ; move the window off-screen
	ldh [lobyte(hWY)], a
	ldh [lobyte(rWY)], a
	ld a, 7
	ldh [lobyte(rWX)], a

	ld a, CONNECTION_NOT_ESTABLISHED
	ldh [lobyte(hSerialConnectionStatus)], a

	ld h, hibyte(vBGMap0)
	call ClearBgMap
	ld h, hibyte(vBGMap1)
	call ClearBgMap

	ld a, LCDC_DEFAULT
	ldh [lobyte(rLCDC)], a
	ld a, 16
	ldh [lobyte(hSoftReset)], a
	call StopAllSounds

	ei

	predef LoadSGB

	ld a, bank(SFX_Shooting_Star)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, hibyte(vBGMap1)
	ldh [lobyte(hAutoBGTransferDest + 1)], a
	xor a
	ldh [lobyte(hAutoBGTransferDest)], a
	dec a
	ld [wUpdateSpritesEnabled], a

	predef PlayIntro

	call DisableLCD
	call ClearVram
	call GBPalNormal
	call ClearSprites
	ld a, LCDC_DEFAULT
	ldh [lobyte(rLCDC)], a

	jp PrepareTitleScreen

ClearVram:
	ld hl, $8000
	ld bc, $2000
	xor a
	jp FillMemory


StopAllSounds:
	ld a, $02
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	xor a
	ld [wAudioFadeOutControl], a
	ld [wNewSoundID], a
	ld [wLastMusicSoundID], a
	dec a
	jp PlaySound
