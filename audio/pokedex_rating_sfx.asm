PlayPokedexRatingSfx:
	ldh a, [lobyte(hDexRatingNumMonsOwned)]
	ld c, $0
	ld hl, OwnedMonValues
PlayPokedexRatingSfx.getSfxPointer
	cp [hl]
	jr c, PlayPokedexRatingSfx.gotSfxPointer
	inc c
	inc hl
	jr PlayPokedexRatingSfx.getSfxPointer
PlayPokedexRatingSfx.gotSfxPointer
	push bc
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySoundWaitForCurrent
	pop bc
	ld b, $0
	ld hl, PokedexRatingSfxPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, [hl]
	call PlayMusic
	jp PlayDefaultMusic

PokedexRatingSfxPointers:
	.DB SFX_DENIED,         bank(SFX_Denied_3)
	.DB SFX_POKEDEX_RATING, bank(SFX_Pokedex_Rating_1)
	.DB SFX_GET_ITEM_1,     bank(SFX_Get_Item1_1)
	.DB SFX_CAUGHT_MON,     bank(SFX_Caught_Mon)
	.DB SFX_LEVEL_UP,       bank(SFX_Level_Up)
	.DB SFX_GET_KEY_ITEM,   bank(SFX_Get_Key_Item_1)
	.DB SFX_GET_ITEM_2,     bank(SFX_Get_Item2_1)

OwnedMonValues:
	.DB 10, 40, 60, 90, 120, 150, $ff
