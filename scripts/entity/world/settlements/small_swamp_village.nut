this.small_swamp_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Stakendorf",
			"Schwartbuck",
			"Monkamp",
			"Sehlendorf",
			"Schwarzpfuhl",
			"Ehlerstorf",
			"Torfbruck",
			"Mohrdorf",
			"Streekmoor",
			"Kolkdorf",
			"Schwarzwasser",
			"Lauenbruck",
			"Farnheim",
			"Birkhain",
			"Ahlen",
			"Suderbusch",
			"Altenfurth",
			"Breitenbrunn",
			"Grunbach",
			"Grunwasser",
			"Schmalfurth",
			"Grossfurth",
			"Grunkraut",
			"Schattenfluth",
			"Weissenbach",
			"Kaltenbach",
			"Tarsdorf",
			"Tiefenbach",
			"Julbach",
			"Auengrund",
			"Schwarzbrook",
			"Brookdorf",
			"Brookheim"
		]);
		this.m.DraftList = [
			"beggar_background",
			"cultist_background",
			"cultist_background",
			"daytaler_background",
			"daytaler_background",
			"flagellant_background",
			"poacher_background",
			"poacher_background",
			"ratcatcher_background",
			"ratcatcher_background",
			"vagabond_background",
			"wildman_background",
			"wildman_background",
			"witchhunter_background"
		];

		if (this.Const.DLC.Unhold)
		{
			this.m.DraftList.push("beast_hunter_background");
		}

		this.m.UIDescription = "A small and crude settlement in a swampy area";
		this.m.Description = "A small settlement in a swampy area. The people living here sure know hardship.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_01";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_01_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_01.png";
		this.m.Sprite = "world_townhall_01";
		this.m.Lighting = "world_townhall_01_light";
		this.m.Rumors = this.Const.Strings.RumorsSwampSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
		this.m.Size = 1;
		this.m.HousesType = 1;
		this.m.HousesMin = 1;
		this.m.HousesMax = 2;
		this.m.AttachedLocationsMax = 3;
		this.m.ProduceString = "mushrooms";
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);

		if (this.Const.DLC.Unhold && (this.Const.World.Buildings.Taxidermists == 0 || this.Math.rand(1, 100) <= 33))
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/taxidermist_building"));
		}
		else if (this.Math.rand(1, 100) <= 33)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/mushroom_grove_location", [
				this.Const.World.TerrainType.Swamp
			], [], 2);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], []);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/mushroom_grove_location", [
				this.Const.World.TerrainType.Swamp
			], [], 2);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], []);
		}

		this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/peat_pit_location", [
			this.Const.World.TerrainType.Swamp
		], []);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/herbalists_grove_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 2);
	}

});

