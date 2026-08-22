PrizeDifferentMenuPtrs:
	.DW PrizeMenuMon1Entries, PrizeMenuMon1Cost
	.DW PrizeMenuMon2Entries, PrizeMenuMon2Cost
	.DW PrizeMenuTMsEntries,  PrizeMenuTMsCost

NoThanksText:
		.STRINGMAP pokemon, "NO THANKS@"

PrizeMenuMon1Entries:
	.DB ABRA
	.DB CLEFAIRY
.IF defined(_RED)
	.DB NIDORINA
.ENDIF
.IF defined(_BLUE)
	.DB NIDORINO
.ENDIF
		.STRINGMAP pokemon, "@"

PrizeMenuMon1Cost:
.IF defined(_RED)
	bcd2 180
	bcd2 500
.ENDIF
.IF defined(_BLUE)
	bcd2 120
	bcd2 750
.ENDIF
	bcd2 1200
		.STRINGMAP pokemon, "@"

PrizeMenuMon2Entries:
.IF defined(_RED)
	.DB DRATINI
	.DB SCYTHER
.ENDIF
.IF defined(_BLUE)
	.DB PINSIR
	.DB DRATINI
.ENDIF
	.DB PORYGON
		.STRINGMAP pokemon, "@"

PrizeMenuMon2Cost:
.IF defined(_RED)
	bcd2 2800
	bcd2 5500
	bcd2 9999
.ENDIF
.IF defined(_BLUE)
	bcd2 2500
	bcd2 4600
	bcd2 6500
.ENDIF
		.STRINGMAP pokemon, "@"

PrizeMenuTMsEntries:
	.DB TM_DRAGON_RAGE
	.DB TM_HYPER_BEAM
	.DB TM_SUBSTITUTE
		.STRINGMAP pokemon, "@"

PrizeMenuTMsCost:
	bcd2 3300
	bcd2 5500
	bcd2 7700
		.STRINGMAP pokemon, "@"
