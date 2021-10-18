this.large_fishing_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Seestadt",
			"Wikstadt",
			"Konigshaven",
			"Grafenhaven",
			"Holnisland",
			"Nieweland",
			"Kampstadt",
			"Krakenland",
			"Blankenstadt",
			"Harkenstadt",
			"Tiefenstadt",
			"Weissenstadt",
			"Kobmanhaven",
			"Grotenhaven",
			"Konigswasser",
			"Konigsmunde",
			"Kronenkoog",
			"Steinkai",
			"Deichstadt"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"beggar_background",
			"beggar_background",
			"brawler_background",
			"caravan_hand_background",
			"caravan_hand_background",
			"gambler_background",
			"cultist_background",
			"daytaler_background",
			"daytaler_background",
			"fisherman_background",
			"fisherman_background",
			"fisherman_background",
			"fisherman_background",
			"gravedigger_background",
			"graverobber_background",
			"historian_background",
			"juggler_background",
			"killer_on_the_run_background",
			"mason_background",
			"messenger_background",
			"militia_background",
			"militia_background",
			"minstrel_background",
			"monk_background",
			"cripple_background",
			"eunuch_background",
			"peddler_background",
			"flagellant_background",
			"ratcatcher_background",
			"refugee_background",
			"servant_background",
			"servant_background",
			"tailor_background",
			"thief_background",
			"vagabond_background",
			"adventurous_noble_background",
			"bastard_background",
			"disowned_noble_background",
			"raider_background",
			"raider_background",
			"retired_soldier_background",
			"sellsword_background",
			"swordmaster_background"
		];
		this.m.UIDescription = "A large coastal city and trading hub";
		this.m.Description = "A big harbor city relying on trade and fishing, and an important hub for travellers arriving or leaving by ship.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_03";
		this.m.UIBackgroundLeft = "ui/settlements/water_01";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_03_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_cobblestone";
		this.m.UISprite = "ui/settlement_sprites/townhall_03.png";
		this.m.Sprite = "world_townhall_03";
		this.m.Lighting = "world_townhall_03_light";
		this.m.Rumors = this.Const.Strings.RumorsFishingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
		this.m.Size = 3;
		this.m.HousesType = 3;
		this.m.HousesMin = 3;
		this.m.HousesMax = 5;
		this.m.AttachedLocationsMax = 6 + 2;
		this.m.ProduceString = "fish";
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/port_building"), 3);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));

		if (this.Math.rand(1, 100) <= 60 || this.Const.World.Buildings.Barbers == 0)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));
		}
		else
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/training_hall_building"));
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/wooden_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/militia_trainingcamp_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wooden_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/militia_trainingcamp_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1, true);
		}

		if (this.Math.rand(1, 100) <= 70)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/amber_collector_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Tundra
			], [], 2);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/workshop_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/amber_collector_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Shore
			], 2);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/workshop_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1, true);
		}

		this.buildAttachedLocation(2, "scripts/entity/world/attached_location/harbor_location", [
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
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/herbalists_grove_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 3);
	}

});

