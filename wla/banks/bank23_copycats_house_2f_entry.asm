CopycatsHouse2F_h:
.DB $04, $04, $04
.DW $4010
.DW $4C74
.DW $4C71
.DB $00
.DW $4D21
CopycatsHouse2FHeaderEnd:
.ASSERT CopycatsHouse2FHeaderEnd - CopycatsHouse2F_h == 12

CopycatsHouse2F_Script:
	JP $3C3C
CopycatsHouse2FScriptEnd:
.ASSERT CopycatsHouse2FScriptEnd - CopycatsHouse2F_Script == 3

CopycatsHouse2F_TextPointers:
.DW $4C82, $4CF4, $4CF9, $4CF9, $4CF9, $4CFE, $4D03
CopycatsHouse2FTextPointersEnd:
.ASSERT CopycatsHouse2FTextPointersEnd - CopycatsHouse2F_TextPointers == 14
