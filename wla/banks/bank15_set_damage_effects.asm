; Effects that deal damage outside the normal damage calculation.
SetDamageEffects:
.DB $28, $29, $FF
SetDamageEffectsEnd:
.ASSERT SetDamageEffectsEnd - SetDamageEffects == 3
