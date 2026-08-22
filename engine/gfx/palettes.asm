_RunPaletteCommand:
WLA_GLOBAL_RunPaletteCommand:
	call GetPredefRegisters
	ld a, b
	cp SET_PAL_DEFAULT
	jr nz, WLA_GLOBAL_RunPaletteCommand__not_default
	ld a, [wDefaultPaletteCommand]
_RunPaletteCommand.not_default:
WLA_GLOBAL_RunPaletteCommand__not_default:
	cp SET_PAL_PARTY_MENU_HP_BARS
	jp z, UpdatePartyMenuBlkPacket
	ld l, a
	ld h, 0
	add hl, hl
	ld de, SetPalFunctions
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, SendSGBPackets
	push de
	jp hl

SetPal_BattleBlack:
	ld hl, PalPacket_Black
	ld de, BlkPacket_Battle
	ret

; uses PalPacket_Empty to build a packet based on mon IDs and health color
SetPal_Battle:
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wPlayerBattleStatus3]
	ld hl, wBattleMonSpecies
	call DeterminePaletteID
	ld b, a
	ld a, [wEnemyBattleStatus3]
	ld hl, wEnemyMonSpecies2
	call DeterminePaletteID
	ld c, a
	ld hl, wPalPacket + 1
	ld a, [wPlayerHPBarColor]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	ld a, [wEnemyHPBarColor]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	ld a, b
	ld [hli], a
	inc hl
	ld a, c
	ld [hl], a
	ld hl, wPalPacket
	ld de, BlkPacket_Battle
	ld a, SET_PAL_BATTLE
	ld [wDefaultPaletteCommand], a
	ret

SetPal_TownMap:
	ld hl, PalPacket_TownMap
	ld de, BlkPacket_WholeScreen
	ret

; uses PalPacket_Empty to build a packet based the mon ID
SetPal_StatusScreen:
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wCurPartySpecies]
	cp NUM_POKEMON_INDEXES + 1
	jr c, SetPal_StatusScreen.pokemon
	ld a, $1 ; not pokemon
SetPal_StatusScreen.pokemon
	call DeterminePaletteIDOutOfBattle
	push af
	ld hl, wPalPacket + 1
	ld a, [wStatusScreenHPBarColor]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	pop af
	ld [hl], a
	ld hl, wPalPacket
	ld de, BlkPacket_StatusScreen
	ret

SetPal_PartyMenu:
	ld hl, PalPacket_PartyMenu
	ld de, wPartyMenuBlkPacket
	ret

SetPal_Pokedex:
	ld hl, PalPacket_Pokedex
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wCurPartySpecies]
	call DeterminePaletteIDOutOfBattle
	ld hl, wPalPacket + 3
	ld [hl], a
	ld hl, wPalPacket
	ld de, BlkPacket_Pokedex
	ret

SetPal_Slots:
	ld hl, PalPacket_Slots
	ld de, BlkPacket_Slots
	ret

SetPal_TitleScreen:
	ld hl, PalPacket_Titlescreen
	ld de, BlkPacket_Titlescreen
	ret

; used mostly for menus and the Oak intro
SetPal_Generic:
	ld hl, PalPacket_Generic
	ld de, BlkPacket_WholeScreen
	ret

SetPal_NidorinoIntro:
	ld hl, PalPacket_NidorinoIntro
	ld de, BlkPacket_NidorinoIntro
	ret

SetPal_GameFreakIntro:
	ld hl, PalPacket_GameFreakIntro
	ld de, BlkPacket_GameFreakIntro
	ld a, SET_PAL_GENERIC
	ld [wDefaultPaletteCommand], a
	ret

; uses PalPacket_Empty to build a packet based on the current map
SetPal_Overworld:
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wCurMapTileset]
	cp CEMETERY
	jr z, SetPal_Overworld.PokemonTowerOrAgatha
	cp CAVERN
	jr z, SetPal_Overworld.caveOrBruno
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP
	jr c, SetPal_Overworld.townOrRoute
	cp CERULEAN_CAVE_2F
	jr c, SetPal_Overworld.normalDungeonOrBuilding
	cp CERULEAN_CAVE_1F + 1
	jr c, SetPal_Overworld.caveOrBruno
	cp LORELEIS_ROOM
	jr z, SetPal_Overworld.Lorelei
	cp BRUNOS_ROOM
	jr z, SetPal_Overworld.caveOrBruno
SetPal_Overworld.normalDungeonOrBuilding
	ld a, [wLastMap] ; town or route that current dungeon or building is located
SetPal_Overworld.townOrRoute
	cp NUM_CITY_MAPS
	jr c, SetPal_Overworld.town
	ld a, PAL_ROUTE - 1
SetPal_Overworld.town
	inc a ; a town's palette ID is its map ID + 1
	ld hl, wPalPacket + 1
	ld [hld], a
	ld de, BlkPacket_WholeScreen
	ld a, SET_PAL_OVERWORLD
	ld [wDefaultPaletteCommand], a
	ret
SetPal_Overworld.PokemonTowerOrAgatha
	ld a, PAL_GRAYMON - 1
	jr SetPal_Overworld.town
SetPal_Overworld.caveOrBruno
	ld a, PAL_CAVE - 1
	jr SetPal_Overworld.town
SetPal_Overworld.Lorelei
	xor a
	jr SetPal_Overworld.town

; used when a Pokemon is the only thing on the screen
; such as evolution, trading and the Hall of Fame
SetPal_PokemonWholeScreen:
	push bc
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	pop bc
	ld a, c
	and a
	ld a, PAL_BLACK
	jr nz, SetPal_PokemonWholeScreen.next
	ld a, [wWholeScreenPaletteMonSpecies]
	call DeterminePaletteIDOutOfBattle
SetPal_PokemonWholeScreen.next
	ld [wPalPacket + 1], a
	ld hl, wPalPacket
	ld de, BlkPacket_WholeScreen
	ret

SetPal_TrainerCard:
	ld hl, BlkPacket_TrainerCard
	ld de, wTrainerCardBlkPacket
	ld bc, $40
	call CopyData
	ld de, BadgeBlkDataLengths
	ld hl, wTrainerCardBlkPacket + 2
	ld a, [wObtainedBadges]
	ld c, NUM_BADGES
SetPal_TrainerCard.badgeLoop
	srl a
	push af
	jr c, SetPal_TrainerCard.haveBadge
; The player doesn't have the badge, so zero the badge's blk data.
	push bc
	ld a, [de]
	ld c, a
	xor a
SetPal_TrainerCard.zeroBadgeDataLoop
	ld [hli], a
	dec c
	jr nz, SetPal_TrainerCard.zeroBadgeDataLoop
	pop bc
	jr SetPal_TrainerCard.nextBadge
SetPal_TrainerCard.haveBadge
; The player does have the badge, so skip past the badge's blk data.
	ld a, [de]
SetPal_TrainerCard.skipBadgeDataLoop
	inc hl
	dec a
	jr nz, SetPal_TrainerCard.skipBadgeDataLoop
SetPal_TrainerCard.nextBadge
	pop af
	inc de
	dec c
	jr nz, SetPal_TrainerCard.badgeLoop
	ld hl, PalPacket_TrainerCard
	ld de, wTrainerCardBlkPacket
	ret

SetPalFunctions:
; entries correspond to SET_PAL_* constants
	.DW SetPal_BattleBlack
	.DW SetPal_Battle
	.DW SetPal_TownMap
	.DW SetPal_StatusScreen
	.DW SetPal_Pokedex
	.DW SetPal_Slots
	.DW SetPal_TitleScreen
	.DW SetPal_NidorinoIntro
	.DW SetPal_Generic
	.DW SetPal_Overworld
	.DW SetPal_PartyMenu
	.DW SetPal_PokemonWholeScreen
	.DW SetPal_GameFreakIntro
	.DW SetPal_TrainerCard

; The length of the blk data of each badge on the Trainer Card.
; The Rainbow Badge has 3 entries because of its many colors.
BadgeBlkDataLengths:
	.DB 6     ; Boulder Badge
	.DB 6     ; Cascade Badge
	.DB 6     ; Thunder Badge
	.DB 6 * 3 ; Rainbow Badge
	.DB 6     ; Soul Badge
	.DB 6     ; Marsh Badge
	.DB 6     ; Volcano Badge
	.DB 6     ; Earth Badge

DeterminePaletteID:
	bit TRANSFORMED, a ; a is battle status 3
	ld a, PAL_GRAYMON  ; if the mon has used Transform, use Ditto's palette
	ret nz
	ld a, [hl]
DeterminePaletteIDOutOfBattle:
	ld [wPokedexNum], a
	and a ; is the mon index 0?
	jr z, DeterminePaletteIDOutOfBattle.skipDexNumConversion
	push bc
	predef IndexToPokedex
	pop bc
	ld a, [wPokedexNum]
DeterminePaletteIDOutOfBattle.skipDexNumConversion
	ld e, a
	ld d, 0
	ld hl, MonsterPalettes ; not just for Pokemon, Trainers use it too
	add hl, de
	ld a, [hl]
	ret

InitPartyMenuBlkPacket:
	ld hl, BlkPacket_PartyMenu
	ld de, wPartyMenuBlkPacket
	ld bc, $30
	jp CopyData

UpdatePartyMenuBlkPacket:
; Update the blk packet with the palette of the HP bar that is
; specified in [wWhichPartyMenuHPBar].
	ld hl, wPartyMenuHPBarColors
	ld a, [wWhichPartyMenuHPBar]
	ld e, a
	ld d, 0
	add hl, de
	ld e, l
	ld d, h
	ld a, [de]
	and a
	ld e, (1 << 2) | 1 ; green
	jr z, UpdatePartyMenuBlkPacket.next
	dec a
	ld e, (2 << 2) | 2 ; yellow
	jr z, UpdatePartyMenuBlkPacket.next
	ld e, (3 << 2) | 3 ; red
UpdatePartyMenuBlkPacket.next
	push de
	ld hl, wPartyMenuBlkPacket + 8 + 1
	ld bc, 6
	ld a, [wWhichPartyMenuHPBar]
	call AddNTimes
	pop de
	ld [hl], e
	ret

SendSGBPacket:
;check number of packets
	ld a, [hl]
	and $07
	ret z
; store number of packets in B
	ld b, a
SendSGBPacket.loop2
; save B for later use
	push bc
; disable ReadJoypad to prevent it from interfering with sending the packet
	ld a, 1
	ldh [lobyte(hDisableJoypadPolling)], a
; send RESET signal (P14=LOW, P15=LOW)
	xor a ; JOYP_SGB_START
	ldh [lobyte(rJOYP)], a
; set P14=HIGH, P15=HIGH
	ld a, JOYP_SGB_FINISH
	ldh [lobyte(rJOYP)], a
;load length of packets (16 bytes)
	ld b, 16
SendSGBPacket.nextByte
;set bit counter (8 bits per byte)
	ld e, 8
; get next byte in the packet
	ld a, [hli]
	ld d, a
SendSGBPacket.nextBit0
	bit 0, d
; if 0th bit is not zero set P14=HIGH, P15=LOW (send bit 1)
	ld a, JOYP_SGB_ONE
	jr nz, SendSGBPacket.next0
; else (if 0th bit is zero) set P14=LOW, P15=HIGH (send bit 0)
	ld a, JOYP_SGB_ZERO
SendSGBPacket.next0
	ldh [lobyte(rJOYP)], a
; must set P14=HIGH,P15=HIGH between each "pulse"
	ld a, JOYP_SGB_FINISH
	ldh [lobyte(rJOYP)], a
; rotation will put next bit in 0th position (so  we can always use command
; "bit 0, d" to fetch the bit that has to be sent)
	rr d
; decrease bit counter so we know when we have sent all 8 bits of current byte
	dec e
	jr nz, SendSGBPacket.nextBit0
	dec b
	jr nz, SendSGBPacket.nextByte
; send bit 0 as a "stop bit" (end of parameter data)
	ld a, JOYP_SGB_ZERO
	ldh [lobyte(rJOYP)], a
; set P14=HIGH,P15=HIGH
	ld a, JOYP_SGB_FINISH
	ldh [lobyte(rJOYP)], a
	xor a
	ldh [lobyte(hDisableJoypadPolling)], a
; wait for about 70000 cycles
	call Wait7000
; restore (previously pushed) number of packets
	pop bc
	dec b
; return if there are no more packets
	ret z
; else send 16 more bytes
	jr SendSGBPacket.loop2

LoadSGB:
	xor a
	ld [wOnSGB], a
	call CheckSGB
	ret nc
	ld a, 1
	ld [wOnSGB], a
	ld a, [wOnCGB]
	and a
	jr z, LoadSGB.notCGB
	ret
LoadSGB.notCGB
	di
	call PrepareSuperNintendoVRAMTransfer
	ei
	ld a, 1
	ld [wCopyingSGBTileData], a
	ld de, ChrTrnPacket
	ld hl, SGBBorderGraphics
	call CopyGfxToSuperNintendoVRAM
	xor a
	ld [wCopyingSGBTileData], a
	ld de, PctTrnPacket
	ld hl, BorderPalettes
	call CopyGfxToSuperNintendoVRAM
	xor a
	ld [wCopyingSGBTileData], a
	ld de, PalTrnPacket
	ld hl, SuperPalettes
	call CopyGfxToSuperNintendoVRAM
	call ClearVram
	ld hl, MaskEnCancelPacket
	jp SendSGBPacket

PrepareSuperNintendoVRAMTransfer:
	ld hl, PrepareSuperNintendoVRAMTransfer.packetPointers
	ld c, 9
PrepareSuperNintendoVRAMTransfer.loop
	push bc
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call SendSGBPacket
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, PrepareSuperNintendoVRAMTransfer.loop
	ret

PrepareSuperNintendoVRAMTransfer.packetPointers
; Only the first packet is needed.
	.DW MaskEnFreezePacket
	.DW DataSndPacket1
	.DW DataSndPacket2
	.DW DataSndPacket3
	.DW DataSndPacket4
	.DW DataSndPacket5
	.DW DataSndPacket6
	.DW DataSndPacket7
	.DW DataSndPacket8

CheckSGB:
; Returns whether the game is running on an SGB in carry.
	ld hl, MltReq2Packet
	di
	call SendSGBPacket
	ld a, 1
	ldh [lobyte(hDisableJoypadPolling)], a
	ei
	call Wait7000
	ldh a, [lobyte(rJOYP)]
	and JOYP_SGB_MLT_REQ
	cp JOYP_SGB_MLT_REQ
	jr nz, CheckSGB.isSGB
	ld a, JOYP_SGB_ZERO
	ldh [lobyte(rJOYP)], a
	ldh a, [lobyte(rJOYP)]
	ldh a, [lobyte(rJOYP)]
	call Wait7000
	call Wait7000
	ld a, JOYP_SGB_FINISH
	ldh [lobyte(rJOYP)], a
	call Wait7000
	call Wait7000
	ld a, JOYP_SGB_ONE
	ldh [lobyte(rJOYP)], a
	ldh a, [lobyte(rJOYP)]
	ldh a, [lobyte(rJOYP)]
	ldh a, [lobyte(rJOYP)]
	ldh a, [lobyte(rJOYP)]
	ldh a, [lobyte(rJOYP)]
	ldh a, [lobyte(rJOYP)]
	call Wait7000
	vc_hook Unknown_network_reset
	call Wait7000
	ld a, JOYP_SGB_FINISH
	ldh [lobyte(rJOYP)], a
	ldh a, [lobyte(rJOYP)]
	ldh a, [lobyte(rJOYP)]
	ldh a, [lobyte(rJOYP)]
	call Wait7000
	call Wait7000
	ldh a, [lobyte(rJOYP)]
	and JOYP_SGB_MLT_REQ
	cp JOYP_SGB_MLT_REQ
	jr nz, CheckSGB.isSGB
	call SendMltReq1Packet
	and a
	ret
CheckSGB.isSGB
	call SendMltReq1Packet
	scf
	ret

SendMltReq1Packet:
	ld hl, MltReq1Packet
	call SendSGBPacket
	jp Wait7000

CopyGfxToSuperNintendoVRAM:
	di
	push de
	call DisableLCD
	ld a, $e4
	ldh [lobyte(rBGP)], a
	ld de, vChars1
	ld a, [wCopyingSGBTileData]
	and a
	jr z, CopyGfxToSuperNintendoVRAM.notCopyingTileData
	call CopySGBBorderTiles
	jr CopyGfxToSuperNintendoVRAM.next
CopyGfxToSuperNintendoVRAM.notCopyingTileData
	ld bc, 256 * TILE_SIZE
	call CopyData
CopyGfxToSuperNintendoVRAM.next
	ld hl, vBGMap0
	ld de, TILEMAP_WIDTH - SCREEN_WIDTH
	ld a, $80
	ld c, (256 + SCREEN_WIDTH - 1) / SCREEN_WIDTH ; enough rows to fit 256 * TILE_SIZE
CopyGfxToSuperNintendoVRAM.loop
	ld b, SCREEN_WIDTH
CopyGfxToSuperNintendoVRAM.innerLoop
	ld [hli], a
	inc a
	dec b
	jr nz, CopyGfxToSuperNintendoVRAM.innerLoop
	add hl, de
	dec c
	jr nz, CopyGfxToSuperNintendoVRAM.loop
	ld a, LCDC_DEFAULT
	ldh [lobyte(rLCDC)], a
	pop hl
	call SendSGBPacket
	xor a
	ldh [lobyte(rBGP)], a
	ei
	ret

Wait7000:
; Each loop takes 9 cycles so this routine actually waits 63000 cycles.
	ld de, 7000
Wait7000.loop
	nop
	nop
	nop
	dec de
	ld a, d
	or e
	jr nz, Wait7000.loop
	ret

SendSGBPackets:
	ld a, [wOnCGB]
	and a
	jr z, SendSGBPackets.notCGB
	push de
	call InitCGBPalettes
	pop hl
	call EmptyFunc3
	ret
SendSGBPackets.notCGB
	push de
	call SendSGBPacket
	pop hl
	jp SendSGBPacket

InitCGBPalettes:
	ld a, $80 ; index 0 with auto-increment
	ldh [lobyte(rBGPI)], a
	inc hl
	ld c, $20
InitCGBPalettes.loop
	ld a, [hli]
	inc hl
	add a
	add a
	add a
	ld de, SuperPalettes
	add e
	jr nc, InitCGBPalettes.noCarry
	inc d
InitCGBPalettes.noCarry
	ld a, [de]
	ldh [lobyte(rBGPD)], a
	dec c
	jr nz, InitCGBPalettes.loop
	ret

EmptyFunc3:
	ret

CopySGBBorderTiles:
; SGB tile data is stored in a 4BPP planar format.
; Each tile is 32 bytes. The first 16 bytes contain bit planes 1 and 2, while
; the second 16 bytes contain bit planes 3 and 4.
; This function converts 2BPP planar data into this format by mapping
; 2BPP colors 0-3 to 4BPP colors 0-3. 4BPP colors 4-15 are not used.
	ld b, 128
CopySGBBorderTiles.tileLoop
; Copy bit planes 1 and 2 of the tile data.
	ld c, TILE_SIZE
CopySGBBorderTiles.copyLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, CopySGBBorderTiles.copyLoop

; Zero bit planes 3 and 4.
	ld c, 16
	xor a
CopySGBBorderTiles.zeroLoop
	ld [de], a
	inc de
	dec c
	jr nz, CopySGBBorderTiles.zeroLoop

	dec b
	jr nz, CopySGBBorderTiles.tileLoop
	ret

.INCLUDE "data/sgb/sgb_packets.asm"

.INCLUDE "data/pokemon/palettes.asm"

.INCLUDE "data/sgb/sgb_palettes.asm"

.INCLUDE "data/sgb/sgb_border.asm"
