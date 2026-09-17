_ItemUseBallText00:
WLA_GLOBAL_ItemUseBallText00:
	text "It dodged the"
	line "thrown BALL!"

	para "This #MON"
	line "can't be caught!"
	prompt

_ItemUseBallText01:
WLA_GLOBAL_ItemUseBallText01:
	text "You missed the"
	line "#MON!"
	prompt

_ItemUseBallText02:
WLA_GLOBAL_ItemUseBallText02:
	text "Darn! The #MON"
	line "broke free!"
	prompt

_ItemUseBallText03:
WLA_GLOBAL_ItemUseBallText03:
	text "Aww! It appeared"
	line "to be caught! "
	prompt

_ItemUseBallText04:
WLA_GLOBAL_ItemUseBallText04:
	text "Shoot! It was so"
	line "close too!"
	prompt

_ItemUseBallText05:
WLA_GLOBAL_ItemUseBallText05:
	text "All right!"
	line "@"
	text_ram wEnemyMonNick
	text " was"
	cont "caught!@"
	text_end

_ItemUseBallText07:
WLA_GLOBAL_ItemUseBallText07:
	text_ram wBoxMonNicks
	text " was"
	line "transferred to"
	cont "BILL's PC!"
	prompt

_ItemUseBallText08:
WLA_GLOBAL_ItemUseBallText08:
	text_ram wBoxMonNicks
	text " was"
	line "transferred to"
	cont "someone's PC!"
	prompt

_ItemUseBallText06:
WLA_GLOBAL_ItemUseBallText06:
	text "New #DEX data"
	line "will be added for"
	cont "@"
	text_ram wEnemyMonNick
	text "!@"
	text_end

_SurfingGotOnText:
WLA_GLOBAL_SurfingGotOnText:
	text "<PLAYER> got on"
	line "@"
	text_ram wNameBuffer
	text "!"
	prompt

_SurfingNoPlaceToGetOffText:
WLA_GLOBAL_SurfingNoPlaceToGetOffText:
	text "There's no place"
	line "to get off!"
	prompt

_VitaminStatRoseText:
WLA_GLOBAL_VitaminStatRoseText:
	text_ram wNameBuffer
	text "'s"
	line "@"
	text_ram wStringBuffer
	text " rose."
	prompt

_VitaminNoEffectText:
WLA_GLOBAL_VitaminNoEffectText:
	text "It won't have any"
	line "effect."
	prompt

_ThrewBaitText:
WLA_GLOBAL_ThrewBaitText:
	text "<PLAYER> threw"
	line "some BAIT."
	done

_ThrewRockText:
WLA_GLOBAL_ThrewRockText:
	text "<PLAYER> threw a"
	line "ROCK."
	done

_PlayedFluteNoEffectText:
WLA_GLOBAL_PlayedFluteNoEffectText:
	text "Played the #"
	line "FLUTE."

	para "Now, that's a"
	line "catchy tune!"
	prompt

_FluteWokeUpText:
WLA_GLOBAL_FluteWokeUpText:
	text "All sleeping"
	line "#MON woke up."
	prompt

_PlayedFluteHadEffectText:
WLA_GLOBAL_PlayedFluteHadEffectText:
	text "<PLAYER> played the"
	line "# FLUTE.@"
	text_end

_CoinCaseNumCoinsText:
WLA_GLOBAL_CoinCaseNumCoinsText:
	text "Coins"
	line "@"
	text_bcd wPlayerCoins, 2 | LEADING_ZEROES | LEFT_ALIGN
	text " "
	prompt

_ItemfinderFoundItemText:
WLA_GLOBAL_ItemfinderFoundItemText:
	text "Yes! ITEMFINDER"
	line "indicates there's"
	cont "an item nearby."
	prompt

_ItemfinderFoundNothingText:
WLA_GLOBAL_ItemfinderFoundNothingText:
	text "Nope! ITEMFINDER"
	line "isn't responding."
	prompt

_RaisePPWhichTechniqueText:
WLA_GLOBAL_RaisePPWhichTechniqueText:
	text "Raise PP of which"
	line "technique?"
	done

_RestorePPWhichTechniqueText:
WLA_GLOBAL_RestorePPWhichTechniqueText:
	text "Restore PP of"
	line "which technique?"
	done

_PPMaxedOutText:
WLA_GLOBAL_PPMaxedOutText:
	text_ram wStringBuffer
	text "'s PP"
	line "is maxed out."
	prompt

_PPIncreasedText:
WLA_GLOBAL_PPIncreasedText:
	text_ram wStringBuffer
	text "'s PP"
	line "increased."
	prompt

_PPRestoredText:
WLA_GLOBAL_PPRestoredText:
	text "PP was restored."
	prompt

_BootedUpTMText:
WLA_GLOBAL_BootedUpTMText:
	text "Booted up a TM!"
	prompt

_BootedUpHMText:
WLA_GLOBAL_BootedUpHMText:
	text "Booted up an HM!"
	prompt

_TeachMachineMoveText:
WLA_GLOBAL_TeachMachineMoveText:
	text "It contained"
	line "@"
	text_ram wStringBuffer
	text "!"

	para "Teach @"
	text_ram wStringBuffer
	text_start
	line "to a #MON?"
	done

_MonCannotLearnMachineMoveText:
WLA_GLOBAL_MonCannotLearnMachineMoveText:
	text_ram wNameBuffer
	text " is not"
	line "compatible with"
	cont "@"
	text_ram wStringBuffer
	text "."

	para "It can't learn"
	line "@"
	text_ram wStringBuffer
	text "."
	prompt

_ItemUseNotTimeText:
WLA_GLOBAL_ItemUseNotTimeText:
	text "OAK: <PLAYER>!"
	line "This isn't the"
	cont "time to use that! "
	prompt

_ItemUseNotYoursToUseText:
WLA_GLOBAL_ItemUseNotYoursToUseText:
	text "This isn't yours"
	line "to use!"
	prompt

_ItemUseNoEffectText:
WLA_GLOBAL_ItemUseNoEffectText:
	text "It won't have any"
	line "effect."
	prompt

_ThrowBallAtTrainerMonText1:
WLA_GLOBAL_ThrowBallAtTrainerMonText1:
	text "The trainer"
	line "blocked the BALL!"
	prompt

_ThrowBallAtTrainerMonText2:
WLA_GLOBAL_ThrowBallAtTrainerMonText2:
	text "Don't be a thief!"
	prompt

_NoCyclingAllowedHereText:
WLA_GLOBAL_NoCyclingAllowedHereText:
	text "No cycling"
	next "allowed here."
	prompt

_NoSurfingHereText:
WLA_GLOBAL_NoSurfingHereText:
	text "No SURFing on"
	line "@"
	text_ram wNameBuffer
	text " here!"
	prompt

_BoxFullCannotThrowBallText:
WLA_GLOBAL_BoxFullCannotThrowBallText:
	text "The #MON BOX"
	line "is full! Can't"
	cont "use that item!"
	prompt
