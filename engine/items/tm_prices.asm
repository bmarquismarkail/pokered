GetMachinePrice:
; Input:  [wCurItem] = Item ID of a TM
; Output: Stores the TM price at hItemPrice
	ld a, [wCurItem]
	sub TM01 ; underflows below 0 for HM items (before TM items)
	ret c ; HMs are priceless
	ld d, a
	ld hl, TechnicalMachinePrices
	srl a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl] ; a contains byte whose high or low nybble is the TM price (in thousands)
	srl d
	jr nc, GetMachinePrice.highNybbleIsPrice ; is TM id odd?
	swap a
GetMachinePrice.highNybbleIsPrice
	and $f0
	ldh [lobyte(hItemPrice + 1)], a
	xor a
	ldh [lobyte(hItemPrice)], a
	ldh [lobyte(hItemPrice + 2)], a
	ret

.INCLUDE "data/items/tm_prices.asm"
