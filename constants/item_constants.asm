; item ids
; indexes for:
; - ItemNames (see data/items/names.asm)
; - ItemPrices (see data/items/prices.asm)
; - TechnicalMachinePrices (see data/items/tm_prices.asm)
; - KeyItemFlags (see data/items/key_items.asm)
; - ItemUsePtrTable (see engine/items/item_effects.asm)
	const_def
	const NO_ITEM       ; $00
	const MASTER_BALL   ; $01
	const ULTRA_BALL    ; $02
	const GREAT_BALL    ; $03
	const POKE_BALL     ; $04
	const TOWN_MAP      ; $05
	const BICYCLE       ; $06
	const SURFBOARD     ; $07
	const SAFARI_BALL   ; $08
	const POKEDEX       ; $09
	const MOON_STONE    ; $0A
	const ANTIDOTE      ; $0B
	const BURN_HEAL     ; $0C
	const ICE_HEAL      ; $0D
	const AWAKENING     ; $0E
	const PARLYZ_HEAL   ; $0F
	const FULL_RESTORE  ; $10
	const MAX_POTION    ; $11
	const HYPER_POTION  ; $12
	const SUPER_POTION  ; $13
	const POTION        ; $14
; badges use item IDs (see scripts/CeruleanBadgeHouse.asm)
	const BOULDERBADGE  ; $15
.DEFINE SAFARI_BAIT BOULDERBADGE ; overload
	const CASCADEBADGE  ; $16
.DEFINE SAFARI_ROCK CASCADEBADGE ; overload
	const THUNDERBADGE  ; $17
	const RAINBOWBADGE  ; $18
	const SOULBADGE     ; $19
	const MARSHBADGE    ; $1A
	const VOLCANOBADGE  ; $1B
	const EARTHBADGE    ; $1C
	const ESCAPE_ROPE   ; $1D
	const REPEL         ; $1E
	const OLD_AMBER     ; $1F
	const FIRE_STONE    ; $20
	const THUNDER_STONE ; $21
	const WATER_STONE   ; $22
	const HP_UP         ; $23
	const PROTEIN       ; $24
	const IRON          ; $25
	const CARBOS        ; $26
	const CALCIUM       ; $27
	const RARE_CANDY    ; $28
	const DOME_FOSSIL   ; $29
	const HELIX_FOSSIL  ; $2A
	const SECRET_KEY    ; $2B
	const ITEM_2C       ; $2C ; unused
	const BIKE_VOUCHER  ; $2D
	const X_ACCURACY    ; $2E
	const LEAF_STONE    ; $2F
	const CARD_KEY      ; $30
	const NUGGET        ; $31
	const ITEM_32       ; $32 ; unused
	const POKE_DOLL     ; $33
	const FULL_HEAL     ; $34
	const REVIVE        ; $35
	const MAX_REVIVE    ; $36
	const GUARD_SPEC    ; $37
	const SUPER_REPEL   ; $38
	const MAX_REPEL     ; $39
	const DIRE_HIT      ; $3A
	const COIN          ; $3B
	const FRESH_WATER   ; $3C
	const SODA_POP      ; $3D
	const LEMONADE      ; $3E
	const S_S_TICKET    ; $3F
	const GOLD_TEETH    ; $40
	const X_ATTACK      ; $41
	const X_DEFEND      ; $42
	const X_SPEED       ; $43
	const X_SPECIAL     ; $44
	const COIN_CASE     ; $45
	const OAKS_PARCEL   ; $46
	const ITEMFINDER    ; $47
	const SILPH_SCOPE   ; $48
	const POKE_FLUTE    ; $49
	const LIFT_KEY      ; $4A
	const EXP_ALL       ; $4B
	const OLD_ROD       ; $4C
	const GOOD_ROD      ; $4D
	const SUPER_ROD     ; $4E
	const PP_UP         ; $4F
	const ETHER         ; $50
	const MAX_ETHER     ; $51
	const ELIXER        ; $52
	const MAX_ELIXER    ; $53
.DEFINE NUM_ITEMS const_value - 1

; elevator floors use item IDs (see scripts/CeladonMartElevator.asm and scripts/SilphCoElevator.asm)
	const FLOOR_B2F     ; $54
	const FLOOR_B1F     ; $55
	const FLOOR_1F      ; $56
	const FLOOR_2F      ; $57
	const FLOOR_3F      ; $58
	const FLOOR_4F      ; $59
	const FLOOR_5F      ; $5A
	const FLOOR_6F      ; $5B
	const FLOOR_7F      ; $5C
	const FLOOR_8F      ; $5D
	const FLOOR_9F      ; $5E
	const FLOOR_10F     ; $5F
	const FLOOR_11F     ; $60
	const FLOOR_B4F     ; $61
.DEFINE NUM_FLOORS const_value - 1 - NUM_ITEMS

	const_next $C4

; HMs are defined before TMs, so the actual number of TM definitions
; is not yet available. The TM quantity is hard-coded here and must
; match the actual number below.
.DEFINE NUM_TMS 50

.ARRAYDEFINE NAME tmhm_numbers SIZE NUM_ATTACKS + 1

.DEFINE __tmhm_value__ NUM_TMS + 1

.MACRO add_hm ARGS move, item
; Defines three constants:
; - HM_\1: the item id, starting at $C4
; - \1_TMNUM: the learnable TM/HM flag, starting at 51
; - HM##_MOVE: alias for the move id, equal to the value of \1
	.DEFINE \2 const_value
	.REDEFINE const_value const_value + const_inc
	.IF defined(HM_VALUE)
		.UNDEFINE HM_VALUE
	.ENDIF
	.DEFINE HM_VALUE __tmhm_value__ - NUM_TMS
	.DEFINE HM{%.2d{HM_VALUE}}_MOVE move
	.DEFINE {move}_TMNUM __tmhm_value__
	.ARRAYIN NAME tmhm_numbers INDEX move VALUE __tmhm_value__
	.REDEFINE __tmhm_value__ __tmhm_value__ + (1)
.ENDM

.DEFINE HM01 const_value
	add_hm CUT, HM_CUT          ; $C4
	add_hm FLY, HM_FLY          ; $C5
	add_hm SURF, HM_SURF         ; $C6
	add_hm STRENGTH, HM_STRENGTH     ; $C7
	add_hm FLASH, HM_FLASH        ; $C8
.DEFINE NUM_HMS const_value - HM01

.REDEFINE __tmhm_value__ 1

.MACRO add_tm ARGS move, item
; Defines three constants:
; - TM_\1: the item id, starting at $C9
; - \1_TMNUM: the learnable TM/HM flag, starting at 1
; - TM##_MOVE: alias for the move id, equal to the value of \1
	.DEFINE \2 const_value
	.REDEFINE const_value const_value + const_inc
	.DEFINE TM{%.2d{__tmhm_value__}}_MOVE move
	.DEFINE {move}_TMNUM __tmhm_value__
	.ARRAYIN NAME tmhm_numbers INDEX move VALUE __tmhm_value__
	.REDEFINE __tmhm_value__ __tmhm_value__ + (1)
.ENDM

.DEFINE TM01 const_value
	add_tm MEGA_PUNCH, TM_MEGA_PUNCH   ; $C9
	add_tm RAZOR_WIND, TM_RAZOR_WIND   ; $CA
	add_tm SWORDS_DANCE, TM_SWORDS_DANCE ; $CB
	add_tm WHIRLWIND, TM_WHIRLWIND    ; $CC
	add_tm MEGA_KICK, TM_MEGA_KICK    ; $CD
	add_tm TOXIC, TM_TOXIC        ; $CE
	add_tm HORN_DRILL, TM_HORN_DRILL   ; $CF
	add_tm BODY_SLAM, TM_BODY_SLAM    ; $D0
	add_tm TAKE_DOWN, TM_TAKE_DOWN    ; $D1
	add_tm DOUBLE_EDGE, TM_DOUBLE_EDGE  ; $D2
	add_tm BUBBLEBEAM, TM_BUBBLEBEAM   ; $D3
	add_tm WATER_GUN, TM_WATER_GUN    ; $D4
	add_tm ICE_BEAM, TM_ICE_BEAM     ; $D5
	add_tm BLIZZARD, TM_BLIZZARD     ; $D6
	add_tm HYPER_BEAM, TM_HYPER_BEAM   ; $D7
	add_tm PAY_DAY, TM_PAY_DAY      ; $D8
	add_tm SUBMISSION, TM_SUBMISSION   ; $D9
	add_tm COUNTER, TM_COUNTER      ; $DA
	add_tm SEISMIC_TOSS, TM_SEISMIC_TOSS ; $DB
	add_tm RAGE, TM_RAGE         ; $DC
	add_tm MEGA_DRAIN, TM_MEGA_DRAIN   ; $DD
	add_tm SOLARBEAM, TM_SOLARBEAM    ; $DE
	add_tm DRAGON_RAGE, TM_DRAGON_RAGE  ; $DF
	add_tm THUNDERBOLT, TM_THUNDERBOLT  ; $E0
	add_tm THUNDER, TM_THUNDER      ; $E1
	add_tm EARTHQUAKE, TM_EARTHQUAKE   ; $E2
	add_tm FISSURE, TM_FISSURE      ; $E3
	add_tm DIG, TM_DIG          ; $E4
	add_tm PSYCHIC_M, TM_PSYCHIC_M    ; $E5
	add_tm TELEPORT, TM_TELEPORT     ; $E6
	add_tm MIMIC, TM_MIMIC        ; $E7
	add_tm DOUBLE_TEAM, TM_DOUBLE_TEAM  ; $E8
	add_tm REFLECT, TM_REFLECT      ; $E9
	add_tm BIDE, TM_BIDE         ; $EA
	add_tm METRONOME, TM_METRONOME    ; $EB
	add_tm SELFDESTRUCT, TM_SELFDESTRUCT ; $EC
	add_tm EGG_BOMB, TM_EGG_BOMB     ; $ED
	add_tm FIRE_BLAST, TM_FIRE_BLAST   ; $EE
	add_tm SWIFT, TM_SWIFT        ; $EF
	add_tm SKULL_BASH, TM_SKULL_BASH   ; $F0
	add_tm SOFTBOILED, TM_SOFTBOILED   ; $F1
	add_tm DREAM_EATER, TM_DREAM_EATER  ; $F2
	add_tm SKY_ATTACK, TM_SKY_ATTACK   ; $F3
	add_tm REST, TM_REST         ; $F4
	add_tm THUNDER_WAVE, TM_THUNDER_WAVE ; $F5
	add_tm PSYWAVE, TM_PSYWAVE      ; $F6
	add_tm EXPLOSION, TM_EXPLOSION    ; $F7
	add_tm ROCK_SLIDE, TM_ROCK_SLIDE   ; $F8
	add_tm TRI_ATTACK, TM_TRI_ATTACK   ; $F9
	add_tm SUBSTITUTE, TM_SUBSTITUTE   ; $FA
.ASSERT ((NUM_TMS)-(const_value - TM01)) < 1 && ((NUM_TMS)-(const_value - TM01)) > -1

.DEFINE NUM_TM_HM NUM_TMS + NUM_HMS

; 50 TMs + 5 HMs = 55 learnable TM/HM flags per Pokémon.
; These fit in 7 bytes, with one unused bit left over.
.REDEFINE __tmhm_value__ NUM_TM_HM + 1
.DEFINE UNUSED_TMNUM __tmhm_value__
.DEFINE UNUSED 0
.ARRAYIN NAME tmhm_numbers INDEX UNUSED VALUE UNUSED_TMNUM

.DEFINE MAX_HIDDEN_ITEMS 112
.DEFINE MAX_HIDDEN_COINS 16
