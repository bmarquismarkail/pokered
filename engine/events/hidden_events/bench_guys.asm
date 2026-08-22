PrintBenchGuyText:
	call EnableAutoTextBoxDrawing
	ld hl, BenchGuyTextPointers
	ld a, [wCurMap]
	ld b, a
PrintBenchGuyText.loop
	ld a, [hli]
	cp -1
	ret z
	cp b
	jr z, PrintBenchGuyText.match
	inc hl
	inc hl
	jr PrintBenchGuyText.loop
PrintBenchGuyText.match
	ld a, [hli]
	ld b, a
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp b

	; bug: an 'inc hl' instruction is needed before looping back. When trying to
	; talk to a bench guy from above, this Sprite Facing test will fail, and the
	; next loop iteration will be misaligned within BenchGuyTextPointers table.
	; As a result, the routine will miss the terminator byte, and continue to
	; process data beyond the table boundary.
	; It seems that it will only return after starting to read data from VRAM
	; (According to Pan Docs, during PPU mode 3, reads return garbage value,
	; usually $FF).
	jr nz, PrintBenchGuyText.loop ; player isn't facing the bench guy
	ld a, [hl]
	jp PrintPredefTextID

.INCLUDE "data/events/bench_guys.asm"

ViridianCityPokecenterBenchGuyText:
	text_far WLA_GLOBAL_ViridianCityPokecenterGuyText
	text_end

PewterCityPokecenterBenchGuyText:
	text_far WLA_GLOBAL_PewterCityPokecenterGuyText
	text_end

CeruleanCityPokecenterBenchGuyText:
	text_far WLA_GLOBAL_CeruleanPokecenterGuyText
	text_end

LavenderCityPokecenterBenchGuyText:
	text_far WLA_GLOBAL_LavenderPokecenterGuyText
	text_end

MtMoonPokecenterBenchGuyText:
	text_far WLA_GLOBAL_MtMoonPokecenterBenchGuyText
	text_end

RockTunnelPokecenterBenchGuyText:
	text_far WLA_GLOBAL_RockTunnelPokecenterGuyText
	text_end

UnusedBenchGuyText1:
	text_far WLA_GLOBAL_UnusedBenchGuyText1
	text_end

UnusedBenchGuyText2:
	text_far WLA_GLOBAL_UnusedBenchGuyText2
	text_end

UnusedBenchGuyText3:
	text_far WLA_GLOBAL_UnusedBenchGuyText3
	text_end

VermilionCityPokecenterBenchGuyText:
	text_far WLA_GLOBAL_VermilionPokecenterGuyText
	text_end

CeladonCityPokecenterBenchGuyText:
	text_far WLA_GLOBAL_CeladonCityPokecenterGuyText
	text_end

FuchsiaCityPokecenterBenchGuyText:
	text_far WLA_GLOBAL_FuchsiaCityPokecenterGuyText
	text_end

CinnabarIslandPokecenterBenchGuyText:
	text_far WLA_GLOBAL_CinnabarPokecenterGuyText
	text_end

SaffronCityPokecenterBenchGuyText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, SaffronCityPokecenterBenchGuyText2
	jr nz, SaffronCityPokecenterBenchGuyText.printText
	ld hl, SaffronCityPokecenterBenchGuyText1
SaffronCityPokecenterBenchGuyText.printText
	call PrintText
	jp TextScriptEnd

SaffronCityPokecenterBenchGuyText1:
	text_far WLA_GLOBAL_SaffronCityPokecenterGuyText1
	text_end

SaffronCityPokecenterBenchGuyText2:
	text_far WLA_GLOBAL_SaffronCityPokecenterGuyText2
	text_end

CeladonCityHotelText:
	text_far WLA_GLOBAL_CeladonCityHotelText
	text_end
