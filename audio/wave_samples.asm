; This file is INCLUDEd three times, once for each audio engine.

	.DW {WAVE_POINTERS_LABEL}.wave0
	.DW {WAVE_POINTERS_LABEL}.wave1
	.DW {WAVE_POINTERS_LABEL}.wave2
	.DW {WAVE_POINTERS_LABEL}.wave3
	.DW {WAVE_POINTERS_LABEL}.wave4
	.DW {WAVE_POINTERS_LABEL}.wave5 ; used in the Lavender Town and Pokemon Tower themes
	.DW {WAVE_POINTERS_LABEL}.wave5 ; unused
	.DW {WAVE_POINTERS_LABEL}.wave5 ; unused
	.DW {WAVE_POINTERS_LABEL}.wave5 ; unused

; these are the definitions for the channel 3 instruments
; each instrument definition is made up of 32 points (nibbles) that form
; the graph of the wave
; the current instrument is copied to _AUD3WAVERAM
{WAVE_POINTERS_LABEL}.wave0:
	dn  0,  2,  4,  6,  8, 10, 12, 14, 15, 15, 15, 14, 14, 13, 13, 12, 12, 11, 10,  9,  8,  7,  6,  5,  4,  4,  3,  3,  2,  2,  1,  1

{WAVE_POINTERS_LABEL}.wave1:
	dn  0,  2,  4,  6,  8, 10, 12, 14, 14, 15, 15, 15, 15, 14, 14, 14, 13, 13, 12, 11, 10,  9,  8,  7,  6,  5,  4,  3,  2,  2,  1,  1

{WAVE_POINTERS_LABEL}.wave2:
	dn  1,  3,  6,  9, 11, 13, 14, 14, 14, 14, 15, 15, 15, 15, 14, 13, 13, 14, 15, 15, 15, 15, 14, 14, 14, 14, 13, 11,  9,  6,  3,  1

{WAVE_POINTERS_LABEL}.wave3:
	dn  0,  2,  4,  6,  8, 10, 12, 13, 14, 15, 15, 14, 13, 14, 15, 15, 14, 14, 13, 12, 11, 10,  9,  8,  7,  6,  5,  4,  3,  2,  1,  0

{WAVE_POINTERS_LABEL}.wave4:
	dn  0,  1,  2,  3,  4,  5,  6,  7,  8, 10, 12, 13, 14, 14, 15,  7,  7, 15, 14, 14, 13, 12, 10,  8,  7,  6,  5,  4,  3,  2,  1,  0

; duty 5 reads from sfx data
{WAVE_POINTERS_LABEL}.wave5:
; in audio 1: (used by audio/music/lavender.asm)
;	dn  2,  1, 14,  2,  3,  3,  2,  8, 14,  1,  2,  2, 15, 15, 14, 10,  1,  0,  1,  4, 13, 12,  1,  0, 14,  3,  4,  1,  5,  1,  7,  3
; in audio 2:
;	dn 14, 12,  0,  2,  2,  0,  9,  1,  0,  7, 12,  0,  2,  0,  8,  1,  0,  7, 13,  0,  2,  0,  9,  1,  0,  7, 12,  0,  2, 12, 10,  1
; in audio 3: (used by audio/music/pokemontower.asm)
;	dn  2,  1, 14,  2,  3,  3,  2,  8, 14,  1,  2,  2, 15, 15,  2,  2, 15,  7,  2,  4,  2,  2, 15,  7,  3,  4,  2,  4, 15,  7,  4,  4
