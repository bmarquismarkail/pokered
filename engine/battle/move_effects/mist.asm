MistEffect_:
	ld hl, wPlayerBattleStatus2
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, MistEffect_.mistEffect
	ld hl, wEnemyBattleStatus2
MistEffect_.mistEffect
	bit PROTECTED_BY_MIST, [hl] ; is mon protected by mist?
	jr nz, MistEffect_.mistAlreadyInUse
	set PROTECTED_BY_MIST, [hl] ; mon is now protected by mist
	callfar PlayCurrentMoveAnimation
	ld hl, ShroudedInMistText
	jp PrintText
MistEffect_.mistAlreadyInUse
	jpfar PrintButItFailedText_

ShroudedInMistText:
	text_far WLA_GLOBAL_ShroudedInMistText
	text_end
