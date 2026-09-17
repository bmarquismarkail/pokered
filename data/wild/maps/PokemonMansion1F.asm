PokemonMansion1FWildMons:
	def_grass_wildmons 10 ; encounter rate
.IF defined(_RED)
	.DB 32, KOFFING
	.DB 30, KOFFING
	.DB 34, PONYTA
	.DB 30, PONYTA
	.DB 34, GROWLITHE
	.DB 32, PONYTA
	.DB 30, GRIMER
	.DB 28, PONYTA
	.DB 37, WEEZING
	.DB 39, MUK
.ENDIF
.IF defined(_BLUE)
	.DB 32, GRIMER
	.DB 30, GRIMER
	.DB 34, PONYTA
	.DB 30, PONYTA
	.DB 34, VULPIX
	.DB 32, PONYTA
	.DB 30, KOFFING
	.DB 28, PONYTA
	.DB 37, MUK
	.DB 39, WEEZING
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
