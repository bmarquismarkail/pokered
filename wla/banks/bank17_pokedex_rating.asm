; Native WLA-DX form of engine/events/pokedex_rating.asm.
DisplayDexRating:
	LD HL, wPokedexSeen
	LD B, wPokedexSeenEnd - wPokedexSeen
	CALL $2b7f ; CountSetBits
	LD A, (wNumSetBits)
	LDH ($db), A ; hDexRatingNumMonsSeen
	LD HL, wPokedexOwned
	LD B, wPokedexOwnedEnd - wPokedexOwned
	CALL $2b7f ; CountSetBits
	LD A, (wNumSetBits)
	LDH ($dc), A ; hDexRatingNumMonsOwned
	LD HL, DexRatingsTable
DisplayDexRating.findRating:
	LD A, (HL+)
	LD B, A
	LDH A, ($dc) ; hDexRatingNumMonsOwned
	CP B
	JR C, DisplayDexRating.foundRating
	INC HL
	INC HL
	JR DisplayDexRating.findRating
DisplayDexRating.foundRating:
	LD A, (HL+)
	LD H, (HL)
	LD L, A
	LD A, (wEventFlags)
	BIT 3, A ; EVENT_HALL_OF_FAME_DEX_RATING
	RES 3, A
	LD (wEventFlags), A
	JR NZ, DisplayDexRating.hallOfFame
	PUSH HL
	LD HL, DexCompletionText
	CALL PrintText
	POP HL
	CALL PrintText
	LD B, $1f
	LD HL, $513b ; PlayPokedexRatingSfx
	CALL Bankswitch
	JP WaitForTextScrollButtonPress
DisplayDexRating.hallOfFame:
	LD DE, wDexRatingNumMonsSeen
	LDH A, ($db) ; hDexRatingNumMonsSeen
	LD (DE), A
	INC DE
	LDH A, ($dc) ; hDexRatingNumMonsOwned
	LD (DE), A
	INC DE
DisplayDexRating.copyRatingTextLoop:
	LD A, (HL+)
	CP $50 ; "@"
	JR Z, DisplayDexRating.doneCopying
	LD (DE), A
	INC DE
	JR DisplayDexRating.copyRatingTextLoop
DisplayDexRating.doneCopying:
	LD (DE), A
	RET

DexCompletionText:
	.DB $17
	.DW $580c ; _DexCompletionText
	.DB $25, $50

DexRatingsTable:
	.DB 10
	.DW DexRatingText_Own0To9
	.DB 20
	.DW DexRatingText_Own10To19
	.DB 30
	.DW DexRatingText_Own20To29
	.DB 40
	.DW DexRatingText_Own30To39
	.DB 50
	.DW DexRatingText_Own40To49
	.DB 60
	.DW DexRatingText_Own50To59
	.DB 70
	.DW DexRatingText_Own60To69
	.DB 80
	.DW DexRatingText_Own70To79
	.DB 90
	.DW DexRatingText_Own80To89
	.DB 100
	.DW DexRatingText_Own90To99
	.DB 110
	.DW DexRatingText_Own100To109
	.DB 120
	.DW DexRatingText_Own110To119
	.DB 130
	.DW DexRatingText_Own120To129
	.DB 140
	.DW DexRatingText_Own130To139
	.DB 150
	.DW DexRatingText_Own140To149
	.DB 152 ; NUM_POKEMON + 1
	.DW DexRatingText_Own150To151

DexRatingText_Own0To9:
	.DB $17
	.DW $5858
	.DB $25, $50
DexRatingText_Own10To19:
	.DB $17
	.DW $5893
	.DB $25, $50
DexRatingText_Own20To29:
	.DB $17
	.DW $58cc
	.DB $25, $50
DexRatingText_Own30To39:
	.DB $17
	.DW $5903
	.DB $25, $50
DexRatingText_Own40To49:
	.DB $17
	.DW $593d
	.DB $25, $50
DexRatingText_Own50To59:
	.DB $17
	.DW $596d
	.DB $25, $50
DexRatingText_Own60To69:
	.DB $17
	.DW $59b8
	.DB $25, $50
DexRatingText_Own70To79:
	.DB $17
	.DW $59d9
	.DB $25, $50
DexRatingText_Own80To89:
	.DB $17
	.DW $5a03
	.DB $25, $50
DexRatingText_Own90To99:
	.DB $17
	.DW $5a2e
	.DB $25, $50
DexRatingText_Own100To109:
	.DB $17
	.DW $5a60
	.DB $25, $50
DexRatingText_Own110To119:
	.DB $17
	.DW $5aa8
	.DB $25, $50
DexRatingText_Own120To129:
	.DB $17
	.DW $5ad9
	.DB $25, $50
DexRatingText_Own130To139:
	.DB $17
	.DW $5b0a
	.DB $25, $50
DexRatingText_Own140To149:
	.DB $17
	.DW $5b39
	.DB $25, $50
DexRatingText_Own150To151:
	.DB $17
	.DW $5b6f
	.DB $25, $50
PokedexRatingEnd:
