; Native WLA-DX form of the four RGBDS Hidden Events 4 sources.
GymStatues:
	CALL EnableAutoTextBoxDrawing
	LD A, (wSpritePlayerStateData1FacingDirection)
	CP $04 ; SPRITE_FACING_UP
	RET NZ
	LD HL, MapBadgeFlags
	LD A, (wCurMap)
	LD B, A
GymStatues.loop:
	LD A, (HL+)
	CP $ff
	RET Z
	CP B
	JR Z, GymStatues.match
	INC HL
	JR GymStatues.loop
GymStatues.match:
	LD B, (HL)
	LD A, (wBeatGymFlags)
	AND B
	CP B
	LD A, $0d ; GymStatueText2
	JR Z, GymStatues.haveBadge
	LD A, $0c ; GymStatueText1
GymStatues.haveBadge:
	JP $3ef5 ; PrintPredefTextID

MapBadgeFlags:
	.DB $36, $01 ; PEWTER_GYM, BOULDERBADGE
	.DB $41, $02 ; CERULEAN_GYM, CASCADEBADGE
	.DB $5c, $04 ; VERMILION_GYM, THUNDERBADGE
	.DB $86, $08 ; CELADON_GYM, RAINBOWBADGE
	.DB $9d, $10 ; FUCHSIA_GYM, SOULBADGE
	.DB $b2, $20 ; SAFFRON_GYM, MARSHBADGE
	.DB $a6, $40 ; CINNABAR_GYM, VOLCANOBADGE
	.DB $2d, $80 ; VIRIDIAN_GYM, EARTHBADGE
	.DB $ff

GymStatueText1:
	.DB $17
	.DW $4275
	.DB $22, $50
GymStatueText2:
	.DB $17
	.DW $42a5
	.DB $22, $50

PrintBenchGuyText:
	CALL EnableAutoTextBoxDrawing
	LD HL, BenchGuyTextPointers
	LD A, (wCurMap)
	LD B, A
PrintBenchGuyText.loop:
	LD A, (HL+)
	CP $ff
	RET Z
	CP B
	JR Z, PrintBenchGuyText.match
	INC HL
	INC HL
	JR PrintBenchGuyText.loop
PrintBenchGuyText.match:
	LD A, (HL+)
	LD B, A
	LD A, (wSpritePlayerStateData1FacingDirection)
	CP B
	JR NZ, PrintBenchGuyText.loop ; preserves the original misaligned-loop bug
	LD A, (HL)
	JP $3ef5 ; PrintPredefTextID

BenchGuyTextPointers:
	.DB $29, $08, $0f ; VIRIDIAN_POKECENTER
	.DB $3a, $08, $10 ; PEWTER_POKECENTER
	.DB $40, $08, $11 ; CERULEAN_POKECENTER
	.DB $8d, $08, $12 ; LAVENDER_POKECENTER
	.DB $59, $08, $13 ; VERMILION_POKECENTER
	.DB $85, $08, $14 ; CELADON_POKECENTER
	.DB $8c, $08, $15 ; CELADON_HOTEL
	.DB $9a, $08, $16 ; FUCHSIA_POKECENTER
	.DB $ab, $08, $17 ; CINNABAR_POKECENTER
	.DB $b6, $08, $18 ; SAFFRON_POKECENTER
	.DB $44, $08, $19 ; MT_MOON_POKECENTER
	.DB $51, $08, $1a ; ROCK_TUNNEL_POKECENTER
	.DB $ff

ViridianCityPokecenterBenchGuyText:
	.DB $17
	.DW $42d7
	.DB $22, $50
PewterCityPokecenterBenchGuyText:
	.DB $17
	.DW $430c
	.DB $22, $50
CeruleanCityPokecenterBenchGuyText:
	.DB $17
	.DW $4353
	.DB $22, $50
LavenderCityPokecenterBenchGuyText:
	.DB $17
	.DW $4386
	.DB $22, $50
MtMoonPokecenterBenchGuyText:
	.DB $17
	.DW $43c2
	.DB $22, $50
RockTunnelPokecenterBenchGuyText:
	.DB $17
	.DW $43fc
	.DB $22, $50
UnusedBenchGuyText1:
	.DB $17
	.DW $4426
	.DB $22, $50
UnusedBenchGuyText2:
	.DB $17
	.DW $4442
	.DB $22, $50
UnusedBenchGuyText3:
	.DB $17
	.DW $4460
	.DB $22, $50
VermilionCityPokecenterBenchGuyText:
	.DB $17
	.DW $448e
	.DB $22, $50
CeladonCityPokecenterBenchGuyText:
	.DB $17
	.DW $4531
	.DB $22, $50
FuchsiaCityPokecenterBenchGuyText:
	.DB $17
	.DW $455f
	.DB $22, $50
CinnabarIslandPokecenterBenchGuyText:
	.DB $17
	.DW $45af
	.DB $22, $50

SaffronCityPokecenterBenchGuyText:
	.DB $08 ; text_asm
	LD A, (wSilphCoGiovanniEvent)
	BIT 7, A ; EVENT_BEAT_SILPH_CO_GIOVANNI
	LD HL, SaffronCityPokecenterBenchGuyText2
	JR NZ, SaffronCityPokecenterBenchGuyText.printText
	LD HL, SaffronCityPokecenterBenchGuyText1
SaffronCityPokecenterBenchGuyText.printText:
	CALL PrintText
	JP $24d7 ; TextScriptEnd
SaffronCityPokecenterBenchGuyText1:
	.DB $17
	.DW $4621
	.DB $22, $50
SaffronCityPokecenterBenchGuyText2:
	.DB $17
	.DW $4664
	.DB $22, $50
CeladonCityHotelText:
	.DB $17
	.DW $46a4
	.DB $22, $50
	RET ; unused

UnusedPredefText:
	.DB $50

PrintBookcaseText:
	CALL EnableAutoTextBoxDrawing
	LD A, $0e ; BookcaseText
	JP $3ef5 ; PrintPredefTextID
BookcaseText:
	.DB $17
	.DW $46c9
	.DB $22, $50

OpenPokemonCenterPC:
	LD A, (wSpritePlayerStateData1FacingDirection)
	CP $04 ; SPRITE_FACING_UP
	RET NZ
	CALL EnableAutoTextBoxDrawing
	LD A, $01 ; BIT_NO_AUTO_TEXT_BOX
	LD (wAutoTextBoxDrawingControl), A
	LD A, $1f ; PokemonCenterPCText
	JP $3ef5 ; PrintPredefTextID
PokemonCenterPCText:
	.DB $f9 ; script_pokecenter_pc
HiddenEvents4End:
