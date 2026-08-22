SetLastBlackoutMap:
; Set the map to return to when
; blacking out or using Teleport or Dig.
; Safari rest houses don't count.

	push hl
	ld hl, SafariZoneRestHouses
	ld a, [wCurMap]
	ld b, a
SetLastBlackoutMap.loop
	ld a, [hli]
	cp -1
	jr z, SetLastBlackoutMap.notresthouse
	cp b
	jr nz, SetLastBlackoutMap.loop
	jr SetLastBlackoutMap.done

SetLastBlackoutMap.notresthouse
	ld a, [wLastMap]
	ld [wLastBlackoutMap], a
SetLastBlackoutMap.done
	pop hl
	ret

.INCLUDE "data/maps/rest_house_maps.asm"
