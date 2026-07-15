; Stats that vitamins can raise or lower.
; Five fixed-width, 7-byte Pokémon-encoded names.
VitaminStats:
.DB $87, $84, $80, $8B, $93, $87, $50
.DB $80, $93, $93, $80, $82, $8A, $50
.DB $83, $84, $85, $84, $8D, $92, $84
.DB $50, $92, $8F, $84, $84, $83, $50
.DB $92, $8F, $84, $82, $88, $80, $8B
VitaminStatsEnd:
.ASSERT VitaminStatsEnd - VitaminStats == 35
