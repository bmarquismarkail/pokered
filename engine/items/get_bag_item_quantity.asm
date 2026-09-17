GetQuantityOfItemInBag:
; In: b = item ID
; Out: b = how many of that item are in the bag
	call GetPredefRegisters
	ld hl, wNumBagItems
GetQuantityOfItemInBag.loop
	inc hl
	ld a, [hli]
	cp $ff
	jr z, GetQuantityOfItemInBag.notInBag
	cp b
	jr nz, GetQuantityOfItemInBag.loop
	ld a, [hl]
	ld b, a
	ret
GetQuantityOfItemInBag.notInBag
	ld b, 0
	ret
