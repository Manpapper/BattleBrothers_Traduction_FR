local gt = this.getroottable();
gt.Const.Movement <- {
	AutoEndTurnBelowAP = 2,
	FatigueCostFactor = 0.25,
	LevelDifferenceActionPointCost = 1,
	LevelDifferenceFatigueCost = 4,
	LevelClimbingFatigueCost = 0,
	HiddenStatusEffect = "scripts/skills/terrain/hidden_effect",
	HiddenStatusEffectID = "terrain.hidden",
	AnnounceDiscoveredEntities = true,
	EnemySelectionColor = this.createColor("#490a03"),
	EnemySelectionFadeTime = 500
};
gt.Const.XP <- {
	XPForKillerPct = 0.2,
	MaxLevelWithPerkpoints = 11
};
gt.Const.BusinessReputation <- [
	-500,
	-250,
	-100,
	0,
	250,
	500,
	750,
	1050,
	1400,
	1800,
	2250,
	2750,
	3350,
	4000,
	8000,
	14000
];
gt.Const.FollowerSlotRequirements <- [
	4,
	6,
	8,
	10,
	12,
	14
];
gt.Const.LevelXP <- [
	0,
	200,
	500,
	1000,
	2000,
	3500,
	5000,
	7000,
	9000,
	12000,
	15000
];

for( local i = 0; i < 22; i = ++i )
{
	this.Const.LevelXP.push(this.Const.LevelXP[this.Const.LevelXP.len() - 1] + 4000 + 1000 * i);
}

gt.Const.Combat <- {
	GlobalXPMult = 0.85,
	GlobalXPVeteranLevelMult = 1.0,
	WeaponSpecFatigueMult = 0.75,
	RetreatDeathChanceNotAtBorder = 0,
	InitiativeAfterWaitMult = 0.75,
	InjuryThresholdMult = 1.0,
	InjuryMinDamage = 10,
	SurviveWithInjuryChance = 33,
	FatigueReceivedPerHit = 5,
	FatigueLossOnBeingAttacked = 0,
	FatigueLossOnBeingMissed = 2,
	LevelDifferenceToHitBonus = 10,
	LevelDifferenceToHitMalus = -10,
	OverwhelmDefenseMalus = -10,
	AttackOfOpportunityLimit = 999,
	RangedAttackBlockedChance = 0.75,
	FallingDamage = 10,
	ArmorDirectDamageMitigationMult = 0.1,
	PoisonEffectMinDamage = 6,
	AlertWeaponBreakingCondition = 12,
	WeaponDurabilityLossOnHit = 3.0,
	WeaponDurabilityLossOnUse = 2.0,
	MinDamageToApplyBleeding = 6,
	BasicShieldDamage = 1,
	HumanCorpseOffset = this.createVec(0, 10),
	ShieldWallMaxAllies = 4,
	RiposteDelay = 300,
	SpawnBloodMinDamage = 10,
	SpawnBloodSameTileChance = 90,
	SpawnBloodAdjacentTileChance = 75,
	SpawnBloodAttempts = 3,
	SpawnBloodEffectMinDamage = 8,
	PlayHitSoundMinDamage = 1,
	PlayPainSoundMinDamage = 6,
	PlayPainVolumeMaxDamage = 20.0,
	BloodSplattersAtDeathMult = 1.0,
	BloodSplattersAtOriginalPosMult = 0.05,
	DustSplattersAtResurrectionMult = 1.0,
	BloodPoolsAtDeathMin = 4,
	BloodPoolsAtDeathMax = 4,
	BloodiedBustCount = 4,
	FliesRoundDelay = 15,
	DiversionMaxLevelDifference = 1,
	DiversionMinDist = 2,
	DiversionSpreadMinDist = 4,
	SpawnArrowDecalChance = 100,
	SpawnArrowDecalAttempts = 3,
	SpawnProjectileMinDist = 2,
	ShowDamagedArmorThreshold = 0.5,
	ShowDamagedShieldThreshold = 0.5,
	StunnedBrush = "bust_stunned",
	ShakeEffectHitpointsHitColor = this.createColor("#ffffff"),
	ShakeEffectHitpointsHitHighlight = this.createColor("#600a0a"),
	ShakeEffectHitpointsHitFactor = 0.5,
	ShakeEffectArmorHitColor = this.createColor("#ffffff"),
	ShakeEffectArmorHitHighlight = this.createColor("#ffffff"),
	ShakeEffectArmorHitFactor = 0.5,
	ShakeEffectHitpointsSaturation = 1.0,
	ShakeEffectArmorSaturation = 1.0,
	ShakeEffectSplitShieldColor = this.createColor("#ffffff"),
	ShakeEffectSplitShieldHighlight = this.createColor("#ffffff"),
	ShakeEffectSplitShieldFactor = 0.5,
	ResurrectAnimationTime = 1.0,
	ResurrectAnimationDistance = -200.0,
	RootedAnimationTime = 0.5,
	ZweihanderFatigueMult = 0.8,
	StealthFailRadius = 4
};
gt.Const.Corpse <- {
	Type = "",
	Faction = 0,
	Name = "",
	CorpseName = "",
	Description = "",
	Tile = null,
	Value = 1.0,
	IsConsumable = true,
	IsResurrectable = false,
	IsRestoringSkin = false,
	IsHeadAttached = true,
	IsPlayer = false,
	Color = this.createColor("#ffffff"),
	Saturation = 1.0,
	Hitpoints = 0.45,
	Armor = [
		0,
		0
	],
	Items = null,
	Custom = null
};
gt.Const.ShakeCharacterLayers <- [
	[
		"body",
		"armor",
		"skin",
		"injury_body",
		"quiver",
		"tattoo_body",
		"armor_upgrade_back",
		"armor_upgrade_front"
	],
	[
		"head",
		"head_skin",
		"injury",
		"helmet",
		"helmet_damage",
		"dirt",
		"tattoo_head",
		"hair"
	],
	[
		"body",
		"armor",
		"skin",
		"injury_body",
		"quiver",
		"tattoo_body",
		"armor_upgrade_back",
		"armor_upgrade_front",
		"head",
		"head_skin",
		"injury",
		"helmet",
		"helmet_damage",
		"dirt",
		"tattoo_head",
		"hair"
	]
];
gt.Const.Morale <- {
	EnemyKilledBaseDifficulty = -30,
	EnemyKilledXPMult = 0.04,
	EnemyKilledDistancePow = 3.0,
	EnemyKilledSelfBonus = 15,
	AllyKilledBaseDifficulty = 20,
	AllyKilledXPMult = 0.035,
	AllyKilledDistancePow = 2.4000001,
	AllyFleeingBaseDifficulty = 30,
	AllyFleeingXPMult = 0.035,
	AllyFleeingDistancePow = 3.0,
	OnHitMinDamage = 15,
	OnHitBaseDifficulty = -40,
	RallyBaseDifficulty = 0,
	OnNewTurnBaseDifficulty = -15,
	OpponentsAdjacentMult = 3,
	AlliesAdjacentMult = 3,
	RallyBonusPerRound = 2,
	RallyBonusPerRoundArena = 5,
	MoraleUpIcon = "morale_up",
	MoraleDownIcon = "morale_down"
};
gt.Const.Attributes <- {
	Hitpoints = 0,
	Bravery = 1,
	Fatigue = 2,
	Initiative = 3,
	MeleeSkill = 4,
	RangedSkill = 5,
	MeleeDefense = 6,
	RangedDefense = 7,
	COUNT = 8
};
gt.Const.AttributesLevelUp <- [
	{
		Min = 2,
		Max = 4
	},
	{
		Min = 2,
		Max = 4
	},
	{
		Min = 2,
		Max = 4
	},
	{
		Min = 3,
		Max = 5
	},
	{
		Min = 1,
		Max = 3
	},
	{
		Min = 2,
		Max = 4
	},
	{
		Min = 1,
		Max = 3
	},
	{
		Min = 2,
		Max = 4
	}
];
gt.Const.MoraleState <- {
	Fleeing = 0,
	Breaking = 1,
	Wavering = 2,
	Steady = 3,
	Confident = 4,
	Ignore = 5,
	COUNT = 6
};
gt.Const.MoraleCheckType <- {
	Default = 0,
	MentalAttack = 1,
	Fatality = 2
};
gt.Const.MoraleStateBrush <- [
	"icon_fleeing",
	"icon_breaking",
	"icon_wavering",
	"",
	"icon_confident",
	""
];
gt.Const.MoraleStateName <- [
	"Fleeing",
	"Breaking",
	"Wavering",
	"Steady",
	"Confident",
	"Unbreakable"
];
gt.Const.MoraleStateEvent <- [
	" s'enfuit",
	" se brise",
	" est vacillant",
	" est maintenant stable",
	" est confiant",
	""
];
gt.Const.HitpointsStateName <- [
	"Proche de la mort",
	"Gravement blessé",
	"Blessé",
	"Meurtri",
	"Indemne"
];
gt.Const.FatigueStateName <- [
	"Frais",
	"Réchauffé",
	"Reprend son souffle",
	"Fatigué",
	"Épuisé",
	"Épuisé"
];
gt.Const.ArmorStateName <- [
	"",
	"Se désagrége",
	"Cabossé",
	"Rayé",
	"Intacte"
];
gt.Const.MoodChange <- {
	DrunkAtTavern = 1.0,
	NotPaid = 1.0,
	NotPaidGreedy = 2.0,
	NotEaten = 1.0,
	NotEatenSpartan = 0.5,
	NotEatenGluttonous = 2.0,
	BrotherDied = 0.25,
	BrotherDismissed = 0.5,
	VeteranDismissed = 1.0,
	SlaveCompensated = 0.35,
	BattleWithoutMe = 0.2,
	BattleWon = 0.35,
	BattleLost = 0.45,
	BattleRetreat = 0.25,
	TooFewSlaves = 0.5,
	TooFewSlavesInBattle = 1.0,
	PermanentInjury = 1.35,
	Injury = 0.15,
	NearCity = 0.1,
	StandardLost = 0.25,
	AmbitionFulfilled = 1.0,
	AmbitionFailed = 0.75,
	OptimistMult = 1.33,
	PessimistMult = 1.33,
	CheckIntervalHours = 4,
	RecoveryPerHour = 0.015,
	RelativeRecoveryPerHour = 0.01,
	Timeout = 5.0 * this.World.getTime().SecondsPerDay
};
gt.Const.MoodState <- {
	Angry = 0,
	Disgruntled = 1,
	Concerned = 2,
	Neutral = 3,
	InGoodSpirit = 4,
	Eager = 5,
	Euphoric = 6
};
gt.Const.MoodStateName <- [
	"En colère",
	"Mécontent",
	"Insatisfait",
	"Content",
	"De bonne humeur",
	"A hâte",
	"Euphorique"
];
gt.Const.MoodStateEvent <- [
	" se met en colère",
	" devient mécontent",
	" devient insastisfait",
	" est content",
	" est de bonne humeur",
	" à hâte",
	" devient euphorique"
];
gt.Const.MoodStateIcon <- [
	"skills/status_effect_44.png",
	"skills/status_effect_45.png",
	"skills/status_effect_46.png",
	"skills/status_effect_64.png",
	"skills/status_effect_47.png",
	"skills/status_effect_48.png",
	"skills/status_effect_49.png"
];
gt.Const.SkillType <- {
	None = 0,
	Active = 1,
	Trait = 2,
	Racial = 4,
	StatusEffect = 8,
	Special = 16,
	Item = 32,
	Perk = 64,
	Terrain = 128,
	WorldEvent = 256,
	Background = 512,
	Alert = 1024,
	Injury = 2048,
	PermanentInjury = 4096,
	TemporaryInjury = 8192,
	SemiInjury = 16384,
	DrugEffect = 32768,
	DamageOverTime = 65536,
	Passive = 2 | 4 | 8 | 16 | 32 | 128 | 256 | 512 | 2048,
	Hiring = 512,
	All = 1 | 2 | 4 | 8 | 16 | 32 | 64 | 128 | 256 | 512 | 1024 | 2048 | 4096 | 8192 | 16384 | 32768 | 65536
};
gt.Const.SkillOrder <- {
	First = 0,
	Item = 1000,
	Perk = 5000,
	Background = 6000,
	Trait = 8000,
	PermanentInjury = 9000,
	TemporaryInjury = 9500,
	OffensiveTargeted = 10000,
	Offensive = 15000,
	UtilityTargeted = 20000,
	OtherTargeted = 30000,
	NonTargeted = 40000,
	Any = 50000,
	BeforeLast = 60000,
	Last = 70000,
	VeryLast = 80000
};
gt.Const.BodyPart <- {
	Body = 0,
	Head = 1,
	All = 2,
	COUNT = 2
};
gt.Const.ItemSlot <- {
	None = -1,
	Mainhand = 0,
	Offhand = 1,
	Body = 2,
	Head = 3,
	Accessory = 4,
	Ammo = 5,
	Bag = 6,
	Free = 6,
	COUNT = 7
};
gt.Const.ItemSlotSpaces <- [
	1,
	1,
	1,
	1,
	1,
	1,
	4
];
gt.Const.ItemSlotChangeableInBattle <- [
	true,
	true,
	false,
	false,
	true,
	true,
	true
];
gt.Const.FatalityType <- {
	None = 0,
	Decapitated = 1,
	Disemboweled = 2,
	Smashed = 3,
	Unconscious = 4,
	Devoured = 5,
	Suicide = 6,
	Kraken = 7
};
gt.Const.BloodType <- {
	None = 0,
	Red = 1,
	Dark = 2,
	Bones = 3,
	Ash = 4,
	Green = 5,
	Wood = 6,
	Sand = 7,
	COUNT = 8
};
gt.Const.BloodDecals <- [
	[],
	[
		"blood_red_01",
		"blood_red_02",
		"blood_red_03",
		"blood_red_04",
		"blood_red_05",
		"blood_red_06",
		"blood_red_07",
		"blood_red_08",
		"blood_red_09",
		"blood_red_10"
	],
	[
		"blood_dark_01",
		"blood_dark_02",
		"blood_dark_03",
		"blood_dark_04",
		"blood_dark_05",
		"blood_dark_06",
		"blood_dark_07"
	],
	[
		"blood_bones_01",
		"blood_bones_02",
		"blood_bones_03",
		"blood_bones_04",
		"blood_bones_05",
		"blood_bones_06",
		"blood_bones_07"
	],
	[],
	[
		"blood_green_01",
		"blood_green_02",
		"blood_green_03",
		"blood_green_04",
		"blood_green_05",
		"blood_green_06",
		"blood_green_07",
		"blood_green_08",
		"blood_green_09",
		"blood_green_10"
	],
	[
		"blood_wood_1",
		"blood_wood_2",
		"blood_wood_3",
		"blood_wood_4",
		"blood_wood_5",
		"blood_wood_6",
		"blood_wood_7"
	],
	[]
];
gt.Const.BloodPoolDecals <- [
	[],
	[
		"bloodpool_red_01",
		"bloodpool_red_03",
		"bloodpool_red_04"
	],
	[
		"bloodpool_dark_01",
		"bloodpool_dark_03",
		"bloodpool_dark_04"
	],
	[],
	[],
	[
		"bloodpool_green_01",
		"bloodpool_green_03",
		"bloodpool_green_04"
	],
	[],
	[]
];
gt.Const.BloodPoolTerrainAlpha <- [
	0.0,
	1.0,
	1.0,
	1.0,
	1.0,
	1.0,
	0.66,
	0.8,
	0.66,
	0.66
];
gt.Const.CorpsePart <- [
	"corpse_part_01",
	"corpse_part_02",
	"corpse_part_03",
	"corpse_part_04",
	"corpse_part_05"
];
gt.Const.ProjectileType <- {
	None = 0,
	Arrow = 1,
	Javelin = 2,
	Bola = 3,
	Axe = 4,
	Flask = 5,
	Flask2 = 6,
	Stone = 7,
	Rock = 8,
	Bomb1 = 9,
	Bomb2 = 10,
	COUNT = 11
};
gt.Const.ProjectileDecals <- [
	[],
	[
		"arrow_missed_01",
		"arrow_missed_02",
		"arrow_missed_03",
		"arrow_missed_04",
		"arrow_missed_05",
		"arrow_missed_06",
		"arrow_missed_07",
		"arrow_missed_08"
	],
	[
		"javelin_missed_10",
		"javelin_missed_11",
		"javelin_missed_12"
	],
	[
		"balls_missed_01",
		"balls_missed_02"
	],
	[
		"axe_missed_01",
		"axe_missed_02",
		"axe_missed_03"
	],
	[],
	[],
	[
		"detail_stone_00",
		"detail_stone_01",
		"detail_stone_02",
		"detail_stone_03",
		"detail_stone_04"
	],
	[],
	[],
	[]
];
gt.Const.ProjectileSprite <- [
	"",
	"projectile_01",
	"projectile_02",
	"projectile_03",
	"projectile_04",
	"projectile_05",
	"projectile_06",
	"projectile_07",
	"projectile_08",
	"projectile_09",
	"projectile_10"
];
gt.Const.FliesDecals <- [
	"detail_flies_01",
	"detail_flies_02",
	"detail_flies_03",
	"detail_flies_04",
	"detail_flies_05",
	"detail_flies_06",
	"detail_flies_07",
	"detail_flies_08"
];
gt.Const.DefaultMovementAPCost <- [
	0,
	2,
	2,
	3,
	3,
	4,
	4,
	2,
	4
];
gt.Const.PathfinderMovementAPCost <- [
	0,
	2,
	2,
	2,
	2,
	3,
	3,
	2,
	3
];
gt.Const.ImmobileMovementAPCost <- [
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
];
gt.Const.SameMovementAPCost <- [
	0,
	2,
	2,
	2,
	2,
	2,
	2,
	2,
	2
];
gt.Const.NoMovementFatigueCost <- [
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
];
gt.Const.DefaultMovementFatigueCost <- [
	0,
	2,
	4,
	6,
	6,
	8,
	14,
	6,
	12
];
gt.Const.PathfinderMovementFatigueCost <- [
	0,
	2,
	2,
	3,
	3,
	4,
	7,
	3,
	6
];
gt.Const.SkillCounter <- 0;
gt.Const.CharacterProperties <- {
	function getClone()
	{
		local c = clone this;
		c.Armor = clone this.Armor;
		c.ArmorMax = clone this.ArmorMax;
		c.ArmorMult = clone this.ArmorMult;
		c.HitChance = clone this.HitChance;
		c.HitChanceMult = clone this.HitChanceMult;
		c.DamageAgainstMult = clone this.DamageAgainstMult;
		c.MoraleCheckBravery = clone this.MoraleCheckBravery;
		c.MoraleCheckBraveryMult = clone this.MoraleCheckBraveryMult;
		return c;
	}

	ActionPoints = 0,
	ActionPointsMult = 1.0,
	AdditionalActionPointCost = 0,
	Hitpoints = 0,
	HitpointsMult = 1.0,
	HitpointsRecoveryRate = 0,
	HitpointsRecoveryRateMult = 1.0,
	Bravery = 0,
	BraveryMult = 1.0,
	MoraleEffectMult = 1.0,
	Stamina = 0,
	StaminaMult = 1.0,
	FatigueOnSkillUse = 0,
	FatigueEffectMult = 1.0,
	FatigueRecoveryRate = 15,
	FatigueRecoveryRateMult = 1.0,
	FatigueArmorMult = 1.0,
	FatigueToInitiativeRate = 1.0,
	Initiative = 0,
	InitiativeMult = 1.0,
	InitiativeForTurnOrderMult = 1.0,
	InitiativeForTurnOrderAdditional = 0,
	InitiativeAfterWaitMult = this.Const.Combat.InitiativeAfterWaitMult,
	MeleeSkill = 0,
	MeleeSkillMult = 1.0,
	RangedSkill = 0,
	RangedSkillMult = 1.0,
	TotalAttackToHitMult = 1.0,
	TotalDefenseToHitMult = 1.0,
	MeleeDefense = 0,
	MeleeDefenseMult = 1.0,
	RangedDefense = 0,
	RangedDefenseMult = 1.0,
	Threat = 0,
	ThreatOnHit = 0,
	Vision = 7,
	VisionMult = 1.0,
	XPGainMult = 1.0,
	MovementAPCostAdditional = 0,
	MovementAPCostMult = 1.0,
	MovementFatigueCostAdditional = 0,
	MovementFatigueCostMult = 1.0,
	RangedAttackBlockedChanceMult = 1.0,
	FatalityChanceMult = 1.0,
	DamageReceivedRegularMult = 1.0,
	DamageReceivedArmorMult = 1.0,
	DamageReceivedDirectMult = 1.0,
	DamageReceivedRangedMult = 1.0,
	DamageReceivedMeleeMult = 1.0,
	DamageReceivedTotalMult = 1.0,
	DamageRegularReduction = 0,
	DamageArmorReduction = 0,
	Armor = [
		0.0,
		0.0
	],
	ArmorMax = [
		0.0,
		0.0
	],
	ArmorMult = [
		1.0,
		1.0
	],
	FatigueReceivedPerHitMult = 1.0,
	MoraleCheckBravery = [
		0,
		0,
		0
	],
	MoraleCheckBraveryMult = [
		1.0,
		1.0,
		1.0
	],
	ThresholdToReceiveInjuryMult = 1.0,
	SurviveWithInjuryChanceMult = 1.0,
	StartSurroundCountAt = 0,
	SurroundedDefense = 0,
	RerollDefenseChance = 0,
	RerollMoraleChance = 0,
	NegativeStatusEffectDuration = 0,
	DamageAgainstMult = [
		1.0,
		1.5
	],
	HitChance = [
		75,
		25
	],
	HitChanceMult = [
		1.0,
		1.0
	],
	HitChanceAdditionalWithEachTile = 0.0,
	HitChanceWithEachTileMult = 1.0,
	FatigueDealtPerHitMult = 1.0,
	FatigueLossOnAnyAttackMult = 1.0,
	MeleeDamageMult = 1.0,
	RangedDamageMult = 1.0,
	DamageRegularMin = 0,
	DamageRegularMax = 0,
	DamageRegularMult = 1.0,
	DamageArmorMult = 1.0,
	DamageDirectAdd = 0.0,
	DamageDirectMeleeAdd = 0.0,
	DamageDirectRangedAdd = 0.0,
	DamageDirectMult = 1.0,
	DamageTotalMult = 1.0,
	DamageAdditionalWithEachTile = 0.0,
	DamageMinimum = 0,
	DamageTooltipMinMult = 1.0,
	DamageTooltipMaxMult = 1.0,
	ThresholdToInflictInjuryMult = 1.0,
	SurroundedBonus = 5,
	SurroundedBonusMult = 1.0,
	TargetAttractionMult = 1.0,
	IsImmuneToOverwhelm = false,
	IsImmuneToZoneOfControl = false,
	IsImmuneToStun = false,
	IsImmuneToDaze = false,
	IsImmuneToRoot = false,
	IsImmuneToKnockBackAndGrab = false,
	IsImmuneToRotation = false,
	IsImmuneToDisarm = false,
	IsImmuneToSurrounding = false,
	IsImmuneToBleeding = false,
	IsImmuneToPoison = false,
	IsImmuneToDamageReflection = false,
	IsImmuneToFire = false,
	IsIgnoringArmorOnAttack = false,
	IsResistantToAnyStatuses = false,
	IsResistantToPhysicalStatuses = false,
	IsResistantToMiasma = false,
	IsRooted = false,
	IsStunned = false,
	IsMovable = true,
	IsAbleToUseSkills = true,
	IsAbleToUseWeaponSkills = true,
	IsAttackingOnZoneOfControlEnter = false,
	IsAttackingOnZoneOfControlAlways = false,
	IsRiposting = false,
	IsSkillUseFree = false,
	IsSkillUseHalfCost = false,
	IsAffectedByNight = true,
	IsAffectedByInjuries = true,
	IsAffectedByFreshInjuries = true,
	IsAffectedByFleeingAllies = true,
	IsAffectedByDyingAllies = true,
	IsAffectedByLosingHitpoints = true,
	IsStealthed = false,
	IsFleetfooted = false,
	IsSharpshooter = false,
	IsProficientWithHeavyWeapons = false,
	IsProficientWithShieldWall = false,
	IsProficientWithShieldSkills = false,
	IsSpecializedInBows = false,
	IsSpecializedInCrossbows = false,
	IsSpecializedInThrowing = false,
	IsSpecializedInSwords = false,
	IsSpecializedInCleavers = false,
	IsSpecializedInMaces = false,
	IsSpecializedInHammers = false,
	IsSpecializedInAxes = false,
	IsSpecializedInFlails = false,
	IsSpecializedInSpears = false,
	IsSpecializedInPolearms = false,
	IsSpecializedInDaggers = false,
	IsSpecializedInShields = false,
	IsContentWithBeingInReserve = false,
	IsAllyXPBlocked = false,
	DailyWage = 0,
	DailyWageMult = 1.0,
	DailyFood = 2.0,
	function getMeleeDefense()
	{
		if (this.MeleeDefense >= 0)
		{
			return this.Math.floor(this.MeleeDefense * (this.MeleeDefenseMult >= 0 ? this.MeleeDefenseMult : 1.0 / this.MeleeDefenseMult));
		}
		else
		{
			return this.Math.floor(this.MeleeDefense * (this.MeleeDefenseMult < 0 ? this.MeleeDefenseMult : 1.0 / this.MeleeDefenseMult));
		}
	}

	function getRangedDefense()
	{
		if (this.RangedDefense >= 0)
		{
			return this.Math.floor(this.RangedDefense * (this.RangedDefenseMult >= 0 ? this.RangedDefenseMult : 1.0 / this.RangedDefenseMult));
		}
		else
		{
			return this.Math.floor(this.RangedDefense * (this.RangedDefenseMult < 0 ? this.RangedDefenseMult : 1.0 / this.RangedDefenseMult));
		}
	}

	function getMeleeSkill()
	{
		return this.Math.floor(this.MeleeSkill * (this.MeleeSkill >= 0 ? this.MeleeSkillMult : 1.0 / this.MeleeSkillMult));
	}

	function getRangedSkill()
	{
		return this.Math.floor(this.RangedSkill * (this.RangedSkillMult >= 0 ? this.RangedSkillMult : 1.0 / this.RangedSkillMult));
	}

	function getVision()
	{
		return this.Math.max(1, this.Math.floor(this.Vision * this.VisionMult));
	}

	function getBravery()
	{
		return this.Math.floor(this.Bravery * (this.BraveryMult >= 0 ? this.BraveryMult : 1.0 / this.BraveryMult));
	}

	function getInitiative()
	{
		return this.Math.floor(this.Initiative * (this.InitiativeMult >= 0 ? this.InitiativeMult : 1.0 / this.InitiativeMult));
	}

	function getRegularDamageAverage()
	{
		return this.Math.floor((this.DamageRegularMin + (this.DamageRegularMax - this.DamageRegularMin) / 2) * this.DamageRegularMult * this.DamageTotalMult);
	}

	function getArmorDamageAverage()
	{
		return this.Math.floor((this.DamageRegularMin + (this.DamageRegularMax - this.DamageRegularMin) / 2) * this.DamageArmorMult * this.DamageTotalMult);
	}

	function getDamageRegularMin()
	{
		return this.Math.floor(this.DamageRegularMin * this.DamageRegularMult * this.DamageTotalMult);
	}

	function getDamageRegularMax()
	{
		return this.Math.floor(this.DamageRegularMax * this.DamageRegularMult * this.DamageTotalMult);
	}

	function getDamageArmorMin()
	{
		return this.Math.floor(this.DamageRegularMin * this.DamageArmorMult * this.DamageTotalMult);
	}

	function getDamageArmorMax()
	{
		return this.Math.floor(this.DamageRegularMax * this.DamageArmorMult * this.DamageTotalMult);
	}

	function getDamageArmorMult()
	{
		return this.DamageArmorMult;
	}

	function getHitchance( _bodyPart )
	{
		if (_bodyPart == this.Const.BodyPart.Head)
		{
			return this.Math.min(100.0, this.Math.floor(this.HitChance[_bodyPart] * this.HitChanceMult[_bodyPart]) * 1.0);
		}
		else
		{
			return 100.0 - this.Math.minf(100.0, this.getHitchance(this.Const.BodyPart.Head));
		}
	}

	function setValues( _t )
	{
		this.ActionPoints = _t.ActionPoints;
		this.Hitpoints = _t.Hitpoints;
		this.Bravery = _t.Bravery;
		this.Stamina = _t.Stamina;
		this.MeleeSkill = _t.MeleeSkill;
		this.RangedSkill = _t.RangedSkill;
		this.MeleeDefense = _t.MeleeDefense;
		this.RangedDefense = _t.RangedDefense;
		this.Initiative = _t.Initiative;
		this.Armor[0] = _t.Armor[0];
		this.Armor[1] = _t.Armor[1];
		this.ArmorMax = clone this.Armor;

		if (_t.rawin("FatigueRecoveryRate"))
		{
			this.FatigueRecoveryRate = _t.FatigueRecoveryRate;
		}

		if (_t.rawin("MoraleEffectMult"))
		{
			this.MoraleEffectMult = _t.MoraleEffectMult;
		}

		if (_t.rawin("FatigueEffectMult"))
		{
			this.FatigueEffectMult = _t.FatigueEffectMult;
		}

		if (_t.rawin("Vision"))
		{
			this.Vision = _t.Vision;
		}

		if (_t.rawin("DamageRegularMin"))
		{
			this.DamageRegularMin = _t.DamageRegularMin;
		}

		if (_t.rawin("DamageRegularMax"))
		{
			this.DamageRegularMax = _t.DamageRegularMax;
		}

		if (_t.rawin("DamageRegularMult"))
		{
			this.DamageRegularMult = _t.DamageRegularMult;
		}

		if (_t.rawin("DamageArmorMult"))
		{
			this.DamageArmorMult = _t.DamageArmorMult;
		}

		if (_t.rawin("DamageTotalMult"))
		{
			this.DamageTotalMult = _t.DamageTotalMult;
		}
	}

	function onSerialize( _out )
	{
		_out.writeU8(this.ActionPoints);
		_out.writeI16(this.Hitpoints);
		_out.writeI16(this.Bravery);
		_out.writeI16(this.Stamina);
		_out.writeI16(this.MeleeSkill);
		_out.writeI16(this.RangedSkill);
		_out.writeI16(this.MeleeDefense);
		_out.writeI16(this.RangedDefense);
		_out.writeI16(this.Initiative);
		_out.writeI16(this.DailyWage);
		_out.writeF32(this.DailyFood);
	}

	function onDeserialize( _in )
	{
		this.ActionPoints = _in.readU8();
		this.Hitpoints = _in.readI16();
		this.Bravery = _in.readI16();
		this.Stamina = _in.readI16();
		this.MeleeSkill = _in.readI16();
		this.RangedSkill = _in.readI16();
		this.MeleeDefense = _in.readI16();
		this.RangedDefense = _in.readI16();
		this.Initiative = _in.readI16();
		this.DailyWage = _in.readI16();
		this.DailyFood = _in.readF32();
	}

};

