Route13WildMons:
	def_grass_wildmons 20 ; encounter rate
.IF defined(_RED)
	.DB 24, ODDISH
	.DB 25, PIDGEY
	.DB 27, PIDGEY
	.DB 24, VENONAT
	.DB 22, ODDISH
	.DB 26, VENONAT
	.DB 26, ODDISH
	.DB 25, DITTO
	.DB 28, GLOOM
	.DB 30, GLOOM
.ENDIF
.IF defined(_BLUE)
	.DB 24, BELLSPROUT
	.DB 25, PIDGEY
	.DB 27, PIDGEY
	.DB 24, VENONAT
	.DB 22, BELLSPROUT
	.DB 26, VENONAT
	.DB 26, BELLSPROUT
	.DB 25, DITTO
	.DB 28, WEEPINBELL
	.DB 30, WEEPINBELL
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
