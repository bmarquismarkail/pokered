UpdateSprites:
	ld a, [wUpdateSpritesEnabled]
	dec a
	ret nz
	homecall WLA_GLOBAL_UpdateSprites
	ret
