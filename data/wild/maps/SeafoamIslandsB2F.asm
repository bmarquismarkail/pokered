SeafoamIslandsB2FWildMons:
	def_grass_wildmons 10 ; encounter rate
	.DB 30, SEEL
.IF defined(_RED)
	.DB 30, SLOWPOKE
	.DB 32, SEEL
	.DB 32, SLOWPOKE
	.DB 28, HORSEA
	.DB 30, STARYU
	.DB 30, HORSEA
	.DB 28, SHELLDER
	.DB 30, GOLBAT
	.DB 37, SLOWBRO
.ENDIF
.IF defined(_BLUE)
	.DB 30, PSYDUCK
	.DB 32, SEEL
	.DB 32, PSYDUCK
	.DB 28, KRABBY
	.DB 30, SHELLDER
	.DB 30, KRABBY
	.DB 28, STARYU
	.DB 30, GOLBAT
	.DB 37, GOLDUCK
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
