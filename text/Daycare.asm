_DaycareGentlemanIntroText:
WLA_GLOBAL_DaycareGentlemanIntroText:
	text "I run a DAYCARE."
	line "Would you like me"
	cont "to raise one of"
	cont "your #MON?"
	done

_DaycareGentlemanWhichMonText:
WLA_GLOBAL_DaycareGentlemanWhichMonText:
	text "Which #MON"
	line "should I raise?"
	prompt

_DaycareGentlemanWillLookAfterMonText:
WLA_GLOBAL_DaycareGentlemanWillLookAfterMonText:
	text "Fine, I'll look"
	line "after @"
	text_ram wNameBuffer
	text_start
	cont "for a while."
	prompt

_DaycareGentlemanComeSeeMeInAWhileText:
WLA_GLOBAL_DaycareGentlemanComeSeeMeInAWhileText:
	text "Come see me in"
	line "a while."
	done

_DaycareGentlemanMonHasGrownText:
WLA_GLOBAL_DaycareGentlemanMonHasGrownText:
	text "Your @"
	text_ram wNameBuffer
	text_start
	line "has grown a lot!"

	para "By level, it's"
	line "grown by @"
	text_decimal wDayCareNumLevelsGrown, 1, 3
	text "!"

	para "Aren't I great?"
	prompt

_DaycareGentlemanOweMoneyText:
WLA_GLOBAL_DaycareGentlemanOweMoneyText:
	text "You owe me ¥@"
	text_bcd wDayCareTotalCost, 2 | LEADING_ZEROES | LEFT_ALIGN
	text_start
	line "for the return"
	cont "of this #MON."
	done

_DaycareGentlemanGotMonBackText:
WLA_GLOBAL_DaycareGentlemanGotMonBackText:
	text "<PLAYER> got"
	line "@"
	text_ram wDayCareMonName
	text " back!"
	done

_DaycareGentlemanMonNeedsMoreTimeText:
WLA_GLOBAL_DaycareGentlemanMonNeedsMoreTimeText:
	text "Back already?"
	line "Your @"
	text_ram wNameBuffer
	text_start
	cont "needs some more"
	cont "time with me."
	prompt
