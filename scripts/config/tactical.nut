local gt = this.getroottable();

if (!("Tactical" in gt.Const))
{
	gt.Const.Tactical <- {};
}

gt.Const.Tactical.ActionState <- {
	ComputePath = 0,
	TravelPath = 1,
	SkillSelected = 2,
	ExecuteSkill = 3
};
gt.Const.Tactical.CameraEventType <- {
	Idle = 0,
	MoveTo = 1,
	MoveToSlowly = 2,
	MoveToIfNotVisible = 3,
	JumpTo = 4
};
gt.Const.Tactical.CameraEventState <- {
	Queued = 0,
	Focus = 1,
	WaitOnCallback = 2,
	WaitOnFinalization = 3
};
gt.Const.Tactical.CombatResult <- {
	None = 0,
	EnemyRetreated = 1,
	EnemyDestroyed = 2,
	PlayerRetreated = 3,
	PlayerDestroyed = 4
};
gt.Const.Tactical.MovementType <- {
	Default = 0,
	Involuntary = 1,
	Ignore = 2
};
gt.Const.Tactical.DetailFlag <- {
	None = 0,
	Loot = 1,
	Corpse = 8,
	SeveredHead = 16,
	Effect = 32,
	Overlay = 64,
	SpecialOverlay = 128,
	Scorchmark = 256
};
gt.Const.Tactical.Settings <- {
	MapBorderColor = "#666666",
	EnemyZoneOfControlColor = "#330000",
	EnemyMovementAreaColor = "#222222",
	PlayerMovementAreaColor = "#222222",
	SkillAreaColor = "#330000",
	RangedSkillBlockedIcon = "overlay_ranged_attack_blocked",
	AreaOfEffectIcon = "overlay_aoe_attack",
	SkillOverlayOffsetX = 0,
	SkillOverlayOffsetY = 105,
	SkillOverlayScale = 0.75,
	SkillOverlayStayDuration = 500,
	SkillOverlayFadeDuration = 900,
	AttackEffectOffsetX = 35,
	AttackEffectOffsetY = 40,
	AttackEffectScale = 1.0,
	AttackEffectStayDuration = 0,
	AttackEffectFadeInDuration = 150,
	AttackEffectFadeOutDuration = 150,
	SkillIconOffsetX = 0,
	SkillIconOffsetY = 190,
	SkillIconFadeInDuration = 100,
	SkillIconStayDuration = 550,
	SkillIconFadeOutDuration = 180,
	SkillIconMovement = this.createVec(0, -200),
	SkillIconScale = 0.75,
	CameraWaitForEventDelay = 500,
	CameraNextEventDelay = 1000,
	SwitchWeaponAPCost = 4,
	SwitchItemAPCost = 4,
	CampRadius = 7
};
gt.Const.Tactical.AmbientLightingColor <- {
	Default = "#ffffff",
	Fog = "#eeeeee",
	Dawn = "#cae7f8",
	Dusk = "#f8c3be",
	Night = "#6c96d7",
	Midday = "#ffffff",
	Rain = "#c3cbd0",
	LightRain = "#e0e8ef",
	Storm = "#9ba5ad",
	Desert = "#f5f0e1",
	Time = [
		"#cae7f8",
		"#ffc092",
		"#ffffff",
		"#ffffff",
		"#d0deed",
		"#f8c3be",
		"#6c96d7",
		"#b0c7f4"
	]
};
gt.Const.Tactical.AmbientLightingSaturation <- {
	Default = 1.0,
	Fog = 0.9,
	Dawn = 1.0,
	Dusk = 1.0,
	Night = 0.5,
	Midday = 1.0,
	Rain = 1.0,
	LightRain = 1.0,
	Storm = 0.9,
	Desert = 1.0,
	Time = [
		1.0,
		1.0,
		1.0,
		1.0,
		1.0,
		1.0,
		0.5,
		0.9
	]
};
gt.Const.Tactical.TileBlendPriority <- {
	Steppe3 = 0,
	Earth = 1,
	Autumn2 = 2,
	Swamp = 3,
	Forest = 4,
	Swamp4 = 5,
	Swamp5 = 6,
	Swamp2 = 7,
	Swamp1 = 8,
	Swamp3 = 9,
	Road = 10,
	Tundra2 = 11,
	Autumn1 = 12,
	Tundra5 = 13,
	Stone2 = 14,
	Autumn4 = 15,
	Tundra3 = 16,
	Tundra4 = 17,
	Tundra1 = 18,
	Autumn3 = 19,
	Moss2 = 20,
	Moss1 = 21,
	Grass = 22,
	Grass2 = 23,
	Grass1 = 24,
	Snow3 = 25,
	Snow1 = 26,
	Snow2 = 27,
	Steppe4 = 28,
	Steppe5 = 29,
	Steppe1 = 30,
	Steppe2 = 31,
	Desert5 = 32,
	Desert6 = 33,
	Desert1 = 34,
	Desert2 = 35,
	Desert7 = 36,
	Desert3 = 37,
	Desert4 = 38,
	COUNT = 39
};
gt.Const.Tactical.TerrainType <- {
	Impassable = 0,
	PavedGround = 1,
	FlatGround = 2,
	RoughGround = 3,
	Forest = 4,
	Rocks = 5,
	Swamp = 6,
	Sand = 7,
	ShallowWater = 8,
	DeepWater = 9,
	COUNT = 10
};
gt.Const.Tactical.TerrainEffect <- [
	"",
	"",
	"",
	"",
	"",
	"",
	"scripts/skills/terrain/swamp_effect",
	"",
	"",
	"",
	""
];
gt.Const.Tactical.TerrainEffectID <- [
	"",
	"",
	"",
	"",
	"",
	"",
	"terrain.swamp",
	"",
	"",
	"",
	""
];
gt.Const.Tactical.TerrainEffectTooltip <- [
	[],
	[],
	[],
	[],
	[],
	[],
	[
		{
			id = 4,
			type = "text",
			icon = "/ui/icons/melee_skill.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Maîtrise de Mêlée"
		},
		{
			id = 5,
			type = "text",
			icon = "/ui/icons/melee_defense.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Défense de Mêlée"
		},
		{
			id = 6,
			type = "text",
			icon = "/ui/icons/ranged_defense.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Défense à Distance"
		}
	],
	[],
	[],
	[]
];
gt.Const.Tactical.TerrainSubtype <- {
	None = 0,
	DirtRoad = 1,
	ClayRoad = 2,
	CobblestoneRoad = 3,
	Grassland = 4,
	Dirt = 5,
	Forest = 6,
	MoistEarth = 7,
	PlashyGrass = 8,
	MurkyWater = 9,
	Steppe = 10,
	DrySteppe = 11,
	Tundra = 12,
	Snow = 13,
	LightSnow = 14,
	FlatStone = 15,
	RoughStone = 16,
	Desert = 17,
	ShallowWater = 18,
	COUNT = 19
};
gt.Const.Tactical.TerrainMovementSound <- [
	[],
	[
		{
			File = "movement/movement_dry_earth_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_dry_earth_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_stone_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_grass_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_dry_earth_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_forest_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_forest_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_forest_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_forest_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_forest_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_muddy_earth_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_muddy_earth_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_muddy_earth_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_muddy_earth_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_muddy_earth_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_grass_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_shallow_water_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_shallow_water_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_shallow_water_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_shallow_water_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_grass_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_grass_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_dry_earth_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_dry_earth_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_dry_earth_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_snow_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_snow_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_snow_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_snow_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_snow_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_snow_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_snow_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_snow_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_stone_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_stone_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_stone_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/dlc6/movement_sand_01.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/dlc6/movement_sand_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/dlc6/movement_sand_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/dlc6/movement_sand_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/dlc6/movement_sand_05.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/dlc6/movement_sand_06.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/dlc6/movement_sand_07.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/dlc6/movement_sand_08.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	],
	[
		{
			File = "movement/movement_shallow_water_00.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_shallow_water_02.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_shallow_water_03.wav",
			Volume = 1.0,
			Pitch = 1.0
		},
		{
			File = "movement/movement_shallow_water_04.wav",
			Volume = 1.0,
			Pitch = 1.0
		}
	]
];
gt.Const.Tactical.TerrainSubtypeAllowProjectileDecals <- [
	false,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	true,
	false
];
gt.Const.Tactical.FortificationType <- {
	None = 0,
	Palisade = 1,
	Walls = 2,
	WallsAndPalisade = 3
};
gt.Const.Tactical.LocationTemplate <- {
	OwnedByFaction = 0,
	Template = [
		null,
		null
	],
	Fortification = this.Const.Tactical.FortificationType.None,
	CutDownTrees = false,
	ForceLineBattle = false,
	ShiftX = 6,
	ShiftY = 0,
	AdditionalRadius = 0
};
gt.Const.Tactical.HitInfo <- {
	DamageRegular = 0.0,
	DamageArmor = 0.0,
	DamageDirect = 0.0,
	DamageFatigue = 0.0,
	DamageMinimum = 0,
	BodyPart = 0,
	BodyDamageMult = 1.0,
	FatalityChanceMult = 1.0,
	DamageInflictedHitpoints = 0,
	DamageInflictedArmor = 0,
	Injuries = null,
	InjuryThresholdMult = 1.0,
	Tile = null,
	IsPlayingArmorSound = true
};
gt.Const.Tactical.DeploymentType <- {
	Auto = 0,
	Line = 1,
	LineBack = 2,
	LineForward = 3,
	Pincer = 4,
	Circle = 5,
	Center = 6,
	Edge = 7,
	Camp = 8,
	Random = 9,
	Arena = 10,
	Custom = 11
};
gt.Const.Tactical.CombatInfo <- {
	TerrainTemplate = null,
	LocationTemplate = null,
	Tile = null,
	Entities = [],
	Players = [],
	Parties = [],
	Music = [],
	Ambience = [
		[],
		[]
	],
	AmbienceMinDelay = [
		this.Const.Sound.AmbienceMinDelay,
		this.Const.Sound.AmbienceMinDelay
	],
	TemporaryEnemies = [],
	AllyBanners = [],
	EnemyBanners = [],
	Loot = [],
	PlayerDeploymentType = this.Const.Tactical.DeploymentType.Auto,
	EnemyDeploymentType = this.Const.Tactical.DeploymentType.Auto,
	PlayerDeploymentCallback = null,
	EnemyDeploymentCallback = null,
	BeforeDeploymentCallback = null,
	AfterDeploymentCallback = null,
	CombatID = "Default",
	MapSeed = 0,
	InCombatAlready = false,
	IsPlayerInitiated = false,
	IsAttackingLocation = false,
	IsWithoutAmbience = false,
	IsFleeingProhibited = false,
	IsLootingProhibited = false,
	IsAutoAssigningBases = true,
	IsUsingSetPlayers = false,
	IsFogOfWarVisible = true,
	IsArenaMode = false,
	function getClone()
	{
		local p = clone this;
		p.Entities = [];
		p.Parties = [];
		p.Music = [];
		p.TemporaryEnemies = [];
		p.AllyBanners = [
			this.World.Assets.getBanner()
		];
		p.EnemyBanners = [];
		p.Loot = [];
		p.Players = [];
		p.Ambience = [
			[],
			[]
		];
		p.AmbienceMinDelay = [
			this.Const.Sound.AmbienceMinDelay,
			this.Const.Sound.AmbienceMinDelay
		];
		return p;
	}

};

