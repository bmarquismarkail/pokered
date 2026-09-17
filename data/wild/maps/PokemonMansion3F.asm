PokemonMansion3FWildMons:
	def_grass_wildmons 10 ; encounter rate
.IF defined(_RED)
	.DB 31, KOFFING
	.DB 33, GROWLITHE
	.DB 35, KOFFING
	.DB 32, PONYTA
	.DB 34, PONYTA
	.DB 40, WEEZING
	.DB 34, GRIMER
	.DB 38, WEEZING
	.DB 36, PONYTA
	.DB 42, MUK
.ENDIF
.IF defined(_BLUE)
	.DB 31, GRIMER
	.DB 33, VULPIX
	.DB 35, GRIMER
	.DB 32, PONYTA
	.DB 34, MAGMAR
	.DB 40, MUK
	.DB 34, KOFFING
	.DB 38, MUK
	.DB 36, PONYTA
	.DB 42, WEEZING
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
