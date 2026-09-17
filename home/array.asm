; skips a text entries, each of size NAME_LENGTH (like trainer name, OT name, rival name, ...)
; hl: base pointer, will be incremented by NAME_LENGTH * a
SkipFixedLengthTextEntries:
	and a
	ret z
	ld bc, NAME_LENGTH
SkipFixedLengthTextEntries.skipLoop
	add hl, bc
	dec a
	jr nz, SkipFixedLengthTextEntries.skipLoop
	ret

AddNTimes:
; add bc to hl a times
	and a
	ret z
AddNTimes.loop
	add hl, bc
	dec a
	jr nz, AddNTimes.loop
	ret
