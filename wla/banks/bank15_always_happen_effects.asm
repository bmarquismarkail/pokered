; Side effects that still resolve after the target faints.
AlwaysHappenSideEffects:
.DB $03, $07, $08, $10, $1D, $1E, $2C, $30, $4D, $51, $FF
AlwaysHappenSideEffectsEnd:
.ASSERT AlwaysHappenSideEffectsEnd - AlwaysHappenSideEffects == 11
