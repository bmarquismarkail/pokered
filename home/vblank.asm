VBlank:

	push af
	push bc
	push de
	push hl

	ldh a, [lobyte(hLoadedROMBank)]
	ld [wVBlankSavedROMBank], a

	ldh a, [lobyte(hSCX)]
	ldh [lobyte(rSCX)], a
	ldh a, [lobyte(hSCY)]
	ldh [lobyte(rSCY)], a

	ld a, [wDisableVBlankWYUpdate]
	and a
	jr nz, VBlank.ok
	ldh a, [lobyte(hWY)]
	ldh [lobyte(rWY)], a
VBlank.ok

	call AutoBgMapTransfer
	call VBlankCopyBgMap
	call RedrawRowOrColumn
	call VBlankCopy
	call VBlankCopyDouble
	call UpdateMovingBgTiles
	call hDMARoutine
	ld a, bank(PrepareOAMData)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	call PrepareOAMData

	; VBlank-sensitive operations end.

	call Random

	ldh a, [lobyte(hVBlankOccurred)]
	and a
	jr z, VBlank.skipZeroing
	xor a
	ldh [lobyte(hVBlankOccurred)], a

VBlank.skipZeroing
	ldh a, [lobyte(hFrameCounter)]
	and a
	jr z, VBlank.skipDec
	dec a
	ldh [lobyte(hFrameCounter)], a

VBlank.skipDec
	call FadeOutAudio

	ld a, [wAudioROMBank] ; music ROM bank
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a

	cp bank(Audio1_UpdateMusic)
	jr nz, VBlank.checkForAudio2
VBlank.audio1
	call Audio1_UpdateMusic
	jr VBlank.afterMusic
VBlank.checkForAudio2
	cp bank(Audio2_UpdateMusic)
	jr nz, VBlank.audio3
VBlank.audio2
	call Music_DoLowHealthAlarm
	call Audio2_UpdateMusic
	jr VBlank.afterMusic
VBlank.audio3
	call Audio3_UpdateMusic
VBlank.afterMusic

	farcall TrackPlayTime ; keep track of time played

	ldh a, [lobyte(hDisableJoypadPolling)]
	and a
	call z, ReadJoypad

	ld a, [wVBlankSavedROMBank]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a

	pop hl
	pop de
	pop bc
	pop af
	reti


DelayFrame:
; Wait for the next vblank interrupt.
; As a bonus, this saves battery.

.DEFINE NOT_VBLANKED 1

	ld a, NOT_VBLANKED
	ldh [lobyte(hVBlankOccurred)], a
DelayFrame.halt
	halt
	ldh a, [lobyte(hVBlankOccurred)]
	and a
	jr nz, DelayFrame.halt
	ret
