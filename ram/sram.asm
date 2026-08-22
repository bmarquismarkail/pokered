.RAMSECTION "Sprite Buffers" BANK 0 SLOT 3

sSpriteBuffer0: ds SPRITEBUFFERSIZE
sSpriteBuffer1: ds SPRITEBUFFERSIZE
sSpriteBuffer2: ds SPRITEBUFFERSIZE

	__wla_sram_padding_000: ds $100

sHallOfFame: ds HOF_TEAM * HOF_TEAM_CAPACITY


.ENDS

.RAMSECTION "Save Data" BANK 1 SLOT 3

	__wla_sram_padding_001: ds $598

sGameData: ds 0
sPlayerName:  ds NAME_LENGTH
sMainData:    ds wMainDataEnd - wMainDataStart
sSpriteData:  ds wSpriteDataEnd - wSpriteDataStart
sPartyData:   ds wPartyDataEnd - wPartyDataStart
sCurBoxData:  ds wBoxDataEnd - wBoxDataStart
sTileAnimations: db
sGameDataEnd: ds 0
sMainDataCheckSum: db


; The PC boxes will not fit into one SRAM bank, so they use two banks.

.ENDS

.RAMSECTION "Saved Boxes 1" BANK 2 SLOT 3

; sBox1 - sBox6
sBox1: ds wBoxDataEnd - wBoxDataStart
sBox2: ds wBoxDataEnd - wBoxDataStart
sBox3: ds wBoxDataEnd - wBoxDataStart
sBox4: ds wBoxDataEnd - wBoxDataStart
sBox5: ds wBoxDataEnd - wBoxDataStart
sBox6: ds wBoxDataEnd - wBoxDataStart
sBank2AllBoxesChecksum: db
sBank2IndividualBoxChecksums: ds 6

.ENDS

.RAMSECTION "Saved Boxes 2" BANK 3 SLOT 3

; sBox7 - sBox12
sBox7: ds wBoxDataEnd - wBoxDataStart
sBox8: ds wBoxDataEnd - wBoxDataStart
sBox9: ds wBoxDataEnd - wBoxDataStart
sBox10: ds wBoxDataEnd - wBoxDataStart
sBox11: ds wBoxDataEnd - wBoxDataStart
sBox12: ds wBoxDataEnd - wBoxDataStart
sBank3AllBoxesChecksum: db
sBank3IndividualBoxChecksums: ds 6

.ENDS
