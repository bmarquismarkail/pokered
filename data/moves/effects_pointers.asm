MoveEffectPointerTable:
; entries correspond to *_EFFECT constants
	table_width 2
	.DW SleepEffect               ; EFFECT_01
	.DW PoisonEffect              ; POISON_SIDE_EFFECT1
	.DW DrainHPEffect             ; DRAIN_HP_EFFECT
	.DW FreezeBurnParalyzeEffect  ; BURN_SIDE_EFFECT1
	.DW FreezeBurnParalyzeEffect  ; FREEZE_SIDE_EFFECT1
	.DW FreezeBurnParalyzeEffect  ; PARALYZE_SIDE_EFFECT1
	.DW ExplodeEffect             ; EXPLODE_EFFECT
	.DW DrainHPEffect             ; DREAM_EATER_EFFECT
	.DW NULL                      ; MIRROR_MOVE_EFFECT
	.DW StatModifierUpEffect      ; ATTACK_UP1_EFFECT
	.DW StatModifierUpEffect      ; DEFENSE_UP1_EFFECT
	.DW StatModifierUpEffect      ; SPEED_UP1_EFFECT
	.DW StatModifierUpEffect      ; SPECIAL_UP1_EFFECT
	.DW StatModifierUpEffect      ; ACCURACY_UP1_EFFECT
	.DW StatModifierUpEffect      ; EVASION_UP1_EFFECT
	.DW PayDayEffect              ; PAY_DAY_EFFECT
	.DW NULL                      ; SWIFT_EFFECT
	.DW StatModifierDownEffect    ; ATTACK_DOWN1_EFFECT
	.DW StatModifierDownEffect    ; DEFENSE_DOWN1_EFFECT
	.DW StatModifierDownEffect    ; SPEED_DOWN1_EFFECT
	.DW StatModifierDownEffect    ; SPECIAL_DOWN1_EFFECT
	.DW StatModifierDownEffect    ; ACCURACY_DOWN1_EFFECT
	.DW StatModifierDownEffect    ; EVASION_DOWN1_EFFECT
	.DW ConversionEffect          ; CONVERSION_EFFECT
	.DW HazeEffect                ; HAZE_EFFECT
	.DW BideEffect                ; BIDE_EFFECT
	.DW ThrashPetalDanceEffect    ; THRASH_PETAL_DANCE_EFFECT
	.DW SwitchAndTeleportEffect   ; SWITCH_AND_TELEPORT_EFFECT
	.DW TwoToFiveAttacksEffect    ; TWO_TO_FIVE_ATTACKS_EFFECT
	.DW TwoToFiveAttacksEffect    ; EFFECT_1E
	.DW FlinchSideEffect          ; FLINCH_SIDE_EFFECT1
	.DW SleepEffect               ; SLEEP_EFFECT
	.DW PoisonEffect              ; POISON_SIDE_EFFECT2
	.DW FreezeBurnParalyzeEffect  ; BURN_SIDE_EFFECT2
	.DW FreezeBurnParalyzeEffect  ; FREEZE_SIDE_EFFECT2
	.DW FreezeBurnParalyzeEffect  ; PARALYZE_SIDE_EFFECT2
	.DW FlinchSideEffect          ; FLINCH_SIDE_EFFECT2
	.DW OneHitKOEffect            ; OHKO_EFFECT
	.DW ChargeEffect              ; CHARGE_EFFECT
	.DW NULL                      ; SUPER_FANG_EFFECT
	.DW NULL                      ; SPECIAL_DAMAGE_EFFECT
	.DW TrappingEffect            ; TRAPPING_EFFECT
	.DW ChargeEffect              ; FLY_EFFECT
	.DW TwoToFiveAttacksEffect    ; ATTACK_TWICE_EFFECT
	.DW NULL                      ; JUMP_KICK_EFFECT
	.DW MistEffect                ; MIST_EFFECT
	.DW FocusEnergyEffect         ; FOCUS_ENERGY_EFFECT
	.DW RecoilEffect              ; RECOIL_EFFECT
	.DW ConfusionEffect           ; CONFUSION_EFFECT
	.DW StatModifierUpEffect      ; ATTACK_UP2_EFFECT
	.DW StatModifierUpEffect      ; DEFENSE_UP2_EFFECT
	.DW StatModifierUpEffect      ; SPEED_UP2_EFFECT
	.DW StatModifierUpEffect      ; SPECIAL_UP2_EFFECT
	.DW StatModifierUpEffect      ; ACCURACY_UP2_EFFECT
	.DW StatModifierUpEffect      ; EVASION_UP2_EFFECT
	.DW HealEffect                ; HEAL_EFFECT
	.DW TransformEffect           ; TRANSFORM_EFFECT
	.DW StatModifierDownEffect    ; ATTACK_DOWN2_EFFECT
	.DW StatModifierDownEffect    ; DEFENSE_DOWN2_EFFECT
	.DW StatModifierDownEffect    ; SPEED_DOWN2_EFFECT
	.DW StatModifierDownEffect    ; SPECIAL_DOWN2_EFFECT
	.DW StatModifierDownEffect    ; ACCURACY_DOWN2_EFFECT
	.DW StatModifierDownEffect    ; EVASION_DOWN2_EFFECT
	.DW ReflectLightScreenEffect  ; LIGHT_SCREEN_EFFECT
	.DW ReflectLightScreenEffect  ; REFLECT_EFFECT
	.DW PoisonEffect              ; POISON_EFFECT
	.DW ParalyzeEffect            ; PARALYZE_EFFECT
	.DW StatModifierDownEffect    ; ATTACK_DOWN_SIDE_EFFECT
	.DW StatModifierDownEffect    ; DEFENSE_DOWN_SIDE_EFFECT
	.DW StatModifierDownEffect    ; SPEED_DOWN_SIDE_EFFECT
	.DW StatModifierDownEffect    ; SPECIAL_DOWN_SIDE_EFFECT
	.DW StatModifierDownEffect    ; unused effect
	.DW StatModifierDownEffect    ; unused effect
	.DW StatModifierDownEffect    ; unused effect
	.DW StatModifierDownEffect    ; unused effect
	.DW ConfusionSideEffect       ; CONFUSION_SIDE_EFFECT
	.DW TwoToFiveAttacksEffect    ; TWINEEDLE_EFFECT
	.DW NULL                      ; unused effect
	.DW SubstituteEffect          ; SUBSTITUTE_EFFECT
	.DW HyperBeamEffect           ; HYPER_BEAM_EFFECT
	.DW RageEffect                ; RAGE_EFFECT
	.DW MimicEffect               ; MIMIC_EFFECT
	.DW NULL                      ; METRONOME_EFFECT
	.DW LeechSeedEffect           ; LEECH_SEED_EFFECT
	.DW SplashEffect              ; SPLASH_EFFECT
	.DW DisableEffect             ; DISABLE_EFFECT
	assert_table_length NUM_MOVE_EFFECTS
