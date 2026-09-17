BattleCore:

.INCLUDE "data/battle/residual_effects_1.asm"
.INCLUDE "data/battle/set_damage_effects.asm"
.INCLUDE "data/battle/residual_effects_2.asm"
.INCLUDE "data/battle/always_happen_effects.asm"
.INCLUDE "data/battle/special_effects.asm"

SlidePlayerAndEnemySilhouettesOnScreen:
	call LoadPlayerBackPic
	ld a, MESSAGE_BOX ; the usual text box at the bottom of the screen
	ld [wTextBoxID], a
	call DisplayTextBoxID
	hlcoord 1, 5
	lb "bc", 3, 7
	call ClearScreenArea
	call DisableLCD
	call LoadFontTilePatterns
	call LoadHudAndHpBarAndStatusTilePatterns
	ld hl, vBGMap0
	ld bc, TILEMAP_AREA
SlidePlayerAndEnemySilhouettesOnScreen.clearBackgroundLoop
	ld a, $7f
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, SlidePlayerAndEnemySilhouettesOnScreen.clearBackgroundLoop
; copy the work RAM tile map to VRAM
	hlcoord 0, 0
	ld de, vBGMap0
	ld b, SCREEN_HEIGHT
SlidePlayerAndEnemySilhouettesOnScreen.copyRowLoop
	ld c, SCREEN_WIDTH
SlidePlayerAndEnemySilhouettesOnScreen.copyColumnLoop
	ld a, [hli]
	ld [de], a
	inc e
	dec c
	jr nz, SlidePlayerAndEnemySilhouettesOnScreen.copyColumnLoop
	ld a, 12 ; number of off screen tiles to the right of screen in VRAM
	add e ; skip the off screen tiles
	ld e, a
	jr nc, SlidePlayerAndEnemySilhouettesOnScreen.noCarry
	inc d
SlidePlayerAndEnemySilhouettesOnScreen.noCarry
	dec b
	jr nz, SlidePlayerAndEnemySilhouettesOnScreen.copyRowLoop
	call EnableLCD
	ld a, $90
	ldh [lobyte(hWY)], a
	ldh [lobyte(rWY)], a
	xor a
	ldh [lobyte(hTileAnimations)], a
	ldh [lobyte(hSCY)], a
	dec a
	ld [wUpdateSpritesEnabled], a
	call Delay3
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld b, $70
	ld c, $90
	ld a, c
	ldh [lobyte(hSCX)], a
	call DelayFrame
	ld a, %11100100 ; inverted palette for silhouette effect
	ldh [lobyte(rBGP)], a
	ldh [lobyte(rOBP0)], a
	ldh [lobyte(rOBP1)], a
SlidePlayerAndEnemySilhouettesOnScreen.slideSilhouettesLoop ; slide silhouettes of the player's pic and the enemy's pic onto the screen
	ld h, b
	ld l, $40
	call SetScrollXForSlidingPlayerBodyLeft ; begin background scrolling on line $40
	inc b
	inc b
	ld h, $0
	ld l, $60
	call SetScrollXForSlidingPlayerBodyLeft ; end background scrolling on line $60
	call SlidePlayerHeadLeft
	ld a, c
	ldh [lobyte(hSCX)], a
	dec c
	dec c
	jr nz, SlidePlayerAndEnemySilhouettesOnScreen.slideSilhouettesLoop
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld a, $31
	ldh [lobyte(hStartTileID)], a
	hlcoord 1, 5
	predef CopyUncompressedPicToTilemap
	xor a
	ldh [lobyte(hWY)], a
	ldh [lobyte(rWY)], a
	inc a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call Delay3
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	call HideSprites
	jpfar PrintBeginningBattleText

; when a battle is starting, silhouettes of the player's pic and the enemy's pic are slid onto the screen
; the lower of the player's pic (his body) is part of the background, but his head is a sprite
; the reason for this is that it shares Y coordinates with the lower part of the enemy pic, so background scrolling wouldn't work for both pics
; instead, the enemy pic is part of the background and uses the scroll register, while the player's head is a sprite and is slid by changing its X coordinates in a loop
SlidePlayerHeadLeft:
	push bc
	ld hl, wShadowOAMSprite00XCoord
	ld c, 7 * 3 ; number of OAM entries
	ld de, OBJ_SIZE
SlidePlayerHeadLeft.loop
	dec [hl] ; decrement X
	dec [hl] ; decrement X
	add hl, de ; next OAM entry
	dec c
	jr nz, SlidePlayerHeadLeft.loop
	pop bc
	ret

SetScrollXForSlidingPlayerBodyLeft:
	ldh a, [lobyte(rLY)]
	cp l
	jr nz, SetScrollXForSlidingPlayerBodyLeft
	ld a, h
	ldh [lobyte(rSCX)], a
SetScrollXForSlidingPlayerBodyLeft.loop
	ldh a, [lobyte(rLY)]
	cp h
	jr z, SetScrollXForSlidingPlayerBodyLeft.loop
	ret

StartBattle:
	xor a
	ld [wPartyGainExpFlags], a
	ld [wPartyFoughtCurrentEnemyFlags], a
	ld [wActionResultOrTookBattleTurn], a
	inc a
	ld [wFirstMonsNotOutYet], a
	ld hl, wEnemyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH - 1
	ld d, $3
StartBattle.findFirstAliveEnemyMonLoop
	inc d
	ld a, [hli]
	or [hl]
	jr nz, StartBattle.foundFirstAliveEnemyMon
	add hl, bc
	jr StartBattle.findFirstAliveEnemyMonLoop
StartBattle.foundFirstAliveEnemyMon
	ld a, d
	ld [wSerialExchangeNybbleReceiveData], a
	ld a, [wIsInBattle]
	dec a ; is it a trainer battle?
	call nz, EnemySendOutFirstMon ; if it is a trainer battle, send out enemy mon
	ld c, 40
	call DelayFrames
	call SaveScreenTilesToBuffer1
StartBattle.checkAnyPartyAlive
	call AnyPartyAlive
	ld a, d
	and a
	jp z, HandlePlayerBlackOut ; jump if no mon is alive
	call LoadScreenTilesFromBuffer1
	ld a, [wBattleType]
	and a ; is it a normal battle?
	jp z, StartBattle.playerSendOutFirstMon ; if so, send out player mon
; safari zone battle
StartBattle.displaySafariZoneBattleMenu
	call DisplayBattleMenu
	ret c ; return if the player ran from battle
	ld a, [wActionResultOrTookBattleTurn]
	and a ; was the item used successfully?
	jr z, StartBattle.displaySafariZoneBattleMenu ; if not, display the menu again; XXX does this ever jump?
	ld a, [wNumSafariBalls]
	and a
	jr nz, StartBattle.notOutOfSafariBalls
	call LoadScreenTilesFromBuffer1
	ld hl, StartBattle.outOfSafariBallsText
	jp PrintText
StartBattle.notOutOfSafariBalls
	callfar PrintSafariZoneBattleText
	ld a, [wEnemyMonSpeed + 1]
	add a
	ld b, a ; init b (which is later compared with random value) to (enemy speed % 256) * 2
	jp c, EnemyRan ; if (enemy speed % 256) > 127, the enemy runs
	ld a, [wSafariBaitFactor]
	and a ; is bait factor 0?
	jr z, StartBattle.checkEscapeFactor
; bait factor is not 0
; divide b by 4 (making the mon less likely to run)
	srl b
	srl b
StartBattle.checkEscapeFactor
	ld a, [wSafariEscapeFactor]
	and a ; is escape factor 0?
	jr z, StartBattle.compareWithRandomValue
; escape factor is not 0
; multiply b by 2 (making the mon more likely to run)
	sla b
	jr nc, StartBattle.compareWithRandomValue
; cap b at 255
	ld b, $ff
StartBattle.compareWithRandomValue
	call Random
	cp b
	jr nc, StartBattle.checkAnyPartyAlive
	jr EnemyRan ; if b was greater than the random value, the enemy runs

StartBattle.outOfSafariBallsText
	text_far WLA_GLOBAL_OutOfSafariBallsText
	text_end

StartBattle.playerSendOutFirstMon
	xor a
	ld [wWhichPokemon], a
StartBattle.findFirstAliveMonLoop
	call HasMonFainted
	jr nz, StartBattle.foundFirstAliveMon
; fainted, go to the next one
	ld hl, wWhichPokemon
	inc [hl]
	jr StartBattle.findFirstAliveMonLoop
StartBattle.foundFirstAliveMon
	ld a, [wWhichPokemon]
	ld [wPlayerMonNumber], a
	inc a
	ld hl, wPartySpecies - 1
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl] ; species
	ld [wCurPartySpecies], a
	ld [wBattleMonSpecies2], a
	call LoadScreenTilesFromBuffer1
	hlcoord 1, 5
	ld a, $9
	call SlideTrainerPicOffScreen
	call SaveScreenTilesToBuffer1
	ld a, [wWhichPokemon]
	ld c, a
	ld b, FLAG_SET
	push bc
	ld hl, wPartyGainExpFlags
	predef FlagActionPredef
	ld hl, wPartyFoughtCurrentEnemyFlags
	pop bc
	predef FlagActionPredef
	call LoadBattleMonFromParty
	call LoadScreenTilesFromBuffer1
	call SendOutMon
	jr MainInBattleLoop

; wild mon or link battle enemy ran from battle
EnemyRan:
	call LoadScreenTilesFromBuffer1
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ld hl, WildRanText
	jr nz, EnemyRan.printText
; link battle
	xor a
	ld [wBattleResult], a
	ld hl, EnemyRanText
EnemyRan.printText
	call PrintText
	ld a, SFX_RUN
	call PlaySoundWaitForCurrent
	xor a
	ldh [lobyte(hWhoseTurn)], a
	jpfar AnimationSlideEnemyMonOff

WildRanText:
	text_far WLA_GLOBAL_WildRanText
	text_end

EnemyRanText:
	text_far WLA_GLOBAL_EnemyRanText
	text_end

MainInBattleLoop:
	call ReadPlayerMonCurHPAndStatus
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl] ; is battle mon HP 0?
	jp z, HandlePlayerMonFainted  ; if battle mon HP is 0, jump
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl] ; is enemy mon HP 0?
	jp z, HandleEnemyMonFainted ; if enemy mon HP is 0, jump
	call SaveScreenTilesToBuffer1
	xor a
	ld [wFirstMonsNotOutYet], a
	ld a, [wPlayerBattleStatus2]
	and (1 << NEEDS_TO_RECHARGE) | (1 << USING_RAGE) ; check if the player is using Rage or needs to recharge
	jr nz, MainInBattleLoop.selectEnemyMove
; the player is not using Rage and doesn't need to recharge
	ld hl, wEnemyBattleStatus1
	res FLINCHED, [hl] ; reset flinch bit
	ld hl, wPlayerBattleStatus1
	res FLINCHED, [hl] ; reset flinch bit
	ld a, [hl]
	and (1 << THRASHING_ABOUT) | (1 << CHARGING_UP) ; check if the player is thrashing about or charging for an attack
	jr nz, MainInBattleLoop.selectEnemyMove ; if so, jump
; the player is neither thrashing about nor charging for an attack
	call DisplayBattleMenu ; show battle menu
	ret c ; return if player ran from battle
	ld a, [wEscapedFromBattle]
	and a
	ret nz ; return if pokedoll was used to escape from battle
	ld a, [wBattleMonStatus]
	and (1 << FRZ) | SLP_MASK
	jr nz, MainInBattleLoop.selectEnemyMove ; if so, jump
	ld a, [wPlayerBattleStatus1]
	and (1 << STORING_ENERGY) | (1 << USING_TRAPPING_MOVE) ; check player is using Bide or using a multi-turn attack like wrap
	jr nz, MainInBattleLoop.selectEnemyMove ; if so, jump
	ld a, [wEnemyBattleStatus1]
	bit USING_TRAPPING_MOVE, a ; check if enemy is using a multi-turn attack like wrap
	jr z, MainInBattleLoop.selectPlayerMove ; if not, jump
; enemy is using a multi-turn attack like wrap, so player is trapped and cannot execute a move
	ld a, CANNOT_MOVE
	ld [wPlayerSelectedMove], a
	jr MainInBattleLoop.selectEnemyMove
MainInBattleLoop.selectPlayerMove
	ld a, [wActionResultOrTookBattleTurn]
	and a ; has the player already used the turn (e.g. by using an item, trying to run or switching pokemon)
	jr nz, MainInBattleLoop.selectEnemyMove
	ld [wMoveMenuType], a
	inc a
	ld [wAnimationID], a
	xor a
	ld [wMenuItemToSwap], a
	call MoveSelectionMenu
	push af
	call LoadScreenTilesFromBuffer1
	call DrawHUDsAndHPBars
	pop af
	jr nz, MainInBattleLoop ; if the player didn't select a move, jump
MainInBattleLoop.selectEnemyMove
	call SelectEnemyMove
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, MainInBattleLoop.noLinkBattle
; link battle
	ld a, [wSerialExchangeNybbleReceiveData]
	cp LINKBATTLE_RUN
	jp z, EnemyRan
	cp LINKBATTLE_STRUGGLE
	jr z, MainInBattleLoop.noLinkBattle
	cp LINKBATTLE_NO_ACTION
	jr z, MainInBattleLoop.noLinkBattle
	sub 4
	jr c, MainInBattleLoop.noLinkBattle
; the link battle enemy has switched mons
	ld a, [wPlayerBattleStatus1]
	bit USING_TRAPPING_MOVE, a ; check if using multi-turn move like Wrap
	jr z, MainInBattleLoop.specialMoveNotUsed
	ld a, [wPlayerMoveListIndex]
	ld hl, wBattleMonMoves
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp METRONOME ; a MIRROR MOVE check is missing, might lead to a desync in link battles
	             ; when combined with multi-turn moves
	jr nz, MainInBattleLoop.specialMoveNotUsed
	ld [wPlayerSelectedMove], a
MainInBattleLoop.specialMoveNotUsed
	callfar SwitchEnemyMon
MainInBattleLoop.noLinkBattle
	ld a, [wPlayerSelectedMove]
	cp QUICK_ATTACK
	jr nz, MainInBattleLoop.playerDidNotUseQuickAttack
	ld a, [wEnemySelectedMove]
	cp QUICK_ATTACK
	jr z, MainInBattleLoop.compareSpeed  ; if both used Quick Attack
	jp MainInBattleLoop.playerMovesFirst ; if player used Quick Attack and enemy didn't
MainInBattleLoop.playerDidNotUseQuickAttack
	ld a, [wEnemySelectedMove]
	cp QUICK_ATTACK
	jr z, MainInBattleLoop.enemyMovesFirst ; if enemy used Quick Attack and player didn't
	ld a, [wPlayerSelectedMove]
	cp COUNTER
	jr nz, MainInBattleLoop.playerDidNotUseCounter
	ld a, [wEnemySelectedMove]
	cp COUNTER
	jr z, MainInBattleLoop.compareSpeed ; if both used Counter
	jr MainInBattleLoop.enemyMovesFirst ; if player used Counter and enemy didn't
MainInBattleLoop.playerDidNotUseCounter
	ld a, [wEnemySelectedMove]
	cp COUNTER
	jr z, MainInBattleLoop.playerMovesFirst ; if enemy used Counter and player didn't
MainInBattleLoop.compareSpeed
	ld de, wBattleMonSpeed ; player speed value
	ld hl, wEnemyMonSpeed ; enemy speed value
	ld c, $2
	call StringCmp ; compare speed values
	jr z, MainInBattleLoop.speedEqual
	jr nc, MainInBattleLoop.playerMovesFirst ; if player is faster
	jr MainInBattleLoop.enemyMovesFirst ; if enemy is faster
MainInBattleLoop.speedEqual ; 50/50 chance for both players
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_INTERNAL_CLOCK
	jr z, MainInBattleLoop.invertOutcome
	call BattleRandom
	cp (50 * $ff / 100) + 1
	jr c, MainInBattleLoop.playerMovesFirst
	jr MainInBattleLoop.enemyMovesFirst
MainInBattleLoop.invertOutcome
	call BattleRandom
	cp (50 * $ff / 100) + 1
	jr c, MainInBattleLoop.enemyMovesFirst
	jr MainInBattleLoop.playerMovesFirst
MainInBattleLoop.enemyMovesFirst
	ld a, $1
	ldh [lobyte(hWhoseTurn)], a
	callfar TrainerAI
	jr c, MainInBattleLoop.AIActionUsedEnemyFirst
	call ExecuteEnemyMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Roar, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandlePlayerMonFainted
MainInBattleLoop.AIActionUsedEnemyFirst
	call HandlePoisonBurnLeechSeed
	jp z, HandleEnemyMonFainted
	call DrawHUDsAndHPBars
	call ExecutePlayerMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Roar, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandleEnemyMonFainted
	call HandlePoisonBurnLeechSeed
	jp z, HandlePlayerMonFainted
	call DrawHUDsAndHPBars
	call CheckNumAttacksLeft
	jp MainInBattleLoop
MainInBattleLoop.playerMovesFirst
	call ExecutePlayerMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Roar, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandleEnemyMonFainted
	call HandlePoisonBurnLeechSeed
	jp z, HandlePlayerMonFainted
	call DrawHUDsAndHPBars
	ld a, $1
	ldh [lobyte(hWhoseTurn)], a
	callfar TrainerAI
	jr c, MainInBattleLoop.AIActionUsedPlayerFirst
	call ExecuteEnemyMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Roar, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandlePlayerMonFainted
MainInBattleLoop.AIActionUsedPlayerFirst
	call HandlePoisonBurnLeechSeed
	jp z, HandleEnemyMonFainted
	call DrawHUDsAndHPBars
	call CheckNumAttacksLeft
	jp MainInBattleLoop

HandlePoisonBurnLeechSeed:
	ld hl, wBattleMonHP
	ld de, wBattleMonStatus
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, HandlePoisonBurnLeechSeed.playersTurn
	ld hl, wEnemyMonHP
	ld de, wEnemyMonStatus
HandlePoisonBurnLeechSeed.playersTurn
	ld a, [de]
	and (1 << BRN) | (1 << PSN)
	jr z, HandlePoisonBurnLeechSeed.notBurnedOrPoisoned
	push hl
	ld hl, HurtByPoisonText
	ld a, [de]
	and 1 << BRN
	jr z, HandlePoisonBurnLeechSeed.poisoned
	ld hl, HurtByBurnText
HandlePoisonBurnLeechSeed.poisoned
	call PrintText
	xor a
	ld [wAnimationType], a
	ld a, BURN_PSN_ANIM
	call PlayMoveAnimation   ; play burn/poison animation
	pop hl
	call HandlePoisonBurnLeechSeed_DecreaseOwnHP
HandlePoisonBurnLeechSeed.notBurnedOrPoisoned
	ld de, wPlayerBattleStatus2
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, HandlePoisonBurnLeechSeed.playersTurn2
	ld de, wEnemyBattleStatus2
HandlePoisonBurnLeechSeed.playersTurn2
	ld a, [de]
	add a
	jr nc, HandlePoisonBurnLeechSeed.notLeechSeeded
	push hl
	ldh a, [lobyte(hWhoseTurn)]
	push af
	xor $1
	ldh [lobyte(hWhoseTurn)], a
	xor a
	ld [wAnimationType], a
	ld a, ABSORB
	call PlayMoveAnimation ; play leech seed animation (from opposing mon)
	pop af
	ldh [lobyte(hWhoseTurn)], a
	pop hl
	call HandlePoisonBurnLeechSeed_DecreaseOwnHP
	call HandlePoisonBurnLeechSeed_IncreaseEnemyHP
	push hl
	ld hl, HurtByLeechSeedText
	call PrintText
	pop hl
HandlePoisonBurnLeechSeed.notLeechSeeded
	ld a, [hli]
	or [hl]
	ret nz          ; test if fainted
	call DrawHUDsAndHPBars
	ld c, 20
	call DelayFrames
	xor a
	ret

HurtByPoisonText:
	text_far WLA_GLOBAL_HurtByPoisonText
	text_end

HurtByBurnText:
	text_far WLA_GLOBAL_HurtByBurnText
	text_end

HurtByLeechSeedText:
	text_far WLA_GLOBAL_HurtByLeechSeedText
	text_end

; decreases the mon's current HP by 1/16 of the Max HP (multiplied by number of toxic ticks if active)
; note that the toxic ticks are considered even if the damage is not poison (hence the Leech Seed glitch)
; hl: HP pointer
; bc (out): total damage
HandlePoisonBurnLeechSeed_DecreaseOwnHP:
	push hl
	push hl
	ld bc, $e      ; skip to max HP
	add hl, bc
	ld a, [hli]    ; load max HP
	ld [wHPBarMaxHP+1], a
	ld b, a
	ld a, [hl]
	ld [wHPBarMaxHP], a
	ld c, a
	srl b
	rr c
	srl b
	rr c
	srl c
	srl c         ; c = max HP/16 (assumption: HP < 1024)
	ld a, c
	and a
	jr nz, HandlePoisonBurnLeechSeed_DecreaseOwnHP.nonZeroDamage
	inc c         ; damage is at least 1
HandlePoisonBurnLeechSeed_DecreaseOwnHP.nonZeroDamage
	ld hl, wPlayerBattleStatus3
	ld de, wPlayerToxicCounter
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, HandlePoisonBurnLeechSeed_DecreaseOwnHP.playersTurn
	ld hl, wEnemyBattleStatus3
	ld de, wEnemyToxicCounter
HandlePoisonBurnLeechSeed_DecreaseOwnHP.playersTurn
	bit BADLY_POISONED, [hl]
	jr z, HandlePoisonBurnLeechSeed_DecreaseOwnHP.noToxic
	ld a, [de]    ; increment toxic counter
	inc a
	ld [de], a
	ld hl, 0
HandlePoisonBurnLeechSeed_DecreaseOwnHP.toxicTicksLoop
	add hl, bc
	dec a
	jr nz, HandlePoisonBurnLeechSeed_DecreaseOwnHP.toxicTicksLoop
	ld b, h       ; bc = damage * toxic counter
	ld c, l
HandlePoisonBurnLeechSeed_DecreaseOwnHP.noToxic
	pop hl
	inc hl
	ld a, [hl]    ; subtract total damage from current HP
	ld [wHPBarOldHP], a
	sub c
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	sbc b
	ld [hl], a
	ld [wHPBarNewHP+1], a
	jr nc, HandlePoisonBurnLeechSeed_DecreaseOwnHP.noOverkill
	xor a         ; overkill: zero HP
	ld [hli], a
	ld [hl], a
	ld [wHPBarNewHP], a
	ld [wHPBarNewHP+1], a
HandlePoisonBurnLeechSeed_DecreaseOwnHP.noOverkill
	call UpdateCurMonHPBar
	pop hl
	ret

; adds bc to enemy HP
; bc isn't updated if HP subtracted was capped to prevent overkill
HandlePoisonBurnLeechSeed_IncreaseEnemyHP:
	push hl
	ld hl, wEnemyMonMaxHP
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, HandlePoisonBurnLeechSeed_IncreaseEnemyHP.playersTurn
	ld hl, wBattleMonMaxHP
HandlePoisonBurnLeechSeed_IncreaseEnemyHP.playersTurn
	ld a, [hli]
	ld [wHPBarMaxHP+1], a
	ld a, [hl]
	ld [wHPBarMaxHP], a
	ld de, wBattleMonHP - wBattleMonMaxHP
	add hl, de           ; skip back from max hp to current hp
	ld a, [hl]
	ld [wHPBarOldHP], a ; add bc to current HP
	add c
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	adc b
	ld [hli], a
	ld [wHPBarNewHP+1], a
	ld a, [wHPBarMaxHP]
	ld c, a
	ld a, [hld]
	sub c
	ld a, [wHPBarMaxHP+1]
	ld b, a
	ld a, [hl]
	sbc b
	jr c, HandlePoisonBurnLeechSeed_IncreaseEnemyHP.noOverfullHeal
	ld a, b                ; overfull heal, set HP to max HP
	ld [hli], a
	ld [wHPBarNewHP+1], a
	ld a, c
	ld [hl], a
	ld [wHPBarNewHP], a
HandlePoisonBurnLeechSeed_IncreaseEnemyHP.noOverfullHeal
	ldh a, [lobyte(hWhoseTurn)]
	xor $1
	ldh [lobyte(hWhoseTurn)], a
	call UpdateCurMonHPBar
	ldh a, [lobyte(hWhoseTurn)]
	xor $1
	ldh [lobyte(hWhoseTurn)], a
	pop hl
	ret

UpdateCurMonHPBar:
	hlcoord 10, 9    ; tile pointer to player HP bar
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld a, $1
	jr z, UpdateCurMonHPBar.playersTurn
	hlcoord 2, 2    ; tile pointer to enemy HP bar
	xor a
UpdateCurMonHPBar.playersTurn
	push bc
	ld [wHPBarType], a
	predef UpdateHPBar2
	pop bc
	ret

CheckNumAttacksLeft:
	ld a, [wPlayerNumAttacksLeft]
	and a
	jr nz, CheckNumAttacksLeft.checkEnemy
; player has 0 attacks left
	ld hl, wPlayerBattleStatus1
	res USING_TRAPPING_MOVE, [hl] ; player not using multi-turn attack like wrap any more
CheckNumAttacksLeft.checkEnemy
	ld a, [wEnemyNumAttacksLeft]
	and a
	ret nz
; enemy has 0 attacks left
	ld hl, wEnemyBattleStatus1
	res USING_TRAPPING_MOVE, [hl] ; enemy not using multi-turn attack like wrap any more
	ret

HandleEnemyMonFainted:
	xor a
	ld [wInHandlePlayerMonFainted], a
	call FaintEnemyPokemon
	call AnyPartyAlive
	ld a, d
	and a
	jp z, HandlePlayerBlackOut ; if no party mons are alive, the player blacks out
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl] ; is battle mon HP zero?
	call nz, DrawPlayerHUDAndHPBar ; if battle mon HP is not zero, draw player HD and HP bar
	ld a, [wIsInBattle]
	dec a
	ret z ; return if it's a wild battle
	call AnyEnemyPokemonAliveCheck
	jp z, TrainerBattleVictory
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl] ; does battle mon have 0 HP?
	jr nz, HandleEnemyMonFainted.skipReplacingBattleMon ; if not, skip replacing battle mon
	call DoUseNextMonDialogue ; this call is useless in a trainer battle. it shouldn't be here
	ret c
	call ChooseNextMon
HandleEnemyMonFainted.skipReplacingBattleMon
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	call ReplaceFaintedEnemyMon
	jp z, EnemyRan
	xor a
	ld [wActionResultOrTookBattleTurn], a
	jp MainInBattleLoop

FaintEnemyPokemon:
	call ReadPlayerMonCurHPAndStatus
	ld a, [wIsInBattle]
	dec a
	jr z, FaintEnemyPokemon.wild
	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	xor a
	ld [hli], a
	ld [hl], a
FaintEnemyPokemon.wild
	ld hl, wPlayerBattleStatus1
	res ATTACKING_MULTIPLE_TIMES, [hl]
; Bug. This only zeroes the high byte of the player's accumulated damage,
; setting the accumulated damage to itself mod 256 instead of 0 as was probably
; intended. That alone is problematic, but this mistake has another more severe
; effect. This function's counterpart for when the player mon faints,
; RemoveFaintedPlayerMon, zeroes both the high byte and the low byte. In a link
; battle, the other player's Game Boy will call that function in response to
; the enemy mon (the player mon from the other side's perspective) fainting,
; and the states of the two Game Boys will go out of sync unless the damage
; was congruent to 0 modulo 256.
	xor a
	ld [wPlayerBideAccumulatedDamage], a
	ld hl, wEnemyStatsToDouble ; clear enemy statuses
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wEnemyDisabledMove], a
	ld [wEnemyDisabledMoveNumber], a
	ld [wEnemyMonMinimized], a
	ld hl, wPlayerUsedMove
	ld [hli], a
	ld [hl], a
	hlcoord 12, 5
	decoord 12, 6
	call SlideDownFaintedMonPic
	hlcoord 0, 0
	lb "bc", 4, 11
	call ClearScreenArea
	ld a, [wIsInBattle]
	dec a
	jr z, FaintEnemyPokemon.wild_win
	xor a
	ld [wFrequencyModifier], a
	ld [wTempoModifier], a
	ld a, SFX_FAINT_FALL
	call PlaySoundWaitForCurrent
FaintEnemyPokemon.sfxwait
	ld a, [wChannelSoundIDs + CHAN5]
	cp SFX_FAINT_FALL
	jr z, FaintEnemyPokemon.sfxwait
	ld a, SFX_FAINT_THUD
	call PlaySound
	call WaitForSoundToFinish
	jr FaintEnemyPokemon.sfxplayed
FaintEnemyPokemon.wild_win
	call EndLowHealthAlarm
	ld a, MUSIC_DEFEATED_WILD_MON
	call PlayBattleVictoryMusic
FaintEnemyPokemon.sfxplayed
; bug: win sfx is played for wild battles before checking for player mon HP
; this can lead to odd scenarios where both player and enemy faint, as the win sfx plays yet the player never won the battle
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, FaintEnemyPokemon.playermonnotfaint
	ld a, [wInHandlePlayerMonFainted]
	and a ; was this called by HandlePlayerMonFainted?
	jr nz, FaintEnemyPokemon.playermonnotfaint ; if so, don't call RemoveFaintedPlayerMon twice
	call RemoveFaintedPlayerMon
FaintEnemyPokemon.playermonnotfaint
	call AnyPartyAlive
	ld a, d
	and a
	ret z
	ld hl, EnemyMonFaintedText
	call PrintText
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
	xor a
	ld [wBattleResult], a
	ld b, EXP_ALL
	call IsItemInBag
	push af
	jr z, FaintEnemyPokemon.giveExpToMonsThatFought ; if no exp all, then jump

; the player has exp all
; first, we halve the values that determine exp gain
; the enemy mon base stats are added to stat exp, so they are halved
; the base exp (which determines normal exp) is also halved
	ld hl, wEnemyMonBaseStats
	ld b, NUM_STATS + 2
FaintEnemyPokemon.halveExpDataLoop
	srl [hl]
	inc hl
	dec b
	jr nz, FaintEnemyPokemon.halveExpDataLoop

; give exp (divided evenly) to the mons that actually fought in battle against the enemy mon that has fainted
; if exp all is in the bag, this will be only be half of the stat exp and normal exp, due to the above loop
FaintEnemyPokemon.giveExpToMonsThatFought
	xor a
	ld [wBoostExpByExpAll], a
	callfar GainExperience
	pop af
	ret z ; return if no exp all

; the player has exp all
; now, set the gain exp flag for every party member
; half of the total stat exp and normal exp will divided evenly amongst every party member
	ld a, TRUE
	ld [wBoostExpByExpAll], a
	ld a, [wPartyCount]
	ld b, 0
FaintEnemyPokemon.gainExpFlagsLoop
	scf
	rl b
	dec a
	jr nz, FaintEnemyPokemon.gainExpFlagsLoop
	ld a, b
	ld [wPartyGainExpFlags], a
	jpfar GainExperience

EnemyMonFaintedText:
	text_far WLA_GLOBAL_EnemyMonFaintedText
	text_end

EndLowHealthAlarm:
; This function is called when the player has the won the battle. It turns off
; the low health alarm and prevents it from reactivating until the next battle.
	xor a
	ld [wLowHealthAlarm], a ; turn off low health alarm
	ld [wChannelSoundIDs + CHAN5], a
	inc a
	ld [wLowHealthAlarmDisabled], a ; prevent it from reactivating
	ret

AnyEnemyPokemonAliveCheck:
	ld a, [wEnemyPartyCount]
	ld b, a
	xor a
	ld hl, wEnemyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH
AnyEnemyPokemonAliveCheck.nextPokemon
	or [hl]
	inc hl
	or [hl]
	dec hl
	add hl, de
	dec b
	jr nz, AnyEnemyPokemonAliveCheck.nextPokemon
	and a
	ret

; stores whether enemy ran in Z flag
ReplaceFaintedEnemyMon:
	ld hl, wEnemyHPBarColor
	ld e, $30
	call GetBattleHealthBarColor
	callfar DrawEnemyPokeballs
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, ReplaceFaintedEnemyMon.notLinkBattle
; link battle
	call LinkBattleExchangeData
	ld a, [wSerialExchangeNybbleReceiveData]
	cp LINKBATTLE_RUN
	ret z
	call LoadScreenTilesFromBuffer1
ReplaceFaintedEnemyMon.notLinkBattle
	call EnemySendOut
	xor a
	ld [wEnemyMoveNum], a
	ld [wActionResultOrTookBattleTurn], a
	ld [wAILayer2Encouragement], a
	inc a ; reset Z flag
	ret

TrainerBattleVictory:
	call EndLowHealthAlarm
	ld b, MUSIC_DEFEATED_GYM_LEADER
	ld a, [wGymLeaderNo]
	and a
	jr nz, TrainerBattleVictory.gymleader
	ld b, MUSIC_DEFEATED_TRAINER
TrainerBattleVictory.gymleader
	ld a, [wTrainerClass]
	cp RIVAL3 ; final battle against rival
	jr nz, TrainerBattleVictory.notrival
	ld b, MUSIC_DEFEATED_GYM_LEADER
	ld hl, wStatusFlags7
	set BIT_NO_MAP_MUSIC, [hl]
TrainerBattleVictory.notrival
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ld a, b
	call nz, PlayBattleVictoryMusic
	ld hl, TrainerDefeatedText
	call PrintText
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z
	call ScrollTrainerPicAfterBattle
	ld c, 40
	call DelayFrames
	call PrintEndBattleText
; win money
	ld hl, MoneyForWinningText
	call PrintText
	ld de, wPlayerMoney + 2
	ld hl, wAmountMoneyWon + 2
	ld c, $3
	predef_jump AddBCDPredef

MoneyForWinningText:
	text_far WLA_GLOBAL_MoneyForWinningText
	text_end

TrainerDefeatedText:
	text_far WLA_GLOBAL_TrainerDefeatedText
	text_end

PlayBattleVictoryMusic:
	push af
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySoundWaitForCurrent
	ld c, bank(Music_DefeatedTrainer)
	pop af
	call PlayMusic
	jp Delay3

HandlePlayerMonFainted:
	ld a, 1
	ld [wInHandlePlayerMonFainted], a
	call RemoveFaintedPlayerMon
	call AnyPartyAlive     ; test if any more mons are alive
	ld a, d
	and a
	jp z, HandlePlayerBlackOut
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl] ; is enemy mon's HP 0?
	jr nz, HandlePlayerMonFainted.doUseNextMonDialogue ; if not, jump
; the enemy mon has 0 HP
	call FaintEnemyPokemon
	ld a, [wIsInBattle]
	dec a
	ret z            ; if wild encounter, battle is over
	call AnyEnemyPokemonAliveCheck
	jp z, TrainerBattleVictory
HandlePlayerMonFainted.doUseNextMonDialogue
	call DoUseNextMonDialogue
	ret c ; return if the player ran from battle
	call ChooseNextMon
	jp nz, MainInBattleLoop ; if the enemy mon has more than 0 HP, go back to battle loop
; the enemy mon has 0 HP
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	call ReplaceFaintedEnemyMon
	jp z, EnemyRan ; if enemy ran from battle rather than sending out another mon, jump
	xor a
	ld [wActionResultOrTookBattleTurn], a
	jp MainInBattleLoop

; resets flags, slides mon's pic down, plays cry, and prints fainted message
RemoveFaintedPlayerMon:
	ld a, [wPlayerMonNumber]
	ld c, a
	ld hl, wPartyGainExpFlags
	ld b, FLAG_RESET
	predef FlagActionPredef ; clear gain exp flag for fainted mon
	ld hl, wEnemyBattleStatus1
	res ATTACKING_MULTIPLE_TIMES, [hl]
	ld a, [wLowHealthAlarm]
	bit BIT_LOW_HEALTH_ALARM, a
	jr z, RemoveFaintedPlayerMon.skipWaitForSound
	ld a, DISABLE_LOW_HEALTH_ALARM
	ld [wLowHealthAlarm], a
	call WaitForSoundToFinish
RemoveFaintedPlayerMon.skipWaitForSound
; a is 0, so this zeroes the enemy's accumulated damage.
	ld hl, wEnemyBideAccumulatedDamage
	ld [hli], a
	ld [hl], a
	ld [wBattleMonStatus], a
	call ReadPlayerMonCurHPAndStatus
	hlcoord 9, 7
	lb "bc", 5, 11
	call ClearScreenArea
	hlcoord 1, 10
	decoord 1, 11
	call SlideDownFaintedMonPic
	ld a, $1
	ld [wBattleResult], a

; When the player mon and enemy mon faint at the same time and the fact that the
; enemy mon has fainted is detected first (e.g. when the player mon knocks out
; the enemy mon using a move with recoil and faints due to the recoil), don't
; play the player mon's cry or show the "[player mon] fainted!" message.
	ld a, [wInHandlePlayerMonFainted]
	and a ; was this called by HandleEnemyMonFainted?
	ret z ; if so, return

	ld a, [wBattleMonSpecies]
	call PlayCry
	ld hl, PlayerMonFaintedText
	jp PrintText

PlayerMonFaintedText:
	text_far WLA_GLOBAL_PlayerMonFaintedText
	text_end

; asks if you want to use next mon
; stores whether you ran in C flag
DoUseNextMonDialogue:
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
	ld a, [wIsInBattle]
	and a
	dec a
	ret nz ; return if it's a trainer battle
	ld hl, UseNextMonText
	call PrintText
DoUseNextMonDialogue.displayYesNoBox
	hlcoord 13, 9
	lb "bc", 10, 14
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld a, [wMenuExitMethod]
	cp CHOSE_SECOND_ITEM ; did the player choose NO?
	jr z, DoUseNextMonDialogue.tryRunning ; if the player chose NO, try running
	and a ; reset carry
	ret
DoUseNextMonDialogue.tryRunning
	ld a, [wCurrentMenuItem]
	and a
	jr z, DoUseNextMonDialogue.displayYesNoBox ; xxx when does this happen?
	ld hl, wPartyMon1Speed
	ld de, wEnemyMonSpeed
	jp TryRunningFromBattle

UseNextMonText:
	text_far WLA_GLOBAL_UseNextMonText
	text_end

; choose next player mon to send out
; stores whether enemy mon has no HP left in Z flag
ChooseNextMon:
	ld a, BATTLE_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call DisplayPartyMenu
ChooseNextMon.checkIfMonChosen
	jr nc, ChooseNextMon.monChosen
ChooseNextMon.goBackToPartyMenu
	call GoBackToPartyMenu
	jr ChooseNextMon.checkIfMonChosen
ChooseNextMon.monChosen
	call HasMonFainted
	jr z, ChooseNextMon.goBackToPartyMenu ; if mon fainted, you have to choose another
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, ChooseNextMon.notLinkBattle
	inc a ; 1
	ld [wActionResultOrTookBattleTurn], a
	call LinkBattleExchangeData
ChooseNextMon.notLinkBattle
	xor a
	ld [wActionResultOrTookBattleTurn], a
	call ClearSprites
	ld a, [wWhichPokemon]
	ld [wPlayerMonNumber], a
	ld c, a
	ld hl, wPartyGainExpFlags
	ld b, FLAG_SET
	push bc
	predef FlagActionPredef
	pop bc
	ld hl, wPartyFoughtCurrentEnemyFlags
	predef FlagActionPredef
	call LoadBattleMonFromParty
	call GBPalWhiteOut
	call LoadHudTilePatterns
	call LoadScreenTilesFromBuffer1
	call RunDefaultPaletteCommand
	call GBPalNormal
	call SendOutMon
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	ret

; called when player is out of usable mons.
; prints appropriate lose message, sets carry flag if player blacked out (special case for initial rival fight)
HandlePlayerBlackOut:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, HandlePlayerBlackOut.notRival1Battle
	ld a, [wCurOpponent]
	cp OPP_RIVAL1
	jr nz, HandlePlayerBlackOut.notRival1Battle
	hlcoord 0, 0  ; rival 1 battle
	lb "bc", 8, 21
	call ClearScreenArea
	call ScrollTrainerPicAfterBattle
	ld c, 40
	call DelayFrames
	ld hl, Rival1WinText
	call PrintText
	ld a, [wCurMap]
	cp OAKS_LAB
	ret z            ; starter battle in oak's lab: don't black out
HandlePlayerBlackOut.notRival1Battle
	ld b, SET_PAL_BATTLE_BLACK
	call RunPaletteCommand
	ld hl, PlayerBlackedOutText2
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, HandlePlayerBlackOut.noLinkBattle
	ld hl, LinkBattleLostText
HandlePlayerBlackOut.noLinkBattle
	call PrintText
	ld a, [wStatusFlags6]
	res BIT_ALWAYS_ON_BIKE, a
	ld [wStatusFlags6], a
	call ClearScreen
	scf
	ret

Rival1WinText:
	text_far WLA_GLOBAL_Rival1WinText
	text_end

PlayerBlackedOutText2:
	text_far WLA_GLOBAL_PlayerBlackedOutText2
	text_end

LinkBattleLostText:
	text_far WLA_GLOBAL_LinkBattleLostText
	text_end

; slides pic of fainted mon downwards until it disappears
; bug: when this is called, [hAutoBGTransferEnabled] is non-zero, so there is screen tearing
SlideDownFaintedMonPic:
	ld a, [wStatusFlags5]
	push af
	set BIT_NO_TEXT_DELAY, a
	ld [wStatusFlags5], a
	ld b, PIC_HEIGHT ; number of times to slide
SlideDownFaintedMonPic.slideStepLoop ; each iteration, the mon is slid down one row
	push bc
	push de
	push hl
	ld b, PIC_HEIGHT - 1 ; number of rows
SlideDownFaintedMonPic.rowLoop
	push bc
	push hl
	push de
	ld bc, PIC_WIDTH
	call CopyData
	pop de
	pop hl
	ld bc, -SCREEN_WIDTH
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	pop bc
	dec b
	jr nz, SlideDownFaintedMonPic.rowLoop
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld de, SevenSpacesText
	call PlaceString
	ld c, 2
	call DelayFrames
	pop hl
	pop de
	pop bc
	dec b
	jr nz, SlideDownFaintedMonPic.slideStepLoop
	pop af
	ld [wStatusFlags5], a
	ret

SevenSpacesText:
	.DSB PIC_WIDTH, $7f
		.STRINGMAP pokemon, "@"

; slides the player or enemy trainer off screen
; a is the number of tiles to slide it horizontally (always 9 for the player trainer or 8 for the enemy trainer)
; if a is 8, the slide is to the right, else it is to the left
; bug: when this is called, [hAutoBGTransferEnabled] is non-zero, so there is screen tearing
SlideTrainerPicOffScreen:
	ldh [lobyte(hSlideAmount)], a
	ld c, a
SlideTrainerPicOffScreen.slideStepLoop ; each iteration, the trainer pic is slid one tile left/right
	push bc
	push hl
	ld b, PIC_HEIGHT ; number of rows
SlideTrainerPicOffScreen.rowLoop
	push hl
	ldh a, [lobyte(hSlideAmount)]
	ld c, a
SlideTrainerPicOffScreen.columnLoop
	ldh a, [lobyte(hSlideAmount)]
	cp 8
	jr z, SlideTrainerPicOffScreen.slideRight
; slide player sprite left off screen
	ld a, [hld]
	ld [hli], a
	inc hl
	jr SlideTrainerPicOffScreen.nextColumn
SlideTrainerPicOffScreen.slideRight ; slide enemy trainer sprite off screen
	ld a, [hli]
	ld [hld], a
	dec hl
SlideTrainerPicOffScreen.nextColumn
	dec c
	jr nz, SlideTrainerPicOffScreen.columnLoop
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, SlideTrainerPicOffScreen.rowLoop
	ld c, 2
	call DelayFrames
	pop hl
	pop bc
	dec c
	jr nz, SlideTrainerPicOffScreen.slideStepLoop
	ret

; send out a trainer's mon
EnemySendOut:
	ld hl, wPartyGainExpFlags
	xor a
	ld [hl], a
	ld a, [wPlayerMonNumber]
	ld c, a
	ld b, FLAG_SET
	push bc
	predef FlagActionPredef
	ld hl, wPartyFoughtCurrentEnemyFlags
	xor a
	ld [hl], a
	pop bc
	predef FlagActionPredef

; don't change wPartyGainExpFlags or wPartyFoughtCurrentEnemyFlags
EnemySendOutFirstMon:
	xor a
	ld hl, wEnemyStatsToDouble ; clear enemy statuses
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wEnemyDisabledMove], a
	ld [wEnemyDisabledMoveNumber], a
	ld [wEnemyMonMinimized], a
	ld hl, wPlayerUsedMove
	ld [hli], a
	ld [hl], a
	dec a
	ld [wAICount], a
	ld hl, wPlayerBattleStatus1
	res USING_TRAPPING_MOVE, [hl]
	hlcoord 18, 0
	ld a, 8
	call SlideTrainerPicOffScreen
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, EnemySendOutFirstMon.next
	ld a, [wSerialExchangeNybbleReceiveData]
	sub 4
	ld [wWhichPokemon], a
	jr EnemySendOutFirstMon.next3
EnemySendOutFirstMon.next
	ld b, $ff
EnemySendOutFirstMon.next2
	inc b
	ld a, [wEnemyMonPartyPos]
	cp b
	jr z, EnemySendOutFirstMon.next2
	ld hl, wEnemyMon1
	ld a, b
	ld [wWhichPokemon], a
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	inc hl
	ld a, [hli]
	ld c, a
	ld a, [hl]
	or c
	jr z, EnemySendOutFirstMon.next2
EnemySendOutFirstMon.next3
	ld a, [wWhichPokemon]
	ld hl, wEnemyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hl]
	ld [wCurEnemyLevel], a
	ld a, [wWhichPokemon]
	inc a
	ld hl, wEnemyPartyCount
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wEnemyMonSpecies2], a
	ld [wCurPartySpecies], a
	call LoadEnemyMonData
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [wLastSwitchInEnemyMonHP], a
	ld a, [hl]
	ld [wLastSwitchInEnemyMonHP + 1], a
	ld a, 1
	ld [wCurrentMenuItem], a
	ld a, [wFirstMonsNotOutYet]
	dec a
	jr z, EnemySendOutFirstMon.next4
	ld a, [wPartyCount]
	dec a
	jr z, EnemySendOutFirstMon.next4
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, EnemySendOutFirstMon.next4
	ld a, [wOptions]
	bit BIT_BATTLE_SHIFT, a
	jr nz, EnemySendOutFirstMon.next4
	ld hl, TrainerAboutToUseText
	call PrintText
	hlcoord 0, 7
	lb "bc", 8, 1
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld a, [wCurrentMenuItem]
	and a
	jr nz, EnemySendOutFirstMon.next4
	ld a, BATTLE_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call DisplayPartyMenu
EnemySendOutFirstMon.next9
	ld a, 1
	ld [wCurrentMenuItem], a
	jr c, EnemySendOutFirstMon.next7
	ld hl, wPlayerMonNumber
	ld a, [wWhichPokemon]
	cp [hl]
	jr nz, EnemySendOutFirstMon.next6
	ld hl, AlreadyOutText
	call PrintText
EnemySendOutFirstMon.next8
	call GoBackToPartyMenu
	jr EnemySendOutFirstMon.next9
EnemySendOutFirstMon.next6
	call HasMonFainted
	jr z, EnemySendOutFirstMon.next8
	xor a
	ld [wCurrentMenuItem], a
EnemySendOutFirstMon.next7
	call GBPalWhiteOut
	call LoadHudTilePatterns
	call LoadScreenTilesFromBuffer1
EnemySendOutFirstMon.next4
	call ClearSprites
	hlcoord 0, 0
	lb "bc", 4, 11
	call ClearScreenArea
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	call GBPalNormal
	ld hl, TrainerSentOutText
	call PrintText
	ld a, [wEnemyMonSpecies2]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetMonHeader
	ld de, vFrontPic
	call LoadMonFrontSprite
	ld a, -$31
	ldh [lobyte(hStartTileID)], a
	hlcoord 15, 6
	predef AnimateSendingOutMon
	ld a, [wEnemyMonSpecies2]
	call PlayCry
	call DrawEnemyHUDAndHPBar
	ld a, [wCurrentMenuItem]
	and a
	ret nz
	xor a
	ld [wPartyGainExpFlags], a
	ld [wPartyFoughtCurrentEnemyFlags], a
	call SaveScreenTilesToBuffer1
	jp SwitchPlayerMon

TrainerAboutToUseText:
	text_far WLA_GLOBAL_TrainerAboutToUseText
	text_end

TrainerSentOutText:
	text_far WLA_GLOBAL_TrainerSentOutText
	text_end

; tests if the player has any pokemon that are not fainted
; sets d = 0 if all fainted, d != 0 if some mons are still alive
AnyPartyAlive:
	ld a, [wPartyCount]
	ld e, a
	xor a
	ld hl, wPartyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH - 1
AnyPartyAlive.partyMonsLoop
	or [hl]
	inc hl
	or [hl]
	add hl, bc
	dec e
	jr nz, AnyPartyAlive.partyMonsLoop
	ld d, a
	ret

; tests if player mon has fainted
; stores whether mon has fainted in Z flag
HasMonFainted:
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hli]
	or [hl]
	ret nz
	ld a, [wFirstMonsNotOutYet]
	and a
	jr nz, HasMonFainted.done
	ld hl, NoWillText
	call PrintText
HasMonFainted.done
	xor a
	ret

NoWillText:
	text_far WLA_GLOBAL_NoWillText
	text_end

; try to run from battle (hl = player speed, de = enemy speed)
; stores whether the attempt was successful in carry flag
TryRunningFromBattle:
	call IsGhostBattle
	jp z, TryRunningFromBattle.canEscape ; jump if it's a ghost battle
	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	jp z, TryRunningFromBattle.canEscape ; jump if it's a safari battle
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, TryRunningFromBattle.canEscape
	ld a, [wIsInBattle]
	dec a
	jr nz, TryRunningFromBattle.trainerBattle ; jump if it's a trainer battle
	ld a, [wNumRunAttempts]
	inc a
	ld [wNumRunAttempts], a
	ld a, [hli]
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, [hl]
	ldh [lobyte(hMultiplicand + 2)], a
	ld a, [de]
	ldh [lobyte(hEnemySpeed)], a
	inc de
	ld a, [de]
	ldh [lobyte(hEnemySpeed + 1)], a
	call LoadScreenTilesFromBuffer1
	ld de, hMultiplicand + 1
	ld hl, hEnemySpeed
	ld c, 2
	call StringCmp
	jr nc, TryRunningFromBattle.canEscape ; jump if player speed greater than enemy speed
	xor a
	ldh [lobyte(hMultiplicand)], a
	ld a, 32
	ldh [lobyte(hMultiplier)], a
	call Multiply ; multiply player speed by 32
	ldh a, [lobyte(hProduct + 2)]
	ldh [lobyte(hDividend)], a
	ldh a, [lobyte(hProduct + 3)]
	ldh [lobyte(hDividend + 1)], a
	ldh a, [lobyte(hEnemySpeed)]
	ld b, a
	ldh a, [lobyte(hEnemySpeed + 1)]
; divide enemy speed by 4
	srl b
	rr a
	srl b
	rr a
	and a
	jr z, TryRunningFromBattle.canEscape ; jump if enemy speed divided by 4, mod 256 is 0
	ldh [lobyte(hDivisor)], a ; ((enemy speed / 4) % 256)
	ld b, $2
	call Divide ; divide (player speed * 32) by ((enemy speed / 4) % 256)
	ldh a, [lobyte(hQuotient + 2)]
	and a ; is the quotient greater than 256?
	jr nz, TryRunningFromBattle.canEscape ; if so, the player can escape
	ld a, [wNumRunAttempts]
	ld c, a
; add 30 to the quotient for each run attempt
TryRunningFromBattle.loop
	dec c
	jr z, TryRunningFromBattle.compareWithRandomValue
	ld b, 30
	ldh a, [lobyte(hQuotient + 3)]
	add b
	ldh [lobyte(hQuotient + 3)], a
	jr c, TryRunningFromBattle.canEscape
	jr TryRunningFromBattle.loop
TryRunningFromBattle.compareWithRandomValue
	call BattleRandom
	ld b, a
	ldh a, [lobyte(hQuotient + 3)]
	cp b
	jr nc, TryRunningFromBattle.canEscape ; if the random value was less than or equal to the quotient
	                  ; plus 30 times the number of attempts, the player can escape
; can't escape
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a ; you lose your turn when you can't escape
	ld hl, CantEscapeText
	jr TryRunningFromBattle.printCantEscapeOrNoRunningText
TryRunningFromBattle.trainerBattle
	ld hl, NoRunningText
TryRunningFromBattle.printCantEscapeOrNoRunningText
	call PrintText
	ld a, 1
	ld [wForcePlayerToChooseMon], a
	call SaveScreenTilesToBuffer1
	and a ; reset carry
	ret
TryRunningFromBattle.canEscape
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ld a, $2
	jr nz, TryRunningFromBattle.playSound
; link battle
	call SaveScreenTilesToBuffer1
	xor a
	ld [wActionResultOrTookBattleTurn], a
	ld a, LINKBATTLE_RUN
	ld [wPlayerMoveListIndex], a
	call LinkBattleExchangeData
	call LoadScreenTilesFromBuffer1
	ld a, [wSerialExchangeNybbleReceiveData]
	cp LINKBATTLE_RUN
	ld a, $2
	jr z, TryRunningFromBattle.playSound
	dec a
TryRunningFromBattle.playSound
	ld [wBattleResult], a
	ld a, SFX_RUN
	call PlaySoundWaitForCurrent
	ld hl, GotAwayText
	call PrintText
	call WaitForSoundToFinish
	call SaveScreenTilesToBuffer1
	scf ; set carry
	ret

CantEscapeText:
	text_far WLA_GLOBAL_CantEscapeText
	text_end

NoRunningText:
	text_far WLA_GLOBAL_NoRunningText
	text_end

GotAwayText:
	text_far WLA_GLOBAL_GotAwayText
	text_end

; copies from party data to battle mon data when sending out a new player mon
LoadBattleMonFromParty:
	ld a, [wWhichPokemon]
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1Species
	call AddNTimes
	ld de, wBattleMonSpecies
	ld bc, wBattleMonDVs - wBattleMonSpecies
	call CopyData
	ld bc, MON_DVS - MON_OTID
	add hl, bc
	ld de, wBattleMonDVs
	ld bc, MON_PP - MON_DVS
	call CopyData
	ld de, wBattleMonPP
	ld bc, NUM_MOVES
	call CopyData
	ld de, wBattleMonLevel
	ld bc, wBattleMonPP - wBattleMonLevel
	call CopyData
	ld a, [wBattleMonSpecies2]
	ld [wCurSpecies], a
	call GetMonHeader
	ld hl, wPartyMonNicks
	ld a, [wPlayerMonNumber]
	call SkipFixedLengthTextEntries
	ld de, wBattleMonNick
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wBattleMonLevel
	ld de, wPlayerMonUnmodifiedLevel ; block of memory used for unmodified stats
	ld bc, 1 + NUM_STATS * 2
	call CopyData
	call ApplyBurnAndParalysisPenaltiesToPlayer
	call ApplyBadgeStatBoosts
	ld a, $7 ; default stat modifier
	ld b, NUM_STAT_MODS
	ld hl, wPlayerMonAttackMod
LoadBattleMonFromParty.statModLoop
	ld [hli], a
	dec b
	jr nz, LoadBattleMonFromParty.statModLoop
	ret

; copies from enemy party data to current enemy mon data when sending out a new enemy mon
LoadEnemyMonFromParty:
	ld a, [wWhichPokemon]
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wEnemyMons
	call AddNTimes
	ld de, wEnemyMonSpecies
	ld bc, wEnemyMonDVs - wEnemyMonSpecies
	call CopyData
	ld bc, MON_DVS - MON_OTID
	add hl, bc
	ld de, wEnemyMonDVs
	ld bc, MON_PP - MON_DVS
	call CopyData
	ld de, wEnemyMonPP
	ld bc, NUM_MOVES
	call CopyData
	ld de, wEnemyMonLevel
	ld bc, wEnemyMonPP - wEnemyMonLevel
	call CopyData
	ld a, [wEnemyMonSpecies]
	ld [wCurSpecies], a
	call GetMonHeader
	ld hl, wEnemyMonNicks
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld de, wEnemyMonNick
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, wEnemyMonLevel
	ld de, wEnemyMonUnmodifiedLevel ; block of memory used for unmodified stats
	ld bc, 1 + NUM_STATS * 2
	call CopyData
	call ApplyBurnAndParalysisPenaltiesToEnemy
	ld hl, wMonHBaseStats
	ld de, wEnemyMonBaseStats
	ld b, NUM_STATS
LoadEnemyMonFromParty.copyBaseStatsLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, LoadEnemyMonFromParty.copyBaseStatsLoop
	ld a, $7 ; default stat modifier
	ld b, NUM_STAT_MODS
	ld hl, wEnemyMonStatMods
LoadEnemyMonFromParty.statModLoop
	ld [hli], a
	dec b
	jr nz, LoadEnemyMonFromParty.statModLoop
	ld a, [wWhichPokemon]
	ld [wEnemyMonPartyPos], a
	ret

SendOutMon:
	callfar PrintSendOutMonMessage
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl] ; is enemy mon HP zero?
	jp z, SendOutMon.skipDrawingEnemyHUDAndHPBar ; if HP is zero, skip drawing the HUD and HP bar
	call DrawEnemyHUDAndHPBar
SendOutMon.skipDrawingEnemyHUDAndHPBar
	call DrawPlayerHUDAndHPBar
	predef LoadMonBackPic
	xor a
	ldh [lobyte(hStartTileID)], a
	ld hl, wBattleAndStartSavedMenuItem
	ld [hli], a
	ld [hl], a
	ld [wBoostExpByExpAll], a
	ld [wDamageMultipliers], a
	ld [wPlayerMoveNum], a
	ld hl, wPlayerUsedMove
	ld [hli], a
	ld [hl], a
	ld hl, wPlayerStatsToDouble
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wPlayerDisabledMove], a
	ld [wPlayerDisabledMoveNumber], a
	ld [wPlayerMonMinimized], a
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	ld hl, wEnemyBattleStatus1
	res USING_TRAPPING_MOVE, [hl]
	ld a, $1
	ldh [lobyte(hWhoseTurn)], a
	ld a, POOF_ANIM
	call PlayMoveAnimation
	hlcoord 4, 11
	predef AnimateSendingOutMon
	ld a, [wCurPartySpecies]
	call PlayCry
	call PrintEmptyString
	jp SaveScreenTilesToBuffer1

; show 2 stages of the player mon getting smaller before disappearing
AnimateRetreatingPlayerMon:
	hlcoord 1, 5
	lb "bc", 7, 7
	call ClearScreenArea
	hlcoord 3, 7
	lb "bc", 5, 5
	xor a
	ld [wDownscaledMonSize], a
	ldh [lobyte(hBaseTileID)], a
	predef CopyDownscaledMonTiles
	ld c, 4
	call DelayFrames
	call AnimateRetreatingPlayerMon.clearScreenArea
	hlcoord 4, 9
	lb "bc", 3, 3
	ld a, 1
	ld [wDownscaledMonSize], a
	xor a
	ldh [lobyte(hBaseTileID)], a
	predef CopyDownscaledMonTiles
	call Delay3
	call AnimateRetreatingPlayerMon.clearScreenArea
	ld a, $4c
	ldcoord_a 5, 11
AnimateRetreatingPlayerMon.clearScreenArea
	hlcoord 1, 5
	lb "bc", 7, 7
	jp ClearScreenArea

; Copies player's current pokemon's current HP, party pos, and status into the party
; struct data so it stays after battle or switching
ReadPlayerMonCurHPAndStatus:
	ld a, [wPlayerMonNumber]
	ld hl, wPartyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wBattleMonHP
	ld bc, MON_STATUS + 1 - MON_HP ; also copies party pos in-between HP and status
	jp CopyData

DrawHUDsAndHPBars:
	call DrawPlayerHUDAndHPBar
	jp DrawEnemyHUDAndHPBar

DrawPlayerHUDAndHPBar:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	hlcoord 9, 7
	lb "bc", 5, 11
	call ClearScreenArea
	callfar PlacePlayerHUDTiles
	hlcoord 18, 9
	ld [hl], $73
	ld de, wBattleMonNick
	hlcoord 10, 7
	call CenterMonName
	call PlaceString
	ld hl, wBattleMonSpecies
	ld de, wLoadedMon
	ld bc, wBattleMonDVs - wBattleMonSpecies
	call CopyData
	ld hl, wBattleMonLevel
	ld de, wLoadedMonLevel
	ld bc, wBattleMonPP - wBattleMonLevel
	call CopyData
	hlcoord 14, 8
	push hl
	inc hl
	ld de, wLoadedMonStatus
	call PrintStatusConditionNotFainted
	pop hl
	jr nz, DrawPlayerHUDAndHPBar.doNotPrintLevel
	call PrintLevel
DrawPlayerHUDAndHPBar.doNotPrintLevel
	ld a, [wLoadedMonSpecies]
	ld [wCurPartySpecies], a
	hlcoord 10, 9
	predef DrawHP
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld hl, wPlayerHPBarColor
	call GetBattleHealthBarColor
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr z, DrawPlayerHUDAndHPBar.fainted
	ld a, [wLowHealthAlarmDisabled]
	and a ; has the alarm been disabled because the player has already won?
	ret nz ; if so, return
	ld a, [wPlayerHPBarColor]
	cp HP_BAR_RED
	jr z, DrawPlayerHUDAndHPBar.setLowHealthAlarm
DrawPlayerHUDAndHPBar.fainted
	ld hl, wLowHealthAlarm
	bit BIT_LOW_HEALTH_ALARM, [hl]
	ld [hl], 0
	ret z
	xor a
	ld [wChannelSoundIDs + CHAN5], a
	ret
DrawPlayerHUDAndHPBar.setLowHealthAlarm
	ld hl, wLowHealthAlarm
	set BIT_LOW_HEALTH_ALARM, [hl]
	ret

DrawEnemyHUDAndHPBar:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	hlcoord 0, 0
	lb "bc", 4, 12
	call ClearScreenArea
	callfar PlaceEnemyHUDTiles
	ld de, wEnemyMonNick
	hlcoord 1, 0
	call CenterMonName
	call PlaceString
	hlcoord 4, 1
	push hl
	inc hl
	ld de, wEnemyMonStatus
	call PrintStatusConditionNotFainted
	pop hl
	jr nz, DrawEnemyHUDAndHPBar.skipPrintLevel ; if the mon has a status condition, skip printing the level
	ld a, [wEnemyMonLevel]
	ld [wLoadedMonLevel], a
	call PrintLevel
DrawEnemyHUDAndHPBar.skipPrintLevel
	ld hl, wEnemyMonHP
	ld a, [hli]
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, [hld]
	ldh [lobyte(hMultiplicand + 2)], a
	or [hl] ; is current HP zero?
	jr nz, DrawEnemyHUDAndHPBar.hpNonzero
; current HP is 0
; set variables for DrawHPBar
	ld c, a
	ld e, a
	ld d, $6
	jp DrawEnemyHUDAndHPBar.drawHPBar
DrawEnemyHUDAndHPBar.hpNonzero
	xor a
	ldh [lobyte(hMultiplicand)], a
	ld a, 48
	ldh [lobyte(hMultiplier)], a
	call Multiply ; multiply current HP by 48
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ldh [lobyte(hDivisor)], a
	ld a, b
	and a ; is max HP > 255?
	jr z, DrawEnemyHUDAndHPBar.doDivide
; if max HP > 255, scale both (current HP * 48) and max HP by dividing by 4 so that max HP fits in one byte
; (it needs to be one byte so it can be used as the divisor for the Divide function)
	ldh a, [lobyte(hDivisor)]
	srl b
	rr a
	srl b
	rr a
	ldh [lobyte(hDivisor)], a
	ldh a, [lobyte(hProduct + 2)]
	ld b, a
	srl b
	ldh a, [lobyte(hProduct + 3)]
	rr a
	srl b
	rr a
	ldh [lobyte(hProduct + 3)], a
	ld a, b
	ldh [lobyte(hProduct + 2)], a
DrawEnemyHUDAndHPBar.doDivide
	ldh a, [lobyte(hProduct + 2)]
	ldh [lobyte(hDividend)], a
	ldh a, [lobyte(hProduct + 3)]
	ldh [lobyte(hDividend + 1)], a
	ld a, $2
	ld b, a
	call Divide ; divide (current HP * 48) by max HP
	ldh a, [lobyte(hQuotient + 3)]
; set variables for DrawHPBar
	ld e, a
	ld a, $6
	ld d, a
	ld c, a
DrawEnemyHUDAndHPBar.drawHPBar
	xor a
	ld [wHPBarType], a
	hlcoord 2, 2
	call DrawHPBar
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld hl, wEnemyHPBarColor

GetBattleHealthBarColor:
	ld b, [hl]
	call GetHealthBarColor
	ld a, [hl]
	cp b
	ret z
	ld b, SET_PAL_BATTLE
	jp RunPaletteCommand

; center's mon's name on the battle screen
; if the name is 1 or 2 letters long, it is printed 2 spaces more to the right than usual
; (i.e. for names longer than 4 letters)
; if the name is 3 or 4 letters long, it is printed 1 space more to the right than usual
; (i.e. for names longer than 4 letters)
CenterMonName:
	push de
	inc hl
	inc hl
	ld b, $2
CenterMonName.loop
	inc de
	ld a, [de]
	cp $50
	jr z, CenterMonName.done
	inc de
	ld a, [de]
	cp $50
	jr z, CenterMonName.done
	dec hl
	dec b
	jr nz, CenterMonName.loop
CenterMonName.done
	pop de
	ret

DisplayBattleMenu:
	call LoadScreenTilesFromBuffer1 ; restore saved screen
	ld a, [wBattleType]
	and a
	jr nz, DisplayBattleMenu.nonstandardbattle
	call DrawHUDsAndHPBars
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
DisplayBattleMenu.nonstandardbattle
	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	ld a, BATTLE_MENU_TEMPLATE
	jr nz, DisplayBattleMenu.menuselected
	ld a, SAFARI_BATTLE_MENU_TEMPLATE
DisplayBattleMenu.menuselected
	ld [wTextBoxID], a
	call DisplayTextBoxID
 ; handle menu input if it's not the old man tutorial
	ld a, [wBattleType]
	.ASSERT ((BATTLE_TYPE_OLD_MAN)-(1)) < 1 && ((BATTLE_TYPE_OLD_MAN)-(1)) > -1
	dec a
	jp nz, DisplayBattleMenu.handleBattleMenuInput
; the following happens for the old man tutorial
	; Temporarily save the player name in wLinkEnemyTrainerName.
	; Since wLinkEnemyTrainerName = wGrassRate, this affects wild encounters.
	; The wGrassRate byte and following wGrassMons buffer are supposed
	; to get overwritten when entering a map with wild Pokémon,
	; but an oversight prevents this in Cinnabar and Route 21,
	; so the infamous MissingNo. glitch can show up.
	ld hl, wPlayerName
	ld de, wLinkEnemyTrainerName
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, DisplayBattleMenu.oldManName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
; the following simulates the keystrokes by drawing menus on screen
	hlcoord 9, 14
	ld [hl], $ed
	ld c, 80
	call DelayFrames
	ld [hl], $7f
	hlcoord 9, 16
	ld [hl], $ed
	ld c, 50
	call DelayFrames
	ld [hl], $ec
	ld a, $2 ; select the "ITEM" menu
	jp DisplayBattleMenu.upperLeftMenuItemWasNotSelected
DisplayBattleMenu.oldManName
		.STRINGMAP pokemon, "OLD MAN@"
DisplayBattleMenu.handleBattleMenuInput
	ld a, [wBattleAndStartSavedMenuItem]
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	sub 2 ; check if the cursor is in the left column
	jr c, DisplayBattleMenu.leftColumn
; cursor is in the right column
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	jr DisplayBattleMenu.rightColumn
DisplayBattleMenu.leftColumn ; put cursor in left column of menu
	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	ld a, $7f
	jr z, DisplayBattleMenu.safariLeftColumn
; put cursor in left column for normal battle menu (i.e. when it's not a Safari battle)
	ldcoord_a 15, 14 ; clear upper cursor position in right column
	ldcoord_a 15, 16 ; clear lower cursor position in right column
	ld b, $9 ; top menu item X
	jr DisplayBattleMenu.leftColumn_WaitForInput
DisplayBattleMenu.safariLeftColumn
	ldcoord_a 13, 14
	ldcoord_a 13, 16
	hlcoord 7, 14
	ld de, wNumSafariBalls
	lb "bc", 1, 2
	call PrintNumber
	ld b, $1 ; top menu item X
DisplayBattleMenu.leftColumn_WaitForInput
	ld hl, wTopMenuItemY
	ld a, $e
	ld [hli], a ; wTopMenuItemY
	ld a, b
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, $1
	ld [hli], a ; wMaxMenuItem
	ld [hl], PAD_RIGHT | PAD_A ; wMenuWatchedKeys
	call HandleMenuInput
	bit B_PAD_RIGHT, a
	jr nz, DisplayBattleMenu.rightColumn
	jr DisplayBattleMenu.AButtonPressed ; the A button was pressed
DisplayBattleMenu.rightColumn ; put cursor in right column of menu
	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	ld a, $7f
	jr z, DisplayBattleMenu.safariRightColumn
; put cursor in right column for normal battle menu (i.e. when it's not a Safari battle)
	ldcoord_a 9, 14 ; clear upper cursor position in left column
	ldcoord_a 9, 16 ; clear lower cursor position in left column
	ld b, $f ; top menu item X
	jr DisplayBattleMenu.rightColumn_WaitForInput
DisplayBattleMenu.safariRightColumn
	ldcoord_a 1, 14 ; clear upper cursor position in left column
	ldcoord_a 1, 16 ; clear lower cursor position in left column
	hlcoord 7, 14
	ld de, wNumSafariBalls
	lb "bc", 1, 2
	call PrintNumber
	ld b, $d ; top menu item X
DisplayBattleMenu.rightColumn_WaitForInput
	ld hl, wTopMenuItemY
	ld a, $e
	ld [hli], a ; wTopMenuItemY
	ld a, b
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, $1
	ld [hli], a ; wMaxMenuItem
	ld a, PAD_LEFT | PAD_A
	ld [hli], a ; wMenuWatchedKeys
	call HandleMenuInput
	bit B_PAD_LEFT, a
	jr nz, DisplayBattleMenu.leftColumn ; if left was pressed, jump
	ld a, [wCurrentMenuItem]
	add $2 ; if we're in the right column, the actual id is +2
	ld [wCurrentMenuItem], a
DisplayBattleMenu.AButtonPressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	ld a, [wCurrentMenuItem]
	ld [wBattleAndStartSavedMenuItem], a
	jr z, DisplayBattleMenu.handleMenuSelection
; not Safari battle
; swap the IDs of the item menu and party menu (this is probably because they swapped the positions
; of these menu items in first generation English versions)
	cp $1 ; was the item menu selected?
	jr nz, DisplayBattleMenu.notItemMenu
; item menu was selected
	inc a ; increment a to 2
	jr DisplayBattleMenu.handleMenuSelection
DisplayBattleMenu.notItemMenu
	cp $2 ; was the party menu selected?
	jr nz, DisplayBattleMenu.handleMenuSelection
; party menu selected
	dec a ; decrement a to 1
DisplayBattleMenu.handleMenuSelection
	and a
	jr nz, DisplayBattleMenu.upperLeftMenuItemWasNotSelected
; the upper left menu item was selected
	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	jr z, DisplayBattleMenu.throwSafariBallWasSelected
; the "FIGHT" menu was selected
	xor a
	ld [wNumRunAttempts], a
	jp LoadScreenTilesFromBuffer1 ; restore saved screen and return
DisplayBattleMenu.throwSafariBallWasSelected
	ld a, SAFARI_BALL
	ld [wCurItem], a
	jr UseBagItem

DisplayBattleMenu.upperLeftMenuItemWasNotSelected ; a menu item other than the upper left item was selected
	cp $2
	jp nz, PartyMenuOrRockOrRun

; either the bag (normal battle) or bait (safari battle) was selected
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, DisplayBattleMenu.notLinkBattle

; can't use items in link battles
	ld hl, ItemsCantBeUsedHereText
	call PrintText
	jp DisplayBattleMenu

DisplayBattleMenu.notLinkBattle
	call SaveScreenTilesToBuffer2
	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	jr nz, BagWasSelected

; bait was selected
	ld a, SAFARI_BAIT
	ld [wCurItem], a
	jr UseBagItem

BagWasSelected:
	call LoadScreenTilesFromBuffer1
	ld a, [wBattleType]
	and a ; is it a normal battle?
	jr nz, BagWasSelected.next

; normal battle
	call DrawHUDsAndHPBars
BagWasSelected.next
	ld a, [wBattleType]
	dec a ; is it the old man tutorial?
	jr nz, DisplayPlayerBag ; no, it is a normal battle
	ld hl, OldManItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	jr DisplayBagMenu

OldManItemList:
	.DB 1 ; # items
	.DB POKE_BALL, 50
	.DB -1 ; end

DisplayPlayerBag:
	; get the pointer to player's bag when in a normal battle
	ld hl, wNumBagItems
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a

DisplayBagMenu:
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	ld a, [wBagSavedMenuItem]
	ld [wCurrentMenuItem], a
	call DisplayListMenuID
	ld a, [wCurrentMenuItem]
	ld [wBagSavedMenuItem], a
	ld a, $0
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wMenuItemToSwap], a
	jp c, DisplayBattleMenu ; go back to battle menu if an item was not selected

UseBagItem:
	; either use an item from the bag or use a safari zone item
	ld a, [wCurItem]
	ld [wNamedObjectIndex], a
	call GetItemName
	call CopyToStringBuffer
	xor a
	ld [wPseudoItemID], a
	call UseItem
	call LoadHudTilePatterns
	call ClearSprites
	xor a
	ld [wCurrentMenuItem], a
	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	jr z, UseBagItem.checkIfMonCaptured

	ld a, [wActionResultOrTookBattleTurn]
	and a ; was the item used successfully?
	jp z, BagWasSelected ; if not, go back to the bag menu

	ld a, [wPlayerBattleStatus1]
	bit USING_TRAPPING_MOVE, a ; is the player using a multi-turn move like wrap?
	jr z, UseBagItem.checkIfMonCaptured
	ld hl, wPlayerNumAttacksLeft
	dec [hl]
	jr nz, UseBagItem.checkIfMonCaptured
	ld hl, wPlayerBattleStatus1
	res USING_TRAPPING_MOVE, [hl] ; not using multi-turn move any more

UseBagItem.checkIfMonCaptured
	ld a, [wCapturedMonSpecies]
	and a ; was the enemy mon captured with a ball?
	jr nz, UseBagItem.returnAfterCapturingMon

	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	jr z, UseBagItem.returnAfterUsingItem_NoCapture
; not a safari battle
	call LoadScreenTilesFromBuffer1
	call DrawHUDsAndHPBars
	call Delay3
UseBagItem.returnAfterUsingItem_NoCapture

	call GBPalNormal
	and a ; reset carry
	ret

UseBagItem.returnAfterCapturingMon
	call GBPalNormal
	xor a
	ld [wCapturedMonSpecies], a
	ld a, $2
	ld [wBattleResult], a
	scf ; set carry
	ret

ItemsCantBeUsedHereText:
	text_far WLA_GLOBAL_ItemsCantBeUsedHereText
	text_end

PartyMenuOrRockOrRun:
	dec a ; was Run selected?
	jp nz, BattleMenu_RunWasSelected
; party menu or rock was selected
	call SaveScreenTilesToBuffer2
	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	jr nz, PartyMenuOrRockOrRun.partyMenuWasSelected
; safari battle
	ld a, SAFARI_ROCK
	ld [wCurItem], a
	jp UseBagItem
PartyMenuOrRockOrRun.partyMenuWasSelected
	call LoadScreenTilesFromBuffer1
	xor a ; NORMAL_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
PartyMenuOrRockOrRun.checkIfPartyMonWasSelected
	jp nc, PartyMenuOrRockOrRun.partyMonWasSelected ; if a party mon was selected, jump, else we quit the party menu
PartyMenuOrRockOrRun.quitPartyMenu
	call ClearSprites
	call GBPalWhiteOut
	call LoadHudTilePatterns
	call LoadScreenTilesFromBuffer2
	call RunDefaultPaletteCommand
	call GBPalNormal
	jp DisplayBattleMenu
PartyMenuOrRockOrRun.partyMonDeselected
	hlcoord 11, 11
	ld bc, 6 * SCREEN_WIDTH + 9
	ld a, $7f
	call FillMemory
	xor a ; NORMAL_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call GoBackToPartyMenu
	jr PartyMenuOrRockOrRun.checkIfPartyMonWasSelected
PartyMenuOrRockOrRun.partyMonWasSelected
	ld a, SWITCH_STATS_CANCEL_MENU_TEMPLATE
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, wTopMenuItemY
	ld a, $c
	ld [hli], a ; wTopMenuItemY
	ld [hli], a ; wTopMenuItemX
	xor a
	ld [hli], a ; wCurrentMenuItem
	inc hl
	ld a, $2
	ld [hli], a ; wMaxMenuItem
	ld a, PAD_B | PAD_A
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hl], a ; wLastMenuItem
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, PartyMenuOrRockOrRun.partyMonDeselected ; if B was pressed, jump
; A was pressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	cp $2 ; was Cancel selected?
	jr z, PartyMenuOrRockOrRun.quitPartyMenu ; if so, quit the party menu entirely
	and a ; was Switch selected?
	jr z, PartyMenuOrRockOrRun.switchMon ; if so, jump
; Stats was selected
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	ld hl, wPartyMon1
	call ClearSprites
; display the two status screens
	predef StatusScreen
	predef StatusScreen2
; now we need to reload the enemy mon pic
	ld a, [wEnemyBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a ; does the enemy mon have a substitute?
	ld hl, AnimationSubstitute
	jr nz, PartyMenuOrRockOrRun.doEnemyMonAnimation
; enemy mon doesn't have substitute
	ld a, [wEnemyMonMinimized]
	and a ; has the enemy mon used Minimize?
	ld hl, AnimationMinimizeMon
	jr nz, PartyMenuOrRockOrRun.doEnemyMonAnimation
; enemy mon is not minimized
	ld a, [wEnemyMonSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetMonHeader
	ld de, vFrontPic
	call LoadMonFrontSprite
	jr PartyMenuOrRockOrRun.enemyMonPicReloaded
PartyMenuOrRockOrRun.doEnemyMonAnimation
	ld b, bank(AnimationSubstitute) ; bank(AnimationMinimizeMon)
	call Bankswitch
PartyMenuOrRockOrRun.enemyMonPicReloaded ; enemy mon pic has been reloaded, so return to the party menu
	jp PartyMenuOrRockOrRun.partyMenuWasSelected
PartyMenuOrRockOrRun.switchMon
	ld a, [wPlayerMonNumber]
	ld d, a
	ld a, [wWhichPokemon]
	cp d ; check if the mon to switch to is already out
	jr nz, PartyMenuOrRockOrRun.notAlreadyOut
; mon is already out
	ld hl, AlreadyOutText
	call PrintText
	jp PartyMenuOrRockOrRun.partyMonDeselected
PartyMenuOrRockOrRun.notAlreadyOut
	call HasMonFainted
	jp z, PartyMenuOrRockOrRun.partyMonDeselected ; can't switch to fainted mon
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	call GBPalWhiteOut
	call ClearSprites
	call LoadHudTilePatterns
	call LoadScreenTilesFromBuffer1
	call RunDefaultPaletteCommand
	call GBPalNormal
; fall through to SwitchPlayerMon

SwitchPlayerMon:
	callfar RetreatMon
	ld c, 50
	call DelayFrames
	call AnimateRetreatingPlayerMon
	ld a, [wWhichPokemon]
	ld [wPlayerMonNumber], a
	ld c, a
	ld b, FLAG_SET
	push bc
	ld hl, wPartyGainExpFlags
	predef FlagActionPredef
	pop bc
	ld hl, wPartyFoughtCurrentEnemyFlags
	predef FlagActionPredef
	call LoadBattleMonFromParty
	call SendOutMon
	call SaveScreenTilesToBuffer1
	ld a, $2
	ld [wCurrentMenuItem], a
	and a
	ret

AlreadyOutText:
	text_far WLA_GLOBAL_AlreadyOutText
	text_end

BattleMenu_RunWasSelected:
	call LoadScreenTilesFromBuffer1
	ld a, $3
	ld [wCurrentMenuItem], a
	ld hl, wBattleMonSpeed
	ld de, wEnemyMonSpeed
	call TryRunningFromBattle
	ld a, 0
	ld [wForcePlayerToChooseMon], a
	ret c
	ld a, [wActionResultOrTookBattleTurn]
	and a
	ret nz ; return if the player couldn't escape
	jp DisplayBattleMenu

MoveSelectionMenu:
	ld a, [wMoveMenuType]
	dec a
	jr z, MoveSelectionMenu.mimicmenu
	dec a
	jr z, MoveSelectionMenu.relearnmenu
	jr MoveSelectionMenu.regularmenu

MoveSelectionMenu.loadmoves
	ld de, wMoves
	ld bc, NUM_MOVES
	call CopyData
	callfar FormatMovesString
	ret

MoveSelectionMenu.writemoves
	ld de, wMovesString
	ldh a, [lobyte(hUILayoutFlags)]
	set BIT_SINGLE_SPACED_LINES, a
	ldh [lobyte(hUILayoutFlags)], a
	call PlaceString
	ldh a, [lobyte(hUILayoutFlags)]
	res BIT_SINGLE_SPACED_LINES, a
	ldh [lobyte(hUILayoutFlags)], a
	ret

MoveSelectionMenu.regularmenu
	call AnyMoveToSelect
	ret z
	ld hl, wBattleMonMoves
	call MoveSelectionMenu.loadmoves
	hlcoord 4, 12
	ld b, 4
	ld c, 14
	di ; out of pure coincidence, it is possible for vblank to occur between the di and ei
	   ; so it is necessary to put the di ei block to not cause tearing
	call TextBoxBorder
	hlcoord 4, 12
	ld [hl], $7a
	hlcoord 10, 12
	ld [hl], $7e
	ei
	hlcoord 6, 13
	call MoveSelectionMenu.writemoves
	ld b, $5
	ld a, $c
	jr MoveSelectionMenu.menuset
MoveSelectionMenu.mimicmenu
	ld hl, wEnemyMonMoves
	call MoveSelectionMenu.loadmoves
	hlcoord 0, 7
	ld b, 4
	ld c, 14
	call TextBoxBorder
	hlcoord 2, 8
	call MoveSelectionMenu.writemoves
	ld b, $1
	ld a, $7
	jr MoveSelectionMenu.menuset
MoveSelectionMenu.relearnmenu
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	call MoveSelectionMenu.loadmoves
	hlcoord 4, 7
	ld b, 4
	ld c, 14
	call TextBoxBorder
	hlcoord 6, 8
	call MoveSelectionMenu.writemoves
	ld b, $5
	ld a, $7
MoveSelectionMenu.menuset
	ld hl, wTopMenuItemY
	ld [hli], a ; wTopMenuItemY
	ld a, b
	ld [hli], a ; wTopMenuItemX
	ld a, [wMoveMenuType]
	cp $1
	jr z, MoveSelectionMenu.selectedmoveknown
	ld a, $1
	jr nc, MoveSelectionMenu.selectedmoveknown
	ld a, [wPlayerMoveListIndex]
	inc a
MoveSelectionMenu.selectedmoveknown
	ld [hli], a ; wCurrentMenuItem
	inc hl ; wTileBehindCursor untouched
	ld a, [wNumMovesMinusOne]
	inc a
	inc a
	ld [hli], a ; wMaxMenuItem
	ld a, [wMoveMenuType]
	dec a
	ld b, PAD_UP | PAD_DOWN | PAD_A
	jr z, MoveSelectionMenu.matchedkeyspicked
	dec a
	ld b, PAD_UP | PAD_DOWN | PAD_A | PAD_B
	jr z, MoveSelectionMenu.matchedkeyspicked
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, MoveSelectionMenu.matchedkeyspicked
	; Disable left, right, and START buttons in regular battles.
	ld a, [wStatusFlags7]
	bit BIT_TEST_BATTLE, a
	ld b, ~(PAD_LEFT | PAD_RIGHT | PAD_START)
	jr z, MoveSelectionMenu.matchedkeyspicked
	ld b, PAD_CTRL_PAD | PAD_BUTTONS
MoveSelectionMenu.matchedkeyspicked
	ld a, b
	ld [hli], a ; wMenuWatchedKeys
	ld a, [wMoveMenuType]
	cp $1
	jr z, MoveSelectionMenu.movelistindex1
	ld a, [wPlayerMoveListIndex]
	inc a
MoveSelectionMenu.movelistindex1
	ld [hl], a
; fallthrough

SelectMenuItem:
	ld a, [wMoveMenuType]
	and a
	jr z, SelectMenuItem.battleselect
	dec a
	jr nz, SelectMenuItem.select
	hlcoord 1, 14
	ld de, WhichTechniqueString
	call PlaceString
	jr SelectMenuItem.select
SelectMenuItem.battleselect
	; Hide move swap cursor in TestBattle.
	ld a, [wStatusFlags7]
	bit BIT_TEST_BATTLE, a
	; This causes PrintMenuItem to not run in TestBattle.
	; MoveSelectionMenu still draws part of its window, an issue
	; which did not seem to exist in the Japanese versions.
	jr nz, SelectMenuItem.select
	call PrintMenuItem
	ld a, [wMenuItemToSwap]
	and a
	jr z, SelectMenuItem.select
	hlcoord 5, 13
	dec a
	ld bc, SCREEN_WIDTH
	call AddNTimes
	ld [hl], $ec
SelectMenuItem.select
	ld hl, hUILayoutFlags
	set BIT_DOUBLE_SPACED_MENU, [hl]
	call HandleMenuInput
	ld hl, hUILayoutFlags
	res BIT_DOUBLE_SPACED_MENU, [hl]
	bit B_PAD_UP, a
	jp nz, SelectMenuItem_CursorUp
	bit B_PAD_DOWN, a
	jp nz, SelectMenuItem_CursorDown
	bit B_PAD_SELECT, a
	jp nz, SwapMovesInMenu
	bit B_PAD_B, a
	push af
	xor a
	ld [wMenuItemToSwap], a
	ld a, [wCurrentMenuItem]
	dec a
	ld [wCurrentMenuItem], a
	ld b, a
	ld a, [wMoveMenuType]
	dec a ; if not mimic
	jr nz, SelectMenuItem.notB
	pop af
	ret
SelectMenuItem.notB
	dec a
	ld a, b
	ld [wPlayerMoveListIndex], a
	jr nz, SelectMenuItem.moveselected
	pop af
	ret
SelectMenuItem.moveselected
	pop af
	ret nz
	ld hl, wBattleMonPP
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	and PP_MASK
	jr z, SelectMenuItem.noPP
	ld a, [wPlayerDisabledMove]
	swap a
	and $f
	dec a
	cp c
	jr z, SelectMenuItem.disabled
	ld a, [wPlayerBattleStatus3]
	bit TRANSFORMED, a
	jr nz, SelectMenuItem.transformedMoveSelected
SelectMenuItem.transformedMoveSelected ; pointless
	; Allow moves copied by Transform to be used.
	ld a, [wCurrentMenuItem]
	ld hl, wBattleMonMoves
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wPlayerSelectedMove], a
	xor a
	ret
SelectMenuItem.disabled
	ld hl, MoveDisabledText
	jr SelectMenuItem.print
SelectMenuItem.noPP
	ld hl, MoveNoPPText
SelectMenuItem.print
	call PrintText
	call LoadScreenTilesFromBuffer1
	jp MoveSelectionMenu

MoveNoPPText:
	text_far WLA_GLOBAL_MoveNoPPText
	text_end

MoveDisabledText:
	text_far WLA_GLOBAL_MoveDisabledText
	text_end

WhichTechniqueString:
		.STRINGMAP pokemon, "WHICH TECHNIQUE?@"

SelectMenuItem_CursorUp:
	ld a, [wCurrentMenuItem]
	and a
	jp nz, SelectMenuItem
	call EraseMenuCursor
	ld a, [wNumMovesMinusOne]
	inc a
	ld [wCurrentMenuItem], a
	jp SelectMenuItem

SelectMenuItem_CursorDown:
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wNumMovesMinusOne]
	inc a
	inc a
	cp b
	jp nz, SelectMenuItem
	call EraseMenuCursor
	ld a, $1
	ld [wCurrentMenuItem], a
	jp SelectMenuItem

AnyMoveToSelect:
; return z and Struggle as the selected move if all moves have 0 PP and/or are disabled
	ld a, STRUGGLE
	ld [wPlayerSelectedMove], a
	ld a, [wPlayerDisabledMove]
	and a
	ld hl, wBattleMonPP
	jr nz, AnyMoveToSelect.handleDisabledMove
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	and PP_MASK
	ret nz
	jr AnyMoveToSelect.noMovesLeft
AnyMoveToSelect.handleDisabledMove
	swap a
	and $f ; get disabled move
	ld b, a
	ld d, NUM_MOVES + 1
	xor a
AnyMoveToSelect.handleDisabledMovePPLoop
	dec d
	jr z, AnyMoveToSelect.allMovesChecked
	ld c, [hl] ; get move PP
	inc hl
	dec b ; is this the disabled move?
	jr z, AnyMoveToSelect.handleDisabledMovePPLoop ; if so, ignore its PP value
	or c
	jr AnyMoveToSelect.handleDisabledMovePPLoop
AnyMoveToSelect.allMovesChecked
	and a ; any PP left?
	ret nz ; return if a move has PP left
AnyMoveToSelect.noMovesLeft
	ld hl, NoMovesLeftText
	call PrintText
	ld c, 60
	call DelayFrames
	xor a
	ret

NoMovesLeftText:
	text_far WLA_GLOBAL_NoMovesLeftText
	text_end

SwapMovesInMenu:
	ld a, [wMenuItemToSwap]
	and a
	jr z, SwapMovesInMenu.noMenuItemSelected
	ld hl, wBattleMonMoves
	call SwapMovesInMenu.swapBytes ; swap moves
	ld hl, wBattleMonPP
	call SwapMovesInMenu.swapBytes ; swap move PP
; update the index of the disabled move if necessary
	ld hl, wPlayerDisabledMove
	ld a, [hl]
	swap a
	and $f
	ld b, a
	ld a, [wCurrentMenuItem]
	cp b
	jr nz, SwapMovesInMenu.next
	ld a, [hl]
	and $f
	ld b, a
	ld a, [wMenuItemToSwap]
	swap a
	add b
	ld [hl], a
	jr SwapMovesInMenu.swapMovesInPartyMon
SwapMovesInMenu.next
	ld a, [wMenuItemToSwap]
	cp b
	jr nz, SwapMovesInMenu.swapMovesInPartyMon
	ld a, [hl]
	and $f
	ld b, a
	ld a, [wCurrentMenuItem]
	swap a
	add b
	ld [hl], a
SwapMovesInMenu.swapMovesInPartyMon
	ld hl, wPartyMon1Moves
	ld a, [wPlayerMonNumber]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	push hl
	call SwapMovesInMenu.swapBytes ; swap moves
	pop hl
	ld bc, MON_PP - MON_MOVES
	add hl, bc
	call SwapMovesInMenu.swapBytes ; swap move PP
	xor a
	ld [wMenuItemToSwap], a ; deselect the item
	jp MoveSelectionMenu
SwapMovesInMenu.swapBytes
	push hl
	ld a, [wMenuItemToSwap]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wCurrentMenuItem]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret
SwapMovesInMenu.noMenuItemSelected
	ld a, [wCurrentMenuItem]
	ld [wMenuItemToSwap], a ; select the current menu item for swapping
	jp MoveSelectionMenu

PrintMenuItem:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	hlcoord 0, 8
	ld b, 3
	ld c, 9
	call TextBoxBorder
	ld a, [wPlayerDisabledMove]
	and a
	jr z, PrintMenuItem.notDisabled
	swap a
	and $f
	ld b, a
	ld a, [wCurrentMenuItem]
	cp b
	jr nz, PrintMenuItem.notDisabled
	hlcoord 1, 10
	ld de, DisabledText
	call PlaceString
	jr PrintMenuItem.moveDisabled
PrintMenuItem.notDisabled
	ld hl, wCurrentMenuItem
	dec [hl]
	xor a
	ldh [lobyte(hWhoseTurn)], a
	ld hl, wBattleMonMoves
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0 ; which item in the menu is the cursor pointing to? (0-3)
	add hl, bc ; point to the item (move) in memory
	ld a, [hl]
	ld [wPlayerSelectedMove], a ; update wPlayerSelectedMove even if the move
	                            ; isn't actually selected (just pointed to by the cursor)
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	ld a, BATTLE_MON_DATA
	ld [wMonDataLocation], a
	callfar GetMaxPP
	ld hl, wCurrentMenuItem
	ld c, [hl]
	inc [hl]
	ld b, $0
	ld hl, wBattleMonPP
	add hl, bc
	ld a, [hl]
	and PP_MASK
	ld [wBattleMenuCurrentPP], a
; print TYPE/<type> and <curPP>/<maxPP>
	hlcoord 1, 9
	ld de, TypeText
	call PlaceString
	hlcoord 7, 11
	ld [hl], $f3
	hlcoord 5, 9
	ld [hl], $f3
	hlcoord 5, 11
	ld de, wBattleMenuCurrentPP
	lb "bc", 1, 2
	call PrintNumber
	hlcoord 8, 11
	ld de, wMaxPP
	lb "bc", 1, 2
	call PrintNumber
	call GetCurrentMove
	hlcoord 2, 10
	predef PrintMoveType
PrintMenuItem.moveDisabled
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	jp Delay3

DisabledText:
		.STRINGMAP pokemon, "disabled!@"

TypeText:
		.STRINGMAP pokemon, "TYPE@"

SelectEnemyMove:
	ld a, [wLinkState]
	sub LINK_STATE_BATTLING
	jr nz, SelectEnemyMove.noLinkBattle
; link battle
	call SaveScreenTilesToBuffer1
	call LinkBattleExchangeData
	call LoadScreenTilesFromBuffer1
	ld a, [wSerialExchangeNybbleReceiveData]
	cp LINKBATTLE_STRUGGLE
	jp z, SelectEnemyMove.linkedOpponentUsedStruggle
	cp LINKBATTLE_NO_ACTION
	jr z, SelectEnemyMove.unableToSelectMove
	cp 4
	ret nc
	ld [wEnemyMoveListIndex], a
	ld c, a
	ld hl, wEnemyMonMoves
	ld b, 0
	add hl, bc
	ld a, [hl]
	jr SelectEnemyMove.done
SelectEnemyMove.noLinkBattle
	ld a, [wEnemyBattleStatus2]
	and (1 << NEEDS_TO_RECHARGE) | (1 << USING_RAGE) ; need to recharge or using rage
	ret nz
	ld hl, wEnemyBattleStatus1
	ld a, [hl]
	and (1 << CHARGING_UP) | (1 << THRASHING_ABOUT) ; using a charging move or thrash/petal dance
	ret nz
	ld a, [wEnemyMonStatus]
	and (1 << FRZ) | SLP_MASK
	ret nz
	ld a, [wEnemyBattleStatus1]
	and (1 << USING_TRAPPING_MOVE) | (1 << STORING_ENERGY) ; using a trapping move like wrap or bide
	ret nz
	ld a, [wPlayerBattleStatus1]
	bit USING_TRAPPING_MOVE, a ; caught in player's trapping move (e.g. wrap)
	jr z, SelectEnemyMove.canSelectMove
SelectEnemyMove.unableToSelectMove
	ld a, $ff
	jr SelectEnemyMove.done
SelectEnemyMove.canSelectMove
	ld hl, wEnemyMonMoves+1 ; 2nd enemy move
	ld a, [hld]
	and a
	jr nz, SelectEnemyMove.atLeastTwoMovesAvailable
	ld a, [wEnemyDisabledMove]
	and a
	ld a, STRUGGLE ; struggle if the only move is disabled
	jr nz, SelectEnemyMove.done
SelectEnemyMove.atLeastTwoMovesAvailable
	ld a, [wIsInBattle]
	dec a
	jr z, SelectEnemyMove.chooseRandomMove ; wild encounter
	callfar AIEnemyTrainerChooseMoves
SelectEnemyMove.chooseRandomMove
	push hl
	call BattleRandom
	ld b, 1 ; 25% chance to select move 1
	cp (25 * $ff / 100)
	jr c, SelectEnemyMove.moveChosen
	inc hl
	inc b ; 25% chance to select move 2
	cp (50 * $ff / 100)
	jr c, SelectEnemyMove.moveChosen
	inc hl
	inc b ; 25% chance to select move 3
	cp (75 * $ff / 100) - 1
	jr c, SelectEnemyMove.moveChosen
	inc hl
	inc b ; 25% chance to select move 4
SelectEnemyMove.moveChosen
	ld a, b
	dec a
	ld [wEnemyMoveListIndex], a
	ld a, [wEnemyDisabledMove]
	swap a
	and $f
	cp b
	ld a, [hl]
	pop hl
	jr z, SelectEnemyMove.chooseRandomMove ; move disabled, try again
	and a
	jr z, SelectEnemyMove.chooseRandomMove ; move non-existent, try again
SelectEnemyMove.done
	ld [wEnemySelectedMove], a
	ret
SelectEnemyMove.linkedOpponentUsedStruggle
	ld a, STRUGGLE
	jr SelectEnemyMove.done

; this appears to exchange data with the other gameboy during link battles
LinkBattleExchangeData:
	ld a, $ff
	ld [wSerialExchangeNybbleReceiveData], a
	ld a, [wPlayerMoveListIndex]
	cp LINKBATTLE_RUN ; is the player running from battle?
	jr z, LinkBattleExchangeData.doExchange
	ld a, [wActionResultOrTookBattleTurn]
	and a ; is the player switching in another mon?
	jr nz, LinkBattleExchangeData.switching
; the player used a move
	ld a, [wPlayerSelectedMove]
	cp STRUGGLE
	ld b, LINKBATTLE_STRUGGLE
	jr z, LinkBattleExchangeData.next
	dec b ; LINKBATTLE_NO_ACTION
	.ASSERT ((CANNOT_MOVE)-($ff)) < 1 && ((CANNOT_MOVE)-($ff)) > -1
	inc a
	jr z, LinkBattleExchangeData.next
	ld a, [wPlayerMoveListIndex]
	jr LinkBattleExchangeData.doExchange
LinkBattleExchangeData.switching
	ld a, [wWhichPokemon]
	add 4
	ld b, a
LinkBattleExchangeData.next
	ld a, b
LinkBattleExchangeData.doExchange
	ld [wSerialExchangeNybbleSendData], a
	vc_hook Wireless_start_exchange
	callfar PrintWaitingText
LinkBattleExchangeData.syncLoop1
	call Serial_ExchangeNybble
	call DelayFrame
	ld a, [wSerialExchangeNybbleReceiveData]
	inc a
	jr z, LinkBattleExchangeData.syncLoop1
	vc_hook Wireless_end_exchange
	vc_patch Wireless_net_delay_1
.IF defined(_RED_VC) || defined(_BLUE_VC)
	ld b, 26
.ELSE
	ld b, 10
.ENDIF
	vc_patch_end
LinkBattleExchangeData.syncLoop2
	call DelayFrame
	call Serial_ExchangeNybble
	dec b
	jr nz, LinkBattleExchangeData.syncLoop2
	vc_hook Wireless_start_send_zero_bytes
	vc_patch Wireless_net_delay_2
.IF defined(_RED_VC) || defined(_BLUE_VC)
	ld b, 26
.ELSE
	ld b, 10
.ENDIF
	vc_patch_end
LinkBattleExchangeData.syncLoop3
	call DelayFrame
	call Serial_SendZeroByte
	dec b
	jr nz, LinkBattleExchangeData.syncLoop3
	vc_hook Wireless_end_send_zero_bytes
	ret

ExecutePlayerMove:
	xor a
	ldh [lobyte(hWhoseTurn)], a ; set player's turn
	ld a, [wPlayerSelectedMove]
	.ASSERT ((CANNOT_MOVE)-($ff)) < 1 && ((CANNOT_MOVE)-($ff)) > -1
	inc a
	jp z, ExecutePlayerMoveDone ; if the player cannot move, skip most of their turn
	xor a
	ld [wMoveMissed], a
	ld [wMonIsDisobedient], a
	ld [wMoveDidntMiss], a
	ld a, EFFECTIVE
	ld [wDamageMultipliers], a
	ld a, [wActionResultOrTookBattleTurn]
	and a ; has the player already used the turn (e.g. by using an item, trying to run or switching pokemon)
	jp nz, ExecutePlayerMoveDone
	call PrintGhostText
	jp z, ExecutePlayerMoveDone
	call CheckPlayerStatusConditions
	jr nz, ExecutePlayerMove.playerHasNoSpecialCondition
	jp hl
ExecutePlayerMove.playerHasNoSpecialCondition
	call GetCurrentMove
	ld hl, wPlayerBattleStatus1
	bit CHARGING_UP, [hl] ; charging up for attack
	jr nz, PlayerCanExecuteChargingMove
	call CheckForDisobedience
	jp z, ExecutePlayerMoveDone

CheckIfPlayerNeedsToChargeUp:
	ld a, [wPlayerMoveEffect]
	cp CHARGE_EFFECT
	jp z, JumpMoveEffect
	cp FLY_EFFECT
	jp z, JumpMoveEffect
	jr PlayerCanExecuteMove

; in-battle stuff
PlayerCanExecuteChargingMove:
	ld hl, wPlayerBattleStatus1
	res CHARGING_UP, [hl] ; reset charging up and invulnerability statuses if mon was charging up for an attack
	                    ; being fully paralyzed or hurting oneself in confusion removes charging up status
	                    ; resulting in the Pokemon being invulnerable for the whole battle
	res INVULNERABLE, [hl]
PlayerCanExecuteMove:
	call DisplayUsedMoveText
	ld hl, DecrementPP
	ld de, wPlayerSelectedMove ; pointer to the move just used
	ld b, bank(DecrementPP)
	call Bankswitch
	ld a, [wPlayerMoveEffect] ; effect of the move just used
	ld hl, ResidualEffects1
	ld de, 1
	call IsInArray
	jp c, JumpMoveEffect ; ResidualEffects1 moves skip damage calculation and accuracy tests
	                    ; unless executed as part of their exclusive effect functions
	ld a, [wPlayerMoveEffect]
	ld hl, SpecialEffectsCont
	ld de, 1
	call IsInArray
	call c, JumpMoveEffect ; execute the effects of SpecialEffectsCont moves (e.g. Wrap, Thrash) but don't skip anything
PlayerCalcMoveDamage:
	ld a, [wPlayerMoveEffect]
	ld hl, SetDamageEffects
	ld de, 1
	call IsInArray
	jp c, PlayerCalcMoveDamage.moveHitTest ; SetDamageEffects moves (e.g. Seismic Toss and Super Fang) skip damage calculation
	call CriticalHitTest
	call HandleCounterMove
	jr z, HandleIfPlayerMoveMissed
	call GetDamageVarsForPlayerAttack
	call CalculateDamage
	jp z, PlayerCheckIfFlyOrChargeEffect ; for moves with 0 BP, skip any further damage calculation and, for now, skip MoveHitTest
	               ; for these moves, accuracy tests will only occur if they are called as part of the effect itself
	call AdjustDamageForMoveType
	call RandomizeDamage
PlayerCalcMoveDamage.moveHitTest
	call MoveHitTest
HandleIfPlayerMoveMissed:
	ld a, [wMoveMissed]
	and a
	jr z, GetPlayerAnimationType
	ld a, [wPlayerMoveEffect]
	sub EXPLODE_EFFECT
	jr z, PlayPlayerMoveAnimation ; don't play any animation if the move missed, unless it was EXPLODE_EFFECT
	jr PlayerCheckIfFlyOrChargeEffect
GetPlayerAnimationType:
	ld a, [wPlayerMoveEffect]
	and a
	ld a, ANIMATIONTYPE_BLINK_ENEMY_MON_SPRITE ; move has no effect other than dealing damage
	jr z, PlayPlayerMoveAnimation
	ld a, ANIMATIONTYPE_SHAKE_SCREEN_HORIZONTALLY_LIGHT ; move has effect
PlayPlayerMoveAnimation:
	push af
	ld a, [wPlayerBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a
	ld hl, HideSubstituteShowMonAnim
	ld b, bank(HideSubstituteShowMonAnim)
	call nz, Bankswitch
	pop af
	ld [wAnimationType], a
	ld a, [wPlayerMoveNum]
	call PlayMoveAnimation
	call HandleExplodingAnimation
	call DrawPlayerHUDAndHPBar
	ld a, [wPlayerBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a
	ld hl, ReshowSubstituteAnim
	ld b, bank(ReshowSubstituteAnim)
	call nz, Bankswitch
	jr MirrorMoveCheck
PlayerCheckIfFlyOrChargeEffect:
	ld c, 30
	call DelayFrames
	ld a, [wPlayerMoveEffect]
	cp FLY_EFFECT
	jr z, PlayerCheckIfFlyOrChargeEffect.playAnim
	cp CHARGE_EFFECT
	jr z, PlayerCheckIfFlyOrChargeEffect.playAnim
	jr MirrorMoveCheck
PlayerCheckIfFlyOrChargeEffect.playAnim
	xor a
	ld [wAnimationType], a
	ld a, STATUS_AFFECTED_ANIM
	call PlayMoveAnimation
MirrorMoveCheck:
	ld a, [wPlayerMoveEffect]
	cp MIRROR_MOVE_EFFECT
	jr nz, MirrorMoveCheck.metronomeCheck
	call MirrorMoveCopyMove
	jp z, ExecutePlayerMoveDone
	xor a
	ld [wMonIsDisobedient], a
	jp CheckIfPlayerNeedsToChargeUp ; if Mirror Move was successful go back to damage calculation for copied move
MirrorMoveCheck.metronomeCheck
	cp METRONOME_EFFECT
	jr nz, MirrorMoveCheck.next
	call MetronomePickMove
	jp CheckIfPlayerNeedsToChargeUp ; Go back to damage calculation for the move picked by Metronome
MirrorMoveCheck.next
	ld a, [wPlayerMoveEffect]
	ld hl, ResidualEffects2
	ld de, 1
	call IsInArray
	jp c, JumpMoveEffect ; done here after executing effects of ResidualEffects2
	ld a, [wMoveMissed]
	and a
	jr z, MirrorMoveCheck.moveDidNotMiss
	call PrintMoveFailureText
	ld a, [wPlayerMoveEffect]
	cp EXPLODE_EFFECT ; even if Explosion or Selfdestruct missed, its effect still needs to be activated
	jr z, MirrorMoveCheck.notDone
	jp ExecutePlayerMoveDone ; otherwise, we're done if the move missed
MirrorMoveCheck.moveDidNotMiss
	call ApplyAttackToEnemyPokemon
	call PrintCriticalOHKOText
	callfar DisplayEffectiveness
	ld a, 1
	ld [wMoveDidntMiss], a
MirrorMoveCheck.notDone
	ld a, [wPlayerMoveEffect]
	ld hl, AlwaysHappenSideEffects
	ld de, 1
	call IsInArray
	call c, JumpMoveEffect ; not done after executing effects of AlwaysHappenSideEffects
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld b, [hl]
	or b
	ret z ; don't do anything else if the enemy fainted
	call HandleBuildingRage

	ld hl, wPlayerBattleStatus1
	bit ATTACKING_MULTIPLE_TIMES, [hl]
	jr z, MirrorMoveCheck.executeOtherEffects
	ld a, [wPlayerNumAttacksLeft]
	dec a
	ld [wPlayerNumAttacksLeft], a
	jp nz, GetPlayerAnimationType ; for multi-hit moves, apply attack until PlayerNumAttacksLeft hits 0 or the enemy faints.
	                             ; damage calculation and accuracy tests only happen for the first hit
	res ATTACKING_MULTIPLE_TIMES, [hl] ; clear attacking multiple times status when all attacks are over
	ld hl, MultiHitText
	call PrintText
	xor a
	ld [wPlayerNumHits], a
MirrorMoveCheck.executeOtherEffects
	ld a, [wPlayerMoveEffect]
	and a
	jp z, ExecutePlayerMoveDone
	ld hl, SpecialEffects
	ld de, 1
	call IsInArray
	call nc, JumpMoveEffect ; move effects not included in SpecialEffects or in either of the ResidualEffect arrays,
	; which are the effects not covered yet. Rage effect will be executed for a second time (though it's irrelevant).
	; Includes side effects that only need to be called if the target didn't faint.
	; Responsible for executing Twineedle's second side effect (poison).
	jp ExecutePlayerMoveDone

MultiHitText:
	text_far WLA_GLOBAL_MultiHitText
	text_end

ExecutePlayerMoveDone:
	xor a
	ld [wActionResultOrTookBattleTurn], a
	ld b, 1
	ret

PrintGhostText:
; print the ghost battle messages
	call IsGhostBattle
	ret nz
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr nz, PrintGhostText.Ghost
	ld a, [wBattleMonStatus] ; player's turn
	and (1 << FRZ) | SLP_MASK
	ret nz
	ld hl, ScaredText
	call PrintText
	xor a
	ret
PrintGhostText.Ghost ; ghost's turn
	ld hl, GetOutText
	call PrintText
	xor a
	ret

ScaredText:
	text_far WLA_GLOBAL_ScaredText
	text_end

GetOutText:
	text_far WLA_GLOBAL_GetOutText
	text_end

IsGhostBattle:
	ld a, [wIsInBattle]
	dec a
	ret nz
	ld a, [wCurMap]
	cp POKEMON_TOWER_1F
	jr c, IsGhostBattle.next
	cp POKEMON_TOWER_7F + 1
	jr nc, IsGhostBattle.next
	ld b, SILPH_SCOPE
	call IsItemInBag
	ret z
IsGhostBattle.next
	ld a, 1
	and a
	ret

; checks for various status conditions affecting the player mon
; stores whether the mon cannot use a move this turn in Z flag
CheckPlayerStatusConditions:
	ld hl, wBattleMonStatus
	ld a, [hl]
	and SLP_MASK
	jr z, CheckPlayerStatusConditions.FrozenCheck
; sleeping
	dec a
	ld [wBattleMonStatus], a ; decrement number of turns left
	and a
	jr z, CheckPlayerStatusConditions.WakeUp ; if the number of turns hit 0, wake up
; fast asleep
	xor a
	ld [wAnimationType], a
	ld a, SLP_PLAYER_ANIM
	call PlayMoveAnimation
	ld hl, FastAsleepText
	call PrintText
	jr CheckPlayerStatusConditions.sleepDone
CheckPlayerStatusConditions.WakeUp
	ld hl, WokeUpText
	call PrintText
CheckPlayerStatusConditions.sleepDone
	xor a
	ld [wPlayerUsedMove], a
	ld hl, ExecutePlayerMoveDone ; player can't move this turn
	jp CheckPlayerStatusConditions.returnToHL

CheckPlayerStatusConditions.FrozenCheck
	bit FRZ, [hl] ; frozen?
	jr z, CheckPlayerStatusConditions.HeldInPlaceCheck
	ld hl, IsFrozenText
	call PrintText
	xor a
	ld [wPlayerUsedMove], a
	ld hl, ExecutePlayerMoveDone ; player can't move this turn
	jp CheckPlayerStatusConditions.returnToHL

CheckPlayerStatusConditions.HeldInPlaceCheck
	ld a, [wEnemyBattleStatus1]
	bit USING_TRAPPING_MOVE, a ; is enemy using a multi-turn move like wrap?
	jp z, CheckPlayerStatusConditions.FlinchedCheck
	ld hl, CantMoveText
	call PrintText
	ld hl, ExecutePlayerMoveDone ; player can't move this turn
	jp CheckPlayerStatusConditions.returnToHL

CheckPlayerStatusConditions.FlinchedCheck
	ld hl, wPlayerBattleStatus1
	bit FLINCHED, [hl]
	jp z, CheckPlayerStatusConditions.HyperBeamCheck
	res FLINCHED, [hl] ; reset player's flinch status
	ld hl, FlinchedText
	call PrintText
	ld hl, ExecutePlayerMoveDone ; player can't move this turn
	jp CheckPlayerStatusConditions.returnToHL

CheckPlayerStatusConditions.HyperBeamCheck
	ld hl, wPlayerBattleStatus2
	bit NEEDS_TO_RECHARGE, [hl]
	jr z, CheckPlayerStatusConditions.AnyMoveDisabledCheck
	res NEEDS_TO_RECHARGE, [hl] ; reset player's recharge status
	ld hl, MustRechargeText
	call PrintText
	ld hl, ExecutePlayerMoveDone ; player can't move this turn
	jp CheckPlayerStatusConditions.returnToHL

CheckPlayerStatusConditions.AnyMoveDisabledCheck
	ld hl, wPlayerDisabledMove
	ld a, [hl]
	and a
	jr z, CheckPlayerStatusConditions.ConfusedCheck
	dec a
	ld [hl], a
	and $f ; did Disable counter hit 0?
	jr nz, CheckPlayerStatusConditions.ConfusedCheck
	ld [hl], a
	ld [wPlayerDisabledMoveNumber], a
	ld hl, DisabledNoMoreText
	call PrintText

CheckPlayerStatusConditions.ConfusedCheck
	ld a, [wPlayerBattleStatus1]
	add a ; is player confused?
	jr nc, CheckPlayerStatusConditions.TriedToUseDisabledMoveCheck
	ld hl, wPlayerConfusedCounter
	dec [hl]
	jr nz, CheckPlayerStatusConditions.IsConfused
	ld hl, wPlayerBattleStatus1
	res CONFUSED, [hl] ; if confused counter hit 0, reset confusion status
	ld hl, ConfusedNoMoreText
	call PrintText
	jr CheckPlayerStatusConditions.TriedToUseDisabledMoveCheck
CheckPlayerStatusConditions.IsConfused
	ld hl, IsConfusedText
	call PrintText
	xor a
	ld [wAnimationType], a
	ld a, CONF_PLAYER_ANIM
	call PlayMoveAnimation
	call BattleRandom
	cp (50 * $ff / 100) + 1 ; chance to hurt itself
	jr c, CheckPlayerStatusConditions.TriedToUseDisabledMoveCheck
	ld hl, wPlayerBattleStatus1
	ld a, [hl]
	and 1 << CONFUSED ; if mon hurts itself, clear every other status from wPlayerBattleStatus1
	ld [hl], a
	call HandleSelfConfusionDamage
	jr CheckPlayerStatusConditions.MonHurtItselfOrFullyParalysed

CheckPlayerStatusConditions.TriedToUseDisabledMoveCheck
; prevents a disabled move that was selected before being disabled from being used
	ld a, [wPlayerDisabledMoveNumber]
	and a
	jr z, CheckPlayerStatusConditions.ParalysisCheck
	ld hl, wPlayerSelectedMove
	cp [hl]
	jr nz, CheckPlayerStatusConditions.ParalysisCheck
	call PrintMoveIsDisabledText
	ld hl, ExecutePlayerMoveDone ; if a disabled move was somehow selected, player can't move this turn
	jp CheckPlayerStatusConditions.returnToHL

CheckPlayerStatusConditions.ParalysisCheck
	ld hl, wBattleMonStatus
	bit PAR, [hl]
	jr z, CheckPlayerStatusConditions.BideCheck
	call BattleRandom
	cp (25 * $ff / 100) ; chance to be fully paralyzed
	jr nc, CheckPlayerStatusConditions.BideCheck
	ld hl, FullyParalyzedText
	call PrintText

CheckPlayerStatusConditions.MonHurtItselfOrFullyParalysed
	ld hl, wPlayerBattleStatus1
	ld a, [hl]
	; clear bide, thrashing, charging up, and trapping moves such as warp (already cleared for confusion damage)
	and ~((1 << STORING_ENERGY) | (1 << THRASHING_ABOUT) | (1 << CHARGING_UP) | (1 << USING_TRAPPING_MOVE))
	ld [hl], a
	ld a, [wPlayerMoveEffect]
	cp FLY_EFFECT
	jr z, CheckPlayerStatusConditions.FlyOrChargeEffect
	cp CHARGE_EFFECT
	jr z, CheckPlayerStatusConditions.FlyOrChargeEffect
	jr CheckPlayerStatusConditions.NotFlyOrChargeEffect

CheckPlayerStatusConditions.FlyOrChargeEffect
	xor a
	ld [wAnimationType], a
	ld a, STATUS_AFFECTED_ANIM
	call PlayMoveAnimation
CheckPlayerStatusConditions.NotFlyOrChargeEffect
	ld hl, ExecutePlayerMoveDone
	jp CheckPlayerStatusConditions.returnToHL ; if using a two-turn move, we need to recharge the first turn

CheckPlayerStatusConditions.BideCheck
	ld hl, wPlayerBattleStatus1
	bit STORING_ENERGY, [hl] ; is mon using bide?
	jr z, CheckPlayerStatusConditions.ThrashingAboutCheck
	xor a
	ld [wPlayerMoveNum], a
	ld hl, wDamage
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wPlayerBideAccumulatedDamage + 1
	ld a, [hl]
	add c ; accumulate damage taken
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a
	ld hl, wPlayerNumAttacksLeft
	dec [hl] ; did Bide counter hit 0?
	jr z, CheckPlayerStatusConditions.UnleashEnergy
	ld hl, ExecutePlayerMoveDone
	jp CheckPlayerStatusConditions.returnToHL ; unless mon unleashes energy, can't move this turn
CheckPlayerStatusConditions.UnleashEnergy
	ld hl, wPlayerBattleStatus1
	res STORING_ENERGY, [hl] ; not using bide any more
	ld hl, UnleashedEnergyText
	call PrintText
	ld a, 1
	ld [wPlayerMovePower], a
	ld hl, wPlayerBideAccumulatedDamage + 1
	ld a, [hld]
	add a
	ld b, a
	ld [wDamage + 1], a
	ld a, [hl]
	rl a ; double the damage
	ld [wDamage], a
	or b
	jr nz, CheckPlayerStatusConditions.next
	ld a, 1
	ld [wMoveMissed], a
CheckPlayerStatusConditions.next
	xor a
	ld [hli], a
	ld [hl], a
	ld a, BIDE
	ld [wPlayerMoveNum], a
	ld hl, HandleIfPlayerMoveMissed ; skip damage calculation, DecrementPP and MoveHitTest
	jp CheckPlayerStatusConditions.returnToHL

CheckPlayerStatusConditions.ThrashingAboutCheck
	bit THRASHING_ABOUT, [hl] ; is mon using thrash or petal dance?
	jr z, CheckPlayerStatusConditions.MultiturnMoveCheck
	ld a, THRASH
	ld [wPlayerMoveNum], a
	ld hl, ThrashingAboutText
	call PrintText
	ld hl, wPlayerNumAttacksLeft
	dec [hl] ; did Thrashing About counter hit 0?
	ld hl, PlayerCalcMoveDamage ; skip DecrementPP
	jp nz, CheckPlayerStatusConditions.returnToHL
	push hl
	ld hl, wPlayerBattleStatus1
	res THRASHING_ABOUT, [hl] ; no longer thrashing about
	set CONFUSED, [hl] ; confused
	call BattleRandom
	and 3
	inc a
	inc a ; confused for 2-5 turns
	ld [wPlayerConfusedCounter], a
	pop hl ; skip DecrementPP
	jp CheckPlayerStatusConditions.returnToHL

CheckPlayerStatusConditions.MultiturnMoveCheck
	bit USING_TRAPPING_MOVE, [hl] ; is mon using multi-turn move?
	jp z, CheckPlayerStatusConditions.RageCheck
	ld hl, AttackContinuesText
	call PrintText
	ld a, [wPlayerNumAttacksLeft]
	dec a
	ld [wPlayerNumAttacksLeft], a
	ld hl, GetPlayerAnimationType ; skip damage calculation (deal damage equal to last hit),
	                              ; DecrementPP and MoveHitTest
	jp nz, CheckPlayerStatusConditions.returnToHL  ; redundant leftover code, the case wEnemyNumAttacksLeft = 0
						; is handled within CheckNumAttacksLeft
	jp CheckPlayerStatusConditions.returnToHL

CheckPlayerStatusConditions.RageCheck
	ld a, [wPlayerBattleStatus2]
	bit USING_RAGE, a ; is mon using rage?
	jp z, CheckPlayerStatusConditions.checkPlayerStatusConditionsDone ; if we made it this far, mon can move normally this turn
	ld a, RAGE
	ld [wNamedObjectIndex], a
	call GetMoveName
	call CopyToStringBuffer
	xor a
	ld [wPlayerMoveEffect], a
	ld hl, PlayerCanExecuteMove
	jp CheckPlayerStatusConditions.returnToHL

CheckPlayerStatusConditions.returnToHL
	xor a
	ret

CheckPlayerStatusConditions.checkPlayerStatusConditionsDone
	ld a, $1
	and a
	ret

FastAsleepText:
	text_far WLA_GLOBAL_FastAsleepText
	text_end

WokeUpText:
	text_far WLA_GLOBAL_WokeUpText
	text_end

IsFrozenText:
	text_far WLA_GLOBAL_IsFrozenText
	text_end

FullyParalyzedText:
	text_far WLA_GLOBAL_FullyParalyzedText
	text_end

FlinchedText:
	text_far WLA_GLOBAL_FlinchedText
	text_end

MustRechargeText:
	text_far WLA_GLOBAL_MustRechargeText
	text_end

DisabledNoMoreText:
	text_far WLA_GLOBAL_DisabledNoMoreText
	text_end

IsConfusedText:
	text_far WLA_GLOBAL_IsConfusedText
	text_end

HurtItselfText:
	text_far WLA_GLOBAL_HurtItselfText
	text_end

ConfusedNoMoreText:
	text_far WLA_GLOBAL_ConfusedNoMoreText
	text_end

SavingEnergyText: ; unreferenced
	text_far WLA_GLOBAL_SavingEnergyText
	text_end

UnleashedEnergyText:
	text_far WLA_GLOBAL_UnleashedEnergyText
	text_end

ThrashingAboutText:
	text_far WLA_GLOBAL_ThrashingAboutText
	text_end

AttackContinuesText:
	text_far WLA_GLOBAL_AttackContinuesText
	text_end

CantMoveText:
	text_far WLA_GLOBAL_CantMoveText
	text_end

PrintMoveIsDisabledText:
	ld hl, wPlayerSelectedMove
	ld de, wPlayerBattleStatus1
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, PrintMoveIsDisabledText.removeChargingUp
	inc hl
	ld de, wEnemyBattleStatus1
PrintMoveIsDisabledText.removeChargingUp
	ld a, [de]
	res CHARGING_UP, a ; end the pokemon's
	ld [de], a
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetMoveName
	ld hl, MoveIsDisabledText
	jp PrintText

MoveIsDisabledText:
	text_far WLA_GLOBAL_MoveIsDisabledText
	text_end

HandleSelfConfusionDamage:
	ld hl, HurtItselfText
	call PrintText
	ld hl, wEnemyMonDefense
	ld a, [hli]
	push af
	ld a, [hld]
	push af
	ld a, [wBattleMonDefense]
	ld [hli], a
	ld a, [wBattleMonDefense + 1]
	ld [hl], a
	ld hl, wPlayerMoveEffect
	push hl
	ld a, [hl]
	push af
	xor a
	ld [hli], a
	ld [wCriticalHitOrOHKO], a ; self-inflicted confusion damage can't be a Critical Hit
	ld a, 40 ; 40 base power
	ld [hli], a
	xor a
	ld [hl], a
	call GetDamageVarsForPlayerAttack
	call CalculateDamage ; ignores AdjustDamageForMoveType (type-less damage), RandomizeDamage,
	                     ; and MoveHitTest (always hits)
	pop af
	pop hl
	ld [hl], a
	ld hl, wEnemyMonDefense + 1
	pop af
	ld [hld], a
	pop af
	ld [hl], a
	xor a
	ld [wAnimationType], a
	inc a
	ldh [lobyte(hWhoseTurn)], a
	call PlayMoveAnimation
	call DrawPlayerHUDAndHPBar
	xor a
	ldh [lobyte(hWhoseTurn)], a
	jp ApplyDamageToPlayerPokemon

.INCLUDE "engine/battle/used_move_text.asm"

PrintMoveFailureText:
	ld de, wPlayerMoveEffect
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, PrintMoveFailureText.playersTurn
	ld de, wEnemyMoveEffect
PrintMoveFailureText.playersTurn
	ld hl, DoesntAffectMonText
	ld a, [wDamageMultipliers]
	and EFFECTIVENESS_MASK
	jr z, PrintMoveFailureText.gotTextToPrint
	ld hl, AttackMissedText
	ld a, [wCriticalHitOrOHKO]
	cp $ff
	jr nz, PrintMoveFailureText.gotTextToPrint
	ld hl, UnaffectedText
PrintMoveFailureText.gotTextToPrint
	push de
	call PrintText
	xor a
	ld [wCriticalHitOrOHKO], a
	pop de
	ld a, [de]
	cp JUMP_KICK_EFFECT
	ret nz

	; if you get here, the mon used jump kick or hi jump kick and missed
	ld hl, wDamage ; since the move missed, wDamage will always contain 0 at this point.
	                ; Thus, recoil damage will always be equal to 1
	                ; even if it was intended to be potential damage/8.
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b
	srl a
	rr b
	ld [hl], b
	dec hl
	ld [hli], a
	or b
	jr nz, PrintMoveFailureText.applyRecoil
	inc a
	ld [hl], a
PrintMoveFailureText.applyRecoil
	ld hl, KeptGoingAndCrashedText
	call PrintText
	ld b, $4
	predef PredefShakeScreenHorizontally
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr nz, PrintMoveFailureText.enemyTurn
	jp ApplyDamageToPlayerPokemon
PrintMoveFailureText.enemyTurn
	jp ApplyDamageToEnemyPokemon

AttackMissedText:
	text_far WLA_GLOBAL_AttackMissedText
	text_end

KeptGoingAndCrashedText:
	text_far WLA_GLOBAL_KeptGoingAndCrashedText
	text_end

UnaffectedText:
	text_far WLA_GLOBAL_UnaffectedText
	text_end

PrintDoesntAffectText:
	ld hl, DoesntAffectMonText
	jp PrintText

DoesntAffectMonText:
	text_far WLA_GLOBAL_DoesntAffectMonText
	text_end

; if there was a critical hit or an OHKO was successful, print the corresponding text
PrintCriticalOHKOText:
	ld a, [wCriticalHitOrOHKO]
	and a
	jr z, PrintCriticalOHKOText.done ; do nothing if there was no critical hit or successful OHKO
	dec a
	add a
	ld hl, CriticalOHKOTextPointers
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	xor a
	ld [wCriticalHitOrOHKO], a
PrintCriticalOHKOText.done
	ld c, 20
	jp DelayFrames

CriticalOHKOTextPointers:
	.DW CriticalHitText
	.DW OHKOText

CriticalHitText:
	text_far WLA_GLOBAL_CriticalHitText
	text_end

OHKOText:
	text_far WLA_GLOBAL_OHKOText
	text_end

; checks if a traded mon will disobey due to lack of badges
; stores whether the mon will use a move in Z flag
CheckForDisobedience:
	xor a
	ld [wMonIsDisobedient], a
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, CheckForDisobedience.checkIfMonIsTraded
	ld a, $1
	and a
	ret
; compare the mon's original trainer ID with the player's ID to see if it was traded
CheckForDisobedience.checkIfMonIsTraded
	ld hl, wPartyMon1OTID
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wPlayerMonNumber]
	call AddNTimes
	ld a, [wPlayerID]
	cp [hl]
	jr nz, CheckForDisobedience.monIsTraded
	inc hl
	ld a, [wPlayerID + 1]
	cp [hl]
	jp z, CheckForDisobedience.canUseMove
; it was traded
CheckForDisobedience.monIsTraded
; what level might disobey?
	ld hl, wObtainedBadges
	bit BIT_EARTHBADGE, [hl]
	ld a, 101
	jr nz, CheckForDisobedience.next
	bit BIT_MARSHBADGE, [hl]
	ld a, 70
	jr nz, CheckForDisobedience.next
	bit BIT_RAINBOWBADGE, [hl]
	ld a, 50
	jr nz, CheckForDisobedience.next
	bit BIT_CASCADEBADGE, [hl]
	ld a, 30
	jr nz, CheckForDisobedience.next
	ld a, 10
CheckForDisobedience.next
	ld b, a
	ld c, a
	ld a, [wBattleMonLevel]
	ld d, a
	add b
	ld b, a
	jr nc, CheckForDisobedience.noCarry
	ld b, $ff ; cap b at $ff
CheckForDisobedience.noCarry
	ld a, c
	cp d
	jp nc, CheckForDisobedience.canUseMove
CheckForDisobedience.loop1
	call BattleRandom
	swap a
	cp b
	jr nc, CheckForDisobedience.loop1
	cp c
	jp c, CheckForDisobedience.canUseMove
CheckForDisobedience.loop2
	call BattleRandom
	cp b
	jr nc, CheckForDisobedience.loop2
	cp c
	jr c, CheckForDisobedience.useRandomMove
	ld a, d
	sub c
	ld b, a
	call BattleRandom
	swap a
	sub b
	jr c, CheckForDisobedience.monNaps
	cp b
	jr nc, CheckForDisobedience.monDoesNothing
	ld hl, WontObeyText
	call PrintText
	call HandleSelfConfusionDamage
	jp CheckForDisobedience.cannotUseMove
CheckForDisobedience.monNaps
	call BattleRandom
	add a
	swap a
	and SLP_MASK
	jr z, CheckForDisobedience.monNaps ; keep trying until we get at least 1 turn of sleep
	ld [wBattleMonStatus], a
	ld hl, BeganToNapText
	jr CheckForDisobedience.printText
CheckForDisobedience.monDoesNothing
	call BattleRandom
	and $3
	ld hl, LoafingAroundText
	and a
	jr z, CheckForDisobedience.printText
	ld hl, WontObeyText
	dec a
	jr z, CheckForDisobedience.printText
	ld hl, TurnedAwayText
	dec a
	jr z, CheckForDisobedience.printText
	ld hl, IgnoredOrdersText
CheckForDisobedience.printText
	call PrintText
	jr CheckForDisobedience.cannotUseMove
CheckForDisobedience.useRandomMove
	ld a, [wBattleMonMoves + 1]
	and a ; is the second move slot empty?
	jr z, CheckForDisobedience.monDoesNothing ; mon will not use move if it only knows one move
	ld a, [wPlayerDisabledMoveNumber]
	and a
	jr nz, CheckForDisobedience.monDoesNothing
	ld a, [wPlayerSelectedMove]
	cp STRUGGLE
	jr z, CheckForDisobedience.monDoesNothing ; mon will not use move if struggling
; check if only one move has remaining PP
	ld hl, wBattleMonPP
	push hl
	ld a, [hli]
	and PP_MASK
	ld b, a
	ld a, [hli]
	and PP_MASK
	add b
	ld b, a
	ld a, [hli]
	and PP_MASK
	add b
	ld b, a
	ld a, [hl]
	and PP_MASK
	add b
	pop hl
	push af
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	and PP_MASK
	ld b, a
	pop af
	cp b
	jr z, CheckForDisobedience.monDoesNothing ; mon will not use move if only one move has remaining PP
	ld a, $1
	ld [wMonIsDisobedient], a
	ld a, [wMaxMenuItem]
	ld b, a
	ld a, [wCurrentMenuItem]
	ld c, a
CheckForDisobedience.chooseMove
	call BattleRandom
	and $3
	cp b
	jr nc, CheckForDisobedience.chooseMove ; if the random number is greater than the move count, choose another
	cp c
	jr z, CheckForDisobedience.chooseMove ; if the random number matches the move the player selected, choose another
	ld [wCurrentMenuItem], a
	ld hl, wBattleMonPP
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	and a ; does the move have any PP left?
	jr z, CheckForDisobedience.chooseMove ; if the move has no PP left, choose another
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	ld hl, wBattleMonMoves
	add hl, bc
	ld a, [hl]
	ld [wPlayerSelectedMove], a
	call GetCurrentMove
CheckForDisobedience.canUseMove
	ld a, $1
	and a ; clear Z flag
	ret
CheckForDisobedience.cannotUseMove
	xor a ; set Z flag
	ret

LoafingAroundText:
	text_far WLA_GLOBAL_LoafingAroundText
	text_end

BeganToNapText:
	text_far WLA_GLOBAL_BeganToNapText
	text_end

WontObeyText:
	text_far WLA_GLOBAL_WontObeyText
	text_end

TurnedAwayText:
	text_far WLA_GLOBAL_TurnedAwayText
	text_end

IgnoredOrdersText:
	text_far WLA_GLOBAL_IgnoredOrdersText
	text_end

; sets b, c, d, and e for the CalculateDamage routine in the case of an attack by the player mon
GetDamageVarsForPlayerAttack:
	xor a
	ld hl, wDamage ; damage to eventually inflict, initialise to zero
	ld [hli], a
	ld [hl], a
	ld hl, wPlayerMovePower
	ld a, [hli]
	and a
	ld d, a ; d = move power
	ret z ; return if move power is zero
	ld a, [hl] ; a = [wPlayerMoveType]
	cp SPECIAL ; types >= SPECIAL are all special
	jr nc, GetDamageVarsForPlayerAttack.specialAttack
; physical attack
	ld hl, wEnemyMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = enemy defense
	ld a, [wEnemyBattleStatus3]
	bit HAS_REFLECT_UP, a ; check for Reflect
	jr z, GetDamageVarsForPlayerAttack.physicalAttackCritCheck
; if the enemy has used Reflect, double the enemy's defense
	sla c
	rl b
GetDamageVarsForPlayerAttack.physicalAttackCritCheck
	ld hl, wBattleMonAttack
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, GetDamageVarsForPlayerAttack.scaleStats
; in the case of a critical hit, reset the player's attack and the enemy's defense to their base values
	ld c, STAT_DEFENSE
	call GetEnemyMonStat
	ldh a, [lobyte(hProduct + 2)]
	ld b, a
	ldh a, [lobyte(hProduct + 3)]
	ld c, a
	push bc
	ld hl, wPartyMon1Attack
	ld a, [wPlayerMonNumber]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	jr GetDamageVarsForPlayerAttack.scaleStats
GetDamageVarsForPlayerAttack.specialAttack
	ld hl, wEnemyMonSpecial
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = enemy special
	ld a, [wEnemyBattleStatus3]
	bit HAS_LIGHT_SCREEN_UP, a ; check for Light Screen
	jr z, GetDamageVarsForPlayerAttack.specialAttackCritCheck
; if the enemy has used Light Screen, double the enemy's special
	sla c
	rl b
; reflect and light screen boosts do not cap the stat at MAX_STAT_VALUE, so weird things will happen during stats scaling
; if a Pokemon with 512 or more Defense has used Reflect, or if a Pokemon with 512 or more Special has used Light Screen
GetDamageVarsForPlayerAttack.specialAttackCritCheck
	ld hl, wBattleMonSpecial
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, GetDamageVarsForPlayerAttack.scaleStats
; in the case of a critical hit, reset the player's and enemy's specials to their base values
	ld c, STAT_SPECIAL
	call GetEnemyMonStat
	ldh a, [lobyte(hProduct + 2)]
	ld b, a
	ldh a, [lobyte(hProduct + 3)]
	ld c, a
	push bc
	ld hl, wPartyMon1Special
	ld a, [wPlayerMonNumber]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
; if either the offensive or defensive stat is too large to store in a byte, scale both stats by dividing them by 4
; this allows values with up to 10 bits (values up to 1023) to be handled
; anything larger will wrap around
GetDamageVarsForPlayerAttack.scaleStats
	ld a, [hli]
	ld l, [hl]
	ld h, a ; hl = player's offensive stat
	or b ; is either high byte nonzero?
	jr z, GetDamageVarsForPlayerAttack.next ; if not, we don't need to scale
; bc /= 4 (scale enemy's defensive stat)
	srl b
	rr c
	srl b
	rr c
; defensive stat can actually end up as 0, leading to a division by 0 freeze during damage calculation
; hl /= 4 (scale player's offensive stat)
	srl h
	rr l
	srl h
	rr l
	ld a, l
	or h ; is the player's offensive stat 0?
	jr nz, GetDamageVarsForPlayerAttack.next
	inc l ; if the player's offensive stat is 0, bump it up to 1
GetDamageVarsForPlayerAttack.next
	ld b, l ; b = player's offensive stat (possibly scaled)
	        ; (c already contains enemy's defensive stat (possibly scaled))
	ld a, [wBattleMonLevel]
	ld e, a ; e = level
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, GetDamageVarsForPlayerAttack.done
	sla e ; double level if it was a critical hit
GetDamageVarsForPlayerAttack.done
	ld a, 1
	and a
	ret

; sets b, c, d, and e for the CalculateDamage routine in the case of an attack by the enemy mon
GetDamageVarsForEnemyAttack:
	ld hl, wDamage ; damage to eventually inflict, initialise to zero
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wEnemyMovePower
	ld a, [hli]
	ld d, a ; d = move power
	and a
	ret z ; return if move power is zero
	ld a, [hl] ; a = [wEnemyMoveType]
	cp SPECIAL ; types >= SPECIAL are all special
	jr nc, GetDamageVarsForEnemyAttack.specialAttack
; physical attack
	ld hl, wBattleMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = player defense
	ld a, [wPlayerBattleStatus3]
	bit HAS_REFLECT_UP, a ; check for Reflect
	jr z, GetDamageVarsForEnemyAttack.physicalAttackCritCheck
; if the player has used Reflect, double the player's defense
	sla c
	rl b
GetDamageVarsForEnemyAttack.physicalAttackCritCheck
	ld hl, wEnemyMonAttack
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, GetDamageVarsForEnemyAttack.scaleStats
; in the case of a critical hit, reset the player's defense and the enemy's attack to their base values
	ld hl, wPartyMon1Defense
	ld a, [wPlayerMonNumber]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push bc
	ld c, STAT_ATTACK
	call GetEnemyMonStat
	ld hl, hProduct + 2
	pop bc
	jr GetDamageVarsForEnemyAttack.scaleStats
GetDamageVarsForEnemyAttack.specialAttack
	ld hl, wBattleMonSpecial
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, [wPlayerBattleStatus3]
	bit HAS_LIGHT_SCREEN_UP, a ; check for Light Screen
	jr z, GetDamageVarsForEnemyAttack.specialAttackCritCheck
; if the player has used Light Screen, double the player's special
	sla c
	rl b
; reflect and light screen boosts do not cap the stat at MAX_STAT_VALUE, so weird things will happen during stats scaling
; if a Pokemon with 512 or more Defense has used Reflect, or if a Pokemon with 512 or more Special has used Light Screen
GetDamageVarsForEnemyAttack.specialAttackCritCheck
	ld hl, wEnemyMonSpecial
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, GetDamageVarsForEnemyAttack.scaleStats
; in the case of a critical hit, reset the player's and enemy's specials to their base values
	ld hl, wPartyMon1Special
	ld a, [wPlayerMonNumber]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push bc
	ld c, STAT_SPECIAL
	call GetEnemyMonStat
	ld hl, hProduct + 2
	pop bc
; if either the offensive or defensive stat is too large to store in a byte, scale both stats by dividing them by 4
; this allows values with up to 10 bits (values up to 1023) to be handled
; anything larger will wrap around
GetDamageVarsForEnemyAttack.scaleStats
	ld a, [hli]
	ld l, [hl]
	ld h, a ; hl = enemy's offensive stat
	or b ; is either high byte nonzero?
	jr z, GetDamageVarsForEnemyAttack.next ; if not, we don't need to scale
; bc /= 4 (scale player's defensive stat)
	srl b
	rr c
	srl b
	rr c
; defensive stat can actually end up as 0, leading to a division by 0 freeze during damage calculation
; hl /= 4 (scale enemy's offensive stat)
	srl h
	rr l
	srl h
	rr l
	ld a, l
	or h ; is the enemy's offensive stat 0?
	jr nz, GetDamageVarsForEnemyAttack.next
	inc l ; if the enemy's offensive stat is 0, bump it up to 1
GetDamageVarsForEnemyAttack.next
	ld b, l ; b = enemy's offensive stat (possibly scaled)
	        ; (c already contains player's defensive stat (possibly scaled))
	ld a, [wEnemyMonLevel]
	ld e, a
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, GetDamageVarsForEnemyAttack.done
	sla e ; double level if it was a critical hit
GetDamageVarsForEnemyAttack.done
	ld a, $1
	and a
	and a
	ret

; get stat c of enemy mon
; c: stat to get (STAT_* constant)
GetEnemyMonStat:
	push de
	push bc
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, GetEnemyMonStat.notLinkBattle
	ld hl, wEnemyMon1Stats
	dec c
	sla c
	ld b, $0
	add hl, bc
	ld a, [wEnemyMonPartyPos]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hli]
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, [hl]
	ldh [lobyte(hMultiplicand + 2)], a
	pop bc
	pop de
	ret
GetEnemyMonStat.notLinkBattle
	ld a, [wEnemyMonLevel]
	ld [wCurEnemyLevel], a
	ld a, [wEnemyMonSpecies]
	ld [wCurSpecies], a
	call GetMonHeader
	ld hl, wEnemyMonDVs
	ld de, wLoadedMonSpeedExp
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	pop bc
	ld b, $0
	ld hl, wLoadedMonSpeedExp - $b ; this base address makes CalcStat look in [wLoadedMonSpeedExp] for DVs
	call CalcStat
	pop de
	ret

CalculateDamage:
; input:
;   b: attack
;   c: opponent defense
;   d: base power
;   e: level

	ldh a, [lobyte(hWhoseTurn)] ; whose turn?
	and a
	ld a, [wPlayerMoveEffect]
	jr z, CalculateDamage.effect
	ld a, [wEnemyMoveEffect]
CalculateDamage.effect

; EXPLODE_EFFECT halves defense.
	cp EXPLODE_EFFECT
	jr nz, CalculateDamage.ok
	srl c
	jr nz, CalculateDamage.ok
	inc c ; ...with a minimum value of 1 (used as a divisor later on)
CalculateDamage.ok

; Multi-hit attacks may or may not have 0 bp.
	cp TWO_TO_FIVE_ATTACKS_EFFECT
	jr z, CalculateDamage.skipbp
	cp EFFECT_1E
	jr z, CalculateDamage.skipbp

; Calculate OHKO damage based on remaining HP.
	cp OHKO_EFFECT
	jp z, JumpToOHKOMoveEffect

; Don't calculate damage for moves that don't do any.
	ld a, d ; base power
	and a
	ret z
CalculateDamage.skipbp

	xor a
	ld hl, hDividend
	ld [hli], a
	ld [hli], a
	ld [hl], a

; Multiply level by 2
	ld a, e ; level
	add a
	jr nc, CalculateDamage.nc
	push af
	ld a, 1
	ld [hl], a
	pop af
CalculateDamage.nc
	inc hl
	ld [hli], a

; Divide by 5
	ld a, 5
	ld [hld], a
	push bc
	ld b, 4
	call Divide
	pop bc

; Add 2
	inc [hl]
	inc [hl]

	inc hl ; multiplier

; Multiply by attack base power
	ld [hl], d
	call Multiply

; Multiply by attack stat
	ld [hl], b
	call Multiply

; Divide by defender's defense stat
	ld [hl], c
	ld b, 4
	call Divide

; Divide by 50
	ld [hl], 50
	ld b, 4
	call Divide

; Update wCurDamage.
; Capped at MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE: 999 - 2 = 997.
	ld hl, wDamage
	ld b, [hl]
	ldh a, [lobyte(hQuotient + 3)]
	add b
	ldh [lobyte(hQuotient + 3)], a
	jr nc, CalculateDamage.dont_cap_1

	ldh a, [lobyte(hQuotient + 2)]
	inc a
	ldh [lobyte(hQuotient + 2)], a
	and a
	jr z, CalculateDamage.cap

CalculateDamage.dont_cap_1
	ldh a, [lobyte(hQuotient)]
	ld b, a
	ldh a, [lobyte(hQuotient + 1)]
	or a
	jr nz, CalculateDamage.cap

	ldh a, [lobyte(hQuotient + 2)]
	cp hibyte(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1)
	jr c, CalculateDamage.dont_cap_2

	cp hibyte(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1) + 1
	jr nc, CalculateDamage.cap

	ldh a, [lobyte(hQuotient + 3)]
	cp lobyte(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1)
	jr nc, CalculateDamage.cap

CalculateDamage.dont_cap_2
	inc hl

	ldh a, [lobyte(hQuotient + 3)]
	ld b, [hl]
	add b
	ld [hld], a

	ldh a, [lobyte(hQuotient + 2)]
	ld b, [hl]
	adc b
	ld [hl], a
	jr c, CalculateDamage.cap

	ld a, [hl]
	cp hibyte(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1)
	jr c, CalculateDamage.dont_cap_3

	cp hibyte(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1) + 1
	jr nc, CalculateDamage.cap

	inc hl
	ld a, [hld]
	cp lobyte(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1)
	jr c, CalculateDamage.dont_cap_3

CalculateDamage.cap
	ld a, hibyte(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE)
	ld [hli], a
	ld a, lobyte(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE)
	ld [hld], a

CalculateDamage.dont_cap_3
; Add back MIN_NEUTRAL_DAMAGE (capping at 999).
	inc hl
	ld a, [hl]
	add MIN_NEUTRAL_DAMAGE
	ld [hld], a
	jr nc, CalculateDamage.dont_floor
	inc [hl]
CalculateDamage.dont_floor

; Returns nz and nc.
	ld a, 1
	and a
	ret

JumpToOHKOMoveEffect:
	call JumpMoveEffect
	ld a, [wMoveMissed]
	dec a
	ret

.INCLUDE "data/battle/unused_critical_hit_moves.asm"

; determines if attack is a critical hit
; Azure Heights claims "the fastest pokémon (who are, not coincidentally,
; among the most popular) tend to CH about 20 to 25% of the time."
CriticalHitTest:
	xor a
	ld [wCriticalHitOrOHKO], a
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld a, [wEnemyMonSpecies]
	jr nz, CriticalHitTest.handleEnemy
	ld a, [wBattleMonSpecies]
CriticalHitTest.handleEnemy
	ld [wCurSpecies], a
	call GetMonHeader
	ld a, [wMonHBaseSpeed]
	ld b, a
	srl b                        ; (effective (base speed/2))
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld hl, wPlayerMovePower
	ld de, wPlayerBattleStatus2
	jr z, CriticalHitTest.calcCriticalHitProbability
	ld hl, wEnemyMovePower
	ld de, wEnemyBattleStatus2
CriticalHitTest.calcCriticalHitProbability
	ld a, [hld]                  ; read base power from RAM
	and a
	ret z                        ; do nothing if zero
	dec hl
	ld c, [hl]                   ; read move id
	ld a, [de]
	bit GETTING_PUMPED, a        ; test for focus energy
	jr nz, CriticalHitTest.focusEnergyUsed      ; bug: using focus energy causes a shift to the right instead of left,
	                             ; resulting in 1/4 the usual crit chance
	sla b                        ; (effective (base speed/2)*2)
	jr nc, CriticalHitTest.noFocusEnergyUsed
	ld b, $ff                    ; cap at 255/256
	jr CriticalHitTest.noFocusEnergyUsed
CriticalHitTest.focusEnergyUsed
	srl b
CriticalHitTest.noFocusEnergyUsed
	ld hl, HighCriticalMoves     ; table of high critical hit moves
CriticalHitTest.Loop
	ld a, [hli]                  ; read move from move table
	cp c                         ; does it match the move about to be used?
	jr z, CriticalHitTest.HighCritical          ; if so, the move about to be used is a high critical hit ratio move
	inc a                        ; move on to the next move, FF terminates loop
	jr nz, CriticalHitTest.Loop                 ; check the next move in HighCriticalMoves
	srl b                        ; /2 for regular move (effective (base speed / 2))
	jr CriticalHitTest.SkipHighCritical         ; continue as a normal move
CriticalHitTest.HighCritical
	sla b                        ; *2 for high critical hit moves
	jr nc, CriticalHitTest.noCarry
	ld b, $ff                    ; cap at 255/256
CriticalHitTest.noCarry
	sla b                        ; *4 for high critical move (effective (base speed/2)*8))
	jr nc, CriticalHitTest.SkipHighCritical
	ld b, $ff
CriticalHitTest.SkipHighCritical
	call BattleRandom            ; generates a random value, in "a"
	rlc a
	rlc a
	rlc a
	cp b                         ; check a against calculated crit rate
	ret nc                       ; no critical hit if no borrow
	ld a, $1
	ld [wCriticalHitOrOHKO], a   ; set critical hit flag
	ret

.INCLUDE "data/battle/critical_hit_moves.asm"

; function to determine if Counter hits and if so, how much damage it does
HandleCounterMove:
; The variables checked by Counter are updated whenever the cursor points to a new move in the battle selection menu.
; This is irrelevant for the opponent's side outside of link battles, since the move selection is controlled by the AI.
; However, in the scenario where the player switches out and the opponent uses Counter,
; the outcome may be affected by the player's actions in the move selection menu prior to switching the Pokemon.
; This might also lead to desync glitches in link battles.

	ldh a, [lobyte(hWhoseTurn)] ; whose turn
	and a
; player's turn
	ld hl, wEnemySelectedMove
	ld de, wEnemyMovePower
	ld a, [wPlayerSelectedMove]
	jr z, HandleCounterMove.next
; enemy's turn
	ld hl, wPlayerSelectedMove
	ld de, wPlayerMovePower
	ld a, [wEnemySelectedMove]
HandleCounterMove.next
	cp COUNTER
	ret nz ; return if not using Counter
	ld a, $01
	ld [wMoveMissed], a ; initialize the move missed variable to true (it is set to false below if the move hits)
	ld a, [hl]
	cp COUNTER
	ret z ; miss if the opponent's last selected move is Counter.
	ld a, [de]
	and a
	ret z ; miss if the opponent's last selected move's Base Power is 0.
; check if the move the target last selected was Normal or Fighting type
	inc de
	ld a, [de]
	and a ; normal type
	jr z, HandleCounterMove.counterableType
	cp FIGHTING
	jr z, HandleCounterMove.counterableType
; if the move wasn't Normal or Fighting type, miss
	xor a
	ret
HandleCounterMove.counterableType
	ld hl, wDamage
	ld a, [hli]
	or [hl]
	ret z ; If we made it here, Counter still misses if the last move used in battle did no damage to its target.
	      ; wDamage is shared by both players, so Counter may strike back damage dealt by the Counter user itself
	      ; if the conditions meet, even though 99% of the times damage will come from the target.
; if it did damage, double it
	ld a, [hl]
	add a
	ld [hld], a
	ld a, [hl]
	adc a
	ld [hl], a
	jr nc, HandleCounterMove.noCarry
; damage is capped at 0xFFFF
	ld a, $ff
	ld [hli], a
	ld [hl], a
HandleCounterMove.noCarry
	xor a
	ld [wMoveMissed], a
	call MoveHitTest ; do the normal move hit test in addition to Counter's special rules
	xor a
	ret

ApplyAttackToEnemyPokemon:
	ld a, [wPlayerMoveEffect]
	cp OHKO_EFFECT
	jr z, ApplyDamageToEnemyPokemon
	cp SUPER_FANG_EFFECT
	jr z, ApplyAttackToEnemyPokemon.superFangEffect
	cp SPECIAL_DAMAGE_EFFECT
	jr z, ApplyAttackToEnemyPokemon.specialDamage
	ld a, [wPlayerMovePower]
	and a
	jp z, ApplyAttackToEnemyPokemonDone ; no attack to apply if base power is 0
	jr ApplyDamageToEnemyPokemon
ApplyAttackToEnemyPokemon.superFangEffect
; set the damage to half the target's HP
	ld hl, wEnemyMonHP
	ld de, wDamage
	ld a, [hli]
	srl a
	ld [de], a
	inc de
	ld b, a
	ld a, [hl]
	rr a
	ld [de], a
	or b
	jr nz, ApplyDamageToEnemyPokemon
; make sure Super Fang's damage is always at least 1
	ld a, $01
	ld [de], a
	jr ApplyDamageToEnemyPokemon
ApplyAttackToEnemyPokemon.specialDamage
	ld hl, wBattleMonLevel
	ld a, [hl]
	ld b, a ; Seismic Toss deals damage equal to the user's level
	ld a, [wPlayerMoveNum]
	cp SEISMIC_TOSS
	jr z, ApplyAttackToEnemyPokemon.storeDamage
	cp NIGHT_SHADE
	jr z, ApplyAttackToEnemyPokemon.storeDamage
	ld b, SONICBOOM_DAMAGE ; 20
	cp SONICBOOM
	jr z, ApplyAttackToEnemyPokemon.storeDamage
	ld b, DRAGON_RAGE_DAMAGE ; 40
	cp DRAGON_RAGE
	jr z, ApplyAttackToEnemyPokemon.storeDamage
; Psywave
	ld a, [hl]
	ld b, a
	srl a
	add b
	ld b, a ; b = level * 1.5
; loop until a random number in the range [1, b) is found
ApplyAttackToEnemyPokemon.loop
	call BattleRandom
	and a
	jr z, ApplyAttackToEnemyPokemon.loop
	cp b
	jr nc, ApplyAttackToEnemyPokemon.loop
	ld b, a
ApplyAttackToEnemyPokemon.storeDamage ; store damage value at b
	ld hl, wDamage
	xor a
	ld [hli], a
	ld a, b
	ld [hl], a

ApplyDamageToEnemyPokemon:
	ld hl, wDamage
	ld a, [hli]
	ld b, a
	ld a, [hl]
	or b
	jr z, ApplyAttackToEnemyPokemonDone ; we're done if damage is 0
	ld a, [wEnemyBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a ; does the enemy have a substitute?
	jp nz, AttackSubstitute
; subtract the damage from the pokemon's current HP
; also, save the current HP at wHPBarOldHP
	ld a, [hld]
	ld b, a
	ld a, [wEnemyMonHP + 1]
	ld [wHPBarOldHP], a
	sub b
	ld [wEnemyMonHP + 1], a
	ld a, [hl]
	ld b, a
	ld a, [wEnemyMonHP]
	ld [wHPBarOldHP+1], a
	sbc b
	ld [wEnemyMonHP], a
	jr nc, ApplyDamageToEnemyPokemon.animateHpBar
; if more damage was done than the current HP, zero the HP and set the damage (wDamage)
; equal to how much HP the pokemon had before the attack
	ld a, [wHPBarOldHP+1]
	ld [hli], a
	ld a, [wHPBarOldHP]
	ld [hl], a
	xor a
	ld hl, wEnemyMonHP
	ld [hli], a
	ld [hl], a
ApplyDamageToEnemyPokemon.animateHpBar
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld [wHPBarMaxHP+1], a
	ld a, [hl]
	ld [wHPBarMaxHP], a
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [wHPBarNewHP+1], a
	ld a, [hl]
	ld [wHPBarNewHP], a
	hlcoord 2, 2
	xor a
	ld [wHPBarType], a
	predef UpdateHPBar2 ; animate the HP bar shortening
ApplyAttackToEnemyPokemonDone:
	jp DrawHUDsAndHPBars

ApplyAttackToPlayerPokemon:
	ld a, [wEnemyMoveEffect]
	cp OHKO_EFFECT
	jr z, ApplyDamageToPlayerPokemon
	cp SUPER_FANG_EFFECT
	jr z, ApplyAttackToPlayerPokemon.superFangEffect
	cp SPECIAL_DAMAGE_EFFECT
	jr z, ApplyAttackToPlayerPokemon.specialDamage
	ld a, [wEnemyMovePower]
	and a
	jp z, ApplyAttackToPlayerPokemonDone
	jr ApplyDamageToPlayerPokemon
ApplyAttackToPlayerPokemon.superFangEffect
; set the damage to half the target's HP
	ld hl, wBattleMonHP
	ld de, wDamage
	ld a, [hli]
	srl a
	ld [de], a
	inc de
	ld b, a
	ld a, [hl]
	rr a
	ld [de], a
	or b
	jr nz, ApplyDamageToPlayerPokemon
; make sure Super Fang's damage is always at least 1
	ld a, $01
	ld [de], a
	jr ApplyDamageToPlayerPokemon
ApplyAttackToPlayerPokemon.specialDamage
	ld hl, wEnemyMonLevel
	ld a, [hl]
	ld b, a
	ld a, [wEnemyMoveNum]
	cp SEISMIC_TOSS
	jr z, ApplyAttackToPlayerPokemon.storeDamage
	cp NIGHT_SHADE
	jr z, ApplyAttackToPlayerPokemon.storeDamage
	ld b, SONICBOOM_DAMAGE
	cp SONICBOOM
	jr z, ApplyAttackToPlayerPokemon.storeDamage
	ld b, DRAGON_RAGE_DAMAGE
	cp DRAGON_RAGE
	jr z, ApplyAttackToPlayerPokemon.storeDamage
; Psywave
	ld a, [hl]
	ld b, a
	srl a
	add b
	ld b, a ; b = attacker's level * 1.5
; loop until a random number in the range [0, b) is found
; this differs from the range when the player attacks, which is [1, b)
; it's possible for the enemy to do 0 damage with Psywave, but the player always does at least 1 damage
ApplyAttackToPlayerPokemon.loop
	call BattleRandom
	cp b
	jr nc, ApplyAttackToPlayerPokemon.loop
	ld b, a
ApplyAttackToPlayerPokemon.storeDamage
	ld hl, wDamage
	xor a
	ld [hli], a
	ld a, b
	ld [hl], a

ApplyDamageToPlayerPokemon:
	ld hl, wDamage
	ld a, [hli]
	ld b, a
	ld a, [hl]
	or b
	jr z, ApplyAttackToPlayerPokemonDone ; we're done if damage is 0
	ld a, [wPlayerBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a ; does the player have a substitute?
	jp nz, AttackSubstitute
; subtract the damage from the pokemon's current HP
; also, save the current HP at wHPBarOldHP and the new HP at wHPBarNewHP
	ld a, [hld]
	ld b, a
	ld a, [wBattleMonHP + 1]
	ld [wHPBarOldHP], a
	sub b
	ld [wBattleMonHP + 1], a
	ld [wHPBarNewHP], a
	ld b, [hl]
	ld a, [wBattleMonHP]
	ld [wHPBarOldHP+1], a
	sbc b
	ld [wBattleMonHP], a
	ld [wHPBarNewHP+1], a
	jr nc, ApplyDamageToPlayerPokemon.animateHpBar
; if more damage was done than the current HP, zero the HP and set the damage (wDamage)
; equal to how much HP the pokemon had before the attack
	ld a, [wHPBarOldHP+1]
	ld [hli], a
	ld a, [wHPBarOldHP]
	ld [hl], a
	xor a
	ld hl, wBattleMonHP
	ld [hli], a
	ld [hl], a
	ld hl, wHPBarNewHP
	ld [hli], a
	ld [hl], a
ApplyDamageToPlayerPokemon.animateHpBar
	ld hl, wBattleMonMaxHP
	ld a, [hli]
	ld [wHPBarMaxHP+1], a
	ld a, [hl]
	ld [wHPBarMaxHP], a
	hlcoord 10, 9
	ld a, $01
	ld [wHPBarType], a
	predef UpdateHPBar2 ; animate the HP bar shortening
ApplyAttackToPlayerPokemonDone:
	jp DrawHUDsAndHPBars

AttackSubstitute:
; Unlike the two ApplyAttackToPokemon functions, Attack Substitute is shared by player and enemy.
; Self-confusion damage as well as Hi-Jump Kick and Jump Kick recoil cause a momentary turn swap before being applied.
; If the user has a Substitute up and would take damage because of that,
; damage will be applied to the other player's Substitute.
; Normal recoil such as from Double-Edge isn't affected by this glitch,
; because this function is never called in that case.

	ld hl, SubstituteTookDamageText
	call PrintText
; values for player turn
	ld de, wEnemySubstituteHP
	ld bc, wEnemyBattleStatus2
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, AttackSubstitute.applyDamageToSubstitute
; values for enemy turn
	ld de, wPlayerSubstituteHP
	ld bc, wPlayerBattleStatus2
AttackSubstitute.applyDamageToSubstitute
	ld hl, wDamage
	ld a, [hli]
	and a
	jr nz, AttackSubstitute.substituteBroke ; damage > 0xFF always breaks substitutes
; subtract damage from HP of substitute
	ld a, [de]
	sub [hl]
	ld [de], a
	ret nc
AttackSubstitute.substituteBroke
; If the target's Substitute breaks, wDamage isn't updated with the amount of HP
; the Substitute had before being attacked.
	ld h, b
	ld l, c
	res HAS_SUBSTITUTE_UP, [hl] ; unset the substitute bit
	ld hl, SubstituteBrokeText
	call PrintText
; flip whose turn it is for the next function call
	ldh a, [lobyte(hWhoseTurn)]
	xor $01
	ldh [lobyte(hWhoseTurn)], a
	callfar HideSubstituteShowMonAnim ; animate the substitute breaking
; flip the turn back to the way it was
	ldh a, [lobyte(hWhoseTurn)]
	xor $01
	ldh [lobyte(hWhoseTurn)], a
	ld hl, wPlayerMoveEffect ; value for player's turn
	and a
	jr z, AttackSubstitute.nullifyEffect
	ld hl, wEnemyMoveEffect ; value for enemy's turn
AttackSubstitute.nullifyEffect
	xor a
	ld [hl], a ; zero the effect of the attacker's move
	jp DrawHUDsAndHPBars

SubstituteTookDamageText:
	text_far WLA_GLOBAL_SubstituteTookDamageText
	text_end

SubstituteBrokeText:
	text_far WLA_GLOBAL_SubstituteBrokeText
	text_end

; this function raises the attack modifier of a pokemon using Rage when that pokemon is attacked
HandleBuildingRage:
; values for the player turn
	ld hl, wEnemyBattleStatus2
	ld de, wEnemyMonStatMods
	ld bc, wEnemyMoveNum
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, HandleBuildingRage.next
; values for the enemy turn
	ld hl, wPlayerBattleStatus2
	ld de, wPlayerMonStatMods
	ld bc, wPlayerMoveNum
HandleBuildingRage.next
	bit USING_RAGE, [hl] ; is the pokemon being attacked under the effect of Rage?
	ret z ; return if not
	ld a, [de]
	cp $0d ; maximum stat modifier value
	ret z ; return if attack modifier is already maxed
	ldh a, [lobyte(hWhoseTurn)]
	xor $01 ; flip turn for the stat modifier raising function
	ldh [lobyte(hWhoseTurn)], a
; temporarily change the target pokemon's move to $00 and the effect to the one
; that causes the attack modifier to go up one stage
	ld h, b
	ld l, c
	ld [hl], $00 ; null move number
	inc hl
	ld [hl], ATTACK_UP1_EFFECT
	push hl
	ld hl, BuildingRageText
	call PrintText
	call StatModifierUpEffect ; stat modifier raising function
	pop hl
	xor a
	ld [hld], a ; null move effect
	ld a, RAGE
	ld [hl], a ; restore the target pokemon's move number to Rage
	ldh a, [lobyte(hWhoseTurn)]
	xor $01 ; flip turn back to the way it was
	ldh [lobyte(hWhoseTurn)], a
	ret

BuildingRageText:
	text_far WLA_GLOBAL_BuildingRageText
	text_end

; copy last move for Mirror Move
; sets zero flag on failure and unsets zero flag on success
MirrorMoveCopyMove:
; Mirror Move makes use of wPlayerUsedMove and wEnemyUsedMove,
; which are mainly used to print the "[Pokemon] used [Move]" text.
; Both are set to 0 whenever a new Pokemon is sent out
; wPlayerUsedMove is also set to 0 whenever the player is fast asleep or frozen solid.
; wEnemyUsedMove is also set to 0 whenever the enemy is fast asleep or frozen solid.

	ldh a, [lobyte(hWhoseTurn)]
	and a
; values for player turn
	ld a, [wEnemyUsedMove]
	ld hl, wPlayerSelectedMove
	ld de, wPlayerMoveNum
	jr z, MirrorMoveCopyMove.next
; values for enemy turn
	ld a, [wPlayerUsedMove]
	ld de, wEnemyMoveNum
	ld hl, wEnemySelectedMove
MirrorMoveCopyMove.next
	ld [hl], a
	cp MIRROR_MOVE ; did the target Pokemon last use Mirror Move, and miss?
	jr z, MirrorMoveCopyMove.mirrorMoveFailed
	and a ; has the target selected any move yet?
	jr nz, ReloadMoveData
MirrorMoveCopyMove.mirrorMoveFailed
	ld hl, MirrorMoveFailedText
	call PrintText
	xor a
	ret

MirrorMoveFailedText:
	text_far WLA_GLOBAL_MirrorMoveFailedText
	text_end

; function used to reload move data for moves like Mirror Move and Metronome
ReloadMoveData:
	ld [wNamedObjectIndex], a
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, bank(Moves)
	call FarCopyData ; copy the move's stats
	call IncrementMovePP
; the follow two function calls are used to reload the move name
	call GetMoveName
	call CopyToStringBuffer
	ld a, $01
	and a
	ret

; function that picks a random move for metronome
MetronomePickMove:
	xor a
	ld [wAnimationType], a
	ld a, METRONOME
	call PlayMoveAnimation ; play Metronome's animation
; values for player turn
	ld de, wPlayerMoveNum
	ld hl, wPlayerSelectedMove
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, MetronomePickMove.pickMoveLoop
; values for enemy turn
	ld de, wEnemyMoveNum
	ld hl, wEnemySelectedMove
; loop to pick a random number in the range of valid moves used by Metronome
MetronomePickMove.pickMoveLoop
	call BattleRandom
	and a
	jr z, MetronomePickMove.pickMoveLoop
	cp STRUGGLE
	jr nc, MetronomePickMove.pickMoveLoop
	cp METRONOME
	jr z, MetronomePickMove.pickMoveLoop
	ld [hl], a
	jr ReloadMoveData

; this function increments the current move's PP
; it's used to prevent moves that run another move within the same turn
; (like Mirror Move and Metronome) from losing 2 PP
IncrementMovePP:
	ldh a, [lobyte(hWhoseTurn)]
	and a
; values for player turn
	ld hl, wBattleMonPP
	ld de, wPartyMon1PP
	ld a, [wPlayerMoveListIndex]
	jr z, IncrementMovePP.next
; values for enemy turn
	ld hl, wEnemyMonPP
	ld de, wEnemyMon1PP
	ld a, [wEnemyMoveListIndex]
IncrementMovePP.next
	ld b, $00
	ld c, a
	add hl, bc
	inc [hl] ; increment PP in the currently battling pokemon memory location
	ld h, d
	ld l, e
	add hl, bc
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld a, [wPlayerMonNumber] ; value for player turn
	jr z, IncrementMovePP.updatePP
	ld a, [wEnemyMonPartyPos] ; value for enemy turn
IncrementMovePP.updatePP
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	inc [hl] ; increment PP in the party memory location
	ret

; function to adjust the base damage of an attack to account for type effectiveness
AdjustDamageForMoveType:
; values for player turn
	ld hl, wBattleMonType
	ld a, [hli]
	ld b, a    ; b = type 1 of attacker
	ld c, [hl] ; c = type 2 of attacker
	ld hl, wEnemyMonType
	ld a, [hli]
	ld d, a    ; d = type 1 of defender
	ld e, [hl] ; e = type 2 of defender
	ld a, [wPlayerMoveType]
	ld [wMoveType], a
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, AdjustDamageForMoveType.next
; values for enemy turn
	ld hl, wEnemyMonType
	ld a, [hli]
	ld b, a    ; b = type 1 of attacker
	ld c, [hl] ; c = type 2 of attacker
	ld hl, wBattleMonType
	ld a, [hli]
	ld d, a    ; d = type 1 of defender
	ld e, [hl] ; e = type 2 of defender
	ld a, [wEnemyMoveType]
	ld [wMoveType], a
AdjustDamageForMoveType.next
	ld a, [wMoveType]
	cp b ; does the move type match type 1 of the attacker?
	jr z, AdjustDamageForMoveType.sameTypeAttackBonus
	cp c ; does the move type match type 2 of the attacker?
	jr z, AdjustDamageForMoveType.sameTypeAttackBonus
	jr AdjustDamageForMoveType.skipSameTypeAttackBonus
AdjustDamageForMoveType.sameTypeAttackBonus
; if the move type matches one of the attacker's types
	ld hl, wDamage + 1
	ld a, [hld]
	ld h, [hl]
	ld l, a    ; hl = damage
	ld b, h
	ld c, l    ; bc = damage
	srl b
	rr c      ; bc = floor(0.5 * damage)
	add hl, bc ; hl = floor(1.5 * damage)
; store damage
	ld a, h
	ld [wDamage], a
	ld a, l
	ld [wDamage + 1], a
	ld hl, wDamageMultipliers
	set BIT_STAB_DAMAGE, [hl]
AdjustDamageForMoveType.skipSameTypeAttackBonus
	ld a, [wMoveType]
	ld b, a
	ld hl, TypeEffects
AdjustDamageForMoveType.loop
	ld a, [hli] ; a = "attacking type" of the current type pair
	cp $ff
	jr z, AdjustDamageForMoveType.done
	cp b ; does move type match "attacking type"?
	jr nz, AdjustDamageForMoveType.nextTypePair
	ld a, [hl] ; a = "defending type" of the current type pair
	cp d ; does type 1 of defender match "defending type"?
	jr z, AdjustDamageForMoveType.matchingPairFound
	cp e ; does type 2 of defender match "defending type"?
	jr z, AdjustDamageForMoveType.matchingPairFound
	jr AdjustDamageForMoveType.nextTypePair
AdjustDamageForMoveType.matchingPairFound
; if the move type matches the "attacking type" and one of the defender's types matches the "defending type"
	push hl
	push bc
	inc hl
	ld a, [wDamageMultipliers]
	and 1 << BIT_STAB_DAMAGE
	ld b, a
	ld a, [hl] ; a = damage multiplier
	ldh [lobyte(hMultiplier)], a
	add b
	ld [wDamageMultipliers], a
	xor a
	ldh [lobyte(hMultiplicand)], a
	ld hl, wDamage
	ld a, [hli]
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, [hld]
	ldh [lobyte(hMultiplicand + 2)], a
	call Multiply
	ld a, 10
	ldh [lobyte(hDivisor)], a
	ld b, 4
	call Divide
	ldh a, [lobyte(hQuotient + 2)]
	ld [hli], a
	ld b, a
	ldh a, [lobyte(hQuotient + 3)]
	ld [hl], a
	or b ; is damage 0?
	jr nz, AdjustDamageForMoveType.skipTypeImmunity
; if damage is 0, make the move miss
; this only occurs if a move that would do 2 or 3 damage is 0.25x effective against the target
	inc a
	ld [wMoveMissed], a
AdjustDamageForMoveType.skipTypeImmunity
	pop bc
	pop hl
AdjustDamageForMoveType.nextTypePair
	inc hl
	inc hl
	jp AdjustDamageForMoveType.loop
AdjustDamageForMoveType.done
	ret

; function to tell how effective the type of an enemy attack is on the player's current pokemon
; this doesn't take into account the effects that dual types can have
; (e.g. 4x weakness / resistance, weaknesses and resistances canceling)
; the result is stored in [wTypeEffectiveness]
; as far is can tell, this is only used once in some AI code to help decide which move to use
AIGetTypeEffectiveness:
	ld a, [wEnemyMoveType]
	ld d, a                    ; d = type of enemy move
	ld hl, wBattleMonType
	ld b, [hl]                 ; b = type 1 of player's pokemon
	inc hl
	ld c, [hl]                 ; c = type 2 of player's pokemon
	; initialize to neutral effectiveness
	ld a, $10 ; bug: should be EFFECTIVE (10)
	ld [wTypeEffectiveness], a
	ld hl, TypeEffects
AIGetTypeEffectiveness.loop
	ld a, [hli]
	cp $ff
	ret z
	cp d                      ; match the type of the move
	jr nz, AIGetTypeEffectiveness.nextTypePair1
	ld a, [hli]
	cp b                      ; match with type 1 of pokemon
	jr z, AIGetTypeEffectiveness.done
	cp c                      ; or match with type 2 of pokemon
	jr z, AIGetTypeEffectiveness.done
	jr AIGetTypeEffectiveness.nextTypePair2
AIGetTypeEffectiveness.nextTypePair1
	inc hl
AIGetTypeEffectiveness.nextTypePair2
	inc hl
	jr AIGetTypeEffectiveness.loop
AIGetTypeEffectiveness.done
	ld a, [hl]
	ld [wTypeEffectiveness], a ; store damage multiplier
	ret

.INCLUDE "data/types/type_matchups.asm"

; some tests that need to pass for a move to hit
MoveHitTest:
; player's turn
	ld hl, wEnemyBattleStatus1
	ld de, wPlayerMoveEffect
	ld bc, wEnemyMonStatus
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, MoveHitTest.dreamEaterCheck
; enemy's turn
	ld hl, wPlayerBattleStatus1
	ld de, wEnemyMoveEffect
	ld bc, wBattleMonStatus
MoveHitTest.dreamEaterCheck
	ld a, [de]
	cp DREAM_EATER_EFFECT
	jr nz, MoveHitTest.swiftCheck
	ld a, [bc]
	and SLP_MASK
	jp z, MoveHitTest.moveMissed
MoveHitTest.swiftCheck
	ld a, [de]
	cp SWIFT_EFFECT
	ret z ; Swift never misses (this was fixed from the Japanese versions)
	call CheckTargetSubstitute ; substitute check (note that this overwrites a)
	jr z, MoveHitTest.checkForDigOrFlyStatus
; The fix for Swift broke this code. It's supposed to prevent HP draining moves from working on Substitutes.
; Since CheckTargetSubstitute overwrites a with either $00 or $01, it never works.
	cp DRAIN_HP_EFFECT
	jp z, MoveHitTest.moveMissed
	cp DREAM_EATER_EFFECT
	jp z, MoveHitTest.moveMissed
MoveHitTest.checkForDigOrFlyStatus
	bit INVULNERABLE, [hl]
	jp nz, MoveHitTest.moveMissed
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr nz, MoveHitTest.enemyTurn
; player's turn
; this checks if the move effect is disallowed by mist
	ld a, [wPlayerMoveEffect]
	cp ATTACK_DOWN1_EFFECT
	jr c, MoveHitTest.skipEnemyMistCheck
	cp HAZE_EFFECT + 1
	jr c, MoveHitTest.enemyMistCheck
	cp ATTACK_DOWN2_EFFECT
	jr c, MoveHitTest.skipEnemyMistCheck
	cp REFLECT_EFFECT + 1
	jr c, MoveHitTest.enemyMistCheck
	jr MoveHitTest.skipEnemyMistCheck
MoveHitTest.enemyMistCheck
; if move effect is from $12 to $19 inclusive or $3a to $41 inclusive
; i.e. the following moves
; GROWL, TAIL WHIP, LEER, STRING SHOT, SAND-ATTACK, SMOKESCREEN, KINESIS,
; FLASH, CONVERSION*, HAZE*, SCREECH, LIGHT SCREEN*, REFLECT*
; the moves that are marked with an asterisk are not affected since this
; function is not called when those moves are used
	ld a, [wEnemyBattleStatus2]
	bit PROTECTED_BY_MIST, a ; is mon protected by mist?
	jp nz, MoveHitTest.moveMissed
MoveHitTest.skipEnemyMistCheck
	ld a, [wPlayerBattleStatus2]
	bit USING_X_ACCURACY, a ; is the player using X Accuracy?
	ret nz ; if so, always hit regardless of accuracy/evasion
	jr MoveHitTest.calcHitChance
MoveHitTest.enemyTurn
	ld a, [wEnemyMoveEffect]
	cp ATTACK_DOWN1_EFFECT
	jr c, MoveHitTest.skipPlayerMistCheck
	cp HAZE_EFFECT + 1
	jr c, MoveHitTest.playerMistCheck
	cp ATTACK_DOWN2_EFFECT
	jr c, MoveHitTest.skipPlayerMistCheck
	cp REFLECT_EFFECT + 1
	jr c, MoveHitTest.playerMistCheck
	jr MoveHitTest.skipPlayerMistCheck
MoveHitTest.playerMistCheck
; similar to enemy mist check
	ld a, [wPlayerBattleStatus2]
	bit PROTECTED_BY_MIST, a ; is mon protected by mist?
	jp nz, MoveHitTest.moveMissed
MoveHitTest.skipPlayerMistCheck
	ld a, [wEnemyBattleStatus2]
	bit USING_X_ACCURACY, a ; is the enemy using X Accuracy?
	ret nz ; if so, always hit regardless of accuracy/evasion
MoveHitTest.calcHitChance
	call CalcHitChance ; scale the move accuracy according to attacker's accuracy and target's evasion
	ld a, [wPlayerMoveAccuracy]
	ld b, a
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, MoveHitTest.doAccuracyCheck
	ld a, [wEnemyMoveAccuracy]
	ld b, a
MoveHitTest.doAccuracyCheck
; if the random number generated is greater than or equal to the scaled accuracy, the move misses
; note that this means that even the highest accuracy is still just a 255/256 chance, not 100%
	call BattleRandom
	cp b
	jr nc, MoveHitTest.moveMissed
	ret
MoveHitTest.moveMissed
	xor a
	ld hl, wDamage ; zero the damage
	ld [hli], a
	ld [hl], a
	inc a
	ld [wMoveMissed], a
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, MoveHitTest.playerTurn
; enemy's turn
	ld hl, wEnemyBattleStatus1
	res USING_TRAPPING_MOVE, [hl] ; end multi-turn attack e.g. wrap
	ret
MoveHitTest.playerTurn
	ld hl, wPlayerBattleStatus1
	res USING_TRAPPING_MOVE, [hl] ; end multi-turn attack e.g. wrap
	ret

; values for player turn
CalcHitChance:
	ld hl, wPlayerMoveAccuracy
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld a, [wPlayerMonAccuracyMod]
	ld b, a
	ld a, [wEnemyMonEvasionMod]
	ld c, a
	jr z, CalcHitChance.next
; values for enemy turn
	ld hl, wEnemyMoveAccuracy
	ld a, [wEnemyMonAccuracyMod]
	ld b, a
	ld a, [wPlayerMonEvasionMod]
	ld c, a
CalcHitChance.next
	ld a, $0e
	sub c
	ld c, a ; c = 14 - EVASIONMOD (this "reflects" the value over 7, so that an increase in the target's evasion
	       ; decreases the hit chance instead of increasing the hit chance)
; zero the high bytes of the multiplicand
	xor a
	ldh [lobyte(hMultiplicand)], a
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, [hl]
	ldh [lobyte(hMultiplicand + 2)], a ; set multiplicand to move accuracy
	push hl
	ld d, $02 ; loop has two iterations
; loop to do the calculations, the first iteration multiplies by the accuracy ratio and
; the second iteration multiplies by the evasion ratio
CalcHitChance.loop
	push bc
	ld hl, StatModifierRatios  ; stat modifier ratios
	dec b
	sla b
	ld c, b
	ld b, $00
	add hl, bc ; hl = address of stat modifier ratio
	pop bc
	ld a, [hli]
	ldh [lobyte(hMultiplier)], a ; set multiplier to the numerator of the ratio
	call Multiply
	ld a, [hl]
	ldh [lobyte(hDivisor)], a ; set divisor to the the denominator of the ratio
	                 ; (the dividend is the product of the previous multiplication)
	ld b, $04 ; number of bytes in the dividend
	call Divide
	ldh a, [lobyte(hQuotient + 3)]
	ld b, a
	ldh a, [lobyte(hQuotient + 2)]
	or b
	jp nz, CalcHitChance.nextCalculation
; make sure the result is always at least one
	ldh [lobyte(hQuotient + 2)], a
	ld a, $01
	ldh [lobyte(hQuotient + 3)], a
CalcHitChance.nextCalculation
	ld b, c
	dec d
	jr nz, CalcHitChance.loop
	ldh a, [lobyte(hQuotient + 2)]
	and a ; is the calculated hit chance over 0xFF?
	ldh a, [lobyte(hQuotient + 3)]
	jr z, CalcHitChance.storeAccuracy
; if calculated hit chance over 0xFF
	ld a, $ff ; set the hit chance to 0xFF
CalcHitChance.storeAccuracy
	pop hl
	ld [hl], a ; store the hit chance in the move accuracy variable
	ret

; multiplies damage by a random percentage from ~85% to 100%
RandomizeDamage:
	ld hl, wDamage
	ld a, [hli]
	and a
	jr nz, RandomizeDamage.DamageGreaterThanOne
	ld a, [hl]
	cp 2
	ret c ; return if damage is equal to 0 or 1
RandomizeDamage.DamageGreaterThanOne
	xor a
	ldh [lobyte(hMultiplicand)], a
	dec hl
	ld a, [hli]
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, [hl]
	ldh [lobyte(hMultiplicand + 2)], a
; loop until a random number greater than or equal to 217 is generated
RandomizeDamage.loop
	call BattleRandom
	rrca
	cp (85 * $ff / 100) + 1
	jr c, RandomizeDamage.loop
	ldh [lobyte(hMultiplier)], a
	call Multiply ; multiply damage by the random number, which is in the range [217, 255]
	ld a, 255
	ldh [lobyte(hDivisor)], a
	ld b, $4
	call Divide ; divide the result by 255
; store the modified damage
	ldh a, [lobyte(hQuotient + 2)]
	ld hl, wDamage
	ld [hli], a
	ldh a, [lobyte(hQuotient + 3)]
	ld [hl], a
	ret

; for more detailed commentary, see equivalent function for player side (ExecutePlayerMove)
ExecuteEnemyMove:
	ld a, [wEnemySelectedMove]
	.ASSERT ((CANNOT_MOVE)-($ff)) < 1 && ((CANNOT_MOVE)-($ff)) > -1
	inc a
	jp z, ExecuteEnemyMoveDone
	call PrintGhostText
	jp z, ExecuteEnemyMoveDone
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, ExecuteEnemyMove.executeEnemyMove
	ld b, $1
	ld a, [wSerialExchangeNybbleReceiveData]
	cp LINKBATTLE_STRUGGLE
	jr z, ExecuteEnemyMove.executeEnemyMove
	cp 4
	ret nc
ExecuteEnemyMove.executeEnemyMove
	ld hl, wAILayer2Encouragement
	inc [hl]
	xor a
	ld [wMoveMissed], a
	ld [wMoveDidntMiss], a
	ld a, EFFECTIVE
	ld [wDamageMultipliers], a
	call CheckEnemyStatusConditions
	jr nz, ExecuteEnemyMove.enemyHasNoSpecialConditions
	jp hl
ExecuteEnemyMove.enemyHasNoSpecialConditions
	ld hl, wEnemyBattleStatus1
	bit CHARGING_UP, [hl] ; is the enemy charging up for attack?
	jr nz, EnemyCanExecuteChargingMove ; if so, jump
	call GetCurrentMove

CheckIfEnemyNeedsToChargeUp:
	ld a, [wEnemyMoveEffect]
	cp CHARGE_EFFECT
	jp z, JumpMoveEffect
	cp FLY_EFFECT
	jp z, JumpMoveEffect
	jr EnemyCanExecuteMove
EnemyCanExecuteChargingMove:
	ld hl, wEnemyBattleStatus1
	res CHARGING_UP, [hl] ; no longer charging up for attack
	res INVULNERABLE, [hl] ; no longer invulnerable to typical attacks
	ld a, [wEnemyMoveNum]
	ld [wNameListIndex], a
	ld a, bank(MoveNames)
	ld [wPredefBank], a
	ld a, MOVE_NAME
	ld [wNameListType], a
	call GetName
	ld de, wNameBuffer
	call CopyToStringBuffer
EnemyCanExecuteMove:
	xor a
	ld [wMonIsDisobedient], a
	call DisplayUsedMoveText
	ld a, [wEnemyMoveEffect]
	ld hl, ResidualEffects1
	ld de, $1
	call IsInArray
	jp c, JumpMoveEffect
	ld a, [wEnemyMoveEffect]
	ld hl, SpecialEffectsCont
	ld de, $1
	call IsInArray
	call c, JumpMoveEffect
EnemyCalcMoveDamage:
	call SwapPlayerAndEnemyLevels
	ld a, [wEnemyMoveEffect]
	ld hl, SetDamageEffects
	ld de, $1
	call IsInArray
	jp c, EnemyMoveHitTest
	call CriticalHitTest
	call HandleCounterMove
	jr z, HandleIfEnemyMoveMissed
	call SwapPlayerAndEnemyLevels
	call GetDamageVarsForEnemyAttack
	call SwapPlayerAndEnemyLevels
	call CalculateDamage
	jp z, EnemyCheckIfFlyOrChargeEffect
	call AdjustDamageForMoveType
	call RandomizeDamage

EnemyMoveHitTest:
	call MoveHitTest
HandleIfEnemyMoveMissed:
	ld a, [wMoveMissed]
	and a
	jr z, HandleIfEnemyMoveMissed.moveDidNotMiss
	ld a, [wEnemyMoveEffect]
	cp EXPLODE_EFFECT
	jr z, HandleExplosionMiss
	jr EnemyCheckIfFlyOrChargeEffect
HandleIfEnemyMoveMissed.moveDidNotMiss
	call SwapPlayerAndEnemyLevels

GetEnemyAnimationType:
	ld a, [wEnemyMoveEffect]
	and a
	ld a, ANIMATIONTYPE_SHAKE_SCREEN_VERTICALLY
	jr z, PlayEnemyMoveAnimation
	ld a, ANIMATIONTYPE_SHAKE_SCREEN_HORIZONTALLY_HEAVY
	jr PlayEnemyMoveAnimation
HandleExplosionMiss:
	call SwapPlayerAndEnemyLevels
	xor a
PlayEnemyMoveAnimation:
	push af
	ld a, [wEnemyBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a ; does mon have a substitute?
	ld hl, HideSubstituteShowMonAnim
	ld b, bank(HideSubstituteShowMonAnim)
	call nz, Bankswitch
	pop af
	ld [wAnimationType], a
	ld a, [wEnemyMoveNum]
	call PlayMoveAnimation
	call HandleExplodingAnimation
	call DrawEnemyHUDAndHPBar
	ld a, [wEnemyBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a ; does mon have a substitute?
	ld hl, ReshowSubstituteAnim
	ld b, bank(ReshowSubstituteAnim)
	call nz, Bankswitch ; slide the substitute's sprite out
	jr EnemyCheckIfMirrorMoveEffect

EnemyCheckIfFlyOrChargeEffect:
	call SwapPlayerAndEnemyLevels
	ld c, 30
	call DelayFrames
	ld a, [wEnemyMoveEffect]
	cp FLY_EFFECT
	jr z, EnemyCheckIfFlyOrChargeEffect.playAnim
	cp CHARGE_EFFECT
	jr z, EnemyCheckIfFlyOrChargeEffect.playAnim
	jr EnemyCheckIfMirrorMoveEffect
EnemyCheckIfFlyOrChargeEffect.playAnim
	xor a
	ld [wAnimationType], a
	ld a, STATUS_AFFECTED_ANIM
	call PlayMoveAnimation
EnemyCheckIfMirrorMoveEffect:
	ld a, [wEnemyMoveEffect]
	cp MIRROR_MOVE_EFFECT
	jr nz, EnemyCheckIfMirrorMoveEffect.notMirrorMoveEffect
	call MirrorMoveCopyMove
	jp z, ExecuteEnemyMoveDone
	jp CheckIfEnemyNeedsToChargeUp
EnemyCheckIfMirrorMoveEffect.notMirrorMoveEffect
	cp METRONOME_EFFECT
	jr nz, EnemyCheckIfMirrorMoveEffect.notMetronomeEffect
	call MetronomePickMove
	jp CheckIfEnemyNeedsToChargeUp
EnemyCheckIfMirrorMoveEffect.notMetronomeEffect
	ld a, [wEnemyMoveEffect]
	ld hl, ResidualEffects2
	ld de, $1
	call IsInArray
	jp c, JumpMoveEffect
	ld a, [wMoveMissed]
	and a
	jr z, EnemyCheckIfMirrorMoveEffect.moveDidNotMiss
	call PrintMoveFailureText
	ld a, [wEnemyMoveEffect]
	cp EXPLODE_EFFECT
	jr z, EnemyCheckIfMirrorMoveEffect.handleExplosionMiss
	jp ExecuteEnemyMoveDone
EnemyCheckIfMirrorMoveEffect.moveDidNotMiss
	call ApplyAttackToPlayerPokemon
	call PrintCriticalOHKOText
	callfar DisplayEffectiveness
	ld a, 1
	ld [wMoveDidntMiss], a
EnemyCheckIfMirrorMoveEffect.handleExplosionMiss
	ld a, [wEnemyMoveEffect]
	ld hl, AlwaysHappenSideEffects
	ld de, $1
	call IsInArray
	call c, JumpMoveEffect
	ld hl, wBattleMonHP
	ld a, [hli]
	ld b, [hl]
	or b
	ret z
	call HandleBuildingRage
	ld hl, wEnemyBattleStatus1
	bit ATTACKING_MULTIPLE_TIMES, [hl] ; is mon hitting multiple times? (example: double kick)
	jr z, EnemyCheckIfMirrorMoveEffect.notMultiHitMove
	push hl
	ld hl, wEnemyNumAttacksLeft
	dec [hl]
	pop hl
	jp nz, GetEnemyAnimationType
	res ATTACKING_MULTIPLE_TIMES, [hl] ; mon is no longer hitting multiple times
	ld hl, HitXTimesText
	call PrintText
	xor a
	ld [wEnemyNumHits], a
EnemyCheckIfMirrorMoveEffect.notMultiHitMove
	ld a, [wEnemyMoveEffect]
	and a
	jr z, ExecuteEnemyMoveDone
	ld hl, SpecialEffects
	ld de, $1
	call IsInArray
	call nc, JumpMoveEffect
	jr ExecuteEnemyMoveDone

HitXTimesText:
	text_far WLA_GLOBAL_HitXTimesText
	text_end

ExecuteEnemyMoveDone:
	ld b, $1
	ret

; checks for various status conditions affecting the enemy mon
; stores whether the mon cannot use a move this turn in Z flag
CheckEnemyStatusConditions:
	ld hl, wEnemyMonStatus
	ld a, [hl]
	and SLP_MASK
	jr z, CheckEnemyStatusConditions.checkIfFrozen
	dec a ; decrement number of turns left
	ld [wEnemyMonStatus], a
	and a
	jr z, CheckEnemyStatusConditions.wokeUp ; if the number of turns hit 0, wake up
	ld hl, FastAsleepText
	call PrintText
	xor a
	ld [wAnimationType], a
	ld a, SLP_ANIM
	call PlayMoveAnimation
	jr CheckEnemyStatusConditions.sleepDone
CheckEnemyStatusConditions.wokeUp
	ld hl, WokeUpText
	call PrintText
CheckEnemyStatusConditions.sleepDone
	xor a
	ld [wEnemyUsedMove], a
	ld hl, ExecuteEnemyMoveDone ; enemy can't move this turn
	jp CheckEnemyStatusConditions.enemyReturnToHL
CheckEnemyStatusConditions.checkIfFrozen
	bit FRZ, [hl]
	jr z, CheckEnemyStatusConditions.checkIfTrapped
	ld hl, IsFrozenText
	call PrintText
	xor a
	ld [wEnemyUsedMove], a
	ld hl, ExecuteEnemyMoveDone ; enemy can't move this turn
	jp CheckEnemyStatusConditions.enemyReturnToHL
CheckEnemyStatusConditions.checkIfTrapped
	ld a, [wPlayerBattleStatus1]
	bit USING_TRAPPING_MOVE, a ; is the player using a multi-turn attack like warp
	jp z, CheckEnemyStatusConditions.checkIfFlinched
	ld hl, CantMoveText
	call PrintText
	ld hl, ExecuteEnemyMoveDone ; enemy can't move this turn
	jp CheckEnemyStatusConditions.enemyReturnToHL
CheckEnemyStatusConditions.checkIfFlinched
	ld hl, wEnemyBattleStatus1
	bit FLINCHED, [hl] ; check if enemy mon flinched
	jp z, CheckEnemyStatusConditions.checkIfMustRecharge
	res FLINCHED, [hl]
	ld hl, FlinchedText
	call PrintText
	ld hl, ExecuteEnemyMoveDone ; enemy can't move this turn
	jp CheckEnemyStatusConditions.enemyReturnToHL
CheckEnemyStatusConditions.checkIfMustRecharge
	ld hl, wEnemyBattleStatus2
	bit NEEDS_TO_RECHARGE, [hl] ; check if enemy mon has to recharge after using a move
	jr z, CheckEnemyStatusConditions.checkIfAnyMoveDisabled
	res NEEDS_TO_RECHARGE, [hl]
	ld hl, MustRechargeText
	call PrintText
	ld hl, ExecuteEnemyMoveDone ; enemy can't move this turn
	jp CheckEnemyStatusConditions.enemyReturnToHL
CheckEnemyStatusConditions.checkIfAnyMoveDisabled
	ld hl, wEnemyDisabledMove
	ld a, [hl]
	and a
	jr z, CheckEnemyStatusConditions.checkIfConfused
	dec a ; decrement disable counter
	ld [hl], a
	and $f ; did disable counter hit 0?
	jr nz, CheckEnemyStatusConditions.checkIfConfused
	ld [hl], a
	ld [wEnemyDisabledMoveNumber], a
	ld hl, DisabledNoMoreText
	call PrintText
CheckEnemyStatusConditions.checkIfConfused
	ld a, [wEnemyBattleStatus1]
	add a ; check if enemy mon is confused
	jp nc, CheckEnemyStatusConditions.checkIfTriedToUseDisabledMove
	ld hl, wEnemyConfusedCounter
	dec [hl]
	jr nz, CheckEnemyStatusConditions.isConfused
	ld hl, wEnemyBattleStatus1
	res CONFUSED, [hl] ; if confused counter hit 0, reset confusion status
	ld hl, ConfusedNoMoreText
	call PrintText
	jp CheckEnemyStatusConditions.checkIfTriedToUseDisabledMove
CheckEnemyStatusConditions.isConfused
	ld hl, IsConfusedText
	call PrintText
	xor a
	ld [wAnimationType], a
	ld a, CONF_ANIM
	call PlayMoveAnimation
	call BattleRandom
	cp $80
	jr c, CheckEnemyStatusConditions.checkIfTriedToUseDisabledMove
	ld hl, wEnemyBattleStatus1
	ld a, [hl]
	and 1 << CONFUSED ; if mon hurts itself, clear every other status from wEnemyBattleStatus1
	ld [hl], a
	ld hl, HurtItselfText
	call PrintText
	ld hl, wBattleMonDefense
	ld a, [hli]
	push af
	ld a, [hld]
	push af
	ld a, [wEnemyMonDefense]
	ld [hli], a
	ld a, [wEnemyMonDefense + 1]
	ld [hl], a
	ld hl, wEnemyMoveEffect
	push hl
	ld a, [hl]
	push af
	xor a
	ld [hli], a
	ld [wCriticalHitOrOHKO], a
	ld a, 40
	ld [hli], a
	xor a
	ld [hl], a
	call GetDamageVarsForEnemyAttack
	call CalculateDamage
	pop af
	pop hl
	ld [hl], a
	ld hl, wBattleMonDefense + 1
	pop af
	ld [hld], a
	pop af
	ld [hl], a
	xor a
	ld [wAnimationType], a
	ldh [lobyte(hWhoseTurn)], a
	ld a, POUND
	call PlayMoveAnimation
	ld a, $1
	ldh [lobyte(hWhoseTurn)], a
	call ApplyDamageToEnemyPokemon
	jr CheckEnemyStatusConditions.monHurtItselfOrFullyParalysed
CheckEnemyStatusConditions.checkIfTriedToUseDisabledMove
; prevents a disabled move that was selected before being disabled from being used
	ld a, [wEnemyDisabledMoveNumber]
	and a
	jr z, CheckEnemyStatusConditions.checkIfParalysed
	ld hl, wEnemySelectedMove
	cp [hl]
	jr nz, CheckEnemyStatusConditions.checkIfParalysed
	call PrintMoveIsDisabledText
	ld hl, ExecuteEnemyMoveDone ; if a disabled move was somehow selected, player can't move this turn
	jp CheckEnemyStatusConditions.enemyReturnToHL
CheckEnemyStatusConditions.checkIfParalysed
	ld hl, wEnemyMonStatus
	bit PAR, [hl]
	jr z, CheckEnemyStatusConditions.checkIfUsingBide
	call BattleRandom
	cp (25 * $ff / 100) ; chance to be fully paralysed
	jr nc, CheckEnemyStatusConditions.checkIfUsingBide
	ld hl, FullyParalyzedText
	call PrintText
CheckEnemyStatusConditions.monHurtItselfOrFullyParalysed
	ld hl, wEnemyBattleStatus1
	ld a, [hl]
	; clear bide, thrashing about, charging up, and multi-turn moves such as warp
	and ~((1 << STORING_ENERGY) | (1 << THRASHING_ABOUT) | (1 << CHARGING_UP) | (1 << USING_TRAPPING_MOVE))
	ld [hl], a
	ld a, [wEnemyMoveEffect]
	cp FLY_EFFECT
	jr z, CheckEnemyStatusConditions.flyOrChargeEffect
	cp CHARGE_EFFECT
	jr z, CheckEnemyStatusConditions.flyOrChargeEffect
	jr CheckEnemyStatusConditions.notFlyOrChargeEffect
CheckEnemyStatusConditions.flyOrChargeEffect
	xor a
	ld [wAnimationType], a
	ld a, STATUS_AFFECTED_ANIM
	call PlayMoveAnimation
CheckEnemyStatusConditions.notFlyOrChargeEffect
	ld hl, ExecuteEnemyMoveDone
	jp CheckEnemyStatusConditions.enemyReturnToHL ; if using a two-turn move, enemy needs to recharge the first turn
CheckEnemyStatusConditions.checkIfUsingBide
	ld hl, wEnemyBattleStatus1
	bit STORING_ENERGY, [hl] ; is mon using bide?
	jr z, CheckEnemyStatusConditions.checkIfThrashingAbout
	xor a
	ld [wEnemyMoveNum], a
	ld hl, wDamage
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemyBideAccumulatedDamage + 1
	ld a, [hl]
	add c ; accumulate damage taken
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a
	ld hl, wEnemyNumAttacksLeft
	dec [hl] ; did Bide counter hit 0?
	jr z, CheckEnemyStatusConditions.unleashEnergy
	ld hl, ExecuteEnemyMoveDone
	jp CheckEnemyStatusConditions.enemyReturnToHL ; unless mon unleashes energy, can't move this turn
CheckEnemyStatusConditions.unleashEnergy
	ld hl, wEnemyBattleStatus1
	res STORING_ENERGY, [hl] ; not using bide any more
	ld hl, UnleashedEnergyText
	call PrintText
	ld a, $1
	ld [wEnemyMovePower], a
	ld hl, wEnemyBideAccumulatedDamage + 1
	ld a, [hld]
	add a
	ld b, a
	ld [wDamage + 1], a
	ld a, [hl]
	rl a ; double the damage
	ld [wDamage], a
	or b
	jr nz, CheckEnemyStatusConditions.next
	ld a, $1
	ld [wMoveMissed], a
CheckEnemyStatusConditions.next
	xor a
	ld [hli], a
	ld [hl], a
	ld a, BIDE
	ld [wEnemyMoveNum], a
	call SwapPlayerAndEnemyLevels
	ld hl, HandleIfEnemyMoveMissed ; skip damage calculation, DecrementPP and MoveHitTest
	jp CheckEnemyStatusConditions.enemyReturnToHL
CheckEnemyStatusConditions.checkIfThrashingAbout
	bit THRASHING_ABOUT, [hl] ; is mon using thrash or petal dance?
	jr z, CheckEnemyStatusConditions.checkIfUsingMultiturnMove
	ld a, THRASH
	ld [wEnemyMoveNum], a
	ld hl, ThrashingAboutText
	call PrintText
	ld hl, wEnemyNumAttacksLeft
	dec [hl] ; did Thrashing About counter hit 0?
	ld hl, EnemyCalcMoveDamage ; skip DecrementPP
	jp nz, CheckEnemyStatusConditions.enemyReturnToHL
	push hl
	ld hl, wEnemyBattleStatus1
	res THRASHING_ABOUT, [hl] ; mon is no longer using thrash or petal dance
	set CONFUSED, [hl] ; mon is now confused
	call BattleRandom
	and $3
	inc a
	inc a ; confused for 2-5 turns
	ld [wEnemyConfusedCounter], a
	pop hl ; skip DecrementPP
	jp CheckEnemyStatusConditions.enemyReturnToHL
CheckEnemyStatusConditions.checkIfUsingMultiturnMove
	bit USING_TRAPPING_MOVE, [hl] ; is mon using multi-turn move?
	jp z, CheckEnemyStatusConditions.checkIfUsingRage
	ld hl, AttackContinuesText
	call PrintText
	ld hl, wEnemyNumAttacksLeft
	dec [hl]
	ld hl, GetEnemyAnimationType ; skip damage calculation (deal damage equal to last hit),
	                             ; DecrementPP and MoveHitTest
	jp nz, CheckEnemyStatusConditions.enemyReturnToHL ; redundant leftover code, the case wEnemyNumAttacksLeft = 0
							; is handled within CheckNumAttacksLeft
	jp CheckEnemyStatusConditions.enemyReturnToHL
CheckEnemyStatusConditions.checkIfUsingRage
	ld a, [wEnemyBattleStatus2]
	bit USING_RAGE, a ; is mon using rage?
	jp z, CheckEnemyStatusConditions.checkEnemyStatusConditionsDone ; if we made it this far, mon can move normally this turn
	ld a, RAGE
	ld [wNamedObjectIndex], a
	call GetMoveName
	call CopyToStringBuffer
	xor a
	ld [wEnemyMoveEffect], a
	ld hl, EnemyCanExecuteMove
	jp CheckEnemyStatusConditions.enemyReturnToHL
CheckEnemyStatusConditions.enemyReturnToHL
	xor a ; set Z flag
	ret
CheckEnemyStatusConditions.checkEnemyStatusConditionsDone
	ld a, $1
	and a ; clear Z flag
	ret

GetCurrentMove:
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jp z, GetCurrentMove.player
	ld de, wEnemyMoveNum
	ld a, [wEnemySelectedMove]
	jr GetCurrentMove.selected
GetCurrentMove.player
	ld de, wPlayerMoveNum
	; Apply InitBattleVariables to TestBattle.
	ld a, [wStatusFlags7]
	bit BIT_TEST_BATTLE, a
	ld a, [wTestBattlePlayerSelectedMove]
	jr nz, GetCurrentMove.selected
	ld a, [wPlayerSelectedMove]
GetCurrentMove.selected
	ld [wNameListIndex], a
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, bank(Moves)
	call FarCopyData

	ld a, bank(MoveNames)
	ld [wPredefBank], a
	ld a, MOVE_NAME
	ld [wNameListType], a
	call GetName
	ld de, wNameBuffer
	jp CopyToStringBuffer

LoadEnemyMonData:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, LoadEnemyMonFromParty
	ld a, [wEnemyMonSpecies2]
	ld [wEnemyMonSpecies], a
	ld [wCurSpecies], a
	call GetMonHeader
	ld a, [wEnemyBattleStatus3]
	bit TRANSFORMED, a ; is enemy mon transformed?
	ld hl, wTransformedEnemyMonOriginalDVs ; original DVs before transforming
	ld a, [hli]
	ld b, [hl]
	jr nz, LoadEnemyMonData.storeDVs
	ld a, [wIsInBattle]
	cp $2 ; is it a trainer battle?
; fixed DVs for trainer mon
	ld a, ATKDEFDV_TRAINER
	ld b, SPDSPCDV_TRAINER
	jr z, LoadEnemyMonData.storeDVs
; random DVs for wild mon
	call BattleRandom
	ld b, a
	call BattleRandom
LoadEnemyMonData.storeDVs
	ld hl, wEnemyMonDVs
	ld [hli], a
	ld [hl], b
	ld de, wEnemyMonLevel
	ld a, [wCurEnemyLevel]
	ld [de], a
	inc de
	ld b, $0
	ld hl, wEnemyMonHP
	push hl
	call CalcStats
	pop hl
	ld a, [wIsInBattle]
	cp $2 ; is it a trainer battle?
	jr z, LoadEnemyMonData.copyHPAndStatusFromPartyData
	ld a, [wEnemyBattleStatus3]
	bit TRANSFORMED, a ; is enemy mon transformed?
	jr nz, LoadEnemyMonData.copyTypes ; if transformed, jump
; if it's a wild mon and not transformed, init the current HP to max HP and the status to 0
	ld a, [wEnemyMonMaxHP]
	ld [hli], a
	ld a, [wEnemyMonMaxHP+1]
	ld [hli], a
	xor a
	inc hl
	ld [hl], a ; init status to 0
	jr LoadEnemyMonData.copyTypes
; if it's a trainer mon, copy the HP and status from the enemy party data
LoadEnemyMonData.copyHPAndStatusFromPartyData
	ld hl, wEnemyMon1HP
	ld a, [wWhichPokemon]
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	ld [wEnemyMonHP], a
	ld a, [hli]
	ld [wEnemyMonHP + 1], a
	ld a, [wWhichPokemon]
	ld [wEnemyMonPartyPos], a
	inc hl
	ld a, [hl]
	ld [wEnemyMonStatus], a
	jr LoadEnemyMonData.copyTypes
LoadEnemyMonData.copyTypes
	ld hl, wMonHTypes
	ld de, wEnemyMonType
	ld a, [hli]            ; copy type 1
	ld [de], a
	inc de
	ld a, [hli]            ; copy type 2
	ld [de], a
	inc de
	ld a, [hli]            ; copy catch rate
	ld [de], a
	inc de
	ld a, [wIsInBattle]
	cp $2 ; is it a trainer battle?
	jr nz, LoadEnemyMonData.copyStandardMoves
; if it's a trainer battle, copy moves from enemy party data
	ld hl, wEnemyMon1Moves
	ld a, [wWhichPokemon]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld bc, NUM_MOVES
	call CopyData
	jr LoadEnemyMonData.loadMovePPs
LoadEnemyMonData.copyStandardMoves
; for a wild mon, first copy default moves from the mon header
	ld hl, wMonHMoves
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	dec de
	dec de
	dec de
	xor a
	ld [wLearningMovesFromDayCare], a
	predef WriteMonMoves ; get moves based on current level
LoadEnemyMonData.loadMovePPs
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonPP - 1
	predef LoadMovePPs
	ld hl, wMonHBaseStats
	ld de, wEnemyMonBaseStats
	ld b, NUM_STATS
LoadEnemyMonData.copyBaseStatsLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, LoadEnemyMonData.copyBaseStatsLoop
	ld hl, wMonHCatchRate
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]     ; base exp
	ld [de], a
	ld a, [wEnemyMonSpecies2]
	ld [wNamedObjectIndex], a
	call GetMonName
	ld hl, wNameBuffer
	ld de, wEnemyMonNick
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wEnemyMonSpecies2]
	ld [wPokedexNum], a
	predef IndexToPokedex
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld b, FLAG_SET
	ld hl, wPokedexSeen
	predef FlagActionPredef ; mark this mon as seen in the pokedex
	ld hl, wEnemyMonLevel
	ld de, wEnemyMonUnmodifiedLevel
	ld bc, 1 + NUM_STATS * 2
	call CopyData
	ld a, $7 ; default stat mod
	ld b, NUM_STAT_MODS ; number of stat mods
	ld hl, wEnemyMonStatMods
LoadEnemyMonData.statModLoop
	ld [hli], a
	dec b
	jr nz, LoadEnemyMonData.statModLoop
	ret

; calls BattleTransition to show the battle transition animation and initializes some battle variables
DoBattleTransitionAndInitBattleVariables:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, DoBattleTransitionAndInitBattleVariables.next
; link battle
	xor a
	ld [wMenuJoypadPollCount], a
	callfar DisplayLinkBattleVersusTextBox
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	call ClearScreen
DoBattleTransitionAndInitBattleVariables.next
	call DelayFrame
	predef BattleTransition
	callfar LoadHudAndHpBarAndStatusTilePatterns
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	call ClearSprites
	call ClearScreen
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ldh [lobyte(hWY)], a
	ldh [lobyte(rWY)], a
	ldh [lobyte(hTileAnimations)], a
	ld hl, wPlayerStatsToDouble
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wPlayerDisabledMove], a
	ret

; swaps the level values of the BattleMon and EnemyMon structs
SwapPlayerAndEnemyLevels:
	push bc
	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [wEnemyMonLevel]
	ld [wBattleMonLevel], a
	ld a, b
	ld [wEnemyMonLevel], a
	pop bc
	ret

; loads either red back pic or old man back pic
; also writes OAM data and loads tile patterns for the Red or Old Man back sprite's head
; (for use when scrolling the player sprite and enemy's silhouettes on screen)
LoadPlayerBackPic:
	ld a, [wBattleType]
	dec a ; is it the old man tutorial?
	ld de, RedPicBack
	jr nz, LoadPlayerBackPic.next
	ld de, OldManPicBack
LoadPlayerBackPic.next
	ld a, bank(RedPicBack)
	call UncompressSpriteFromDE
	predef ScaleSpriteByTwo
	ld hl, wShadowOAM
	xor a
	ldh [lobyte(hOAMTile)], a ; initial tile number
	ld b, $7 ; 7 columns
	ld e, $a0 ; X for the left-most column
LoadPlayerBackPic.loop ; each loop iteration writes 3 OAM entries in a vertical column
	ld c, $3 ; 3 * TILE_SIZE per column
	ld d, $38 ; Y for the top of each column
LoadPlayerBackPic.innerLoop ; each loop iteration writes 1 OAM entry in the column
	ld [hl], d ; OAM Y
	inc hl
	ld [hl], e ; OAM X
	ld a, TILE_HEIGHT
	add d ; increase Y by height of tile
	ld d, a
	inc hl
	ldh a, [lobyte(hOAMTile)]
	ld [hli], a ; OAM tile number
	inc a ; increment tile number
	ldh [lobyte(hOAMTile)], a
	inc hl
	dec c
	jr nz, LoadPlayerBackPic.innerLoop
	ldh a, [lobyte(hOAMTile)]
	add $4 ; increase tile number by 4
	ldh [lobyte(hOAMTile)], a
	ld a, TILE_WIDTH
	add e ; increase X by width of tile
	ld e, a
	dec b
	jr nz, LoadPlayerBackPic.loop
	ld de, vBackPic
	call InterlaceMergeSpriteBuffers
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
	xor a
	ld [rRAMB], a
	ld hl, vSprites
	ld de, sSpriteBuffer1
	ldh a, [lobyte(hLoadedROMBank)]
	ld b, a
	ld c, PIC_SIZE
	call CopyVideoData
	xor a
	ld [rRAMG], a
	ld a, $31
	ldh [lobyte(hStartTileID)], a
	hlcoord 1, 5
	predef_jump CopyUncompressedPicToTilemap

; does nothing since no stats are ever selected (barring glitches)
DoubleOrHalveSelectedStats:
	callfar DoubleSelectedStats
	jpfar HalveSelectedStats

ScrollTrainerPicAfterBattle:
	jpfar WLA_GLOBAL_ScrollTrainerPicAfterBattle

ApplyBurnAndParalysisPenaltiesToPlayer:
	ld a, $1
	jr ApplyBurnAndParalysisPenalties

ApplyBurnAndParalysisPenaltiesToEnemy:
	xor a

ApplyBurnAndParalysisPenalties:
	ldh [lobyte(hWhoseTurn)], a
	call QuarterSpeedDueToParalysis
	jp HalveAttackDueToBurn

QuarterSpeedDueToParalysis:
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, QuarterSpeedDueToParalysis.playerTurn
; enemy's turn, quarter the player's speed
	ld a, [wBattleMonStatus]
	and 1 << PAR
	ret z ; return if player not paralysed
	ld hl, wBattleMonSpeed + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, QuarterSpeedDueToParalysis.storePlayerSpeed
	ld b, 1 ; give the player a minimum of at least one speed point
QuarterSpeedDueToParalysis.storePlayerSpeed
	ld [hl], b
	ret
QuarterSpeedDueToParalysis.playerTurn ; quarter the enemy's speed
	ld a, [wEnemyMonStatus]
	and 1 << PAR
	ret z ; return if enemy not paralysed
	ld hl, wEnemyMonSpeed + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, QuarterSpeedDueToParalysis.storeEnemySpeed
	ld b, 1 ; give the enemy a minimum of at least one speed point
QuarterSpeedDueToParalysis.storeEnemySpeed
	ld [hl], b
	ret

HalveAttackDueToBurn:
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, HalveAttackDueToBurn.playerTurn
; enemy's turn, halve the player's attack
	ld a, [wBattleMonStatus]
	and 1 << BRN
	ret z ; return if player not burnt
	ld hl, wBattleMonAttack + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, HalveAttackDueToBurn.storePlayerAttack
	ld b, 1 ; give the player a minimum of at least one attack point
HalveAttackDueToBurn.storePlayerAttack
	ld [hl], b
	ret
HalveAttackDueToBurn.playerTurn ; halve the enemy's attack
	ld a, [wEnemyMonStatus]
	and 1 << BRN
	ret z ; return if enemy not burnt
	ld hl, wEnemyMonAttack + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, HalveAttackDueToBurn.storeEnemyAttack
	ld b, 1 ; give the enemy a minimum of at least one attack point
HalveAttackDueToBurn.storeEnemyAttack
	ld [hl], b
	ret

CalculateModifiedStats:
	ld c, 0
CalculateModifiedStats.loop
	call CalculateModifiedStat
	inc c
	ld a, c
	cp NUM_STATS - 1
	jr nz, CalculateModifiedStats.loop
	ret

; calculate modified stat for stat c (0 = attack, 1 = defense, 2 = speed, 3 = special)
CalculateModifiedStat:
	push bc
	push bc
	ld a, [wCalculateWhoseStats]
	and a
	ld a, c
	ld hl, wBattleMonAttack
	ld de, wPlayerMonUnmodifiedAttack
	ld bc, wPlayerMonStatMods
	jr z, CalculateModifiedStat.next
	ld hl, wEnemyMonAttack
	ld de, wEnemyMonUnmodifiedAttack
	ld bc, wEnemyMonStatMods
CalculateModifiedStat.next
	add c
	ld c, a
	jr nc, CalculateModifiedStat.noCarry1
	inc b
CalculateModifiedStat.noCarry1
	ld a, [bc]
	pop bc
	ld b, a
	push bc
	sla c
	ld b, 0
	add hl, bc
	ld a, c
	add e
	ld e, a
	jr nc, CalculateModifiedStat.noCarry2
	inc d
CalculateModifiedStat.noCarry2
	pop bc
	push hl
	ld hl, StatModifierRatios
	dec b
	sla b
	ld c, b
	ld b, 0
	add hl, bc
	xor a
	ldh [lobyte(hMultiplicand)], a
	ld a, [de]
	ldh [lobyte(hMultiplicand + 1)], a
	inc de
	ld a, [de]
	ldh [lobyte(hMultiplicand + 2)], a
	ld a, [hli]
	ldh [lobyte(hMultiplier)], a
	call Multiply
	ld a, [hl]
	ldh [lobyte(hDivisor)], a
	ld b, $4
	call Divide
	pop hl
	ldh a, [lobyte(hDividend + 3)]
	sub lobyte(MAX_STAT_VALUE)
	ldh a, [lobyte(hDividend + 2)]
	sbc hibyte(MAX_STAT_VALUE)
	jp c, CalculateModifiedStat.storeNewStatValue
; cap the stat at MAX_STAT_VALUE (999)
	ld a, hibyte(MAX_STAT_VALUE)
	ldh [lobyte(hDividend + 2)], a
	ld a, lobyte(MAX_STAT_VALUE)
	ldh [lobyte(hDividend + 3)], a
CalculateModifiedStat.storeNewStatValue
	ldh a, [lobyte(hDividend + 2)]
	ld [hli], a
	ld b, a
	ldh a, [lobyte(hDividend + 3)]
	ld [hl], a
	or b
	jr nz, CalculateModifiedStat.done
	inc [hl] ; if the stat is 0, bump it up to 1
CalculateModifiedStat.done
	pop bc
	ret

ApplyBadgeStatBoosts:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z ; return if link battle
	ld a, [wObtainedBadges]
	ld b, a
	ld hl, wBattleMonAttack
	ld c, $4
; the boost is applied for badges whose bit position is even
; the order of boosts matches the order they are laid out in RAM
; Boulder (bit 0) - attack
; Thunder (bit 2) - defense
; Soul (bit 4) - speed
; Volcano (bit 6) - special
ApplyBadgeStatBoosts.loop
	srl b
	call c, ApplyBadgeStatBoosts.applyBoostToStat
	inc hl
	inc hl
	srl b
	dec c
	jr nz, ApplyBadgeStatBoosts.loop
	ret

; multiply stat at hl by 1.125
; cap stat at MAX_STAT_VALUE
ApplyBadgeStatBoosts.applyBoostToStat
	ld a, [hli]
	ld d, a
	ld e, [hl]
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e
	ld a, [hl]
	add e
	ld [hld], a
	ld a, [hl]
	adc d
	ld [hli], a
	ld a, [hld]
	sub lobyte(MAX_STAT_VALUE)
	ld a, [hl]
	sbc hibyte(MAX_STAT_VALUE)
	ret c
	ld a, hibyte(MAX_STAT_VALUE)
	ld [hli], a
	ld a, lobyte(MAX_STAT_VALUE)
	ld [hld], a
	ret

LoadHudAndHpBarAndStatusTilePatterns:
	call LoadHpBarAndStatusTilePatterns

LoadHudTilePatterns:
	ldh a, [lobyte(rLCDC)]
	add a ; is LCD disabled?
	jr c, LoadHudTilePatterns.lcdEnabled
; LCD disabled
	ld hl, BattleHudTiles1
	ld de, vChars2 + TILE_SIZE * $6d
	ld bc, BattleHudTiles1End - BattleHudTiles1
	ld a, bank(BattleHudTiles1)
	call FarCopyDataDouble
	ld hl, BattleHudTiles2
	ld de, vChars2 + TILE_SIZE * $73
	ld bc, BattleHudTiles3End - BattleHudTiles2
	ld a, bank(BattleHudTiles2)
	jp FarCopyDataDouble
LoadHudTilePatterns.lcdEnabled
	ld de, BattleHudTiles1
	ld hl, vChars2 + TILE_SIZE * $6d
	lb "bc", bank(BattleHudTiles1), (BattleHudTiles1End - BattleHudTiles1) / TILE_1BPP_SIZE
	call CopyVideoDataDouble
	ld de, BattleHudTiles2
	ld hl, vChars2 + TILE_SIZE * $73
	lb "bc", bank(BattleHudTiles2), (BattleHudTiles3End - BattleHudTiles2) / TILE_1BPP_SIZE
	jp CopyVideoDataDouble

PrintEmptyString:
	ld hl, PrintEmptyString.emptyString
	jp PrintText

PrintEmptyString.emptyString
		.STRINGMAP pokemon, "@"


BattleRandom:
; Link battles use a shared PRNG.

	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp nz, Random

	push hl
	push bc
	ld a, [wLinkBattleRandomNumberListIndex]
	ld c, a
	ld b, 0
	ld hl, wLinkBattleRandomNumberList
	add hl, bc
	inc a
	ld [wLinkBattleRandomNumberListIndex], a
	cp SERIAL_RNS_LENGTH - 1
	ld a, [hl]
	pop bc
	pop hl
	vc_hook Unknown_BattleRandom_ret_c
	vc_patch BattleRandom_ret
.IF defined(_RED_VC) || defined(_BLUE_VC)
	ret
.ELSE
	ret c
.ENDIF
	vc_patch_end

; if we picked the last seed, we need to recalculate the nine seeds
	push hl
	push bc
	push af

; point to seed 0 so we pick the first number the next time
	xor a
	ld [wLinkBattleRandomNumberListIndex], a

	ld hl, wLinkBattleRandomNumberList
	ld b, SERIAL_RNS_LENGTH - 1
BattleRandom.loop
	ld a, [hl]
	ld c, a
; multiply by 5
	add a
	add a
	add c
; add 1
	inc a
	ld [hli], a
	dec b
	jr nz, BattleRandom.loop

	pop af
	pop bc
	pop hl
	ret


HandleExplodingAnimation:
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld hl, wEnemyMonType1
	ld de, wEnemyBattleStatus1
	ld a, [wPlayerMoveNum]
	jr z, HandleExplodingAnimation.player
	ld hl, wBattleMonType1
	ld de, wEnemyBattleStatus1
	ld a, [wEnemyMoveNum]
HandleExplodingAnimation.player
	cp SELFDESTRUCT
	jr z, HandleExplodingAnimation.isExplodingMove
	cp EXPLOSION
	ret nz
HandleExplodingAnimation.isExplodingMove
	ld a, [de]
	bit INVULNERABLE, a ; fly/dig
	ret nz
	ld a, [hli]
	cp GHOST
	ret z
	ld a, [hl]
	cp GHOST
	ret z
	ld a, [wMoveMissed]
	and a
	ret nz
	ld a, ANIMATIONTYPE_SHAKE_SCREEN_HORIZONTALLY_LIGHT
	ld [wAnimationType], a
	.ASSERT ((ANIMATIONTYPE_SHAKE_SCREEN_HORIZONTALLY_LIGHT)-(MEGA_PUNCH)) < 1 && ((ANIMATIONTYPE_SHAKE_SCREEN_HORIZONTALLY_LIGHT)-(MEGA_PUNCH)) > -1
	; ld a, MEGA_PUNCH
; fallthrough
PlayMoveAnimation:
	ld [wAnimationID], a
	vc_hook_red Reduce_move_anim_flashing_Confusion
	call Delay3
	vc_hook_red Reduce_move_anim_flashing_Psychic
	predef_jump MoveAnimation

InitBattle:
	ld a, [wCurOpponent]
	and a
	jr z, DetermineWildOpponent

InitOpponent:
	ld a, [wCurOpponent]
	ld [wCurPartySpecies], a
	ld [wEnemyMonSpecies2], a
	jr InitBattleCommon

DetermineWildOpponent:
	ld a, [wStatusFlags6]
	bit BIT_DEBUG_MODE, a
	jr z, DetermineWildOpponent.notDebugMode
	ldh a, [lobyte(hJoyHeld)]
	bit B_PAD_B, a ; disable wild encounters
	ret nz
DetermineWildOpponent.notDebugMode
	ld a, [wNumberOfNoRandomBattleStepsLeft]
	and a
	ret nz
	callfar TryDoWildEncounter
	ret nz
InitBattleCommon:
	ld a, [wMapPalOffset]
	push af
	ld hl, wLetterPrintingDelayFlags
	ld a, [hl]
	push af
	res BIT_TEXT_DELAY, [hl] ; no delay
	callfar InitBattleVariables
	ld a, [wEnemyMonSpecies2]
	sub OPP_ID_OFFSET
	jp c, InitWildBattle
	ld [wTrainerClass], a
	call GetTrainerInformation
	callfar ReadTrainer
	call DoBattleTransitionAndInitBattleVariables
	call WLA_GLOBAL_LoadTrainerPic
	xor a
	ld [wEnemyMonSpecies2], a
	ldh [lobyte(hStartTileID)], a
	dec a
	ld [wAICount], a
	hlcoord 12, 0
	predef CopyUncompressedPicToTilemap
	ld a, $ff
	ld [wEnemyMonPartyPos], a
	ld a, $2
	ld [wIsInBattle], a
	jp WLA_GLOBAL_InitBattleCommon

InitWildBattle:
	ld a, $1
	ld [wIsInBattle], a
	call LoadEnemyMonData
	call DoBattleTransitionAndInitBattleVariables
	ld a, [wCurOpponent]
	cp RESTLESS_SOUL
	jr z, InitWildBattle.isGhost
	call IsGhostBattle
	jr nz, InitWildBattle.isNoGhost
InitWildBattle.isGhost
	ld hl, wMonHSpriteDim
	ld a, $66
	ld [hli], a   ; write sprite dimensions
	ld bc, GhostPic
	ld a, c
	ld [hli], a   ; write front sprite pointer
	ld [hl], b
	ld hl, wEnemyMonNick  ; set name to "GHOST"
	ld_hli_a_string "GHOST@"
	ld a, [wCurPartySpecies]
	push af
	ld a, MON_GHOST
	ld [wCurPartySpecies], a
	ld de, vFrontPic
	call LoadMonFrontSprite ; load ghost sprite
	pop af
	ld [wCurPartySpecies], a
	jr InitWildBattle.spriteLoaded
InitWildBattle.isNoGhost
	ld de, vFrontPic
	call LoadMonFrontSprite ; load mon sprite
InitWildBattle.spriteLoaded
	xor a
	ld [wTrainerClass], a
	ldh [lobyte(hStartTileID)], a
	hlcoord 12, 0
	predef CopyUncompressedPicToTilemap

; common code that executes after init battle code specific to trainer or wild battles
_InitBattleCommon:
WLA_GLOBAL_InitBattleCommon:
	ld b, SET_PAL_BATTLE_BLACK
	call RunPaletteCommand
	call SlidePlayerAndEnemySilhouettesOnScreen
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld hl, WLA_GLOBAL_InitBattleCommon__emptyString
	call PrintText
	call SaveScreenTilesToBuffer1
	call ClearScreen
	ld a, hibyte(vBGMap0)
	ldh [lobyte(hAutoBGTransferDest + 1)], a
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call Delay3
	ld a, hibyte(vBGMap1)
	ldh [lobyte(hAutoBGTransferDest + 1)], a
	call LoadScreenTilesFromBuffer1
	hlcoord 9, 7
	lb "bc", 5, 10
	call ClearScreenArea
	hlcoord 1, 0
	lb "bc", 4, 10
	call ClearScreenArea
	call ClearSprites
	ld a, [wIsInBattle]
	dec a ; is it a wild battle?
	call z, DrawEnemyHUDAndHPBar ; draw enemy HUD and HP bar if it's a wild battle
	call StartBattle
	callfar EndOfBattle
	pop af
	ld [wLetterPrintingDelayFlags], a
	pop af
	ld [wMapPalOffset], a
	ld a, [wSavedTileAnimations]
	ldh [lobyte(hTileAnimations)], a
	scf
	ret
_InitBattleCommon.emptyString:
WLA_GLOBAL_InitBattleCommon__emptyString:
		.STRINGMAP pokemon, "@"

_LoadTrainerPic:
WLA_GLOBAL_LoadTrainerPic:
	ld a, [wTrainerPicPointer]
	ld e, a
	ld a, [wTrainerPicPointer + 1]
	ld d, a ; de contains pointer to trainer pic
	ld a, [wLinkState]
	and a
	ld a, 19
	jr z, WLA_GLOBAL_LoadTrainerPic__loadSprite
	ld a, bank(RedPicFront)
_LoadTrainerPic.loadSprite:
WLA_GLOBAL_LoadTrainerPic__loadSprite:
	call UncompressSpriteFromDE
	ld de, vFrontPic
	ld a, $77
	ld c, a
	jp LoadUncompressedSpriteData

; unreferenced
ResetCryModifiers:
	xor a
	ld [wFrequencyModifier], a
	ld [wTempoModifier], a
	jp PlaySound

; animates the mon "growing" out of the pokeball
AnimateSendingOutMon:
	ld a, [wPredefHL]
	ld h, a
	ld a, [wPredefHL + 1]
	ld l, a
	ldh a, [lobyte(hStartTileID)]
	ldh [lobyte(hBaseTileID)], a
	ld b, $4c
	ld a, [wIsInBattle]
	and a
	jr z, AnimateSendingOutMon.notInBattle
	add b
	ld [hl], a
	call Delay3
	ld bc, -(SCREEN_WIDTH * 2 + 1)
	add hl, bc
	ld a, 1
	ld [wDownscaledMonSize], a
	lb "bc", 3, 3
	predef CopyDownscaledMonTiles
	ld c, 4
	call DelayFrames
	ld bc, -(SCREEN_WIDTH * 2 + 1)
	add hl, bc
	xor a
	ld [wDownscaledMonSize], a
	lb "bc", 5, 5
	predef CopyDownscaledMonTiles
	ld c, 5
	call DelayFrames
	ld bc, -(SCREEN_WIDTH * 2 + 1)
	jr AnimateSendingOutMon.next
AnimateSendingOutMon.notInBattle
	ld bc, -(SCREEN_WIDTH * 6 + 3)
AnimateSendingOutMon.next
	add hl, bc
	ldh a, [lobyte(hBaseTileID)]
	add $31
	jr CopyUncompressedPicToHL

CopyUncompressedPicToTilemap:
	ld a, [wPredefHL]
	ld h, a
	ld a, [wPredefHL + 1]
	ld l, a
	ldh a, [lobyte(hStartTileID)]
CopyUncompressedPicToHL:
	lb "bc", 7, 7
	ld de, SCREEN_WIDTH
	push af
	ld a, [wSpriteFlipped]
	and a
	jr nz, CopyUncompressedPicToHL.flipped
	pop af
CopyUncompressedPicToHL.loop
	push bc
	push hl
CopyUncompressedPicToHL.innerLoop
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, CopyUncompressedPicToHL.innerLoop
	pop hl
	inc hl
	pop bc
	dec b
	jr nz, CopyUncompressedPicToHL.loop
	ret

CopyUncompressedPicToHL.flipped
	push bc
	ld b, 0
	dec c
	add hl, bc
	pop bc
	pop af
CopyUncompressedPicToHL.flippedLoop
	push bc
	push hl
CopyUncompressedPicToHL.flippedInnerLoop
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, CopyUncompressedPicToHL.flippedInnerLoop
	pop hl
	dec hl
	pop bc
	dec b
	jr nz, CopyUncompressedPicToHL.flippedLoop
	ret

LoadMonBackPic:
; Assumes the monster's attributes have
; been loaded with GetMonHeader.
	ld a, [wBattleMonSpecies2]
	ld [wCurPartySpecies], a
	hlcoord 1, 5
	ld b, 7
	ld c, 8
	call ClearScreenArea
	ld hl, wMonHBackSprite - wMonHeader
	call UncompressMonSprite
	predef ScaleSpriteByTwo
	ld de, vBackPic
	call InterlaceMergeSpriteBuffers ; combine the two buffers to a single 2bpp sprite
	ld hl, vSprites
	ld de, vBackPic
	ld c, (2 * SPRITEBUFFERSIZE) / TILE_SIZE ; count of 16-byte chunks to be copied
	ldh a, [lobyte(hLoadedROMBank)]
	ld b, a
	jp CopyVideoData
