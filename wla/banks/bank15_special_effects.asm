SpecialEffects:
.DB $03, $07, $08, $10, $11, $1D, $1E, $27, $28, $29, $2B, $2C, $2D, $30
SpecialEffectsCont:
.DB $1B, $2A, $FF
SpecialEffectsEnd:
.ASSERT SpecialEffectsEnd - SpecialEffects == 17
