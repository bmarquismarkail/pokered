WriteDMACodeToHRAM:
; Since no other memory is available during OAM DMA,
; DMARoutine is copied to HRAM and executed there.
	ld c, lobyte(hDMARoutine)
	ld b, DMARoutine.End - DMARoutine
	ld hl, DMARoutine
WriteDMACodeToHRAM.copy
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, WriteDMACodeToHRAM.copy
	ret

DMARoutine:
	; initiate DMA
	ld a, hibyte(wShadowOAM)
	ldh [lobyte(rDMA)], a
	; wait for DMA to finish
	ld a, $28
DMARoutine.wait
	dec a
	jr nz, DMARoutine.wait
	ret
DMARoutine.End:
