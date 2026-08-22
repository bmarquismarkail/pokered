.MACRO spinner
; \1: source
; \2: offset (bank() chokes on literals)
; \3: dest
	.DW \1 + TILE_SIZE * \2
	.DB 1
	.DB bank(\1)
	.DW vTileset + TILE_SIZE * \3
.ENDM

FacilitySpinnerArrows:
	spinner SpinnerArrowAnimTiles, 0,   $20
	spinner SpinnerArrowAnimTiles, 1,   $21
	spinner SpinnerArrowAnimTiles, 2,   $30
	spinner SpinnerArrowAnimTiles, 3,   $31
	spinner Facility_GFX,          $20, $20
	spinner Facility_GFX,          $21, $21
	spinner Facility_GFX,          $30, $30
	spinner Facility_GFX,          $31, $31

GymSpinnerArrows:
	spinner SpinnerArrowAnimTiles, 1,   $3c
	spinner SpinnerArrowAnimTiles, 3,   $3d
	spinner SpinnerArrowAnimTiles, 0,   $4c
	spinner SpinnerArrowAnimTiles, 2,   $4d
	spinner Gym_GFX,               $3c, $3c
	spinner Gym_GFX,               $3d, $3d
	spinner Gym_GFX,               $4c, $4c
	spinner Gym_GFX,               $4d, $4d
