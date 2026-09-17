PokemonMansion2FWildMons:
	def_grass_wildmons 10 ; encounter rate
.IF defined(_RED)
	.DB 32, GROWLITHE
	.DB 34, KOFFING
	.DB 34, KOFFING
	.DB 30, PONYTA
	.DB 30, KOFFING
	.DB 32, PONYTA
	.DB 30, GRIMER
	.DB 28, PONYTA
	.DB 39, WEEZING
	.DB 37, MUK
.ENDIF
.IF defined(_BLUE)
	.DB 32, VULPIX
	.DB 34, GRIMER
	.DB 34, GRIMER
	.DB 30, PONYTA
	.DB 30, GRIMER
	.DB 32, PONYTA
	.DB 30, KOFFING
	.DB 28, PONYTA
	.DB 39, MUK
	.DB 37, WEEZING
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
