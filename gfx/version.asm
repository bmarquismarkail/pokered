Version_GFX:
.IF defined(_RED)
	.INCBIN "gfx/title/red_version.1bpp" ; 10 tiles
.ENDIF
.IF defined(_BLUE)
	.INCBIN "gfx/title/blue_version.1bpp" ; 8 tiles
.ENDIF
Version_GFXEnd:
