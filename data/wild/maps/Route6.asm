Route6WildMons:
	def_grass_wildmons 15 ; encounter rate
.IF defined(_RED)
	.DB 13, ODDISH
	.DB 13, PIDGEY
	.DB 15, PIDGEY
	.DB 10, MANKEY
	.DB 12, MANKEY
	.DB 15, ODDISH
	.DB 16, ODDISH
	.DB 16, PIDGEY
	.DB 14, MANKEY
	.DB 16, MANKEY
.ENDIF
.IF defined(_BLUE)
	.DB 13, BELLSPROUT
	.DB 13, PIDGEY
	.DB 15, PIDGEY
	.DB 10, MEOWTH
	.DB 12, MEOWTH
	.DB 15, BELLSPROUT
	.DB 16, BELLSPROUT
	.DB 16, PIDGEY
	.DB 14, MEOWTH
	.DB 16, MEOWTH
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
