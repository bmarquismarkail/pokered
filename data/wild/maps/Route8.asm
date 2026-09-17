Route8WildMons:
	def_grass_wildmons 15 ; encounter rate
	.DB 18, PIDGEY
.IF defined(_RED)
	.DB 18, MANKEY
	.DB 17, EKANS
	.DB 16, GROWLITHE
	.DB 20, PIDGEY
	.DB 20, MANKEY
	.DB 19, EKANS
	.DB 17, GROWLITHE
	.DB 15, GROWLITHE
	.DB 18, GROWLITHE
.ENDIF
.IF defined(_BLUE)
	.DB 18, MEOWTH
	.DB 17, SANDSHREW
	.DB 16, VULPIX
	.DB 20, PIDGEY
	.DB 20, MEOWTH
	.DB 19, SANDSHREW
	.DB 17, VULPIX
	.DB 15, VULPIX
	.DB 18, VULPIX
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
