ResidualEffects1:
.DB $18, $19, $1C, $2E, $2F, $31, $38, $39, $40, $41, $42, $43, $4F, $52, $54, $55
.DB $FF, $28, $29, $FF ; table terminator plus preserved RGBDS padding
ResidualEffects1End:
.ASSERT ResidualEffects1End - ResidualEffects1 == 20

ResidualEffects2:
.DB $01, $0A, $0B, $0C, $0D, $0E, $0F, $12, $13, $14, $15, $16, $17, $1A, $20, $32
.DB $33, $34, $35, $36, $37, $3A, $3B, $3C, $3D, $3E, $3F, $FF
ResidualEffects2End:
.ASSERT ResidualEffects2End - ResidualEffects2 == 28
