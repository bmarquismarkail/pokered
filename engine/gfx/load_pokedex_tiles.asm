; Loads tile patterns for tiles used in the pokedex.
LoadPokedexTilePatterns:
	call LoadHpBarAndStatusTilePatterns
	ld de, PokedexTileGraphics
	ld hl, vChars2 + TILE_SIZE * $60
	lb "bc", bank(PokedexTileGraphics), (PokedexTileGraphicsEnd - PokedexTileGraphics) / TILE_SIZE
	call CopyVideoData
	ld de, PokeballTileGraphics
	ld hl, vChars2 + TILE_SIZE * $72
	lb "bc", bank(PokeballTileGraphics), 1
	jp CopyVideoData ; load pokeball tile for marking caught mons
