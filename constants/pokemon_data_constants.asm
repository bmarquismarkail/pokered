; base data struct members (see data/pokemon/base_stats/*.asm)
.ENUM 0 EXPORT
BASE_DEX_NO      db
BASE_STATS       dsb NUM_STATS
.ENDE
.ENUM BASE_STATS EXPORT
BASE_HP          db
BASE_ATK         db
BASE_DEF         db
BASE_SPD         db
BASE_SPC         db
BASE_TYPES       dw
.ENDE
.ENUM BASE_TYPES EXPORT
BASE_TYPE_1      db
BASE_TYPE_2      db
BASE_CATCH_RATE  db
BASE_EXP         db
BASE_PIC_SIZE    db
BASE_FRONTPIC    dw
BASE_BACKPIC     dw
BASE_MOVES       dsb NUM_MOVES
BASE_GROWTH_RATE db
BASE_TMHM        dsb (NUM_TM_HM + 7) / 8
BASE_DATA_PADDING dsb 1
BASE_DATA_SIZE: ds 0
.ENDE

; party_struct members (see macros/ram.asm)
.ENUM 0 EXPORT
MON_SPECIES    db
MON_HP         dw
MON_BOX_LEVEL  db
MON_STATUS     db
MON_TYPE       dw
.ENDE
.ENUM MON_TYPE EXPORT
MON_TYPE1      db
MON_TYPE2      db
MON_CATCH_RATE db
MON_MOVES      dsb NUM_MOVES
MON_OTID       dw
MON_EXP        dsb 3
MON_HP_EXP     dw
MON_ATK_EXP    dw
MON_DEF_EXP    dw
MON_SPD_EXP    dw
MON_SPC_EXP    dw
MON_DVS        dw
MON_PP         dsb NUM_MOVES
BOXMON_STRUCT_LENGTH: ds 0
MON_LEVEL      db
MON_STATS      dsb NUM_STATS * 2
.ENDE
.ENUM MON_STATS EXPORT
MON_MAXHP      dw
MON_ATK        dw
MON_DEF        dw
MON_SPD        dw
MON_SPC        dw
PARTYMON_STRUCT_LENGTH: ds 0
.ENDE

.DEFINE PARTY_LENGTH 6

.DEFINE MONS_PER_BOX 20
.DEFINE NUM_BOXES 12

.DEFINE HOF_MON $10
.DEFINE HOF_TEAM PARTY_LENGTH * HOF_MON
.DEFINE HOF_TEAM_CAPACITY 50

; mon data locations
; Note that some values are not supported by all functions that use these values.
	const_def
	const PLAYER_PARTY_DATA ; 0
	const ENEMY_PARTY_DATA  ; 1
	const BOX_DATA          ; 2
	const DAYCARE_DATA      ; 3
	const BATTLE_MON_DATA   ; 4

; Evolution types
	const_def 1
	const EVOLVE_LEVEL ; 1
	const EVOLVE_ITEM  ; 2
	const EVOLVE_TRADE ; 3

; evolution data (see data/pokemon/evos_moves.asm)
.DEFINE NUM_EVOS_IN_BUFFER 3

; wMonHGrowthRate values
; GrowthRateTable indexes (see data/growth_rates.asm)
	const_def
	const GROWTH_MEDIUM_FAST
	const GROWTH_SLIGHTLY_FAST
	const GROWTH_SLIGHTLY_SLOW
	const GROWTH_MEDIUM_SLOW
	const GROWTH_FAST
	const GROWTH_SLOW
.DEFINE NUM_GROWTH_RATES const_value

; wild data (see data/wild/maps/*.asm)
.DEFINE NUM_WILDMONS 10
.DEFINE WILDDATA_LENGTH 1 + NUM_WILDMONS * 2

; PP in box_struct (see macros/ram.asm)
.DEFINE PP_UP_MASK %11000000 ; number of PP Up used
.DEFINE PP_MASK %00111111 ; currently remaining PP
