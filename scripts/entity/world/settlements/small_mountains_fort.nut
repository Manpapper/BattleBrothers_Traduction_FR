this.small_mountains_fort <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Wallstein",
			"Hohenwacht",
			"Steinberg",
			"Wolfswall",
			"Felswall",
			"Steinwacht",
			"Eisenwall",
			"Jaderwall",
			"Hohenschanze",
			"Wallheim",
			"Gronenwall",
			"Thalwacht",
			"Schanzberg",
			"Windwacht",
			"Turmwacht",
			"Felswacht",
			"Hohenturm",
			"Adlerwacht",
			"Scharfenstein",
			"Oberwallheim",
			"Hochwall",
			"Bergwall",
			"Finkenwacht",
			"Greifenwall",
			"Himmelswacht"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"houndmaster_background",
			"beggar_background",
			"brawler_background",
			"daytaler_background",
			"mason_background",
			"messenger_background",
			"militia_background",
			"militia_background",
			"vagabond_background",
			"witchhunter_background",
			"bastard_background",
			"deserter_background",
			"deserter_background",
			"retired_soldier_background",
			"retired_soldier_background"
		];
		this.m.UIDescription = "A small fortification built in the mountains";
		this.m.Description = "A small fortification has been built in this mountainous region to act as a base of operations and control the surrounding lands.";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_01";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_01_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/stronghold_01.png";
		this.m.Sprite = "world_stronghold_01";
		this.m.Lighting = "world_stronghold_01_light";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = true;
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

		if (this.Const.World.Buildings.Kennels == 0)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/kennel_building"));
		}
		else
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
			}

			if (this.Math.rand(1, 100) <= 50)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));
			}
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/goat_herd_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wheat_fields_location", [
				this.Const.World.TerrainType.Plains
			], [], 1);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/goat_herd_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 1);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/wheat_fields_location", [
				this.Const.World.TerrainType.Plains
			], [], 1);
		}

		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/ore_smelters_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Hills
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/blast_furnace_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Hills
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wooden_watchtower_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], 4, true);
	}

});

