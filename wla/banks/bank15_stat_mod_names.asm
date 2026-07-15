; Names used by move-effect stat modifiers (Pokémon encoding).
StatModTextStrings:
.DB $80, $93, $93, $80, $82, $8A, $50
.DB $83, $84, $85, $84, $8D, $92, $84
.DB $50, $92, $8F, $84, $84, $83, $50
.DB $92, $8F, $84, $82, $88, $80, $8B
.DB $50, $80, $82, $82, $94, $91, $80
.DB $82, $98, $50, $84, $95, $80, $83
.DB $84, $50
StatModTextStringsEnd:
.ASSERT StatModTextStringsEnd - StatModTextStrings == 44
