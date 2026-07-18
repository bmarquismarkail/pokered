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
.INCLUDE "wla/banks/bank29_cinnabar_gym_blaine_text.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_trainer_texts.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_guide_text.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_object.asm"
.INCLUDE "wla/banks/bank29_cinnabar_gym_blocks.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_header.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_script.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_object.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_blocks.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_trade_room_header.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_trade_room_script.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_trade_room_object.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_trade_room_blocks.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_metronome_room_header.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_metronome_room_script.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_metronome_room_object.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_metronome_room_blocks.asm"
.INCLUDE "wla/banks/bank29_cinnabar_lab_fossil_room.asm"
.INCLUDE "wla/banks/bank29_cinnabar_pokecenter_header.asm"
.INCLUDE "wla/banks/bank29_cinnabar_pokecenter_dispatch.asm"
.INCLUDE "wla/banks/bank29_cinnabar_pokecenter_texts.asm"
.INCLUDE "wla/banks/bank29_cinnabar_pokecenter_object.asm"
.INCLUDE "wla/banks/bank29_cinnabar_mart.asm"
.INCLUDE "wla/banks/bank29_copycats_house_1f.asm"
.INCLUDE "wla/banks/bank29_champions_room_entry.asm"
.INCLUDE "wla/banks/bank29_champions_room_rival_ready.asm"
.INCLUDE "wla/banks/bank29_champions_room_post_battle.asm"
.INCLUDE "wla/banks/bank29_champions_room_oak_sequence.asm"
.INCLUDE "wla/banks/bank29_champions_room_texts.asm"
.INCLUDE "wla/banks/bank29_champions_room_map_data.asm"
.INCLUDE "wla/banks/bank29_loreleis_room_entry.asm"
.INCLUDE "wla/banks/bank29_loreleis_room_battle_control.asm"
.INCLUDE "wla/banks/bank29_loreleis_room_texts.asm"
.INCLUDE "wla/banks/bank29_loreleis_room_map_data.asm"
.INCLUDE "wla/banks/bank29_brunos_room_entry.asm"
.INCLUDE "wla/banks/bank29_brunos_room_battle_control.asm"
.INCLUDE "wla/banks/bank29_brunos_room_texts.asm"
.INCLUDE "wla/banks/bank29_brunos_room_map_data.asm"
.db $0F, $06, $05, $60, $65, $05, $65, $2D, $64
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
