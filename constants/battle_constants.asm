.DEFINE MAX_LEVEL 100

; maximum moves known per mon
.DEFINE NUM_MOVES 4

; significant stat values
.DEFINE BASE_STAT_LEVEL 7
.DEFINE MAX_STAT_LEVEL 13

; VitaminStats indexes (see data/battle/stat_names.asm)
	const_def 1
	const STAT_HEALTH
	const STAT_ATTACK
	const STAT_DEFENSE
	const STAT_SPEED
	const STAT_SPECIAL
.DEFINE NUM_STATS const_value - 1

; StatModTextStrings indexes (see data/battle/stat_mod_names.asm)
	const_def
	const MOD_ATTACK
	const MOD_DEFENSE
	const MOD_SPEED
	const MOD_SPECIAL
	const MOD_ACCURACY
	const MOD_EVASION
	const_skip 2
.DEFINE NUM_STAT_MODS const_value

; Moves struct fields (see data/moves/moves.asm)
.ENUM 0 EXPORT
MOVE_ANIM   db
MOVE_EFFECT db
MOVE_POWER  db
MOVE_TYPE   db
MOVE_ACC    db
MOVE_PP     db
MOVE_LENGTH: ds 0
.ENDE

; battle type constants (wBattleType values)
	const_def
	const BATTLE_TYPE_NORMAL  ; 0
	const BATTLE_TYPE_OLD_MAN ; 1
	const BATTLE_TYPE_SAFARI  ; 2

; damage limits before type effectiveness
.DEFINE MIN_NEUTRAL_DAMAGE 2
.DEFINE MAX_NEUTRAL_DAMAGE 999

; fixed damage constants
.DEFINE SONICBOOM_DAMAGE 20
.DEFINE DRAGON_RAGE_DAMAGE 40

; type effectiveness factors, scaled by 10
.DEFINE SUPER_EFFECTIVE 20
.DEFINE MORE_EFFECTIVE 15
.DEFINE EFFECTIVE 10
.DEFINE NOT_VERY_EFFECTIVE 05
.DEFINE NO_EFFECT 00

; non-volatile statuses
.DEFINE SLP_MASK %111 ; 0-7 turns
	const_def 3
	const PSN ; 3
	const BRN ; 4
	const FRZ ; 5
	const PAR ; 6

.DEFINE MAX_STAT_VALUE 999

; trainer dvs
.DEFINE ATKDEFDV_TRAINER $98
.DEFINE SPDSPCDV_TRAINER $88

; wDamageMultipliers
.DEFINE BIT_STAB_DAMAGE 7
.DEFINE EFFECTIVENESS_MASK %01111111

; wPlayerBattleStatus1 or wEnemyBattleStatus1 bit flags
	const_def
	const STORING_ENERGY           ; 0 ; Bide
	const THRASHING_ABOUT          ; 1 ; Thrash, Petal Dance
	const ATTACKING_MULTIPLE_TIMES ; 2 ; e.g. Double Kick, Fury Attack
	const FLINCHED                 ; 3
	const CHARGING_UP              ; 4 ; e.g. Solar Beam, Fly
	const USING_TRAPPING_MOVE      ; 5 ; e.g. Wrap
	const INVULNERABLE             ; 6 ; charging up Fly/Dig
	const CONFUSED                 ; 7

; wPlayerBattleStatus2 or wEnemyBattleStatus2 bit flags
	const_def
	const USING_X_ACCURACY    ; 0
	const PROTECTED_BY_MIST   ; 1
	const GETTING_PUMPED      ; 2 ; Focus Energy
	const_skip                ; 3 ; unused
	const HAS_SUBSTITUTE_UP   ; 4
	const NEEDS_TO_RECHARGE   ; 5 ; Hyper Beam
	const USING_RAGE          ; 6
	const SEEDED              ; 7 ; Leech Seed

; wPlayerBattleStatus3 or wEnemyBattleStatus3 bit flags
	const_def
	const BADLY_POISONED      ; 0 ; Toxic
	const HAS_LIGHT_SCREEN_UP ; 1
	const HAS_REFLECT_UP      ; 2
	const TRANSFORMED         ; 3
