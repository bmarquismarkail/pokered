ReflectLightScreenEffect_:
	ld hl, wPlayerBattleStatus3
	ld de, wPlayerMoveEffect
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, ReflectLightScreenEffect_.reflectLightScreenEffect
	ld hl, wEnemyBattleStatus3
	ld de, wEnemyMoveEffect
ReflectLightScreenEffect_.reflectLightScreenEffect
	ld a, [de]
	cp LIGHT_SCREEN_EFFECT
	jr nz, ReflectLightScreenEffect_.reflect
	bit HAS_LIGHT_SCREEN_UP, [hl] ; is mon already protected by light screen?
	jr nz, ReflectLightScreenEffect_.moveFailed
	set HAS_LIGHT_SCREEN_UP, [hl] ; mon is now protected by light screen
	ld hl, LightScreenProtectedText
	jr ReflectLightScreenEffect_.playAnim
ReflectLightScreenEffect_.reflect
	bit HAS_REFLECT_UP, [hl] ; is mon already protected by reflect?
	jr nz, ReflectLightScreenEffect_.moveFailed
	set HAS_REFLECT_UP, [hl] ; mon is now protected by reflect
	ld hl, ReflectGainedArmorText
ReflectLightScreenEffect_.playAnim
	push hl
	ld hl, PlayCurrentMoveAnimation
	call EffectCallBattleCore
	pop hl
	jp PrintText
ReflectLightScreenEffect_.moveFailed
	ld c, 50
	call DelayFrames
	ld hl, PrintButItFailedText_
	jp EffectCallBattleCore

LightScreenProtectedText:
	text_far WLA_GLOBAL_LightScreenProtectedText
	text_end

ReflectGainedArmorText:
	text_far WLA_GLOBAL_ReflectGainedArmorText
	text_end

EffectCallBattleCore:
	ld b, bank(BattleCore)
	jp Bankswitch
