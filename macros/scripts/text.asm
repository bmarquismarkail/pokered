.MACRO text ARGS str
	.DB TX_START ; Start writing text
	.IF \?1 == ARG_STRING
		.STRINGMAP pokemon, str
	.ELSE
		.REPT NARGS
			.DB \1
			.SHIFT
		.ENDR
	.ENDIF
.ENDM

.MACRO next ARGS str
	.DB $4e ; Move a line down
	.IF \?1 == ARG_STRING
		.STRINGMAP pokemon, str
	.ELSE
		.REPT NARGS
			.DB \1
			.SHIFT
		.ENDR
	.ENDIF
.ENDM

.MACRO line ARGS str
	.DB $4f ; Start writing at the bottom line
	.IF \?1 == ARG_STRING
		.STRINGMAP pokemon, str
	.ELSE
		.REPT NARGS
			.DB \1
			.SHIFT
		.ENDR
	.ENDIF
.ENDM

.MACRO para ARGS str
	.DB $51 ; Start a new paragraph
	.IF \?1 == ARG_STRING
		.STRINGMAP pokemon, str
	.ELSE
		.REPT NARGS
			.DB \1
			.SHIFT
		.ENDR
	.ENDIF
.ENDM

.MACRO cont ARGS str
	.DB $55 ; Scroll to the next line
	.IF \?1 == ARG_STRING
		.STRINGMAP pokemon, str
	.ELSE
		.REPT NARGS
			.DB \1
			.SHIFT
		.ENDR
	.ENDIF
.ENDM

.MACRO done
	.DB $57 ; End a text box
.ENDM

.MACRO prompt
	.DB $58 ; Prompt the player to end a text box (initiating some other event)
.ENDM

.MACRO page ARGS str
	.DB $49 ; Start a new Pokédex page
	.IF \?1 == ARG_STRING
		.STRINGMAP pokemon, str
	.ELSE
		.REPT NARGS
			.DB \1
			.SHIFT
		.ENDR
	.ENDIF
.ENDM

.MACRO dex
	.DB $5f, $50 ; End a Pokédex entry
.ENDM


; TextCommandJumpTable indexes (see home/text.asm)
	const_def

	const TX_START ; $00
.MACRO text_start
	.DB TX_START
.ENDM

	const TX_RAM ; $01
.MACRO text_ram
	.DB TX_RAM
	.DW \1 ; address to read from
.ENDM

	const TX_BCD ; $02
.MACRO text_bcd
	.DB TX_BCD
	.DW \1 ; address to read from
	.DB \2 ; number of bytes + print flags
.ENDM

	const TX_MOVE ; $03
.MACRO text_move
	.DB TX_MOVE
	.DW \1 ; address of the new location
.ENDM

	const TX_BOX ; $04
.MACRO text_box
; draw box
	.DB TX_BOX
	.DW \1 ; address of upper left corner
	.DB \2, \3 ; height, width
.ENDM

	const TX_LOW ; $05
.MACRO text_low
	.DB TX_LOW
.ENDM

	const TX_PROMPT_BUTTON ; $06
.MACRO text_promptbutton
	.DB TX_PROMPT_BUTTON
.ENDM

	const TX_SCROLL ; $07
.MACRO text_scroll
	.DB TX_SCROLL
.ENDM

	const TX_START_ASM ; $08
.MACRO text_asm
	.DB TX_START_ASM
.ENDM

	const TX_NUM ; $09
.MACRO text_decimal
; print a big-endian decimal number.
	.DB TX_NUM
	.DW \1 ; address to read from
	dn \2, \3 ; number of bytes to read, number of digits to display
.ENDM

	const TX_PAUSE ; $0a
.MACRO text_pause
	.DB TX_PAUSE
.ENDM

	const TX_SOUND_GET_ITEM_1 ; $0b
.MACRO sound_get_item_1
	.DB TX_SOUND_GET_ITEM_1
.ENDM

.DEFINE TX_SOUND_LEVEL_UP TX_SOUND_GET_ITEM_1
.MACRO sound_level_up
	.DB TX_SOUND_LEVEL_UP
.ENDM

	const TX_DOTS ; $0c
.MACRO text_dots
	.DB TX_DOTS
	.DB \1 ; number of ellipses to draw
.ENDM

	const TX_WAIT_BUTTON ; $0d
.MACRO text_waitbutton
	.DB TX_WAIT_BUTTON
.ENDM

	const TX_SOUND_POKEDEX_RATING ; $0e
.MACRO sound_pokedex_rating
	.DB TX_SOUND_POKEDEX_RATING
.ENDM

	const TX_SOUND_GET_ITEM_1_DUPLICATE ; $0f
.MACRO sound_get_item_1_duplicate
	.DB TX_SOUND_GET_ITEM_1_DUPLICATE
.ENDM

	const TX_SOUND_GET_ITEM_2 ; $10
.MACRO sound_get_item_2
	.DB TX_SOUND_GET_ITEM_2
.ENDM

	const TX_SOUND_GET_KEY_ITEM ; $11
.MACRO sound_get_key_item
	.DB TX_SOUND_GET_KEY_ITEM
.ENDM

	const TX_SOUND_CAUGHT_MON ; $12
.MACRO sound_caught_mon
	.DB TX_SOUND_CAUGHT_MON
.ENDM

	const TX_SOUND_DEX_PAGE_ADDED ; $13
.MACRO sound_dex_page_added
	.DB TX_SOUND_DEX_PAGE_ADDED
.ENDM

	const TX_SOUND_CRY_NIDORINA ; $14
.MACRO sound_cry_nidorina
	.DB TX_SOUND_CRY_NIDORINA
.ENDM

	const TX_SOUND_CRY_PIDGEOT ; $15
.MACRO sound_cry_pidgeot
	.DB TX_SOUND_CRY_PIDGEOT
.ENDM

	const TX_SOUND_CRY_DEWGONG ; $16
.MACRO sound_cry_dewgong
	.DB TX_SOUND_CRY_DEWGONG
.ENDM

	const TX_FAR ; $17
.MACRO text_far
	.DB TX_FAR
	dab \1 ; address of text commands
.ENDM


	const_next $50

	const TX_END ; $50
.MACRO text_end
	.DB TX_END
.ENDM


; Text script IDs (see home/text_script.asm)
	const_def -1, -1

	const TX_SCRIPT_POKECENTER_NURSE ; $ff
.MACRO script_pokecenter_nurse
	.DB TX_SCRIPT_POKECENTER_NURSE
.ENDM

	const TX_SCRIPT_MART ; $fe
.MACRO script_mart
	.DB TX_SCRIPT_MART
	.DB NARGS ; number of items
	.REPT NARGS
		.DB \1 ; all item ids
		.SHIFT
	.ENDR
	.DB -1 ; end
.ENDM

	const TX_SCRIPT_BILLS_PC ; $fd
.MACRO script_bills_pc
	.DB TX_SCRIPT_BILLS_PC
.ENDM

	const TX_SCRIPT_PLAYERS_PC ; $fc
.MACRO script_players_pc
	.DB TX_SCRIPT_PLAYERS_PC
.ENDM

	const_skip ; $fb

	const_skip ; $fa

	const TX_SCRIPT_POKECENTER_PC ; $f9
.MACRO script_pokecenter_pc
	.DB TX_SCRIPT_POKECENTER_PC
.ENDM

	const_skip ; $f8

	const TX_SCRIPT_PRIZE_VENDOR ; $f7
.MACRO script_prize_vendor
	.DB TX_SCRIPT_PRIZE_VENDOR
.ENDM

	const TX_SCRIPT_CABLE_CLUB_RECEPTIONIST ; $f6
.MACRO script_cable_club_receptionist
	.DB TX_SCRIPT_CABLE_CLUB_RECEPTIONIST
.ENDM

	const TX_SCRIPT_VENDING_MACHINE ; $f5
.MACRO script_vending_machine
	.DB TX_SCRIPT_VENDING_MACHINE
.ENDM
