CeruleanGym_TextPointers:
.DW $4771 ; CeruleanGymMistyText
.DW $47DF ; CeruleanGymCooltrainerFText
.DW $47F8 ; CeruleanGymSwimmerText
.DW $4811 ; CeruleanGymGymGuideText
.DW $47C8 ; CeruleanGymMistyCascadeBadgeInfoText
.DW $47CD ; CeruleanGymMistyReceivedTM11Text
.DW $47D3 ; CeruleanGymMistyTM11NoRoomText
CeruleanGymTextPointersEnd:
.ASSERT CeruleanGymTextPointersEnd - CeruleanGym_TextPointers == 14

CeruleanGymTrainerHeaders:
CeruleanGymTrainerHeader0:
.DB $02, $30, $5E, $D7
.DW $47E9, $47F3, $47EE, $47EE
CeruleanGymTrainerHeader1:
.DB $03, $30, $5E, $D7
.DW $4802, $480C, $4807, $4807
.DB $FF
CeruleanGymTrainerHeadersEnd:
.ASSERT CeruleanGymTrainerHeadersEnd - CeruleanGymTrainerHeaders == 25
