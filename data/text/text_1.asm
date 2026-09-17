_CardKeySuccessText1:
WLA_GLOBAL_CardKeySuccessText1:
	text "Bingo!@"
	text_end

_CardKeySuccessText2:
WLA_GLOBAL_CardKeySuccessText2:
	text_start
	line "The CARD KEY"
	cont "opened the door!"
	done

_CardKeyFailText:
WLA_GLOBAL_CardKeyFailText:
	text "Darn! It needs a"
	line "CARD KEY!"
	done

_TrainerNameText:
WLA_GLOBAL_TrainerNameText:
	text_ram wNameBuffer
	text ": @"
	text_end

_NoNibbleText:
WLA_GLOBAL_NoNibbleText:
	text "Not even a nibble!"
	prompt

_NothingHereText:
WLA_GLOBAL_NothingHereText:
	text "Looks like there's"
	line "nothing here."
	prompt

_ItsABiteText:
WLA_GLOBAL_ItsABiteText:
	text "Oh!"
	line "It's a bite!"
	prompt

_ExclamationText:
WLA_GLOBAL_ExclamationText:
	text "!"
	done

_GroundRoseText:
WLA_GLOBAL_GroundRoseText:
	text "Ground rose up"
	line "somewhere!"
	done

_BoulderText:
WLA_GLOBAL_BoulderText:
	text "This requires"
	line "STRENGTH to move!"
	done

_MartSignText:
WLA_GLOBAL_MartSignText:
	text "All your item"
	line "needs fulfilled!"
	cont "#MON MART"
	done

_PokeCenterSignText:
WLA_GLOBAL_PokeCenterSignText:
	text "Heal Your #MON!"
	line "#MON CENTER"
	done

_FoundItemText:
WLA_GLOBAL_FoundItemText:
	text "<PLAYER> found"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_NoMoreRoomForItemText:
WLA_GLOBAL_NoMoreRoomForItemText:
	text "No more room for"
	line "items!"
	done

_OaksAideHiText:
WLA_GLOBAL_OaksAideHiText:
	text "Hi! Remember me?"
	line "I'm PROF.OAK's"
	cont "AIDE!"

	para "If you caught @"
	text_decimal hOaksAideRequirement, 1, 3
	text_start
	line "kinds of #MON,"
	cont "I'm supposed to"
	cont "give you an"
	cont "@"
	text_ram wOaksAideRewardItemName
	text "!"

	para "So, <PLAYER>! Have"
	line "you caught at"
	cont "least @"
	text_decimal hOaksAideRequirement, 1, 3
	text " kinds of"
	cont "#MON?"
	done

_OaksAideUhOhText:
WLA_GLOBAL_OaksAideUhOhText:
	text "Let's see..."
	line "Uh-oh! You have"
	cont "caught only @"
	text_decimal hOaksAideNumMonsOwned, 1, 3
	text_start
	cont "kinds of #MON!"

	para "You need @"
	text_decimal hOaksAideRequirement, 1, 3
	text " kinds"
	line "if you want the"
	cont "@"
	text_ram wOaksAideRewardItemName
	text "."
	done

_OaksAideComeBackText:
WLA_GLOBAL_OaksAideComeBackText:
	text "Oh. I see."

	para "When you get @"
	text_decimal hOaksAideRequirement, 1, 3
	text_start
	line "kinds, come back"
	cont "for @"
	text_ram wOaksAideRewardItemName
	text "."
	done

_OaksAideHereYouGoText:
WLA_GLOBAL_OaksAideHereYouGoText:
	text "Great! You have"
	line "caught @"
	text_decimal hOaksAideNumMonsOwned, 1, 3
	text " kinds "
	cont "of #MON!"
	cont "Congratulations!"

	para "Here you go!"
	prompt

_OaksAideGotItemText:
WLA_GLOBAL_OaksAideGotItemText:
	text "<PLAYER> got the"
	line "@"
	text_ram wOaksAideRewardItemName
	text "!@"
	text_end

_OaksAideNoRoomText:
WLA_GLOBAL_OaksAideNoRoomText:
	text "Oh! I see you"
	line "don't have any"
	cont "room for the"
	cont "@"
	text_ram wOaksAideRewardItemName
	text "."
	done
