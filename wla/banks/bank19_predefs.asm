; Native WLA-DX form of RGBDS section "Predefs".
_GivePokemon:
	CALL EnableAutoTextBoxDrawing
	XOR A
	LD (wAddedToParty), A
	LD A, (wPartyCount)
	CP 6
	JR C, _GivePokemon.addToParty
	LD A, (wBoxCount)
	CP 20
	JR NC, _GivePokemon.boxFull
	XOR A
	LD (wEnemyBattleStatus3), A
	LD A, (wCurPartySpecies)
	LD (wEnemyMonSpecies2), A
	LD HL, $6b01 ; LoadEnemyMonData
	LD B, $0f
	CALL Bankswitch
	CALL SetPokedexOwnedFlag
	LD HL, $67a4 ; SendNewMonToBox
	LD B, $03
	CALL Bankswitch
	LD HL, wStringBuffer
	LD A, (wCurrentBoxNum)
	AND $7f
	CP 9
	JR C, _GivePokemon.singleDigitBoxNum
	SUB 9
	LD (HL), $f7 ; "1"
	INC HL
	ADD $f6 ; "0"
	JR _GivePokemon.next
_GivePokemon.singleDigitBoxNum:
	ADD $f7 ; "1"
_GivePokemon.next:
	LD (HL+), A
	LD (HL), $50
	LD HL, SentToBoxText
	CALL PrintText
	SCF
	RET
_GivePokemon.boxFull:
	LD HL, BoxIsFullText
	CALL PrintText
	AND A
	RET
_GivePokemon.addToParty:
	CALL SetPokedexOwnedFlag
	CALL $3927 ; AddPartyMon
	LD A, 1
	LD (wDoNotWaitForButtonPressAfterDisplayingText), A
	LD (wAddedToParty), A
	SCF
	RET

SetPokedexOwnedFlag:
	LD A, (wCurPartySpecies)
	PUSH AF
	LD (wPokedexNum), A
	LD A, $3a ; IndexToPokedex
	CALL Predef
	LD A, (wPokedexNum)
	DEC A
	LD C, A
	LD HL, wPokedexOwned
	LD B, 1
	LD A, $10 ; FlagActionPredef
	CALL Predef
	POP AF
	LD (wNamedObjectIndex), A
	CALL $2f9e ; GetMonName
	LD HL, GotMonText
	JP PrintText

GotMonText:
	.DB $17
	.DW $4180
	.DB $29, $0b, $50
SentToBoxText:
	.DB $17
	.DW $418f
	.DB $29, $50
BoxIsFullText:
	.DB $17
	.DW $41d6
	.DB $29, $50

GetPredefPointer:
	LD A, H
	LD (wPredefHL), A
	LD A, L
	LD (wPredefHL + 1), A
	LD HL, wPredefDE
	LD A, D
	LD (HL+), A
	LD A, E
	LD (HL+), A
	LD A, B
	LD (HL+), A
	LD (HL), C
	LD HL, PredefPointers
	LD DE, $0000
	LD A, (wPredefID)
	LD E, A
	ADD A
	ADD E
	LD E, A
	JR NC, GetPredefPointer.nocarry
	INC D
GetPredefPointer.nocarry:
	ADD HL, DE
	LD D, H
	LD E, L
	LD A, (DE)
	LD (wPredefBank), A
	INC DE
	LD A, (DE)
	LD L, A
	INC DE
	LD A, (DE)
	LD H, A
	RET

PredefPointers:
DrawPlayerHUDAndHPBarPredef:
	.DB $0f
	.DW $4d60
CopyUncompressedPicToTilemapPredef:
	.DB $0f
	.DW $70c6
AnimateSendingOutMonPredef:
	.DB $0f
	.DW $7073
ScaleSpriteByTwoPredef:
	.DB $0b
	.DW $7e40
LoadMonBackPicPredef:
	.DB $0f
	.DW $7103
CopyDownscaledMonTilesPredef:
	.DB $1e
	.DW $5aba
JumpMoveEffectPredef:
	.DB $03
	.DW $7132
HealPartyPredef:
	.DB $03
	.DW $76a5
MoveAnimationPredef:
	.DB $1e
	.DW $4d5e
DivideBCDPredefPredef:
	.DB $03
	.DW $771e
DivideBCDPredef2Predef:
	.DB $03
	.DW $771e
AddBCDPredefPredef:
	.DB $03
	.DW $781d
SubBCDPredefPredef:
	.DB $03
	.DW $7836
DivideBCDPredef3Predef:
	.DB $03
	.DW $771e
DivideBCDPredef4Predef:
	.DB $03
	.DW $771e
InitPlayerDataPredef:
	.DB $03
	.DW $7850
FlagActionPredefPredef:
	.DB $03
	.DW $7666
HideObjectPredef:
	.DB $03
	.DW $71d7
IsObjectHiddenPredef:
	.DB $03
	.DW $71a6
ApplyOutOfBattlePoisonDamagePredef:
	.DB $03
	.DW $469c
AnyPartyAlivePredef:
	.DB $0f
	.DW $4a83
ShowObjectPredef:
	.DB $03
	.DW $71c8
ShowObject2Predef:
	.DB $03
	.DW $71c8
ReplaceTileBlockPredef:
	.DB $03
	.DW $6e9e
InitPlayerData2Predef:
	.DB $03
	.DW $7850
LoadTilesetHeaderPredef:
	.DB $03
	.DW $4754
LearnMoveFromLevelUpPredef:
	.DB $0e
	.DW $6f5b
LearnMovePredef:
	.DB $01
	.DW $6e43
GetQuantityOfItemInBagPredef:
	.DB $03
	.DW $78a5
CheckForHiddenEventOrBookshelfOrCardKeyDoorPredef:
	.DB $03
	.DW $3eb5
GiveItemPredef:
	.DB $03
	.DW $3e2e
ChangeBGPalColor0_4FramesPredef:
	.DB $12
	.DW $40eb
FindPathToPlayerPredef:
	.DB $03
	.DW $78ba
PredefShakeScreenVerticallyPredef:
	.DB $12
	.DW $40ff
CalcPositionOfPlayerRelativeToNPCPredef:
	.DB $03
	.DW $7929
ConvertNPCMovementDirectionsToJoypadMasksPredef:
	.DB $03
	.DW $79a0
PredefShakeScreenHorizontallyPredef:
	.DB $12
	.DW $4125
UpdateHPBarPredef:
	.DB $03
	.DW $7a1d
HPBarLengthPredef:
	.DB $03
	.DW $79dc
Diploma_TextBoxBorderPredef:
	.DB $01
	.DW $5ab0
DoubleOrHalveSelectedStatsPredef:
	.DB $0f
	.DW $6d02
ShowPokedexMenuPredef:
	.DB $10
	.DW $4000
EvolutionAfterBattlePredef:
	.DB $0e
	.DW $6d1c
SaveMainDataPredef:
	.DB $1c
	.DW $778c
InitOpponentPredef:
	.DB $0f
	.DW $6f18
CableClub_RunPredef:
	.DB $01
	.DW $5a5f
DrawBadgesPredef:
	.DB $03
	.DW $6a03
ExternalClockTradeAnimPredef:
	.DB $10
	.DW $50f3
BattleTransitionPredef:
	.DB $1c
	.DW $496d
CopyTileIDsFromListPredef:
	.DB $1e
	.DW $5dda
PlayIntroPredef:
	.DB $10
	.DW $5682
GetIntroMoveSoundPredef:
	.DB $1e
	.DW $5869
FlashScreenPredef:
	.DB $1c
	.DW $4b5d
GetTileAndCoordsInFrontOfPlayerPredef:
	.DB $03
	.DW $4586
StatusScreenPredef:
	.DB $04
	.DW $6953
StatusScreen2Predef:
	.DB $04
	.DW $6b57
InternalClockTradeAnimPredef:
	.DB $10
	.DW $50e2
TrainerEngagePredef:
	.DB $15
	.DW $690f
IndexToPokedexPredef:
	.DB $10
	.DW $5010
DisplayPicCenteredOrUpperRightPredef:
	.DB $01
	.DW $62a1
UsedCutPredef:
	.DB $03
	.DW $6f54
ShowPokedexDataPredef:
	.DB $10
	.DW $42d1
WriteMonMovesPredef:
	.DB $0e
	.DW $6fb8
SaveMenuPredef:
	.DB $1c
	.DW $770a
LoadSGBPredef:
	.DB $1c
	.DW $602b
MarkTownVisitedAndLoadToggleableObjectsPredef:
	.DB $03
	.DW $7113
SetPartyMonTypesPredef:
	.DB $17
	.DW $5b5e
CanLearnTMPredef:
	.DB $04
	.DW $773e
TMToMovePredef:
	.DB $04
	.DW $7763
_RunPaletteCommandPredef:
	.DB $1c
	.DW $5ddf
StarterDexPredef:
	.DB $17
	.DW $40dc
_AddPartyMonPredef:
	.DB $03
	.DW $72e5
UpdateHPBar2Predef:
	.DB $03
	.DW $7a1d
DrawEnemyHUDAndHPBarPredef:
	.DB $0f
	.DW $4dec
LoadTownMap_NestPredef:
	.DB $1c
	.DW $4f60
PrintMonTypePredef:
	.DB $09
	.DW $7d6b
EmotionBubblePredef:
	.DB $05
	.DW $7c47
EmptyFuncPredef:
	.DB $01
	.DW $5aaf
AskNamePredef:
	.DB $01
	.DW $64eb
PewterGuysPredef:
	.DB $0d
	.DW $7ca1
SavePartyAndDexDataPredef:
	.DB $1c
	.DW $780f
LoadPartyAndDexDataPredef:
	.DB $1c
	.DW $76bd
TryLoadSaveFilePredef:
	.DB $1c
	.DW $75e8
SaveCurrentBoxDataPredef:
	.DB $1c
	.DW $77e2
DoInGameTradeDialoguePredef:
	.DB $1c
	.DW $5ad9
HallOfFamePCPredef:
	.DB $1d
	.DW $405c
DisplayDexRatingPredef:
	.DB $11
	.DW $4169
_LeaveMapAnimPredef:
	.DB $1e
	.DW $45ba
EnterMapAnimPredef:
	.DB $1e
	.DW $4510
GetTileTwoStepsInFrontOfPlayerPredef:
	.DB $03
	.DW $45be
CheckForCollisionWhenPushingBoulderPredef:
	.DB $03
	.DW $460b
PrintStrengthTextPredef:
	.DB $03
	.DW $4d99
PickUpItemPredef:
	.DB $01
	.DW $4de1
PrintMoveTypePredef:
	.DB $09
	.DW $7d98
LoadMovePPsPredef:
	.DB $03
	.DW $7473
DrawHPPredef:
	.DB $04
	.DW $68ef
DrawHP2Predef:
	.DB $04
	.DW $68f6
DisplayElevatorFloorMenuPredef:
	.DB $07
	.DW $49c6
OaksAideScriptPredef:
	.DB $16
	.DW $5035
PredefsEnd:
