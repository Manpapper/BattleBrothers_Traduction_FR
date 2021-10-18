this.small_farming_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Weidefeld",
			"Hemmeln",
			"Saxdorf",
			"Kochendorf",
			"Altenhof",
			"Weidenau",
			"Schnellen",
			"Neudorf",
			"Freidorf",
			"Weissenhaus",
			"Muhlenheim",
			"Grunfelde",
			"Ivendorf",
			"Grafenheide",
			"Hermannshof",
			"Koppeldorf",
			"Meiding",
			"Varel",
			"Durbach",
			"Dreifelden",
			"Bockhorn",
			"Hufschlag",
			"Hage",
			"Wagenheim",
			"Harlingen",
			"Wiese",
			"Wiesendorf",
			"Markdorf",
			"Heuweiler",
			"Bitterfeld",
			"Neuenried",
			"Auenbach",
			"Adelshofen",
			"Allersdorf",
			"Brunnendorf",
			"Ochsenhausen",
			"Weingarten",
			"Konigsfeld",
			"Rosenhof",
			"Weidenbach"
		]);
		this.m.DraftList = [
			"beggar_background",
			"daytaler_background",
			"daytaler_background",
			"farmhand_background",
			"farmhand_background",
			"farmhand_background",
			"farmhand_background",
			"miller_background",
			"miller_background",
			"ratcatcher_background",
			"tailor_background",
			"vagabond_background",
			"poacher_background"
		];
		this.m.UIDescription = "A small farming village living mostly off of the surrounding fertile lands";
		this.m.Description = "A small farming village living mostly off of the surrounding fertile lands.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_01";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_01_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_01.png";
		this.m.Sprite = "world_townhall_01";
		this.m.Lighting = "world_townhall_01_light";
		this.m.Rumors = this.Const.Strings.RumorsFarmingSettlement;
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
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		}
		else if (this.Math.rand(1, 100) <= 25)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
		}

		this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/wheat_fields_location", [
			this.Const.World.TerrainType.Plains
		], [], 2);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/orchard_location", [
			this.Const.World.TerrainType.Plains
		], [], 1);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wool_spinner_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Plains
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/herbalists_grove_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 2, true);
	}

});

