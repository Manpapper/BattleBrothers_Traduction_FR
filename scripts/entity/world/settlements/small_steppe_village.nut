this.small_steppe_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Wohlen",
			"Krauchthal",
			"Brunnenthal",
			"Erlach",
			"Treiten",
			"Tentlingen",
			"Himmelsdorf",
			"Thurn",
			"Subingen",
			"Thunstetten",
			"Rothenbach",
			"Sandheim",
			"Sonstedt",
			"Siegau",
			"Strohdorf",
			"Sonnheim",
			"Sandfels",
			"Sonnfels",
			"Attendorn",
			"Strauchdorf",
			"Kargau",
			"Sudheim",
			"Krauchdorf",
			"Dornen",
			"Dornthal",
			"Dornheim"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"beggar_background",
			"brawler_background",
			"caravan_hand_background",
			"gambler_background",
			"daytaler_background",
			"daytaler_background",
			"peddler_background",
			"refugee_background",
			"tailor_background",
			"thief_background",
			"vagabond_background",
			"poacher_background"
		];
		this.m.UIDescription = "A small village in the steppe living mainly off of modest trading";
		this.m.Description = "A small village in the steppe living mainly off of modest trading.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_01";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_01_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_01.png";
		this.m.Sprite = "world_townhall_01";
		this.m.Lighting = "world_townhall_01_light";
		this.m.Rumors = this.Const.Strings.RumorsSteppeSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
		this.m.Size = 1;
		this.m.HousesType = 1;
		this.m.HousesMin = 1;
		this.m.HousesMax = 2;
		this.m.AttachedLocationsMax = 3;
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);

		if (this.Math.rand(1, 100) <= 25)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
		}
		else if (this.Math.rand(1, 100) <= 25)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/fletcher_building"));
		}
		else if (this.Math.rand(1, 100) <= 25)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/beekeeper_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Hills
			], [], 1);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/winery_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Hills
			]);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/beekeeper_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Hills
			], [], 1);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/winery_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Hills
			]);
		}

		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/dye_maker_location", [
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 1);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/fletchers_hut_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Steppe
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/goat_herd_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Steppe
		]);
	}

});

