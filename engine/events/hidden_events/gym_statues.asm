GymStatues:
; if in a gym and have the corresponding badge, a = GymStatueText2_id and jp PrintPredefTextID
; if in a gym and don't have the corresponding badge, a = GymStatueText1_id and jp PrintPredefTextID
; else ret
	call EnableAutoTextBoxDrawing
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	ld hl, MapBadgeFlags
	ld a, [wCurMap]
	ld b, a
GymStatues.loop
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr z, GymStatues.match
	inc hl
	jr GymStatues.loop
GymStatues.match
	ld b, [hl]
	ld a, [wBeatGymFlags]
	and b
	cp b
	tx_pre_id GymStatueText2
	jr z, GymStatues.haveBadge
	tx_pre_id GymStatueText1
GymStatues.haveBadge
	jp PrintPredefTextID

.INCLUDE "data/maps/badge_maps.asm"

GymStatueText1:
	text_far WLA_GLOBAL_GymStatueText1
	text_end

GymStatueText2:
	text_far WLA_GLOBAL_GymStatueText2
	text_end
