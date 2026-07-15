; Structured replacement for engine/events/pewter_guys.asm.
+PewterGuys:
	ld hl, wSimulatedJoypadStatesEnd
	ld a, (wSimulatedJoypadStatesIndex)
	dec a ; this decrement causes it to overwrite the last byte before $FF in the list
	ld (wSimulatedJoypadStatesIndex), a
	ld d, 0
	ld e, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, PewterGuysCoordsTable
	ld a, (wWhichPewterGuy)
	add a
	ld b, 0
	ld c, a
	add hl, bc
	ld a, (HL+)
	ld h, (hl)
	ld l, a
	ld a, (wYCoord)
	ld b, a
	ld a, (wXCoord)
	ld c, a
PewterGuys.findMatchingCoordsLoop:
	ld a, (HL+)
	cp b
	jr nz, PewterGuys.nextEntry1
	ld a, (HL+)
	cp c
	jr nz, PewterGuys.nextEntry2
	ld a, (HL+)
	ld h, (hl)
	ld l, a
PewterGuys.copyMovementDataLoop:
	ld a, (HL+)
	cp $ff
	ret z
	ld (de), a
	inc de
	ld a, (wSimulatedJoypadStatesIndex)
	inc a
	ld (wSimulatedJoypadStatesIndex), a
	jr PewterGuys.copyMovementDataLoop
PewterGuys.nextEntry1:
	inc hl
PewterGuys.nextEntry2:
	inc hl
	inc hl
	jr PewterGuys.findMatchingCoordsLoop

PewterGuysCoordsTable:
	.DW PewterMuseumGuyCoords
	.DW PewterGymGuyCoords

; these are the four coordinates of the spaces below, above, to the left and
; to the right of the museum guy, and pointers to different movements for
; the player to make to get positioned before the main movement.
PewterMuseumGuyCoords:
	.DB 18, 27
	.DW PewterMuseumGuyCoords.down
	.DB 16, 27
	.DW PewterMuseumGuyCoords.up
	.DB 17, 26
	.DW PewterMuseumGuyCoords.left
	.DB 17, 28
	.DW PewterMuseumGuyCoords.right

PewterMuseumGuyCoords.down:
	.DB PAD_UP, PAD_UP, $ff
PewterMuseumGuyCoords.up:
	.DB PAD_RIGHT, PAD_LEFT, $ff
PewterMuseumGuyCoords.left:
	.DB PAD_UP, PAD_RIGHT, $ff
PewterMuseumGuyCoords.right:
	.DB PAD_UP, PAD_LEFT, $ff

; these are the five coordinates which trigger the gym guy and pointers to
; different movements for the player to make to get positioned before the
; main movement
; $00 is a pause
PewterGymGuyCoords:
	.DB 16, 34
	.DW PewterGymGuyCoords.one
	.DB 17, 35
	.DW PewterGymGuyCoords.two
	.DB 18, 37
	.DW PewterGymGuyCoords.three
	.DB 19, 37
	.DW PewterGymGuyCoords.four
	.DB 17, 36
	.DW PewterGymGuyCoords.five

PewterGymGuyCoords.one:
	.DB PAD_LEFT, PAD_DOWN, PAD_DOWN, PAD_RIGHT, $ff
PewterGymGuyCoords.two:
	.DB PAD_LEFT, PAD_DOWN, PAD_RIGHT, PAD_LEFT, $ff
PewterGymGuyCoords.three:
	.DB PAD_LEFT, PAD_LEFT, PAD_LEFT, $00, $00, $00, $00, $00, $00, $00, $00, $ff
PewterGymGuyCoords.four:
	.DB PAD_LEFT, PAD_LEFT, PAD_UP, PAD_LEFT, $ff
PewterGymGuyCoords.five:
	.DB PAD_LEFT, PAD_DOWN, PAD_LEFT, $00, $00, $00, $00, $00, $00, $00, $00, $ff

PewterGuysEnd:
