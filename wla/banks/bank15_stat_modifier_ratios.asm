StatModifierRatios:
.DB 25, 100, 28, 100, 33, 100, 40, 100
.DB 50, 100, 66, 100, 1, 1, 15, 10
.DB 2, 1, 25, 10, 3, 1, 35, 10
.DB 4, 1
StatModifierRatiosEnd:
.ASSERT StatModifierRatiosEnd - StatModifierRatios == 26
