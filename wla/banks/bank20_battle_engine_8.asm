; Native WLA-DX form of engine/battle/init_battle_variables.asm and
; engine/battle/move_effects/paralyze.asm.
InitBattleVariables:
	LDH A, ($d7) ; hTileAnimations
	LD (wSavedTileAnimations), A
	XOR A
	LD (wActionResultOrTookBattleTurn), A
	LD (wBattleResult), A
	LD HL, wPartyAndBillsPCSavedMenuItem
	LD (HL+), A
	LD (HL+), A
	LD (HL+), A
	LD (HL), A
	LD (wListScrollOffset), A
	LD (wCriticalHitOrOHKO), A
	LD (wBattleMonSpecies), A
	LD (wPartyGainExpFlags), A
	LD (wPlayerMonNumber), A
	LD (wEscapedFromBattle), A
	LD (wMapPalOffset), A
	LD HL, wPlayerHPBarColor
	LD (HL+), A ; wPlayerHPBarColor
	LD (HL), A ; wEnemyHPBarColor
	LD HL, wCanEvolveFlags
	LD B, wMiscBattleDataEnd - wMiscBattleData
InitBattleVariables.loop:
	LD (HL+), A
	DEC B
	JR NZ, InitBattleVariables.loop
	INC A ; POUND
	LD (wTestBattlePlayerSelectedMove), A
	LD A, (wCurMap)
	CP $d9 ; SAFARI_ZONE_EAST
	JR C, InitBattleVariables.notSafariBattle
	CP $dd ; SAFARI_ZONE_CENTER_REST_HOUSE
	JR NC, InitBattleVariables.notSafariBattle
	LD A, 2 ; BATTLE_TYPE_SAFARI
	LD (wBattleType), A
InitBattleVariables.notSafariBattle:
	LD HL, $50c6 ; PlayBattleMusic
	LD B, $02
	JP Bankswitch

ParalyzeEffect_:
	LD HL, wEnemyMonStatus
	LD DE, wPlayerMoveType
	LDH A, ($f3) ; hWhoseTurn
	AND A
	JP Z, ParalyzeEffect_.next
	LD HL, wBattleMonStatus
	LD DE, wEnemyMoveType
ParalyzeEffect_.next:
	LD A, (HL)
	AND A
	JR NZ, ParalyzeEffect_.didntAffect
	LD A, (DE)
	CP $17 ; ELECTRIC
	JR NZ, ParalyzeEffect_.hitTest
	LD B, H
	LD C, L
	INC BC
	LD A, (BC)
	CP $04 ; GROUND
	JR Z, ParalyzeEffect_.doesntAffect
	INC BC
	LD A, (BC)
	CP $04 ; GROUND
	JR Z, ParalyzeEffect_.doesntAffect
ParalyzeEffect_.hitTest:
	PUSH HL
	LD HL, $656b ; MoveHitTest
	LD B, $0f
	CALL Bankswitch
	POP HL
	LD A, (wMoveMissed)
	AND A
	JR NZ, ParalyzeEffect_.didntAffect
	SET 6, (HL) ; PAR
	LD HL, $6d27 ; QuarterSpeedDueToParalysis
	LD B, $0f
	CALL Bankswitch
	LD C, 30
	CALL DelayFrames
	LD HL, $7ba8 ; PlayCurrentMoveAnimation
	LD B, $0f
	CALL Bankswitch
	LD HL, $7b6e ; PrintMayNotAttackText
	LD B, $0f
	JP Bankswitch
ParalyzeEffect_.didntAffect:
	LD C, 50
	CALL DelayFrames
	LD HL, $7b5e ; PrintDidntAffectText
	LD B, $0f
	JP Bankswitch
ParalyzeEffect_.doesntAffect:
	LD C, 50
	CALL DelayFrames
	LD HL, $5c51 ; PrintDoesntAffectText
	LD B, $0f
	JP Bankswitch
BattleEngine8End:
