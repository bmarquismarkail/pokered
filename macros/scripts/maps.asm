.MACRO def_object_events
	; Counts are committed explicitly in each map object file.
.ENDM

;\1 x position
;\2 y position
;\3 sprite id
;\4 movement (WALK/STAY)
;\5 range or direction
;\6 text id
;\7 items only: item id
;\7 trainers only: trainer class/pokemon id
;\8 trainers only: trainer number/pokemon level
.MACRO object_event
	.DB \3
	.DB \2 + 4
	.DB \1 + 4
	.DB \4
	.DB \5
	.IF NARGS > 7
		.DB TRAINER | \6
		.DB \7
		.DB \8
	.ELIF NARGS > 6
		.DB ITEM | \6
		.DB \7
	.ELSE
		.DB \6
	.ENDIF
.ENDM

.MACRO def_warp_events
	; Counts are committed explicitly in each map object file.
.ENDM

;\1 x position
;\2 y position
;\3 destination map (-1 = wLastMap)
;\4 destination warp id; starts at 1 (internally at 0)
.MACRO warp_event
	.DB \2, \1, \4 - 1, \3
.ENDM

.MACRO def_bg_events
	; Counts are committed explicitly in each map object file.
.ENDM

;\1 x position
;\2 y position
;\3 sign id
.MACRO bg_event
	.DB \2, \1, \3
.ENDM

;\1 source map
.MACRO def_warps_to
	; Warp displacements are committed explicitly in each map object file.
.ENDM

;\1 x position
;\2 y position
;\3 map width
.MACRO warp_to
	event_displacement \3, \1, \2
.ENDM


;\1 first bit offset / first object id
.MACRO def_trainers
	.IF (((NARGS))-(1)) < 1 && (((NARGS))-(1)) > -1
		.REDEFINE CURRENT_TRAINER_BIT \1
	.ELSE
		.REDEFINE CURRENT_TRAINER_BIT 1
	.ENDIF
.ENDM

;\1 event flag
;\2 view range
;\3 TextBeforeBattle
;\4 TextEndBattle
;\5 TextAfterBattle
.MACRO trainer
	.REDEFINE _ev_bit \1 # 8
	.REDEFINE _cur_bit CURRENT_TRAINER_BIT # 8
	.ASSERT ((_ev_bit)-(_cur_bit)) < 1 && ((_ev_bit)-(_cur_bit)) > -1
	.DB CURRENT_TRAINER_BIT
	.DB \2 << 4
	.DW wEventFlags + (\1 - CURRENT_TRAINER_BIT) / 8
	.DW \3, \5, \4, \4
	.REDEFINE CURRENT_TRAINER_BIT CURRENT_TRAINER_BIT + (1)
.ENDM

;\1 x position
;\2 y position
;\3 movement data
.MACRO map_coord_movement
	dbmapcoord \1, \2
	.DW \3
.ENDM


;\1 map name
;\2 map id
;\3 tileset
.MACRO map_header ARGS map_name, map_id, tileset
	.REDEFINE CURRENT_MAP_ID map_id
	.REDEFINE CURRENT_MAP_NAME map_name
	.ARRAYOUT NAME map_widths INDEX map_id DEFINITION CURRENT_MAP_WIDTH
	.ARRAYOUT NAME map_heights INDEX map_id DEFINITION CURRENT_MAP_HEIGHT
{map_name}_h:
	.DB tileset
	.DB CURRENT_MAP_HEIGHT, CURRENT_MAP_WIDTH
	.DW {map_name}_Blocks
	.DW {map_name}_TextPointers
	.DW {map_name}_Script
	.DB MAP_CONNECTIONS_{map_id}
	; Define the connection mask after emitting its forward reference so later
	; connection calls can update the final value.
	.REDEFINE MAP_CONNECTIONS_{map_id} 0
.ENDM

; Comes after map_header and connection macros
.MACRO end_map_header
	.DW {CURRENT_MAP_NAME}_Object
.ENDM

; Connections go in order: north, south, west, east
;\1 direction
;\2 map name
;\3 map id
;\4 offset of the target map relative to the current map
;   (x offset for east/west, y offset for north/south)
.MACRO connection ARGS direction, map_name, map_id, offset
	.ARRAYOUT NAME map_widths INDEX map_id DEFINITION _target_width
	.ARRAYOUT NAME map_heights INDEX map_id DEFINITION _target_height

	; Calculate tile offsets for source (current) and target maps
	.REDEFINE _src 0
	.REDEFINE _tgt (\4) + 3
	.IF _tgt < 2
		.REDEFINE _src -_tgt
		.REDEFINE _tgt 0
	.ENDIF

	.IF direction & NORTH
		.IF MAP_CONNECTIONS_{CURRENT_MAP_ID} & (NORTH | SOUTH | WEST | EAST)
			.FAIL "Invalid order for 'connection' (must be north, south, west, east)"
		.ENDIF
		.REDEFINE MAP_CONNECTIONS_{CURRENT_MAP_ID} MAP_CONNECTIONS_{CURRENT_MAP_ID} | (NORTH)
		.REDEFINE _blk _target_width * (_target_height - 3) + _src
		.REDEFINE _map _tgt
		.REDEFINE _win (_target_width + 6) * _target_height + 1
		.REDEFINE _y _target_height * 2 - 1
		.REDEFINE _x (\4) * -2
		.REDEFINE _len CURRENT_MAP_WIDTH + 3 - (\4)
		.IF _len > _target_width
			.REDEFINE _len _target_width
		.ENDIF

	.ENDIF
	.IF direction & SOUTH
		.IF MAP_CONNECTIONS_{CURRENT_MAP_ID} & (SOUTH | WEST | EAST)
			.FAIL "Invalid order for 'connection' (must be north, south, west, east)"
		.ENDIF
		.REDEFINE MAP_CONNECTIONS_{CURRENT_MAP_ID} MAP_CONNECTIONS_{CURRENT_MAP_ID} | (SOUTH)
		.REDEFINE _blk _src
		.REDEFINE _map (CURRENT_MAP_WIDTH + 6) * (CURRENT_MAP_HEIGHT + 3) + _tgt
		.REDEFINE _win _target_width + 7
		.REDEFINE _y 0
		.REDEFINE _x (\4) * -2
		.REDEFINE _len CURRENT_MAP_WIDTH + 3 - (\4)
		.IF _len > _target_width
			.REDEFINE _len _target_width
		.ENDIF

	.ENDIF
	.IF direction & WEST
		.IF MAP_CONNECTIONS_{CURRENT_MAP_ID} & (WEST | EAST)
			.FAIL "Invalid order for 'connection' (must be north, south, west, east)"
		.ENDIF
		.REDEFINE MAP_CONNECTIONS_{CURRENT_MAP_ID} MAP_CONNECTIONS_{CURRENT_MAP_ID} | (WEST)
		.REDEFINE _blk (_target_width * _src) + _target_width - 3
		.REDEFINE _map (CURRENT_MAP_WIDTH + 6) * _tgt
		.REDEFINE _win (_target_width + 6) * 2 - 6
		.REDEFINE _y (\4) * -2
		.REDEFINE _x _target_width * 2 - 1
		.REDEFINE _len CURRENT_MAP_HEIGHT + 3 - (\4)
		.IF _len > _target_height
			.REDEFINE _len _target_height
		.ENDIF

	.ENDIF
	.IF direction & EAST
		.IF MAP_CONNECTIONS_{CURRENT_MAP_ID} & EAST
			.FAIL "Invalid order for 'connection' (must be north, south, west, east)"
		.ENDIF
		.REDEFINE MAP_CONNECTIONS_{CURRENT_MAP_ID} MAP_CONNECTIONS_{CURRENT_MAP_ID} | (EAST)
		.REDEFINE _blk (_target_width * _src)
		.REDEFINE _map (CURRENT_MAP_WIDTH + 6) * _tgt + CURRENT_MAP_WIDTH + 3
		.REDEFINE _win _target_width + 7
		.REDEFINE _y (\4) * -2
		.REDEFINE _x 0
		.REDEFINE _len CURRENT_MAP_HEIGHT + 3 - (\4)
		.IF _len > _target_height
			.REDEFINE _len _target_height
		.ENDIF

	.ENDIF

	.DB map_id
	.DW {map_name}_Blocks + _blk
	.DW wOverworldMap + _map
	.DB _len - _src
	.DB _target_width
	.DB _y, _x
	.DW wOverworldMap + _win
.ENDM

.MACRO def_script_pointers
	const_def
.ENDM

.MACRO def_text_pointers
	const_def 1
.ENDM

.MACRO object_const_def
	const_def 1
.ENDM
