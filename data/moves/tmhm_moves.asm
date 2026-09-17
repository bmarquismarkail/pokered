; The add_hm and add_tm macros in constants/item_constants.asm simultaneously
; define constants for the item IDs and for the corresponding move values.

TechnicalMachines:
	table_width 1

.REPEAT NUM_TMS START 1 INDEX n
.DB TM{%.2d{n}}_MOVE
.ENDR
	assert_table_length NUM_TMS

.REPEAT NUM_HMS START 1 INDEX n
.DB HM{%.2d{n}}_MOVE
.ENDR
	assert_table_length NUM_TM_HM
