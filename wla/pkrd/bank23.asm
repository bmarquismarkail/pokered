.BANK 23
.ORG $0000

; Data from 5C000 to 5FFFF (16384 bytes)
.INCLUDE "wla/banks/bank23_maps_15.asm"
.INCLUDE "wla/banks/bank23_starter_dex.asm"
.INCLUDE "wla/banks/bank23_museum_1f_header.asm"
.INCLUDE "wla/banks/bank23_museum_1f_script.asm"
.INCLUDE "wla/banks/bank23_museum_1f_script_pointers.asm"
.INCLUDE "wla/banks/bank23_museum_1f_default_script.asm"
.INCLUDE "wla/banks/bank23_museum_1f_text_pointers.asm"
.db $08, $FA, $61, $D3, $FE, $04, $20, $0A, $FA, $62, $D3
.db $FE, $0D, $CA, $F9, $41, $18, $1C, $FE, $03, $20, $08, $FA, $62, $D3, $FE, $0C
.db $CA, $F9, $41, $FA, $54, $D7, $CB, $47, $20, $10, $21, $3D, $42, $CD, $49, $3C
.db $C3, $17, $42, $FA, $54, $D7, $CB, $47, $28, $09, $21, $42, $42, $CD, $49, $3C
.db $C3, $17, $42, $3E, $13, $EA, $25, $D1, $CD, $E8, $30, $AF, $E0, $B4, $21, $1F
.db $42, $CD, $49, $3C, $CD, $EC, $35, $FA, $26, $CC, $A7, $20, $4D, $AF, $E0, $9F
.db $E0, $A0, $3E, $50, $E0, $A1, $CD, $A6, $35, $30, $09, $21, $29, $42, $CD, $49
.db $3C, $C3, $DA, $41, $21, $24, $42, $CD, $49, $3C, $21, $54, $D7, $CB, $C6, $AF
.db $EA, $3D, $CD, $EA, $3E, $CD, $3E, $50, $EA, $3F, $CD, $21, $3F, $CD, $11, $49
.db $D3, $0E, $03, $3E, $0C, $CD, $6D, $3E, $3E, $13, $EA, $25, $D1, $CD, $E8, $30
.db $3E, $B2, $CD, $40, $37, $CD, $48, $37, $18, $18, $21, $1A, $42, $CD, $49, $3C
.db $3E, $01, $EA, $38, $CD, $3E, $80, $EA, $D3, $CC, $CD, $86, $34, $CD, $29, $24
.db $18, $25, $3E, $01, $EA, $19, $D6, $18, $1E, $21, $2E, $42, $CD, $49, $3C, $CD
.db $EC, $35, $FA, $26, $CC, $FE, $00, $20, $08, $21, $33, $42, $CD, $49, $3C, $18
.db $06, $21, $38, $42, $CD, $49, $3C, $C3, $D7, $24, $17, $2C, $65, $25, $50, $17
.db $39, $65, $25, $50, $17, $72, $65, $25, $50, $17, $8A, $65, $25, $50, $17, $A7
.db $65, $25, $50, $17, $F1, $65, $25, $50, $17, $36, $66, $25, $50, $17, $57, $66
.db $25, $50, $17, $75, $66, $25, $50
.INCLUDE "wla/banks/bank23_museum_1f_gambler_text.asm"
.db $08, $FA, $54, $D7, $CB, $4F, $20, $27, $21, $8E
.db $42, $CD, $49, $3C, $01, $01, $1F, $CD, $2E, $3E, $30, $14, $21, $54, $D7, $CB
.db $CE, $3E, $34, $EA, $4D, $CC, $3E, $11, $CD, $6D, $3E, $21, $93, $42, $18, $08
.db $21, $9E, $42, $18, $03, $21, $99, $42, $CD, $49, $3C, $C3, $D7, $24, $17, $B4
.db $66, $25, $50, $17, $90, $67, $25, $0B, $50, $17, $A8, $67, $25, $50, $17, $C9
.db $67, $25, $50
.INCLUDE "wla/banks/bank23_museum_1f_small_texts.asm"
.INCLUDE "wla/banks/bank23_museum_1f_object.asm"
.INCLUDE "wla/banks/bank23_museum_2f_header.asm"
.INCLUDE "wla/banks/bank23_museum_2f_dispatch.asm"
.INCLUDE "wla/banks/bank23_museum_2f_texts.asm"
.INCLUDE "wla/banks/bank23_museum_2f_object.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_header.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_dispatch.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_script_pointers.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_brock_post_battle.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_text_pointers.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_trainer_headers.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_brock_text.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_brock_text_records.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_cooltrainer_text.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_guide_text.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_object.asm"
.INCLUDE "wla/banks/bank23_pewter_gym_blocks.asm"
.INCLUDE "wla/banks/bank23_pewter_pokecenter_header.asm"
.INCLUDE "wla/banks/bank23_pewter_pokecenter_dispatch.asm"
.INCLUDE "wla/banks/bank23_pewter_pokecenter_small_texts.asm"
.INCLUDE "wla/banks/bank23_pewter_pokecenter_jigglypuff.asm"
.INCLUDE "wla/banks/bank23_pewter_pokecenter_receptionist.asm"
.INCLUDE "wla/banks/bank23_pewter_pokecenter_object.asm"
.INCLUDE "wla/banks/bank23_cerulean_pokecenter_header.asm"
.INCLUDE "wla/banks/bank23_cerulean_pokecenter_dispatch.asm"
.INCLUDE "wla/banks/bank23_cerulean_pokecenter_object.asm"
.INCLUDE "wla/banks/bank23_cerulean_pokecenter_blocks.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_header.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_dispatch.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_script_pointers.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_misty_post_battle.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_tables.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_misty_text.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_misty_records.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_trainer_texts.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_guide_text.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_object.asm"
.INCLUDE "wla/banks/bank23_cerulean_gym_blocks.asm"
.INCLUDE "wla/banks/bank23_cerulean_mart_header.asm"
.INCLUDE "wla/banks/bank23_cerulean_mart_dispatch.asm"
.INCLUDE "wla/banks/bank23_cerulean_mart_texts.asm"
.INCLUDE "wla/banks/bank23_cerulean_mart_object.asm"
.INCLUDE "wla/banks/bank23_lavender_pokecenter_header.asm"
.INCLUDE "wla/banks/bank23_lavender_pokecenter_dispatch.asm"
.INCLUDE "wla/banks/bank23_lavender_pokecenter_object.asm"
.INCLUDE "wla/banks/bank23_lavender_mart_header.asm"
.INCLUDE "wla/banks/bank23_lavender_mart_dispatch.asm"
.INCLUDE "wla/banks/bank23_lavender_mart_cooltrainer_text.asm"
.INCLUDE "wla/banks/bank23_lavender_mart_object.asm"
.INCLUDE "wla/banks/bank23_vermilion_pokecenter_header.asm"
.INCLUDE "wla/banks/bank23_vermilion_pokecenter_dispatch.asm"
.INCLUDE "wla/banks/bank23_vermilion_pokecenter_object.asm"
.INCLUDE "wla/banks/bank23_vermilion_mart_header.asm"
.INCLUDE "wla/banks/bank23_vermilion_mart_dispatch.asm"
.INCLUDE "wla/banks/bank23_vermilion_mart_texts.asm"
.INCLUDE "wla/banks/bank23_vermilion_mart_object.asm"
.INCLUDE "wla/banks/bank23_vermilion_gym_header.asm"
.INCLUDE "wla/banks/bank23_vermilion_gym_dispatch.asm"
.INCLUDE "wla/banks/bank23_vermilion_gym_battle_control.asm"
.INCLUDE "wla/banks/bank23_vermilion_gym_tables.asm"
.INCLUDE "wla/banks/bank23_vermilion_gym_surge_text.asm"
.INCLUDE "wla/banks/bank23_vermilion_gym_surge_records.asm"
.INCLUDE "wla/banks/bank23_vermilion_gym_trainer_texts.asm"
.INCLUDE "wla/banks/bank23_vermilion_gym_guide_text.asm"
.INCLUDE "wla/banks/bank23_vermilion_gym_object.asm"
.INCLUDE "wla/banks/bank23_vermilion_gym_blocks.asm"
.INCLUDE "wla/banks/bank23_copycats_house_2f_entry.asm"
.INCLUDE "wla/banks/bank23_copycats_house_2f_copycat_text.asm"
.INCLUDE "wla/banks/bank23_copycats_house_2f_room_texts.asm"
.INCLUDE "wla/banks/bank23_copycats_house_2f_object.asm"
.INCLUDE "wla/banks/bank23_fighting_dojo_entry.asm"
.INCLUDE "wla/banks/bank23_fighting_dojo_default.asm"
.INCLUDE "wla/banks/bank23_fighting_dojo_post_battle.asm"
.INCLUDE "wla/banks/bank23_fighting_dojo_tables.asm"
.INCLUDE "wla/banks/bank23_fighting_dojo_master_text.asm"
.INCLUDE "wla/banks/bank23_fighting_dojo_blackbelt_texts.asm"
.INCLUDE "wla/banks/bank23_fighting_dojo_prizes.asm"
.INCLUDE "wla/banks/bank23_fighting_dojo_object.asm"
.INCLUDE "wla/banks/bank23_fighting_dojo_blocks.asm"
.INCLUDE "wla/banks/bank23_saffron_gym_entry.asm"
.INCLUDE "wla/banks/bank23_saffron_gym_battle_control.asm"
.INCLUDE "wla/banks/bank23_saffron_gym_tables.asm"
.db $08, $FA, $B3, $D7, $CB, $4F, $28, $14, $CB, $47, $20, $08, $CC, $68
.db $50, $CD, $B6, $30, $18, $33, $21, $6E, $51, $CD, $49, $3C, $18, $2B, $21, $62
.db $51, $CD, $49, $3C, $21, $2D, $D7, $CB, $F6, $CB, $FE, $21, $67, $51, $11, $67
.db $51, $CD, $54, $33, $F0, $8C, $EA, $13, $CF, $CD, $6A, $33, $CD, $D7, $32, $3E
.db $06, $EA, $5C, $D0, $3E, $03, $EA, $5C, $D6, $C3, $D7, $24, $17, $B4, $5B, $28
.db $50, $17, $73, $5C, $28, $11, $06, $50, $17, $DC, $5C, $28, $50, $17, $16, $5D
.db $28, $50, $17, $CD, $5D, $28, $0B, $17, $E0, $5D, $28, $50, $17, $25, $5E, $28
.db $50, $08, $21, $C3, $50, $CD, $CC, $31, $C3, $D7, $24, $08, $21, $CF, $50, $CD
.db $CC, $31, $C3, $D7, $24, $08, $21, $DB, $50, $CD, $CC, $31, $C3, $D7, $24, $08
.db $21, $E7, $50, $CD, $CC, $31, $C3, $D7, $24, $08, $21, $F3, $50, $CD, $CC, $31
.db $C3, $D7, $24, $08, $21, $FF, $50, $CD, $CC, $31, $C3, $D7, $24, $08, $21, $0B
.db $51, $CD, $CC, $31, $C3, $D7, $24, $08, $FA, $B3, $D7, $CB, $4F, $20, $08, $21
.db $E6, $51, $CD, $49, $3C, $18, $06, $21, $EB, $51, $CD, $49, $3C, $C3, $D7, $24
.db $17, $48, $5E, $28, $50, $17, $F0, $5E, $28, $50, $17, $33, $5F, $28, $50, $17
.db $62, $5F, $28, $50, $17, $74, $5F, $28, $50, $17, $E0, $5F, $28, $50, $17, $02
.db $60, $28, $50, $17, $19, $60, $28, $50, $17, $42, $60, $28, $50, $17, $91, $60
.db $28, $50, $17, $9D, $60, $28, $50, $17, $C9, $60, $28, $50, $17, $F1, $60, $28
.db $50, $17, $07, $61, $28, $50, $17, $3C, $61, $28, $50, $17, $5E, $61, $28, $50
.db $17, $71, $61, $28, $50, $17, $9C, $61, $28, $50, $17, $E4, $61, $28, $50, $17
.db $FE, $61, $28, $50, $17, $77, $62, $28, $50, $17, $CA, $62, $28, $50, $17, $D3
.db $62, $28, $50, $2E, $20, $11, $08, $02, $FF, $11, $09, $02, $FF, $03, $01, $16
.db $B2, $03, $05, $0F, $B2, $05, $01, $12, $B2, $05, $05, $08, $B2, $09, $01, $1B
.db $B2, $09, $05, $10, $B2, $0B, $01, $05, $B2, $0B, $05, $0D, $B2, $0F, $01, $17
.db $B2, $0F, $05, $1E, $B2, $11, $01, $11, $B2, $11, $05, $09, $B2, $03, $09, $1A
.db $B2, $03, $0B, $03, $B2, $05, $09, $07, $B2, $05, $0B, $0C, $B2, $0B, $0B, $04
.db $B2, $0F, $0B, $1F, $B2, $03, $0F, $18, $B2, $03, $13, $1C, $B2, $05, $0F, $02
.db $B2, $05, $13, $0A, $B2, $09, $0F, $14, $B2, $09, $13, $1D, $B2, $0B, $0F, $0E
.db $B2, $0B, $13, $06, $B2, $0F, $0F, $15, $B2, $0F, $13, $19, $B2, $11, $0F, $0B
.db $B2, $11, $13, $13, $B2, $00, $09, $0D, $0C, $0D, $FF, $D0, $41, $F0, $01, $19
.db $05, $0E, $FF, $D0, $42, $F5, $16, $04, $05, $15, $FF, $D0, $43, $DB, $01, $19
.db $0B, $07, $FF, $D0, $44, $F5, $17, $04, $0B, $15, $FF, $D0, $45, $DB, $02, $19
.db $11, $07, $FF, $D0, $46, $F5, $18, $04, $11, $15, $FF, $D0, $47, $DB, $03, $04
.db $05, $07, $FF, $D0, $48, $DB, $04, $24, $13, $0E, $FF, $D0, $09, $7D, $C7, $11
.db $08, $7D, $C7, $11, $09, $09, $C7, $03, $01, $0B, $C7, $03, $05, $19, $C7, $05
.db $01, $1B, $C7, $05, $05, $39, $C7, $09, $01, $3B, $C7, $09, $05, $49, $C7, $0B
.db $01, $4B, $C7, $0B, $05, $69, $C7, $0F, $01, $6B, $C7, $0F, $05, $79, $C7, $11
.db $01, $7B, $C7, $11, $05, $0D, $C7, $03, $09, $0E, $C7, $03, $0B, $1D, $C7, $05
.db $09, $1E, $C7, $05, $0B, $4E, $C7, $0B, $0B, $6E, $C7, $0F, $0B, $10, $C7, $03
.db $0F, $12, $C7, $03, $13, $20, $C7, $05, $0F, $22, $C7, $05, $13, $40, $C7, $09
.db $0F, $42, $C7, $09, $13, $50, $C7, $0B, $0F, $52, $C7, $0B, $13, $70, $C7, $0F
.db $0F, $72, $C7, $0F, $13, $80, $C7, $11, $0F, $82, $C7, $11, $13, $41, $41, $41
.db $40, $41, $41, $42, $41, $41, $41, $2F, $0E, $2F, $44, $2F, $2F, $46, $2F, $0E
.db $2F, $2F, $0E, $2F, $44, $2F, $2F, $46, $2F, $0E, $2F, $41, $41, $41, $40, $41
.db $41, $42, $41, $41, $41, $2F, $0E, $2F, $44, $0E, $0E, $46, $2F, $0E, $2F, $2F
.db $0E, $2F, $44, $0E, $2F, $46, $2F, $0E, $2F, $41, $41, $41, $40, $41, $41, $42
.db $41, $41, $41, $2F, $0E, $2F, $44, $45, $2F, $46, $2F, $0E, $2F, $2F, $0E, $2F
.db $44, $2C, $0E, $46, $2F, $0E, $2F, $02, $04, $04, $00, $40, $0C, $54, $09, $54
.db $00, $1C, $54, $C3, $3C, $3C, $C3, $24, $12, $54, $17, $54, $17, $E3, $63, $28
.db $50, $17, $2A, $64, $28, $50, $00, $02, $07, $03, $04, $FF, $07, $04, $04, $FF
.db $00, $03, $26, $09, $04, $FF, $D3, $01, $0C, $06, $08, $FF, $FF, $02, $06, $09
.db $0A, $FE, $00, $03, $12, $C7, $07, $03, $13, $C7, $07, $04, $16, $09, $0F, $A2
.db $54, $69, $54, $4E, $54, $00, $70, $54, $CD, $3C, $3C, $FA, $38, $D8, $CB, $7F
.db $C8, $21, $B9, $D7, $CB, $7E, $CB, $FE, $C0, $3E, $4C, $EA, $4D, $CC, $3E, $15
.db $C3, $6D, $3E, $6B, $54, $17, $5A, $64, $28, $50, $2E, $05, $11, $0A, $05, $FF
.db $11, $0B, $05, $FF, $00, $1A, $00, $CF, $00, $14, $00, $EC, $0A, $10, $06, $D0
.db $00, $01, $2A, $06, $08, $FF, $D0, $01, $AB, $C7, $11, $0A, $AB, $C7, $11, $0B
.db $0B, $C7, $00, $1A, $08, $C7, $00, $14, $6F, $C7, $0A, $10, $3C, $3D, $3D, $7F
.db $3D, $3D, $3D, $3D, $3D, $3D, $7C, $3D, $3D, $7D, $3E, $7E, $22, $22, $23, $0E
.db $0E, $1D, $0E, $0E, $1D, $0E, $0E, $0E, $09, $46, $44, $0E, $0E, $0E, $0E, $1E
.db $5B, $1C, $1E, $5B, $1C, $0E, $0E, $0E, $46, $44, $0D, $0E, $0E, $20, $5B, $5B
.db $5B, $5B, $5B, $5B, $39, $0E, $09, $46, $44, $0E, $0E, $0E, $0E, $1A, $5B, $18
.db $1A, $5B, $18, $0E, $0E, $0E, $46, $44, $0D, $0E, $0E, $0E, $0E, $19, $0E, $0E
.db $19, $0E, $0E, $0E, $09, $46, $44
.dsb 13, $0E
.db $46, $44, $0B, $0B, $0B, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0B, $0B, $0B, $46
.db $48, $49, $49, $49, $58, $2C, $57, $49, $49, $49, $49, $49, $49, $49, $4A, $06
.db $04, $07, $64, $40, $3B, $55, $35, $55, $00, $4F, $55, $CD, $FA, $22, $C3, $3C
.db $3C, $43, $55, $44, $55, $49, $55, $4E, $55, $FF, $17, $8E, $64, $28, $50, $17
.db $BF, $64, $28, $50, $F6, $00, $02, $07, $03, $06, $FF, $07, $04, $06, $FF, $00
.db $04, $29, $05, $07, $FF, $D0, $01, $0F, $09, $09, $FF, $FF, $02, $10, $07, $0C
.db $FF, $D0, $03, $2A, $06, $0F, $FF, $D0, $04, $1E, $C7, $07, $03, $1F, $C7, $07
.db $04, $09, $04, $05, $90, $40, $8A, $55, $87, $55, $00, $98, $55, $C3, $3C, $3C
.db $8E, $55, $93, $55, $17, $FD, $66, $22, $50, $17, $5D, $67, $22, $50, $0A, $04
.db $00, $04, $01, $FF, $00, $05, $01, $FF, $07, $04, $00, $33, $07, $05, $00, $33
.db $00, $02, $0C, $06, $07, $FF, $FF, $01, $25, $09, $06, $FF, $FF, $02, $F6, $C6
.db $00, $04, $F6, $C6, $00, $05, $17, $C7, $07, $04, $17, $C7, $07, $05, $0C, $04
.db $05, $90, $40, $D7, $55, $D4, $55, $00, $20, $56, $C3, $3C, $3C, $DB, $55, $1B
.db $56, $08, $FA, $C2, $D7, $CB, $47, $20, $2A, $3E, $0A, $E0, $DB, $3E, $C8, $E0
.db $DC, $EA, $1E, $D1, $CD, $CF, $2F, $21, $6D, $CD, $11, $5B, $CC, $01, $0D, $00
.db $CD, $B5, $00, $3E, $62, $CD, $6D, $3E, $F0, $DB, $FE, $01, $20, $0B, $21, $C2
.db $D7, $CB, $C6, $21, $16, $56, $CD, $49, $3C, $C3, $D7, $24, $17, $FC, $67, $22
.db $50, $17, $2C, $68, $22, $50, $0A, $04, $00, $04, $03, $FF, $00, $05, $03, $FF
.db $07, $04, $04, $FF, $07, $05, $04, $FF, $00, $02, $20, $08, $05, $FF, $D2, $01
.db $04, $08, $09, $FE, $02, $02, $F6, $C6, $00, $04, $F6, $C6, $00, $05, $17, $C7
.db $07, $04, $17, $C7, $07, $05, $09, $04, $05, $90, $40, $5F, $56, $5C, $56, $00
.db $6D, $56, $C3, $3C, $3C, $63, $56, $68, $56, $17, $68, $68, $22, $50, $17, $AB
.db $68, $22, $50, $0A, $04, $00, $04, $03, $33, $00, $05, $04, $33, $07, $04, $05
.db $FF, $07, $05, $05, $FF, $00, $02, $0D, $08, $0C, $FF, $D2, $01, $08, $08, $06
.db $FE, $01, $02, $F6, $C6, $00, $04, $F6, $C6, $00, $05, $17, $C7, $07, $04, $17
.db $C7, $07, $05, $0C, $04, $04, $80, $40, $B0, $56, $A9, $56, $00, $C1, $56, $3E
.db $10, $EA, $65, $D3, $C9, $50, $B2, $56, $08, $3E, $09, $EA, $3D, $CD, $3E, $54
.db $CD, $6D, $3E, $21, $AF, $56, $C9, $0A, $03, $07, $03, $03, $FF, $07, $04, $03
.db $FF, $04, $04, $00, $77, $00, $01, $08, $07, $06, $FF, $FF, $01, $12, $C7, $07
.db $03, $13, $C7, $07, $04, $09, $C7, $04, $04, $0C, $04, $04, $80, $40, $F7, $56
.db $EF, $56, $00, $FE, $56, $3E, $11, $EA, $65, $D3, $C3, $3C, $3C, $F9, $56, $17
.db $CB, $40, $23, $50, $0A, $03, $07, $03, $03, $FF, $07, $04, $03, $FF, $04, $04
.db $01, $77, $00, $01, $0D, $07, $06, $FF, $FF, $01, $12, $C7, $07, $03, $13, $C7
.db $07, $04, $09, $C7, $04, $04, $0C, $04, $04, $80, $40, $34, $57, $2C, $57, $00
.db $3B, $57, $3E, $12, $EA, $65, $D3, $C3, $3C, $3C, $36, $57, $17, $FF, $40, $23
.db $50, $0A, $03, $07, $03, $04, $FF, $07, $04, $04, $FF, $04, $04, $00, $79, $00
.db $01, $0A, $08, $06, $FF, $FF, $01, $12, $C7, $07, $03, $13, $C7, $07, $04, $09
.db $C7, $04, $04, $0C, $04, $04, $80, $40, $6F, $57, $69, $57, $00, $87, $57, $3E
.db $12, $EA, $65, $D3, $C9, $73, $57, $7D, $57, $17, $32, $41, $23, $50, $17, $95
.db $41, $23, $50, $17, $C8, $41, $23, $50, $17, $09, $42, $23, $50, $0A, $03, $07
.db $03, $05, $FF, $07, $04, $05, $FF, $04, $04, $00, $79, $00, $02, $0D, $06, $07
.db $FF, $FF, $01, $0A, $08, $06, $FF, $FF, $02, $12, $C7, $07, $03, $13, $C7, $07
.db $04, $09, $C7, $04, $04, $16, $09, $0D, $89, $59, $8B, $58, $BB, $57, $00, $3F
.db $59, $CD, $D1, $57, $CD, $3C, $3C, $21, $93, $58, $11, $85, $58, $FA, $4A, $D6
.db $CD, $60, $31, $EA, $4A, $D6, $C9, $21, $26, $D1, $CB, $6E, $CB, $AE, $C8, $21
.db $2E, $58, $CD, $37, $58, $CD, $63, $58, $FA, $34, $D8, $CB, $47, $20, $0F, $F5
.db $3E, $5F, $EA, $9F, $D0, $01, $01, $04, $3E, $17, $CD, $6D, $3E, $F1, $CB, $4F
.db $20, $0F, $F5, $3E, $54, $EA, $9F, $D0, $01, $09, $02, $3E, $17, $CD, $6D, $3E
.db $F1, $CB, $57, $20, $0F, $F5, $3E, $54, $EA, $9F, $D0, $01, $09, $05, $3E, $17
.db $CD, $6D, $3E, $F1, $CB, $5F, $C0, $3E, $5F, $EA, $9F, $D0, $01, $05, $06, $3E
.db $17, $C3, $6D, $3E, $04, $01, $02, $09, $05, $09, $06, $05, $FF, $E5, $21, $3F
.db $D7, $2A, $47, $7E, $4F, $AF, $E0, $E0, $E1, $2A, $FE, $FF, $28, $17, $E5, $21
.db $E0, $FF, $34, $E1, $B8, $28, $03, $23, $18, $EF, $2A, $B9, $20, $EB, $21, $3F
.db $D7, $AF, $22, $77, $C9, $AF, $E0, $E0, $C9, $21, $34, $D8, $F0, $E0, $A7, $C8
.db $FE, $01, $20, $03, $CB, $C6, $C9, $FE, $02, $20, $03, $CB, $CE, $C9, $FE, $03
.db $20, $03, $CB, $D6, $C9, $FE, $04, $C0, $CB, $DE, $C9, $19, $32, $4C, $32, $75
.db $32, $B8, $58, $F4, $58, $FE, $58, $08, $59, $02, $40, $33, $D8, $12, $59, $1C
.db $59, $17, $59, $17, $59, $03, $20, $33, $D8, $21, $59, $2B, $59, $26, $59, $26
.db $59, $04, $40, $33, $D8, $30, $59, $3A, $59, $35, $59, $35, $59, $FF, $08, $FA
.db $38, $D8, $CB, $7F, $20, $1C, $21, $E5, $58, $CD, $49, $3C, $3E, $07, $CD, $6D
.db $3E, $CD, $D8, $20, $CD, $D7, $3D, $CD, $F6, $20, $21, $EA, $58, $CD, $49, $3C
.db $18, $06, $21, $EF, $58, $CD, $49, $3C, $C3, $D7, $24, $17, $0B, $4C, $21, $50
.db $17, $39, $4C, $21, $50, $17, $48, $4C, $21, $50, $08, $21, $93, $58, $CD, $CC
.db $31, $C3, $D7, $24, $08, $21, $9F, $58, $CD, $CC, $31, $C3, $D7, $24, $08, $21
.db $AB, $58, $CD, $CC, $31, $C3, $D7, $24, $17, $5C, $4C, $21, $50, $17, $7F, $4C
.db $21, $50, $17, $88, $4C, $21, $50, $17, $B6, $4C, $21, $50, $17, $E4, $4C, $21
.db $50, $17, $F6, $4C, $21, $50, $17, $33, $4D, $21, $50, $17, $57, $4D, $21, $50
.db $17, $70, $4D, $21, $50, $2E, $05, $00, $0E, $00, $EA, $00, $10, $00, $D5, $00
.db $12, $00, $EC, $03, $09, $07, $D0, $0F, $11, $04, $D2, $00, $04, $29, $12, $07
.db $FF, $D0, $01, $18, $08, $06, $FF, $D1, $42, $E6, $25, $20, $11, $19, $FF, $D0
.db $43, $E4, $0A, $18, $14, $11, $FF, $D1, $44, $E6, $26, $03, $C7, $00, $0E, $04
.db $C7, $00, $10, $05, $C7, $00, $12, $13, $C7, $03, $09, $89, $C7, $0F, $11, $40
.db $41, $41, $41, $41, $42, $41, $7D, $24, $7C, $3D, $3D, $3E, $44, $0E, $0E, $0E
.db $2F, $46, $0E, $0E, $0E, $0E, $0E, $0E, $46, $44, $5A, $67, $41, $41, $42, $0E
.db $40, $63, $0E, $67, $59, $46, $44, $56, $0E, $47, $47, $46, $0E, $44, $0E, $34
.db $0E, $12, $46, $44, $0E, $0E, $67, $40, $42, $0D, $44, $0E, $37, $0E, $12, $46
.db $44, $5A, $0E, $0E, $55, $56, $0D, $40, $63, $0E, $67, $42, $46, $50, $4A, $43
.db $43, $0E, $0E, $0E, $44, $47, $7B, $0E, $56, $46, $44, $43, $43, $43, $59, $5A
.db $0E, $44, $2F, $47, $0E, $0E, $46, $48, $49, $49, $49, $48, $4A, $49, $48, $49
.db $49, $49, $49, $4A, $11, $09, $0A, $04, $5B, $5F, $5A, $0A, $5A, $00, $B8, $5A
.db $21, $26, $D1, $CB, $6E, $CB, $AE, $C4, $27, $5A, $CD, $3C, $3C, $21, $6D, $5A
.db $11, $3A, $5A, $FA, $51, $D6, $CD, $60, $31, $EA, $51, $D6, $C9, $FA, $69, $D8
.db $CB, $7F, $C8, $3E, $1D, $EA, $9F, $D0, $01, $04, $06, $3E, $17, $C3, $6D, $3E
.db $40, $5A, $4C, $32, $75, $32, $FA, $69, $D8, $CB, $7F, $C2, $19, $32, $21, $5C
.db $5A, $CD, $E4, $34, $D2, $19, $32, $21, $26, $D1, $CB, $EE, $21, $69, $D8, $CB
.db $FE, $C9, $0D, $11, $FF, $86, $5A, $90, $5A, $F4, $24, $F4, $24, $E5, $24, $E5
.db $24, $E5, $24, $01, $20, $69, $D8, $9A, $5A, $A4, $5A, $9F, $5A, $9F, $5A, $02
.db $20, $69, $D8, $A9, $5A, $B3, $5A, $AE, $5A, $AE, $5A, $FF, $08, $21, $6D, $5A
.db $CD, $CC, $31, $C3, $D7, $24, $08, $21, $79, $5A, $CD, $CC, $31, $C3, $D7, $24
.db $17, $79, $5C, $21, $50, $17, $A2, $5C, $21, $50, $17, $AF, $5C, $21, $50, $17
.db $D3, $5C, $21, $50, $17, $07, $5D, $21, $50, $17, $1A, $5D, $21, $50, $7D, $03
.db $11, $08, $02, $FF, $11, $09, $02, $FF, $01, $01, $00, $C2, $00, $07, $06, $09
.db $0B, $FF, $D3, $41, $E8, $05, $07, $06, $07, $FF, $D0, $42, $E7, $05, $3D, $04
.db $0F, $FF, $FF, $83, $F3, $3D, $06, $0D, $FF, $FF, $84, $28, $3F, $13, $09, $FF
.db $10, $05, $3F, $06, $12, $FF, $10, $06, $3F, $0E, $06, $FF, $10, $07, $7D, $C7
.db $11, $08, $7D, $C7, $11, $09, $F9, $C6, $01, $01, $62, $05, $7D, $7D, $4E, $6D
.db $74, $0C, $09, $7D, $4D, $01, $7A, $7D, $0A, $0C, $0D, $01, $01, $7A, $06, $01
.db $14, $15, $15, $15, $15, $15, $16, $01, $7D, $01, $1C, $2D, $1D, $2B, $2C, $2D
.db $1E, $01, $7D, $0E, $6A, $5B, $6F, $18, $1A, $4C, $01, $0D, $4D, $0F, $18, $19
.db $70, $18, $1A, $4F, $05, $72, $0E, $0D, $66, $1D, $25, $1D, $1E, $0D, $6C, $74
.db $0C, $05, $01, $08, $01, $5E, $01, $01, $07, $7D, $53, $04, $04, $01, $24, $7D
.db $04, $51, $7D, $7D
.INCLUDE "wla/banks/bank23_hidden_events_3.asm"
.dsb 8427, $00
