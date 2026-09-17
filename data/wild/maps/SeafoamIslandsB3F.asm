SeafoamIslandsB3FWildMons:
	def_grass_wildmons 10 ; encounter rate
.IF defined(_RED)
	.DB 31, SLOWPOKE
	.DB 31, SEEL
	.DB 33, SLOWPOKE
	.DB 33, SEEL
	.DB 29, HORSEA
	.DB 31, SHELLDER
	.DB 31, HORSEA
	.DB 29, SHELLDER
	.DB 39, SEADRA
.ENDIF
.IF defined(_BLUE)
	.DB 31, PSYDUCK
	.DB 31, SEEL
	.DB 33, PSYDUCK
	.DB 33, SEEL
	.DB 29, KRABBY
	.DB 31, STARYU
	.DB 31, KRABBY
	.DB 29, STARYU
	.DB 39, KINGLER
.ENDIF
	.DB 37, DEWGONG
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
