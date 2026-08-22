SeafoamIslandsB1FWildMons:
	def_grass_wildmons 10 ; encounter rate
.IF defined(_RED)
	.DB 30, STARYU
	.DB 30, HORSEA
	.DB 32, SHELLDER
	.DB 32, HORSEA
	.DB 28, SLOWPOKE
	.DB 30, SEEL
	.DB 30, SLOWPOKE
	.DB 28, SEEL
	.DB 38, DEWGONG
	.DB 37, SEADRA
.ENDIF
.IF defined(_BLUE)
	.DB 30, SHELLDER
	.DB 30, KRABBY
	.DB 32, STARYU
	.DB 32, KRABBY
	.DB 28, PSYDUCK
	.DB 30, SEEL
	.DB 30, PSYDUCK
	.DB 28, SEEL
	.DB 38, DEWGONG
	.DB 37, KINGLER
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
