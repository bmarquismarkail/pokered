_FileDataDestroyedText:
WLA_GLOBAL_FileDataDestroyedText:
	text "The file data is"
	line "destroyed!"
	prompt

_WouldYouLikeToSaveText:
WLA_GLOBAL_WouldYouLikeToSaveText:
	text "Would you like to"
	line "SAVE the game?"
	done

_GameSavedText:
WLA_GLOBAL_GameSavedText:
	text "<PLAYER> saved"
	line "the game!"
	done

_OlderFileWillBeErasedText:
WLA_GLOBAL_OlderFileWillBeErasedText:
	text "The older file"
	line "will be erased to"
	cont "save. Okay?"
	done

_WhenYouChangeBoxText:
WLA_GLOBAL_WhenYouChangeBoxText:
	text "When you change a"
	line "#MON BOX, data"
	cont "will be saved."

	para "Is that okay?"
	done

_ChooseABoxText:
WLA_GLOBAL_ChooseABoxText:
	text "Choose a"
	line "<PKMN> BOX.@"
	text_end

_EvolvedText:
WLA_GLOBAL_EvolvedText:
	text_ram wStringBuffer
	text " evolved"
	done

_IntoText:
WLA_GLOBAL_IntoText:
	text_start
	line "into @"
	text_ram wNameBuffer
	text "!"
	done

_StoppedEvolvingText:
WLA_GLOBAL_StoppedEvolvingText:
	text "Huh? @"
	text_ram wStringBuffer
	text_start
	line "stopped evolving!"
	prompt

_IsEvolvingText:
WLA_GLOBAL_IsEvolvingText:
	text "What? @"
	text_ram wStringBuffer
	text_start
	line "is evolving!"
	done

_FellAsleepText:
WLA_GLOBAL_FellAsleepText:
	text "<TARGET>"
	line "fell asleep!"
	prompt

_AlreadyAsleepText:
WLA_GLOBAL_AlreadyAsleepText:
	text "<TARGET>'s"
	line "already asleep!"
	prompt

_PoisonedText:
WLA_GLOBAL_PoisonedText:
	text "<TARGET>"
	line "was poisoned!"
	prompt

_BadlyPoisonedText:
WLA_GLOBAL_BadlyPoisonedText:
	text "<TARGET>'s"
	line "badly poisoned!"
	prompt

_BurnedText:
WLA_GLOBAL_BurnedText:
	text "<TARGET>"
	line "was burned!"
	prompt

_FrozenText:
WLA_GLOBAL_FrozenText:
	text "<TARGET>"
	line "was frozen solid!"
	prompt

_FireDefrostedText:
WLA_GLOBAL_FireDefrostedText:
	text "Fire defrosted"
	line "<TARGET>!"
	prompt

_MonsStatsRoseText:
WLA_GLOBAL_MonsStatsRoseText:
	text "<USER>'s"
	line "@"
	text_ram wStringBuffer
	text "@"
	text_end

_GreatlyRoseText:
WLA_GLOBAL_GreatlyRoseText:
	text "<SCROLL>greatly@"
	text_end

_RoseText:
WLA_GLOBAL_RoseText:
	text " rose!"
	prompt

_MonsStatsFellText:
WLA_GLOBAL_MonsStatsFellText:
	text "<TARGET>'s"
	line "@"
	text_ram wStringBuffer
	text "@"
	text_end

_GreatlyFellText:
WLA_GLOBAL_GreatlyFellText:
	text "<SCROLL>greatly@"
	text_end

_FellText:
WLA_GLOBAL_FellText:
	text " fell!"
	prompt

_RanFromBattleText:
WLA_GLOBAL_RanFromBattleText:
	text "<USER>"
	line "ran from battle!"
	prompt

_RanAwayScaredText:
WLA_GLOBAL_RanAwayScaredText:
	text "<TARGET>"
	line "ran away scared!"
	prompt

_WasBlownAwayText:
WLA_GLOBAL_WasBlownAwayText:
	text "<TARGET>"
	line "was blown away!"
	prompt

_ChargeMoveEffectText:
WLA_GLOBAL_ChargeMoveEffectText:
	text "<USER>@"
	text_end

_MadeWhirlwindText:
WLA_GLOBAL_MadeWhirlwindText:
	text_start
	line "made a whirlwind!"
	prompt

_TookInSunlightText:
WLA_GLOBAL_TookInSunlightText:
	text_start
	line "took in sunlight!"
	prompt

_LoweredItsHeadText:
WLA_GLOBAL_LoweredItsHeadText:
	text_start
	line "lowered its head!"
	prompt

_SkyAttackGlowingText:
WLA_GLOBAL_SkyAttackGlowingText:
	text_start
	line "is glowing!"
	prompt

_FlewUpHighText:
WLA_GLOBAL_FlewUpHighText:
	text_start
	line "flew up high!"
	prompt

_DugAHoleText:
WLA_GLOBAL_DugAHoleText:
	text_start
	line "dug a hole!"
	prompt

_BecameConfusedText:
WLA_GLOBAL_BecameConfusedText:
	text "<TARGET>"
	line "became confused!"
	prompt

_MimicLearnedMoveText:
WLA_GLOBAL_MimicLearnedMoveText:
	text "<USER>"
	line "learned"
	cont "@"
	text_ram wNameBuffer
	text "!"
	prompt

_MoveWasDisabledText:
WLA_GLOBAL_MoveWasDisabledText:
	text "<TARGET>'s"
	line "@"
	text_ram wNameBuffer
	text " was"
	cont "disabled!"
	prompt

_NothingHappenedText:
WLA_GLOBAL_NothingHappenedText:
	text "Nothing happened!"
	prompt

_NoEffectText:
WLA_GLOBAL_NoEffectText:
	text "No effect!"
	prompt

_ButItFailedText:
WLA_GLOBAL_ButItFailedText:
	text "But, it failed! "
	prompt

_DidntAffectText:
WLA_GLOBAL_DidntAffectText:
	text "It didn't affect"
	line "<TARGET>!"
	prompt

_IsUnaffectedText:
WLA_GLOBAL_IsUnaffectedText:
	text "<TARGET>"
	line "is unaffected!"
	prompt

_ParalyzedMayNotAttackText:
WLA_GLOBAL_ParalyzedMayNotAttackText:
	text "<TARGET>'s"
	line "paralyzed! It may"
	cont "not attack!"
	prompt

_SubstituteText:
WLA_GLOBAL_SubstituteText:
	text "It created a"
	line "SUBSTITUTE!"
	prompt

_HasSubstituteText:
WLA_GLOBAL_HasSubstituteText:
	text "<USER>"
	line "has a SUBSTITUTE!"
	prompt

_TooWeakSubstituteText:
WLA_GLOBAL_TooWeakSubstituteText:
	text "Too weak to make"
	line "a SUBSTITUTE!"
	prompt

_CoinsScatteredText:
WLA_GLOBAL_CoinsScatteredText:
	text "Coins scattered"
	line "everywhere!"
	prompt

_GettingPumpedText:
WLA_GLOBAL_GettingPumpedText:
	text "<USER>'s"
	line "getting pumped!"
	prompt

_WasSeededText:
WLA_GLOBAL_WasSeededText:
	text "<TARGET>"
	line "was seeded!"
	prompt

_EvadedAttackText:
WLA_GLOBAL_EvadedAttackText:
	text "<TARGET>"
	line "evaded attack!"
	prompt

_HitWithRecoilText:
WLA_GLOBAL_HitWithRecoilText:
	text "<USER>'s"
	line "hit with recoil!"
	prompt

_ConvertedTypeText:
WLA_GLOBAL_ConvertedTypeText:
	text "Converted type to"
	line "<TARGET>'s!"
	prompt

_StatusChangesEliminatedText:
WLA_GLOBAL_StatusChangesEliminatedText:
	text "All STATUS changes"
	line "are eliminated!"
	prompt

_StartedSleepingEffect:
WLA_GLOBAL_StartedSleepingEffect:
	text "<USER>"
	line "started sleeping!"
	done

_FellAsleepBecameHealthyText:
WLA_GLOBAL_FellAsleepBecameHealthyText:
	text "<USER>"
	line "fell asleep and"
	cont "became healthy!"
	done

_RegainedHealthText:
WLA_GLOBAL_RegainedHealthText:
	text "<USER>"
	line "regained health!"
	prompt

_TransformedText:
WLA_GLOBAL_TransformedText:
	text "<USER>"
	line "transformed into"
	cont "@"
	text_ram wNameBuffer
	text "!"
	prompt

_LightScreenProtectedText:
WLA_GLOBAL_LightScreenProtectedText:
	text "<USER>'s"
	line "protected against"
	cont "special attacks!"
	prompt

_ReflectGainedArmorText:
WLA_GLOBAL_ReflectGainedArmorText:
	text "<USER>"
	line "gained armor!"
	prompt

_ShroudedInMistText:
WLA_GLOBAL_ShroudedInMistText:
	text "<USER>'s"
	line "shrouded in mist!"
	prompt

_SuckedHealthText:
WLA_GLOBAL_SuckedHealthText:
	text "Sucked health from"
	line "<TARGET>!"
	prompt

_DreamWasEatenText:
WLA_GLOBAL_DreamWasEatenText:
	text "<TARGET>'s"
	line "dream was eaten!"
	prompt

_TradeCenterOpponentText:
WLA_GLOBAL_TradeCenterOpponentText:
	text "!"
	done

_ColosseumOpponentText:
WLA_GLOBAL_ColosseumOpponentText:
	text "!"
	done
