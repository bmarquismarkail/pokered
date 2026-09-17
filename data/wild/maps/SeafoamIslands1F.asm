SeafoamIslands1FWildMons:
	def_grass_wildmons 15 ; encounter rate
	.DB 30, SEEL
.IF defined(_RED)
	.DB 30, SLOWPOKE
	.DB 30, SHELLDER
	.DB 30, HORSEA
	.DB 28, HORSEA
	.DB 21, ZUBAT
	.DB 29, GOLBAT
	.DB 28, PSYDUCK
	.DB 28, SHELLDER
	.DB 38, GOLDUCK
.ENDIF
.IF defined(_BLUE)
	.DB 30, PSYDUCK
	.DB 30, STARYU
	.DB 30, KRABBY
	.DB 28, KRABBY
	.DB 21, ZUBAT
	.DB 29, GOLBAT
	.DB 28, SLOWPOKE
	.DB 28, STARYU
	.DB 38, SLOWBRO
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
