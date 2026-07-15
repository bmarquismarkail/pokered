; Native WLA-DX form of engine/events/saffron_guards.asm.
.DEFINE IsItemInBag $3493

RemoveGuardDrink:
	LD HL, GuardDrinksList
RemoveGuardDrinkDrinkLoop:
	LD A, (HL+)
	LDH ($db), A ; hItemToRemoveID
	AND A
	RET Z
	PUSH HL
	LD B, A
	CALL IsItemInBag
	POP HL
	JR Z, RemoveGuardDrinkDrinkLoop
	LD B, $05
	LD HL, RemoveItemByID
	JP Bankswitch

GuardDrinksList:
	.DB $3c, $3d, $3e, $00 ; FRESH_WATER, SODA_POP, LEMONADE, end
SaffronGuardsEnd:
