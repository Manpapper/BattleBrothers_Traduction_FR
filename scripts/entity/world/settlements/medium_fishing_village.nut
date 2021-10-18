this.medium_fishing_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Seedock",
			"Wikhavn",
			"Sandhoom",
			"Sandkai",
			"Holnishovn",
			"Holmwader",
			"Niewekai",
			"Stohlhoven",
			"Strandekai",
			"Kampwader",
			"Birkhaven",
			"Sundkajung",
			"Seehoben",
			"Krakenwader",
			"Blankhoom",
			"Harkendock",
			"Krumwader",
			"Saltkai",
			"Salthaven",
			"Grotenhoom",
			"Lutendock",
			"Kaiwader",
			"Singhoben",
			"Weissenhaven",
			"Tiefenhaven",
			"Wasserkoog",
			"Osterstrande",
			"Steinhaven",
			"Duhnenhaven",
			"Neudeich",
			"Sandehaven"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"beggar_background",
			"beggar_background",
			"brawler_background",
			"caravan_hand_background",
			"daytaler_background",
			"fisherman_background",
			"fisherman_background",
			"fisherman_background",
			"fisherman_background",
			"fisherman_background",
			"gravedigger_background",
			"graverobber_background",
			"historian_background",
			"juggler_background",
			"killer_on_the_run_background",
			"messenger_background",
			"militia_background",
			"monk_background",
			"peddler_background",
			"flagellant_background",
			"ratcatcher_background",
			"refugee_background",
			"servant_background",
			"tailor_background",
			"thief_background",
			"vagabond_background",
			"cripple_background",
			"eunuch_background",
			"sellsword_background"
		];
		this.m.UIDescription = "A larger spread out village relying on fishing and a little trade";
		this.m.Description = "A larger spread out village relying on fishing and a little trade.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_02";
		this.m.UIBackgroundLeft = "ui/settlements/water_01";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_02_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_02.png";
		this.m.Sprite = "world_townhall_02";
		this.m.Lighting = "world_townhall_02_light";
		this.m.Rumors = this.Const.Strings.RumorsFishingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
		this.m.Size = 2;
		this.m.HousesType = 2;
		this.m.HousesMin = 2;
		this.m.HousesMax = 3;
		this.m.AttachedLocationsMax = 4 + 1;
		this.m.ProduceString = "fish";
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/port_building"), 3);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));

		if (this.Math.rand(1, 100) <= 66)
		{
			local r = this.Math.rand(1, 2);

			if (r == 1 || this.Const.World.Buildings.Barbers == 0)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));
			}
			else if (r <= 2)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
			}
		}

		this.buildAttachedLocation(1, "scripts/entity/world/attached_location/harbor_location", [
			this.Const.World.TerrainType.Shore
		], [
			this.Const.World.TerrainType.Ocean,
			this.Const.World.TerrainType.Shore
		], -1, false, false);
		this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/fishing_huts_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Shore
		], 1, true);
		this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/amber_collector_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Shore
		], 2);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/workshop_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 1, true);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/herbalists_grove_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 2);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wooden_watchtower_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 3, true);
	}

});

