.BANK 29
.ORG $0000

; Data from 74000 to 77FFF (16384 bytes)
.INCLUDE "wla/banks/bank29_maps_19.asm"
.INCLUDE "wla/banks/bank29_itemfinder_1.asm"
.INCLUDE "wla/banks/bank29_cerulean_hide_rocket.asm"
.INCLUDE "wla/banks/bank29_viridian_gym_entry.asm"
.INCLUDE "wla/banks/bank29_viridian_gym_spinner_tables.asm"
.INCLUDE "wla/banks/bank29_viridian_gym_spinner_runtime.asm"
.INCLUDE "wla/banks/bank29_viridian_gym_post_battle.asm"
.INCLUDE "wla/banks/bank29_viridian_gym_tables.asm"
.INCLUDE "wla/banks/bank29_viridian_gym_giovanni_text.asm"
.INCLUDE "wla/banks/bank29_viridian_gym_trainer_texts.asm"
.INCLUDE "wla/banks/bank29_viridian_gym_guide_text.asm"
.INCLUDE "wla/banks/bank29_viridian_gym_object.asm"
.INCLUDE "wla/banks/bank29_viridian_gym_blocks.asm"
.INCLUDE "wla/banks/bank29_pewter_mart_header.asm"
.INCLUDE "wla/banks/bank29_pewter_mart_dispatch.asm"
.INCLUDE "wla/banks/bank29_pewter_mart_texts.asm"
.INCLUDE "wla/banks/bank29_pewter_mart_object.asm"
.INCLUDE "wla/banks/bank29_cerulean_cave_1f_header.asm"
.INCLUDE "wla/banks/bank29_cerulean_cave_1f_dispatch.asm"
.INCLUDE "wla/banks/bank29_cerulean_cave_1f_object.asm"
.INCLUDE "wla/banks/bank29_cerulean_cave_1f_blocks.asm"
.INCLUDE "wla/banks/bank29_cerulean_badge_house_header.asm"
.INCLUDE "wla/banks/bank29_cerulean_badge_house_dispatch.asm"
.INCLUDE "wla/banks/bank29_cerulean_badge_house_text.asm"
.INCLUDE "wla/banks/bank29_cerulean_badge_house_object.asm"
.INCLUDE "wla/banks/bank29_vending_machine.asm"
.INCLUDE "wla/banks/bank29_fuchsia_bills_grandpas_house_header.asm"
.INCLUDE "wla/banks/bank29_fuchsia_bills_grandpas_house_dispatch.asm"
.INCLUDE "wla/banks/bank29_fuchsia_bills_grandpas_house_texts.asm"
.INCLUDE "wla/banks/bank29_fuchsia_bills_grandpas_house_object.asm"
.INCLUDE "wla/banks/bank29_fuchsia_pokecenter_header.asm"
.INCLUDE "wla/banks/bank29_fuchsia_pokecenter_dispatch.asm"
.INCLUDE "wla/banks/bank29_fuchsia_pokecenter_texts.asm"
.INCLUDE "wla/banks/bank29_fuchsia_pokecenter_object.asm"
.INCLUDE "wla/banks/bank29_wardens_house_header.asm"
.INCLUDE "wla/banks/bank29_wardens_house_dispatch.asm"
.INCLUDE "wla/banks/bank29_wardens_house_text.asm"
.INCLUDE "wla/banks/bank29_wardens_house_object.asm"
.INCLUDE "wla/banks/bank29_wardens_house_blocks.asm"
.INCLUDE "wla/banks/bank29_safari_zone_gate_header.asm"
.INCLUDE "wla/banks/bank29_safari_zone_gate_entry.asm"
.INCLUDE "wla/banks/bank29_safari_zone_gate_default.asm"
.INCLUDE "wla/banks/bank29_safari_zone_gate_state_machine.asm"
.INCLUDE "wla/banks/bank29_safari_zone_gate_text_pointers.asm"
.INCLUDE "wla/banks/bank29_safari_zone_gate_admission_text.asm"
.INCLUDE "wla/banks/bank29_safari_zone_gate_leaving_text.asm"
.INCLUDE "wla/banks/bank29_safari_zone_gate_worker_texts.asm"
.INCLUDE "wla/banks/bank29_safari_zone_gate_object.asm"
.INCLUDE "wla/banks/bank29_safari_zone_gate_blocks.asm"
.INCLUDE "wla/banks/bank29_fuchsia_gym_header.asm"
.INCLUDE "wla/banks/bank29_fuchsia_gym_entry.asm"
.INCLUDE "wla/banks/bank29_fuchsia_gym_reset_tables.asm"
.INCLUDE "wla/banks/bank29_fuchsia_gym_post_battle.asm"
.INCLUDE "wla/banks/bank29_fuchsia_gym_tables.asm"
.INCLUDE "wla/banks/bank29_fuchsia_gym_koga_text.asm"
.INCLUDE "wla/banks/bank29_fuchsia_gym_trainer_texts.asm"
.INCLUDE "wla/banks/bank29_fuchsia_gym_guide_text.asm"
.INCLUDE "wla/banks/bank29_fuchsia_gym_object.asm"
.INCLUDE "wla/banks/bank29_fuchsia_gym_blocks.asm"
.INCLUDE "wla/banks/bank29_fuchsia_meeting_room_header.asm"
.INCLUDE "wla/banks/bank29_fuchsia_meeting_room_dispatch.asm"
.INCLUDE "wla/banks/bank29_fuchsia_meeting_room_texts.asm"
.INCLUDE "wla/banks/bank29_fuchsia_meeting_room_object.asm"
.INCLUDE "wla/banks/bank29_fuchsia_meeting_room_blocks.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_header.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_entry.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_reset_tables.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_default.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_open_gate.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_post_battle.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_battle_tables.asm"
.db $08, $FA, $9A, $D7, $CB, $4F, $28
.db $16, $CB, $47, $20, $09, $CC, $57, $58, $CD, $B6, $30, $C3, $D7, $24, $21, $20
.db $59, $CD, $49, $3C, $C3, $D7, $24, $21, $14, $59, $CD, $49, $3C, $21, $19, $59
.db $11, $19, $59, $CD, $54, $33, $3E, $07, $EA, $5C, $D0, $C3, $B7, $58, $17, $44
.db $48, $28, $50, $17, $C7, $48, $28, $11, $0D, $50, $17, $FD, $48, $28, $50, $17
.db $46, $49, $28, $50, $17, $A8, $49, $28, $0B, $17, $BC, $49, $28, $50, $17, $1E
.db $4A, $28, $50, $08, $CD, $A0, $57, $FA, $9A, $D7, $CB, $57, $20, $12, $21, $5F
.db $59, $CD, $49, $3C, $21, $64, $59, $11, $64, $59, $CD, $54, $33, $C3, $B7, $58
.db $21, $69, $59, $CD, $49, $3C, $C3, $D7, $24, $17, $36, $4A, $28, $50, $17, $65
.db $4A, $28, $50, $17, $7A, $4A, $28, $50, $08, $CD, $A0, $57, $FA, $9A, $D7, $CB
.db $5F, $20, $12, $21, $94, $59, $CD, $49, $3C, $21, $99, $59, $11, $99, $59, $CD
.db $54, $33, $C3, $B7, $58, $21, $9E, $59, $CD, $49, $3C, $C3, $D7, $24, $17, $C0
.db $4A, $28, $50, $17, $F4, $4A, $28, $50, $17, $02, $4B, $28, $50, $08, $CD, $A0
.db $57, $FA, $9A, $D7, $CB, $67, $20, $12, $21, $C9, $59, $CD, $49, $3C, $21, $CE
.db $59, $11, $CE, $59, $CD, $54, $33, $C3, $B7, $58, $21, $D3, $59, $CD, $49, $3C
.db $C3, $D7, $24, $17, $2C, $4B, $28, $50, $17, $58, $4B, $28, $50, $17, $6B, $4B
.db $28, $50, $08, $CD, $A0, $57, $FA, $9A, $D7, $CB, $6F, $20, $12, $21, $FE, $59
.db $CD, $49, $3C, $21, $03, $5A, $11, $03, $5A, $CD, $54, $33, $C3, $B7, $58, $21
.db $08, $5A, $CD, $49, $3C, $C3, $D7, $24, $17, $95, $4B, $28, $50, $17, $B3, $4B
.db $28, $50, $17, $C7, $4B, $28, $50, $08, $CD, $A0, $57, $FA, $9A, $D7, $CB, $77
.db $20, $12, $21, $33, $5A, $CD, $49, $3C, $21, $38, $5A, $11, $38, $5A, $CD, $54
.db $33, $C3, $B7, $58, $21, $3D, $5A, $CD, $49, $3C, $C3, $D7, $24, $17, $F4, $4B
.db $28, $50, $17, $19, $4C, $28, $50, $17, $1E, $4C, $28, $50, $08, $CD, $A0, $57
.db $FA, $9A, $D7, $CB, $7F, $20, $12, $21, $68, $5A, $CD, $49, $3C, $21, $6D, $5A
.db $11, $6D, $5A, $CD, $54, $33, $C3, $B7, $58, $21, $72, $5A, $CD, $49, $3C, $C3
.db $D7, $24, $17, $90, $4C, $28, $50, $17, $C1, $4C, $28, $50, $17, $D2, $4C, $28
.db $50, $08, $CD, $A0, $57, $FA, $9B, $D7, $CB, $47, $20, $12, $21, $9D, $5A, $CD
.db $49, $3C, $21, $A2, $5A, $11, $A2, $5A, $CD, $54, $33, $C3, $B7, $58, $21, $A7
.db $5A, $CD, $49, $3C, $C3, $D7, $24, $17, $00, $4D, $28, $50, $17, $1B, $4D, $28
.db $50, $17, $2D, $4D, $28, $50, $08, $FA, $9A, $D7, $CB, $4F, $20, $05, $21, $C2
.db $5A, $18, $03, $21, $C7, $5A, $CD, $49, $3C, $C3, $D7, $24, $17, $5A, $4D, $28
.db $50, $17, $D9, $4D, $28, $50, $2E, $02, $11, $10, $01, $FF, $11, $11, $01, $FF
.db $00, $09, $0A, $07, $07, $FF, $D0, $41, $EF, $01, $0C, $06, $15, $FF, $D0, $42
.db $D0, $09, $0C, $0C, $15, $FF, $D0, $43, $D3, $04, $0C, $08, $0F, $FF, $D0, $44
.db $D0, $0A, $0C, $0C, $0F, $FF, $D0, $45, $D3, $05, $0C, $12, $0F, $FF, $D0, $46
.db $D0, $0B, $0C, $12, $07, $FF, $D0, $47, $D3, $06, $0C, $0C, $07, $FF, $D0, $48
.db $D0, $0C, $24, $11, $14, $FF, $D0, $09, $81, $C7, $11, $10, $81, $C7, $11, $11
.db $40, $61, $61, $40, $40, $61, $41, $41, $41, $41, $44, $0E, $0E, $44, $44, $0E
.db $0E, $59, $0E, $0E, $44, $0E, $0E, $44, $44, $0E, $0E, $44, $0E, $0E, $6B, $63
.db $0E, $44, $6B, $63, $0E, $6B, $63, $0E, $44, $0E, $0E, $44, $44, $0E, $0E, $44
.db $0E, $0E, $44, $0E, $0E, $44, $44, $0E, $0E, $50, $58, $0E, $6B, $63, $0E, $44
.db $6B, $63, $0E, $44, $45, $0E, $44, $0E, $0E, $48, $55, $0E, $0E, $44, $0E, $0E
.db $44, $0E, $0E, $0E, $0E, $0E, $0E, $44, $2C, $0E, $14, $04, $09, $F1, $5B, $90
.db $5B, $8C, $5B, $00, $B3, $5B, $CD, $3C, $3C, $C9, $9A, $5B, $9F, $5B, $A4, $5B
.db $A9, $5B, $AE, $5B, $17, $F7, $4D, $28, $50, $17, $49, $4E, $28, $50, $17, $70
.db $4E, $28, $50, $17, $87, $4E, $28, $50, $17, $9E, $4E, $28, $50, $17, $05, $07
.db $02, $02, $FF, $07, $03, $02, $FF, $04, $08, $00, $A8, $04, $0C, $00, $A9, $04
.db $10, $00, $AA, $04, $02, $03, $02, $04, $09, $03, $04, $0D, $04, $04, $11, $05
.db $01, $27, $07, $05, $FF, $FF, $01, $26, $C7, $07, $02, $26, $C7, $07, $03, $1A
.db $C7, $04, $08, $1C, $C7, $04, $0C, $1E, $C7, $04, $10
.dsb 9, $17
.db $09, $03, $0A, $17, $17, $17, $17, $17, $17, $07, $07, $07, $19, $18, $01, $18
.db $01, $18, $07, $0C, $07, $07, $07, $07, $07, $07, $07, $14, $04, $04, $6B, $5C
.db $24, $5C, $21, $5C, $00, $45, $5C, $C3, $3C, $3C, $2A, $5C, $2F, $5C, $37, $5C
.db $17, $B5, $4E, $28, $50, $08, $3E, $07, $EA, $3D, $CD, $18, $06, $08, $3E, $08
.db $EA, $3D, $CD, $3E, $54, $CD, $6D, $3E, $C3, $D7, $24, $17, $02, $07, $02, $02
.db $A7, $07, $03, $02, $A7, $00, $03, $0C, $06, $07, $FF, $D0, $01, $25, $08, $05
.db $FF, $FF, $02, $0F, $09, $09, $FF, $D1, $03, $12, $C7, $07, $02, $12, $C7, $07
.db $03, $09, $03, $01, $0A, $07, $10, $11, $07, $07, $14, $15, $07, $0D, $0C, $07
.db $0E, $14, $04, $04, $15, $5D, $8A, $5C, $87, $5C, $00, $EC, $5C, $C3, $3C, $3C
.db $94, $5C, $DD, $5C, $E2, $5C, $E2, $5C, $E7, $5C, $08, $FA, $A1, $D7, $CB, $7F
.db $20, $23, $21, $C8, $5C, $CD, $49, $3C, $01, $01, $EB, $CD, $2E, $3E, $30, $0D
.db $21, $CD, $5C, $CD, $49, $3C, $21, $A1, $D7, $CB, $FE, $18, $0E, $21, $D8, $5C
.db $CD, $49, $3C, $18, $06, $21, $D3, $5C, $CD, $49, $3C, $C3, $D7, $24, $17, $09
.db $4F, $28, $50, $17, $48, $4F, $28, $0B, $50, $17, $5D, $4F, $28, $50, $17, $C7
.db $4F, $28, $50, $17, $E3, $4F, $28, $50, $17, $10, $50, $28, $50, $17, $D8, $50
.db $28, $50, $17, $02, $07, $02, $03, $A7, $07, $03, $03, $A7, $03, $04, $00, $03
.db $04, $01, $04, $01, $02, $05, $02, $20, $06, $0B, $FF, $D0, $01, $20, $07, $06
.db $FE, $02, $02, $12, $C7, $07, $02, $12, $C7, $07, $03, $04, $04, $05, $06, $07
.db $07, $07, $07, $08, $07, $07, $06, $07, $0C, $07, $07, $14, $04, $04, $10, $5E
.db $34, $5D, $31, $5D, $00, $F0, $5D, $C3, $3C, $3C, $6C, $5D, $DA, $5D, $AF, $EA
.db $37, $CD, $11, $5B, $CC, $21, $68, $5D, $2A, $A7, $28, $1E, $E5, $D5, $EA, $1E
.db $D1, $47, $3E, $1C, $CD, $6D, $3E, $D1, $E1, $78, $A7, $28, $EB, $FA, $1E, $D1
.db $12, $13, $E5, $21, $37, $CD, $34, $E1, $18, $DE, $3E, $FF, $12, $C9, $29, $2A
.db $1F, $00, $08, $FA, $A3, $D7, $CB, $47, $20, $22, $21, $C6, $5D, $CD, $49, $3C
.db $CD, $38, $5D, $FA, $37, $CD, $A7, $28, $0A, $06, $18, $21, $06, $50, $CD, $D6
.db $35, $18, $06, $21, $CB, $5D, $CD, $49, $3C, $C3, $D7, $24, $CB, $4F, $28, $08
.db $21, $D0, $5D, $CD, $49, $3C, $18, $F1, $CD, $E8, $5D, $21, $D5, $5D, $CD, $49
.db $3C, $21, $A3, $D7, $CB, $D6, $FA, $10, $D7, $47, $0E, $1E, $CD, $48, $3E, $30
.db $D8, $21, $A3, $D7, $CB, $86, $CB, $8E, $CB, $96, $18, $CD, $17, $E8, $50, $28
.db $50, $17, $45, $51, $28, $50, $17, $56, $51, $28, $50, $17, $8D, $51, $28, $50
.db $08, $3E, $03, $EA, $3D, $CD, $3E, $54, $CD, $6D, $3E, $C3, $D7, $24, $06, $18
.db $21, $EB, $50, $C3, $D6, $35, $17, $02, $07, $02, $04, $A7, $07, $03, $04, $A7
.db $00, $02, $20, $06, $09, $FE, $02, $01, $20, $0A, $0B, $FF, $D1, $02, $12, $C7
.db $07, $02, $12, $C7, $07, $03, $12, $13, $16, $02, $0B, $0B, $07, $07, $08, $08
.db $07, $0F, $07, $0C, $07, $07, $06, $04, $07, $30, $40, $32, $5E, $2C, $5E, $00
.db $46, $5E, $CD, $FA, $22, $C3, $3C, $3C, $3A, $5E, $3B, $5E, $40, $5E, $45, $5E
.db $FF, $17, $DE, $52, $28, $50, $17, $3E, $53, $28, $50, $F6, $00, $02, $07, $03
.db $03, $FF, $07, $04, $03, $FF, $00, $04, $29, $05, $07, $FF, $D0, $01, $06, $08
.db $0D, $FE, $00, $02, $10, $0A, $06, $FF, $FF, $03, $2A, $06, $0F, $FF, $D0, $04
.db $1E, $C7, $07, $03, $1F, $C7, $07, $04, $02, $04, $04, $10, $40, $81, $5E, $7E
.db $5E, $00, $91, $5E, $C3, $3C, $3C, $B9, $24, $87, $5E, $8C, $5E, $17, $9B, $53
.db $28, $50, $17, $CB, $53, $28, $50, $00, $02, $07, $03, $04, $FF, $07, $04, $04
.db $FF, $00, $03, $26, $09, $04, $FF, $D3, $01, $1B, $06, $0A, $FF, $FF, $02, $20
.db $08, $07, $FF, $FF, $03, $12, $C7, $07, $03, $13, $C7, $07, $04, $01, $04, $04
.db $00, $40, $C6, $5E, $C3, $5E, $00, $E3, $5E, $C3, $3C, $3C, $CC, $5E, $D1, $5E
.db $D6, $5E, $17, $F7, $54, $28, $50, $17, $35, $55, $28, $50, $17, $96, $55, $28
.db $08, $3E, $28, $CD, $D0, $13, $C3, $D7, $24, $0A, $03, $07, $02, $00, $FF, $07
.db $03, $00, $FF, $01, $07, $00, $B0, $00, $03, $1C, $06, $06, $FF, $D0, $01, $0A
.db $08, $09, $FF, $D2, $02, $38, $08, $05, $FE, $01, $03, $12, $C7, $07, $02, $12
.db $C7, $07, $03, $F6, $C6, $01, $07, $07, $04, $04, $5F, $61, $D6, $60, $1D, $5F
.db $00, $2F, $61, $CD, $3C, $3C, $21, $31, $5F, $FA, $4C, $D6, $C3, $97, $3D, $AF
.db $EA, $6B, $CD, $EA, $4C, $D6, $C9, $47, $5F, $48, $5F, $6A, $5F, $BB, $5F, $E4
.db $5F, $1A, $60, $47, $60, $5F, $60, $83, $60, $99, $60, $B9, $60, $C9, $3E, $FF
.db $EA, $6B, $CD, $21, $D3, $CC, $11, $63, $5F, $CD, $0C, $35, $3D, $EA, $38, $CD
.db $CD, $86, $34, $3E, $02, $EA, $4C, $D6, $C9, $40, $01, $10, $01, $40, $03, $FF
.db $FA, $38, $CD, $A7, $C0, $CD, $D7, $3D, $AF, $EA, $6B, $CD, $21, $55, $D3, $CB
.db $BE, $3E, $01, $E0, $8C, $CD, $20, $29, $CD, $D7, $3D, $21, $2D, $D7, $CB, $F6
.db $CB, $FE, $21, $F9, $60, $11, $FE, $60, $CD, $54, $33, $3E, $F3, $EA, $59, $D0
.db $FA, $15, $D7, $FE, $B1, $20, $04, $3E, $01, $18, $0A, $FE, $99, $20, $04, $3E
.db $02, $18, $02, $3E, $03, $EA, $5D, $D0, $AF, $E0, $B4, $3E, $03, $EA, $4C, $D6
.db $C9, $FA, $57, $D0, $FE, $FF, $CA, $29, $5F, $CD, $29, $24, $21, $67, $D8, $CB
.db $CE, $3E, $F0, $EA, $6B, $CD, $3E, $01, $E0, $8C, $CD, $C8, $60, $3E, $01, $E0
.db $8C, $CD, $41, $35, $3E, $04, $EA, $4C, $D6, $C9, $06, $02, $21, $81, $5B, $CD
.db $D6, $35, $3E, $02, $E0, $8C, $CD, $C8, $60, $3E, $02, $E0, $8C, $CD, $41, $35
.db $11, $14, $60, $3E, $02, $E0, $8C, $CD, $3A, $36, $3E, $D6, $EA, $4D, $CC, $3E
.db $15, $CD, $6D, $3E, $3E, $05, $EA, $4C, $D6, $C9, $40, $40, $40, $40, $40, $FF
.db $FA, $30, $D7, $CB, $47, $C0, $3E, $02, $EA, $28, $D5, $3E, $01, $E0, $8C, $3E
.db $08, $E0, $8D, $CD, $A6, $34, $3E, $02, $E0, $8C, $AF, $E0, $8D, $CD, $A6, $34
.db $3E, $03, $E0, $8C, $CD, $C8, $60, $3E, $06, $EA, $4C, $D6, $C9, $3E, $02, $E0
.db $8C, $3E, $0C, $E0, $8D, $CD, $A6, $34, $3E, $04, $E0, $8C, $CD, $C8, $60, $3E
.db $07, $EA, $4C, $D6, $C9, $3E, $02, $E0, $8C, $AF, $E0, $8D, $CD, $A6, $34, $3E
.db $05, $E0, $8C, $CD, $C8, $60, $11, $80, $60, $3E, $02, $E0, $8C, $CD, $3A, $36
.db $3E, $08, $EA, $4C, $D6, $C9, $40, $40, $FF, $FA, $30, $D7, $CB, $47, $C0, $3E
.db $D6, $EA, $4D, $CC, $3E, $11, $CD, $6D, $3E, $3E, $09, $EA, $4C, $D6, $C9, $3E
.db $FF, $EA, $6B, $CD, $21, $D3, $CC, $11, $B4, $60, $CD, $0C, $35, $3D, $EA, $38
.db $CD, $CD, $86, $34, $3E, $0A, $EA, $4C, $D6, $C9, $40, $04, $20, $01, $FF, $FA
.db $38, $CD, $A7, $C0, $AF, $EA, $6B, $CD, $3E, $00, $EA, $4C, $D6, $C9, $3E, $F0
.db $EA, $6B, $CD, $CD, $20, $29, $3E, $FF, $EA, $6B, $CD, $C9, $E0, $60, $08, $61
.db $0D, $61, $25, $61, $2A, $61, $08, $FA, $67, $D8, $CB, $4F, $21, $F4, $60, $28
.db $03, $21, $03, $61, $CD, $49, $3C, $C3, $D7, $24, $17, $E1, $60, $21, $50, $17
.db $3B, $62, $21, $50, $17, $B4, $62, $21, $50, $17, $2F, $63, $21, $50, $17, $C1
.db $63, $21, $50, $08, $FA, $17, $D7, $EA, $1E, $D1, $CD, $9E, $2F, $21, $20, $61
.db $CD, $49, $3C, $C3, $D7, $24, $17, $CA, $63, $21, $50, $17, $63, $64, $21, $50
.db $17, $67, $65, $21, $50, $03, $04, $07, $03, $01, $71, $07, $04, $02, $71, $00
.db $03, $00, $76, $00, $04, $00, $76, $00, $02, $02, $06, $08, $FF, $D0, $01, $03
.db $0B, $07, $FF, $D1, $02, $12, $C7, $07, $03, $13, $C7, $07, $04, $F4, $C6, $00
.db $03, $F5, $C6, $00, $04, $49, $31, $32, $4A, $4B, $05, $05, $4C, $4B, $05, $05
.db $4C, $52, $31, $32, $6F, $07, $06, $05, $AC, $62, $51, $62, $7B, $61, $00, $80
.db $62, $CD, $91, $61, $CD, $3C, $3C, $21, $55, $62, $11, $BB, $61, $FA, $4D, $D6
.db $CD, $60, $31, $EA, $4D, $D6, $C9, $21, $26, $D1, $CB, $6E, $CB, $AE, $C8, $21
.db $34, $D7, $CB, $CE, $FA, $63, $D8, $CB, $4F, $28, $04, $3E, $05, $18, $02, $3E
.db $24, $EA, $9F, $D0, $01, $02, $00, $3E, $17, $C3, $6D, $3E, $AF, $EA, $4D, $D6
.db $C9, $E2, $61, $4C, $32, $3F, $62, $2C, $62, $C5, $61, $C9, $21, $D3, $CC, $3E
.db $40, $22, $22, $22, $22, $22, $77, $3E, $06, $EA, $38, $CD, $CD, $86, $34, $3E
.db $03, $EA, $4D, $D6, $EA, $39, $DA, $C9, $21, $23, $62, $CD, $BF, $34, $D2, $19
.db $32, $AF, $E0, $B3, $E0, $B4, $EA, $D3, $CC, $EA, $38, $CD, $FA, $3D, $CD, $FE
.db $03, $38, $09, $21, $63, $D8, $CB, $76, $CB, $F6, $28, $C0, $3E, $02, $E0, $8C
.db $CD, $20, $29, $3E, $40, $EA, $D3, $CC, $3E, $01, $EA, $38, $CD, $CD, $86, $34
.db $3E, $03, $EA, $4D, $D6, $EA, $39, $DA, $C9, $0A, $04, $0A, $05, $0B, $04, $0B
.db $05, $FF, $FA, $38, $CD, $A7, $C0, $CD, $D7, $3D, $AF, $EA, $6B, $CD, $EA, $4D
.db $D6, $EA, $39, $DA, $C9, $CD, $75, $32, $FA, $57, $D0, $FE, $FF, $CA, $B6, $61
.db $3E, $01, $E0, $8C, $C3, $20, $29, $62, $62, $7B, $62, $01, $00, $63, $D8, $6C
.db $62, $76, $62, $71, $62, $71, $62, $FF, $08, $21, $55, $62, $CD, $CC, $31, $C3
.db $D7, $24, $17, $EF, $65, $21, $50, $17, $C4, $66, $21, $50, $17, $D3, $66, $21
.db $50, $17, $29, $67, $21, $50, $03, $04, $0B, $04, $02, $AE, $0B, $05, $02, $AE
.db $00, $04, $00, $F6, $00, $05, $01, $F6, $00, $01, $3B, $06, $09, $FF, $D0, $41
.db $F4, $01, $2D, $C7, $0B, $04, $2D, $C7, $0B, $05, $F6, $C6, $00, $04, $F6, $C6
.db $00, $05, $21, $21, $24, $21, $21, $02, $18, $18, $18, $02, $02, $18, $18, $18
.db $02, $02, $20, $05, $20, $02, $02, $1A, $05, $02, $02, $02, $44, $05, $44, $02
.db $07, $06, $05, $03, $64, $A8, $63, $D6, $62, $00, $D7, $63, $CD, $EC, $62, $CD
.db $3C, $3C, $21, $AC, $63, $11, $12, $63, $FA, $4E, $D6, $CD, $60, $31, $EA, $4E
.db $D6, $C9, $21, $26, $D1, $CB, $6E, $CB, $AE, $C8, $FA, $64, $D8, $CB, $4F, $28
.db $05, $3E, $05, $C3, $02, $63, $3E, $24, $EA, $9F, $D0, $01, $02, $00, $3E, $17
.db $C3, $6D, $3E, $AF, $EA, $4E, $D6, $C9, $39, $63, $4C, $32, $96, $63, $83, $63
.db $1C, $63, $C9, $21, $D3, $CC, $3E, $40, $22, $22, $22, $22, $22, $77, $3E, $06
.db $EA, $38, $CD, $CD, $86, $34, $3E, $03, $EA, $4E, $D6, $EA, $39, $DA, $C9, $21
.db $7A, $63, $CD, $BF, $34, $D2, $19, $32, $AF, $E0, $B3, $E0, $B4, $EA, $D3, $CC
.db $EA, $38, $CD, $FA, $3D, $CD, $FE, $03, $38, $09, $21, $64, $D8, $CB, $76, $CB
.db $F6, $28, $C0, $3E, $02, $E0, $8C, $CD, $20, $29, $3E, $40, $EA, $D3, $CC, $3E
.db $01, $EA, $38, $CD, $CD, $86, $34, $3E, $03, $EA, $4E, $D6, $EA, $39, $DA, $C9
.db $0A, $04, $0A, $05, $0B, $04, $0B, $05, $FF, $FA, $38, $CD, $A7, $C0, $CD, $D7
.db $3D, $AF, $EA, $6B, $CD, $EA, $4E, $D6, $EA, $39, $DA, $C9, $CD, $75, $32, $FA
.db $57, $D0, $FE, $FF, $CA, $0D, $63, $3E, $01, $E0, $8C, $C3, $20, $29, $B9, $63
.db $D2, $63, $01, $00, $64, $D8, $C3, $63, $CD, $63, $C8, $63, $C8, $63, $FF, $08
.db $21, $AC, $63, $CD, $CC, $31, $C3, $D7, $24, $17, $49, $67, $21, $50, $17, $05
.db $68, $21, $50, $17, $1D, $68, $21, $50, $17, $4B, $68, $21, $50, $03, $04, $0B
.db $04, $02, $F5, $0B, $05, $03, $F5, $00, $04, $00, $F7, $00, $05, $01, $F7, $00
.db $01, $3A, $06, $09, $FF, $D0, $41, $E9, $01, $2D, $C7, $0B, $04, $2D, $C7, $0B
.db $05, $F6, $C6, $00, $04, $F6, $C6, $00, $05, $01, $01, $05, $01, $01, $08, $05
.db $05, $05, $0A, $0C, $12, $05, $13, $0D, $0C, $0A, $05, $0B, $0C, $08, $07, $05
.db $0C, $08, $0D, $11, $05, $0A, $0D, $0F, $06, $05, $60, $65, $05, $65, $2D, $64
.db $00, $34, $65, $CD, $43, $64, $CD, $3C, $3C, $21, $09, $65, $11, $69, $64, $FA
.db $4F, $D6, $CD, $60, $31, $EA, $4F, $D6, $C9, $21, $26, $D1, $CB, $6E, $CB, $AE
.db $C8, $FA, $65, $D8, $CB, $4F, $28, $05, $3E, $0E, $C3, $59, $64, $3E, $3B, $EA
.db $9F, $D0, $01, $02, $00, $3E, $17, $C3, $6D, $3E, $AF, $EA, $4F, $D6, $C9, $90
.db $64, $4C, $32, $ED, $64, $DA, $64, $73, $64, $C9, $21, $D3, $CC, $3E, $40, $22
.db $22, $22, $22, $22, $77, $3E, $06, $EA, $38, $CD, $CD, $86, $34, $3E, $03, $EA
.db $4F, $D6, $EA, $39, $DA, $C9, $21, $D1, $64, $CD, $BF, $34, $D2, $19, $32, $AF
.db $E0, $B3, $E0, $B4, $EA, $D3, $CC, $EA, $38, $CD, $FA, $3D, $CD, $FE, $03, $38
.db $09, $21, $65, $D8, $CB, $76, $CB, $F6, $28, $C0, $3E, $02, $E0, $8C, $CD, $20
.db $29, $3E, $40, $EA, $D3, $CC, $3E, $01, $EA, $38, $CD, $CD, $86, $34, $3E, $03
.db $EA, $4F, $D6, $EA, $39, $DA, $C9, $0A, $04, $0A, $05, $0B, $04, $0B, $05, $FF
.db $FA, $38, $CD, $A7, $C0, $CD, $D7, $3D, $AF, $EA, $6B, $CD, $EA, $4F, $D6, $EA
.db $39, $DA, $C9, $CD, $75, $32, $FA, $57, $D0, $FE, $FF, $CA, $64, $64, $3E, $01
.db $E0, $8C, $CD, $20, $29, $3E, $01, $EA, $4C, $D6, $C9, $16, $65, $2F, $65, $01
.db $00, $65, $D8, $20, $65, $2A, $65, $25, $65, $25, $65, $FF, $08, $21, $09, $65
.db $CD, $CC, $31, $C3, $D7, $24, $17, $6B, $68, $21, $50, $17, $70, $69, $21, $50
.db $17, $98, $69, $21, $50, $17, $FD, $69, $21, $50, $00, $04, $0B, $04, $02, $F6
.db $0B, $05, $03, $F6, $00, $04, $00, $71, $00, $05, $00, $71, $00, $01, $39, $06
.db $09, $FF, $D0, $41, $F6, $01, $2D, $C7, $0B, $04, $2D, $C7, $0B, $05, $F6, $C6
.db $00, $04, $F6, $C6, $00, $05, $47, $47, $36, $47, $47, $67, $36, $36, $4E, $65
.db $52, $4E, $36, $65, $52, $65, $67, $36, $65, $65, $52, $4B, $36, $65, $52, $67
.db $52, $36, $68, $68
.INCLUDE "wla/banks/bank29_itemfinder_2.asm"
.dsb 6021, $00
