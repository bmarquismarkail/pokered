LoadFontTilePatterns:
	ldh a, [lobyte(rLCDC)]
	bit B_LCDC_ENABLE, a
	jr nz, LoadFontTilePatterns.on
; off
	ld hl, FontGraphics
	ld de, vFont
	ld bc, FontGraphicsEnd - FontGraphics
	ld a, bank(FontGraphics)
	jp FarCopyDataDouble ; if LCD is off, transfer all at once
LoadFontTilePatterns.on
	ld de, FontGraphics
	ld hl, vFont
	lb "bc", bank(FontGraphics), (FontGraphicsEnd - FontGraphics) / TILE_1BPP_SIZE
	jp CopyVideoDataDouble ; if LCD is on, transfer during V-blank

LoadTextBoxTilePatterns:
	ldh a, [lobyte(rLCDC)]
	bit B_LCDC_ENABLE, a
	jr nz, LoadTextBoxTilePatterns.on
; off
	ld hl, TextBoxGraphics
	ld de, vChars2 + TILE_SIZE * $60
	ld bc, TextBoxGraphicsEnd - TextBoxGraphics
	ld a, bank(TextBoxGraphics)
	jp FarCopyData2 ; if LCD is off, transfer all at once
LoadTextBoxTilePatterns.on
	ld de, TextBoxGraphics
	ld hl, vChars2 + TILE_SIZE * $60
	lb "bc", bank(TextBoxGraphics), (TextBoxGraphicsEnd - TextBoxGraphics) / TILE_SIZE
	jp CopyVideoData ; if LCD is on, transfer during V-blank

LoadHpBarAndStatusTilePatterns:
	ldh a, [lobyte(rLCDC)]
	bit B_LCDC_ENABLE, a
	jr nz, LoadHpBarAndStatusTilePatterns.on
; off
	ld hl, HpBarAndStatusGraphics
	ld de, vChars2 + TILE_SIZE * $62
	ld bc, HpBarAndStatusGraphicsEnd - HpBarAndStatusGraphics
	ld a, bank(HpBarAndStatusGraphics)
	jp FarCopyData2 ; if LCD is off, transfer all at once
LoadHpBarAndStatusTilePatterns.on
	ld de, HpBarAndStatusGraphics
	ld hl, vChars2 + TILE_SIZE * $62
	lb "bc", bank(HpBarAndStatusGraphics), (HpBarAndStatusGraphicsEnd - HpBarAndStatusGraphics) / TILE_SIZE
	jp CopyVideoData ; if LCD is on, transfer during V-blank
