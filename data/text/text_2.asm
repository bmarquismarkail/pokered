_AIBattleWithdrawText:
WLA_GLOBAL_AIBattleWithdrawText:
	text_ram wTrainerName
	text " with-"
	line "drew @"
	text_ram wEnemyMonNick
	text "!"
	prompt

_AIBattleUseItemText:
WLA_GLOBAL_AIBattleUseItemText:
	text_ram wTrainerName
	text_start
	line "used @"
	text_ram wNameBuffer
	text_start
	cont "on @"
	text_ram wEnemyMonNick
	text "!"
	prompt

_TradeWentToText:
WLA_GLOBAL_TradeWentToText:
	text_ram wStringBuffer
	text " went"
	line "to @"
	text_ram wLinkEnemyTrainerName
	text "."
	done

_TradeForText:
WLA_GLOBAL_TradeForText:
	text "For <PLAYER>'s"
	line "@"
	text_ram wStringBuffer
	text ","
	done

_TradeSendsText:
WLA_GLOBAL_TradeSendsText:
	text_ram wLinkEnemyTrainerName
	text " sends"
	line "@"
	text_ram wNameBuffer
	text "."
	done

_TradeWavesFarewellText:
WLA_GLOBAL_TradeWavesFarewellText:
	text_ram wLinkEnemyTrainerName
	text " waves"
	line "farewell as"
	done

_TradeTransferredText:
WLA_GLOBAL_TradeTransferredText:
	text_ram wNameBuffer
	text " is"
	line "transferred."
	done

_TradeTakeCareText:
WLA_GLOBAL_TradeTakeCareText:
	text "Take good care of"
	line "@"
	text_ram wNameBuffer
	text "."
	done

_TradeWillTradeText:
WLA_GLOBAL_TradeWillTradeText:
	text_ram wLinkEnemyTrainerName
	text " will"
	line "trade @"
	text_ram wNameBuffer
	text_start
	done

_TradeforText:
WLA_GLOBAL_TradeforText:
	text "for <PLAYER>'s"
	line "@"
	text_ram wStringBuffer
	text "."
	done

_PlaySlotMachineText:
WLA_GLOBAL_PlaySlotMachineText:
	text "A slot machine!"
	line "Want to play?"
	done

_OutOfCoinsSlotMachineText:
WLA_GLOBAL_OutOfCoinsSlotMachineText:
	text "Darn!"
	line "Ran out of coins!"
	done

_BetHowManySlotMachineText:
WLA_GLOBAL_BetHowManySlotMachineText:
	text "Bet how many"
	line "coins?"
	done

_StartSlotMachineText:
WLA_GLOBAL_StartSlotMachineText:
	text "Start!"
	done

_NotEnoughCoinsSlotMachineText:
WLA_GLOBAL_NotEnoughCoinsSlotMachineText:
	text "Not enough"
	line "coins!"
	prompt

_OneMoreGoSlotMachineText:
WLA_GLOBAL_OneMoreGoSlotMachineText:
	text "One more "
	line "go?"
	done

_LinedUpText:
WLA_GLOBAL_LinedUpText:
	text " lined up!"
	line "Scored @"
	text_ram wStringBuffer
	text " coins!"
	done

_NotThisTimeText:
WLA_GLOBAL_NotThisTimeText:
	text "Not this time!"
	prompt

_YeahText:
WLA_GLOBAL_YeahText:
	text "Yeah!@"
	text_end

_DexSeenOwnedText:
WLA_GLOBAL_DexSeenOwnedText:
	text "#DEX   Seen:@"
	text_decimal wDexRatingNumMonsSeen, 1, 3
	text_start
	line "         Owned:@"
	text_decimal wDexRatingNumMonsOwned, 1, 3
	text_end

_DexRatingText:
WLA_GLOBAL_DexRatingText:
	text "#DEX Rating<COLON>"
	done

_GymStatueText1:
WLA_GLOBAL_GymStatueText1:
	text_ram wGymCityName
	text_start
	line "#MON GYM"
	cont "LEADER: @"
	text_ram wGymLeaderName
	text_start

	para "WINNING TRAINERS:"
	line "<RIVAL>"
	done

_GymStatueText2:
WLA_GLOBAL_GymStatueText2:
	text_ram wGymCityName
	text_start
	line "#MON GYM"
	cont "LEADER: @"
	text_ram wGymLeaderName
	text_start

	para "WINNING TRAINERS:"
	line "<RIVAL>"
	cont "<PLAYER>"
	done

_ViridianCityPokecenterGuyText:
WLA_GLOBAL_ViridianCityPokecenterGuyText:
	text "#MON CENTERs"
	line "heal your tired,"
	cont "hurt or fainted"
	cont "#MON!"
	done

_PewterCityPokecenterGuyText:
WLA_GLOBAL_PewterCityPokecenterGuyText:
	text "Yawn!"

	para "When JIGGLYPUFF"
	line "sings, #MON"
	cont "get drowsy..."

	para "...Me too..."
	line "Snore..."
	done

_CeruleanPokecenterGuyText:
WLA_GLOBAL_CeruleanPokecenterGuyText:
	text "BILL has lots of"
	line "#MON!"

	para "He collects rare"
	line "ones too!"
	done

_LavenderPokecenterGuyText:
WLA_GLOBAL_LavenderPokecenterGuyText:
	text "CUBONEs wear"
	line "skulls, right?"

	para "People will pay a"
	line "lot for one!"
	done

_MtMoonPokecenterBenchGuyText:
WLA_GLOBAL_MtMoonPokecenterBenchGuyText:
	text "If you have too"
	line "many #MON, you"
	cont "should store them"
	cont "via PC!"
	done

_RockTunnelPokecenterGuyText:
WLA_GLOBAL_RockTunnelPokecenterGuyText:
	text "I heard that"
	line "GHOSTs haunt"
	cont "LAVENDER TOWN!"
	done

_UnusedBenchGuyText1:
WLA_GLOBAL_UnusedBenchGuyText1:
	text "I wish I could"
	line "catch #MON."
	done

_UnusedBenchGuyText2:
WLA_GLOBAL_UnusedBenchGuyText2:
	text "I'm tired from"
	line "all the fun..."
	done

_UnusedBenchGuyText3:
WLA_GLOBAL_UnusedBenchGuyText3:
	text "SILPH's manager"
	line "is hiding in the"
	cont "SAFARI ZONE."
	done

_VermilionPokecenterGuyText:
WLA_GLOBAL_VermilionPokecenterGuyText:
	text "It is true that a"
	line "higher level"
	cont "#MON will be"
	cont "more powerful..."

	para "But, all #MON"
	line "will have weak"
	cont "points against"
	cont "specific types."

	para "So, there is no"
	line "universally"
	cont "strong #MON."
	done

_CeladonCityPokecenterGuyText:
WLA_GLOBAL_CeladonCityPokecenterGuyText:
	text "If I had a BIKE,"
	line "I would go to"
	cont "CYCLING ROAD!"
	done

_FuchsiaCityPokecenterGuyText:
WLA_GLOBAL_FuchsiaCityPokecenterGuyText:
	text "If you're studying "
	line "#MON, visit"
	cont "the SAFARI ZONE."

	para "It has all sorts"
	line "of rare #MON."
	done

_CinnabarPokecenterGuyText:
WLA_GLOBAL_CinnabarPokecenterGuyText:
	text "#MON can still"
	line "learn techniques"
	cont "after canceling"
	cont "evolution."

	para "Evolution can wait"
	line "until new moves"
	cont "have been learned."
	done

_SaffronCityPokecenterGuyText1:
WLA_GLOBAL_SaffronCityPokecenterGuyText1:
	text "It would be great"
	line "if the ELITE FOUR"
	cont "came and stomped"
	cont "TEAM ROCKET!"
	done

_SaffronCityPokecenterGuyText2:
WLA_GLOBAL_SaffronCityPokecenterGuyText2:
	text "TEAM ROCKET took"
	line "off! We can go"
	cont "out safely again!"
	cont "That's great!"
	done

_CeladonCityHotelText:
WLA_GLOBAL_CeladonCityHotelText:
	text "My sis brought me"
	line "on this vacation!"
	done

_BookcaseText:
WLA_GLOBAL_BookcaseText:
	text "Crammed full of"
	line "#MON books!"
	done

_NewBicycleText:
WLA_GLOBAL_NewBicycleText:
	text "A shiny new"
	line "BICYCLE!"
	done

_PushStartText:
WLA_GLOBAL_PushStartText:
	text "Push START to"
	line "open the MENU!"
	done

_SaveOptionText:
WLA_GLOBAL_SaveOptionText:
	text "The SAVE option is"
	line "on the MENU"
	cont "screen."
	done

_StrengthsAndWeaknessesText:
WLA_GLOBAL_StrengthsAndWeaknessesText:
	text "All #MON types"
	line "have strong and"
	cont "weak points"
	cont "against others."
	done

_TimesUpText:
WLA_GLOBAL_TimesUpText:
	text "PA: Ding-dong!"

	para "Time's up!"
	prompt

_GameOverText:
WLA_GLOBAL_GameOverText:
	text "PA: Your SAFARI"
	line "GAME is over!"
	done

_CinnabarGymQuizIntroText:
WLA_GLOBAL_CinnabarGymQuizIntroText:
	text "#MON Quiz!"

	para "Get it right and"
	line "the door opens to"
	cont "the next room!"

	para "Get it wrong and"
	line "face a trainer!"

	para "If you want to"
	line "conserve your"
	cont "#MON for the"
	cont "GYM LEADER..."

	para "Then get it right!"
	line "Here we go!"
	prompt

_CinnabarQuizQuestionsText1:
WLA_GLOBAL_CinnabarQuizQuestionsText1:
	text "CATERPIE evolves"
	line "into BUTTERFREE?"
	done

_CinnabarQuizQuestionsText2:
WLA_GLOBAL_CinnabarQuizQuestionsText2:
	text "There are 9"
	line "certified #MON"
	cont "LEAGUE BADGEs?"
	done

_CinnabarQuizQuestionsText3:
WLA_GLOBAL_CinnabarQuizQuestionsText3:
	text "POLIWAG evolves 3"
	line "times?"
	done

_CinnabarQuizQuestionsText4:
WLA_GLOBAL_CinnabarQuizQuestionsText4:
	text "Are thunder moves"
	line "effective against"
	cont "ground element-"
	cont "type #MON?"
	done

_CinnabarQuizQuestionsText5:
WLA_GLOBAL_CinnabarQuizQuestionsText5:
	text "#MON of the"
	line "same kind and"
	cont "level are not"
	cont "identical?"
	done

_CinnabarQuizQuestionsText6:
WLA_GLOBAL_CinnabarQuizQuestionsText6:
	text "TM28 contains"
	line "TOMBSTONER?"
	done

_CinnabarGymQuizCorrectText:
WLA_GLOBAL_CinnabarGymQuizCorrectText:
	text "You're absolutely"
	line "correct!"

	para "Go on through!@"
	text_end

_CinnabarGymQuizIncorrectText:
WLA_GLOBAL_CinnabarGymQuizIncorrectText:
	text "Sorry! Bad call!"
	prompt

_MagazinesText:
WLA_GLOBAL_MagazinesText:
	text "#MON magazines!"

	para "#MON notebooks!"

	para "#MON graphs!"
	done

_BillsHouseMonitorText:
WLA_GLOBAL_BillsHouseMonitorText:
	text "TELEPORTER is"
	line "displayed on the"
	cont "PC monitor."
	done

_BillsHouseInitiatedText:
WLA_GLOBAL_BillsHouseInitiatedText:
	text "<PLAYER> initiated"
	line "TELEPORTER's Cell"
	cont "Separator!@"
	text_end

_BillsHousePokemonListText1:
WLA_GLOBAL_BillsHousePokemonListText1:
	text "BILL's favorite"
	line "#MON list!"
	prompt

_BillsHousePokemonListText2:
WLA_GLOBAL_BillsHousePokemonListText2:
	text "Which #MON do"
	line "you want to see?"
	done

_OakLabEmailText:
WLA_GLOBAL_OakLabEmailText:
	text "There's an e-mail"
	line "message here!"

	para "..."

	para "Calling all"
	line "#MON trainers!"

	para "The elite trainers"
	line "of #MON LEAGUE"
	cont "are ready to take"
	cont "on all comers!"

	para "Bring your best"
	line "#MON and see"
	cont "how you rate as a"
	cont "trainer!"

	para "#MON LEAGUE HQ"
	line "INDIGO PLATEAU"

	para "PS: PROF.OAK,"
	line "please visit us!"
	cont "..."
	done

_GameCornerCoinCaseText:
WLA_GLOBAL_GameCornerCoinCaseText:
	text "A COIN CASE is"
	line "required!"
	done

_GameCornerNoCoinsText:
WLA_GLOBAL_GameCornerNoCoinsText:
	text "You don't have"
	line "any coins!"
	done

_GameCornerOutOfOrderText:
WLA_GLOBAL_GameCornerOutOfOrderText:
	text "OUT OF ORDER"
	line "This is broken."
	done

_GameCornerOutToLunchText:
WLA_GLOBAL_GameCornerOutToLunchText:
	text "OUT TO LUNCH"
	line "This is reserved."
	done

_GameCornerSomeonesKeysText:
WLA_GLOBAL_GameCornerSomeonesKeysText:
	text "Someone's keys!"
	line "They'll be back."
	done

_JustAMomentText:
WLA_GLOBAL_JustAMomentText:
	text "Just a moment."
	done

TMNotebookText:
	text "It's a pamphlet"
	line "on TMs."

	para "..."

	para "There are 50 TMs"
	line "in all."

	para "There are also 5"
	line "HMs that can be"
	cont "used repeatedly."

	para "SILPH CO.@"
	text_end

_TurnPageText:
WLA_GLOBAL_TurnPageText:
	text "Turn the page?"
	done

_ViridianSchoolNotebookText5:
WLA_GLOBAL_ViridianSchoolNotebookText5:
	text "GIRL: Hey! Don't"
	line "look at my notes!@"
	text_end

_ViridianSchoolNotebookText1:
WLA_GLOBAL_ViridianSchoolNotebookText1:
	text "Looked at the"
	line "notebook!"

	para "First page..."

	para "# BALLs are"
	line "used to catch"
	cont "#MON."

	para "Up to 6 #MON"
	line "can be carried."

	para "People who raise"
	line "and make #MON"
	cont "fight are called"
	cont "#MON trainers."
	prompt

_ViridianSchoolNotebookText2:
WLA_GLOBAL_ViridianSchoolNotebookText2:
	text "Second page..."

	para "A healthy #MON"
	line "may be hard to"
	cont "catch, so weaken"
	cont "it first!"

	para "Poison, burns and"
	line "other damage are"
	cont "effective!"
	prompt

_ViridianSchoolNotebookText3:
WLA_GLOBAL_ViridianSchoolNotebookText3:
	text "Third page..."

	para "#MON trainers"
	line "seek others to"
	cont "engage in #MON"
	cont "fights."

	para "Battles are"
	line "constantly fought"
	cont "at #MON GYMs."
	prompt

_ViridianSchoolNotebookText4:
WLA_GLOBAL_ViridianSchoolNotebookText4:
	text "Fourth page..."

	para "The goal for"
	line "#MON trainers"
	cont "is to beat the "
	cont "top 8 #MON"
	cont "GYM LEADERs."

	para "Do so to earn the"
	line "right to face..."

	para "The ELITE FOUR of"
	line "#MON LEAGUE!"
	prompt

_EnemiesOnEverySideText:
WLA_GLOBAL_EnemiesOnEverySideText:
	text "Enemies on every"
	line "side!"
	done

_WhatGoesAroundComesAroundText:
WLA_GLOBAL_WhatGoesAroundComesAroundText:
	text "What goes around"
	line "comes around!"
	done

_FightingDojoText:
WLA_GLOBAL_FightingDojoText:
	text "FIGHTING DOJO"
	done

_IndigoPlateauHQText:
WLA_GLOBAL_IndigoPlateauHQText:
	text "INDIGO PLATEAU"
	line "#MON LEAGUE HQ"
	done

_RedBedroomSNESText:
WLA_GLOBAL_RedBedroomSNESText:
	text "<PLAYER> is"
	line "playing the SNES!"
	cont "...Okay!"
	cont "It's time to go!"
	done

_Route15UpstairsBinocularsText:
WLA_GLOBAL_Route15UpstairsBinocularsText:
	text "Looked into the"
	line "binoculars..."

	para "A large, shining"
	line "bird is flying"
	cont "toward the sea."
	done

_AerodactylFossilText:
WLA_GLOBAL_AerodactylFossilText:
	text "AERODACTYL Fossil"
	line "A primitive and"
	cont "rare #MON."
	done

_KabutopsFossilText:
WLA_GLOBAL_KabutopsFossilText:
	text "KABUTOPS Fossil"
	line "A primitive and"
	cont "rare #MON."
	done

_LinkCableHelpText1:
WLA_GLOBAL_LinkCableHelpText1:
	text "TRAINER TIPS"

	para "Using a Game Link"
	line "Cable"
	prompt

_LinkCableHelpText2:
WLA_GLOBAL_LinkCableHelpText2:
	text "Which heading do"
	line "you want to read?"
	done

_LinkCableInfoText1:
WLA_GLOBAL_LinkCableInfoText1:
	text "When you have"
	line "linked your GAME"
	cont "BOY with another"
	cont "GAME BOY, talk to"
	cont "the attendant on"
	cont "the right in any"
	cont "#MON CENTER."
	prompt

_LinkCableInfoText2:
WLA_GLOBAL_LinkCableInfoText2:
	text "COLOSSEUM lets"
	line "you play against"
	cont "a friend."
	prompt

_LinkCableInfoText3:
WLA_GLOBAL_LinkCableInfoText3:
	text "TRADE CENTER is"
	line "used for trading"
	cont "#MON."
	prompt

_ViridianSchoolBlackboardText1:
WLA_GLOBAL_ViridianSchoolBlackboardText1:
	text "The blackboard"
	line "describes #MON"
	cont "STATUS changes"
	cont "during battles."
	prompt

_ViridianSchoolBlackboardText2:
WLA_GLOBAL_ViridianSchoolBlackboardText2:
	text "Which heading do"
	line "you want to read?"
	done

_ViridianBlackboardSleepText:
WLA_GLOBAL_ViridianBlackboardSleepText:
	text "A #MON can't"
	line "attack if it's"
	cont "asleep!"

	para "#MON will stay"
	line "asleep even after"
	cont "battles."

	para "Use AWAKENING to"
	line "wake them up!"
	prompt

_ViridianBlackboardPoisonText:
WLA_GLOBAL_ViridianBlackboardPoisonText:
	text "When poisoned, a"
	line "#MON's health"
	cont "steadily drops."

	para "Poison lingers"
	line "after battles."

	para "Use an ANTIDOTE"
	line "to cure poison!"
	prompt

_ViridianBlackboardPrlzText:
WLA_GLOBAL_ViridianBlackboardPrlzText:
	text "Paralysis could"
	line "make #MON"
	cont "moves misfire!"

	para "Paralysis remains"
	line "after battles."

	para "Use PARLYZ HEAL"
	line "for treatment!"
	prompt

_ViridianBlackboardBurnText:
WLA_GLOBAL_ViridianBlackboardBurnText:
	text "A burn reduces"
	line "power and speed."
	cont "It also causes"
	cont "ongoing damage."

	para "Burns remain"
	line "after battles."

	para "Use BURN HEAL to"
	line "cure a burn!"
	prompt

_ViridianBlackboardFrozenText:
WLA_GLOBAL_ViridianBlackboardFrozenText:
	text "If frozen, a"
	line "#MON becomes"
	cont "totally immobile!"

	para "It stays frozen"
	line "even after the"
	cont "battle ends."

	para "Use ICE HEAL to"
	line "thaw out #MON!"
	prompt

_VermilionGymTrashText:
WLA_GLOBAL_VermilionGymTrashText:
	text "Nope, there's"
	line "only trash here."
	done

_VermilionGymTrashSuccessText1:
WLA_GLOBAL_VermilionGymTrashSuccessText1:
	text "Hey! There's a"
	line "switch under the"
	cont "trash!"
	cont "Turn it on!"

	para "The 1st electric"
	line "lock opened!@"
	text_end

_VermilionGymTrashSuccessText2:
WLA_GLOBAL_VermilionGymTrashSuccessText2:
	text "Hey! There's"
	line "another switch"
	cont "under the trash!"
	cont "Turn it on!"
	prompt

_VermilionGymTrashSuccessText3:
WLA_GLOBAL_VermilionGymTrashSuccessText3:
	text "The 2nd electric"
	line "lock opened!"

	para "The motorized door"
	line "opened!@"
	text_end

_VermilionGymTrashFailText:
WLA_GLOBAL_VermilionGymTrashFailText:
	text "Nope! There's"
	line "only trash here."
	cont "Hey! The electric"
	cont "locks were reset!@"
	text_end

_FoundHiddenItemText:
WLA_GLOBAL_FoundHiddenItemText:
	text "<PLAYER> found"
	line "@"
	text_ram wNameBuffer
	text "!@"
	text_end

_HiddenItemBagFullText:
WLA_GLOBAL_HiddenItemBagFullText:
	text "But, <PLAYER> has"
	line "no more room for"
	cont "other items!"
	done

_FoundHiddenCoinsText:
WLA_GLOBAL_FoundHiddenCoinsText:
	text "<PLAYER> found"
	line "@"
	text_bcd hCoins, 2 | LEADING_ZEROES | LEFT_ALIGN
	text " coins!@"
	text_end

_FoundHiddenCoins2Text:
WLA_GLOBAL_FoundHiddenCoins2Text:
	text "<PLAYER> found"
	line "@"
	text_bcd hCoins, 2 | LEADING_ZEROES | LEFT_ALIGN
	text " coins!@"
	text_end

_DroppedHiddenCoinsText:
WLA_GLOBAL_DroppedHiddenCoinsText:
	text_start
	para "Oops! Dropped"
	line "some coins!"
	done

_IndigoPlateauStatuesText1:
WLA_GLOBAL_IndigoPlateauStatuesText1:
	text "INDIGO PLATEAU"
	prompt

_IndigoPlateauStatuesText2:
WLA_GLOBAL_IndigoPlateauStatuesText2:
	text "The ultimate goal"
	line "of trainers!"
	cont "#MON LEAGUE HQ"
	done

_IndigoPlateauStatuesText3:
WLA_GLOBAL_IndigoPlateauStatuesText3:
	text "The highest"
	line "#MON authority"
	cont "#MON LEAGUE HQ"
	done

_PokemonBooksText:
WLA_GLOBAL_PokemonBooksText:
	text "Crammed full of"
	line "#MON books!"
	done

_DiglettSculptureText:
WLA_GLOBAL_DiglettSculptureText:
	text "It's a sculpture"
	line "of DIGLETT."
	done

_ElevatorText:
WLA_GLOBAL_ElevatorText:
	text "This is an"
	line "elevator."
	done

_TownMapText:
WLA_GLOBAL_TownMapText:
	text "A TOWN MAP.@"
	text_end

_PokemonStuffText:
WLA_GLOBAL_PokemonStuffText:
	text "Wow! Tons of"
	line "#MON stuff!"
	done

_OutOfSafariBallsText:
WLA_GLOBAL_OutOfSafariBallsText:
	text "PA: Ding-dong!"

	para "You are out of"
	line "SAFARI BALLs!"
	prompt

_WildRanText:
WLA_GLOBAL_WildRanText:
	text "Wild @"
	text_ram wEnemyMonNick
	text_start
	line "ran!"
	prompt

_EnemyRanText:
WLA_GLOBAL_EnemyRanText:
	text "Enemy @"
	text_ram wEnemyMonNick
	text_start
	line "ran!"
	prompt

_HurtByPoisonText:
WLA_GLOBAL_HurtByPoisonText:
	text "<USER>'s"
	line "hurt by poison!"
	prompt

_HurtByBurnText:
WLA_GLOBAL_HurtByBurnText:
	text "<USER>'s"
	line "hurt by the burn!"
	prompt

_HurtByLeechSeedText:
WLA_GLOBAL_HurtByLeechSeedText:
	text "LEECH SEED saps"
	line "<USER>!"
	prompt

_EnemyMonFaintedText:
WLA_GLOBAL_EnemyMonFaintedText:
	text "Enemy @"
	text_ram wEnemyMonNick
	text_start
	line "fainted!"
	prompt

_MoneyForWinningText:
WLA_GLOBAL_MoneyForWinningText:
	text "<PLAYER> got ¥@"
	text_bcd wAmountMoneyWon, 3 | LEADING_ZEROES | LEFT_ALIGN
	text_start
	line "for winning!"
	prompt

_TrainerDefeatedText:
WLA_GLOBAL_TrainerDefeatedText:
	text "<PLAYER> defeated"
	line "@"
	text_ram wTrainerName
	text "!"
	prompt

_PlayerMonFaintedText:
WLA_GLOBAL_PlayerMonFaintedText:
	text_ram wBattleMonNick
	text_start
	line "fainted!"
	prompt

_UseNextMonText:
WLA_GLOBAL_UseNextMonText:
	text "Use next #MON?"
	done

_Rival1WinText:
WLA_GLOBAL_Rival1WinText:
	text "<RIVAL>: Yeah! Am"
	line "I great or what?"
	prompt

_PlayerBlackedOutText2:
WLA_GLOBAL_PlayerBlackedOutText2:
	text "<PLAYER> is out of"
	line "useable #MON!"

	para "<PLAYER> blacked"
	line "out!"
	prompt

_LinkBattleLostText:
WLA_GLOBAL_LinkBattleLostText:
	text "<PLAYER> lost to"
	line "@"
	text_ram wTrainerName
	text "!"
	prompt

_TrainerAboutToUseText:
WLA_GLOBAL_TrainerAboutToUseText:
	text_ram wTrainerName
	text " is"
	line "about to use"
	cont "@"
	text_ram wEnemyMonNick
	text "!"

	para "Will <PLAYER>"
	line "change #MON?"
	done

_TrainerSentOutText:
WLA_GLOBAL_TrainerSentOutText:
	text_ram wTrainerName
	text " sent"
	line "out @"
	text_ram wEnemyMonNick
	text "!"
	done

_NoWillText:
WLA_GLOBAL_NoWillText:
	text "There's no will"
	line "to fight!"
	prompt

_CantEscapeText:
WLA_GLOBAL_CantEscapeText:
	text "Can't escape!"
	prompt

_NoRunningText:
WLA_GLOBAL_NoRunningText:
	text "No! There's no"
	line "running from a"
	cont "trainer battle!"
	prompt

_GotAwayText:
WLA_GLOBAL_GotAwayText:
	text "Got away safely!"
	prompt

_ItemsCantBeUsedHereText:
WLA_GLOBAL_ItemsCantBeUsedHereText:
	text "Items can't be"
	line "used here."
	prompt

_AlreadyOutText:
WLA_GLOBAL_AlreadyOutText:
	text_ram wBattleMonNick
	text " is"
	line "already out!"
	prompt

_MoveNoPPText:
WLA_GLOBAL_MoveNoPPText:
	text "No PP left for"
	line "this move!"
	prompt

_MoveDisabledText:
WLA_GLOBAL_MoveDisabledText:
	text "The move is"
	line "disabled!"
	prompt

_NoMovesLeftText:
WLA_GLOBAL_NoMovesLeftText:
	text_ram wBattleMonNick
	text " has no"
	line "moves left!"
	done

_MultiHitText:
WLA_GLOBAL_MultiHitText:
	text "Hit the enemy"
	line "@"
	text_decimal wPlayerNumHits, 1, 1
	text " times!"
	prompt

_ScaredText:
WLA_GLOBAL_ScaredText:
	text_ram wBattleMonNick
	text " is too"
	line "scared to move!"
	prompt

_GetOutText:
WLA_GLOBAL_GetOutText:
	text "GHOST: Get out..."
	line "Get out..."
	prompt

_FastAsleepText:
WLA_GLOBAL_FastAsleepText:
	text "<USER>"
	line "is fast asleep!"
	prompt

_WokeUpText:
WLA_GLOBAL_WokeUpText:
	text "<USER>"
	line "woke up!"
	prompt

_IsFrozenText:
WLA_GLOBAL_IsFrozenText:
	text "<USER>"
	line "is frozen solid!"
	prompt

_FullyParalyzedText:
WLA_GLOBAL_FullyParalyzedText:
	text "<USER>'s"
	line "fully paralyzed!"
	prompt

_FlinchedText:
WLA_GLOBAL_FlinchedText:
	text "<USER>"
	line "flinched!"
	prompt

_MustRechargeText:
WLA_GLOBAL_MustRechargeText:
	text "<USER>"
	line "must recharge!"
	prompt

_DisabledNoMoreText:
WLA_GLOBAL_DisabledNoMoreText:
	text "<USER>'s"
	line "disabled no more!"
	prompt

_IsConfusedText:
WLA_GLOBAL_IsConfusedText:
	text "<USER>"
	line "is confused!"
	prompt

_HurtItselfText:
WLA_GLOBAL_HurtItselfText:
	text "It hurt itself in"
	line "its confusion!"
	prompt

_ConfusedNoMoreText:
WLA_GLOBAL_ConfusedNoMoreText:
	text "<USER>'s"
	line "confused no more!"
	prompt

_SavingEnergyText:
WLA_GLOBAL_SavingEnergyText:
	text "<USER>"
	line "is saving energy!"
	prompt

_UnleashedEnergyText:
WLA_GLOBAL_UnleashedEnergyText:
	text "<USER>"
	line "unleashed energy!"
	prompt

_ThrashingAboutText:
WLA_GLOBAL_ThrashingAboutText:
	text "<USER>'s"
	line "thrashing about!"
	done

_AttackContinuesText:
WLA_GLOBAL_AttackContinuesText:
	text "<USER>'s"
	line "attack continues!"
	done

_CantMoveText:
WLA_GLOBAL_CantMoveText:
	text "<USER>"
	line "can't move!"
	prompt

_MoveIsDisabledText:
WLA_GLOBAL_MoveIsDisabledText:
	text "<USER>'s"
	line "@"
	text_ram wNameBuffer
	text " is"
	cont "disabled!"
	prompt

_ActorNameText:
WLA_GLOBAL_ActorNameText:
	text "<USER>@"
	text_end

_UsedMove1Text:
WLA_GLOBAL_UsedMove1Text:
	text_start
	line "used @"
	text_end

_UsedMove2Text:
WLA_GLOBAL_UsedMove2Text:
	text_start
	line "used @"
	text_end

_UsedInsteadText:
WLA_GLOBAL_UsedInsteadText:
	text "instead,"
	cont "@"
	text_end

_MoveNameText:
WLA_GLOBAL_MoveNameText:
	text_ram wStringBuffer
	text "@"

_EndUsedMove1Text:
WLA_GLOBAL_EndUsedMove1Text:
	text "!"
	done

_EndUsedMove2Text:
WLA_GLOBAL_EndUsedMove2Text:
	text "!"
	done

_EndUsedMove3Text:
WLA_GLOBAL_EndUsedMove3Text:
	text "!"
	done

_EndUsedMove4Text:
WLA_GLOBAL_EndUsedMove4Text:
	text "!"
	done

_EndUsedMove5Text:
WLA_GLOBAL_EndUsedMove5Text:
	text "!"
	done

_AttackMissedText:
WLA_GLOBAL_AttackMissedText:
	text "<USER>'s"
	line "attack missed!"
	prompt

_KeptGoingAndCrashedText:
WLA_GLOBAL_KeptGoingAndCrashedText:
	text "<USER>"
	line "kept going and"
	cont "crashed!"
	prompt

_UnaffectedText:
WLA_GLOBAL_UnaffectedText:
	text "<TARGET>'s"
	line "unaffected!"
	prompt

_DoesntAffectMonText:
WLA_GLOBAL_DoesntAffectMonText:
	text "It doesn't affect"
	line "<TARGET>!"
	prompt

_CriticalHitText:
WLA_GLOBAL_CriticalHitText:
	text "Critical hit!"
	prompt

_OHKOText:
WLA_GLOBAL_OHKOText:
	text "One-hit KO!"
	prompt

_LoafingAroundText:
WLA_GLOBAL_LoafingAroundText:
	text_ram wBattleMonNick
	text " is"
	line "loafing around."
	prompt

_BeganToNapText:
WLA_GLOBAL_BeganToNapText:
	text_ram wBattleMonNick
	text " began"
	line "to nap!"
	prompt

_WontObeyText:
WLA_GLOBAL_WontObeyText:
	text_ram wBattleMonNick
	text " won't"
	line "obey!"
	prompt

_TurnedAwayText:
WLA_GLOBAL_TurnedAwayText:
	text_ram wBattleMonNick
	text " turned"
	line "away!"
	prompt

_IgnoredOrdersText:
WLA_GLOBAL_IgnoredOrdersText:
	text_ram wBattleMonNick
	text_start
	line "ignored orders!"
	prompt

_SubstituteTookDamageText:
WLA_GLOBAL_SubstituteTookDamageText:
	text "The SUBSTITUTE"
	line "took damage for"
	cont "<TARGET>!"
	prompt

_SubstituteBrokeText:
WLA_GLOBAL_SubstituteBrokeText:
	text "<TARGET>'s"
	line "SUBSTITUTE broke!"
	prompt

_BuildingRageText:
WLA_GLOBAL_BuildingRageText:
	text "<USER>'s"
	line "RAGE is building!"
	prompt

_MirrorMoveFailedText:
WLA_GLOBAL_MirrorMoveFailedText:
	text "The MIRROR MOVE"
	next "failed!"
	prompt

_HitXTimesText:
WLA_GLOBAL_HitXTimesText:
	text "Hit @"
	text_decimal wEnemyNumHits, 1, 1
	text " times!"
	prompt

_GainedText:
WLA_GLOBAL_GainedText:
	text_ram wNameBuffer
	text " gained"
	line "@"
	text_end

_WithExpAllText:
WLA_GLOBAL_WithExpAllText:
	text "with EXP.ALL,"
	cont "@"
	text_end

_BoostedText:
WLA_GLOBAL_BoostedText:
	text "a boosted"
	cont "@"
	text_end

_ExpPointsText:
WLA_GLOBAL_ExpPointsText:
	text_decimal wExpAmountGained, 2, 4
	text " EXP. Points!"
	prompt

_GrewLevelText:
WLA_GLOBAL_GrewLevelText:
	text_ram wNameBuffer
	text " grew"
	line "to level @"
	text_decimal wCurEnemyLevel, 1, 3
	text "!@"
	text_end

_WildMonAppearedText:
WLA_GLOBAL_WildMonAppearedText:
	text "Wild @"
	text_ram wEnemyMonNick
	text_start
	line "appeared!"
	prompt

_HookedMonAttackedText:
WLA_GLOBAL_HookedMonAttackedText:
	text "The hooked"
	line "@"
	text_ram wEnemyMonNick
	text_start
	cont "attacked!"
	prompt

_EnemyAppearedText:
WLA_GLOBAL_EnemyAppearedText:
	text_ram wEnemyMonNick
	text_start
	line "appeared!"
	prompt

_TrainerWantsToFightText:
WLA_GLOBAL_TrainerWantsToFightText:
	text_ram wTrainerName
	text " wants"
	line "to fight!"
	prompt

_UnveiledGhostText:
WLA_GLOBAL_UnveiledGhostText:
	text "SILPH SCOPE"
	line "unveiled the"
	cont "GHOST's identity!"
	prompt

_GhostCantBeIDdText:
WLA_GLOBAL_GhostCantBeIDdText:
	text "Darn! The GHOST"
	line "can't be ID'd!"
	prompt

_GoText:
WLA_GLOBAL_GoText:
	text "Go! @"
	text_end

_DoItText:
WLA_GLOBAL_DoItText:
	text "Do it! @"
	text_end

_GetmText:
WLA_GLOBAL_GetmText:
	text "Get'm! @"
	text_end

_EnemysWeakText:
WLA_GLOBAL_EnemysWeakText:
	text "The enemy's weak!"
	line "Get'm! @"
	text_end

_PlayerMon1Text:
WLA_GLOBAL_PlayerMon1Text:
	text_ram wBattleMonNick
	text "!"
	done

_PlayerMon2Text:
WLA_GLOBAL_PlayerMon2Text:
	text_ram wBattleMonNick
	text " @"
	text_end

_EnoughText:
WLA_GLOBAL_EnoughText:
	text "enough!@"
	text_end

_OKExclamationText:
WLA_GLOBAL_OKExclamationText:
	text "OK!@"
	text_end

_GoodText:
WLA_GLOBAL_GoodText:
	text "good!@"
	text_end

_ComeBackText:
WLA_GLOBAL_ComeBackText:
	text_start
	line "Come back!"
	done

_SuperEffectiveText:
WLA_GLOBAL_SuperEffectiveText:
	text "It's super"
	line "effective!"
	prompt

_NotVeryEffectiveText:
WLA_GLOBAL_NotVeryEffectiveText:
	text "It's not very"
	line "effective..."
	prompt

_SafariZoneEatingText:
WLA_GLOBAL_SafariZoneEatingText:
	text "Wild @"
	text_ram wEnemyMonNick
	text_start
	line "is eating!"
	prompt

_SafariZoneAngryText:
WLA_GLOBAL_SafariZoneAngryText:
	text "Wild @"
	text_ram wEnemyMonNick
	text_start
	line "is angry!"
	prompt

; money related
_PickUpPayDayMoneyText:
WLA_GLOBAL_PickUpPayDayMoneyText:
	text "<PLAYER> picked up"
	line "¥@"
	text_bcd wTotalPayDayMoney, 3 | LEADING_ZEROES | LEFT_ALIGN
	text "!"
	prompt

_ClearSaveDataText:
WLA_GLOBAL_ClearSaveDataText:
	text "Clear all saved"
	line "data?"
	done

_WhichFloorText:
WLA_GLOBAL_WhichFloorText:
	text "Which floor do"
	line "you want? "
	done

_PartyMenuNormalText:
WLA_GLOBAL_PartyMenuNormalText:
	text "Choose a #MON."
	done

_PartyMenuItemUseText:
WLA_GLOBAL_PartyMenuItemUseText:
	text "Use item on which"
	line "#MON?"
	done

_PartyMenuBattleText:
WLA_GLOBAL_PartyMenuBattleText:
	text "Bring out which"
	line "#MON?"
	done

_PartyMenuUseTMText:
WLA_GLOBAL_PartyMenuUseTMText:
	text "Use TM on which"
	line "#MON?"
	done

_PartyMenuSwapMonText:
WLA_GLOBAL_PartyMenuSwapMonText:
	text "Move #MON"
	line "where?"
	done

_PotionText:
WLA_GLOBAL_PotionText:
	text_ram wNameBuffer
	text_start
	line "recovered by @"
	text_decimal wHPBarHPDifference, 2, 3
	text "!"
	done

_AntidoteText:
WLA_GLOBAL_AntidoteText:
	text_ram wNameBuffer
	text " was"
	line "cured of poison!"
	done

_ParlyzHealText:
WLA_GLOBAL_ParlyzHealText:
	text_ram wNameBuffer
	text "'s"
	line "rid of paralysis!"
	done

_BurnHealText:
WLA_GLOBAL_BurnHealText:
	text_ram wNameBuffer
	text "'s"
	line "burn was healed!"
	done

_IceHealText:
WLA_GLOBAL_IceHealText:
	text_ram wNameBuffer
	text " was"
	line "defrosted!"
	done

_AwakeningText:
WLA_GLOBAL_AwakeningText:
	text_ram wNameBuffer
	text_start
	line "woke up!"
	done

_FullHealText:
WLA_GLOBAL_FullHealText:
	text_ram wNameBuffer
	text "'s"
	line "health returned!"
	done

_ReviveText:
WLA_GLOBAL_ReviveText:
	text_ram wNameBuffer
	text_start
	line "is revitalized!"
	done

_RareCandyText:
WLA_GLOBAL_RareCandyText:
	text_ram wNameBuffer
	text " grew"
	line "to level @"
	text_decimal wCurEnemyLevel, 1, 3
	text "!@"
	text_end

_TurnedOnPC1Text:
WLA_GLOBAL_TurnedOnPC1Text:
	text "<PLAYER> turned on"
	line "the PC."
	prompt

_AccessedBillsPCText:
WLA_GLOBAL_AccessedBillsPCText:
	text "Accessed BILL's"
	line "PC."

	para "Accessed #MON"
	line "Storage System."
	prompt

_AccessedSomeonesPCText:
WLA_GLOBAL_AccessedSomeonesPCText:
	text "Accessed someone's"
	line "PC."

	para "Accessed #MON"
	line "Storage System."
	prompt

_AccessedMyPCText:
WLA_GLOBAL_AccessedMyPCText:
	text "Accessed my PC."

	para "Accessed Item"
	line "Storage System."
	prompt

_TurnedOnPC2Text:
WLA_GLOBAL_TurnedOnPC2Text:
	text "<PLAYER> turned on"
	line "the PC."
	prompt

_WhatDoYouWantText:
WLA_GLOBAL_WhatDoYouWantText:
	text "What do you want"
	line "to do?"
	done

_WhatToDepositText:
WLA_GLOBAL_WhatToDepositText:
	text "What do you want"
	line "to deposit?"
	done

_DepositHowManyText:
WLA_GLOBAL_DepositHowManyText:
	text "How many?"
	done

_ItemWasStoredText:
WLA_GLOBAL_ItemWasStoredText:
	text_ram wNameBuffer
	text " was"
	line "stored via PC."
	prompt

_NothingToDepositText:
WLA_GLOBAL_NothingToDepositText:
	text "You have nothing"
	line "to deposit."
	prompt

_NoRoomToStoreText:
WLA_GLOBAL_NoRoomToStoreText:
	text "No room left to"
	line "store items."
	prompt

_WhatToWithdrawText:
WLA_GLOBAL_WhatToWithdrawText:
	text "What do you want"
	line "to withdraw?"
	done

_WithdrawHowManyText:
WLA_GLOBAL_WithdrawHowManyText:
	text "How many?"
	done

_WithdrewItemText:
WLA_GLOBAL_WithdrewItemText:
	text "Withdrew"
	line "@"
	text_ram wNameBuffer
	text "."
	prompt

_NothingStoredText:
WLA_GLOBAL_NothingStoredText:
	text "There is nothing"
	line "stored."
	prompt

_CantCarryMoreText:
WLA_GLOBAL_CantCarryMoreText:
	text "You can't carry"
	line "any more items."
	prompt

_WhatToTossText:
WLA_GLOBAL_WhatToTossText:
	text "What do you want"
	line "to toss away?"
	done

_TossHowManyText:
WLA_GLOBAL_TossHowManyText:
	text "How many?"
	done

_AccessedHoFPCText:
WLA_GLOBAL_AccessedHoFPCText:
	text "Accessed #MON"
	line "LEAGUE's site."

	para "Accessed the HALL"
	line "OF FAME List."
	prompt

_SwitchOnText:
WLA_GLOBAL_SwitchOnText:
	text "Switch on!"
	prompt

_WhatText:
WLA_GLOBAL_WhatText:
	text "What?"
	done

_DepositWhichMonText:
WLA_GLOBAL_DepositWhichMonText:
	text "Deposit which"
	line "#MON?"
	done

_MonWasStoredText:
WLA_GLOBAL_MonWasStoredText:
	text_ram wStringBuffer
	text " was"
	line "stored in Box @"
	text_ram wBoxNumString
	text "."
	prompt

_CantDepositLastMonText:
WLA_GLOBAL_CantDepositLastMonText:
	text "You can't deposit"
	line "the last #MON!"
	prompt

_BoxFullText:
WLA_GLOBAL_BoxFullText:
	text "Oops! This Box is"
	line "full of #MON."
	prompt

_MonIsTakenOutText:
WLA_GLOBAL_MonIsTakenOutText:
	text_ram wStringBuffer
	text " is"
	line "taken out."
	cont "Got @"
	text_ram wStringBuffer
	text "."
	prompt

_NoMonText:
WLA_GLOBAL_NoMonText:
	text "What? There are"
	line "no #MON here!"
	prompt

_CantTakeMonText:
WLA_GLOBAL_CantTakeMonText:
	text "You can't take"
	line "any more #MON."

	para "Deposit #MON"
	line "first."
	prompt

_ReleaseWhichMonText:
WLA_GLOBAL_ReleaseWhichMonText:
	text "Release which"
	line "#MON?"
	done

_OnceReleasedText:
WLA_GLOBAL_OnceReleasedText:
	text "Once released,"
	line "@"
	text_ram wStringBuffer
	text " is"
	cont "gone forever. OK?"
	done

_MonWasReleasedText:
WLA_GLOBAL_MonWasReleasedText:
	text_ram wStringBuffer
	text " was"
	line "released outside."
	cont "Bye @"
	text_ram wStringBuffer
	text "!"
	prompt

_RequireCoinCaseText:
WLA_GLOBAL_RequireCoinCaseText:
	text "A COIN CASE is"
	line "required!@"
	text_end

_ExchangeCoinsForPrizesText:
WLA_GLOBAL_ExchangeCoinsForPrizesText:
	text "We exchange your"
	line "coins for prizes."
	prompt

_WhichPrizeText:
WLA_GLOBAL_WhichPrizeText:
	text "Which prize do"
	line "you want?"
	done

_HereYouGoText:
WLA_GLOBAL_HereYouGoText:
	text "Here you go!@"
	text_end

_SoYouWantPrizeText:
WLA_GLOBAL_SoYouWantPrizeText:
	text "So, you want"
	line "@"
	text_ram wNameBuffer
	text "?"
	done

_SorryNeedMoreCoinsText:
WLA_GLOBAL_SorryNeedMoreCoinsText:
	text "Sorry, you need"
	line "more coins.@"
	text_end

_OopsYouDontHaveEnoughRoomText:
WLA_GLOBAL_OopsYouDontHaveEnoughRoomText:
	text "Oops! You don't"
	line "have enough room.@"
	text_end

_OhFineThenText:
WLA_GLOBAL_OhFineThenText:
	text "Oh, fine then.@"
	text_end

_GetDexRatedText:
WLA_GLOBAL_GetDexRatedText:
	text "Want to get your"
	line "#DEX rated?"
	done

_ClosedOaksPCText:
WLA_GLOBAL_ClosedOaksPCText:
	text "Closed link to"
	line "PROF.OAK's PC.@"
	text_end

_AccessedOaksPCText:
WLA_GLOBAL_AccessedOaksPCText:
	text "Accessed PROF."
	line "OAK's PC."

	para "Accessed #DEX"
	line "Rating System."
	prompt

_WhereWouldYouLikeText:
WLA_GLOBAL_WhereWouldYouLikeText:
	text "Where would you"
	line "like to go?"
	done

_PleaseWaitText:
WLA_GLOBAL_PleaseWaitText:
	text "OK, please wait"
	line "just a moment."
	done

_LinkCanceledText:
WLA_GLOBAL_LinkCanceledText:
	text "The link was"
	line "canceled."
	done

_OakSpeechText1:
WLA_GLOBAL_OakSpeechText1:
	text "Hello there!"
	line "Welcome to the"
	cont "world of #MON!"

	para "My name is OAK!"
	line "People call me"
	cont "the #MON PROF!"
	prompt

_OakSpeechText2A:
WLA_GLOBAL_OakSpeechText2A:
	text "This world is"
	line "inhabited by"
	cont "creatures called"
	cont "#MON!@"
	text_end

_OakSpeechText2B:
WLA_GLOBAL_OakSpeechText2B:
	text_start

	para "For some people,"
	line "#MON are"
	cont "pets. Others use"
	cont "them for fights."

	para "Myself..."

	para "I study #MON"
	line "as a profession."
	prompt

_IntroducePlayerText:
WLA_GLOBAL_IntroducePlayerText:
	text "First, what is"
	line "your name?"
	prompt

_IntroduceRivalText:
WLA_GLOBAL_IntroduceRivalText:
	text "This is my grand-"
	line "son. He's been"
	cont "your rival since"
	cont "you were a baby."

	para "...Erm, what is"
	line "his name again?"
	prompt

_OakSpeechText3:
WLA_GLOBAL_OakSpeechText3:
	text "<PLAYER>!"

	para "Your very own"
	line "#MON legend is"
	cont "about to unfold!"

	para "A world of dreams"
	line "and adventures"
	cont "with #MON"
	cont "awaits! Let's go!"
	done

_DoYouWantToNicknameText:
WLA_GLOBAL_DoYouWantToNicknameText:
	text "Do you want to"
	line "give a nickname"
	cont "to @"
	text_ram wNameBuffer
	text "?"
	done

_YourNameIsText:
WLA_GLOBAL_YourNameIsText:
	text "Right! So your"
	line "name is <PLAYER>!"
	prompt

_HisNameIsText:
WLA_GLOBAL_HisNameIsText:
	text "That's right! I"
	line "remember now! His"
	cont "name is <RIVAL>!"
	prompt

_WillBeTradedText:
WLA_GLOBAL_WillBeTradedText:
	text_ram wNameOfPlayerMonToBeTraded
	text " and"
	line "@"
	text_ram wNameBuffer
	text " will"
	cont "be traded."
	done

_TextIDErrorText:
WLA_GLOBAL_TextIDErrorText:
	text_decimal hTextID, 1, 2
	text " ERROR."
	done

_ContCharText:
WLA_GLOBAL_ContCharText:
	text "<_CONT>@"
	text_end
