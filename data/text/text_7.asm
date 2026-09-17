_ItemUseText001:
WLA_GLOBAL_ItemUseText001:
	text "<PLAYER> used@"
	text_end

_ItemUseText002:
WLA_GLOBAL_ItemUseText002:
	text_ram wStringBuffer
	text "!"
	done

_GotOnBicycleText1:
WLA_GLOBAL_GotOnBicycleText1:
	text "<PLAYER> got on the@"
	text_end

_GotOnBicycleText2:
WLA_GLOBAL_GotOnBicycleText2:
	text_ram wStringBuffer
	text "!"
	prompt

_GotOffBicycleText1:
WLA_GLOBAL_GotOffBicycleText1:
	text "<PLAYER> got off@"
	text_end

_GotOffBicycleText2:
WLA_GLOBAL_GotOffBicycleText2:
	text "the @"
	text_ram wStringBuffer
	text "."
	prompt

_ThrewAwayItemText:
WLA_GLOBAL_ThrewAwayItemText:
	text "Threw away"
	line "@"
	text_ram wNameBuffer
	text "."
	prompt

_IsItOKToTossItemText:
WLA_GLOBAL_IsItOKToTossItemText:
	text "Is it OK to toss"
	line "@"
	text_ram wStringBuffer
	text "?"
	prompt

_TooImportantToTossText:
WLA_GLOBAL_TooImportantToTossText:
	text "That's too impor-"
	line "tant to toss!"
	prompt

_AlreadyKnowsText:
WLA_GLOBAL_AlreadyKnowsText:
	text_ram wNameBuffer
	text " knows"
	line "@"
	text_ram wStringBuffer
	text "!"
	prompt

_ConnectCableText:
WLA_GLOBAL_ConnectCableText:
	text "Okay, connect the"
	line "cable like so!"
	prompt

_TradedForText:
WLA_GLOBAL_TradedForText:
	text "<PLAYER> traded"
	line "@"
	text_ram wInGameTradeGiveMonName
	text " for"
	cont "@"
	text_ram wInGameTradeReceiveMonName
	text "!@"
	text_end

_WannaTrade1Text:
WLA_GLOBAL_WannaTrade1Text:
	text "I'm looking for"
	line "@"
	text_ram wInGameTradeGiveMonName
	text "! Wanna"

	para "trade one for"
	line "@"
	text_ram wInGameTradeReceiveMonName
	text "? "
	done

_NoTrade1Text:
WLA_GLOBAL_NoTrade1Text:
	text "Awww!"
	line "Oh well..."
	done

_WrongMon1Text:
WLA_GLOBAL_WrongMon1Text:
	text "What? That's not"
	line "@"
	text_ram wInGameTradeGiveMonName
	text "!"

	para "If you get one,"
	line "come back here!"
	done

_Thanks1Text:
WLA_GLOBAL_Thanks1Text:
	text "Hey thanks!"
	done

_AfterTrade1Text:
WLA_GLOBAL_AfterTrade1Text:
	text "Isn't my old"
	line "@"
	text_ram wInGameTradeReceiveMonName
	text " great?"
	done

_WannaTrade2Text:
WLA_GLOBAL_WannaTrade2Text:
	text "Hello there! Do"
	line "you want to trade"

	para "your @"
	text_ram wInGameTradeGiveMonName
	text_start
	line "for @"
	text_ram wInGameTradeReceiveMonName
	text "?"
	done

_NoTrade2Text:
WLA_GLOBAL_NoTrade2Text:
	text "Well, if you"
	line "don't want to..."
	done

_WrongMon2Text:
WLA_GLOBAL_WrongMon2Text:
	text "Hmmm? This isn't"
	line "@"
	text_ram wInGameTradeGiveMonName
	text "."

	para "Think of me when"
	line "you get one."
	done

_Thanks2Text:
WLA_GLOBAL_Thanks2Text:
	text "Thanks!"
	done

_AfterTrade2Text:
WLA_GLOBAL_AfterTrade2Text:
	text "The @"
	text_ram wInGameTradeGiveMonName
	text " you"
	line "traded to me"

	para "went and evolved!"
	done

_WannaTrade3Text:
WLA_GLOBAL_WannaTrade3Text:
	text "Hi! Do you have"
	line "@"
	text_ram wInGameTradeGiveMonName
	text "?"

	para "Want to trade it"
	line "for @"
	text_ram wInGameTradeReceiveMonName
	text "?"
	done

_NoTrade3Text:
WLA_GLOBAL_NoTrade3Text:
	text "That's too bad."
	done

_WrongMon3Text:
WLA_GLOBAL_WrongMon3Text:
	text "...This is no"
	line "@"
	text_ram wInGameTradeGiveMonName
	text "."

	para "If you get one,"
	line "trade it with me!"
	done

_Thanks3Text:
WLA_GLOBAL_Thanks3Text:
	text "Thanks pal!"
	done

_AfterTrade3Text:
WLA_GLOBAL_AfterTrade3Text:
	text "How is my old"
	line "@"
	text_ram wInGameTradeReceiveMonName
	text "?"

	para "My @"
	text_ram wInGameTradeGiveMonName
	text " is"
	line "doing great!"
	done

_NothingToCutText:
WLA_GLOBAL_NothingToCutText:
	text "There isn't"
	line "anything to CUT!"
	prompt

_UsedCutText:
WLA_GLOBAL_UsedCutText:
	text_ram wNameBuffer
	text " hacked"
	line "away with CUT!"
	prompt
