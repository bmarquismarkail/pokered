UseItem_:
	ld a, 1
	ld [wActionResultOrTookBattleTurn], a ; initialise to success value
	ld a, [wCurItem]
	cp HM01
	jp nc, ItemUseTMHM
	ld hl, ItemUsePtrTable
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

ItemUsePtrTable:
; entries correspond to item ids
	.DW ItemUseBall       ; MASTER_BALL
	.DW ItemUseBall       ; ULTRA_BALL
	.DW ItemUseBall       ; GREAT_BALL
	.DW ItemUseBall       ; POKE_BALL
	.DW ItemUseTownMap    ; TOWN_MAP
	.DW ItemUseBicycle    ; BICYCLE
	.DW ItemUseSurfboard  ; SURFBOARD
	.DW ItemUseBall       ; SAFARI_BALL
	.DW ItemUsePokedex    ; POKEDEX
	.DW ItemUseEvoStone   ; MOON_STONE
	.DW ItemUseMedicine   ; ANTIDOTE
	.DW ItemUseMedicine   ; BURN_HEAL
	.DW ItemUseMedicine   ; ICE_HEAL
	.DW ItemUseMedicine   ; AWAKENING
	.DW ItemUseMedicine   ; PARLYZ_HEAL
	.DW ItemUseMedicine   ; FULL_RESTORE
	.DW ItemUseMedicine   ; MAX_POTION
	.DW ItemUseMedicine   ; HYPER_POTION
	.DW ItemUseMedicine   ; SUPER_POTION
	.DW ItemUseMedicine   ; POTION
	.DW ItemUseBait       ; BOULDERBADGE
	.DW ItemUseRock       ; CASCADEBADGE
	.DW UnusableItem      ; THUNDERBADGE
	.DW UnusableItem      ; RAINBOWBADGE
	.DW UnusableItem      ; SOULBADGE
	.DW UnusableItem      ; MARSHBADGE
	.DW UnusableItem      ; VOLCANOBADGE
	.DW UnusableItem      ; EARTHBADGE
	.DW ItemUseEscapeRope ; ESCAPE_ROPE
	.DW ItemUseRepel      ; REPEL
	.DW UnusableItem      ; OLD_AMBER
	.DW ItemUseEvoStone   ; FIRE_STONE
	.DW ItemUseEvoStone   ; THUNDER_STONE
	.DW ItemUseEvoStone   ; WATER_STONE
	.DW ItemUseVitamin    ; HP_UP
	.DW ItemUseVitamin    ; PROTEIN
	.DW ItemUseVitamin    ; IRON
	.DW ItemUseVitamin    ; CARBOS
	.DW ItemUseVitamin    ; CALCIUM
	.DW ItemUseVitamin    ; RARE_CANDY
	.DW UnusableItem      ; DOME_FOSSIL
	.DW UnusableItem      ; HELIX_FOSSIL
	.DW UnusableItem      ; SECRET_KEY
	.DW UnusableItem      ; ITEM_2C
	.DW UnusableItem      ; BIKE_VOUCHER
	.DW ItemUseXAccuracy  ; X_ACCURACY
	.DW ItemUseEvoStone   ; LEAF_STONE
	.DW ItemUseCardKey    ; CARD_KEY
	.DW UnusableItem      ; NUGGET
	.DW UnusableItem      ; ITEM_32
	.DW ItemUsePokeDoll   ; POKE_DOLL
	.DW ItemUseMedicine   ; FULL_HEAL
	.DW ItemUseMedicine   ; REVIVE
	.DW ItemUseMedicine   ; MAX_REVIVE
	.DW ItemUseGuardSpec  ; GUARD_SPEC
	.DW ItemUseSuperRepel ; SUPER_REPEL
	.DW ItemUseMaxRepel   ; MAX_REPEL
	.DW ItemUseDireHit    ; DIRE_HIT
	.DW UnusableItem      ; COIN
	.DW ItemUseMedicine   ; FRESH_WATER
	.DW ItemUseMedicine   ; SODA_POP
	.DW ItemUseMedicine   ; LEMONADE
	.DW UnusableItem      ; S_S_TICKET
	.DW UnusableItem      ; GOLD_TEETH
	.DW ItemUseXStat      ; X_ATTACK
	.DW ItemUseXStat      ; X_DEFEND
	.DW ItemUseXStat      ; X_SPEED
	.DW ItemUseXStat      ; X_SPECIAL
	.DW ItemUseCoinCase   ; COIN_CASE
	.DW ItemUseOaksParcel ; OAKS_PARCEL
	.DW ItemUseItemfinder ; ITEMFINDER
	.DW UnusableItem      ; SILPH_SCOPE
	.DW ItemUsePokeFlute  ; POKE_FLUTE
	.DW UnusableItem      ; LIFT_KEY
	.DW UnusableItem      ; EXP_ALL
	.DW ItemUseOldRod     ; OLD_ROD
	.DW ItemUseGoodRod    ; GOOD_ROD
	.DW ItemUseSuperRod   ; SUPER_ROD
	.DW ItemUsePPUp       ; PP_UP
	.DW ItemUsePPRestore  ; ETHER
	.DW ItemUsePPRestore  ; MAX_ETHER
	.DW ItemUsePPRestore  ; ELIXER
	.DW ItemUsePPRestore  ; MAX_ELIXER

ItemUseBall:

; Balls can't be used out of battle.
	ld a, [wIsInBattle]
	and a
	jp z, ItemUseNotTime

; Balls can't catch trainers' Pokémon.
	dec a
	jp nz, ThrowBallAtTrainerMon

; If this is for the old man battle, skip checking if the party & box are full.
	ld a, [wBattleType]
	dec a
	jr z, ItemUseBall.canUseBall

	ld a, [wPartyCount] ; is party full?
	cp PARTY_LENGTH
	jr nz, ItemUseBall.canUseBall
	ld a, [wBoxCount] ; is box full?
	cp MONS_PER_BOX
	jp z, BoxFullCannotThrowBall

ItemUseBall.canUseBall
	xor a
	ld [wCapturedMonSpecies], a

	ld a, [wBattleType]
	cp BATTLE_TYPE_SAFARI
	jr nz, ItemUseBall.skipSafariZoneCode

ItemUseBall.safariZone
	ld hl, wNumSafariBalls
	dec [hl] ; remove a Safari Ball

ItemUseBall.skipSafariZoneCode
	call RunDefaultPaletteCommand

	ld a, $43 ; successful capture value
	ld [wPokeBallAnimData], a

	call LoadScreenTilesFromBuffer1
	ld hl, ItemUseText00
	call PrintText

; If the player is fighting an unidentified ghost, set the value that indicates
; the Pokémon can't be caught and skip the capture calculations.
	callfar IsGhostBattle
	ld b, $10 ; can't be caught value
	jp z, ItemUseBall.setAnimData

	ld a, [wBattleType]
	dec a
	jr nz, ItemUseBall.notOldManBattle

; Old Man battle
	ld hl, wGrassRate
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData ; save the player's name in the Wild Monster data (part of the Cinnabar Island Missingno. glitch)
	jp ItemUseBall.captured

ItemUseBall.notOldManBattle
; If the player is fighting the ghost Marowak, set the value that indicates the
; Pokémon can't be caught and skip the capture calculations.
	ld a, [wCurMap]
	cp POKEMON_TOWER_6F
	jr nz, ItemUseBall.loop
	ld a, [wEnemyMonSpecies2]
	cp RESTLESS_SOUL
	ld b, $10 ; can't be caught value
	jp z, ItemUseBall.setAnimData

; Get the first random number. Let it be called Rand1.
; Rand1 must be within a certain range according the kind of ball being thrown.
; The ranges are as follows.
; Poké Ball:         [0, 255]
; Great Ball:        [0, 200]
; Ultra/Safari Ball: [0, 150]
; Loop until an acceptable number is found.

ItemUseBall.loop
	call Random
	ld b, a

; Get the item ID.
	ld hl, wCurItem
	ld a, [hl]

; The Master Ball always succeeds.
	cp MASTER_BALL
	jp z, ItemUseBall.captured

; Anything will do for the basic Poké Ball.
	cp POKE_BALL
	jr z, ItemUseBall.checkForAilments

; If it's a Great/Ultra/Safari Ball and Rand1 is greater than 200, try again.
	ld a, 200
	cp b
	jr c, ItemUseBall.loop

; Less than or equal to 200 is good enough for a Great Ball.
	ld a, [hl]
	cp GREAT_BALL
	jr z, ItemUseBall.checkForAilments

; If it's an Ultra/Safari Ball and Rand1 is greater than 150, try again.
	ld a, 150
	cp b
	jr c, ItemUseBall.loop

ItemUseBall.checkForAilments
; Pokémon can be caught more easily with a status ailment.
; Depending on the status ailment, a certain value will be subtracted from
; Rand1. Let this value be called Status.
; The larger Status is, the more easily the Pokémon can be caught.
; no status ailment:     Status = 0
; Burn/Paralysis/Poison: Status = 12
; Freeze/Sleep:          Status = 25
; If Status is greater than Rand1, the Pokémon will be caught for sure.
	ld a, [wEnemyMonStatus]
	and a
	jr z, ItemUseBall.skipAilmentValueSubtraction ; no ailments
	and (1 << FRZ) | SLP_MASK
	ld c, 12
	jr z, ItemUseBall.notFrozenOrAsleep
	ld c, 25
ItemUseBall.notFrozenOrAsleep
	ld a, b
	sub c
	jp c, ItemUseBall.captured
	ld b, a

ItemUseBall.skipAilmentValueSubtraction
	push bc ; save (Rand1 - Status)

; Calculate MaxHP * 255.
	xor a
	ldh [lobyte(hMultiplicand)], a
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, [hl]
	ldh [lobyte(hMultiplicand + 2)], a
	ld a, 255
	ldh [lobyte(hMultiplier)], a
	call Multiply

; Determine BallFactor. It's 8 for Great Balls and 12 for the others.
	ld a, [wCurItem]
	cp GREAT_BALL
	ld a, 12
	jr nz, ItemUseBall.skip1
	ld a, 8

ItemUseBall.skip1
; Note that the results of all division operations are floored.

; Calculate (MaxHP * 255) / BallFactor.
	ldh [lobyte(hDivisor)], a
	ld b, 4 ; number of bytes in dividend
	call Divide

; Divide the enemy's current HP by 4. HP is not supposed to exceed 999 so
; the result should fit in a. If the division results in a quotient of 0,
; change it to 1.
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld b, a
	ld a, [hl]
	srl b
	rr a
	srl b
	rr a
	and a
	jr nz, ItemUseBall.skip2
	inc a

ItemUseBall.skip2
; Let W = ((MaxHP * 255) / BallFactor) / max(HP / 4, 1). Calculate W.
	ldh [lobyte(hDivisor)], a
	ld b, 4
	call Divide

; If W > 255, store 255 in [hQuotient + 3].
; Let X = min(W, 255) = [hQuotient + 3].
	ldh a, [lobyte(hQuotient + 2)]
	and a
	jr z, ItemUseBall.skip3
	ld a, 255
	ldh [lobyte(hQuotient + 3)], a

ItemUseBall.skip3
	pop bc ; b = Rand1 - Status

; If Rand1 - Status > CatchRate, the ball fails to capture the Pokémon.
	ld a, [wEnemyMonActualCatchRate]
	cp b
	jr c, ItemUseBall.failedToCapture

; If W > 255, the ball captures the Pokémon.
	ldh a, [lobyte(hQuotient + 2)]
	and a
	jr nz, ItemUseBall.captured

	call Random ; Let this random number be called Rand2.

; If Rand2 > X, the ball fails to capture the Pokémon.
	ld b, a
	ldh a, [lobyte(hQuotient + 3)]
	cp b
	jr c, ItemUseBall.failedToCapture

ItemUseBall.captured
	jr ItemUseBall.skipShakeCalculations

ItemUseBall.failedToCapture
	ldh a, [lobyte(hQuotient + 3)]
	ld [wPokeBallCaptureCalcTemp], a ; Save X.

; Calculate CatchRate * 100.
	xor a
	ldh [lobyte(hMultiplicand)], a
	ldh [lobyte(hMultiplicand + 1)], a
	ld a, [wEnemyMonActualCatchRate]
	ldh [lobyte(hMultiplicand + 2)], a
	ld a, 100
	ldh [lobyte(hMultiplier)], a
	call Multiply

; Determine BallFactor2.
; Poké Ball:         BallFactor2 = 255
; Great Ball:        BallFactor2 = 200
; Ultra/Safari Ball: BallFactor2 = 150
	ld a, [wCurItem]
	ld b, 255
	cp POKE_BALL
	jr z, ItemUseBall.skip4
	ld b, 200
	cp GREAT_BALL
	jr z, ItemUseBall.skip4
	ld b, 150
	cp ULTRA_BALL
	jr z, ItemUseBall.skip4

ItemUseBall.skip4
; Let Y = (CatchRate * 100) / BallFactor2. Calculate Y.
	ld a, b
	ldh [lobyte(hDivisor)], a
	ld b, 4
	call Divide

; If Y > 255, there are 3 shakes.
; Note that this shouldn't be possible.
; The maximum value of Y is (255 * 100) / 150 = 170.
	ldh a, [lobyte(hQuotient + 2)]
	and a
	ld b, $63 ; 3 shakes
	jr nz, ItemUseBall.setAnimData

; Calculate X * Y.
	ld a, [wPokeBallCaptureCalcTemp]
	ldh [lobyte(hMultiplier)], a
	call Multiply

; Calculate (X * Y) / 255.
	ld a, 255
	ldh [lobyte(hDivisor)], a
	ld b, 4
	call Divide

; Determine Status2.
; no status ailment:     Status2 = 0
; Burn/Paralysis/Poison: Status2 = 5
; Freeze/Sleep:          Status2 = 10
	ld a, [wEnemyMonStatus]
	and a
	jr z, ItemUseBall.skip5
	and (1 << FRZ) | SLP_MASK
	ld b, 5
	jr z, ItemUseBall.addAilmentValue
	ld b, 10

ItemUseBall.addAilmentValue
; If the Pokémon has a status ailment, add Status2.
	ldh a, [lobyte(hQuotient + 3)]
	add b
	ldh [lobyte(hQuotient + 3)], a

ItemUseBall.skip5
; Finally determine the number of shakes.
; Let Z = ((X * Y) / 255) + Status2 = [hQuotient + 3].
; The number of shakes depend on the range Z is in.
; 0  ≤ Z < 10: 0 shakes (the ball misses)
; 10 ≤ Z < 30: 1 shake
; 30 ≤ Z < 70: 2 shakes
; 70 ≤ Z:      3 shakes
	ldh a, [lobyte(hQuotient + 3)]
	cp 10
	ld b, $20
	jr c, ItemUseBall.setAnimData
	cp 30
	ld b, $61
	jr c, ItemUseBall.setAnimData
	cp 70
	ld b, $62
	jr c, ItemUseBall.setAnimData
	ld b, $63

ItemUseBall.setAnimData
	ld a, b
	ld [wPokeBallAnimData], a

ItemUseBall.skipShakeCalculations
	ld c, 20
	call DelayFrames

; Do the animation.
	ld a, TOSS_ANIM
	ld [wAnimationID], a
	xor a
	ldh [lobyte(hWhoseTurn)], a
	ld [wAnimationType], a
	ld [wDamageMultipliers], a
	ld a, [wWhichPokemon]
	push af
	ld a, [wCurItem]
	push af
	predef MoveAnimation
	pop af
	ld [wCurItem], a
	pop af
	ld [wWhichPokemon], a

; Determine the message to display from the animation.
	ld a, [wPokeBallAnimData]
	cp $10
	ld hl, ItemUseBallText00
	jp z, ItemUseBall.printMessage
	cp $20
	ld hl, ItemUseBallText01
	jp z, ItemUseBall.printMessage
	cp $61
	ld hl, ItemUseBallText02
	jp z, ItemUseBall.printMessage
	cp $62
	ld hl, ItemUseBallText03
	jp z, ItemUseBall.printMessage
	cp $63
	ld hl, ItemUseBallText04
	jp z, ItemUseBall.printMessage

; Save current HP.
	ld hl, wEnemyMonHP
	ld a, [hli]
	push af
	ld a, [hli]
	push af

; Save status ailment.
	inc hl
	ld a, [hl]
	push af

	push hl

; Bug: If the Pokémon is transformed, the Pokémon is assumed to be a Ditto.
; This is a bug because a wild Pokémon could have used Transform via
; Mirror Move even though the only wild Pokémon that knows Transform is Ditto.
	ld hl, wEnemyBattleStatus3
	bit TRANSFORMED, [hl]
	jr z, ItemUseBall.notTransformed
	ld a, DITTO
	ld [wEnemyMonSpecies2], a
	jr ItemUseBall.skip6

ItemUseBall.notTransformed
; If the Pokémon is not transformed, set the transformed bit and copy the
; DVs to wTransformedEnemyMonOriginalDVs so that LoadEnemyMonData won't generate
; new DVs.
	set TRANSFORMED, [hl]
	ld hl, wTransformedEnemyMonOriginalDVs
	ld a, [wEnemyMonDVs]
	ld [hli], a
	ld a, [wEnemyMonDVs + 1]
	ld [hl], a

ItemUseBall.skip6
	ld a, [wCurPartySpecies]
	push af
	ld a, [wEnemyMonSpecies2]
	ld [wCurPartySpecies], a
	ld a, [wEnemyMonLevel]
	ld [wCurEnemyLevel], a
	callfar LoadEnemyMonData
	pop af
	ld [wCurPartySpecies], a
	pop hl
	pop af
	ld [hld], a
	dec hl
	pop af
	ld [hld], a
	pop af
	ld [hl], a
	ld a, [wEnemyMonSpecies]
	ld [wCapturedMonSpecies], a
	ld [wCurPartySpecies], a
	ld [wPokedexNum], a
	ld a, [wBattleType]
	dec a ; is this the old man battle?
	jr z, ItemUseBall.oldManCaughtMon ; if so, don't give the player the caught Pokémon

	ld hl, ItemUseBallText05
	call PrintText

; Add the caught Pokémon to the Pokédex.
	predef IndexToPokedex
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld b, FLAG_TEST
	ld hl, wPokedexOwned
	predef FlagActionPredef
	ld a, c
	push af
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld b, FLAG_SET
	predef FlagActionPredef
	pop af

	and a ; was the Pokémon already in the Pokédex?
	jr nz, ItemUseBall.skipShowingPokedexData ; if so, don't show the Pokédex data

	ld hl, ItemUseBallText06
	call PrintText
	call ClearSprites
	ld a, [wEnemyMonSpecies]
	ld [wPokedexNum], a
	predef ShowPokedexData

ItemUseBall.skipShowingPokedexData
	ld a, [wPartyCount]
	cp PARTY_LENGTH ; is party full?
	jr z, ItemUseBall.sendToBox
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	call ClearSprites
	call AddPartyMon
	jr ItemUseBall.done

ItemUseBall.sendToBox
	call ClearSprites
	call SendNewMonToBox
	ld hl, ItemUseBallText07
	CheckEvent EVENT_MET_BILL
	jr nz, ItemUseBall.printTransferredToPCText
	ld hl, ItemUseBallText08
ItemUseBall.printTransferredToPCText
	call PrintText
	jr ItemUseBall.done

ItemUseBall.oldManCaughtMon
	ld hl, ItemUseBallText05

ItemUseBall.printMessage
	call PrintText
	call ClearSprites

ItemUseBall.done
	ld a, [wBattleType]
	and a ; is this the old man battle?
	ret nz ; if so, don't remove a ball from the bag

; Remove a ball from the bag.
	ld hl, wNumBagItems
	inc a
	ld [wItemQuantity], a
	jp RemoveItemFromInventory

ItemUseBallText00:
;"It dodged the thrown ball!"
;"This pokemon can't be caught"
	text_far WLA_GLOBAL_ItemUseBallText00
	text_end
ItemUseBallText01:
;"You missed the pokemon!"
	text_far WLA_GLOBAL_ItemUseBallText01
	text_end
ItemUseBallText02:
;"Darn! The pokemon broke free!"
	text_far WLA_GLOBAL_ItemUseBallText02
	text_end
ItemUseBallText03:
;"Aww! It appeared to be caught!"
	text_far WLA_GLOBAL_ItemUseBallText03
	text_end
ItemUseBallText04:
;"Shoot! It was so close too!"
	text_far WLA_GLOBAL_ItemUseBallText04
	text_end
ItemUseBallText05:
;"All right! {MonName} was caught!"
;play sound
	text_far WLA_GLOBAL_ItemUseBallText05
	sound_caught_mon
	text_promptbutton
	text_end
ItemUseBallText07:
;"X was transferred to Bill's PC"
	text_far WLA_GLOBAL_ItemUseBallText07
	text_end
ItemUseBallText08:
;"X was transferred to someone's PC"
	text_far WLA_GLOBAL_ItemUseBallText08
	text_end

ItemUseBallText06:
;"New DEX data will be added..."
;play sound
	text_far WLA_GLOBAL_ItemUseBallText06
	sound_dex_page_added
	text_promptbutton
	text_end

ItemUseTownMap:
	ld a, [wIsInBattle]
	and a
	jp nz, ItemUseNotTime
	farjp DisplayTownMap

ItemUseBicycle:
	ld a, [wIsInBattle]
	and a
	jp nz, ItemUseNotTime
	ld a, [wWalkBikeSurfState]
	ld [wWalkBikeSurfStateCopy], a
	cp 2 ; is the player surfing?
	jp z, ItemUseNotTime
	dec a ; is player already bicycling?
	jr nz, ItemUseBicycle.tryToGetOnBike
; get off bike
	call ItemUseReloadOverworldData
	xor a
	ld [wWalkBikeSurfState], a ; change player state to walking
	call PlayDefaultMusic ; play walking music
	ld hl, GotOffBicycleText
	jr ItemUseBicycle.printText
ItemUseBicycle.tryToGetOnBike
	call IsBikeRidingAllowed
	jp nc, NoCyclingAllowedHere
	call ItemUseReloadOverworldData
	xor a ; no keys pressed
	ldh [lobyte(hJoyHeld)], a ; current joypad state
	inc a
	ld [wWalkBikeSurfState], a ; change player state to bicycling
	ld hl, GotOnBicycleText
	call PlayDefaultMusic ; play bike riding music
ItemUseBicycle.printText
	jp PrintText

; indirectly used by SURF in StartMenu_Pokemon.surf
ItemUseSurfboard:
	ld a, [wWalkBikeSurfState]
	ld [wWalkBikeSurfStateCopy], a
	cp 2 ; is the player already surfing?
	jr z, ItemUseSurfboard.tryToStopSurfing
; try to Surf
	call IsNextTileShoreOrWater
	jp c, SurfingAttemptFailed
	ld hl, TilePairCollisionsWater
	call CheckForTilePairCollisions
	jp c, SurfingAttemptFailed
; surfing
	call ItemUseSurfboard.makePlayerMoveForward
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld a, 2
	ld [wWalkBikeSurfState], a ; change player state to surfing
	call PlayDefaultMusic ; play surfing music
	ld hl, SurfingGotOnText
	jp PrintText
ItemUseSurfboard.tryToStopSurfing
	xor a
	ldh [lobyte(hSpriteIndex)], a
	ld d, 16 ; talking range in pixels (normal range)
	call IsSpriteInFrontOfPlayer2
	res BIT_FACE_PLAYER, [hl]
	ldh a, [lobyte(hSpriteIndex)]
	and a ; is there a sprite in the way?
	jr nz, ItemUseSurfboard.cannotStopSurfing
	ld hl, TilePairCollisionsWater
	call CheckForTilePairCollisions
	jr c, ItemUseSurfboard.cannotStopSurfing
	ld hl, wTilesetCollisionPtr ; pointer to list of passable tiles
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl now points to passable tiles
	ld a, [wTileInFrontOfPlayer] ; tile in front of the player
	ld b, a
ItemUseSurfboard.passableTileLoop
	ld a, [hli]
	cp b
	jr z, ItemUseSurfboard.stopSurfing
	cp $ff
	jr nz, ItemUseSurfboard.passableTileLoop
ItemUseSurfboard.cannotStopSurfing
	ld hl, SurfingNoPlaceToGetOffText
	jp PrintText
ItemUseSurfboard.stopSurfing
	call ItemUseSurfboard.makePlayerMoveForward
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	xor a
	ld [wWalkBikeSurfState], a ; change player state to walking
	dec a
	ld [wJoyIgnore], a
	call PlayDefaultMusic ; play walking music
	jp LoadWalkingPlayerSpriteGraphics
; uses a simulated button press to make the player move forward
ItemUseSurfboard.makePlayerMoveForward
	ld a, [wPlayerDirection] ; direction the player is going
	bit PLAYER_DIR_BIT_UP, a
	ld b, PAD_UP
	jr nz, ItemUseSurfboard.storeSimulatedButtonPress
	bit PLAYER_DIR_BIT_DOWN, a
	ld b, PAD_DOWN
	jr nz, ItemUseSurfboard.storeSimulatedButtonPress
	bit PLAYER_DIR_BIT_LEFT, a
	ld b, PAD_LEFT
	jr nz, ItemUseSurfboard.storeSimulatedButtonPress
	ld b, PAD_RIGHT
ItemUseSurfboard.storeSimulatedButtonPress
	ld a, b
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wUnusedSimulatedJoypadStatesMask], a
	inc a
	ld [wSimulatedJoypadStatesIndex], a
	ret

SurfingGotOnText:
	text_far WLA_GLOBAL_SurfingGotOnText
	text_end

SurfingNoPlaceToGetOffText:
	text_far WLA_GLOBAL_SurfingNoPlaceToGetOffText
	text_end

ItemUsePokedex:
	predef_jump ShowPokedexMenu

ItemUseEvoStone:
	ld a, [wIsInBattle]
	and a
	jp nz, ItemUseNotTime
	ld a, [wWhichPokemon]
	push af
	ld a, [wCurItem]
	ld [wEvoStoneItemID], a
	push af
	ld a, EVO_STONE_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	call DisplayPartyMenu
	pop bc
	jr c, ItemUseEvoStone.canceledItemUse
	ld a, b
	ld [wCurPartySpecies], a
	ld a, TRUE
	ld [wForceEvolution], a
	ld a, SFX_HEAL_AILMENT
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	callfar TryEvolvingMon ; try to evolve pokemon
	ld a, [wEvolutionOccurred]
	and a
	jr z, ItemUseEvoStone.noEffect
	pop af
	ld [wWhichPokemon], a
	ld hl, wNumBagItems
	ld a, 1 ; remove 1 stone
	ld [wItemQuantity], a
	jp RemoveItemFromInventory
ItemUseEvoStone.noEffect
	call ItemUseNoEffect
ItemUseEvoStone.canceledItemUse
	xor a
	ld [wActionResultOrTookBattleTurn], a ; item not used
	pop af
	ret

ItemUseVitamin:
	ld a, [wIsInBattle]
	and a
	jp nz, ItemUseNotTime

ItemUseMedicine:
	ld a, [wPartyCount]
	and a
	jp z, ItemUseMedicine.emptyParty
	ld a, [wWhichPokemon]
	push af
	ld a, [wCurItem]
	push af
	ld a, USE_ITEM_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, [wPseudoItemID]
	and a ; using Softboiled?
	jr z, ItemUseMedicine.notUsingSoftboiled
; if using softboiled
	call GoBackToPartyMenu
	jr ItemUseMedicine.getPartyMonDataAddress
ItemUseMedicine.emptyParty
	ld hl, ItemUseMedicine.emptyPartyText
	xor a
	ld [wActionResultOrTookBattleTurn], a ; item use failed
	jp PrintText
ItemUseMedicine.emptyPartyText
	text "You don't have"
	line "any #MON!"
	prompt
ItemUseMedicine.notUsingSoftboiled
	call DisplayPartyMenu
ItemUseMedicine.getPartyMonDataAddress
	jp c, ItemUseMedicine.canceledItemUse
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld a, [wWhichPokemon]
	ld [wUsedItemOnWhichPokemon], a
	ld d, a
	ld a, [wCurPartySpecies]
	ld e, a
	ld [wCurSpecies], a
	pop af
	ld [wCurItem], a
	pop af
	ld [wWhichPokemon], a
	ld a, [wPseudoItemID]
	and a ; using Softboiled?
	jr z, ItemUseMedicine.checkItemType
; if using softboiled
	ld a, [wWhichPokemon]
	cp d ; is the pokemon trying to use softboiled on itself?
	jr z, ItemUseMedicine ; if so, force another choice
ItemUseMedicine.checkItemType
	ld a, [wCurItem]
	cp REVIVE
	jr nc, ItemUseMedicine.healHP ; if it's a Revive or Max Revive
	cp FULL_HEAL
	jr z, ItemUseMedicine.cureStatusAilment ; if it's a Full Heal
	cp HP_UP
	jp nc, ItemUseMedicine.useVitamin ; if it's a vitamin or Rare Candy
	cp FULL_RESTORE
	jr nc, ItemUseMedicine.healHP ; if it's a Full Restore or one of the potions
; fall through if it's one of the status-specific healing items
ItemUseMedicine.cureStatusAilment
	ld bc, MON_STATUS
	add hl, bc ; hl now points to status
	ld a, [wCurItem]
	lb "bc", ANTIDOTE_MSG, 1 << PSN
	cp ANTIDOTE
	jr z, ItemUseMedicine.checkMonStatus
	lb "bc", BURN_HEAL_MSG, 1 << BRN
	cp BURN_HEAL
	jr z, ItemUseMedicine.checkMonStatus
	lb "bc", ICE_HEAL_MSG, 1 << FRZ
	cp ICE_HEAL
	jr z, ItemUseMedicine.checkMonStatus
	lb "bc", AWAKENING_MSG, SLP_MASK
	cp AWAKENING
	jr z, ItemUseMedicine.checkMonStatus
	lb "bc", PARALYZ_HEAL_MSG, 1 << PAR
	cp PARLYZ_HEAL
	jr z, ItemUseMedicine.checkMonStatus
	lb "bc", FULL_HEAL_MSG, $ff ; Full Heal
ItemUseMedicine.checkMonStatus
	ld a, [hl] ; pokemon's status
	and c ; does the pokemon have a status ailment the item can cure?
	jp z, ItemUseMedicine.healingItemNoEffect
; if the pokemon has a status the item can heal
	xor a
	ld [hl], a ; remove the status ailment in the party data
	ld a, b
	ld [wPartyMenuTypeOrMessageID], a ; the message to display for the item used
	ld a, [wPlayerMonNumber]
	cp d ; is pokemon the item was used on active in battle?
	jp nz, ItemUseMedicine.doneHealing
; if it is active in battle
	xor a
	ld [wBattleMonStatus], a ; remove the status ailment in the in-battle pokemon data
	push hl
	ld hl, wPlayerBattleStatus3
	res BADLY_POISONED, [hl] ; heal Toxic status
	pop hl
	ld bc, MON_STATS - MON_STATUS
	add hl, bc ; hl now points to party stats
	ld de, wBattleMonStats
	ld bc, NUM_STATS * 2
	call CopyData ; copy party stats to in-battle stat data
	predef DoubleOrHalveSelectedStats
	jp ItemUseMedicine.doneHealing
ItemUseMedicine.healHP
	inc hl ; hl = address of current HP
	ld a, [hli]
	ld b, a
	ld [wHPBarOldHP+1], a
	ld a, [hl]
	ld c, a
	ld [wHPBarOldHP], a ; current HP stored at wHPBarOldHP (2 bytes, big-endian)
	or b
	jr nz, ItemUseMedicine.notFainted
; fainted
	ld a, [wCurItem]
	cp REVIVE
	jr z, ItemUseMedicine.updateInBattleFaintedData
	cp MAX_REVIVE
	jr z, ItemUseMedicine.updateInBattleFaintedData
	jp ItemUseMedicine.healingItemNoEffect
ItemUseMedicine.updateInBattleFaintedData
	ld a, [wIsInBattle]
	and a
	jr z, ItemUseMedicine.compareCurrentHPToMaxHP
	push hl
	push de
	push bc
	ld a, [wUsedItemOnWhichPokemon]
	ld c, a
	ld hl, wPartyFoughtCurrentEnemyFlags
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	jr z, ItemUseMedicine.next
	ld a, [wUsedItemOnWhichPokemon]
	ld c, a
	ld hl, wPartyGainExpFlags
	ld b, FLAG_SET
	predef FlagActionPredef
ItemUseMedicine.next
	pop bc
	pop de
	pop hl
	jr ItemUseMedicine.compareCurrentHPToMaxHP
ItemUseMedicine.notFainted
	ld a, [wCurItem]
	cp REVIVE
	jp z, ItemUseMedicine.healingItemNoEffect
	cp MAX_REVIVE
	jp z, ItemUseMedicine.healingItemNoEffect
ItemUseMedicine.compareCurrentHPToMaxHP
	push hl
	push bc
	ld bc, MON_MAXHP - (MON_HP + 1)
	add hl, bc ; hl now points to max HP
	pop bc
	ld a, [hli]
	cp b
	jr nz, ItemUseMedicine.skipComparingLSB ; no need to compare the LSB's if the MSB's don't match
	ld a, [hl]
	cp c
ItemUseMedicine.skipComparingLSB
	pop hl
	jr nz, ItemUseMedicine.notFullHP
; if the pokemon's current HP equals its max HP
	ld a, [wCurItem]
	cp FULL_RESTORE
	jp nz, ItemUseMedicine.healingItemNoEffect
	inc hl
	inc hl
	ld a, [hld] ; status ailment
	and a ; does the pokemon have a status ailment?
	jp z, ItemUseMedicine.healingItemNoEffect
	ld a, FULL_HEAL
	ld [wCurItem], a
	dec hl
	dec hl
	dec hl
	jp ItemUseMedicine.cureStatusAilment
ItemUseMedicine.notFullHP ; if the pokemon's current HP doesn't equal its max HP
	xor a
	ld [wLowHealthAlarm], a ;disable low health alarm
	ld [wChannelSoundIDs + CHAN5], a
	push hl
	push de
	ld bc, MON_MAXHP - (MON_HP + 1)
	add hl, bc ; hl now points to max HP
	ld a, [hli]
	ld [wHPBarMaxHP+1], a
	ld a, [hl]
	ld [wHPBarMaxHP], a ; max HP stored at wHPBarMaxHP (2 bytes, big-endian)
	ld a, [wPseudoItemID]
	and a ; using Softboiled?
	jp z, ItemUseMedicine.notUsingSoftboiled2
; if using softboiled
	ld hl, wHPBarMaxHP
	ld a, [hli]
	push af
	ld a, [hli]
	push af
	ld a, [hli]
	push af
	ld a, [hl]
	push af
	ld hl, wPartyMon1MaxHP
	ld a, [wWhichPokemon]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hli]
	ld [wHPBarMaxHP + 1], a
	ldh [lobyte(hDividend)], a
	ld a, [hl]
	ld [wHPBarMaxHP], a
	ldh [lobyte(hDividend + 1)], a
	ld a, 5
	ldh [lobyte(hDivisor)], a
	ld b, 2 ; number of bytes
	call Divide ; get 1/5 of max HP of pokemon that used Softboiled
	ld bc, (MON_HP + 1) - (MON_MAXHP + 1)
	add hl, bc ; hl now points to LSB of current HP of pokemon that used Softboiled
; subtract 1/5 of max HP from current HP of pokemon that used Softboiled
	ldh a, [lobyte(hQuotient + 3)]
	push af
	ld b, a
	ld a, [hl]
	ld [wHPBarOldHP], a
	sub b
	ld [hld], a
	ld [wHPBarNewHP], a
	ldh a, [lobyte(hQuotient + 2)]
	ld b, a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	sbc b
	ld [hl], a
	ld [wHPBarNewHP+1], a
	hlcoord 4, 1
	ld a, [wWhichPokemon]
	ld bc, 2 * SCREEN_WIDTH
	call AddNTimes ; calculate coordinates of HP bar of pokemon that used Softboiled
	ld a, SFX_HEAL_HP
	call PlaySoundWaitForCurrent
	ldh a, [lobyte(hUILayoutFlags)]
	set BIT_PARTY_MENU_HP_BAR, a
	ldh [lobyte(hUILayoutFlags)], a
	ld a, $02
	ld [wHPBarType], a
	predef UpdateHPBar2 ; animate HP bar decrease of pokemon that used Softboiled
	ldh a, [lobyte(hUILayoutFlags)]
	res BIT_PARTY_MENU_HP_BAR, a
	ldh [lobyte(hUILayoutFlags)], a
	pop af
	ld b, a ; store heal amount (1/5 of max HP)
	ld hl, wHPBarOldHP + 1
	pop af
	ld [hld], a
	pop af
	ld [hld], a
	pop af
	ld [hld], a
	pop af
	ld [hl], a
	jr ItemUseMedicine.addHealAmount
ItemUseMedicine.notUsingSoftboiled2
	ld a, [wCurItem]
	cp SODA_POP
	ld b, 60 ; Soda Pop heal amount
	jr z, ItemUseMedicine.addHealAmount
	ld b, 80 ; Lemonade heal amount
	jr nc, ItemUseMedicine.addHealAmount
	cp FRESH_WATER
	ld b, 50 ; Fresh Water heal amount
	jr z, ItemUseMedicine.addHealAmount
	cp SUPER_POTION
	ld b, 200 ; Hyper Potion heal amount
	jr c, ItemUseMedicine.addHealAmount
	ld b, 50 ; Super Potion heal amount
	jr z, ItemUseMedicine.addHealAmount
	ld b, 20 ; Potion heal amount
ItemUseMedicine.addHealAmount
	pop de
	pop hl
	ld a, [hl]
	add b
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarNewHP+1], a
	jr nc, ItemUseMedicine.noCarry
	inc [hl]
	ld a, [hl]
	ld [wHPBarNewHP + 1], a
ItemUseMedicine.noCarry
	push de
	inc hl
	ld d, h
	ld e, l ; de now points to current HP
	ld hl, (MON_MAXHP + 1) - (MON_HP + 1)
	add hl, de ; hl now points to max HP
	ld a, [wCurItem]
	cp REVIVE
	jr z, ItemUseMedicine.setCurrentHPToHalfMaxHP
	ld a, [hld]
	ld b, a
	ld a, [de]
	sub b
	dec de
	ld b, [hl]
	ld a, [de]
	sbc b
	jr nc, ItemUseMedicine.setCurrentHPToMaxHp ; if current HP exceeds max HP after healing
	ld a, [wCurItem]
	cp HYPER_POTION
	jr c, ItemUseMedicine.setCurrentHPToMaxHp ; if using a Full Restore or Max Potion
	cp MAX_REVIVE
	jr z, ItemUseMedicine.setCurrentHPToMaxHp ; if using a Max Revive
	jr ItemUseMedicine.updateInBattleData
ItemUseMedicine.setCurrentHPToHalfMaxHP
	dec hl
	dec de
	ld a, [hli]
	srl a
	ld [de], a
	ld [wHPBarNewHP+1], a
	ld a, [hl]
	rr a
	inc de
	ld [de], a
	ld [wHPBarNewHP], a
	dec de
	jr ItemUseMedicine.doneHealingPartyHP
ItemUseMedicine.setCurrentHPToMaxHp
	ld a, [hli]
	ld [de], a
	ld [wHPBarNewHP+1], a
	inc de
	ld a, [hl]
	ld [de], a
	ld [wHPBarNewHP], a
	dec de
ItemUseMedicine.doneHealingPartyHP ; done updating the pokemon's current HP in the party data structure
	ld a, [wCurItem]
	cp FULL_RESTORE
	jr nz, ItemUseMedicine.updateInBattleData
	ld bc, MON_STATUS - (MON_MAXHP + 1)
	add hl, bc
	xor a
	ld [hl], a ; remove the status ailment in the party data
ItemUseMedicine.updateInBattleData
	ld h, d
	ld l, e
	pop de
	ld a, [wPlayerMonNumber]
	cp d ; is pokemon the item was used on active in battle?
	jr nz, ItemUseMedicine.calculateHPBarCoords
; copy party HP to in-battle HP
	ld a, [hli]
	ld [wBattleMonHP], a
	ld a, [hld]
	ld [wBattleMonHP + 1], a
	ld a, [wCurItem]
	cp FULL_RESTORE
	jr nz, ItemUseMedicine.calculateHPBarCoords
	xor a
	ld [wBattleMonStatus], a ; remove the status ailment in the in-battle pokemon data
ItemUseMedicine.calculateHPBarCoords
	hlcoord 4, -1
	ld bc, 2 * SCREEN_WIDTH
	inc d
ItemUseMedicine.calculateHPBarCoordsLoop
	add hl, bc
	dec d
	jr nz, ItemUseMedicine.calculateHPBarCoordsLoop
	jr ItemUseMedicine.doneHealing
ItemUseMedicine.healingItemNoEffect
	call ItemUseNoEffect
	jp ItemUseMedicine.done
ItemUseMedicine.doneHealing
	ld a, [wPseudoItemID]
	and a ; using Softboiled?
	jr nz, ItemUseMedicine.skipRemovingItem ; no item to remove if using Softboiled
	push hl
	call RemoveUsedItem
	pop hl
ItemUseMedicine.skipRemovingItem
	ld a, [wCurItem]
	cp FULL_RESTORE
	jr c, ItemUseMedicine.playStatusAilmentCuringSound
	cp FULL_HEAL
	jr z, ItemUseMedicine.playStatusAilmentCuringSound
	ld a, SFX_HEAL_HP
	call PlaySoundWaitForCurrent
	ldh a, [lobyte(hUILayoutFlags)]
	set BIT_PARTY_MENU_HP_BAR, a
	ldh [lobyte(hUILayoutFlags)], a
	ld a, $02
	ld [wHPBarType], a
	predef UpdateHPBar2 ; animate the HP bar lengthening
	ldh a, [lobyte(hUILayoutFlags)]
	res BIT_PARTY_MENU_HP_BAR, a
	ldh [lobyte(hUILayoutFlags)], a
	ld a, REVIVE_MSG
	ld [wPartyMenuTypeOrMessageID], a
	ld a, [wCurItem]
	cp REVIVE
	jr z, ItemUseMedicine.showHealingItemMessage
	cp MAX_REVIVE
	jr z, ItemUseMedicine.showHealingItemMessage
	ld a, POTION_MSG
	ld [wPartyMenuTypeOrMessageID], a
	jr ItemUseMedicine.showHealingItemMessage
ItemUseMedicine.playStatusAilmentCuringSound
	ld a, SFX_HEAL_AILMENT
	call PlaySoundWaitForCurrent
ItemUseMedicine.showHealingItemMessage
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call ClearScreen
	dec a
	ld [wUpdateSpritesEnabled], a
	call RedrawPartyMenu ; redraws the party menu and displays the message
	ld a, 1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld c, 50
	call DelayFrames
	call WaitForTextScrollButtonPress
	jr ItemUseMedicine.done
ItemUseMedicine.canceledItemUse
	xor a
	ld [wActionResultOrTookBattleTurn], a ; item use failed
	pop af
	pop af
ItemUseMedicine.done
	ld a, [wPseudoItemID]
	and a ; using Softboiled?
	ret nz ; if so, return
	call GBPalWhiteOut
	call z, RunDefaultPaletteCommand
	ld a, [wIsInBattle]
	and a
	ret nz
	jp ReloadMapData
ItemUseMedicine.useVitamin
	push hl
	ld a, [hl]
	ld [wCurSpecies], a
	ld [wPokedexNum], a
	ld bc, MON_LEVEL
	add hl, bc ; hl now points to level
	ld a, [hl] ; a = level
	ld [wCurEnemyLevel], a ; store level
	call GetMonHeader
	push de
	ld a, d
	ld hl, wPartyMonNicks
	call GetPartyMonName
	pop de
	pop hl
	ld a, [wCurItem]
	cp RARE_CANDY
	jp z, ItemUseMedicine.useRareCandy
	push hl
	sub HP_UP
	add a
	ld bc, MON_HP_EXP
	add hl, bc
	add l
	ld l, a
	jr nc, ItemUseMedicine.noCarry2
	inc h
ItemUseMedicine.noCarry2
	ld a, 10
	ld b, a
	ld a, [hl] ; a = MSB of stat experience of the appropriate stat
	cp 100 ; is there already at least 25600 (256 * 100) stat experience?
	jr nc, ItemUseMedicine.vitaminNoEffect ; if so, vitamins can't add any more
	add b ; add 2560 (256 * 10) stat experience
	jr nc, ItemUseMedicine.noCarry3 ; a carry should be impossible here, so this will always jump
	ld a, 255
ItemUseMedicine.noCarry3
	ld [hl], a
	pop hl
	call ItemUseMedicine.recalculateStats
	ld hl, VitaminStats
	ld a, [wCurItem]
	sub HP_UP - 1
	ld c, a
ItemUseMedicine.statNameLoop ; loop to get the address of the name of the stat the vitamin increases
	dec c
	jr z, ItemUseMedicine.gotStatName
ItemUseMedicine.statNameInnerLoop
	ld a, [hli]
	ld b, a
	ld a, $50
	cp b
	jr nz, ItemUseMedicine.statNameInnerLoop
	jr ItemUseMedicine.statNameLoop
ItemUseMedicine.gotStatName
	ld de, wStringBuffer
	ld bc, STAT_NAME_LENGTH
	call CopyData ; copy the stat's name to wStringBuffer
	ld a, SFX_HEAL_AILMENT
	call PlaySound
	ld hl, VitaminStatRoseText
	call PrintText
	jp RemoveUsedItem
ItemUseMedicine.vitaminNoEffect
	pop hl
	ld hl, VitaminNoEffectText
	call PrintText
	jp GBPalWhiteOut
ItemUseMedicine.recalculateStats
	ld bc, MON_STATS
	add hl, bc
	ld d, h
	ld e, l ; de now points to stats
	ld bc, (MON_EXP + 2) - MON_STATS
	add hl, bc ; hl now points to LSB of experience
	ld b, 1
	jp CalcStats ; recalculate stats
ItemUseMedicine.useRareCandy
	push hl
	ld bc, MON_LEVEL
	add hl, bc ; hl now points to level
	ld a, [hl] ; a = level
	cp MAX_LEVEL
	jr z, ItemUseMedicine.vitaminNoEffect ; can't raise level above 100
	inc a
	ld [hl], a ; store incremented level
	ld [wCurEnemyLevel], a
	push hl
	push de
	ld d, a
	callfar CalcExperience ; calculate experience for next level and store it at hExperience
	pop de
	pop hl
	ld bc, MON_EXP - MON_LEVEL
	add hl, bc ; hl now points to MSB of experience
; update experience to minimum for new level
	ldh a, [lobyte(hExperience)]
	ld [hli], a
	ldh a, [lobyte(hExperience + 1)]
	ld [hli], a
	ldh a, [lobyte(hExperience + 2)]
	ld [hl], a
	pop hl
	ld a, [wWhichPokemon]
	push af
	ld a, [wCurItem]
	push af
	push de
	push hl
	ld bc, MON_MAXHP
	add hl, bc ; hl now points to MSB of max HP
	ld a, [hli]
	ld b, a
	ld c, [hl]
	pop hl
	push bc
	push hl
	call ItemUseMedicine.recalculateStats
	pop hl
	ld bc, (MON_MAXHP + 1)
	add hl, bc ; hl now points to LSB of max HP
	pop bc
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a ; bc = the amount of max HP gained from leveling up
; add the amount gained to the current HP
	ld de, (MON_HP + 1) - MON_MAXHP
	add hl, de ; hl now points to LSB of current HP
	ld a, [hl]
	add c
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a
	ld a, RARE_CANDY_MSG
	ld [wPartyMenuTypeOrMessageID], a
	call RedrawPartyMenu
	pop de
	ld a, d
	ld [wWhichPokemon], a
	ld a, e
	ld [wPokedexNum], a
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	call LoadMonData
	ld d, LEVEL_UP_STATS_BOX
	callfar PrintStatsBox
	call WaitForTextScrollButtonPress
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	predef LearnMoveFromLevelUp
	xor a
	ld [wForceEvolution], a
	callfar TryEvolvingMon
	ld a, $01
	ld [wUpdateSpritesEnabled], a
	pop af
	ld [wCurItem], a
	pop af
	ld [wWhichPokemon], a
	jp RemoveUsedItem

VitaminStatRoseText:
	text_far WLA_GLOBAL_VitaminStatRoseText
	text_end

VitaminNoEffectText:
	text_far WLA_GLOBAL_VitaminNoEffectText
	text_end

.INCLUDE "data/battle/stat_names.asm"

; for BOULDERBADGE when used from the
; ITEM window, which corresponds to
; SAFARI_BAIT during Safari Game encounters
ItemUseBait:
	ld hl, ThrewBaitText
	call PrintText
	ld hl, wEnemyMonActualCatchRate
	srl [hl] ; halve catch rate
	ld a, BAIT_ANIM
	ld hl, wSafariBaitFactor
	ld de, wSafariEscapeFactor
	jr BaitRockCommon

; for CASCADEBADGE when used from the
; ITEM window, which corresponds to
; SAFARI_ROCK during Safari Game encounters
ItemUseRock:
	ld hl, ThrewRockText
	call PrintText
	ld hl, wEnemyMonActualCatchRate
	ld a, [hl]
	add a ; double catch rate
	jr nc, ItemUseRock.noCarry
	ld a, $ff
ItemUseRock.noCarry
	ld [hl], a
	ld a, ROCK_ANIM
	ld hl, wSafariEscapeFactor
	ld de, wSafariBaitFactor

BaitRockCommon:
	ld [wAnimationID], a
	xor a
	ld [wAnimationType], a
	ldh [lobyte(hWhoseTurn)], a
	ld [de], a ; zero escape factor (for bait), zero bait factor (for rock)
BaitRockCommon.randomLoop ; loop until a random number less than 5 is generated
	call Random
	and 7
	cp 5
	jr nc, BaitRockCommon.randomLoop
	inc a ; increment the random number, giving a range from 1 to 5 inclusive
	ld b, a
	ld a, [hl]
	add b ; increase bait factor (for bait), increase escape factor (for rock)
	jr nc, BaitRockCommon.noCarry
	ld a, $ff
BaitRockCommon.noCarry
	ld [hl], a
	predef MoveAnimation ; do animation
	ld c, 70
	jp DelayFrames

ThrewBaitText:
	text_far WLA_GLOBAL_ThrewBaitText
	text_end

ThrewRockText:
	text_far WLA_GLOBAL_ThrewRockText
	text_end

; indirectly used by DIG in StartMenu_Pokemon.dig
ItemUseEscapeRope:
	ld a, [wIsInBattle]
	and a
	jr nz, ItemUseEscapeRope.notUsable
	ld a, [wCurMap]
	cp AGATHAS_ROOM
	jr z, ItemUseEscapeRope.notUsable
	ld a, [wCurMapTileset]
	ld b, a
	ld hl, EscapeRopeTilesets
ItemUseEscapeRope.loop
	ld a, [hli]
	cp $ff
	jr z, ItemUseEscapeRope.notUsable
	cp b
	jr nz, ItemUseEscapeRope.loop
	ld hl, wStatusFlags6
	set BIT_FLY_WARP, [hl]
	set BIT_ESCAPE_WARP, [hl]
	ld hl, wStatusFlags4
	res BIT_NO_BATTLES, [hl]
	ResetEvent EVENT_IN_SAFARI_ZONE
	xor a
	ld [wNumSafariBalls], a
	ld [wSafariZoneGateCurScript], a ; SCRIPT_SAFARIZONEGATE_DEFAULT
	inc a
	ld [wEscapedFromBattle], a
	ld [wActionResultOrTookBattleTurn], a ; item used
	ld a, [wPseudoItemID]
	and a ; using Dig?
	ret nz ; if so, return
	call ItemUseReloadOverworldData
	ld c, 30
	call DelayFrames
	jp RemoveUsedItem
ItemUseEscapeRope.notUsable
	jp ItemUseNotTime

.INCLUDE "data/tilesets/escape_rope_tilesets.asm"

ItemUseRepel:
	ld b, 100

ItemUseRepelCommon:
	ld a, [wIsInBattle]
	and a
	jp nz, ItemUseNotTime
	ld a, b
	ld [wRepelRemainingSteps], a
	jp PrintItemUseTextAndRemoveItem

; handles X Accuracy item
ItemUseXAccuracy:
	ld a, [wIsInBattle]
	and a
	jp z, ItemUseNotTime
	ld hl, wPlayerBattleStatus2
	set USING_X_ACCURACY, [hl] ; X Accuracy bit
	jp PrintItemUseTextAndRemoveItem

; This function is bugged and never works. It always jumps to ItemUseNotTime.
; The Card Key is handled in a different way.
ItemUseCardKey:
	xor a
	ld [wUnusedCardKeyGateID], a
	call GetTileAndCoordsInFrontOfPlayer
	ld a, [GetTileAndCoordsInFrontOfPlayer]
	cp $18
	jr nz, ItemUseCardKey.next0
	ld hl, CardKeyTable1
	jr ItemUseCardKey.next1
ItemUseCardKey.next0
	cp $24
	jr nz, ItemUseCardKey.next2
	ld hl, CardKeyTable2
	jr ItemUseCardKey.next1
ItemUseCardKey.next2
	cp $5e
	jp nz, ItemUseNotTime
	ld hl, CardKeyTable3
ItemUseCardKey.next1
	ld a, [wCurMap]
	ld b, a
ItemUseCardKey.loop
	ld a, [hli]
	cp -1
	jp z, ItemUseNotTime
	cp b
	jr nz, ItemUseCardKey.nextEntry1
	ld a, [hli]
	cp d
	jr nz, ItemUseCardKey.nextEntry2
	ld a, [hli]
	cp e
	jr nz, ItemUseCardKey.nextEntry3
	ld a, [hl]
	ld [wUnusedCardKeyGateID], a
	jr ItemUseCardKey.done
ItemUseCardKey.nextEntry1
	inc hl
ItemUseCardKey.nextEntry2
	inc hl
ItemUseCardKey.nextEntry3
	inc hl
	jr ItemUseCardKey.loop
ItemUseCardKey.done
	ld hl, ItemUseText00
	call PrintText
	ld hl, wStatusFlags1
	set BIT_UNUSED_CARD_KEY, [hl] ; never checked
	ret

.INCLUDE "data/events/card_key_coords.asm"

ItemUsePokeDoll:
	ld a, [wIsInBattle]
	dec a
	jp nz, ItemUseNotTime
	ld a, $01
	ld [wEscapedFromBattle], a
	jp PrintItemUseTextAndRemoveItem

ItemUseGuardSpec:
	ld a, [wIsInBattle]
	and a
	jp z, ItemUseNotTime
	ld hl, wPlayerBattleStatus2
	set PROTECTED_BY_MIST, [hl] ; Mist bit
	jp PrintItemUseTextAndRemoveItem

ItemUseSuperRepel:
	ld b, 200
	jp ItemUseRepelCommon

ItemUseMaxRepel:
	ld b, 250
	jp ItemUseRepelCommon

ItemUseDireHit:
	ld a, [wIsInBattle]
	and a
	jp z, ItemUseNotTime
	ld hl, wPlayerBattleStatus2
	set GETTING_PUMPED, [hl] ; Focus Energy bit
	jp PrintItemUseTextAndRemoveItem

ItemUseXStat:
	ld a, [wIsInBattle]
	and a
	jr nz, ItemUseXStat.inBattle
	call ItemUseNotTime
	ld a, 2
	ld [wActionResultOrTookBattleTurn], a ; item not used
	ret
ItemUseXStat.inBattle
	ld hl, wPlayerMoveNum
	ld a, [hli]
	push af ; save [wPlayerMoveNum]
	ld a, [hl]
	push af ; save [wPlayerMoveEffect]
	push hl
	ld a, [wCurItem]
	sub X_ATTACK - ATTACK_UP1_EFFECT
	ld [hl], a ; store player move effect
	call PrintItemUseTextAndRemoveItem
	ld a, XSTATITEM_ANIM ; X stat item animation ID
	ld [wPlayerMoveNum], a
	call LoadScreenTilesFromBuffer1 ; restore saved screen
	call Delay3
	xor a
	ldh [lobyte(hWhoseTurn)], a ; set turn to player's turn
	farcall StatModifierUpEffect ; do stat increase move
	pop hl
	pop af
	ld [hld], a ; restore [wPlayerMoveEffect]
	pop af
	ld [hl], a ; restore [wPlayerMoveNum]
	ret

ItemUsePokeFlute:
	ld a, [wIsInBattle]
	and a
	jr nz, ItemUsePokeFlute.inBattle
; if not in battle
	call ItemUseReloadOverworldData
	ld a, [wCurMap]
	cp ROUTE_12
	jr nz, ItemUsePokeFlute.notRoute12
	CheckEvent EVENT_BEAT_ROUTE12_SNORLAX
	jr nz, ItemUsePokeFlute.noSnorlaxToWakeUp
; if the player hasn't beaten Route 12 Snorlax
	ld hl, Route12SnorlaxFluteCoords
	call ArePlayerCoordsInArray
	jr nc, ItemUsePokeFlute.noSnorlaxToWakeUp
	ld hl, PlayedFluteHadEffectText
	call PrintText
	SetEvent EVENT_FIGHT_ROUTE12_SNORLAX
	ret
ItemUsePokeFlute.notRoute12
	cp ROUTE_16
	jr nz, ItemUsePokeFlute.noSnorlaxToWakeUp
	CheckEvent EVENT_BEAT_ROUTE16_SNORLAX
	jr nz, ItemUsePokeFlute.noSnorlaxToWakeUp
; if the player hasn't beaten Route 16 Snorlax
	ld hl, Route16SnorlaxFluteCoords
	call ArePlayerCoordsInArray
	jr nc, ItemUsePokeFlute.noSnorlaxToWakeUp
	ld hl, PlayedFluteHadEffectText
	call PrintText
	SetEvent EVENT_FIGHT_ROUTE16_SNORLAX
	ret
ItemUsePokeFlute.noSnorlaxToWakeUp
	ld hl, PlayedFluteNoEffectText
	jp PrintText
ItemUsePokeFlute.inBattle
	xor a
	ld [wWereAnyMonsAsleep], a
	ld b, ~SLP_MASK
	ld hl, wPartyMon1Status
	call WakeUpEntireParty
	ld a, [wIsInBattle]
	dec a ; is it a trainer battle?
	jr z, ItemUsePokeFlute.skipWakingUpEnemyParty
; if it's a trainer battle
	ld hl, wEnemyMon1Status
	call WakeUpEntireParty
ItemUsePokeFlute.skipWakingUpEnemyParty
	ld hl, wBattleMonStatus
	ld a, [hl]
	and b ; remove Sleep status
	ld [hl], a
	ld hl, wEnemyMonStatus
	ld a, [hl]
	and b ; remove Sleep status
	ld [hl], a
	call LoadScreenTilesFromBuffer2 ; restore saved screen
	ld a, [wWereAnyMonsAsleep]
	and a ; were any pokemon asleep before playing the flute?
	ld hl, PlayedFluteNoEffectText
	jp z, PrintText ; if no pokemon were asleep
; if some pokemon were asleep
	ld hl, PlayedFluteHadEffectText
	call PrintText
	ld a, [wLowHealthAlarm]
	and $80
	jr nz, ItemUsePokeFlute.skipMusic
	call WaitForSoundToFinish ; wait for sound to end
	farcall Music_PokeFluteInBattle ; play in-battle pokeflute music
ItemUsePokeFlute.musicWaitLoop ; wait for music to finish playing
	ld a, [wChannelSoundIDs + CHAN7]
	and a ; music off?
	jr nz, ItemUsePokeFlute.musicWaitLoop
ItemUsePokeFlute.skipMusic
	ld hl, FluteWokeUpText
	jp PrintText

; wakes up all party pokemon
; INPUT:
; hl must point to status of first pokemon in party (player's or enemy's)
; b must equal ~SLP
; [wWereAnyMonsAsleep] should be initialized to 0
; OUTPUT:
; [wWereAnyMonsAsleep]: set to 1 if any pokemon were asleep
WakeUpEntireParty:
	ld de, PARTYMON_STRUCT_LENGTH
	ld c, PARTY_LENGTH
WakeUpEntireParty.loop
	ld a, [hl]
	push af
	and SLP_MASK
	jr z, WakeUpEntireParty.notAsleep
	ld a, 1
	ld [wWereAnyMonsAsleep], a ; indicate that a pokemon had to be woken up
WakeUpEntireParty.notAsleep
	pop af
	and b ; remove Sleep status
	ld [hl], a
	add hl, de
	dec c
	jr nz, WakeUpEntireParty.loop
	ret

Route12SnorlaxFluteCoords:
	dbmapcoord  9, 62 ; one space West of Snorlax
	dbmapcoord 10, 61 ; one space North of Snorlax
	dbmapcoord 10, 63 ; one space South of Snorlax
	dbmapcoord 11, 62 ; one space East of Snorlax
	.DB -1 ; end

Route16SnorlaxFluteCoords:
	dbmapcoord 27, 10 ; one space East of Snorlax
	dbmapcoord 25, 10 ; one space West of Snorlax
	.DB -1 ; end

PlayedFluteNoEffectText:
	text_far WLA_GLOBAL_PlayedFluteNoEffectText
	text_end

FluteWokeUpText:
	text_far WLA_GLOBAL_FluteWokeUpText
	text_end

PlayedFluteHadEffectText:
	text_far WLA_GLOBAL_PlayedFluteHadEffectText
	text_promptbutton
	text_asm
	ld a, [wIsInBattle]
	and a
	jr nz, PlayedFluteHadEffectText.done
; play out-of-battle pokeflute music
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
	ld a, SFX_POKEFLUTE
	ld c, bank(SFX_Pokeflute)
	call PlayMusic
PlayedFluteHadEffectText.musicWaitLoop ; wait for music to finish playing
	ld a, [wChannelSoundIDs + CHAN3]
	cp SFX_POKEFLUTE
	jr z, PlayedFluteHadEffectText.musicWaitLoop
	call PlayDefaultMusic ; start playing normal music again
PlayedFluteHadEffectText.done
	jp TextScriptEnd ; end text

ItemUseCoinCase:
	ld a, [wIsInBattle]
	and a
	jp nz, ItemUseNotTime
	ld hl, CoinCaseNumCoinsText
	jp PrintText

CoinCaseNumCoinsText:
	text_far WLA_GLOBAL_CoinCaseNumCoinsText
	text_end

ItemUseOldRod:
	call FishingInit
	jp c, ItemUseNotTime
	lb "bc", 5, MAGIKARP
	ld a, $1 ; set bite
	jr RodResponse

ItemUseGoodRod:
	call FishingInit
	jp c, ItemUseNotTime
ItemUseGoodRod.RandomLoop
	call Random
	srl a
	jr c, ItemUseGoodRod.SetBite
	and %11
	cp 2
	jr nc, ItemUseGoodRod.RandomLoop
	; choose which monster appears
	ld hl, GoodRodMons
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	inc hl
	ld c, [hl]
	and a
ItemUseGoodRod.SetBite
	ld a, 0
	rla
	xor 1
	jr RodResponse

.INCLUDE "data/wild/good_rod.asm"

ItemUseSuperRod:
	call FishingInit
	jp c, ItemUseNotTime
	call ReadSuperRodData
	ld a, e
RodResponse:
	ld [wRodResponse], a

	dec a ; is there a bite?
	jr nz, RodResponse.next
	; if yes, store level and species data
	ld a, 1
	ld [wMoveMissed], a
	ld a, b ; level
	ld [wCurEnemyLevel], a
	ld a, c ; species
	ld [wCurOpponent], a

RodResponse.next
	ld hl, wWalkBikeSurfState
	ld a, [hl] ; store the value in a
	push af
	push hl
	ld [hl], 0
	farcall FishingAnim
	pop hl
	pop af
	ld [hl], a
	ret

; checks if fishing is possible and if so, runs initialization code common to all rods
; unsets carry if fishing is possible, sets carry if not
FishingInit:
	ld a, [wIsInBattle]
	and a
	jr z, FishingInit.notInBattle
	scf ; can't fish during battle
	ret
FishingInit.notInBattle
	call IsNextTileShoreOrWater
	ret c
	ld a, [wWalkBikeSurfState]
	cp 2 ; Surfing?
	jr z, FishingInit.surfing
	call ItemUseReloadOverworldData
	ld hl, ItemUseText00
	call PrintText
	ld a, SFX_HEAL_AILMENT
	call PlaySound
	ld c, 80
	call DelayFrames
	and a
	ret
FishingInit.surfing
	scf ; can't fish when surfing
	ret

ItemUseOaksParcel:
	jp ItemUseNotYoursToUse

ItemUseItemfinder:
	ld a, [wIsInBattle]
	and a
	jp nz, ItemUseNotTime
	call ItemUseReloadOverworldData
	farcall HiddenItemNear ; check for hidden items
	ld hl, ItemfinderFoundNothingText
	jr nc, ItemUseItemfinder.printText ; if no hidden items
	ld c, 4
ItemUseItemfinder.loop
	ld a, SFX_HEALING_MACHINE
	call PlaySoundWaitForCurrent
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	dec c
	jr nz, ItemUseItemfinder.loop
	ld hl, ItemfinderFoundItemText
ItemUseItemfinder.printText
	jp PrintText

ItemfinderFoundItemText:
	text_far WLA_GLOBAL_ItemfinderFoundItemText
	text_end

ItemfinderFoundNothingText:
	text_far WLA_GLOBAL_ItemfinderFoundNothingText
	text_end

ItemUsePPUp:
	ld a, [wIsInBattle]
	and a
	jp nz, ItemUseNotTime

ItemUsePPRestore:
	ld a, [wWhichPokemon]
	push af
	ld a, [wCurItem]
	ld [wPPRestoreItem], a
ItemUsePPRestore.chooseMon
	xor a
	ld [wUpdateSpritesEnabled], a
	ld a, USE_ITEM_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call DisplayPartyMenu
	jr nc, ItemUsePPRestore.chooseMove
	jp ItemUsePPRestore.itemNotUsed
ItemUsePPRestore.chooseMove
	ld a, [wPPRestoreItem]
	cp ELIXER
	jp nc, ItemUsePPRestore.useElixir ; if Elixir or Max Elixir
	ld a, $02
	ld [wMoveMenuType], a
	ld hl, RaisePPWhichTechniqueText
	ld a, [wPPRestoreItem]
	cp ETHER ; is it a PP Up?
	jr c, ItemUsePPRestore.printWhichTechniqueMessage ; if so, print the raise PP message
	ld hl, RestorePPWhichTechniqueText ; otherwise, print the restore PP message
ItemUsePPRestore.printWhichTechniqueMessage
	call PrintText
	xor a
	ld [wPlayerMoveListIndex], a
	callfar MoveSelectionMenu ; move selection menu
	ld a, 0
	ld [wPlayerMoveListIndex], a
	jr nz, ItemUsePPRestore.chooseMon
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call GetSelectedMoveOffset
	push hl
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetMoveName
	call CopyToStringBuffer
	pop hl
	ld a, [wPPRestoreItem]
	cp ETHER
	jr nc, ItemUsePPRestore.useEther ; if Ether or Max Ether
; use PP Up
	ld bc, MON_PP - MON_MOVES
	add hl, bc
	ld a, [hl] ; move PP
	cp 3 << 6 ; have 3 PP Ups already been used?
	jr c, ItemUsePPRestore.PPNotMaxedOut
	ld hl, PPMaxedOutText
	call PrintText
	jr ItemUsePPRestore.chooseMove
ItemUsePPRestore.PPNotMaxedOut
	ld a, [hl]
	add 1 << 6 ; increase PP Up count by 1
	ld [hl], a
	ld a, 1 ; 1 PP Up used
	ld [wUsingPPUp], a
	call RestoreBonusPP ; add the bonus PP to current PP
	ld hl, PPIncreasedText
	call PrintText
ItemUsePPRestore.done
	pop af
	ld [wWhichPokemon], a
	call GBPalWhiteOut
	call RunDefaultPaletteCommand
	jp RemoveUsedItem
ItemUsePPRestore.afterRestoringPP ; after using a (Max) Ether/Elixir
	ld a, [wWhichPokemon]
	ld b, a
	ld a, [wPlayerMonNumber]
	cp b ; is the pokemon whose PP was restored active in battle?
	jr nz, ItemUsePPRestore.skipUpdatingInBattleData
	ld hl, wPartyMon1PP
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld de, wBattleMonPP
	ld bc, NUM_MOVES
	call CopyData ; copy party data to in-battle data
ItemUsePPRestore.skipUpdatingInBattleData
	ld a, SFX_HEAL_AILMENT
	call PlaySound
	ld hl, PPRestoredText
	call PrintText
	jr ItemUsePPRestore.done
ItemUsePPRestore.useEther
	call ItemUsePPRestore.restorePP
	jr nz, ItemUsePPRestore.afterRestoringPP
	jp ItemUsePPRestore.noEffect
; unsets zero flag if PP was restored, sets zero flag if not
; however, this is bugged for Max Ethers and Max Elixirs (see below)
ItemUsePPRestore.restorePP
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	call GetMaxPP
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call GetSelectedMoveOffset
	ld bc, MON_PP - MON_MOVES
	add hl, bc ; hl now points to move's PP
	ld a, [wMaxPP]
	ld b, a
	ld a, [wPPRestoreItem]
	cp MAX_ETHER
	jr z, ItemUsePPRestore.fullyRestorePP
	ld a, [hl] ; move PP
	and PP_MASK
	cp b ; does current PP equal max PP?
	ret z ; if so, return
	add 10 ; increase current PP by 10
; b holds the max PP amount and b will hold the new PP amount.
; So, if the new amount meets or exceeds the max amount,
; cap the amount to the max amount by leaving b unchanged.
; Otherwise, store the new amount in b.
	cp b ; does the new amount meet or exceed the maximum?
	jr nc, ItemUsePPRestore.storeNewAmount
	ld b, a
ItemUsePPRestore.storeNewAmount
	ld a, [hl] ; move PP
	and PP_UP_MASK
	add b
	ld [hl], a
	ret
ItemUsePPRestore.fullyRestorePP
	ld a, [hl] ; move PP
; Bug: This code doesn't mask out the upper two bits, which are used to count
; how many PP Ups have been used on the move.
; So, Max Ethers and Max Elixirs will not be detected as having no effect on
; a move with full PP if the move has had any PP Ups used on it.
	cp b ; does current PP equal max PP?
	ret z
	jr ItemUsePPRestore.storeNewAmount
ItemUsePPRestore.useElixir
; decrement the item ID so that ELIXER becomes ETHER and MAX_ELIXER becomes MAX_ETHER
	ld hl, wPPRestoreItem
	dec [hl]
	dec [hl]
	xor a
	ld hl, wCurrentMenuItem
	ld [hli], a
	ld [hl], a ; zero the counter for number of moves that had their PP restored
	ld b, 4
; loop through each move and restore PP
ItemUsePPRestore.elixirLoop
	push bc
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call GetSelectedMoveOffset
	ld a, [hl]
	and a ; does the current slot have a move?
	jr z, ItemUsePPRestore.nextMove
	call ItemUsePPRestore.restorePP
	jr z, ItemUsePPRestore.nextMove
; if some PP was restored
	ld hl, wTileBehindCursor ; counter for number of moves that had their PP restored
	inc [hl]
ItemUsePPRestore.nextMove
	ld hl, wCurrentMenuItem
	inc [hl]
	pop bc
	dec b
	jr nz, ItemUsePPRestore.elixirLoop
	ld a, [wTileBehindCursor]
	and a ; did any moves have their PP restored?
	jp nz, ItemUsePPRestore.afterRestoringPP
ItemUsePPRestore.noEffect
	call ItemUseNoEffect
ItemUsePPRestore.itemNotUsed
	call GBPalWhiteOut
	call RunDefaultPaletteCommand
	pop af
	xor a
	ld [wActionResultOrTookBattleTurn], a ; item use failed
	ret

RaisePPWhichTechniqueText:
	text_far WLA_GLOBAL_RaisePPWhichTechniqueText
	text_end

RestorePPWhichTechniqueText:
	text_far WLA_GLOBAL_RestorePPWhichTechniqueText
	text_end

PPMaxedOutText:
	text_far WLA_GLOBAL_PPMaxedOutText
	text_end

PPIncreasedText:
	text_far WLA_GLOBAL_PPIncreasedText
	text_end

PPRestoredText:
	text_far WLA_GLOBAL_PPRestoredText
	text_end

; for items that can't be used from the Item menu
UnusableItem:
	jp ItemUseNotTime

ItemUseTMHM:
	ld a, [wIsInBattle]
	and a
	jp nz, ItemUseNotTime
	ld a, [wCurItem]
	sub TM01 ; underflows below 0 for HM items (before TM items)
	push af
	jr nc, ItemUseTMHM.skipAdding
	add NUM_TMS + NUM_HMS ; adjust HM IDs to come after TM IDs
ItemUseTMHM.skipAdding
	inc a
	ld [wTempTMHM], a
	predef TMToMove ; get move ID from TM/HM ID
	ld a, [wTempTMHM]
	ld [wMoveNum], a
	call GetMoveName
	call CopyToStringBuffer
	pop af
	ld hl, BootedUpTMText
	jr nc, ItemUseTMHM.printBootedUpMachineText
	ld hl, BootedUpHMText
ItemUseTMHM.printBootedUpMachineText
	call PrintText
	ld hl, TeachMachineMoveText
	call PrintText
	hlcoord 14, 7
	lb "bc", 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr z, ItemUseTMHM.useMachine
	ld a, 2
	ld [wActionResultOrTookBattleTurn], a ; item not used
	ret
ItemUseTMHM.useMachine
	ld a, [wWhichPokemon]
	push af
	ld a, [wCurItem]
	push af
ItemUseTMHM.chooseMon
	ld hl, wStringBuffer
	ld de, wTempMoveNameBuffer
	ld bc, MOVE_NAME_LENGTH
	call CopyData ; save the move name because DisplayPartyMenu will overwrite it
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, TMHM_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call DisplayPartyMenu
	push af
	ld hl, wTempMoveNameBuffer
	ld de, wStringBuffer
	ld bc, MOVE_NAME_LENGTH
	call CopyData
	pop af
	jr nc, ItemUseTMHM.checkIfAbleToLearnMove
; if the player canceled teaching the move
	pop af
	pop af
	call GBPalWhiteOutWithDelay3
	call ClearSprites
	call RunDefaultPaletteCommand
	jp LoadScreenTilesFromBuffer1 ; restore saved screen
ItemUseTMHM.checkIfAbleToLearnMove
	predef CanLearnTM ; check if the pokemon can learn the move
	push bc
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	pop bc
	ld a, c
	and a ; can the pokemon learn the move?
	jr nz, ItemUseTMHM.checkIfAlreadyLearnedMove
; if the pokemon can't learn the move
	ld a, SFX_DENIED
	call PlaySoundWaitForCurrent
	ld hl, MonCannotLearnMachineMoveText
	call PrintText
	jr ItemUseTMHM.chooseMon
ItemUseTMHM.checkIfAlreadyLearnedMove
	callfar CheckIfMoveIsKnown ; check if the pokemon already knows the move
	jr c, ItemUseTMHM.chooseMon
	predef LearnMove ; teach move
	pop af
	ld [wCurItem], a
	pop af
	ld [wWhichPokemon], a
	ld a, b
	and a
	ret z
	ld a, [wCurItem]
	call IsItemHM
	ret c
	jp RemoveUsedItem

BootedUpTMText:
	text_far WLA_GLOBAL_BootedUpTMText
	text_end

BootedUpHMText:
	text_far WLA_GLOBAL_BootedUpHMText
	text_end

TeachMachineMoveText:
	text_far WLA_GLOBAL_TeachMachineMoveText
	text_end

MonCannotLearnMachineMoveText:
	text_far WLA_GLOBAL_MonCannotLearnMachineMoveText
	text_end

PrintItemUseTextAndRemoveItem:
	ld hl, ItemUseText00
	call PrintText
	ld a, SFX_HEAL_AILMENT
	call PlaySound
	call WaitForTextScrollButtonPress ; wait for button press

RemoveUsedItem:
	ld hl, wNumBagItems
	ld a, 1 ; one item
	ld [wItemQuantity], a
	jp RemoveItemFromInventory

ItemUseNoEffect:
	ld hl, ItemUseNoEffectText
	jr ItemUseFailed

ItemUseNotTime:
	ld hl, ItemUseNotTimeText
	jr ItemUseFailed

ItemUseNotYoursToUse:
	ld hl, ItemUseNotYoursToUseText
	jr ItemUseFailed

ThrowBallAtTrainerMon:
	call RunDefaultPaletteCommand
	call LoadScreenTilesFromBuffer1 ; restore saved screen
	call Delay3
	ld a, TOSS_ANIM
	ld [wAnimationID], a
	predef MoveAnimation ; do animation
	ld hl, ThrowBallAtTrainerMonText1
	call PrintText
	ld hl, ThrowBallAtTrainerMonText2
	call PrintText
	jr RemoveUsedItem

NoCyclingAllowedHere:
	ld hl, NoCyclingAllowedHereText
	jr ItemUseFailed

BoxFullCannotThrowBall:
	ld hl, BoxFullCannotThrowBallText
	jr ItemUseFailed

SurfingAttemptFailed:
	ld hl, NoSurfingHereText

ItemUseFailed:
	xor a
	ld [wActionResultOrTookBattleTurn], a ; item use failed
	jp PrintText

ItemUseNotTimeText:
	text_far WLA_GLOBAL_ItemUseNotTimeText
	text_end

ItemUseNotYoursToUseText:
	text_far WLA_GLOBAL_ItemUseNotYoursToUseText
	text_end

ItemUseNoEffectText:
	text_far WLA_GLOBAL_ItemUseNoEffectText
	text_end

ThrowBallAtTrainerMonText1:
	text_far WLA_GLOBAL_ThrowBallAtTrainerMonText1
	text_end

ThrowBallAtTrainerMonText2:
	text_far WLA_GLOBAL_ThrowBallAtTrainerMonText2
	text_end

NoCyclingAllowedHereText:
	text_far WLA_GLOBAL_NoCyclingAllowedHereText
	text_end

NoSurfingHereText:
	text_far WLA_GLOBAL_NoSurfingHereText
	text_end

BoxFullCannotThrowBallText:
	text_far WLA_GLOBAL_BoxFullCannotThrowBallText
	text_end

ItemUseText00:
	text_far WLA_GLOBAL_ItemUseText001
	text_low
	text_far WLA_GLOBAL_ItemUseText002
	text_end

GotOnBicycleText:
	text_far WLA_GLOBAL_GotOnBicycleText1
	text_low
	text_far WLA_GLOBAL_GotOnBicycleText2
	text_end

GotOffBicycleText:
	text_far WLA_GLOBAL_GotOffBicycleText1
	text_low
	text_far WLA_GLOBAL_GotOffBicycleText2
	text_end

; restores bonus PP (from PP Ups) when healing at a pokemon center
; also, when a PP Up is used, it increases the current PP by one PP Up bonus
; INPUT:
; [wWhichPokemon] = index of pokemon in party
; [wCurrentMenuItem] = index of move (when using a PP Up)
RestoreBonusPP:
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	push hl
	ld de, wNormalMaxPPList - 1
	predef LoadMovePPs ; loads the normal max PP of each of the pokemon's moves to wNormalMaxPPList
	pop hl
	ld c, MON_PP - MON_MOVES
	ld b, 0
	add hl, bc ; hl now points to move 1 PP
	ld de, wNormalMaxPPList
	ld b, 0 ; initialize move counter to zero
; loop through the pokemon's moves
RestoreBonusPP.loop
	inc b
	ld a, b
	cp 5 ; reached the end of the pokemon's moves?
	ret z ; if so, return
	ld a, [wUsingPPUp]
	dec a ; using a PP Up?
	jr nz, RestoreBonusPP.skipMenuItemIDCheck
; if using a PP Up, check if this is the move it's being used on
	ld a, [wCurrentMenuItem]
	inc a
	cp b
	jr nz, RestoreBonusPP.nextMove
RestoreBonusPP.skipMenuItemIDCheck
	ld a, [hl]
	and PP_UP_MASK
	call nz, AddBonusPP ; if so, add bonus PP
RestoreBonusPP.nextMove
	inc hl
	inc de
	jr RestoreBonusPP.loop

; adds bonus PP from PP Ups to current PP
; 1/5 of normal max PP (capped at 7) is added for each PP Up
; INPUT:
; [de] = normal max PP
; [hl] = move PP
AddBonusPP:
	push bc
	ld a, [de] ; normal max PP of move
	ldh [lobyte(hDividend + 3)], a
	xor a
	ldh [lobyte(hDividend)], a
	ldh [lobyte(hDividend + 1)], a
	ldh [lobyte(hDividend + 2)], a
	ld a, 5
	ldh [lobyte(hDivisor)], a
	ld b, 4
	call Divide
	ld a, [hl] ; move PP
	ld b, a
	swap a
	and %00001111
	srl a
	srl a
	ld c, a ; c = number of PP Ups used
AddBonusPP.loop
	ldh a, [lobyte(hQuotient + 3)]
	cp 8 ; is the amount greater than or equal to 8?
	jr c, AddBonusPP.addAmount
	ld a, 7 ; cap the amount at 7
AddBonusPP.addAmount
	add b
	ld b, a
	ld a, [wUsingPPUp]
	dec a ; is the player using a PP Up right now?
	jr z, AddBonusPP.done ; if so, only add the bonus once
	dec c
	jr nz, AddBonusPP.loop
AddBonusPP.done
	ld [hl], b
	pop bc
	ret

; gets max PP of a pokemon's move (including PP from PP Ups)
; INPUT:
; [wWhichPokemon] = index of pokemon within party/box
; [wMonDataLocation] = pokemon source
; 00: player's party
; 01: enemy's party
; 02: current box
; 03: daycare
; 04: player's in-battle pokemon
; [wCurrentMenuItem] = move index
; OUTPUT:
; [wMaxPP] = max PP
GetMaxPP:
	ld a, [wMonDataLocation]
	and a
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	jr z, GetMaxPP.sourceWithMultipleMon
	ld hl, wEnemyMon1Moves
	dec a
	jr z, GetMaxPP.sourceWithMultipleMon
	ld hl, wBoxMon1Moves
	ld bc, BOXMON_STRUCT_LENGTH
	dec a
	jr z, GetMaxPP.sourceWithMultipleMon
	ld hl, wDayCareMonMoves
	dec a
	jr z, GetMaxPP.sourceWithOneMon
	ld hl, wBattleMonMoves ; player's in-battle pokemon
GetMaxPP.sourceWithOneMon
	call GetSelectedMoveOffset2
	jr GetMaxPP.next
GetMaxPP.sourceWithMultipleMon
	call GetSelectedMoveOffset
GetMaxPP.next
	ld a, [hl]
	dec a
	push hl
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wMoveData
	ld a, bank(Moves)
	call FarCopyData
	ld de, wMoveData + MOVE_PP
	ld a, [de]
	ld b, a ; b = normal max PP
	pop hl
	push bc
	ld bc, MON_PP - MON_MOVES ; PP offset if not player's in-battle pokemon data
	ld a, [wMonDataLocation]
	cp 4 ; player's in-battle pokemon?
	jr nz, GetMaxPP.addPPOffset
	ld bc, wBattleMonPP - wBattleMonMoves ; PP offset if player's in-battle pokemon data
GetMaxPP.addPPOffset
	add hl, bc
	ld a, [hl] ; a = current PP
	and PP_UP_MASK
	pop bc
	or b ; place normal max PP in 6 lower bits of a
	ld h, d
	ld l, e
	inc hl ; hl = wPPUpCountAndMaxPP
	ld [hl], a
	xor a ; add the bonus for the existing PP Up count
	ld [wUsingPPUp], a
	call AddBonusPP ; add bonus PP from PP Ups
	ld a, [hl]
	and PP_MASK
	ld [wMaxPP], a ; store max PP
	ret

GetSelectedMoveOffset:
	ld a, [wWhichPokemon]
	call AddNTimes

GetSelectedMoveOffset2:
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, 0
	add hl, bc
	ret

; confirms the item toss and then tosses the item
; INPUT:
; hl = address of inventory (either wNumBagItems or wNumBoxItems)
; [wCurItem] = item ID
; [wWhichPokemon] = index of item within inventory
; [wItemQuantity] = quantity to toss
; OUTPUT:
; clears carry flag if the item is tossed, sets carry flag if not
TossItem_:
	push hl
	ld a, [wCurItem]
	call IsItemHM
	pop hl
	jr c, TossItem_.tooImportantToToss
	push hl
	call IsKeyItem_
	ld a, [wIsKeyItem]
	pop hl
	and a
	jr nz, TossItem_.tooImportantToToss
	push hl
	ld a, [wCurItem]
	ld [wNamedObjectIndex], a
	call GetItemName
	call CopyToStringBuffer
	ld hl, IsItOKToTossItemText
	call PrintText
	hlcoord 14, 7
	lb "bc", 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID ; yes/no menu
	ld a, [wMenuExitMethod]
	cp CHOSE_SECOND_ITEM
	pop hl
	scf
	ret z ; return if the player chose No
; if the player chose Yes
	push hl
	ld a, [wWhichPokemon]
	call RemoveItemFromInventory
	ld a, [wCurItem]
	ld [wNamedObjectIndex], a
	call GetItemName
	call CopyToStringBuffer
	ld hl, ThrewAwayItemText
	call PrintText
	pop hl
	and a
	ret
TossItem_.tooImportantToToss
	push hl
	ld hl, TooImportantToTossText
	call PrintText
	pop hl
	scf
	ret

ThrewAwayItemText:
	text_far WLA_GLOBAL_ThrewAwayItemText
	text_end

IsItOKToTossItemText:
	text_far WLA_GLOBAL_IsItOKToTossItemText
	text_end

TooImportantToTossText:
	text_far WLA_GLOBAL_TooImportantToTossText
	text_end

; checks if an item is a key item
; INPUT:
; [wCurItem] = item ID
; OUTPUT:
; [wIsKeyItem] = result
; 00: item is not key item
; 01: item is key item
IsKeyItem_:
	ld a, $01
	ld [wIsKeyItem], a
	ld a, [wCurItem]
	cp HM01 ; is the item an HM or TM?
	jr nc, IsKeyItem_.checkIfItemIsHM
; if the item is not an HM or TM
	push af
	ld hl, KeyItemFlags
	ld de, wBuffer
	ld bc, 15 ; only 11 bytes are actually used
	.ASSERT 15 >= (NUM_ITEMS + 7) / 8
	call CopyData
	pop af
	dec a
	ld c, a
	ld hl, wBuffer
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	ret nz
IsKeyItem_.checkIfItemIsHM
	ld a, [wCurItem]
	call IsItemHM
	ret c
	xor a
	ld [wIsKeyItem], a
	ret

.INCLUDE "data/items/key_items.asm"

; store the new mon in the first slot, shifting all existing box data down
SendNewMonToBox:
	ld de, wBoxCount
	ld a, [de]
	inc a
	ld [de], a

	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	ld c, a
SendNewMonToBox.shiftSpeciesLoop
	inc de
	ld a, [de]
	ld b, a
	ld a, c
	ld c, b
	ld [de], a
	cp -1
	jr nz, SendNewMonToBox.shiftSpeciesLoop

	call GetMonHeader
	ld hl, wBoxMonOT
	ld bc, NAME_LENGTH
	ld a, [wBoxCount]
	dec a
	jr z, SendNewMonToBox.skipOTshift ; if the box was empty, there is nothing to shift

	dec a
	call AddNTimes
	push hl
	ld bc, NAME_LENGTH
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wBoxCount]
	dec a
	ld b, a
SendNewMonToBox.shiftMonOTLoop
	push bc
	push hl
	ld bc, NAME_LENGTH
	call CopyData
	pop hl
	ld d, h
	ld e, l
	ld bc, -NAME_LENGTH
	add hl, bc
	pop bc
	dec b
	jr nz, SendNewMonToBox.shiftMonOTLoop

SendNewMonToBox.skipOTshift
	ld hl, wPlayerName
	ld de, wBoxMon1OT
	ld bc, NAME_LENGTH
	call CopyData

	ld a, [wBoxCount]
	dec a
	jr z, SendNewMonToBox.skipNickShift

	ld hl, wBoxMonNicks
	ld bc, NAME_LENGTH
	dec a
	call AddNTimes
	push hl
	ld bc, NAME_LENGTH
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wBoxCount]
	dec a
	ld b, a
SendNewMonToBox.shiftNickLoop
	push bc
	push hl
	ld bc, NAME_LENGTH
	call CopyData
	pop hl
	ld d, h
	ld e, l
	ld bc, -NAME_LENGTH
	add hl, bc
	pop bc
	dec b
	jr nz, SendNewMonToBox.shiftNickLoop

SendNewMonToBox.skipNickShift
	ld hl, wBoxMon1Nick
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	predef AskName

	ld a, [wBoxCount]
	dec a
	jr z, SendNewMonToBox.skipMonDataShift

	ld hl, wBoxMons
	ld bc, BOXMON_STRUCT_LENGTH
	dec a
	call AddNTimes
	push hl
	ld bc, BOXMON_STRUCT_LENGTH
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wBoxCount]
	dec a
	ld b, a
SendNewMonToBox.shiftMonDataLoop
	push bc
	push hl
	ld bc, BOXMON_STRUCT_LENGTH
	call CopyData
	pop hl
	ld d, h
	ld e, l
	ld bc, -BOXMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	dec b
	jr nz, SendNewMonToBox.shiftMonDataLoop

SendNewMonToBox.skipMonDataShift
	ld a, [wEnemyMonLevel]
	ld [wEnemyMonBoxLevel], a
	ld hl, wEnemyMon
	ld de, wBoxMon1
	ld bc, wEnemyMonDVs - wEnemyMon
	call CopyData
	ld hl, wPlayerID
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	push de
	ld a, [wCurEnemyLevel]
	ld d, a
	callfar CalcExperience
	pop de
	ldh a, [lobyte(hExperience)]
	ld [de], a
	inc de
	ldh a, [lobyte(hExperience + 1)]
	ld [de], a
	inc de
	ldh a, [lobyte(hExperience + 2)]
	ld [de], a
	inc de
	xor a
	ld b, NUM_STATS * 2
SendNewMonToBox.statLoop
	ld [de], a
	inc de
	dec b
	jr nz, SendNewMonToBox.statLoop

	ld hl, wEnemyMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld hl, wEnemyMonPP
	ld b, NUM_MOVES
SendNewMonToBox.movePPLoop
	ld a, [hli]
	inc de
	ld [de], a
	dec b
	jr nz, SendNewMonToBox.movePPLoop
	ret

; checks if the tile in front of the player is a shore or water tile
; used for surfing and fishing
; unsets carry if it is, sets carry if not
IsNextTileShoreOrWater:
	ld a, [wCurMapTileset]
	ld hl, WaterTilesets
	ld de, 1
	call IsInArray
	jr nc, IsNextTileShoreOrWater.notShoreOrWater
	ld a, [wCurMapTileset]
	cp SHIP_PORT ; Vermilion Dock tileset
	ld a, [wTileInFrontOfPlayer] ; tile in front of player
	jr z, IsNextTileShoreOrWater.skipShoreTiles ; if it's the Vermilion Dock tileset
	cp $48 ; eastern shore tile in Safari Zone
	jr z, IsNextTileShoreOrWater.shoreOrWater
	cp $32 ; usual eastern shore tile
	jr z, IsNextTileShoreOrWater.shoreOrWater
IsNextTileShoreOrWater.skipShoreTiles
	cp $14 ; water tile
	jr z, IsNextTileShoreOrWater.shoreOrWater
IsNextTileShoreOrWater.notShoreOrWater
	scf
	ret
IsNextTileShoreOrWater.shoreOrWater
	and a
	ret

.INCLUDE "data/tilesets/water_tilesets.asm"

ReadSuperRodData:
; return e = 2 if no fish on this map
; return e = 1 if a bite, bc = level,species
; return e = 0 if no bite
	ld a, [wCurMap]
	ld de, 3 ; each fishing group is three bytes wide
	ld hl, SuperRodData
	call IsInArray
	jr c, ReadSuperRodData.ReadFishingGroup
	ld e, $2 ; $2 if no fishing groups found
	ret

ReadSuperRodData.ReadFishingGroup
; hl points to the fishing group entry in the index
	inc hl ; skip map id

	; read fishing group address
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld b, [hl] ; how many mons in group
	inc hl ; point to data
	ld e, $0 ; no bite yet

ReadSuperRodData.RandomLoop
	call Random
	srl a
	ret c ; 50% chance of no battle

	and %11 ; 2-bit random number
	cp b
	jr nc, ReadSuperRodData.RandomLoop ; if a is greater than the number of mons, regenerate

	; get the mon
	add a
	ld c, a
	ld b, $0
	add hl, bc
	ld b, [hl] ; level
	inc hl
	ld c, [hl] ; species
	ld e, $1 ; $1 if there's a bite
	ret

.INCLUDE "data/wild/super_rod.asm"

; reloads map view and processes sprite data
; for items that cause the overworld to be displayed
ItemUseReloadOverworldData:
	call LoadCurrentMapView
	jp UpdateSprites

; creates a list at wBuffer of maps where the mon in [wPokedexNum] can be found.
; this is used by the pokedex to display locations the mon can be found on the map.
FindWildLocationsOfMon:
	ld hl, WildDataPointers
	ld de, wBuffer
	ld c, $0
FindWildLocationsOfMon.loop
	inc hl
	ld a, [hld]
	inc a
	jr z, FindWildLocationsOfMon.done
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	and a
	call nz, CheckMapForMon ; land
	ld a, [hli]
	and a
	call nz, CheckMapForMon ; water
	pop hl
	inc hl
	inc hl
	inc c
	jr FindWildLocationsOfMon.loop
FindWildLocationsOfMon.done
	ld a, $ff ; list terminator
	ld [de], a
	ret

CheckMapForMon:
	inc hl
	ld b, NUM_WILDMONS
CheckMapForMon.loop
	ld a, [wPokedexNum]
	cp [hl]
	jr nz, CheckMapForMon.nextEntry
	ld a, c
	ld [de], a
	inc de
CheckMapForMon.nextEntry
	inc hl
	inc hl
	dec b
	jr nz, CheckMapForMon.loop
	dec hl
	ret
