_PokemartGreetingText:
WLA_GLOBAL_PokemartGreetingText:
	text "Hi there!"
	next "May I help you?"
	done

_PokemonFaintedText:
WLA_GLOBAL_PokemonFaintedText:
	text_ram wNameBuffer
	text_start
	line "fainted!"
	done

_PlayerBlackedOutText:
WLA_GLOBAL_PlayerBlackedOutText:
	text "<PLAYER> is out of"
	line "useable #MON!"

	para "<PLAYER> blacked"
	line "out!"
	prompt

_RepelWoreOffText:
WLA_GLOBAL_RepelWoreOffText:
	text "REPEL's effect"
	line "wore off."
	done

_PokemartBuyingGreetingText:
WLA_GLOBAL_PokemartBuyingGreetingText:
	text "Take your time."
	done

_PokemartTellBuyPriceText:
WLA_GLOBAL_PokemartTellBuyPriceText:
	text_ram wStringBuffer
	text "?"
	line "That will be"
	cont "¥@"
	text_bcd hMoney, 3 | LEADING_ZEROES | LEFT_ALIGN
	text ". OK?"
	done

_PokemartBoughtItemText:
WLA_GLOBAL_PokemartBoughtItemText:
	text "Here you are!"
	line "Thank you!"
	prompt

_PokemartNotEnoughMoneyText:
WLA_GLOBAL_PokemartNotEnoughMoneyText:
	text "You don't have"
	line "enough money."
	prompt

_PokemartItemBagFullText:
WLA_GLOBAL_PokemartItemBagFullText:
	text "You can't carry"
	line "any more items."
	prompt

_PokemonSellingGreetingText:
WLA_GLOBAL_PokemonSellingGreetingText:
	text "What would you"
	line "like to sell?"
	done

_PokemartTellSellPriceText:
WLA_GLOBAL_PokemartTellSellPriceText:
	text "I can pay you"
	line "¥@"
	text_bcd hMoney, 3 | LEADING_ZEROES | LEFT_ALIGN
	text " for that."
	done

_PokemartItemBagEmptyText:
WLA_GLOBAL_PokemartItemBagEmptyText:
	text "You don't have"
	line "anything to sell."
	prompt

_PokemartUnsellableItemText:
WLA_GLOBAL_PokemartUnsellableItemText:
	text "I can't put a"
	line "price on that."
	prompt

_PokemartThankYouText:
WLA_GLOBAL_PokemartThankYouText:
	text "Thank you!"
	done

_PokemartAnythingElseText:
WLA_GLOBAL_PokemartAnythingElseText:
	text "Is there anything"
	line "else I can do?"
	done

_LearnedMove1Text:
WLA_GLOBAL_LearnedMove1Text:
	text_ram wLearnMoveMonName
	text " learned"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_WhichMoveToForgetText:
WLA_GLOBAL_WhichMoveToForgetText:
	text "Which move should"
	next "be forgotten?"
	done

_AbandonLearningText:
WLA_GLOBAL_AbandonLearningText:
	text "Abandon learning"
	line "@"
	text_ram wStringBuffer
	text "?"
	done

_DidNotLearnText:
WLA_GLOBAL_DidNotLearnText:
	text_ram wLearnMoveMonName
	text_start
	line "did not learn"
	cont "@"
	text_ram wStringBuffer
	text "!"
	prompt

_TryingToLearnText:
WLA_GLOBAL_TryingToLearnText:
	text_ram wLearnMoveMonName
	text " is"
	line "trying to learn"
	cont "@"
	text_ram wStringBuffer
	text "!"

	para "But, @"
	text_ram wLearnMoveMonName
	text_start
	line "can't learn more"
	cont "than 4 moves!"

	para "Delete an older"
	line "move to make room"
	cont "for @"
	text_ram wStringBuffer
	text "?"
	done

_OneTwoAndText:
WLA_GLOBAL_OneTwoAndText:
	text "1, 2 and...@"
	text_end

_PoofText:
WLA_GLOBAL_PoofText:
	text " Poof!@"
	text_end

_ForgotAndText:
WLA_GLOBAL_ForgotAndText:
	text_start
	para "@"
	text_ram wLearnMoveMonName
	text " forgot"
	line "@"
	text_ram wNameBuffer
	text "!"

	para "And..."
	prompt

_HMCantDeleteText:
WLA_GLOBAL_HMCantDeleteText:
	text "HM techniques"
	line "can't be deleted!"
	prompt

_PokemonCenterWelcomeText:
WLA_GLOBAL_PokemonCenterWelcomeText:
	text "Welcome to our"
	line "#MON CENTER!"

	para "We heal your"
	line "#MON back to"
	cont "perfect health!"
	prompt

_ShallWeHealYourPokemonText:
WLA_GLOBAL_ShallWeHealYourPokemonText:
	text "Shall we heal your"
	line "#MON?"
	done

_NeedYourPokemonText:
WLA_GLOBAL_NeedYourPokemonText:
	text "OK. We'll need"
	line "your #MON."
	done

_PokemonFightingFitText:
WLA_GLOBAL_PokemonFightingFitText:
	text "Thank you!"
	line "Your #MON are"
	cont "fighting fit!"
	prompt

_PokemonCenterFarewellText:
WLA_GLOBAL_PokemonCenterFarewellText:
	text "We hope to see"
	line "you again!"
	done

_CableClubNPCAreaReservedFor2FriendsLinkedByCableText:
WLA_GLOBAL_CableClubNPCAreaReservedFor2FriendsLinkedByCableText:
	text "This area is"
	line "reserved for 2"
	cont "friends who are"
	cont "linked by cable."
	done

_CableClubNPCWelcomeText:
WLA_GLOBAL_CableClubNPCWelcomeText:
	text "Welcome to the"
	line "Cable Club!"
	done

_CableClubNPCPleaseApplyHereHaveToSaveText:
WLA_GLOBAL_CableClubNPCPleaseApplyHereHaveToSaveText:
	text "Please apply here."

	para "Before opening"
	line "the link, we have"
	cont "to save the game."
	done

_CableClubNPCPleaseWaitText:
WLA_GLOBAL_CableClubNPCPleaseWaitText:
	text "Please wait.@"
	text_end

_CableClubNPCLinkClosedBecauseOfInactivityText:
WLA_GLOBAL_CableClubNPCLinkClosedBecauseOfInactivityText:
	vc_patch Change_link_closed_inactivity_message
.IF defined(_RED_VC) || defined(_BLUE_VC)
	text "Please come again!"
	done
	text_start
		.STRINGMAP pokemon, "osed because of"
	cont "inactivity."
.ELSE
	text "The link has been"
	line "closed because of"
	cont "inactivity."
.ENDIF
	vc_patch_end

	para "Please contact"
	line "your friend and"
	cont "come again!"
	done
