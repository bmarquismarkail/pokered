TrainerNamePointers:
; These are only used for trainers' defeat speeches.
; They were originally shortened variants of the trainer class names
; in the Japanese versions, but are now redundant with TrainerNames.
	table_width 2
	.DW TrainerNamePointers.YoungsterName
	.DW TrainerNamePointers.BugCatcherName
	.DW TrainerNamePointers.LassName
	.DW wTrainerName
	.DW TrainerNamePointers.JrTrainerMName
	.DW TrainerNamePointers.JrTrainerFName
	.DW TrainerNamePointers.PokemaniacName
	.DW TrainerNamePointers.SuperNerdName
	.DW wTrainerName
	.DW wTrainerName
	.DW TrainerNamePointers.BurglarName
	.DW TrainerNamePointers.EngineerName
	.DW TrainerNamePointers.UnusedJugglerName
	.DW wTrainerName
	.DW TrainerNamePointers.SwimmerName
	.DW wTrainerName
	.DW wTrainerName
	.DW TrainerNamePointers.BeautyName
	.DW wTrainerName
	.DW TrainerNamePointers.RockerName
	.DW TrainerNamePointers.JugglerName
	.DW wTrainerName
	.DW wTrainerName
	.DW TrainerNamePointers.BlackbeltName
	.DW wTrainerName
	.DW TrainerNamePointers.ProfOakName
	.DW TrainerNamePointers.ChiefName
	.DW TrainerNamePointers.ScientistName
	.DW wTrainerName
	.DW TrainerNamePointers.RocketName
	.DW TrainerNamePointers.CooltrainerMName
	.DW TrainerNamePointers.CooltrainerFName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	.DW wTrainerName
	assert_table_length NUM_TRAINERS

TrainerNamePointers.YoungsterName: .STRINGMAP pokemon, "YOUNGSTER@"
TrainerNamePointers.BugCatcherName: .STRINGMAP pokemon, "BUG CATCHER@"
TrainerNamePointers.LassName: .STRINGMAP pokemon, "LASS@"
TrainerNamePointers.JrTrainerMName: .STRINGMAP pokemon, "JR.TRAINER♂@"
TrainerNamePointers.JrTrainerFName: .STRINGMAP pokemon, "JR.TRAINER♀@"
TrainerNamePointers.PokemaniacName: .STRINGMAP pokemon, "POKéMANIAC@"
TrainerNamePointers.SuperNerdName: .STRINGMAP pokemon, "SUPER NERD@"
TrainerNamePointers.BurglarName: .STRINGMAP pokemon, "BURGLAR@"
TrainerNamePointers.EngineerName: .STRINGMAP pokemon, "ENGINEER@"
TrainerNamePointers.UnusedJugglerName: .STRINGMAP pokemon, "JUGGLER@"
TrainerNamePointers.SwimmerName: .STRINGMAP pokemon, "SWIMMER@"
TrainerNamePointers.BeautyName: .STRINGMAP pokemon, "BEAUTY@"
TrainerNamePointers.RockerName: .STRINGMAP pokemon, "ROCKER@"
TrainerNamePointers.JugglerName: .STRINGMAP pokemon, "JUGGLER@"
TrainerNamePointers.BlackbeltName: .STRINGMAP pokemon, "BLACKBELT@"
TrainerNamePointers.ProfOakName: .STRINGMAP pokemon, "PROF.OAK@"
TrainerNamePointers.ChiefName: .STRINGMAP pokemon, "CHIEF@"
TrainerNamePointers.ScientistName: .STRINGMAP pokemon, "SCIENTIST@"
TrainerNamePointers.RocketName: .STRINGMAP pokemon, "ROCKET@"
TrainerNamePointers.CooltrainerMName: .STRINGMAP pokemon, "COOLTRAINER♂@"
TrainerNamePointers.CooltrainerFName: .STRINGMAP pokemon, "COOLTRAINER♀@"
