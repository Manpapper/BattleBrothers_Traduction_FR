this.small_fishing_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Seedorf",
			"Kielseng",
			"Meierwik",
			"Sanddorf",
			"Sandwik",
			"Holnis",
			"Holmwik",
			"Niewik",
			"Hattlund",
			"Stohl",
			"Strande",
			"Sandkamp",
			"Sandberg",
			"Birkenstrand",
			"Sundheim",
			"Seekamp",
			"Krakendorf",
			"Blankwasser",
			"Harkensee",
			"Otterndorf",
			"Seefeld",
			"Horum",
			"Krumhorn",
			"Gothmund",
			"Angeln",
			"Sandholm",
			"Jadensee",
			"Egernsande",
			"Nebelheim",
			"Sudersande",
			"Grossenkoog",
			"Aalbek",
			"Seedeich"
		]);
		this.m.DraftList = [
			"beggar_background",
			"beggar_background",
			"daytaler_background",
			"fisherman_background",
			"fisherman_background",
			"fisherman_background",
			"fisherman_background",
			"fisherman_background",
			"gravedigger_background",
			"peddler_background",
			"tailor_background",
			"vagabond_background",
			"vagabond_background"
		];
		this.m.UIDescription = "A small fishing village made up of a few humble huts";
		this.m.Description = "A small fishing village made up of a few humble huts.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_01";
		this.m.UIBackgroundLeft = "ui/settlements/water_01";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_01.png";
		this.m.Sprite = "world_townhall_01";
		this.m.Lighting = "world_townhall_01_light";
		this.m.Rumors = this.Const.Strings.RumorsFishingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
		this.m.Size = 1;
		this.m.HousesType = 1;
		this.m.HousesMin = 1;
		this.m.HousesMax = 2;
		this.m.AttachedLocationsMax = 3 + 1;
		this.m.ProduceString = "fish";
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/port_building"), 3);

		if (this.Math.rand(1, 100) <= 20)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		}

		this.buildAttachedLocation(1, "scripts/entity/world/attached_location/harbor_location", [
			this.Const.World.TerrainType.Shore
		], [
			this.Const.World.TerrainType.Ocean,
			this.Const.World.TerrainType.Shore
		], -1, false, false);
		this.buildAttachedLocation(1, "scripts/entity/world/attached_location/fishing_huts_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Shore
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/amber_collector_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Shore
		], 1);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/herbalists_grove_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], []);
	}

});

