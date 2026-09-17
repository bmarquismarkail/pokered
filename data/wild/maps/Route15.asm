Route15WildMons:
	def_grass_wildmons 15 ; encounter rate
.IF defined(_RED)
	.DB 24, ODDISH
	.DB 26, DITTO
	.DB 23, PIDGEY
	.DB 26, VENONAT
	.DB 22, ODDISH
	.DB 28, VENONAT
	.DB 26, ODDISH
	.DB 30, GLOOM
.ENDIF
.IF defined(_BLUE)
	.DB 24, BELLSPROUT
	.DB 26, DITTO
	.DB 23, PIDGEY
	.DB 26, VENONAT
	.DB 22, BELLSPROUT
	.DB 28, VENONAT
	.DB 26, BELLSPROUT
	.DB 30, WEEPINBELL
.ENDIF
	.DB 28, PIDGEOTTO
	.DB 30, PIDGEOTTO
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
