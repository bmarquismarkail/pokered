GameCorner_Script:
	call GameCornerSelectLuckySlotMachine
	call GameCornerSetRocketHideoutDoorTile
	call EnableAutoTextBoxDrawing
	ld hl, GameCorner_ScriptPointers
	ld a, [wGameCornerCurScript]
	jp CallFunctionInTable

GameCornerSelectLuckySlotMachine:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	ret z
	call Random
	ldh a, [lobyte(hRandomAdd)]
	cp $7
	jr nc, GameCornerSelectLuckySlotMachine.not_max
	ld a, $8
GameCornerSelectLuckySlotMachine.not_max
	srl a
	srl a
	srl a
	ld [wLuckySlotHiddenEventIndex], a
	ret

GameCornerSetRocketHideoutDoorTile:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	CheckEvent EVENT_FOUND_ROCKET_HIDEOUT
	ret nz
	ld a, $2a
	ld [wNewTileBlockID], a
	lb "bc", 2, 8
	predef_jump ReplaceTileBlock

GameCornerReenterMapAfterPlayerLoss:
	xor a ; SCRIPT_GAMECORNER_DEFAULT
	ld [wJoyIgnore], a
	ld [wGameCornerCurScript], a
	ld [wCurMapScript], a
	ret

GameCorner_ScriptPointers:
	def_script_pointers
	dw_const GameCornerDefaultScript,      SCRIPT_GAMECORNER_DEFAULT
	dw_const GameCornerRocketBattleScript, SCRIPT_GAMECORNER_ROCKET_BATTLE
	dw_const GameCornerRocketExitScript,   SCRIPT_GAMECORNER_ROCKET_EXIT

GameCornerDefaultScript:
	ret

GameCornerRocketBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, GameCornerReenterMapAfterPlayerLoss
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_GAMECORNER_ROCKET_AFTER_BATTLE
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, GAMECORNER_ROCKET
	ldh [lobyte(hSpriteIndex)], a
	call SetSpriteMovementBytesToFF
	ld de, GameCornerMovement_Rocket_WalkAroundPlayer
	ld a, [wYCoord]
	cp 6
	jr nz, GameCornerRocketBattleScript.not_direct_movement
	ld de, GameCornerMovement_Rocket_WalkDirect
	jr GameCornerRocketBattleScript.got_rocket_movement
GameCornerRocketBattleScript.not_direct_movement
	ld a, [wXCoord]
	cp 8
	jr nz, GameCornerRocketBattleScript.got_rocket_movement
	ld de, GameCornerMovement_Rocket_WalkDirect
GameCornerRocketBattleScript.got_rocket_movement
	ld a, GAMECORNER_ROCKET
	ldh [lobyte(hSpriteIndex)], a
	call MoveSprite
	ld a, SCRIPT_GAMECORNER_ROCKET_EXIT
	ld [wGameCornerCurScript], a
	ret

GameCornerMovement_Rocket_WalkAroundPlayer:
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB -1 ; end

GameCornerMovement_Rocket_WalkDirect:
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB -1 ; end

GameCornerRocketExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, TOGGLE_GAME_CORNER_ROCKET
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	set BIT_CUR_MAP_LOADED_2, [hl]
	ld a, SCRIPT_GAMECORNER_DEFAULT
	ld [wGameCornerCurScript], a
	ret

GameCorner_TextPointers:
	def_text_pointers
	dw_const GameCornerBeauty1Text,           TEXT_GAMECORNER_BEAUTY1
	dw_const GameCornerClerk1Text,            TEXT_GAMECORNER_CLERK1
	dw_const GameCornerMiddleAgedMan1Text,    TEXT_GAMECORNER_MIDDLE_AGED_MAN1
	dw_const GameCornerBeauty2Text,           TEXT_GAMECORNER_BEAUTY2
	dw_const GameCornerFishingGuruText,       TEXT_GAMECORNER_FISHING_GURU
	dw_const GameCornerMiddleAgedWomanText,   TEXT_GAMECORNER_MIDDLE_AGED_WOMAN
	dw_const GameCornerGymGuideText,          TEXT_GAMECORNER_GYM_GUIDE
	dw_const GameCornerGamblerText,           TEXT_GAMECORNER_GAMBLER
	dw_const GameCornerClerk2Text,            TEXT_GAMECORNER_CLERK2
	dw_const GameCornerGentlemanText,         TEXT_GAMECORNER_GENTLEMAN
	dw_const GameCornerRocketText,            TEXT_GAMECORNER_ROCKET
	dw_const GameCornerPosterText,            TEXT_GAMECORNER_POSTER
	dw_const GameCornerRocketAfterBattleText, TEXT_GAMECORNER_ROCKET_AFTER_BATTLE

GameCornerBeauty1Text:
	text_far WLA_GLOBAL_GameCornerBeauty1Text
	text_end

GameCornerClerk1Text:
	text_asm
	; Show player's coins
	call GameCornerDrawCoinBox
	ld hl, GameCornerClerk1Text.DoYouNeedSomeGameCoins
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, GameCornerClerk1Text.declined
	; Can only get more coins if you
	; - have the Coin Case
	ld b, COIN_CASE
	call IsItemInBag
	jr z, GameCornerClerk1Text.no_coin_case
	; - have room in the Coin Case for at least 9 coins
	call Has9990Coins
	jr nc, GameCornerClerk1Text.coin_case_full
	; - have at least 1000 yen
	xor a
	ldh [lobyte(hMoney)], a
	ldh [lobyte(hMoney + 2)], a
	ld a, $10
	ldh [lobyte(hMoney + 1)], a
	call HasEnoughMoney
	jr nc, GameCornerClerk1Text.buy_coins
	ld hl, GameCornerClerk1Text.CantAffordTheCoins
	jr GameCornerClerk1Text.print_ret
GameCornerClerk1Text.buy_coins
	; Spend 1000 yen
	xor a
	ldh [lobyte(hMoney)], a
	ldh [lobyte(hMoney + 2)], a
	ld a, $10
	ldh [lobyte(hMoney + 1)], a
	ld hl, hMoney + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	; Receive 50 coins
	xor a
	ldh [lobyte(hUnusedCoinsByte)], a
	ldh [lobyte(hCoins)], a
	ld a, $50
	ldh [lobyte(hCoins + 1)], a
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef
	; Update display
	call GameCornerDrawCoinBox
	ld hl, GameCornerClerk1Text.ThanksHereAre50Coins
	jr GameCornerClerk1Text.print_ret
GameCornerClerk1Text.declined
	ld hl, GameCornerClerk1Text.PleaseComePlaySometime
	jr GameCornerClerk1Text.print_ret
GameCornerClerk1Text.coin_case_full
	ld hl, GameCornerClerk1Text.CoinCaseIsFull
	jr GameCornerClerk1Text.print_ret
GameCornerClerk1Text.no_coin_case
	ld hl, GameCornerClerk1Text.DontHaveCoinCase
GameCornerClerk1Text.print_ret
	call PrintText
	jp TextScriptEnd

GameCornerClerk1Text.DoYouNeedSomeGameCoins:
	text_far WLA_GLOBAL_GameCornerClerk1DoYouNeedSomeGameCoinsText
	text_end

GameCornerClerk1Text.ThanksHereAre50Coins:
	text_far WLA_GLOBAL_GameCornerClerk1ThanksHereAre50CoinsText
	text_end

GameCornerClerk1Text.PleaseComePlaySometime:
	text_far WLA_GLOBAL_GameCornerClerk1PleaseComePlaySometimeText
	text_end

GameCornerClerk1Text.CantAffordTheCoins:
	text_far WLA_GLOBAL_GameCornerClerk1CantAffordTheCoinsText
	text_end

GameCornerClerk1Text.CoinCaseIsFull:
	text_far WLA_GLOBAL_GameCornerClerk1CoinCaseIsFullText
	text_end

GameCornerClerk1Text.DontHaveCoinCase:
	text_far WLA_GLOBAL_GameCornerClerk1DontHaveCoinCaseText
	text_end

GameCornerMiddleAgedMan1Text:
	text_far WLA_GLOBAL_GameCornerMiddleAgedMan1Text
	text_end

GameCornerBeauty2Text:
	text_far WLA_GLOBAL_GameCornerBeauty2Text
	text_end

GameCornerFishingGuruText:
	text_asm
	CheckEvent EVENT_GOT_10_COINS
	jr nz, GameCornerFishingGuruText.alreadyGotNpcCoins
	ld hl, GameCornerFishingGuruText.WantToPlayText
	call PrintText
	ld b, COIN_CASE
	call IsItemInBag
	jr z, GameCornerFishingGuruText.dontHaveCoinCase
	call Has9990Coins
	jr nc, GameCornerFishingGuruText.coinCaseFull
	xor a
	ldh [lobyte(hUnusedCoinsByte)], a
	ldh [lobyte(hCoins)], a
	ld a, $10
	ldh [lobyte(hCoins + 1)], a
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef
	SetEvent EVENT_GOT_10_COINS
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, GameCornerFishingGuruText.Received10CoinsText
	jr GameCornerFishingGuruText.print_ret
GameCornerFishingGuruText.alreadyGotNpcCoins
	ld hl, GameCornerFishingGuruText.WinsComeAndGoText
	jr GameCornerFishingGuruText.print_ret
GameCornerFishingGuruText.coinCaseFull
	ld hl, GameCornerFishingGuruText.DontNeedMyCoinsText
	jr GameCornerFishingGuruText.print_ret
GameCornerFishingGuruText.dontHaveCoinCase
	ld hl, GameCornerOopsForgotCoinCaseText
GameCornerFishingGuruText.print_ret
	call PrintText
	jp TextScriptEnd

GameCornerFishingGuruText.WantToPlayText:
	text_far WLA_GLOBAL_GameCornerFishingGuruWantToPlayText
	text_end

GameCornerFishingGuruText.Received10CoinsText:
	text_far WLA_GLOBAL_GameCornerFishingGuruReceived10CoinsText
	sound_get_item_1
	text_end

GameCornerFishingGuruText.DontNeedMyCoinsText:
	text_far WLA_GLOBAL_GameCornerFishingGuruDontNeedMyCoinsText
	text_end

GameCornerFishingGuruText.WinsComeAndGoText:
	text_far WLA_GLOBAL_GameCornerFishingGuruWinsComeAndGoText
	text_end

GameCornerMiddleAgedWomanText:
	text_far WLA_GLOBAL_GameCornerMiddleAgedWomanText
	text_end

GameCornerGymGuideText:
	text_asm
	CheckEvent EVENT_BEAT_ERIKA
	ld hl, GameCornerGymGuideChampInMakingText
	jr z, GameCornerGymGuideText.not_defeated
	ld hl, GameCornerGymGuideTheyOfferRarePokemonText
GameCornerGymGuideText.not_defeated
	call PrintText
	jp TextScriptEnd

GameCornerGymGuideChampInMakingText:
	text_far WLA_GLOBAL_GameCornerGymGuideChampInMakingText
	text_end

GameCornerGymGuideTheyOfferRarePokemonText:
	text_far WLA_GLOBAL_GameCornerGymGuideTheyOfferRarePokemonText
	text_end

GameCornerGamblerText:
	text_far WLA_GLOBAL_GameCornerGamblerText
	text_end

GameCornerClerk2Text:
	text_asm
	CheckEvent EVENT_GOT_20_COINS_2
	jr nz, GameCornerClerk2Text.alreadyGotNpcCoins
	ld hl, GameCornerClerk2Text.WantSomeCoinsText
	call PrintText
	ld b, COIN_CASE
	call IsItemInBag
	jr z, GameCornerClerk2Text.dontHaveCoinCase
	call Has9990Coins
	jr nc, GameCornerClerk2Text.coinCaseFull
	xor a
	ldh [lobyte(hUnusedCoinsByte)], a
	ldh [lobyte(hCoins)], a
	ld a, $20
	ldh [lobyte(hCoins + 1)], a
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef
	SetEvent EVENT_GOT_20_COINS_2
	ld hl, GameCornerClerk2Text.Received20CoinsText
	jr GameCornerClerk2Text.print_ret
GameCornerClerk2Text.alreadyGotNpcCoins
	ld hl, GameCornerClerk2Text.INeedMoreCoinsText
	jr GameCornerClerk2Text.print_ret
GameCornerClerk2Text.coinCaseFull
	ld hl, GameCornerClerk2Text.YouHaveLotsOfCoinsText
	jr GameCornerClerk2Text.print_ret
GameCornerClerk2Text.dontHaveCoinCase
	ld hl, GameCornerOopsForgotCoinCaseText
GameCornerClerk2Text.print_ret
	call PrintText
	jp TextScriptEnd

GameCornerClerk2Text.WantSomeCoinsText:
	text_far WLA_GLOBAL_GameCornerClerk2WantSomeCoinsText
	text_end

GameCornerClerk2Text.Received20CoinsText:
	text_far WLA_GLOBAL_GameCornerClerk2Received20CoinsText
	sound_get_item_1
	text_end

GameCornerClerk2Text.YouHaveLotsOfCoinsText:
	text_far WLA_GLOBAL_GameCornerClerk2YouHaveLotsOfCoinsText
	text_end

GameCornerClerk2Text.INeedMoreCoinsText:
	text_far WLA_GLOBAL_GameCornerClerk2INeedMoreCoinsText
	text_end

GameCornerGentlemanText:
	text_asm
	CheckEvent EVENT_GOT_20_COINS
	jr nz, GameCornerGentlemanText.alreadyGotNpcCoins
	ld hl, GameCornerGentlemanText.ThrowingMeOffText
	call PrintText
	ld b, COIN_CASE
	call IsItemInBag
	jr z, GameCornerGentlemanText.dontHaveCoinCase
	call Has9990Coins
	jr z, GameCornerGentlemanText.coinCaseFull
	xor a
	ldh [lobyte(hUnusedCoinsByte)], a
	ldh [lobyte(hCoins)], a
	ld a, $20
	ldh [lobyte(hCoins + 1)], a
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef
	SetEvent EVENT_GOT_20_COINS
	ld hl, GameCornerGentlemanText.Received20CoinsText
	jr GameCornerGentlemanText.print_ret
GameCornerGentlemanText.alreadyGotNpcCoins
	ld hl, GameCornerGentlemanText.CloselyWatchTheReelsText
	jr GameCornerGentlemanText.print_ret
GameCornerGentlemanText.coinCaseFull
	ld hl, GameCornerGentlemanText.YouGotYourOwnCoinsText
	jr GameCornerGentlemanText.print_ret
GameCornerGentlemanText.dontHaveCoinCase
	ld hl, GameCornerOopsForgotCoinCaseText
GameCornerGentlemanText.print_ret
	call PrintText
	jp TextScriptEnd

GameCornerGentlemanText.ThrowingMeOffText:
	text_far WLA_GLOBAL_GameCornerGentlemanThrowingMeOffText
	text_end

GameCornerGentlemanText.Received20CoinsText:
	text_far WLA_GLOBAL_GameCornerGentlemanReceived20CoinsText
	sound_get_item_1
	text_end

GameCornerGentlemanText.YouGotYourOwnCoinsText:
	text_far WLA_GLOBAL_GameCornerGentlemanYouGotYourOwnCoinsText
	text_end

GameCornerGentlemanText.CloselyWatchTheReelsText:
	text_far WLA_GLOBAL_GameCornerGentlemanCloselyWatchTheReelsText
	text_end

GameCornerRocketText:
	text_asm
	ld hl, GameCornerRocketText.ImGuardingThisPosterText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, GameCornerRocketText.BattleEndText
	ld de, GameCornerRocketText.BattleEndText
	call SaveEndBattleTextPointers
	ldh a, [lobyte(hSpriteIndex)]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	xor a
	ldh [lobyte(hJoyHeld)], a
	ldh [lobyte(hJoyPressed)], a
	ldh [lobyte(hJoyReleased)], a
	ld a, SCRIPT_GAMECORNER_ROCKET_BATTLE
	ld [wGameCornerCurScript], a
	jp TextScriptEnd

GameCornerRocketText.ImGuardingThisPosterText:
	text_far WLA_GLOBAL_GameCornerRocketImGuardingThisPosterText
	text_end

GameCornerRocketText.BattleEndText:
	text_far WLA_GLOBAL_GameCornerRocketBattleEndText
	text_end

GameCornerRocketAfterBattleText:
	text_far WLA_GLOBAL_GameCornerRocketAfterBattleText
	text_end

GameCornerPosterText:
	text_asm
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, GameCornerPosterText.SwitchBehindPosterText
	call PrintText
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	call PlaySound
	call WaitForSoundToFinish
	SetEvent EVENT_FOUND_ROCKET_HIDEOUT
	ld a, $43
	ld [wNewTileBlockID], a
	lb "bc", 2, 8
	predef ReplaceTileBlock
	jp TextScriptEnd

GameCornerPosterText.SwitchBehindPosterText:
	text_far WLA_GLOBAL_GameCornerPosterSwitchBehindPosterText
	text_asm
	ld a, SFX_SWITCH
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

GameCornerOopsForgotCoinCaseText:
	text_far WLA_GLOBAL_GameCornerOopsForgotCoinCaseText
	text_end

GameCornerDrawCoinBox:
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 11, 0
	ld b, 5
	ld c, 7
	call TextBoxBorder
	call UpdateSprites
	hlcoord 12, 1
	ld b, 4
	ld c, 7
	call ClearScreenArea
	hlcoord 12, 2
	ld de, GameCornerMoneyText
	call PlaceString
	hlcoord 12, 3
	ld de, GameCornerBlankText1
	call PlaceString
	hlcoord 12, 3
	ld de, wPlayerMoney
	ld c, 3 | MONEY_SIGN | LEADING_ZEROES
	call PrintBCDNumber
	hlcoord 12, 4
	ld de, GameCornerCoinText
	call PlaceString
	hlcoord 12, 5
	ld de, GameCornerBlankText2
	call PlaceString
	hlcoord 15, 5
	ld de, wPlayerCoins
	ld c, 2 | LEADING_ZEROES
	call PrintBCDNumber
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ret

GameCornerMoneyText:
		.STRINGMAP pokemon, "MONEY@"

GameCornerCoinText:
		.STRINGMAP pokemon, "COIN@"

GameCornerBlankText1:
		.STRINGMAP pokemon, "       @"

GameCornerBlankText2:
		.STRINGMAP pokemon, "       @"

Has9990Coins:
	ld a, $99
	ldh [lobyte(hCoins)], a
	ld a, $90
	ldh [lobyte(hCoins + 1)], a
	jp HasEnoughCoins
