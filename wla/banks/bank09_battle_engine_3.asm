; Native WLA-DX form of RGBDS section "Battle Engine 3".
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"

PrintMonType:
	CALL $3e94 ; GetPredefRegisters
	PUSH HL
	CALL $1537 ; GetMonHeader
	POP HL
	PUSH HL
	LD A, ($d0be) ; wMonHType1
	CALL PrintType
	LD A, ($d0be)
	LD B, A
	LD A, ($d0bf) ; wMonHType2
	CP B
	POP HL
	JR Z, EraseType2Text
	LD BC, 40
	ADD HL, BC
PrintType:
	PUSH HL
	JR PrintType_
EraseType2Text:
	LD A, $7f
	LD BC, $0013
	ADD HL, BC
	LD BC, $0006
	JP $36e0 ; FillMemory
PrintMoveType:
	CALL $3e94 ; GetPredefRegisters
	PUSH HL
	LD A, (wPlayerMoveType)
PrintType_:
	ADD A
	LD HL, TypeNames
	LD E, A
	LD D, 0
	ADD HL, DE
	LD A, (HL+)
	LD E, A
	LD D, (HL)
	POP HL
	JP $1955 ; PlaceString

TypeNames:
	.DW TypeNames.Normal, TypeNames.Fighting, TypeNames.Flying
	.DW TypeNames.Poison, TypeNames.Ground, TypeNames.Rock
	.DW TypeNames.Bird, TypeNames.Bug, TypeNames.Ghost
	.DW TypeNames.Normal, TypeNames.Normal, TypeNames.Normal
	.DW TypeNames.Normal, TypeNames.Normal, TypeNames.Normal
	.DW TypeNames.Normal, TypeNames.Normal, TypeNames.Normal
	.DW TypeNames.Normal, TypeNames.Normal
	.DW TypeNames.Fire, TypeNames.Water, TypeNames.Grass
	.DW TypeNames.Electric, TypeNames.Psychic, TypeNames.Ice, TypeNames.Dragon
TypeNames.Normal:
	.STRINGMAP pokemon, "NORMAL@"
TypeNames.Fighting:
	.STRINGMAP pokemon, "FIGHTING@"
TypeNames.Flying:
	.STRINGMAP pokemon, "FLYING@"
TypeNames.Poison:
	.STRINGMAP pokemon, "POISON@"
TypeNames.Fire:
	.STRINGMAP pokemon, "FIRE@"
TypeNames.Water:
	.STRINGMAP pokemon, "WATER@"
TypeNames.Grass:
	.STRINGMAP pokemon, "GRASS@"
TypeNames.Electric:
	.STRINGMAP pokemon, "ELECTRIC@"
TypeNames.Psychic:
	.STRINGMAP pokemon, "PSYCHIC@"
TypeNames.Ice:
	.STRINGMAP pokemon, "ICE@"
TypeNames.Ground:
	.STRINGMAP pokemon, "GROUND@"
TypeNames.Rock:
	.STRINGMAP pokemon, "ROCK@"
TypeNames.Bird:
	.STRINGMAP pokemon, "BIRD@"
TypeNames.Bug:
	.STRINGMAP pokemon, "BUG@"
TypeNames.Ghost:
	.STRINGMAP pokemon, "GHOST@"
TypeNames.Dragon:
	.STRINGMAP pokemon, "DRAGON@"
TypeNamesEnd:

SaveTrainerName:
	LD HL, TrainerNamePointers
	LD A, ($d031) ; wTrainerClass
	DEC A
	LD C, A
	LD B, 0
	ADD HL, BC
	ADD HL, BC
	LD A, (HL+)
	LD H, (HL)
	LD L, A
	LD DE, wNameBuffer
SaveTrainerName.CopyCharacter:
	LD A, (HL+)
	LD (DE), A
	INC DE
	CP $50
	JR NZ, SaveTrainerName.CopyCharacter
	RET

TrainerNamePointers:
	.DW TrainerNamePointers.YoungsterName
	.DW TrainerNamePointers.BugCatcherName
	.DW TrainerNamePointers.LassName
	.DW $d04a
	.DW TrainerNamePointers.JrTrainerMName
	.DW TrainerNamePointers.JrTrainerFName
	.DW TrainerNamePointers.PokemaniacName
	.DW TrainerNamePointers.SuperNerdName
	.DW $d04a, $d04a
	.DW TrainerNamePointers.BurglarName
	.DW TrainerNamePointers.EngineerName
	.DW TrainerNamePointers.UnusedJugglerName
	.DW $d04a
	.DW TrainerNamePointers.SwimmerName
	.DW $d04a, $d04a
	.DW TrainerNamePointers.BeautyName
	.DW $d04a
	.DW TrainerNamePointers.RockerName
	.DW TrainerNamePointers.JugglerName
	.DW $d04a, $d04a
	.DW TrainerNamePointers.BlackbeltName
	.DW $d04a
	.DW TrainerNamePointers.ProfOakName
	.DW TrainerNamePointers.ChiefName
	.DW TrainerNamePointers.ScientistName
	.DW $d04a
	.DW TrainerNamePointers.RocketName
	.DW TrainerNamePointers.CooltrainerMName
	.DW TrainerNamePointers.CooltrainerFName
	.DW $d04a, $d04a, $d04a, $d04a, $d04a, $d04a, $d04a, $d04a
	.DW $d04a, $d04a, $d04a, $d04a, $d04a, $d04a, $d04a
TrainerNamePointers.YoungsterName:
	.STRINGMAP pokemon, "YOUNGSTER@"
TrainerNamePointers.BugCatcherName:
	.STRINGMAP pokemon, "BUG CATCHER@"
TrainerNamePointers.LassName:
	.STRINGMAP pokemon, "LASS@"
TrainerNamePointers.JrTrainerMName:
	.STRINGMAP pokemon, "JR.TRAINER♂@"
TrainerNamePointers.JrTrainerFName:
	.STRINGMAP pokemon, "JR.TRAINER♀@"
TrainerNamePointers.PokemaniacName:
	.STRINGMAP pokemon, "POKéMANIAC@"
TrainerNamePointers.SuperNerdName:
	.STRINGMAP pokemon, "SUPER NERD@"
TrainerNamePointers.BurglarName:
	.STRINGMAP pokemon, "BURGLAR@"
TrainerNamePointers.EngineerName:
	.STRINGMAP pokemon, "ENGINEER@"
TrainerNamePointers.UnusedJugglerName:
	.STRINGMAP pokemon, "JUGGLER@"
TrainerNamePointers.SwimmerName:
	.STRINGMAP pokemon, "SWIMMER@"
TrainerNamePointers.BeautyName:
	.STRINGMAP pokemon, "BEAUTY@"
TrainerNamePointers.RockerName:
	.STRINGMAP pokemon, "ROCKER@"
TrainerNamePointers.JugglerName:
	.STRINGMAP pokemon, "JUGGLER@"
TrainerNamePointers.BlackbeltName:
	.STRINGMAP pokemon, "BLACKBELT@"
TrainerNamePointers.ProfOakName:
	.STRINGMAP pokemon, "PROF.OAK@"
TrainerNamePointers.ChiefName:
	.STRINGMAP pokemon, "CHIEF@"
TrainerNamePointers.ScientistName:
	.STRINGMAP pokemon, "SCIENTIST@"
TrainerNamePointers.RocketName:
	.STRINGMAP pokemon, "ROCKET@"
TrainerNamePointers.CooltrainerMName:
	.STRINGMAP pokemon, "COOLTRAINER♂@"
TrainerNamePointers.CooltrainerFName:
	.STRINGMAP pokemon, "COOLTRAINER♀@"

FocusEnergyEffect_:
	LD HL, wPlayerBattleStatus2
	LDH A, ($f3)
	AND A
	JR Z, FocusEnergyEffect_.notEnemy
	LD HL, wEnemyBattleStatus2
FocusEnergyEffect_.notEnemy:
	BIT 2, (HL)
	JR NZ, FocusEnergyEffect_.alreadyUsing
	SET 2, (HL)
	LD HL, $7ba8 ; PlayCurrentMoveAnimation
	LD B, $0f
	CALL Bankswitch
	LD HL, GettingPumpedText
	JP PrintText
FocusEnergyEffect_.alreadyUsing:
	LD C, 50
	CALL DelayFrames
	LD HL, $7b53 ; PrintButItFailedText_
	LD B, $0f
	JP Bankswitch
GettingPumpedText:
	.DB $0a, $17
	.DW $499b
	.DB $25, $50
BattleEngine3End:
