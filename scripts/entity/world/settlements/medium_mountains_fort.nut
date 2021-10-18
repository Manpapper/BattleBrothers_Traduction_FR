this.medium_mountains_fort <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Hohenburg",
			"Wolfenburg",
			"Felsburg",
			"Eisenburg",
			"Jadeburg",
			"Gronenburg",
			"Thalburg",
			"Sattelburg",
			"Windburg",
			"Turmburg",
			"Adlerburg",
			"Scharfenburg",
			"Wolfenstein",
			"Brunwald",
			"Heldenburg",
			"Wurmburg",
			"Schwertburg",
			"Lanzenburg",
			"Himmelsburg",
			"Granitschanze",
			"Erzburg",
			"Wolkenburg",
			"Hochburg",
			"Windfall",
			"Gemmenburg",
			"Hohenstein",
			"Oberburg"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"apprentice_background",
			"houndmaster_background",
			"brawler_background",
			"caravan_hand_background",
			"gambler_background",
			"mason_background",
			"mason_background",
			"messenger_background",
			"militia_background",
			"militia_background",
			"miner_background",
			"miner_background",
			"servant_background",
			"shepherd_background",
			"witchhunter_background",
			"adventurous_noble_background",
			"bastard_background",
			"deserter_background",
			"deserter_background",
			"disowned_noble_background",
			"retired_soldier_background",
			"sellsword_background",
			"sellsword_background"
		];
		this.m.UIDescription = "A stone keep that is towering high over the surrounding mountains";
		this.m.Description = "A stone keep that is towering high over the surrounding mountains. Lookouts on the towers can see approaching troops from miles away.";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_02";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_02_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_02_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/stronghold_02.png";
		this.m.Sprite = "world_stronghold_02";
		this.m.Lighting = "world_stronghold_02_light";
		this.m.Rumors = this.Const.Strings.RumorsMiningSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = true;
		this.m.Size = 2;
		this.m.HousesType = 2;
		this.m.HousesMin = 2;
		this.m.HousesMax = 3;
		this.m.AttachedLocationsMax = 4;
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/stone_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/workshop_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 1, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/stone_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/workshop_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 1, true);
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
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/salt_mine_location", [
			this.Const.World.TerrainType.Hills
		], [
			this.Const.World.TerrainType.Hills
		]);
	}

});

