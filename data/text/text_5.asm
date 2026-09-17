_CableClubNPCPleaseComeAgainText:
WLA_GLOBAL_CableClubNPCPleaseComeAgainText:
	text "Please come again!"
	done

_CableClubNPCMakingPreparationsText:
WLA_GLOBAL_CableClubNPCMakingPreparationsText:
	text "We're making"
	line "preparations."
	cont "Please wait."
	done

_UsedStrengthText:
WLA_GLOBAL_UsedStrengthText:
	text_ram wNameBuffer
	text " used"
	line "STRENGTH.@"
	text_end

_CanMoveBouldersText:
WLA_GLOBAL_CanMoveBouldersText:
	text_ram wNameBuffer
	text " can"
	line "move boulders."
	prompt

_CurrentTooFastText:
WLA_GLOBAL_CurrentTooFastText:
	text "The current is"
	line "much too fast!"
	prompt

_CyclingIsFunText:
WLA_GLOBAL_CyclingIsFunText:
	text "Cycling is fun!"
	line "Forget SURFing!"
	prompt

_FlashLightsAreaText:
WLA_GLOBAL_FlashLightsAreaText:
	text "A blinding FLASH"
	line "lights the area!"
	prompt

_WarpToLastPokemonCenterText:
WLA_GLOBAL_WarpToLastPokemonCenterText:
	text "Warp to the last"
	line "#MON CENTER."
	done

_CannotUseTeleportNowText:
WLA_GLOBAL_CannotUseTeleportNowText:
	text_ram wNameBuffer
	text " can't"
	line "use TELEPORT now."
	prompt

_CannotFlyHereText:
WLA_GLOBAL_CannotFlyHereText:
	text_ram wNameBuffer
	text " can't"
	line "FLY here."
	prompt

_NotHealthyEnoughText:
WLA_GLOBAL_NotHealthyEnoughText:
	text "Not healthy"
	line "enough."
	prompt

_NewBadgeRequiredText:
WLA_GLOBAL_NewBadgeRequiredText:
	text "No! A new BADGE"
	line "is required."
	prompt

_CannotUseItemsHereText:
WLA_GLOBAL_CannotUseItemsHereText:
	text "You can't use items"
	line "here."
	prompt

_CannotGetOffHereText:
WLA_GLOBAL_CannotGetOffHereText:
	text "You can't get off"
	line "here."
	prompt

_GotMonText:
WLA_GLOBAL_GotMonText:
	text "<PLAYER> got"
	line "@"
	text_ram wNameBuffer
	text "!@"
	text_end

_SentToBoxText:
WLA_GLOBAL_SentToBoxText:
	text "There's no more"
	line "room for #MON!"
	cont "@"
	text_ram wBoxMonNicks
	text " was"
	cont "sent to #MON"
	cont "BOX @"
	text_ram wStringBuffer
	text " on PC!"
	done

_BoxIsFullText:
WLA_GLOBAL_BoxIsFullText:
	text "There's no more"
	line "room for #MON!"

	para "The #MON BOX"
	line "is full and can't"
	cont "accept any more!"

	para "Change the BOX at"
	line "a #MON CENTER!"
	done
