; Evos+moves data structure:
; - Evolution methods:
;    * db EVOLVE_LEVEL, level, species
;    * db EVOLVE_ITEM, used item, min level (1), species
;    * db EVOLVE_TRADE, min level (1), species
; - db 0 ; no more evolutions
; - Learnset (in increasing level order):
;    * db level, move
; - db 0 ; no more level-up moves

EvosMovesPointerTable:
	table_width 2
	.DW RhydonEvosMoves
	.DW KangaskhanEvosMoves
	.DW NidoranMEvosMoves
	.DW ClefairyEvosMoves
	.DW SpearowEvosMoves
	.DW VoltorbEvosMoves
	.DW NidokingEvosMoves
	.DW SlowbroEvosMoves
	.DW IvysaurEvosMoves
	.DW ExeggutorEvosMoves
	.DW LickitungEvosMoves
	.DW ExeggcuteEvosMoves
	.DW GrimerEvosMoves
	.DW GengarEvosMoves
	.DW NidoranFEvosMoves
	.DW NidoqueenEvosMoves
	.DW CuboneEvosMoves
	.DW RhyhornEvosMoves
	.DW LaprasEvosMoves
	.DW ArcanineEvosMoves
	.DW MewEvosMoves
	.DW GyaradosEvosMoves
	.DW ShellderEvosMoves
	.DW TentacoolEvosMoves
	.DW GastlyEvosMoves
	.DW ScytherEvosMoves
	.DW StaryuEvosMoves
	.DW BlastoiseEvosMoves
	.DW PinsirEvosMoves
	.DW TangelaEvosMoves
	.DW MissingNo1FEvosMoves
	.DW MissingNo20EvosMoves
	.DW GrowlitheEvosMoves
	.DW OnixEvosMoves
	.DW FearowEvosMoves
	.DW PidgeyEvosMoves
	.DW SlowpokeEvosMoves
	.DW KadabraEvosMoves
	.DW GravelerEvosMoves
	.DW ChanseyEvosMoves
	.DW MachokeEvosMoves
	.DW MrMimeEvosMoves
	.DW HitmonleeEvosMoves
	.DW HitmonchanEvosMoves
	.DW ArbokEvosMoves
	.DW ParasectEvosMoves
	.DW PsyduckEvosMoves
	.DW DrowzeeEvosMoves
	.DW GolemEvosMoves
	.DW MissingNo32EvosMoves
	.DW MagmarEvosMoves
	.DW MissingNo34EvosMoves
	.DW ElectabuzzEvosMoves
	.DW MagnetonEvosMoves
	.DW KoffingEvosMoves
	.DW MissingNo38EvosMoves
	.DW MankeyEvosMoves
	.DW SeelEvosMoves
	.DW DiglettEvosMoves
	.DW TaurosEvosMoves
	.DW MissingNo3DEvosMoves
	.DW MissingNo3EEvosMoves
	.DW MissingNo3FEvosMoves
	.DW FarfetchdEvosMoves
	.DW VenonatEvosMoves
	.DW DragoniteEvosMoves
	.DW MissingNo43EvosMoves
	.DW MissingNo44EvosMoves
	.DW MissingNo45EvosMoves
	.DW DoduoEvosMoves
	.DW PoliwagEvosMoves
	.DW JynxEvosMoves
	.DW MoltresEvosMoves
	.DW ArticunoEvosMoves
	.DW ZapdosEvosMoves
	.DW DittoEvosMoves
	.DW MeowthEvosMoves
	.DW KrabbyEvosMoves
	.DW MissingNo4FEvosMoves
	.DW MissingNo50EvosMoves
	.DW MissingNo51EvosMoves
	.DW VulpixEvosMoves
	.DW NinetalesEvosMoves
	.DW PikachuEvosMoves
	.DW RaichuEvosMoves
	.DW MissingNo56EvosMoves
	.DW MissingNo57EvosMoves
	.DW DratiniEvosMoves
	.DW DragonairEvosMoves
	.DW KabutoEvosMoves
	.DW KabutopsEvosMoves
	.DW HorseaEvosMoves
	.DW SeadraEvosMoves
	.DW MissingNo5EEvosMoves
	.DW MissingNo5FEvosMoves
	.DW SandshrewEvosMoves
	.DW SandslashEvosMoves
	.DW OmanyteEvosMoves
	.DW OmastarEvosMoves
	.DW JigglypuffEvosMoves
	.DW WigglytuffEvosMoves
	.DW EeveeEvosMoves
	.DW FlareonEvosMoves
	.DW JolteonEvosMoves
	.DW VaporeonEvosMoves
	.DW MachopEvosMoves
	.DW ZubatEvosMoves
	.DW EkansEvosMoves
	.DW ParasEvosMoves
	.DW PoliwhirlEvosMoves
	.DW PoliwrathEvosMoves
	.DW WeedleEvosMoves
	.DW KakunaEvosMoves
	.DW BeedrillEvosMoves
	.DW MissingNo73EvosMoves
	.DW DodrioEvosMoves
	.DW PrimeapeEvosMoves
	.DW DugtrioEvosMoves
	.DW VenomothEvosMoves
	.DW DewgongEvosMoves
	.DW MissingNo79EvosMoves
	.DW MissingNo7AEvosMoves
	.DW CaterpieEvosMoves
	.DW MetapodEvosMoves
	.DW ButterfreeEvosMoves
	.DW MachampEvosMoves
	.DW MissingNo7FEvosMoves
	.DW GolduckEvosMoves
	.DW HypnoEvosMoves
	.DW GolbatEvosMoves
	.DW MewtwoEvosMoves
	.DW SnorlaxEvosMoves
	.DW MagikarpEvosMoves
	.DW MissingNo86EvosMoves
	.DW MissingNo87EvosMoves
	.DW MukEvosMoves
	.DW MissingNo8AEvosMoves
	.DW KinglerEvosMoves
	.DW CloysterEvosMoves
	.DW MissingNo8CEvosMoves
	.DW ElectrodeEvosMoves
	.DW ClefableEvosMoves
	.DW WeezingEvosMoves
	.DW PersianEvosMoves
	.DW MarowakEvosMoves
	.DW MissingNo92EvosMoves
	.DW HaunterEvosMoves
	.DW AbraEvosMoves
	.DW AlakazamEvosMoves
	.DW PidgeottoEvosMoves
	.DW PidgeotEvosMoves
	.DW StarmieEvosMoves
	.DW BulbasaurEvosMoves
	.DW VenusaurEvosMoves
	.DW TentacruelEvosMoves
	.DW MissingNo9CEvosMoves
	.DW GoldeenEvosMoves
	.DW SeakingEvosMoves
	.DW MissingNo9FEvosMoves
	.DW MissingNoA0EvosMoves
	.DW MissingNoA1EvosMoves
	.DW MissingNoA2EvosMoves
	.DW PonytaEvosMoves
	.DW RapidashEvosMoves
	.DW RattataEvosMoves
	.DW RaticateEvosMoves
	.DW NidorinoEvosMoves
	.DW NidorinaEvosMoves
	.DW GeodudeEvosMoves
	.DW PorygonEvosMoves
	.DW AerodactylEvosMoves
	.DW MissingNoACEvosMoves
	.DW MagnemiteEvosMoves
	.DW MissingNoAEEvosMoves
	.DW MissingNoAFEvosMoves
	.DW CharmanderEvosMoves
	.DW SquirtleEvosMoves
	.DW CharmeleonEvosMoves
	.DW WartortleEvosMoves
	.DW CharizardEvosMoves
	.DW MissingNoB5EvosMoves
	.DW FossilKabutopsEvosMoves
	.DW FossilAerodactylEvosMoves
	.DW MonGhostEvosMoves
	.DW OddishEvosMoves
	.DW GloomEvosMoves
	.DW VileplumeEvosMoves
	.DW BellsproutEvosMoves
	.DW WeepinbellEvosMoves
	.DW VictreebelEvosMoves
	assert_table_length NUM_POKEMON_INDEXES

RhydonEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 30, STOMP
	.DB 35, TAIL_WHIP
	.DB 40, FURY_ATTACK
	.DB 48, HORN_DRILL
	.DB 55, LEER
	.DB 64, TAKE_DOWN
	.DB 0

KangaskhanEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 26, BITE
	.DB 31, TAIL_WHIP
	.DB 36, MEGA_PUNCH
	.DB 41, LEER
	.DB 46, DIZZY_PUNCH
	.DB 0

NidoranMEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 16, NIDORINO
	.DB 0
; Learnset
	.DB 8, HORN_ATTACK
	.DB 14, POISON_STING
	.DB 21, FOCUS_ENERGY
	.DB 29, FURY_ATTACK
	.DB 36, HORN_DRILL
	.DB 43, DOUBLE_KICK
	.DB 0

ClefairyEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, MOON_STONE, 1, CLEFABLE
	.DB 0
; Learnset
	.DB 13, SING
	.DB 18, DOUBLESLAP
	.DB 24, MINIMIZE
	.DB 31, METRONOME
	.DB 39, DEFENSE_CURL
	.DB 48, LIGHT_SCREEN
	.DB 0

SpearowEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 20, FEAROW
	.DB 0
; Learnset
	.DB 9, LEER
	.DB 15, FURY_ATTACK
	.DB 22, MIRROR_MOVE
	.DB 29, DRILL_PECK
	.DB 36, AGILITY
	.DB 0

VoltorbEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 30, ELECTRODE
	.DB 0
; Learnset
	.DB 17, SONICBOOM
	.DB 22, SELFDESTRUCT
	.DB 29, LIGHT_SCREEN
	.DB 36, SWIFT
	.DB 43, EXPLOSION
	.DB 0

NidokingEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 8, HORN_ATTACK
	.DB 14, POISON_STING
	.DB 23, THRASH
	.DB 0

SlowbroEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 18, DISABLE
	.DB 22, HEADBUTT
	.DB 27, GROWL
	.DB 33, WATER_GUN
	.DB 37, WITHDRAW
	.DB 44, AMNESIA
	.DB 55, PSYCHIC_M
	.DB 0

IvysaurEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 32, VENUSAUR
	.DB 0
; Learnset
	.DB 7, LEECH_SEED
	.DB 13, VINE_WHIP
	.DB 22, POISONPOWDER
	.DB 30, RAZOR_LEAF
	.DB 38, GROWTH
	.DB 46, SLEEP_POWDER
	.DB 54, SOLARBEAM
	.DB 0

ExeggutorEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 28, STOMP
	.DB 0

LickitungEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 7, STOMP
	.DB 15, DISABLE
	.DB 23, DEFENSE_CURL
	.DB 31, SLAM
	.DB 39, SCREECH
	.DB 0

ExeggcuteEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, LEAF_STONE, 1, EXEGGUTOR
	.DB 0
; Learnset
	.DB 25, REFLECT
	.DB 28, LEECH_SEED
	.DB 32, STUN_SPORE
	.DB 37, POISONPOWDER
	.DB 42, SOLARBEAM
	.DB 48, SLEEP_POWDER
	.DB 0

GrimerEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 38, MUK
	.DB 0
; Learnset
	.DB 30, POISON_GAS
	.DB 33, MINIMIZE
	.DB 37, SLUDGE
	.DB 42, HARDEN
	.DB 48, SCREECH
	.DB 55, ACID_ARMOR
	.DB 0

GengarEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 29, HYPNOSIS
	.DB 38, DREAM_EATER
	.DB 0

NidoranFEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 16, NIDORINA
	.DB 0
; Learnset
	.DB 8, SCRATCH
	.DB 14, POISON_STING
	.DB 21, TAIL_WHIP
	.DB 29, BITE
	.DB 36, FURY_SWIPES
	.DB 43, DOUBLE_KICK
	.DB 0

NidoqueenEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 8, SCRATCH
	.DB 14, POISON_STING
	.DB 23, BODY_SLAM
	.DB 0

CuboneEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 28, MAROWAK
	.DB 0
; Learnset
	.DB 25, LEER
	.DB 31, FOCUS_ENERGY
	.DB 38, THRASH
	.DB 43, BONEMERANG
	.DB 46, RAGE
	.DB 0

RhyhornEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 42, RHYDON
	.DB 0
; Learnset
	.DB 30, STOMP
	.DB 35, TAIL_WHIP
	.DB 40, FURY_ATTACK
	.DB 45, HORN_DRILL
	.DB 50, LEER
	.DB 55, TAKE_DOWN
	.DB 0

LaprasEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 16, SING
	.DB 20, MIST
	.DB 25, BODY_SLAM
	.DB 31, CONFUSE_RAY
	.DB 38, ICE_BEAM
	.DB 46, HYDRO_PUMP
	.DB 0

ArcanineEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MewEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 10, TRANSFORM
	.DB 20, MEGA_PUNCH
	.DB 30, METRONOME
	.DB 40, PSYCHIC_M
	.DB 0

GyaradosEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 20, BITE
	.DB 25, DRAGON_RAGE
	.DB 32, LEER
	.DB 41, HYDRO_PUMP
	.DB 52, HYPER_BEAM
	.DB 0

ShellderEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, WATER_STONE, 1, CLOYSTER
	.DB 0
; Learnset
	.DB 18, SUPERSONIC
	.DB 23, CLAMP
	.DB 30, AURORA_BEAM
	.DB 39, LEER
	.DB 50, ICE_BEAM
	.DB 0

TentacoolEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 30, TENTACRUEL
	.DB 0
; Learnset
	.DB 7, SUPERSONIC
	.DB 13, WRAP
	.DB 18, POISON_STING
	.DB 22, WATER_GUN
	.DB 27, CONSTRICT
	.DB 33, BARRIER
	.DB 40, SCREECH
	.DB 48, HYDRO_PUMP
	.DB 0

GastlyEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 25, HAUNTER
	.DB 0
; Learnset
	.DB 27, HYPNOSIS
	.DB 35, DREAM_EATER
	.DB 0

ScytherEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 17, LEER
	.DB 20, FOCUS_ENERGY
	.DB 24, DOUBLE_TEAM
	.DB 29, SLASH
	.DB 35, SWORDS_DANCE
	.DB 42, AGILITY
	.DB 0

StaryuEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, WATER_STONE, 1, STARMIE
	.DB 0
; Learnset
	.DB 17, WATER_GUN
	.DB 22, HARDEN
	.DB 27, RECOVER
	.DB 32, SWIFT
	.DB 37, MINIMIZE
	.DB 42, LIGHT_SCREEN
	.DB 47, HYDRO_PUMP
	.DB 0

BlastoiseEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 8, BUBBLE
	.DB 15, WATER_GUN
	.DB 24, BITE
	.DB 31, WITHDRAW
	.DB 42, SKULL_BASH
	.DB 52, HYDRO_PUMP
	.DB 0

PinsirEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 25, SEISMIC_TOSS
	.DB 30, GUILLOTINE
	.DB 36, FOCUS_ENERGY
	.DB 43, HARDEN
	.DB 49, SLASH
	.DB 54, SWORDS_DANCE
	.DB 0

TangelaEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 29, ABSORB
	.DB 32, POISONPOWDER
	.DB 36, STUN_SPORE
	.DB 39, SLEEP_POWDER
	.DB 45, SLAM
	.DB 49, GROWTH
	.DB 0

MissingNo1FEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo20EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

GrowlitheEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, FIRE_STONE, 1, ARCANINE
	.DB 0
; Learnset
	.DB 18, EMBER
	.DB 23, LEER
	.DB 30, TAKE_DOWN
	.DB 39, AGILITY
	.DB 50, FLAMETHROWER
	.DB 0

OnixEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 15, BIND
	.DB 19, ROCK_THROW
	.DB 25, RAGE
	.DB 33, SLAM
	.DB 43, HARDEN
	.DB 0

FearowEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 9, LEER
	.DB 15, FURY_ATTACK
	.DB 25, MIRROR_MOVE
	.DB 34, DRILL_PECK
	.DB 43, AGILITY
	.DB 0

PidgeyEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 18, PIDGEOTTO
	.DB 0
; Learnset
	.DB 5, SAND_ATTACK
	.DB 12, QUICK_ATTACK
	.DB 19, WHIRLWIND
	.DB 28, WING_ATTACK
	.DB 36, AGILITY
	.DB 44, MIRROR_MOVE
	.DB 0

SlowpokeEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 37, SLOWBRO
	.DB 0
; Learnset
	.DB 18, DISABLE
	.DB 22, HEADBUTT
	.DB 27, GROWL
	.DB 33, WATER_GUN
	.DB 40, AMNESIA
	.DB 48, PSYCHIC_M
	.DB 0

KadabraEvosMoves:
; Evolutions
	.DB EVOLVE_TRADE, 1, ALAKAZAM
	.DB 0
; Learnset
	.DB 16, CONFUSION
	.DB 20, DISABLE
	.DB 27, PSYBEAM
	.DB 31, RECOVER
	.DB 38, PSYCHIC_M
	.DB 42, REFLECT
	.DB 0

GravelerEvosMoves:
; Evolutions
	.DB EVOLVE_TRADE, 1, GOLEM
	.DB 0
; Learnset
	.DB 11, DEFENSE_CURL
	.DB 16, ROCK_THROW
	.DB 21, SELFDESTRUCT
	.DB 29, HARDEN
	.DB 36, EARTHQUAKE
	.DB 43, EXPLOSION
	.DB 0

ChanseyEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 24, SING
	.DB 30, GROWL
	.DB 38, MINIMIZE
	.DB 44, DEFENSE_CURL
	.DB 48, LIGHT_SCREEN
	.DB 54, DOUBLE_EDGE
	.DB 0

MachokeEvosMoves:
; Evolutions
	.DB EVOLVE_TRADE, 1, MACHAMP
	.DB 0
; Learnset
	.DB 20, LOW_KICK
	.DB 25, LEER
	.DB 36, FOCUS_ENERGY
	.DB 44, SEISMIC_TOSS
	.DB 52, SUBMISSION
	.DB 0

MrMimeEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 15, CONFUSION
	.DB 23, LIGHT_SCREEN
	.DB 31, DOUBLESLAP
	.DB 39, MEDITATE
	.DB 47, SUBSTITUTE
	.DB 0

HitmonleeEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 33, ROLLING_KICK
	.DB 38, JUMP_KICK
	.DB 43, FOCUS_ENERGY
	.DB 48, HI_JUMP_KICK
	.DB 53, MEGA_KICK
	.DB 0

HitmonchanEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 33, FIRE_PUNCH
	.DB 38, ICE_PUNCH
	.DB 43, THUNDERPUNCH
	.DB 48, MEGA_PUNCH
	.DB 53, COUNTER
	.DB 0

ArbokEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 10, POISON_STING
	.DB 17, BITE
	.DB 27, GLARE
	.DB 36, SCREECH
	.DB 47, ACID
	.DB 0

ParasectEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 13, STUN_SPORE
	.DB 20, LEECH_LIFE
	.DB 30, SPORE
	.DB 39, SLASH
	.DB 48, GROWTH
	.DB 0

PsyduckEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 33, GOLDUCK
	.DB 0
; Learnset
	.DB 28, TAIL_WHIP
	.DB 31, DISABLE
	.DB 36, CONFUSION
	.DB 43, FURY_SWIPES
	.DB 52, HYDRO_PUMP
	.DB 0

DrowzeeEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 26, HYPNO
	.DB 0
; Learnset
	.DB 12, DISABLE
	.DB 17, CONFUSION
	.DB 24, HEADBUTT
	.DB 29, POISON_GAS
	.DB 32, PSYCHIC_M
	.DB 37, MEDITATE
	.DB 0

GolemEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 11, DEFENSE_CURL
	.DB 16, ROCK_THROW
	.DB 21, SELFDESTRUCT
	.DB 29, HARDEN
	.DB 36, EARTHQUAKE
	.DB 43, EXPLOSION
	.DB 0

MissingNo32EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MagmarEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 36, LEER
	.DB 39, CONFUSE_RAY
	.DB 43, FIRE_PUNCH
	.DB 48, SMOKESCREEN
	.DB 52, SMOG
	.DB 55, FLAMETHROWER
	.DB 0

MissingNo34EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

ElectabuzzEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 34, THUNDERSHOCK
	.DB 37, SCREECH
	.DB 42, THUNDERPUNCH
	.DB 49, LIGHT_SCREEN
	.DB 54, THUNDER
	.DB 0

MagnetonEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 21, SONICBOOM
	.DB 25, THUNDERSHOCK
	.DB 29, SUPERSONIC
	.DB 38, THUNDER_WAVE
	.DB 46, SWIFT
	.DB 54, SCREECH
	.DB 0

KoffingEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 35, WEEZING
	.DB 0
; Learnset
	.DB 32, SLUDGE
	.DB 37, SMOKESCREEN
	.DB 40, SELFDESTRUCT
	.DB 45, HAZE
	.DB 48, EXPLOSION
	.DB 0

MissingNo38EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MankeyEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 28, PRIMEAPE
	.DB 0
; Learnset
	.DB 15, KARATE_CHOP
	.DB 21, FURY_SWIPES
	.DB 27, FOCUS_ENERGY
	.DB 33, SEISMIC_TOSS
	.DB 39, THRASH
	.DB 0

SeelEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 34, DEWGONG
	.DB 0
; Learnset
	.DB 30, GROWL
	.DB 35, AURORA_BEAM
	.DB 40, REST
	.DB 45, TAKE_DOWN
	.DB 50, ICE_BEAM
	.DB 0

DiglettEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 26, DUGTRIO
	.DB 0
; Learnset
	.DB 15, GROWL
	.DB 19, DIG
	.DB 24, SAND_ATTACK
	.DB 31, SLASH
	.DB 40, EARTHQUAKE
	.DB 0

TaurosEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 21, STOMP
	.DB 28, TAIL_WHIP
	.DB 35, LEER
	.DB 44, RAGE
	.DB 51, TAKE_DOWN
	.DB 0

MissingNo3DEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo3EEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo3FEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

FarfetchdEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 7, LEER
	.DB 15, FURY_ATTACK
	.DB 23, SWORDS_DANCE
	.DB 31, AGILITY
	.DB 39, SLASH
	.DB 0

VenonatEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 31, VENOMOTH
	.DB 0
; Learnset
	.DB 24, POISONPOWDER
	.DB 27, LEECH_LIFE
	.DB 30, STUN_SPORE
	.DB 35, PSYBEAM
	.DB 38, SLEEP_POWDER
	.DB 43, PSYCHIC_M
	.DB 0

DragoniteEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 10, THUNDER_WAVE
	.DB 20, AGILITY
	.DB 35, SLAM
	.DB 45, DRAGON_RAGE
	.DB 60, HYPER_BEAM
	.DB 0

MissingNo43EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo44EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo45EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

DoduoEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 31, DODRIO
	.DB 0
; Learnset
	.DB 20, GROWL
	.DB 24, FURY_ATTACK
	.DB 30, DRILL_PECK
	.DB 36, RAGE
	.DB 40, TRI_ATTACK
	.DB 44, AGILITY
	.DB 0

PoliwagEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 25, POLIWHIRL
	.DB 0
; Learnset
	.DB 16, HYPNOSIS
	.DB 19, WATER_GUN
	.DB 25, DOUBLESLAP
	.DB 31, BODY_SLAM
	.DB 38, AMNESIA
	.DB 45, HYDRO_PUMP
	.DB 0

JynxEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 18, LICK
	.DB 23, DOUBLESLAP
	.DB 31, ICE_PUNCH
	.DB 39, BODY_SLAM
	.DB 47, THRASH
	.DB 58, BLIZZARD
	.DB 0

MoltresEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 51, LEER
	.DB 55, AGILITY
	.DB 60, SKY_ATTACK
	.DB 0

ArticunoEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 51, BLIZZARD
	.DB 55, AGILITY
	.DB 60, MIST
	.DB 0

ZapdosEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 51, THUNDER
	.DB 55, AGILITY
	.DB 60, LIGHT_SCREEN
	.DB 0

DittoEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MeowthEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 28, PERSIAN
	.DB 0
; Learnset
	.DB 12, BITE
	.DB 17, PAY_DAY
	.DB 24, SCREECH
	.DB 33, FURY_SWIPES
	.DB 44, SLASH
	.DB 0

KrabbyEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 28, KINGLER
	.DB 0
; Learnset
	.DB 20, VICEGRIP
	.DB 25, GUILLOTINE
	.DB 30, STOMP
	.DB 35, CRABHAMMER
	.DB 40, HARDEN
	.DB 0

MissingNo4FEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo50EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo51EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

VulpixEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, FIRE_STONE, 1, NINETALES
	.DB 0
; Learnset
	.DB 16, QUICK_ATTACK
	.DB 21, ROAR
	.DB 28, CONFUSE_RAY
	.DB 35, FLAMETHROWER
	.DB 42, FIRE_SPIN
	.DB 0

NinetalesEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

PikachuEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, THUNDER_STONE, 1, RAICHU
	.DB 0
; Learnset
	.DB 9, THUNDER_WAVE
	.DB 16, QUICK_ATTACK
	.DB 26, SWIFT
	.DB 33, AGILITY
	.DB 43, THUNDER
	.DB 0

RaichuEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo56EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo57EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

DratiniEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 30, DRAGONAIR
	.DB 0
; Learnset
	.DB 10, THUNDER_WAVE
	.DB 20, AGILITY
	.DB 30, SLAM
	.DB 40, DRAGON_RAGE
	.DB 50, HYPER_BEAM
	.DB 0

DragonairEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 55, DRAGONITE
	.DB 0
; Learnset
	.DB 10, THUNDER_WAVE
	.DB 20, AGILITY
	.DB 35, SLAM
	.DB 45, DRAGON_RAGE
	.DB 55, HYPER_BEAM
	.DB 0

KabutoEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 40, KABUTOPS
	.DB 0
; Learnset
	.DB 34, ABSORB
	.DB 39, SLASH
	.DB 44, LEER
	.DB 49, HYDRO_PUMP
	.DB 0

KabutopsEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 34, ABSORB
	.DB 39, SLASH
	.DB 46, LEER
	.DB 53, HYDRO_PUMP
	.DB 0

HorseaEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 32, SEADRA
	.DB 0
; Learnset
	.DB 19, SMOKESCREEN
	.DB 24, LEER
	.DB 30, WATER_GUN
	.DB 37, AGILITY
	.DB 45, HYDRO_PUMP
	.DB 0

SeadraEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 19, SMOKESCREEN
	.DB 24, LEER
	.DB 30, WATER_GUN
	.DB 41, AGILITY
	.DB 52, HYDRO_PUMP
	.DB 0

MissingNo5EEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo5FEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

SandshrewEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 22, SANDSLASH
	.DB 0
; Learnset
	.DB 10, SAND_ATTACK
	.DB 17, SLASH
	.DB 24, POISON_STING
	.DB 31, SWIFT
	.DB 38, FURY_SWIPES
	.DB 0

SandslashEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 10, SAND_ATTACK
	.DB 17, SLASH
	.DB 27, POISON_STING
	.DB 36, SWIFT
	.DB 47, FURY_SWIPES
	.DB 0

OmanyteEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 40, OMASTAR
	.DB 0
; Learnset
	.DB 34, HORN_ATTACK
	.DB 39, LEER
	.DB 46, SPIKE_CANNON
	.DB 53, HYDRO_PUMP
	.DB 0

OmastarEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 34, HORN_ATTACK
	.DB 39, LEER
	.DB 44, SPIKE_CANNON
	.DB 49, HYDRO_PUMP
	.DB 0

JigglypuffEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, MOON_STONE, 1, WIGGLYTUFF
	.DB 0
; Learnset
	.DB 9, POUND
	.DB 14, DISABLE
	.DB 19, DEFENSE_CURL
	.DB 24, DOUBLESLAP
	.DB 29, REST
	.DB 34, BODY_SLAM
	.DB 39, DOUBLE_EDGE
	.DB 0

WigglytuffEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

EeveeEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, FIRE_STONE, 1, FLAREON
	.DB EVOLVE_ITEM, THUNDER_STONE, 1, JOLTEON
	.DB EVOLVE_ITEM, WATER_STONE, 1, VAPOREON
	.DB 0
; Learnset
	.DB 27, QUICK_ATTACK
	.DB 31, TAIL_WHIP
	.DB 37, BITE
	.DB 45, TAKE_DOWN
	.DB 0

FlareonEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 27, QUICK_ATTACK
	.DB 31, EMBER
	.DB 37, TAIL_WHIP
	.DB 40, BITE
	.DB 42, LEER
	.DB 44, FIRE_SPIN
	.DB 48, RAGE
	.DB 54, FLAMETHROWER
	.DB 0

JolteonEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 27, QUICK_ATTACK
	.DB 31, THUNDERSHOCK
	.DB 37, TAIL_WHIP
	.DB 40, THUNDER_WAVE
	.DB 42, DOUBLE_KICK
	.DB 44, AGILITY
	.DB 48, PIN_MISSILE
	.DB 54, THUNDER
	.DB 0

VaporeonEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 27, QUICK_ATTACK
	.DB 31, WATER_GUN
	.DB 37, TAIL_WHIP
	.DB 40, BITE
	.DB 42, ACID_ARMOR
	.DB 44, HAZE
	.DB 48, MIST
	.DB 54, HYDRO_PUMP
	.DB 0

MachopEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 28, MACHOKE
	.DB 0
; Learnset
	.DB 20, LOW_KICK
	.DB 25, LEER
	.DB 32, FOCUS_ENERGY
	.DB 39, SEISMIC_TOSS
	.DB 46, SUBMISSION
	.DB 0

ZubatEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 22, GOLBAT
	.DB 0
; Learnset
	.DB 10, SUPERSONIC
	.DB 15, BITE
	.DB 21, CONFUSE_RAY
	.DB 28, WING_ATTACK
	.DB 36, HAZE
	.DB 0

EkansEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 22, ARBOK
	.DB 0
; Learnset
	.DB 10, POISON_STING
	.DB 17, BITE
	.DB 24, GLARE
	.DB 31, SCREECH
	.DB 38, ACID
	.DB 0

ParasEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 24, PARASECT
	.DB 0
; Learnset
	.DB 13, STUN_SPORE
	.DB 20, LEECH_LIFE
	.DB 27, SPORE
	.DB 34, SLASH
	.DB 41, GROWTH
	.DB 0

PoliwhirlEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, WATER_STONE, 1, POLIWRATH
	.DB 0
; Learnset
	.DB 16, HYPNOSIS
	.DB 19, WATER_GUN
	.DB 26, DOUBLESLAP
	.DB 33, BODY_SLAM
	.DB 41, AMNESIA
	.DB 49, HYDRO_PUMP
	.DB 0

PoliwrathEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 16, HYPNOSIS
	.DB 19, WATER_GUN
	.DB 0

WeedleEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 7, KAKUNA
	.DB 0
; Learnset
	.DB 0

KakunaEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 10, BEEDRILL
	.DB 0
; Learnset
	.DB 0

BeedrillEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 12, FURY_ATTACK
	.DB 16, FOCUS_ENERGY
	.DB 20, TWINEEDLE
	.DB 25, RAGE
	.DB 30, PIN_MISSILE
	.DB 35, AGILITY
	.DB 0

MissingNo73EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

DodrioEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 20, GROWL
	.DB 24, FURY_ATTACK
	.DB 30, DRILL_PECK
	.DB 39, RAGE
	.DB 45, TRI_ATTACK
	.DB 51, AGILITY
	.DB 0

PrimeapeEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 15, KARATE_CHOP
	.DB 21, FURY_SWIPES
	.DB 27, FOCUS_ENERGY
	.DB 37, SEISMIC_TOSS
	.DB 46, THRASH
	.DB 0

DugtrioEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 15, GROWL
	.DB 19, DIG
	.DB 24, SAND_ATTACK
	.DB 35, SLASH
	.DB 47, EARTHQUAKE
	.DB 0

VenomothEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 24, POISONPOWDER
	.DB 27, LEECH_LIFE
	.DB 30, STUN_SPORE
	.DB 38, PSYBEAM
	.DB 43, SLEEP_POWDER
	.DB 50, PSYCHIC_M
	.DB 0

DewgongEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 30, GROWL
	.DB 35, AURORA_BEAM
	.DB 44, REST
	.DB 50, TAKE_DOWN
	.DB 56, ICE_BEAM
	.DB 0

MissingNo79EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo7AEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

CaterpieEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 7, METAPOD
	.DB 0
; Learnset
	.DB 0

MetapodEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 10, BUTTERFREE
	.DB 0
; Learnset
	.DB 0

ButterfreeEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 12, CONFUSION
	.DB 15, POISONPOWDER
	.DB 16, STUN_SPORE
	.DB 17, SLEEP_POWDER
	.DB 21, SUPERSONIC
	.DB 26, WHIRLWIND
	.DB 32, PSYBEAM
	.DB 0

MachampEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 20, LOW_KICK
	.DB 25, LEER
	.DB 36, FOCUS_ENERGY
	.DB 44, SEISMIC_TOSS
	.DB 52, SUBMISSION
	.DB 0

MissingNo7FEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

GolduckEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 28, TAIL_WHIP
	.DB 31, DISABLE
	.DB 39, CONFUSION
	.DB 48, FURY_SWIPES
	.DB 59, HYDRO_PUMP
	.DB 0

HypnoEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 12, DISABLE
	.DB 17, CONFUSION
	.DB 24, HEADBUTT
	.DB 33, POISON_GAS
	.DB 37, PSYCHIC_M
	.DB 43, MEDITATE
	.DB 0

GolbatEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 10, SUPERSONIC
	.DB 15, BITE
	.DB 21, CONFUSE_RAY
	.DB 32, WING_ATTACK
	.DB 43, HAZE
	.DB 0

MewtwoEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 63, BARRIER
	.DB 66, PSYCHIC_M
	.DB 70, RECOVER
	.DB 75, MIST
	.DB 81, AMNESIA
	.DB 0

SnorlaxEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 35, BODY_SLAM
	.DB 41, HARDEN
	.DB 48, DOUBLE_EDGE
	.DB 56, HYPER_BEAM
	.DB 0

MagikarpEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 20, GYARADOS
	.DB 0
; Learnset
	.DB 15, TACKLE
	.DB 0

MissingNo86EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNo87EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MukEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 30, POISON_GAS
	.DB 33, MINIMIZE
	.DB 37, SLUDGE
	.DB 45, HARDEN
	.DB 53, SCREECH
	.DB 60, ACID_ARMOR
	.DB 0

MissingNo8AEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

KinglerEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 20, VICEGRIP
	.DB 25, GUILLOTINE
	.DB 34, STOMP
	.DB 42, CRABHAMMER
	.DB 49, HARDEN
	.DB 0

CloysterEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 50, SPIKE_CANNON
	.DB 0

MissingNo8CEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

ElectrodeEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 17, SONICBOOM
	.DB 22, SELFDESTRUCT
	.DB 29, LIGHT_SCREEN
	.DB 40, SWIFT
	.DB 50, EXPLOSION
	.DB 0

ClefableEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

WeezingEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 32, SLUDGE
	.DB 39, SMOKESCREEN
	.DB 43, SELFDESTRUCT
	.DB 49, HAZE
	.DB 53, EXPLOSION
	.DB 0

PersianEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 12, BITE
	.DB 17, PAY_DAY
	.DB 24, SCREECH
	.DB 37, FURY_SWIPES
	.DB 51, SLASH
	.DB 0

MarowakEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 25, LEER
	.DB 33, FOCUS_ENERGY
	.DB 41, THRASH
	.DB 48, BONEMERANG
	.DB 55, RAGE
	.DB 0

MissingNo92EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

HaunterEvosMoves:
; Evolutions
	.DB EVOLVE_TRADE, 1, GENGAR
	.DB 0
; Learnset
	.DB 29, HYPNOSIS
	.DB 38, DREAM_EATER
	.DB 0

AbraEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 16, KADABRA
	.DB 0
; Learnset
	.DB 0

AlakazamEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 16, CONFUSION
	.DB 20, DISABLE
	.DB 27, PSYBEAM
	.DB 31, RECOVER
	.DB 38, PSYCHIC_M
	.DB 42, REFLECT
	.DB 0

PidgeottoEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 36, PIDGEOT
	.DB 0
; Learnset
	.DB 5, SAND_ATTACK
	.DB 12, QUICK_ATTACK
	.DB 21, WHIRLWIND
	.DB 31, WING_ATTACK
	.DB 40, AGILITY
	.DB 49, MIRROR_MOVE
	.DB 0

PidgeotEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 5, SAND_ATTACK
	.DB 12, QUICK_ATTACK
	.DB 21, WHIRLWIND
	.DB 31, WING_ATTACK
	.DB 44, AGILITY
	.DB 54, MIRROR_MOVE
	.DB 0

StarmieEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

BulbasaurEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 16, IVYSAUR
	.DB 0
; Learnset
	.DB 7, LEECH_SEED
	.DB 13, VINE_WHIP
	.DB 20, POISONPOWDER
	.DB 27, RAZOR_LEAF
	.DB 34, GROWTH
	.DB 41, SLEEP_POWDER
	.DB 48, SOLARBEAM
	.DB 0

VenusaurEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 7, LEECH_SEED
	.DB 13, VINE_WHIP
	.DB 22, POISONPOWDER
	.DB 30, RAZOR_LEAF
	.DB 43, GROWTH
	.DB 55, SLEEP_POWDER
	.DB 65, SOLARBEAM
	.DB 0

TentacruelEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 7, SUPERSONIC
	.DB 13, WRAP
	.DB 18, POISON_STING
	.DB 22, WATER_GUN
	.DB 27, CONSTRICT
	.DB 35, BARRIER
	.DB 43, SCREECH
	.DB 50, HYDRO_PUMP
	.DB 0

MissingNo9CEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

GoldeenEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 33, SEAKING
	.DB 0
; Learnset
	.DB 19, SUPERSONIC
	.DB 24, HORN_ATTACK
	.DB 30, FURY_ATTACK
	.DB 37, WATERFALL
	.DB 45, HORN_DRILL
	.DB 54, AGILITY
	.DB 0

SeakingEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 19, SUPERSONIC
	.DB 24, HORN_ATTACK
	.DB 30, FURY_ATTACK
	.DB 39, WATERFALL
	.DB 48, HORN_DRILL
	.DB 54, AGILITY
	.DB 0

MissingNo9FEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNoA0EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNoA1EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNoA2EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

PonytaEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 40, RAPIDASH
	.DB 0
; Learnset
	.DB 30, TAIL_WHIP
	.DB 32, STOMP
	.DB 35, GROWL
	.DB 39, FIRE_SPIN
	.DB 43, TAKE_DOWN
	.DB 48, AGILITY
	.DB 0

RapidashEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 30, TAIL_WHIP
	.DB 32, STOMP
	.DB 35, GROWL
	.DB 39, FIRE_SPIN
	.DB 47, TAKE_DOWN
	.DB 55, AGILITY
	.DB 0

RattataEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 20, RATICATE
	.DB 0
; Learnset
	.DB 7, QUICK_ATTACK
	.DB 14, HYPER_FANG
	.DB 23, FOCUS_ENERGY
	.DB 34, SUPER_FANG
	.DB 0

RaticateEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 7, QUICK_ATTACK
	.DB 14, HYPER_FANG
	.DB 27, FOCUS_ENERGY
	.DB 41, SUPER_FANG
	.DB 0

NidorinoEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, MOON_STONE, 1, NIDOKING
	.DB 0
; Learnset
	.DB 8, HORN_ATTACK
	.DB 14, POISON_STING
	.DB 23, FOCUS_ENERGY
	.DB 32, FURY_ATTACK
	.DB 41, HORN_DRILL
	.DB 50, DOUBLE_KICK
	.DB 0

NidorinaEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, MOON_STONE, 1, NIDOQUEEN
	.DB 0
; Learnset
	.DB 8, SCRATCH
	.DB 14, POISON_STING
	.DB 23, TAIL_WHIP
	.DB 32, BITE
	.DB 41, FURY_SWIPES
	.DB 50, DOUBLE_KICK
	.DB 0

GeodudeEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 25, GRAVELER
	.DB 0
; Learnset
	.DB 11, DEFENSE_CURL
	.DB 16, ROCK_THROW
	.DB 21, SELFDESTRUCT
	.DB 26, HARDEN
	.DB 31, EARTHQUAKE
	.DB 36, EXPLOSION
	.DB 0

PorygonEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 23, PSYBEAM
	.DB 28, RECOVER
	.DB 35, AGILITY
	.DB 42, TRI_ATTACK
	.DB 0

AerodactylEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 33, SUPERSONIC
	.DB 38, BITE
	.DB 45, TAKE_DOWN
	.DB 54, HYPER_BEAM
	.DB 0

MissingNoACEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MagnemiteEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 30, MAGNETON
	.DB 0
; Learnset
	.DB 21, SONICBOOM
	.DB 25, THUNDERSHOCK
	.DB 29, SUPERSONIC
	.DB 35, THUNDER_WAVE
	.DB 41, SWIFT
	.DB 47, SCREECH
	.DB 0

MissingNoAEEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MissingNoAFEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

CharmanderEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 16, CHARMELEON
	.DB 0
; Learnset
	.DB 9, EMBER
	.DB 15, LEER
	.DB 22, RAGE
	.DB 30, SLASH
	.DB 38, FLAMETHROWER
	.DB 46, FIRE_SPIN
	.DB 0

SquirtleEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 16, WARTORTLE
	.DB 0
; Learnset
	.DB 8, BUBBLE
	.DB 15, WATER_GUN
	.DB 22, BITE
	.DB 28, WITHDRAW
	.DB 35, SKULL_BASH
	.DB 42, HYDRO_PUMP
	.DB 0

CharmeleonEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 36, CHARIZARD
	.DB 0
; Learnset
	.DB 9, EMBER
	.DB 15, LEER
	.DB 24, RAGE
	.DB 33, SLASH
	.DB 42, FLAMETHROWER
	.DB 56, FIRE_SPIN
	.DB 0

WartortleEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 36, BLASTOISE
	.DB 0
; Learnset
	.DB 8, BUBBLE
	.DB 15, WATER_GUN
	.DB 24, BITE
	.DB 31, WITHDRAW
	.DB 39, SKULL_BASH
	.DB 47, HYDRO_PUMP
	.DB 0

CharizardEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 9, EMBER
	.DB 15, LEER
	.DB 24, RAGE
	.DB 36, SLASH
	.DB 46, FLAMETHROWER
	.DB 55, FIRE_SPIN
	.DB 0

MissingNoB5EvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

FossilKabutopsEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

FossilAerodactylEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

MonGhostEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 0

OddishEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 21, GLOOM
	.DB 0
; Learnset
	.DB 15, POISONPOWDER
	.DB 17, STUN_SPORE
	.DB 19, SLEEP_POWDER
	.DB 24, ACID
	.DB 33, PETAL_DANCE
	.DB 46, SOLARBEAM
	.DB 0

GloomEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, LEAF_STONE, 1, VILEPLUME
	.DB 0
; Learnset
	.DB 15, POISONPOWDER
	.DB 17, STUN_SPORE
	.DB 19, SLEEP_POWDER
	.DB 28, ACID
	.DB 38, PETAL_DANCE
	.DB 52, SOLARBEAM
	.DB 0

VileplumeEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 15, POISONPOWDER
	.DB 17, STUN_SPORE
	.DB 19, SLEEP_POWDER
	.DB 0

BellsproutEvosMoves:
; Evolutions
	.DB EVOLVE_LEVEL, 21, WEEPINBELL
	.DB 0
; Learnset
	.DB 13, WRAP
	.DB 15, POISONPOWDER
	.DB 18, SLEEP_POWDER
	.DB 21, STUN_SPORE
	.DB 26, ACID
	.DB 33, RAZOR_LEAF
	.DB 42, SLAM
	.DB 0

WeepinbellEvosMoves:
; Evolutions
	.DB EVOLVE_ITEM, LEAF_STONE, 1, VICTREEBEL
	.DB 0
; Learnset
	.DB 13, WRAP
	.DB 15, POISONPOWDER
	.DB 18, SLEEP_POWDER
	.DB 23, STUN_SPORE
	.DB 29, ACID
	.DB 38, RAZOR_LEAF
	.DB 49, SLAM
	.DB 0

VictreebelEvosMoves:
; Evolutions
	.DB 0
; Learnset
	.DB 13, WRAP
	.DB 15, POISONPOWDER
	.DB 18, SLEEP_POWDER
	.DB 0
