PokemonMansionB1FWildMons:
	def_grass_wildmons 10 ; encounter rate
.IF defined(_RED)
	.DB 33, KOFFING
	.DB 31, KOFFING
	.DB 35, GROWLITHE
	.DB 32, PONYTA
	.DB 31, KOFFING
	.DB 40, WEEZING
	.DB 34, PONYTA
	.DB 35, GRIMER
	.DB 42, WEEZING
	.DB 42, MUK
.ENDIF
.IF defined(_BLUE)
	.DB 33, GRIMER
	.DB 31, GRIMER
	.DB 35, VULPIX
	.DB 32, PONYTA
	.DB 31, GRIMER
	.DB 40, MUK
	.DB 34, PONYTA
	.DB 35, KOFFING
	.DB 38, MAGMAR
	.DB 42, WEEZING
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
