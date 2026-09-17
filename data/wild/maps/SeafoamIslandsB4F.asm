SeafoamIslandsB4FWildMons:
	def_grass_wildmons 10 ; encounter rate
.IF defined(_RED)
	.DB 31, HORSEA
	.DB 31, SHELLDER
	.DB 33, HORSEA
	.DB 33, SHELLDER
	.DB 29, SLOWPOKE
	.DB 31, SEEL
	.DB 31, SLOWPOKE
	.DB 29, SEEL
	.DB 39, SLOWBRO
.ENDIF
.IF defined(_BLUE)
	.DB 31, KRABBY
	.DB 31, STARYU
	.DB 33, KRABBY
	.DB 33, STARYU
	.DB 29, PSYDUCK
	.DB 31, SEEL
	.DB 31, PSYDUCK
	.DB 29, SEEL
	.DB 39, GOLDUCK
.ENDIF
	.DB 32, GOLBAT
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
