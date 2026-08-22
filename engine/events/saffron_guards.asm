RemoveGuardDrink:
	ld hl, GuardDrinksList
RemoveGuardDrink.drinkLoop
	ld a, [hli]
	ldh [lobyte(hItemToRemoveID)], a
	and a
	ret z
	push hl
	ld b, a
	call IsItemInBag
	pop hl
	jr z, RemoveGuardDrink.drinkLoop
	farjp RemoveItemByID

.INCLUDE "data/items/guard_drink_items.asm"
