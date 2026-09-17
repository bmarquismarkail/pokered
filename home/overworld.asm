HandleMidJump:
; Handle the player jumping down
; a ledge in the overworld.
	farjp HandleMidJumpFar

EnterMap:
; Load a new map.
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	call LoadMapData
	farcall ClearVariablesOnEnterMap
	ld hl, wStatusFlags2
	bit BIT_WILD_ENCOUNTER_COOLDOWN, [hl]
	jr z, EnterMap.skipGivingThreeStepsOfNoRandomBattles
	ld a, 3 ; minimum number of steps between battles
	ld [wNumberOfNoRandomBattleStepsLeft], a
EnterMap.skipGivingThreeStepsOfNoRandomBattles
	ld hl, wStatusFlags4
	bit BIT_BATTLE_OVER_OR_BLACKOUT, [hl]
	res BIT_BATTLE_OVER_OR_BLACKOUT, [hl]
	call z, ResetUsingStrengthOutOfBattleBit
	call nz, MapEntryAfterBattle
	ld hl, wStatusFlags6
	ld a, [hl]
	and (1 << BIT_FLY_WARP) | (1 << BIT_DUNGEON_WARP)
	jr z, EnterMap.didNotEnterUsingFlyWarpOrDungeonWarp
	res BIT_FLY_WARP, [hl]
	farcall EnterMapAnim
	call UpdateSprites
EnterMap.didNotEnterUsingFlyWarpOrDungeonWarp
	farcall CheckForceBikeOrSurf ; handle currents in SF islands and forced bike riding in cycling road
	ld hl, wStatusFlags3
	res BIT_NO_NPC_FACE_PLAYER, [hl]
	call UpdateSprites
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	set BIT_CUR_MAP_LOADED_2, [hl]
	xor a
	ld [wJoyIgnore], a

OverworldLoop:
	call DelayFrame
OverworldLoopLessDelay:
	call DelayFrame
	call LoadGBPal
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	call nz, HandleMidJump
	ld a, [wWalkCounter]
	and a
	jp nz, OverworldLoopLessDelay.moveAhead ; if the player sprite has not yet completed the walking animation
	call JoypadOverworld ; get joypad state (which is possibly simulated)
	farcall SafariZoneCheck
	ld a, [wSafariZoneGameOver]
	and a
	jp nz, WarpFound2
	ld hl, wStatusFlags3
	bit BIT_WARP_FROM_CUR_SCRIPT, [hl]
	res BIT_WARP_FROM_CUR_SCRIPT, [hl]
	jp nz, WarpFound2
	ld a, [wStatusFlags6]
	and (1 << BIT_FLY_WARP) | (1 << BIT_DUNGEON_WARP)
	jp nz, HandleFlyWarpOrDungeonWarp
	ld a, [wCurOpponent]
	and a
	jp nz, OverworldLoopLessDelay.newBattle
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	jr z, OverworldLoopLessDelay.notSimulating
	ldh a, [lobyte(hJoyHeld)]
	jr OverworldLoopLessDelay.checkIfStartIsPressed
OverworldLoopLessDelay.notSimulating
	ldh a, [lobyte(hJoyPressed)]
OverworldLoopLessDelay.checkIfStartIsPressed
	bit B_PAD_START, a
	jr z, OverworldLoopLessDelay.startButtonNotPressed
; if START is pressed
	xor a ; TEXT_START_MENU
	ldh [lobyte(hTextID)], a
	jp OverworldLoopLessDelay.displayDialogue
OverworldLoopLessDelay.startButtonNotPressed
	bit B_PAD_A, a
	jp z, OverworldLoopLessDelay.checkIfDownButtonIsPressed
; if A is pressed
	ld a, [wStatusFlags5]
	bit BIT_UNKNOWN_5_2, a
	jp nz, OverworldLoopLessDelay.noDirectionButtonsPressed
	call IsPlayerCharacterBeingControlledByGame
	jr nz, OverworldLoopLessDelay.checkForOpponent
	call CheckForHiddenEventOrBookshelfOrCardKeyDoor
	ldh a, [lobyte(hItemAlreadyFound)]
	and a
	jp z, OverworldLoop ; jump if a hidden event or bookshelf was found, but not if a card key door was found
	call IsSpriteOrSignInFrontOfPlayer
	ldh a, [lobyte(hTextID)]
	and a
	jp z, OverworldLoop
OverworldLoopLessDelay.displayDialogue
	predef GetTileAndCoordsInFrontOfPlayer
	call UpdateSprites
	ld a, [wMiscFlags]
	bit BIT_TURNING, a
	jr nz, OverworldLoopLessDelay.checkForOpponent
	bit BIT_SEEN_BY_TRAINER, a
	jr nz, OverworldLoopLessDelay.checkForOpponent
	lda_coord 8, 9
	ld [wTilePlayerStandingOn], a ; checked when using Surf for forbidden tile pairs
	call DisplayTextID ; display either the start menu or the NPC/sign text
	ld a, [wEnteringCableClub]
	and a
	jr z, OverworldLoopLessDelay.checkForOpponent
	dec a
	ld a, 0
	ld [wEnteringCableClub], a
	jr z, OverworldLoopLessDelay.changeMap
; XXX can this code be reached?
	predef TryLoadSaveFile
	ld a, [wCurMap]
	ld [wDestinationMap], a
	call PrepareForSpecialWarp
	ld a, [wCurMap]
	call SwitchToMapRomBank
	ld hl, wCurMapTileset
	set BIT_NO_PREVIOUS_MAP, [hl]
OverworldLoopLessDelay.changeMap
	jp EnterMap
OverworldLoopLessDelay.checkForOpponent
	ld a, [wCurOpponent]
	and a
	jp nz, OverworldLoopLessDelay.newBattle
	jp OverworldLoop
OverworldLoopLessDelay.noDirectionButtonsPressed
	ld hl, wMiscFlags
	res BIT_TURNING, [hl]
	call UpdateSprites
	ld a, 1
	ld [wCheckFor180DegreeTurn], a
	ld a, [wPlayerMovingDirection] ; the direction that was pressed last time
	and a
	jp z, OverworldLoop
; if a direction was pressed last time
	ld [wPlayerLastStopDirection], a ; save the last direction
	xor a
	ld [wPlayerMovingDirection], a ; zero the direction
	jp OverworldLoop

OverworldLoopLessDelay.checkIfDownButtonIsPressed
	ldh a, [lobyte(hJoyHeld)] ; current joypad state
	bit B_PAD_DOWN, a
	jr z, OverworldLoopLessDelay.checkIfUpButtonIsPressed
	ld a, 1
	ld [wSpritePlayerStateData1YStepVector], a
	ld a, PLAYER_DIR_DOWN
	jr OverworldLoopLessDelay.handleDirectionButtonPress

OverworldLoopLessDelay.checkIfUpButtonIsPressed
	bit B_PAD_UP, a
	jr z, OverworldLoopLessDelay.checkIfLeftButtonIsPressed
	ld a, -1
	ld [wSpritePlayerStateData1YStepVector], a
	ld a, PLAYER_DIR_UP
	jr OverworldLoopLessDelay.handleDirectionButtonPress

OverworldLoopLessDelay.checkIfLeftButtonIsPressed
	bit B_PAD_LEFT, a
	jr z, OverworldLoopLessDelay.checkIfRightButtonIsPressed
	ld a, -1
	ld [wSpritePlayerStateData1XStepVector], a
	ld a, PLAYER_DIR_LEFT
	jr OverworldLoopLessDelay.handleDirectionButtonPress

OverworldLoopLessDelay.checkIfRightButtonIsPressed
	bit B_PAD_RIGHT, a
	jr z, OverworldLoopLessDelay.noDirectionButtonsPressed
	ld a, 1
	ld [wSpritePlayerStateData1XStepVector], a


OverworldLoopLessDelay.handleDirectionButtonPress
	ld [wPlayerDirection], a ; new direction
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	jr nz, OverworldLoopLessDelay.noDirectionChange ; ignore direction changes if we are
	ld a, [wCheckFor180DegreeTurn]
	and a
	jr z, OverworldLoopLessDelay.noDirectionChange
	ld a, [wPlayerDirection] ; new direction
	ld b, a
	ld a, [wPlayerLastStopDirection] ; old direction
	cp b
	jr z, OverworldLoopLessDelay.noDirectionChange
; Check whether the player did a 180-degree turn.
; It appears that this code was supposed to show the player rotate by having
; the player's sprite face an intermediate direction before facing the opposite
; direction (instead of doing an instantaneous about-face), but the intermediate
; direction is only set for a short period of time. It is unlikely for it to
; ever be visible because DelayFrame is called at the start of OverworldLoop and
; normally not enough cycles would be executed between then and the time the
; direction is set for V-blank to occur while the direction is still set.
	swap a ; put old direction in upper half
	or b ; put new direction in lower half
	cp (PLAYER_DIR_DOWN << 4) | PLAYER_DIR_UP ; change dir from down to up
	jr nz, OverworldLoopLessDelay.notDownToUp
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	jr OverworldLoopLessDelay.holdIntermediateDirectionLoop
OverworldLoopLessDelay.notDownToUp
	cp (PLAYER_DIR_UP << 4) | PLAYER_DIR_DOWN ; change dir from up to down
	jr nz, OverworldLoopLessDelay.notUpToDown
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	jr OverworldLoopLessDelay.holdIntermediateDirectionLoop
OverworldLoopLessDelay.notUpToDown
	cp (PLAYER_DIR_RIGHT << 4) | PLAYER_DIR_LEFT ; change dir from right to left
	jr nz, OverworldLoopLessDelay.notRightToLeft
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	jr OverworldLoopLessDelay.holdIntermediateDirectionLoop
OverworldLoopLessDelay.notRightToLeft
	cp (PLAYER_DIR_LEFT << 4) | PLAYER_DIR_RIGHT ; change dir from left to right
	jr nz, OverworldLoopLessDelay.holdIntermediateDirectionLoop
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
OverworldLoopLessDelay.holdIntermediateDirectionLoop
	ld hl, wMiscFlags
	set BIT_TURNING, [hl]
	ld hl, wCheckFor180DegreeTurn
	dec [hl]
	jr nz, OverworldLoopLessDelay.holdIntermediateDirectionLoop
	ld a, [wPlayerDirection]
	ld [wPlayerMovingDirection], a
	call NewBattle
	jp c, OverworldLoopLessDelay.battleOccurred
	jp OverworldLoop

OverworldLoopLessDelay.noDirectionChange
	ld a, [wPlayerDirection] ; current direction
	ld [wPlayerMovingDirection], a ; save direction
	call UpdateSprites
	ld a, [wWalkBikeSurfState]
	cp $02 ; surfing
	jr z, OverworldLoopLessDelay.surfing
; not surfing
	call CollisionCheckOnLand
	jr nc, OverworldLoopLessDelay.noCollision
; collision occurred
	push hl
	ld hl, wMovementFlags
	bit BIT_STANDING_ON_WARP, [hl]
	pop hl
	jp z, OverworldLoop
; collision occurred while standing on a warp
	push hl
	call ExtraWarpCheck ; sets carry if there is a potential to warp
	pop hl
	jp c, CheckWarpsCollision
	jp OverworldLoop

OverworldLoopLessDelay.surfing
	call CollisionCheckOnWater
	jp c, OverworldLoop

OverworldLoopLessDelay.noCollision
	ld a, $08
	ld [wWalkCounter], a
	jr OverworldLoopLessDelay.moveAhead2

OverworldLoopLessDelay.moveAhead
	ld a, [wMovementFlags]
	bit BIT_SPINNING, a
	jr z, OverworldLoopLessDelay.noSpinning
	farcall LoadSpinnerArrowTiles
OverworldLoopLessDelay.noSpinning
	call UpdateSprites

OverworldLoopLessDelay.moveAhead2
	ld hl, wMiscFlags
	res BIT_TURNING, [hl]
	ld a, [wWalkBikeSurfState]
	dec a ; riding a bike?
	jr nz, OverworldLoopLessDelay.normalPlayerSpriteAdvancement
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	jr nz, OverworldLoopLessDelay.normalPlayerSpriteAdvancement
	call DoBikeSpeedup
OverworldLoopLessDelay.normalPlayerSpriteAdvancement
	call AdvancePlayerSprite
	ld a, [wWalkCounter]
	and a
	jp nz, CheckMapConnections ; it seems like this check will never succeed (the other place where CheckMapConnections is run works)
; walking animation finished
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	jr nz, OverworldLoopLessDelay.doneStepCounting ; if button presses are being simulated, don't count steps
; step counting
	ld hl, wStepCounter
	dec [hl]
	ld a, [wStatusFlags2]
	bit BIT_WILD_ENCOUNTER_COOLDOWN, a
	jr z, OverworldLoopLessDelay.doneStepCounting
	ld hl, wNumberOfNoRandomBattleStepsLeft
	dec [hl]
	jr nz, OverworldLoopLessDelay.doneStepCounting
	ld hl, wStatusFlags2
	res BIT_WILD_ENCOUNTER_COOLDOWN, [hl]
OverworldLoopLessDelay.doneStepCounting
	CheckEvent EVENT_IN_SAFARI_ZONE
	jr z, OverworldLoopLessDelay.notSafariZone
	farcall SafariZoneCheckSteps
	ld a, [wSafariZoneGameOver]
	and a
	jp nz, WarpFound2
OverworldLoopLessDelay.notSafariZone
	ld a, [wIsInBattle]
	and a
	jp nz, CheckWarpsNoCollision
	predef ApplyOutOfBattlePoisonDamage ; also increment daycare mon exp
	ld a, [wOutOfBattleBlackout]
	and a
	jp nz, HandleBlackOut ; if all pokemon fainted
OverworldLoopLessDelay.newBattle
	call NewBattle
	ld hl, wMovementFlags
	res BIT_STANDING_ON_WARP, [hl]
	jp nc, CheckWarpsNoCollision ; check for warps if there was no battle
OverworldLoopLessDelay.battleOccurred
	ld hl, wStatusFlags3
	res BIT_TALKED_TO_TRAINER, [hl]
	ld hl, wStatusFlags7
	res BIT_TRAINER_BATTLE, [hl]
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	set BIT_CUR_MAP_LOADED_2, [hl]
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld a, [wCurMap]
	cp CINNABAR_GYM
	jr nz, OverworldLoopLessDelay.notCinnabarGym
	SetEvent EVENT_2A7
OverworldLoopLessDelay.notCinnabarGym
	ld hl, wStatusFlags4
	set BIT_BATTLE_OVER_OR_BLACKOUT, [hl]
	ld a, [wCurMap]
	cp OAKS_LAB
	jp z, OverworldLoopLessDelay.noFaintCheck ; no blacking out if the player lost to the rival in Oak's lab
	callfar AnyPartyAlive
	ld a, d
	and a
	jr z, OverworldLoopLessDelay.allPokemonFainted
OverworldLoopLessDelay.noFaintCheck
	ld c, 10
	call DelayFrames
	jp EnterMap
OverworldLoopLessDelay.allPokemonFainted
	ld a, $ff
	ld [wIsInBattle], a
	call RunMapScript
	jp HandleBlackOut

; function to determine if there will be a battle and execute it (either a trainer battle or wild battle)
; sets carry if a battle occurred and unsets carry if not
NewBattle:
	ld a, [wStatusFlags3]
	bit BIT_ON_DUNGEON_WARP, a
	jr nz, NewBattle.noBattle
	call IsPlayerCharacterBeingControlledByGame
	jr nz, NewBattle.noBattle ; no battle if the player character is under the game's control
	ld a, [wStatusFlags4]
	bit BIT_NO_BATTLES, a
	jr nz, NewBattle.noBattle
	farjp InitBattle
NewBattle.noBattle
	and a
	ret

; function to make bikes twice as fast as walking
DoBikeSpeedup:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, [wCurMap]
	cp ROUTE_17 ; Cycling Road
	jr nz, DoBikeSpeedup.goFaster
	ldh a, [lobyte(hJoyHeld)]
	and PAD_UP | PAD_LEFT | PAD_RIGHT
	ret nz
DoBikeSpeedup.goFaster
	jp AdvancePlayerSprite

; check if the player has stepped onto a warp after having not collided
CheckWarpsNoCollision:
	ld a, [wNumberOfWarps]
	and a
	jp z, CheckMapConnections
	ld a, [wNumberOfWarps]
	ld b, 0
	ld c, a
	ld a, [wYCoord]
	ld d, a
	ld a, [wXCoord]
	ld e, a
	ld hl, wWarpEntries
CheckWarpsNoCollisionLoop:
	ld a, [hli] ; check if the warp's Y position matches
	cp d
	jr nz, CheckWarpsNoCollisionRetry1
	ld a, [hli] ; check if the warp's X position matches
	cp e
	jr nz, CheckWarpsNoCollisionRetry2
; if a match was found
	push hl
	push bc
	ld hl, wMovementFlags
	set BIT_STANDING_ON_WARP, [hl]
	farcall IsPlayerStandingOnDoorTileOrWarpTile
	pop bc
	pop hl
	jr c, WarpFound1 ; jump if standing on door or warp
	push hl
	push bc
	call ExtraWarpCheck
	pop bc
	pop hl
	jr nc, CheckWarpsNoCollisionRetry2
; if the extra check passed
	ld a, [wStatusFlags7]
	bit BIT_FORCED_WARP, a
	jr nz, WarpFound1
	push de
	push bc
	call Joypad
	pop bc
	pop de
	ldh a, [lobyte(hJoyHeld)]
	and PAD_CTRL_PAD
	jr z, CheckWarpsNoCollisionRetry2 ; if directional buttons aren't being pressed, do not pass through the warp
	jr WarpFound1

; check if the player has stepped onto a warp after having collided
CheckWarpsCollision:
	ld a, [wNumberOfWarps]
	ld c, a
	ld hl, wWarpEntries
CheckWarpsCollision.loop
	ld a, [hli] ; Y coordinate of warp
	ld b, a
	ld a, [wYCoord]
	cp b
	jr nz, CheckWarpsCollision.retry1
	ld a, [hli] ; X coordinate of warp
	ld b, a
	ld a, [wXCoord]
	cp b
	jr nz, CheckWarpsCollision.retry2
	ld a, [hli]
	ld [wDestinationWarpID], a
	ld a, [hl]
	ldh [lobyte(hWarpDestinationMap)], a
	jr WarpFound2
CheckWarpsCollision.retry1
	inc hl
CheckWarpsCollision.retry2
	inc hl
	inc hl
	dec c
	jr nz, CheckWarpsCollision.loop
	jp OverworldLoop

CheckWarpsNoCollisionRetry1:
	inc hl
CheckWarpsNoCollisionRetry2:
	inc hl
	inc hl
	jp ContinueCheckWarpsNoCollisionLoop

WarpFound1:
	ld a, [hli]
	ld [wDestinationWarpID], a
	ld a, [hli]
	ldh [lobyte(hWarpDestinationMap)], a

WarpFound2:
	ld a, [wNumberOfWarps]
	sub c
	ld [wWarpedFromWhichWarp], a ; save ID of used warp
	ld a, [wCurMap]
	ld [wWarpedFromWhichMap], a
	call CheckIfInOutsideMap
	jr nz, WarpFound2.indoorMaps
; this is for handling "outside" maps that can't have the 0xFF destination map
	ld a, [wCurMap]
	ld [wLastMap], a
	ld a, [wCurMapWidth]
	ld [wUnusedLastMapWidth], a
	ldh a, [lobyte(hWarpDestinationMap)]
	ld [wCurMap], a
	cp ROCK_TUNNEL_1F
	jr nz, WarpFound2.notRockTunnel
	ld a, $06
	ld [wMapPalOffset], a
	call GBFadeOutToBlack
WarpFound2.notRockTunnel
	call PlayMapChangeSound
	jr WarpFound2.done

; for maps that can have the 0xFF destination map, which means to return to the outside map
; not all these maps are necessarily indoors, though
WarpFound2.indoorMaps
	ldh a, [lobyte(hWarpDestinationMap)]
	cp LAST_MAP
	jr z, WarpFound2.goBackOutside
; if not going back to the previous map
	ld [wCurMap], a
	farcall IsPlayerStandingOnWarpPadOrHole
	ld a, [wStandingOnWarpPadOrHole]
	dec a ; is the player on a warp pad?
	jr nz, WarpFound2.notWarpPad
; if the player is on a warp pad
	ld hl, wStatusFlags6
	set BIT_FLY_WARP, [hl]
	call LeaveMapAnim
	jr WarpFound2.skipMapChangeSound
WarpFound2.notWarpPad
	call PlayMapChangeSound
WarpFound2.skipMapChangeSound
	ld hl, wMovementFlags
	res BIT_STANDING_ON_DOOR, [hl]
	res BIT_EXITING_DOOR, [hl]
	jr WarpFound2.done
WarpFound2.goBackOutside
	ld a, [wLastMap]
	ld [wCurMap], a
	call PlayMapChangeSound
	xor a
	ld [wMapPalOffset], a
WarpFound2.done
	ld hl, wMovementFlags
	set BIT_STANDING_ON_DOOR, [hl] ; have the player's sprite step out from the door (if there is one)
	call IgnoreInputForHalfSecond
	jp EnterMap

ContinueCheckWarpsNoCollisionLoop:
	inc b ; increment warp number
	dec c ; decrement number of warps
	jp nz, CheckWarpsNoCollisionLoop

; if no matching warp was found
CheckMapConnections:
; check west map
	ld a, [wXCoord]
	cp $ff
	jr nz, CheckMapConnections.checkEastMap
	ld a, [wWestConnectedMap]
	ld [wCurMap], a
	ld a, [wWestConnectedMapXAlignment] ; new X coordinate upon entering west map
	ld [wXCoord], a
	ld a, [wYCoord]
	ld c, a
	ld a, [wWestConnectedMapYAlignment] ; Y adjustment upon entering west map
	add c
	ld c, a
	ld [wYCoord], a
	ld a, [wWestConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for Y position
	ld l, a
	ld a, [wWestConnectedMapViewPointer + 1]
	ld h, a
	srl c
	jr z, CheckMapConnections.savePointer1
CheckMapConnections.pointerAdjustmentLoop1
	ld a, [wWestConnectedMapWidth]
	add MAP_BORDER * 2
	ld e, a
	ld d, 0
	ld b, 0
	add hl, de
	dec c
	jr nz, CheckMapConnections.pointerAdjustmentLoop1
CheckMapConnections.savePointer1
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
	jp CheckMapConnections.loadNewMap

CheckMapConnections.checkEastMap
	ld b, a
	ld a, [wCurrentMapWidth2]
	cp b
	jr nz, CheckMapConnections.checkNorthMap
	ld a, [wEastConnectedMap]
	ld [wCurMap], a
	ld a, [wEastConnectedMapXAlignment] ; new X coordinate upon entering east map
	ld [wXCoord], a
	ld a, [wYCoord]
	ld c, a
	ld a, [wEastConnectedMapYAlignment] ; Y adjustment upon entering east map
	add c
	ld c, a
	ld [wYCoord], a
	ld a, [wEastConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for Y position
	ld l, a
	ld a, [wEastConnectedMapViewPointer + 1]
	ld h, a
	srl c
	jr z, CheckMapConnections.savePointer2
CheckMapConnections.pointerAdjustmentLoop2
	ld a, [wEastConnectedMapWidth]
	add MAP_BORDER * 2
	ld e, a
	ld d, 0
	ld b, 0
	add hl, de
	dec c
	jr nz, CheckMapConnections.pointerAdjustmentLoop2
CheckMapConnections.savePointer2
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
	jp CheckMapConnections.loadNewMap

CheckMapConnections.checkNorthMap
	ld a, [wYCoord]
	cp $ff
	jr nz, CheckMapConnections.checkSouthMap
	ld a, [wNorthConnectedMap]
	ld [wCurMap], a
	ld a, [wNorthConnectedMapYAlignment] ; new Y coordinate upon entering north map
	ld [wYCoord], a
	ld a, [wXCoord]
	ld c, a
	ld a, [wNorthConnectedMapXAlignment] ; X adjustment upon entering north map
	add c
	ld c, a
	ld [wXCoord], a
	ld a, [wNorthConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for X position
	ld l, a
	ld a, [wNorthConnectedMapViewPointer + 1]
	ld h, a
	ld b, 0
	srl c
	add hl, bc
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
	jp CheckMapConnections.loadNewMap

CheckMapConnections.checkSouthMap
	ld b, a
	ld a, [wCurrentMapHeight2]
	cp b
	jr nz, CheckMapConnections.didNotEnterConnectedMap
	ld a, [wSouthConnectedMap]
	ld [wCurMap], a
	ld a, [wSouthConnectedMapYAlignment] ; new Y coordinate upon entering south map
	ld [wYCoord], a
	ld a, [wXCoord]
	ld c, a
	ld a, [wSouthConnectedMapXAlignment] ; X adjustment upon entering south map
	add c
	ld c, a
	ld [wXCoord], a
	ld a, [wSouthConnectedMapViewPointer] ; pointer to upper left corner of map without adjustment for X position
	ld l, a
	ld a, [wSouthConnectedMapViewPointer + 1]
	ld h, a
	ld b, 0
	srl c
	add hl, bc
	ld a, l
	ld [wCurrentTileBlockMapViewPointer], a ; pointer to upper left corner of current tile block map section
	ld a, h
	ld [wCurrentTileBlockMapViewPointer + 1], a
CheckMapConnections.loadNewMap ; load the connected map that was entered
	call LoadMapHeader
	call PlayDefaultMusicFadeOutCurrent
	ld b, SET_PAL_OVERWORLD
	call RunPaletteCommand
; Since the sprite set shouldn't change, this will just update VRAM slots at
; x#SPRITESTATEDATA2_IMAGEBASEOFFSET without loading any tile patterns.
	farcall InitMapSprites
	call LoadTileBlockMap
	jp OverworldLoopLessDelay

CheckMapConnections.didNotEnterConnectedMap
	jp OverworldLoop

; function to play a sound when changing maps
PlayMapChangeSound:
	lda_coord 8, 8 ; upper left tile of the 4x4 square the player's sprite is standing on
	cp $0b ; door tile in tileset 0
	jr nz, PlayMapChangeSound.didNotGoThroughDoor
	ld a, SFX_GO_INSIDE
	jr PlayMapChangeSound.playSound
PlayMapChangeSound.didNotGoThroughDoor
	ld a, SFX_GO_OUTSIDE
PlayMapChangeSound.playSound
	call PlaySound
	ld a, [wMapPalOffset]
	and a
	ret nz
	jp GBFadeOutToBlack

CheckIfInOutsideMap:
; If the player is in an outside map (a town or route), set the z flag
	ld a, [wCurMapTileset]
	and a ; most towns/routes have tileset 0 (OVERWORLD)
	ret z
	cp PLATEAU ; Route 23 / Indigo Plateau
	ret

; this function is an extra check that sometimes has to pass in order to warp, beyond just standing on a warp
; the "sometimes" qualification is necessary because of CheckWarpsNoCollision's behavior
; depending on the map, either "function 1" or "function 2" is used for the check
; "function 1" passes when the player is at the edge of the map and is facing towards the outside of the map
; "function 2" passes when the the tile in front of the player is among a certain set
; sets carry if the check passes, otherwise clears carry
ExtraWarpCheck:
	ld a, [wCurMap]
	cp SS_ANNE_3F
	jr z, ExtraWarpCheck.useFunction1
	cp ROCKET_HIDEOUT_B1F
	jr z, ExtraWarpCheck.useFunction2
	cp ROCKET_HIDEOUT_B2F
	jr z, ExtraWarpCheck.useFunction2
	cp ROCKET_HIDEOUT_B4F
	jr z, ExtraWarpCheck.useFunction2
	cp ROCK_TUNNEL_1F
	jr z, ExtraWarpCheck.useFunction2
	ld a, [wCurMapTileset]
	and a ; outside tileset (OVERWORLD)
	jr z, ExtraWarpCheck.useFunction2
	cp SHIP ; S.S. Anne tileset
	jr z, ExtraWarpCheck.useFunction2
	cp SHIP_PORT ; Vermilion Port tileset
	jr z, ExtraWarpCheck.useFunction2
	cp PLATEAU ; Indigo Plateau tileset
	jr z, ExtraWarpCheck.useFunction2
ExtraWarpCheck.useFunction1
	ld hl, IsPlayerFacingEdgeOfMap
	jr ExtraWarpCheck.doBankswitch
ExtraWarpCheck.useFunction2
	ld hl, IsWarpTileInFrontOfPlayer
ExtraWarpCheck.doBankswitch
	ld b, bank(IsWarpTileInFrontOfPlayer)
	jp Bankswitch

MapEntryAfterBattle:
	farcall IsPlayerStandingOnWarp ; for enabling warp testing after collisions
	ld a, [wMapPalOffset]
	and a
	jp z, GBFadeInFromWhite
	jp LoadGBPal

HandleBlackOut:
; For when all the player's pokemon faint.
; Does not print the "blacked out" message.
	call GBFadeOutToBlack
	ld a, $08
	call StopMusic
	ld hl, wStatusFlags4
	res BIT_BATTLE_OVER_OR_BLACKOUT, [hl]
	ld a, bank(ResetStatusAndHalveMoneyOnBlackout) ; also bank(PrepareForSpecialWarp) and bank(SpecialEnterMap)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	call ResetStatusAndHalveMoneyOnBlackout
	call PrepareForSpecialWarp
	call PlayDefaultMusicFadeOutCurrent
	jp SpecialEnterMap

StopMusic:
	ld [wAudioFadeOutControl], a
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
StopMusic.wait
	ld a, [wAudioFadeOutControl]
	and a
	jr nz, StopMusic.wait
	jp StopAllSounds

HandleFlyWarpOrDungeonWarp:
	call UpdateSprites
	call Delay3
	xor a
	ld [wBattleResult], a
	ld [wWalkBikeSurfState], a
	ld [wIsInBattle], a
	ld [wMapPalOffset], a
	ld hl, wStatusFlags6
	set BIT_FLY_OR_DUNGEON_WARP, [hl]
	res BIT_ALWAYS_ON_BIKE, [hl]
	call LeaveMapAnim
	ld a, bank(PrepareForSpecialWarp)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	call PrepareForSpecialWarp
	jp SpecialEnterMap

LeaveMapAnim:
	farjp WLA_GLOBAL_LeaveMapAnim

LoadPlayerSpriteGraphics:
; Load sprite graphics based on whether the player is standing, biking, or surfing.

	; 0: standing
	; 1: biking
	; 2: surfing

	ld a, [wWalkBikeSurfState]
	dec a
	jr z, LoadPlayerSpriteGraphics.ridingBike

	ldh a, [lobyte(hTileAnimations)]
	and a
	jr nz, LoadPlayerSpriteGraphics.determineGraphics
	jr LoadPlayerSpriteGraphics.startWalking

LoadPlayerSpriteGraphics.ridingBike
	; If the bike can't be used,
	; start walking instead.
	call IsBikeRidingAllowed
	jr c, LoadPlayerSpriteGraphics.determineGraphics

LoadPlayerSpriteGraphics.startWalking
	xor a
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	jp LoadWalkingPlayerSpriteGraphics

LoadPlayerSpriteGraphics.determineGraphics
	ld a, [wWalkBikeSurfState]
	and a
	jp z, LoadWalkingPlayerSpriteGraphics
	dec a
	jp z, LoadBikePlayerSpriteGraphics
	dec a
	jp z, LoadSurfingPlayerSpriteGraphics
	jp LoadWalkingPlayerSpriteGraphics

IsBikeRidingAllowed:
; The bike can be used on Route 23 and Indigo Plateau,
; or maps with tilesets in BikeRidingTilesets.
; Return carry if biking is allowed.

	ld a, [wCurMap]
	cp ROUTE_23
	jr z, IsBikeRidingAllowed.allowed
	cp INDIGO_PLATEAU
	jr z, IsBikeRidingAllowed.allowed

	ld a, [wCurMapTileset]
	ld b, a
	ld hl, BikeRidingTilesets
IsBikeRidingAllowed.loop
	ld a, [hli]
	cp b
	jr z, IsBikeRidingAllowed.allowed
	inc a
	jr nz, IsBikeRidingAllowed.loop
	and a
	ret

IsBikeRidingAllowed.allowed
	scf
	ret

.INCLUDE "data/tilesets/bike_riding_tilesets.asm"

; load the tile pattern data of the current tileset into VRAM
LoadTilesetTilePatternData:
	ld a, [wTilesetGfxPtr]
	ld l, a
	ld a, [wTilesetGfxPtr + 1]
	ld h, a
	ld de, vTileset
	ld bc, MAP_TILESET_SIZE * TILE_SIZE
	ld a, [wTilesetBank]
	jp FarCopyData2

; this loads the current map's complete tile map (which references blocks, not individual tiles) to wOverworldMap
; it can also load partial tile maps of connected maps into a border of length 3 around the current map
LoadTileBlockMap:
; fill wOverworldMap-wOverworldMapEnd with the background tile
	ld hl, wOverworldMap
	ld a, [wMapBackgroundTile]
	ld d, a
	ld bc, wOverworldMapEnd - wOverworldMap
LoadTileBlockMap.backgroundTileLoop
	ld a, d
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, LoadTileBlockMap.backgroundTileLoop
; load tile map of current map (made of tile block IDs)
; a 3-byte border at the edges of the map is kept so that there is space for map connections
	ld hl, wOverworldMap
	ld a, [wCurMapWidth]
	ldh [lobyte(hMapWidth)], a
	add MAP_BORDER * 2 ; east and west
	ldh [lobyte(hMapStride)], a ; map width + border
	ld b, 0
	ld c, a
; make space for north border (next 3 lines)
	add hl, bc
	add hl, bc
	add hl, bc
	ld c, MAP_BORDER
	add hl, bc ; this puts us past the (west) border
	ld a, [wCurMapDataPtr] ; tile map pointer
	ld e, a
	ld a, [wCurMapDataPtr + 1]
	ld d, a ; de = tile map pointer
	ld a, [wCurMapHeight]
	ld b, a
LoadTileBlockMap.rowLoop ; copy one row each iteration
	push hl
	ldh a, [lobyte(hMapWidth)] ; map width (without border)
	ld c, a
LoadTileBlockMap.rowInnerLoop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, LoadTileBlockMap.rowInnerLoop
; add the map width plus the border to the base address of the current row to get the next row's address
	pop hl
	ldh a, [lobyte(hMapStride)] ; map width + border
	add l
	ld l, a
	jr nc, LoadTileBlockMap.noCarry
	inc h
LoadTileBlockMap.noCarry
	dec b
	jr nz, LoadTileBlockMap.rowLoop
LoadTileBlockMap.northConnection
	ld a, [wNorthConnectedMap]
	cp $ff
	jr z, LoadTileBlockMap.southConnection
	call SwitchToMapRomBank
	ld a, [wNorthConnectionStripSrc]
	ld l, a
	ld a, [wNorthConnectionStripSrc + 1]
	ld h, a
	ld a, [wNorthConnectionStripDest]
	ld e, a
	ld a, [wNorthConnectionStripDest + 1]
	ld d, a
	ld a, [wNorthConnectionStripLength]
	ldh [lobyte(hNorthSouthConnectionStripWidth)], a
	ld a, [wNorthConnectedMapWidth]
	ldh [lobyte(hNorthSouthConnectedMapWidth)], a
	call LoadNorthSouthConnectionsTileMap
LoadTileBlockMap.southConnection
	ld a, [wSouthConnectedMap]
	cp $ff
	jr z, LoadTileBlockMap.westConnection
	call SwitchToMapRomBank
	ld a, [wSouthConnectionStripSrc]
	ld l, a
	ld a, [wSouthConnectionStripSrc + 1]
	ld h, a
	ld a, [wSouthConnectionStripDest]
	ld e, a
	ld a, [wSouthConnectionStripDest + 1]
	ld d, a
	ld a, [wSouthConnectionStripLength]
	ldh [lobyte(hNorthSouthConnectionStripWidth)], a
	ld a, [wSouthConnectedMapWidth]
	ldh [lobyte(hNorthSouthConnectedMapWidth)], a
	call LoadNorthSouthConnectionsTileMap
LoadTileBlockMap.westConnection
	ld a, [wWestConnectedMap]
	cp $ff
	jr z, LoadTileBlockMap.eastConnection
	call SwitchToMapRomBank
	ld a, [wWestConnectionStripSrc]
	ld l, a
	ld a, [wWestConnectionStripSrc + 1]
	ld h, a
	ld a, [wWestConnectionStripDest]
	ld e, a
	ld a, [wWestConnectionStripDest + 1]
	ld d, a
	ld a, [wWestConnectionStripLength]
	ld b, a
	ld a, [wWestConnectedMapWidth]
	ldh [lobyte(hEastWestConnectedMapWidth)], a
	call LoadEastWestConnectionsTileMap
LoadTileBlockMap.eastConnection
	ld a, [wEastConnectedMap]
	cp $ff
	jr z, LoadTileBlockMap.done
	call SwitchToMapRomBank
	ld a, [wEastConnectionStripSrc]
	ld l, a
	ld a, [wEastConnectionStripSrc + 1]
	ld h, a
	ld a, [wEastConnectionStripDest]
	ld e, a
	ld a, [wEastConnectionStripDest + 1]
	ld d, a
	ld a, [wEastConnectionStripLength]
	ld b, a
	ld a, [wEastConnectedMapWidth]
	ldh [lobyte(hEastWestConnectedMapWidth)], a
	call LoadEastWestConnectionsTileMap
LoadTileBlockMap.done
	ret

LoadNorthSouthConnectionsTileMap:
	ld c, MAP_BORDER
LoadNorthSouthConnectionsTileMap.loop
	push de
	push hl
	ldh a, [lobyte(hNorthSouthConnectionStripWidth)]
	ld b, a
LoadNorthSouthConnectionsTileMap.innerLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, LoadNorthSouthConnectionsTileMap.innerLoop
	pop hl
	pop de
	ldh a, [lobyte(hNorthSouthConnectedMapWidth)]
	add l
	ld l, a
	jr nc, LoadNorthSouthConnectionsTileMap.noCarry1
	inc h
LoadNorthSouthConnectionsTileMap.noCarry1
	ld a, [wCurMapWidth]
	add MAP_BORDER * 2
	add e
	ld e, a
	jr nc, LoadNorthSouthConnectionsTileMap.noCarry2
	inc d
LoadNorthSouthConnectionsTileMap.noCarry2
	dec c
	jr nz, LoadNorthSouthConnectionsTileMap.loop
	ret

LoadEastWestConnectionsTileMap:
	push hl
	push de
	ld c, MAP_BORDER
LoadEastWestConnectionsTileMap.innerLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, LoadEastWestConnectionsTileMap.innerLoop
	pop de
	pop hl
	ldh a, [lobyte(hEastWestConnectedMapWidth)]
	add l
	ld l, a
	jr nc, LoadEastWestConnectionsTileMap.noCarry1
	inc h
LoadEastWestConnectionsTileMap.noCarry1
	ld a, [wCurMapWidth]
	add MAP_BORDER * 2
	add e
	ld e, a
	jr nc, LoadEastWestConnectionsTileMap.noCarry2
	inc d
LoadEastWestConnectionsTileMap.noCarry2
	dec b
	jr nz, LoadEastWestConnectionsTileMap
	ret

; function to check if there is a sign or sprite in front of the player
; if so, it is stored in [hTextID]
; if not, [hTextID] is set to 0
IsSpriteOrSignInFrontOfPlayer:
	xor a
	ldh [lobyte(hTextID)], a
	ld a, [wNumSigns]
	and a
	jr z, IsSpriteOrSignInFrontOfPlayer.extendRangeOverCounter
; if there are signs
	predef GetTileAndCoordsInFrontOfPlayer ; get the coordinates in front of the player in de
	ld hl, wSignCoords
	ld a, [wNumSigns]
	ld b, a
	ld c, 0
IsSpriteOrSignInFrontOfPlayer.signLoop
	inc c
	ld a, [hli] ; sign Y
	cp d
	jr z, IsSpriteOrSignInFrontOfPlayer.yCoordMatched
	inc hl
	jr IsSpriteOrSignInFrontOfPlayer.retry
IsSpriteOrSignInFrontOfPlayer.yCoordMatched
	ld a, [hli] ; sign X
	cp e
	jr nz, IsSpriteOrSignInFrontOfPlayer.retry
; X coord matched: found sign
	push hl
	push bc
	ld hl, wSignTextIDs
	ld b, 0
	dec c
	add hl, bc
	ld a, [hl]
	ldh [lobyte(hTextID)], a ; store sign text ID
	pop bc
	pop hl
	ret
IsSpriteOrSignInFrontOfPlayer.retry
	dec b
	jr nz, IsSpriteOrSignInFrontOfPlayer.signLoop
; check if the player is front of a counter in a pokemon center, pokemart, etc. and if so, extend the range at which he can talk to the NPC
IsSpriteOrSignInFrontOfPlayer.extendRangeOverCounter
	predef GetTileAndCoordsInFrontOfPlayer ; get the tile in front of the player in c
	ld hl, wTilesetTalkingOverTiles ; list of tiles that extend talking range (counter tiles)
	ld b, 3
	ld d, $20 ; talking range in pixels (long range)
IsSpriteOrSignInFrontOfPlayer.counterTilesLoop
	ld a, [hli]
	cp c
	jr z, IsSpriteInFrontOfPlayer2 ; jumps if the tile in front of the player is a counter tile
	dec b
	jr nz, IsSpriteOrSignInFrontOfPlayer.counterTilesLoop

; part of the above function, but sometimes its called on its own, when signs are irrelevant
; the caller must zero [hTextID]
IsSpriteInFrontOfPlayer:
	ld d, $10 ; talking range in pixels (normal range)
IsSpriteInFrontOfPlayer2:
	lb "bc", $3c, $40 ; Y and X position of player sprite
	ld a, [wSpritePlayerStateData1FacingDirection]
IsSpriteInFrontOfPlayer2.checkIfPlayerFacingUp
	cp SPRITE_FACING_UP
	jr nz, IsSpriteInFrontOfPlayer2.checkIfPlayerFacingDown
; facing up
	ld a, b
	sub d
	ld b, a
	ld a, PLAYER_DIR_UP
	jr IsSpriteInFrontOfPlayer2.doneCheckingDirection

IsSpriteInFrontOfPlayer2.checkIfPlayerFacingDown
	cp SPRITE_FACING_DOWN
	jr nz, IsSpriteInFrontOfPlayer2.checkIfPlayerFacingRight
; facing down
	ld a, b
	add d
	ld b, a
	ld a, PLAYER_DIR_DOWN
	jr IsSpriteInFrontOfPlayer2.doneCheckingDirection

IsSpriteInFrontOfPlayer2.checkIfPlayerFacingRight
	cp SPRITE_FACING_RIGHT
	jr nz, IsSpriteInFrontOfPlayer2.playerFacingLeft
; facing right
	ld a, c
	add d
	ld c, a
	ld a, PLAYER_DIR_RIGHT
	jr IsSpriteInFrontOfPlayer2.doneCheckingDirection

IsSpriteInFrontOfPlayer2.playerFacingLeft
; facing left
	ld a, c
	sub d
	ld c, a
	ld a, PLAYER_DIR_LEFT
IsSpriteInFrontOfPlayer2.doneCheckingDirection
	ld [wPlayerDirection], a
	ld a, [wNumSprites]
	and a
	ret z
; if there are sprites
	ld hl, wSprite01StateData1
	ld d, a
	ld e, $01
IsSpriteInFrontOfPlayer2.spriteLoop
	push hl
	ld a, [hli] ; image (0 if no sprite)
	and a
	jr z, IsSpriteInFrontOfPlayer2.nextSprite
	inc l
	ld a, [hli] ; sprite visibility
	inc a
	jr z, IsSpriteInFrontOfPlayer2.nextSprite
	inc l
	ld a, [hli] ; Y location
	cp b
	jr nz, IsSpriteInFrontOfPlayer2.nextSprite
	inc l
	ld a, [hl] ; X location
	cp c
	jr z, IsSpriteInFrontOfPlayer2.foundSpriteInFrontOfPlayer
IsSpriteInFrontOfPlayer2.nextSprite
	pop hl
	ld a, l
	add SPRITESTATEDATA1_LENGTH
	ld l, a
	inc e
	dec d
	jr nz, IsSpriteInFrontOfPlayer2.spriteLoop
	ret
IsSpriteInFrontOfPlayer2.foundSpriteInFrontOfPlayer
	pop hl
	ld a, l
	and $f0
	inc a
	ld l, a ; hl = x#SPRITESTATEDATA1_MOVEMENTSTATUS
	set BIT_FACE_PLAYER, [hl]
	ld a, e
	ldh [lobyte(hTextID)], a
	ret

; function to check if the player will jump down a ledge and check if the tile ahead is passable (when not surfing)
; sets the carry flag if there is a collision, and unsets it if there isn't a collision
CollisionCheckOnLand:
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	jr nz, CollisionCheckOnLand.noCollision
; if not jumping a ledge
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	jr nz, CollisionCheckOnLand.noCollision ; no collisions when the player's movements are being controlled by the game
	ld a, [wPlayerDirection] ; the direction that the player is trying to go in
	ld d, a
	ld a, [wSpritePlayerStateData1CollisionData]
	and d ; check if a sprite is in the direction the player is trying to go
	jr nz, CollisionCheckOnLand.collision
	xor a
	ldh [lobyte(hTextID)], a
	call IsSpriteInFrontOfPlayer ; check for sprite collisions again? when does the above check fail to detect a sprite collision?
	ldh a, [lobyte(hTextID)]
	and a ; was there a sprite collision?
	jr nz, CollisionCheckOnLand.collision
; if no sprite collision
	ld hl, TilePairCollisionsLand
	call CheckForJumpingAndTilePairCollisions
	jr c, CollisionCheckOnLand.collision
	call CheckTilePassable
	jr nc, CollisionCheckOnLand.noCollision
CollisionCheckOnLand.collision
	ld a, [wChannelSoundIDs + CHAN5]
	cp SFX_COLLISION ; check if collision sound is already playing
	jr z, CollisionCheckOnLand.setCarry
	ld a, SFX_COLLISION
	call PlaySound ; play collision sound (if it's not already playing)
CollisionCheckOnLand.setCarry
	scf
	ret
CollisionCheckOnLand.noCollision
	and a
	ret

; function that checks if the tile in front of the player is passable
; clears carry if it is, sets carry if not
CheckTilePassable:
	predef GetTileAndCoordsInFrontOfPlayer
	ld a, [wTileInFrontOfPlayer]
	ld c, a
	ld hl, wTilesetCollisionPtr ; pointer to list of passable tiles
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl now points to passable tiles
CheckTilePassable.loop
	ld a, [hli]
	cp $ff
	jr z, CheckTilePassable.tileNotPassable
	cp c
	ret z
	jr CheckTilePassable.loop
CheckTilePassable.tileNotPassable
	scf
	ret

; check if the player is going to jump down a small ledge
; and check for collisions that only occur between certain pairs of tiles
; Input: hl - address of directional collision data
; sets carry if there is a collision and unsets carry if not
CheckForJumpingAndTilePairCollisions:
	push hl
	predef GetTileAndCoordsInFrontOfPlayer
	push de
	push bc
	farcall HandleLedges ; check if the player is trying to jump a ledge
	pop bc
	pop de
	pop hl
	and a
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	ret nz
; if not jumping

CheckForTilePairCollisions2:
	lda_coord 8, 9 ; tile the player is on
	ld [wTilePlayerStandingOn], a

CheckForTilePairCollisions:
	ld a, [wTileInFrontOfPlayer]
	ld c, a
CheckForTilePairCollisions.tilePairCollisionLoop
	ld a, [wCurMapTileset]
	ld b, a
	ld a, [hli]
	cp $ff
	jr z, CheckForTilePairCollisions.noMatch
	cp b
	jr z, CheckForTilePairCollisions.tilesetMatches
	inc hl
CheckForTilePairCollisions.retry
	inc hl
	jr CheckForTilePairCollisions.tilePairCollisionLoop
CheckForTilePairCollisions.tilesetMatches
	ld a, [wTilePlayerStandingOn]
	ld b, a
	ld a, [hl]
	cp b
	jr z, CheckForTilePairCollisions.currentTileMatchesFirstInPair
	inc hl
	ld a, [hl]
	cp b
	jr z, CheckForTilePairCollisions.currentTileMatchesSecondInPair
	jr CheckForTilePairCollisions.retry
CheckForTilePairCollisions.currentTileMatchesFirstInPair
	inc hl
	ld a, [hl]
	cp c
	jr z, CheckForTilePairCollisions.foundMatch
	jr CheckForTilePairCollisions.tilePairCollisionLoop
CheckForTilePairCollisions.currentTileMatchesSecondInPair
	dec hl
	ld a, [hli]
	cp c
	inc hl
	jr nz, CheckForTilePairCollisions.tilePairCollisionLoop
CheckForTilePairCollisions.foundMatch
	scf
	ret
CheckForTilePairCollisions.noMatch
	and a
	ret

.INCLUDE "data/tilesets/pair_collision_tile_ids.asm"

; this builds a tile map from the tile block map based on the current X/Y coordinates of the player's character
LoadCurrentMapView:
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, [wTilesetBank]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ld a, [wCurrentTileBlockMapViewPointer] ; address of upper left corner of current map view
	ld e, a
	ld a, [wCurrentTileBlockMapViewPointer + 1]
	ld d, a
	ld hl, wSurroundingTiles
	ld b, SCREEN_BLOCK_HEIGHT
LoadCurrentMapView.rowLoop ; each loop iteration fills in one row of tile blocks
	push hl
	push de
	ld c, SCREEN_BLOCK_WIDTH
LoadCurrentMapView.rowInnerLoop ; loop to draw each tile block of the current row
	push bc
	push de
	push hl
	ld a, [de]
	ld c, a ; tile block number
	call DrawTileBlock
	pop hl
	pop de
	pop bc
	inc hl
	inc hl
	inc hl
	inc hl
	inc de
	dec c
	jr nz, LoadCurrentMapView.rowInnerLoop
; update tile block map pointer to next row's address
	pop de
	ld a, [wCurMapWidth]
	add MAP_BORDER * 2
	add e
	ld e, a
	jr nc, LoadCurrentMapView.noCarry
	inc d
LoadCurrentMapView.noCarry
; update tile map pointer to next row's address
	pop hl
	ld a, SURROUNDING_WIDTH * BLOCK_HEIGHT
	add l
	ld l, a
	jr nc, LoadCurrentMapView.noCarry2
	inc h
LoadCurrentMapView.noCarry2
	dec b
	jr nz, LoadCurrentMapView.rowLoop
	ld hl, wSurroundingTiles
	ld bc, 0
LoadCurrentMapView.adjustForYCoordWithinTileBlock
	ld a, [wYBlockCoord]
	and a
	jr z, LoadCurrentMapView.adjustForXCoordWithinTileBlock
	ld bc, SURROUNDING_WIDTH * 2
	add hl, bc
LoadCurrentMapView.adjustForXCoordWithinTileBlock
	ld a, [wXBlockCoord]
	and a
	jr z, LoadCurrentMapView.copyToVisibleAreaBuffer
	ld bc, BLOCK_WIDTH / 2
	add hl, bc
LoadCurrentMapView.copyToVisibleAreaBuffer
	decoord 0, 0 ; base address for the tiles that are directly transferred to VRAM during V-blank
	ld b, SCREEN_HEIGHT
LoadCurrentMapView.rowLoop2
	ld c, SCREEN_WIDTH
LoadCurrentMapView.rowInnerLoop2
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, LoadCurrentMapView.rowInnerLoop2
	ld a, SURROUNDING_WIDTH - SCREEN_WIDTH
	add l
	ld l, a
	jr nc, LoadCurrentMapView.noCarry3
	inc h
LoadCurrentMapView.noCarry3
	dec b
	jr nz, LoadCurrentMapView.rowLoop2
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

AdvancePlayerSprite:
	ld a, [wSpritePlayerStateData1YStepVector]
	ld b, a
	ld a, [wSpritePlayerStateData1XStepVector]
	ld c, a
	ld hl, wWalkCounter
	dec [hl]
	jr nz, AdvancePlayerSprite.afterUpdateMapCoords
; if it's the end of the animation, update the player's map coordinates
	ld a, [wYCoord]
	add b
	ld [wYCoord], a
	ld a, [wXCoord]
	add c
	ld [wXCoord], a
AdvancePlayerSprite.afterUpdateMapCoords
	ld a, [wWalkCounter]
	cp $07
	jp nz, AdvancePlayerSprite.scrollBackgroundAndSprites
; if this is the first iteration of the animation
	ld a, c
	cp $01
	jr nz, AdvancePlayerSprite.checkIfMovingWest
; moving east
	ld a, [wMapViewVRAMPointer]
	ld e, a
	and $e0
	ld d, a
	ld a, e
	add $02
	and $1f
	or d
	ld [wMapViewVRAMPointer], a
	jr AdvancePlayerSprite.adjustXCoordWithinBlock
AdvancePlayerSprite.checkIfMovingWest
	cp $ff
	jr nz, AdvancePlayerSprite.checkIfMovingSouth
; moving west
	ld a, [wMapViewVRAMPointer]
	ld e, a
	and $e0
	ld d, a
	ld a, e
	sub $02
	and $1f
	or d
	ld [wMapViewVRAMPointer], a
	jr AdvancePlayerSprite.adjustXCoordWithinBlock
AdvancePlayerSprite.checkIfMovingSouth
	ld a, b
	cp $01
	jr nz, AdvancePlayerSprite.checkIfMovingNorth
; moving south
	ld a, [wMapViewVRAMPointer]
	add $40
	ld [wMapViewVRAMPointer], a
	jr nc, AdvancePlayerSprite.adjustXCoordWithinBlock
	ld a, [wMapViewVRAMPointer + 1]
	inc a
	and $03
	or $98
	ld [wMapViewVRAMPointer + 1], a
	jr AdvancePlayerSprite.adjustXCoordWithinBlock
AdvancePlayerSprite.checkIfMovingNorth
	cp $ff
	jr nz, AdvancePlayerSprite.adjustXCoordWithinBlock
; moving north
	ld a, [wMapViewVRAMPointer]
	sub $40
	ld [wMapViewVRAMPointer], a
	jr nc, AdvancePlayerSprite.adjustXCoordWithinBlock
	ld a, [wMapViewVRAMPointer + 1]
	dec a
	and $03
	or $98
	ld [wMapViewVRAMPointer + 1], a
AdvancePlayerSprite.adjustXCoordWithinBlock
	ld a, c
	and a
	jr z, AdvancePlayerSprite.pointlessJump ; mistake?
AdvancePlayerSprite.pointlessJump
	ld hl, wXBlockCoord
	ld a, [hl]
	add c
	ld [hl], a
	cp $02
	jr nz, AdvancePlayerSprite.checkForMoveToWestBlock
; moved into the tile block to the east
	xor a
	ld [hl], a
	ld hl, wXOffsetSinceLastSpecialWarp
	inc [hl]
	ld de, wCurrentTileBlockMapViewPointer
	call MoveTileBlockMapPointerEast
	jr AdvancePlayerSprite.updateMapView
AdvancePlayerSprite.checkForMoveToWestBlock
	cp $ff
	jr nz, AdvancePlayerSprite.adjustYCoordWithinBlock
; moved into the tile block to the west
	ld a, $01
	ld [hl], a
	ld hl, wXOffsetSinceLastSpecialWarp
	dec [hl]
	ld de, wCurrentTileBlockMapViewPointer
	call MoveTileBlockMapPointerWest
	jr AdvancePlayerSprite.updateMapView
AdvancePlayerSprite.adjustYCoordWithinBlock
	ld hl, wYBlockCoord
	ld a, [hl]
	add b
	ld [hl], a
	cp $02
	jr nz, AdvancePlayerSprite.checkForMoveToNorthBlock
; moved into the tile block to the south
	xor a
	ld [hl], a
	ld hl, wYOffsetSinceLastSpecialWarp
	inc [hl]
	ld de, wCurrentTileBlockMapViewPointer
	ld a, [wCurMapWidth]
	call MoveTileBlockMapPointerSouth
	jr AdvancePlayerSprite.updateMapView
AdvancePlayerSprite.checkForMoveToNorthBlock
	cp $ff
	jr nz, AdvancePlayerSprite.updateMapView
; moved into the tile block to the north
	ld a, $01
	ld [hl], a
	ld hl, wYOffsetSinceLastSpecialWarp
	dec [hl]
	ld de, wCurrentTileBlockMapViewPointer
	ld a, [wCurMapWidth]
	call MoveTileBlockMapPointerNorth
AdvancePlayerSprite.updateMapView
	call LoadCurrentMapView
	ld a, [wSpritePlayerStateData1YStepVector]
	cp $01
	jr nz, AdvancePlayerSprite.checkIfMovingNorth2
; if moving south
	call ScheduleSouthRowRedraw
	jr AdvancePlayerSprite.scrollBackgroundAndSprites
AdvancePlayerSprite.checkIfMovingNorth2
	cp $ff
	jr nz, AdvancePlayerSprite.checkIfMovingEast2
; if moving north
	call ScheduleNorthRowRedraw
	jr AdvancePlayerSprite.scrollBackgroundAndSprites
AdvancePlayerSprite.checkIfMovingEast2
	ld a, [wSpritePlayerStateData1XStepVector]
	cp $01
	jr nz, AdvancePlayerSprite.checkIfMovingWest2
; if moving east
	call ScheduleEastColumnRedraw
	jr AdvancePlayerSprite.scrollBackgroundAndSprites
AdvancePlayerSprite.checkIfMovingWest2
	cp $ff
	jr nz, AdvancePlayerSprite.scrollBackgroundAndSprites
; if moving west
	call ScheduleWestColumnRedraw
AdvancePlayerSprite.scrollBackgroundAndSprites
	ld a, [wSpritePlayerStateData1YStepVector]
	ld b, a
	ld a, [wSpritePlayerStateData1XStepVector]
	ld c, a
	sla b
	sla c
	ldh a, [lobyte(hSCY)]
	add b
	ldh [lobyte(hSCY)], a ; update background scroll Y
	ldh a, [lobyte(hSCX)]
	add c
	ldh [lobyte(hSCX)], a ; update background scroll X
; shift all the sprites in the direction opposite of the player's motion
; so that the player appears to move relative to them
	ld hl, wSprite01StateData1YPixels
	ld a, [wNumSprites]
	and a ; are there any sprites?
	jr z, AdvancePlayerSprite.done
	ld e, a
AdvancePlayerSprite.spriteShiftLoop
	ld a, [hl]
	sub b
	ld [hli], a
	inc l
	ld a, [hl]
	sub c
	ld [hl], a
	ld a, $0e
	add l
	ld l, a
	dec e
	jr nz, AdvancePlayerSprite.spriteShiftLoop
AdvancePlayerSprite.done
	ret

; the following four functions are used to move the pointer to the upper left
; corner of the tile block map in the direction of motion

MoveTileBlockMapPointerEast:
	ld a, [de]
	add $01
	ld [de], a
	ret nc
	inc de
	ld a, [de]
	inc a
	ld [de], a
	ret

MoveTileBlockMapPointerWest:
	ld a, [de]
	sub $01
	ld [de], a
	ret nc
	inc de
	ld a, [de]
	dec a
	ld [de], a
	ret

MoveTileBlockMapPointerSouth:
	add MAP_BORDER * 2
	ld b, a
	ld a, [de]
	add b
	ld [de], a
	ret nc
	inc de
	ld a, [de]
	inc a
	ld [de], a
	ret

MoveTileBlockMapPointerNorth:
	add MAP_BORDER * 2
	ld b, a
	ld a, [de]
	sub b
	ld [de], a
	ret nc
	inc de
	ld a, [de]
	dec a
	ld [de], a
	ret

; the following 6 functions are used to tell the V-blank handler to redraw
; the portion of the map that was newly exposed due to the player's movement

ScheduleNorthRowRedraw:
	hlcoord 0, 0
	call CopyToRedrawRowOrColumnSrcTiles
	ld a, [wMapViewVRAMPointer]
	ldh [lobyte(hRedrawRowOrColumnDest)], a
	ld a, [wMapViewVRAMPointer + 1]
	ldh [lobyte(hRedrawRowOrColumnDest + 1)], a
	ld a, REDRAW_ROW
	ldh [lobyte(hRedrawRowOrColumnMode)], a
	ret

CopyToRedrawRowOrColumnSrcTiles:
	ld de, wRedrawRowOrColumnSrcTiles
	ld c, 2 * SCREEN_WIDTH
CopyToRedrawRowOrColumnSrcTiles.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, CopyToRedrawRowOrColumnSrcTiles.loop
	ret

ScheduleSouthRowRedraw:
	hlcoord 0, 16
	call CopyToRedrawRowOrColumnSrcTiles
	ld a, [wMapViewVRAMPointer]
	ld l, a
	ld a, [wMapViewVRAMPointer + 1]
	ld h, a
	ld bc, $200
	add hl, bc
	ld a, h
	and $03
	or $98
	ldh [lobyte(hRedrawRowOrColumnDest + 1)], a
	ld a, l
	ldh [lobyte(hRedrawRowOrColumnDest)], a
	ld a, REDRAW_ROW
	ldh [lobyte(hRedrawRowOrColumnMode)], a
	ret

ScheduleEastColumnRedraw:
	hlcoord 18, 0
	call ScheduleColumnRedrawHelper
	ld a, [wMapViewVRAMPointer]
	ld c, a
	and $e0
	ld b, a
	ld a, c
	add 18
	and $1f
	or b
	ldh [lobyte(hRedrawRowOrColumnDest)], a
	ld a, [wMapViewVRAMPointer + 1]
	ldh [lobyte(hRedrawRowOrColumnDest + 1)], a
	ld a, REDRAW_COL
	ldh [lobyte(hRedrawRowOrColumnMode)], a
	ret

ScheduleColumnRedrawHelper:
	ld de, wRedrawRowOrColumnSrcTiles
	ld c, SCREEN_HEIGHT
ScheduleColumnRedrawHelper.loop
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld a, SCREEN_WIDTH - 1
	add l
	ld l, a
	jr nc, ScheduleColumnRedrawHelper.noCarry
	inc h
ScheduleColumnRedrawHelper.noCarry
	dec c
	jr nz, ScheduleColumnRedrawHelper.loop
	ret

ScheduleWestColumnRedraw:
	hlcoord 0, 0
	call ScheduleColumnRedrawHelper
	ld a, [wMapViewVRAMPointer]
	ldh [lobyte(hRedrawRowOrColumnDest)], a
	ld a, [wMapViewVRAMPointer + 1]
	ldh [lobyte(hRedrawRowOrColumnDest + 1)], a
	ld a, REDRAW_COL
	ldh [lobyte(hRedrawRowOrColumnMode)], a
	ret

; function to write the tiles that make up a tile block to memory
; Input: c = tile block ID, hl = destination address
DrawTileBlock:
	push hl
	ld a, [wTilesetBlocksPtr] ; pointer to tiles
	ld l, a
	ld a, [wTilesetBlocksPtr + 1]
	ld h, a
	ld a, c
	swap a
	ld b, a
	and $f0
	ld c, a
	ld a, b
	and $0f
	ld b, a ; bc = tile block ID * 0x10
	add hl, bc
	ld d, h
	ld e, l ; de = address of the tile block's tiles
	pop hl
	ld c, BLOCK_HEIGHT ; 4 loop iterations
DrawTileBlock.loop ; each loop iteration, write 4 tile numbers
	push bc
.REPT BLOCK_WIDTH - 1
	ld a, [de]
	ld [hli], a
	inc de
.ENDR
	ld a, [de]
	ld [hl], a
	inc de
	ld bc, SURROUNDING_WIDTH - (BLOCK_WIDTH - 1)
	add hl, bc
	pop bc
	dec c
	jr nz, DrawTileBlock.loop
	ret

; function to update joypad state and simulate button presses
JoypadOverworld:
	xor a
	ld [wSpritePlayerStateData1YStepVector], a
	ld [wSpritePlayerStateData1XStepVector], a
	call RunMapScript
	call Joypad
	ld a, [wStatusFlags7]
	bit BIT_TRAINER_BATTLE, a
	jr nz, JoypadOverworld.notForcedDownwards
	ld a, [wCurMap]
	cp ROUTE_17 ; Cycling Road
	jr nz, JoypadOverworld.notForcedDownwards
	ldh a, [lobyte(hJoyHeld)]
	and PAD_CTRL_PAD | PAD_B | PAD_A
	jr nz, JoypadOverworld.notForcedDownwards
	ld a, PAD_DOWN
	ldh [lobyte(hJoyHeld)], a ; on the cycling road, if there isn't a trainer and the player isn't pressing buttons, simulate a down press
JoypadOverworld.notForcedDownwards
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	ret z
; if simulating button presses
	ldh a, [lobyte(hJoyHeld)]
	ld b, a
	ld a, [wOverrideSimulatedJoypadStatesMask] ; bit mask for button presses that override simulated ones
	and b
	ret nz ; return if the simulated button presses are overridden
	ld hl, wSimulatedJoypadStatesIndex
	dec [hl]
	ld a, [hl]
	cp $ff
	jr z, JoypadOverworld.doneSimulating ; if the end of the simulated button presses has been reached
	ld hl, wSimulatedJoypadStatesEnd
	add l
	ld l, a
	jr nc, JoypadOverworld.noCarry
	inc h
JoypadOverworld.noCarry
	ld a, [hl]
	ldh [lobyte(hJoyHeld)], a ; store simulated button press in joypad state
	and a
	ret nz
	ldh [lobyte(hJoyPressed)], a
	ldh [lobyte(hJoyReleased)], a
	ret

; if done simulating button presses
JoypadOverworld.doneSimulating
	xor a
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesEnd], a
	ld [wJoyIgnore], a
	ldh [lobyte(hJoyHeld)], a
	ld hl, wMovementFlags
	ld a, [hl]
	and (1 << BIT_SPINNING) | (1 << BIT_LEDGE_OR_FISHING) | (1 << 5) | (1 << 4) | (1 << 3)
	ld [hl], a
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ret

; function to check the tile ahead to determine if the character should get on land or keep surfing
; sets carry if there is a collision and clears carry otherwise
; It seems that this function has a bug in it, but due to luck, it doesn't
; show up. After detecting a sprite collision, it jumps to the code that
; checks if the next tile is passable instead of just directly jumping to the
; "collision detected" code. However, it doesn't store the next tile in c,
; so the old value of c is used. 2429 is always called before this function,
; and 2429 always sets c to 0xF0. There is no 0xF0 background tile, so it
; is considered impassable and it is detected as a collision.
CollisionCheckOnWater:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	jp nz, CollisionCheckOnWater.noCollision ; return and clear carry if button presses are being simulated
	ld a, [wPlayerDirection] ; the direction that the player is trying to go in
	ld d, a
	ld a, [wSpritePlayerStateData1CollisionData]
	and d ; check if a sprite is in the direction the player is trying to go
	jr nz, CollisionCheckOnWater.checkIfNextTileIsPassable ; bug?
	ld hl, TilePairCollisionsWater
	call CheckForJumpingAndTilePairCollisions
	jr c, CollisionCheckOnWater.collision
	predef GetTileAndCoordsInFrontOfPlayer ; get tile in front of player (puts it in c and [wTileInFrontOfPlayer])
	ld a, [wTileInFrontOfPlayer] ; tile in front of player
	cp $14 ; water tile
	jr z, CollisionCheckOnWater.noCollision ; keep surfing if it's a water tile
	cp $32 ; either the left tile of the S.S. Anne boarding platform or the tile on eastern coastlines (depending on the current tileset)
	jr z, CollisionCheckOnWater.checkIfVermilionDockTileset
	cp $48 ; tile on right on coast lines in Safari Zone
	jr z, CollisionCheckOnWater.noCollision ; keep surfing
; check if the [land] tile in front of the player is passable
CollisionCheckOnWater.checkIfNextTileIsPassable
	ld hl, wTilesetCollisionPtr ; pointer to list of passable tiles
	ld a, [hli]
	ld h, [hl]
	ld l, a
CollisionCheckOnWater.loop
	ld a, [hli]
	cp $ff
	jr z, CollisionCheckOnWater.collision
	cp c
	jr z, CollisionCheckOnWater.stopSurfing ; stop surfing if the tile is passable
	jr CollisionCheckOnWater.loop
CollisionCheckOnWater.collision
	ld a, [wChannelSoundIDs + CHAN5]
	cp SFX_COLLISION ; check if collision sound is already playing
	jr z, CollisionCheckOnWater.setCarry
	ld a, SFX_COLLISION
	call PlaySound ; play collision sound (if it's not already playing)
CollisionCheckOnWater.setCarry
	scf
	jr CollisionCheckOnWater.done
CollisionCheckOnWater.noCollision
	and a
CollisionCheckOnWater.done
	ret
CollisionCheckOnWater.stopSurfing
	xor a
	ld [wWalkBikeSurfState], a
	call LoadPlayerSpriteGraphics
	call PlayDefaultMusic
	jr CollisionCheckOnWater.noCollision
CollisionCheckOnWater.checkIfVermilionDockTileset
	ld a, [wCurMapTileset]
	cp SHIP_PORT ; Vermilion Dock tileset
	jr nz, CollisionCheckOnWater.noCollision ; keep surfing if it's not the boarding platform tile
	jr CollisionCheckOnWater.stopSurfing ; if it is the boarding platform tile, stop surfing

; function to run the current map's script
RunMapScript:
	push hl
	push de
	push bc
	farcall TryPushingBoulder
	ld a, [wMiscFlags]
	bit BIT_BOULDER_DUST, a
	jr z, RunMapScript.afterBoulderEffect
	farcall DoBoulderDustAnimation
RunMapScript.afterBoulderEffect
	pop bc
	pop de
	pop hl
	call RunNPCMovementScript
	ld a, [wCurMap] ; current map number
	call SwitchToMapRomBank ; change to the ROM bank the map's data is in
	ld hl, wCurMapScriptPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, RunMapScript.return
	push de
	jp hl ; jump to script
RunMapScript.return
	ret

LoadWalkingPlayerSpriteGraphics:
	ld de, RedSprite
	ld hl, vNPCSprites
	jr LoadPlayerSpriteGraphicsCommon

LoadSurfingPlayerSpriteGraphics:
	ld de, SeelSprite
	ld hl, vNPCSprites
	jr LoadPlayerSpriteGraphicsCommon

LoadBikePlayerSpriteGraphics:
	ld de, RedBikeSprite
	ld hl, vNPCSprites

LoadPlayerSpriteGraphicsCommon:
	push de
	push hl
	lb "bc", bank(RedSprite), $0c
	call CopyVideoData
	pop hl
	pop de
	ld a, $c0
	add e
	ld e, a
	jr nc, LoadPlayerSpriteGraphicsCommon.noCarry
	inc d
LoadPlayerSpriteGraphicsCommon.noCarry
	set 3, h ; add $800 ($80 * TILE_SIZE) to hl (1 << 3 = $8)
	lb "bc", bank(RedSprite), $0c
	jp CopyVideoData

; function to load data from the map header
LoadMapHeader:
	farcall MarkTownVisitedAndLoadToggleableObjects
	ld a, [wCurMapTileset]
	ld [wUnusedCurMapTilesetCopy], a
	ld a, [wCurMap]
	call SwitchToMapRomBank
	ld a, [wCurMapTileset]
	ld b, a
	res BIT_NO_PREVIOUS_MAP, a
	ld [wCurMapTileset], a
	ldh [lobyte(hPreviousTileset)], a
	bit BIT_NO_PREVIOUS_MAP, b
	ret nz
	ld hl, MapHeaderPointers
	ld a, [wCurMap]
	sla a
	jr nc, LoadMapHeader.noCarry1
	inc h
LoadMapHeader.noCarry1
	add l
	ld l, a
	jr nc, LoadMapHeader.noCarry2
	inc h
LoadMapHeader.noCarry2
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = base of map header
	ld de, wCurMapHeader
	ld c, wCurMapHeaderEnd - wCurMapHeader
LoadMapHeader.copyFixedHeaderLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, LoadMapHeader.copyFixedHeaderLoop
; initialize all the connected maps to disabled at first, before loading the actual values
	ld a, $ff
	ld [wNorthConnectedMap], a
	ld [wSouthConnectedMap], a
	ld [wWestConnectedMap], a
	ld [wEastConnectedMap], a
; copy connection data (if any) to WRAM
	ld a, [wCurMapConnections]
	ld b, a
; check north
	bit NORTH_F, b
	jr z, LoadMapHeader.checkSouth
	ld de, wNorthConnectionHeader
	call CopyMapConnectionHeader
LoadMapHeader.checkSouth
	bit SOUTH_F, b
	jr z, LoadMapHeader.checkWest
	ld de, wSouthConnectionHeader
	call CopyMapConnectionHeader
LoadMapHeader.checkWest
	bit WEST_F, b
	jr z, LoadMapHeader.checkEast
	ld de, wWestConnectionHeader
	call CopyMapConnectionHeader
LoadMapHeader.checkEast
	bit EAST_F, b
	jr z, LoadMapHeader.getObjectDataPointer
	ld de, wEastConnectionHeader
	call CopyMapConnectionHeader
LoadMapHeader.getObjectDataPointer
	ld a, [hli]
	ld [wObjectDataPointerTemp], a
	ld a, [hli]
	ld [wObjectDataPointerTemp + 1], a
	push hl
	ld a, [wObjectDataPointerTemp]
	ld l, a
	ld a, [wObjectDataPointerTemp + 1]
	ld h, a ; hl = base of object data
	ld de, wMapBackgroundTile
	ld a, [hli]
	ld [de], a
; load warp data
	ld a, [hli]
	ld [wNumberOfWarps], a
	and a
	jr z, LoadMapHeader.loadSignData
	ld c, a
	ld de, wWarpEntries
LoadMapHeader.warpLoop ; one warp per loop iteration
	ld b, 4
LoadMapHeader.warpInnerLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, LoadMapHeader.warpInnerLoop
	dec c
	jr nz, LoadMapHeader.warpLoop
LoadMapHeader.loadSignData
	ld a, [hli] ; number of signs
	ld [wNumSigns], a
	and a ; are there any signs?
	jr z, LoadMapHeader.loadSpriteData ; if not, skip this
	ld c, a
	ld de, wSignTextIDs
	ld a, d
	ldh [lobyte(hSignCoordPointer)], a
	ld a, e
	ldh [lobyte(hSignCoordPointer + 1)], a
	ld de, wSignCoords
LoadMapHeader.signLoop
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	push de
	ldh a, [lobyte(hSignCoordPointer)]
	ld d, a
	ldh a, [lobyte(hSignCoordPointer + 1)]
	ld e, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, d
	ldh [lobyte(hSignCoordPointer)], a
	ld a, e
	ldh [lobyte(hSignCoordPointer + 1)], a
	pop de
	dec c
	jr nz, LoadMapHeader.signLoop
LoadMapHeader.loadSpriteData
	ld a, [wStatusFlags4]
	bit BIT_BATTLE_OVER_OR_BLACKOUT, a
	jp nz, LoadMapHeader.finishUp ; if so, skip this because battles don't destroy this data
	ld a, [hli]
	ld [wNumSprites], a ; save the number of sprites
	push hl
; zero out sprite state data for sprites 01-15
	ld hl, wSprite01StateData1
	ld de, wSprite01StateData2
	xor a
	ld b, $f0
LoadMapHeader.zeroSpriteDataLoop
	ld [hli], a
	ld [de], a
	inc e
	dec b
	jr nz, LoadMapHeader.zeroSpriteDataLoop
; disable SPRITESTATEDATA1_IMAGEINDEX (set to $ff) for sprites 01-15
	ld hl, wSprite01StateData1ImageIndex
	ld de, SPRITESTATEDATA1_LENGTH
	ld c, NUM_SPRITESTATEDATA_STRUCTS - 1
LoadMapHeader.disableSpriteEntriesLoop
	ld [hl], $ff
	add hl, de
	dec c
	jr nz, LoadMapHeader.disableSpriteEntriesLoop
	pop hl
	ld de, wSprite01StateData1
	ld a, [wNumSprites] ; number of sprites
	and a ; are there any sprites?
	jp z, LoadMapHeader.finishUp ; if there are no sprites, skip the rest
	ld b, a
	ld c, $00
LoadMapHeader.loadSpriteLoop
	ld a, [hli]
	ld [de], a ; x#SPRITESTATEDATA1_PICTUREID
	inc d
	ld a, $04
	add e
	ld e, a
	ld a, [hli]
	ld [de], a ; x#SPRITESTATEDATA2_MAPY
	inc e
	ld a, [hli]
	ld [de], a ; x#SPRITESTATEDATA2_MAPX
	inc e
	ld a, [hli]
	ld [de], a ; x#SPRITESTATEDATA2_MOVEMENTBYTE1
	ld a, [hli]
	ldh [lobyte(hLoadSpriteTemp1)], a ; save movement byte 2
	ld a, [hli]
	ldh [lobyte(hLoadSpriteTemp2)], a ; save text ID and flags byte
	push bc
	push hl
	ld b, $00
	ld hl, wMapSpriteData
	add hl, bc
	ldh a, [lobyte(hLoadSpriteTemp1)]
	ld [hli], a ; store movement byte 2 in byte 0 of sprite entry
	ldh a, [lobyte(hLoadSpriteTemp2)]
	ld [hl], a ; this appears pointless, since the value is overwritten immediately after
	ldh a, [lobyte(hLoadSpriteTemp2)]
	ldh [lobyte(hLoadSpriteTemp1)], a
	and $3f
	ld [hl], a ; store text ID in byte 1 of sprite entry
	pop hl
	ldh a, [lobyte(hLoadSpriteTemp1)]
	bit BIT_TRAINER, a
	jr nz, LoadMapHeader.trainerSprite
	bit BIT_ITEM, a
	jr nz, LoadMapHeader.itemBallSprite
	jr LoadMapHeader.regularSprite
LoadMapHeader.trainerSprite
	ld a, [hli]
	ldh [lobyte(hLoadSpriteTemp1)], a ; save trainer class
	ld a, [hli]
	ldh [lobyte(hLoadSpriteTemp2)], a ; save trainer number (within class)
	push hl
	ld hl, wMapSpriteExtraData
	add hl, bc
	ldh a, [lobyte(hLoadSpriteTemp1)]
	ld [hli], a ; store trainer class in byte 0 of the entry
	ldh a, [lobyte(hLoadSpriteTemp2)]
	ld [hl], a ; store trainer number in byte 1 of the entry
	pop hl
	jr LoadMapHeader.nextSprite
LoadMapHeader.itemBallSprite
	ld a, [hli]
	ldh [lobyte(hLoadSpriteTemp1)], a ; save item number
	push hl
	ld hl, wMapSpriteExtraData
	add hl, bc
	ldh a, [lobyte(hLoadSpriteTemp1)]
	ld [hli], a ; store item number in byte 0 of the entry
	xor a
	ld [hl], a ; zero byte 1, since it is not used
	pop hl
	jr LoadMapHeader.nextSprite
LoadMapHeader.regularSprite
	push hl
	ld hl, wMapSpriteExtraData
	add hl, bc
; zero both bytes, since regular sprites don't use this extra space
	xor a
	ld [hli], a
	ld [hl], a
	pop hl
LoadMapHeader.nextSprite
	pop bc
	dec d
	ld a, $0a
	add e
	ld e, a
	inc c
	inc c
	dec b
	jp nz, LoadMapHeader.loadSpriteLoop
LoadMapHeader.finishUp
	predef LoadTilesetHeader
	callfar LoadWildData
	pop hl ; restore hl from before going to the warp/sign/sprite data (this value was saved for seemingly no purpose)
	ld a, [wCurMapHeight] ; map height in 4x4 tile blocks
	add a ; double it
	ld [wCurrentMapHeight2], a ; store map height in 2x2 tile blocks
	ld a, [wCurMapWidth] ; map width in 4x4 tile blocks
	add a ; double it
	ld [wCurrentMapWidth2], a ; map width in 2x2 tile blocks
	ld a, [wCurMap]
	ld c, a
	ld b, $00
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, bank(MapSongBanks)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ld hl, MapSongBanks
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wMapMusicSoundID], a ; music 1
	ld a, [hl]
	ld [wMapMusicROMBank], a ; music 2
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

; function to copy map connection data from ROM to WRAM
; Input: hl = source, de = destination
CopyMapConnectionHeader:
	ld c, $0b
CopyMapConnectionHeader.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, CopyMapConnectionHeader.loop
	ret

; function to load map data
LoadMapData:
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	call DisableLCD
	ld a, hibyte(vBGMap0)
	ld [wMapViewVRAMPointer + 1], a
	xor a
	ld [wMapViewVRAMPointer], a
	ldh [lobyte(hSCY)], a
	ldh [lobyte(hSCX)], a
	ld [wWalkCounter], a
	ld [wUnusedCurMapTilesetCopy], a
	ld [wWalkBikeSurfStateCopy], a
	ld [wSpriteSetID], a
	call LoadTextBoxTilePatterns
	call LoadMapHeader
	farcall InitMapSprites ; load tile pattern data for sprites
	call LoadTileBlockMap
	call LoadTilesetTilePatternData
	call LoadCurrentMapView
; copy current map view to VRAM
	hlcoord 0, 0
	ld de, vBGMap0
	ld b, SCREEN_HEIGHT
LoadMapData.vramCopyLoop
	ld c, SCREEN_WIDTH
LoadMapData.vramCopyInnerLoop
	ld a, [hli]
	ld [de], a
	inc e
	dec c
	jr nz, LoadMapData.vramCopyInnerLoop
	ld a, TILEMAP_WIDTH - SCREEN_WIDTH
	add e
	ld e, a
	jr nc, LoadMapData.noCarry
	inc d
LoadMapData.noCarry
	dec b
	jr nz, LoadMapData.vramCopyLoop
	ld a, $01
	ld [wUpdateSpritesEnabled], a
	call EnableLCD
	ld b, SET_PAL_OVERWORLD
	call RunPaletteCommand
	call LoadPlayerSpriteGraphics
	ld a, [wStatusFlags6]
	and (1 << BIT_FLY_WARP) | (1 << BIT_DUNGEON_WARP)
	jr nz, LoadMapData.restoreRomBank
	ld a, [wStatusFlags7]
	bit BIT_NO_MAP_MUSIC, a
	jr nz, LoadMapData.restoreRomBank
	call UpdateMusic6Times
	call PlayDefaultMusicFadeOutCurrent
LoadMapData.restoreRomBank
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

; function to switch to the ROM bank that a map is stored in
; Input: a = map number
SwitchToMapRomBank:
	push hl
	push bc
	ld c, a
	ld b, $00
	ld a, bank(MapHeaderBanks)
	call BankswitchHome
	ld hl, MapHeaderBanks
	add hl, bc
	ld a, [hl]
	ldh [lobyte(hMapROMBank)], a
	call BankswitchBack
	ldh a, [lobyte(hMapROMBank)]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	pop bc
	pop hl
	ret

IgnoreInputForHalfSecond:
	ld a, 30
	ld [wIgnoreInputCounter], a
	ld hl, wStatusFlags5
	ld a, [hl]
	or (1 << BIT_DISABLE_JOYPAD) | (1 << BIT_UNKNOWN_5_2) | (1 << BIT_UNKNOWN_5_1)
	ld [hl], a ; set ignore input bit
	ret

ResetUsingStrengthOutOfBattleBit:
	ld hl, wStatusFlags1
	res BIT_STRENGTH_ACTIVE, [hl]
	ret

ForceBikeOrSurf:
	ld b, bank(RedSprite)
	ld hl, LoadPlayerSpriteGraphics ; in bank 0
	call Bankswitch
	jp PlayDefaultMusic ; update map/player state?

CheckForUserInterruption:
; Return carry if Up+Select+B, Start or A are pressed in c frames.
; Used only in the intro and title screen.
	call DelayFrame

	push bc
	call JoypadLowSensitivity
	pop bc

	ldh a, [lobyte(hJoyHeld)]
	cp PAD_UP + PAD_SELECT + PAD_B
	jr z, CheckForUserInterruption.input

	ldh a, [lobyte(hJoy5)]
.IF defined(_DEBUG)
	and PAD_START | PAD_SELECT | PAD_A
.ELSE
	and PAD_START | PAD_A
.ENDIF
	jr nz, CheckForUserInterruption.input

	dec c
	jr nz, CheckForUserInterruption

	and a
	ret

CheckForUserInterruption.input
	scf
	ret

; function to load position data for destination warp when switching maps
; INPUT:
; a = ID of destination warp within destination map
LoadDestinationWarpPosition:
	ld b, a
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, [wPredefParentBank]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ld a, b
	add a
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld bc, 4
	ld de, wCurrentTileBlockMapViewPointer
	call CopyData
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret
