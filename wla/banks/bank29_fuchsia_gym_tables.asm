FuchsiaGym_TextPointers:
	.DW $5534,$55A4,$55BD,$55D6,$55EF,$5608
	.DW $5621,$563A,$5590,$5595,$559F
FuchsiaGymTextPointersEnd:
.ASSERT FuchsiaGymTextPointersEnd - FuchsiaGym_TextPointers == 22

FuchsiaGymTrainerHeaders:
FuchsiaGymTrainerHeader0:
	.DB $02,$20,$92,$D7
	.DW $55AE,$55B8,$55B3,$55B3
FuchsiaGymTrainerHeader1:
	.DB $03,$20,$92,$D7
	.DW $55C7,$55D1,$55CC,$55CC
FuchsiaGymTrainerHeader2:
	.DB $04,$40,$92,$D7
	.DW $55E0,$55EA,$55E5,$55E5
FuchsiaGymTrainerHeader3:
	.DB $05,$20,$92,$D7
	.DW $55F9,$5603,$55FE,$55FE
FuchsiaGymTrainerHeader4:
	.DB $06,$20,$92,$D7
	.DW $5612,$561C,$5617,$5617
FuchsiaGymTrainerHeader5:
	.DB $07,$20,$92,$D7
	.DW $562B,$5635,$5630,$5630
	.DB $FF
FuchsiaGymTrainerHeadersEnd:
.ASSERT FuchsiaGymTrainerHeadersEnd - FuchsiaGymTrainerHeaders == 73
