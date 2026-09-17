.RAMSECTION "VRAM" BANK 0 SLOT 2

.UNION
; generic
vChars0: ds $80 * TILE_SIZE
vChars1: ds $80 * TILE_SIZE
vChars2: ds $80 * TILE_SIZE
vBGMap0: ds TILEMAP_AREA
vBGMap1: ds TILEMAP_AREA

.NEXTU
; battle/menu
vSprites:  ds $80 * TILE_SIZE
vFont:     ds $80 * TILE_SIZE
vFrontPic: ds PIC_SIZE * TILE_SIZE
vBackPic:  ds PIC_SIZE * TILE_SIZE

.NEXTU
; overworld
vNPCSprites:  ds $80 * TILE_SIZE
vNPCSprites2: ds $80 * TILE_SIZE
vTileset:     ds $80 * TILE_SIZE

.NEXTU
; title
	__wla_vram_padding_000: ds $80 * TILE_SIZE
vTitleLogo:  ds $80 * TILE_SIZE
	__wla_vram_padding_001: ds PIC_SIZE * TILE_SIZE
vTitleLogo2: ds 30 * TILE_SIZE

.ENDU
.ENDS
