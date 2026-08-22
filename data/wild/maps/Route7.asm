Route7WildMons:
	def_grass_wildmons 15 ; encounter rate
	.DB 19, PIDGEY
.IF defined(_RED)
	.DB 19, ODDISH
	.DB 17, MANKEY
	.DB 22, ODDISH
	.DB 22, PIDGEY
	.DB 18, MANKEY
	.DB 18, GROWLITHE
	.DB 20, GROWLITHE
	.DB 19, MANKEY
	.DB 20, MANKEY
.ENDIF
.IF defined(_BLUE)
	.DB 19, BELLSPROUT
	.DB 17, MEOWTH
	.DB 22, BELLSPROUT
	.DB 22, PIDGEY
	.DB 18, MEOWTH
	.DB 18, VULPIX
	.DB 20, VULPIX
	.DB 19, MEOWTH
	.DB 20, MEOWTH
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
