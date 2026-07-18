SafariZoneGate_Script:
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, SafariZoneGate_ScriptPointers
	LD A, ($D61F) ; wSafariZoneGateCurScript
	JP $3D97 ; CallFunctionInTable
SafariZoneGateScriptEnd:
.ASSERT SafariZoneGateScriptEnd - SafariZoneGate_Script == 12

SafariZoneGate_ScriptPointers:
	.DW SafariZoneGateDefaultScript
	.DW SafariZoneGatePlayerMovingRightScript
	.DW SafariZoneGateWouldYouLikeToJoinScript
	.DW SafariZoneGatePlayerMovingUpScript
	.DW SafariZoneGatePlayerMovingDownScript
	.DW SafariZoneGateLeavingSafariScript
	.DW SafariZoneGateSetScriptAfterMoveScript
SafariZoneGateScriptPointersEnd:
.ASSERT SafariZoneGateScriptPointersEnd - SafariZoneGate_ScriptPointers == 14
