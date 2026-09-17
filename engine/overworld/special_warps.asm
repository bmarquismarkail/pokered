PrepareForSpecialWarp:
	call LoadSpecialWarpData
	predef LoadTilesetHeader
	ld hl, wStatusFlags6
	bit BIT_FLY_OR_DUNGEON_WARP, [hl]
	res BIT_FLY_OR_DUNGEON_WARP, [hl]
	jr z, PrepareForSpecialWarp.debugNewGameWarp
	ld a, [wDestinationMap]
	jr PrepareForSpecialWarp.next
PrepareForSpecialWarp.debugNewGameWarp
	bit BIT_DEBUG_MODE, [hl]
	jr z, PrepareForSpecialWarp.setNewGameMatWarp ; apply to StartNewGameDebug only
	call PrepareNewGameDebug
PrepareForSpecialWarp.setNewGameMatWarp
	; This is called by OakSpeech during StartNewGame and
	; loads the first warp event for the specified map index.
	ld a, PALLET_TOWN
PrepareForSpecialWarp.next
	ld b, a
	ld a, [wStatusFlags3]
	and a ; ???
	jr nz, PrepareForSpecialWarp.next2
	ld a, b
PrepareForSpecialWarp.next2
	ld hl, wStatusFlags6
	bit BIT_DUNGEON_WARP, [hl]
	ret nz
	ld [wLastMap], a
	ret

LoadSpecialWarpData:
	ld a, [wCableClubDestinationMap]
	cp TRADE_CENTER
	jr nz, LoadSpecialWarpData.notTradeCenter
	ld hl, TradeCenterPlayerWarp
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_INTERNAL_CLOCK
	jr z, LoadSpecialWarpData.copyWarpData
	ld hl, TradeCenterFriendWarp
	jr LoadSpecialWarpData.copyWarpData
LoadSpecialWarpData.notTradeCenter
	cp COLOSSEUM
	jr nz, LoadSpecialWarpData.notColosseum
	ld hl, ColosseumPlayerWarp
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_INTERNAL_CLOCK
	jr z, LoadSpecialWarpData.copyWarpData
	ld hl, ColosseumFriendWarp
	jr LoadSpecialWarpData.copyWarpData
LoadSpecialWarpData.notColosseum
	ld a, [wStatusFlags6]
	bit BIT_DEBUG_MODE, a
	; warp to wLastMap (PALLET_TOWN) for StartNewGameDebug
	jr nz, LoadSpecialWarpData.notNewGameWarp
	bit BIT_FLY_OR_DUNGEON_WARP, a
	jr nz, LoadSpecialWarpData.notNewGameWarp
	ld hl, NewGameWarp
LoadSpecialWarpData.copyWarpData
	ld de, wCurMap
	ld c, $7
LoadSpecialWarpData.copyWarpDataLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, LoadSpecialWarpData.copyWarpDataLoop
	ld a, [hli]
	ld [wCurMapTileset], a
	xor a
	jr LoadSpecialWarpData.done
LoadSpecialWarpData.notNewGameWarp
	ld a, [wLastMap] ; this value is overwritten before it's ever read
	ld hl, wStatusFlags6
	bit BIT_DUNGEON_WARP, [hl]
	jr nz, LoadSpecialWarpData.usedDungeonWarp
	bit BIT_ESCAPE_WARP, [hl]
	res BIT_ESCAPE_WARP, [hl]
	jr z, LoadSpecialWarpData.otherDestination
	ld a, [wLastBlackoutMap]
	jr LoadSpecialWarpData.usedFlyWarp
LoadSpecialWarpData.usedDungeonWarp
	ld hl, wStatusFlags3
	res BIT_ON_DUNGEON_WARP, [hl]
	ld a, [wDungeonWarpDestinationMap]
	ld b, a
	ld [wCurMap], a
	ld a, [wWhichDungeonWarp]
	ld c, a
	ld hl, DungeonWarpList
	ld de, 0
	ld a, 6
	ld [wDungeonWarpDataEntrySize], a
LoadSpecialWarpData.dungeonWarpListLoop
	ld a, [hli]
	cp b
	jr z, LoadSpecialWarpData.matchedDungeonWarpDestinationMap
	inc hl
	jr LoadSpecialWarpData.nextDungeonWarp
LoadSpecialWarpData.matchedDungeonWarpDestinationMap
	ld a, [hli]
	cp c
	jr z, LoadSpecialWarpData.matchedDungeonWarpID
LoadSpecialWarpData.nextDungeonWarp
	ld a, [wDungeonWarpDataEntrySize]
	add e
	ld e, a
	jr LoadSpecialWarpData.dungeonWarpListLoop
LoadSpecialWarpData.matchedDungeonWarpID
	ld hl, DungeonWarpData
	add hl, de
	jr LoadSpecialWarpData.copyWarpData2
LoadSpecialWarpData.otherDestination
	ld a, [wDestinationMap]
LoadSpecialWarpData.usedFlyWarp
	ld b, a
	ld [wCurMap], a
	ld hl, FlyWarpDataPtr
LoadSpecialWarpData.flyWarpDataPtrLoop
	ld a, [hli]
	inc hl
	cp b
	jr z, LoadSpecialWarpData.foundFlyWarpMatch
	inc hl
	inc hl
	jr LoadSpecialWarpData.flyWarpDataPtrLoop
LoadSpecialWarpData.foundFlyWarpMatch
	ld a, [hli]
	ld h, [hl]
	ld l, a
LoadSpecialWarpData.copyWarpData2
	ld de, wCurrentTileBlockMapViewPointer
	ld c, $6
LoadSpecialWarpData.copyWarpDataLoop2
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, LoadSpecialWarpData.copyWarpDataLoop2
	xor a ; OVERWORLD
	ld [wCurMapTileset], a
LoadSpecialWarpData.done
	ld [wYOffsetSinceLastSpecialWarp], a
	ld [wXOffsetSinceLastSpecialWarp], a
	ld a, -1 ; exclude normal warps
	ld [wDestinationWarpID], a
	ret

.INCLUDE "data/maps/special_warps.asm"
