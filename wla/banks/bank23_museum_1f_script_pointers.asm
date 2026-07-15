Museum1F_ScriptPointers:
.DW $410D ; Museum1FDefaultScript
.DW $412A ; Museum1FNoopScript
Museum1FScriptPointersEnd:
.ASSERT Museum1FScriptPointersEnd - Museum1F_ScriptPointers == 4
