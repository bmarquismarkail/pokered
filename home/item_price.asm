GetItemPrice:
; Stores item's price as BCD at hItemPrice (3 bytes)
; Input: [wCurItem] = item id
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, [wListMenuID]
	cp MOVESLISTMENU
	ld a, bank(ItemPrices)
	jr nz, GetItemPrice.ok
	ld a, $f ; hardcoded Bank
GetItemPrice.ok
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ld hl, wItemPrices
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCurItem]
	cp HM01
	jr nc, GetItemPrice.getTMPrice
	ld bc, $3
GetItemPrice.loop
	add hl, bc
	dec a
	jr nz, GetItemPrice.loop
	dec hl
	ld a, [hld]
	ldh [lobyte(hItemPrice + 2)], a
	ld a, [hld]
	ldh [lobyte(hItemPrice + 1)], a
	ld a, [hl]
	ldh [lobyte(hItemPrice)], a
	jr GetItemPrice.done
GetItemPrice.getTMPrice
	ld a, bank(GetMachinePrice)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	call GetMachinePrice
GetItemPrice.done
	ld de, hItemPrice
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret
