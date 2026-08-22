.MACRO two_option_menu
	.DB \1, \2, \3
	.DW \4
.ENDM

TwoOptionMenuStrings:
; entries correspond to *_MENU constants
	table_width 5
	; width, height, blank line before first menu item?, text pointer
	two_option_menu 4, 3, FALSE, TwoOptionMenuStrings.YesNoMenu
	two_option_menu 6, 3, FALSE, TwoOptionMenuStrings.NorthWestMenu
	two_option_menu 6, 3, FALSE, TwoOptionMenuStrings.SouthEastMenu
	two_option_menu 6, 3, FALSE, TwoOptionMenuStrings.YesNoMenu
	two_option_menu 6, 3, FALSE, TwoOptionMenuStrings.NorthEastMenu
	two_option_menu 7, 3, FALSE, TwoOptionMenuStrings.TradeCancelMenu
	two_option_menu 7, 4, TRUE,  TwoOptionMenuStrings.HealCancelMenu
	two_option_menu 4, 3, FALSE, TwoOptionMenuStrings.NoYesMenu
	assert_table_length NUM_TWO_OPTION_MENUS

TwoOptionMenuStrings.NoYesMenu:
		.STRINGMAP pokemon, "NO"
	next "YES@"

TwoOptionMenuStrings.YesNoMenu:
		.STRINGMAP pokemon, "YES"
	next "NO@"

TwoOptionMenuStrings.NorthWestMenu:
		.STRINGMAP pokemon, "NORTH"
	next "WEST@"

TwoOptionMenuStrings.SouthEastMenu:
		.STRINGMAP pokemon, "SOUTH"
	next "EAST@"

TwoOptionMenuStrings.NorthEastMenu:
		.STRINGMAP pokemon, "NORTH"
	next "EAST@"

TwoOptionMenuStrings.TradeCancelMenu:
		.STRINGMAP pokemon, "TRADE"
	next "CANCEL@"

TwoOptionMenuStrings.HealCancelMenu:
		.STRINGMAP pokemon, "HEAL"
	next "CANCEL@"
