TypeNames:
	table_width 2

	.DW TypeNames.Normal
	.DW TypeNames.Fighting
	.DW TypeNames.Flying
	.DW TypeNames.Poison
	.DW TypeNames.Ground
	.DW TypeNames.Rock
	.DW TypeNames.Bird
	.DW TypeNames.Bug
	.DW TypeNames.Ghost

.REPT UNUSED_TYPES_END - UNUSED_TYPES
	.DW TypeNames.Normal
.ENDR

	.DW TypeNames.Fire
	.DW TypeNames.Water
	.DW TypeNames.Grass
	.DW TypeNames.Electric
	.DW TypeNames.Psychic
	.DW TypeNames.Ice
	.DW TypeNames.Dragon

	assert_table_length NUM_TYPES

TypeNames.Normal: .STRINGMAP pokemon, "NORMAL@"
TypeNames.Fighting: .STRINGMAP pokemon, "FIGHTING@"
TypeNames.Flying: .STRINGMAP pokemon, "FLYING@"
TypeNames.Poison: .STRINGMAP pokemon, "POISON@"
TypeNames.Fire: .STRINGMAP pokemon, "FIRE@"
TypeNames.Water: .STRINGMAP pokemon, "WATER@"
TypeNames.Grass: .STRINGMAP pokemon, "GRASS@"
TypeNames.Electric: .STRINGMAP pokemon, "ELECTRIC@"
TypeNames.Psychic: .STRINGMAP pokemon, "PSYCHIC@"
TypeNames.Ice: .STRINGMAP pokemon, "ICE@"
TypeNames.Ground: .STRINGMAP pokemon, "GROUND@"
TypeNames.Rock: .STRINGMAP pokemon, "ROCK@"
TypeNames.Bird: .STRINGMAP pokemon, "BIRD@"
TypeNames.Bug: .STRINGMAP pokemon, "BUG@"
TypeNames.Ghost: .STRINGMAP pokemon, "GHOST@"
TypeNames.Dragon: .STRINGMAP pokemon, "DRAGON@"
