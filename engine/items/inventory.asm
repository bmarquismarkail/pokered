; function to add an item (in varying quantities) to the player's bag or PC box
; INPUT:
; hl = address of inventory (either wNumBagItems or wNumBoxItems)
; [wCurItem] = item ID
; [wItemQuantity] = item quantity
; sets carry flag if successful, unsets carry flag if unsuccessful
AddItemToInventory_:
	ld a, [wItemQuantity] ; a = item quantity
	push af
	push bc
	push de
	push hl
	push hl
	ld d, PC_ITEM_CAPACITY ; how many items the PC can hold
	ld a, lobyte(wNumBagItems)
	cp l
	jr nz, AddItemToInventory_.checkIfInventoryFull
	ld a, hibyte(wNumBagItems)
	cp h
	jr nz, AddItemToInventory_.checkIfInventoryFull
; if the destination is the bag
	ld d, BAG_ITEM_CAPACITY ; how many items the bag can hold
AddItemToInventory_.checkIfInventoryFull
	ld a, [hl]
	sub d
	ld d, a
	ld a, [hli]
	and a
	jr z, AddItemToInventory_.addNewItem
AddItemToInventory_.notAtEndOfInventory
	ld a, [hli]
	ld b, a ; b = ID of current item in table
	ld a, [wCurItem] ; a = ID of item being added
	cp b ; does the current item in the table match the item being added?
	jp z, AddItemToInventory_.increaseItemQuantity ; if so, increase the item's quantity
	inc hl
	ld a, [hl]
	cp $ff ; is it the end of the table?
	jr nz, AddItemToInventory_.notAtEndOfInventory
AddItemToInventory_.addNewItem ; add an item not yet in the inventory
	pop hl
	ld a, d
	and a ; is there room for a new item slot?
	jr z, AddItemToInventory_.done
; if there is room
	inc [hl] ; increment the number of items in the inventory
	ld a, [hl] ; the number of items will be the index of the new item
	add a
	dec a
	ld c, a
	ld b, 0
	add hl, bc ; hl = address to store the item
	ld a, [wCurItem]
	ld [hli], a ; store item ID
	ld a, [wItemQuantity]
	ld [hli], a ; store item quantity
	ld [hl], $ff ; store terminator
	jp AddItemToInventory_.success
AddItemToInventory_.increaseItemQuantity ; increase the quantity of an item already in the inventory
	ld a, [wItemQuantity]
	ld b, a ; b = quantity to add
	ld a, [hl] ; a = existing item quantity
	add b ; a = new item quantity
	cp 100
	jp c, AddItemToInventory_.storeNewQuantity ; if the new quantity is less than 100, store it
; if the new quantity is greater than or equal to 100,
; try to max out the current slot and add the rest in a new slot
	sub 99
	ld [wItemQuantity], a ; a = amount left over (to put in the new slot)
	ld a, d
	and a ; is there room for a new item slot?
	jr z, AddItemToInventory_.increaseItemQuantityFailed
; if so, store 99 in the current slot and store the rest in a new slot
	ld a, 99
	ld [hli], a
	jp AddItemToInventory_.notAtEndOfInventory
AddItemToInventory_.increaseItemQuantityFailed
	pop hl
	and a
	jr AddItemToInventory_.done
AddItemToInventory_.storeNewQuantity
	ld [hl], a
	pop hl
AddItemToInventory_.success
	scf
AddItemToInventory_.done
	pop hl
	pop de
	pop bc
	pop bc
	ld a, b
	ld [wItemQuantity], a ; restore the initial value from when the function was called
	ret

; function to remove an item (in varying quantities) from the player's bag or PC box
; INPUT:
; hl = address of inventory (either wNumBagItems or wNumBoxItems)
; [wWhichPokemon] = index (within the inventory) of the item to remove
; [wItemQuantity] = quantity to remove
RemoveItemFromInventory_:
	push hl
	inc hl
	ld a, [wWhichPokemon] ; index (within the inventory) of the item being removed
	sla a
	add l
	ld l, a
	jr nc, RemoveItemFromInventory_.noCarry
	inc h
RemoveItemFromInventory_.noCarry
	inc hl
	ld a, [wItemQuantity] ; quantity being removed
	ld e, a
	ld a, [hl] ; a = current quantity
	sub e
	ld [hld], a ; store new quantity
	ld [wMaxItemQuantity], a
	and a
	jr nz, RemoveItemFromInventory_.skipMovingUpSlots
; if the remaining quantity is 0,
; remove the emptied item slot and move up all the following item slots
	ld e, l
	ld d, h
	inc de
	inc de ; de = address of the slot following the emptied one
RemoveItemFromInventory_.loop ; loop to move up the following slots
	ld a, [de]
	inc de
	ld [hli], a
	cp $ff
	jr nz, RemoveItemFromInventory_.loop
; update menu info
	xor a
	ld [wListScrollOffset], a
	ld [wCurrentMenuItem], a
	ld [wBagSavedMenuItem], a
	ld [wSavedListScrollOffset], a
	pop hl
	ld a, [hl] ; a = number of items in inventory
	dec a ; decrement the number of items
	ld [hl], a ; store new number of items
	ld [wListCount], a
	cp 2
	jr c, RemoveItemFromInventory_.done
	ld [wMaxMenuItem], a
	jr RemoveItemFromInventory_.done
RemoveItemFromInventory_.skipMovingUpSlots
	pop hl
RemoveItemFromInventory_.done
	ret
