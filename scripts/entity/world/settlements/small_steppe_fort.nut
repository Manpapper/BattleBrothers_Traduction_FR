this.small_steppe_fort <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Wohlenwacht",
			"Krauchwall",
			"Erlachwall",
			"Treitenwacht",
			"Thurnwall",
			"Rothenwall",
			"Sandwacht",
			"Sonnwehr",
			"Siegwacht",
			"Schanzthal",
			"Sudschanze",
			"Strauchwacht",
			"Kargwall",
			"Dornwall",
			"Dornturm",
			"Gelbwall",
			"Suderwacht",
			"Dorngard",
			"Dornwacht",
			"Weissenwacht",
			"Goldwall",
			"Wurmwacht",
			"Brunnwall",
			"Unterwall",
			"Brackenwacht",
			"Steppwall"
		]);
		this.m.DraftList = [
			"caravan_hand_background",
			"caravan_hand_background",
			"houndmaster_background",
			"daytaler_background",
			"mason_background",
			"militia_background",
			"militia_background",
			"shepherd_background",
			"vagabond_background",
			"bastard_background",
			"deserter_background",
			"deserter_background",
			"retired_soldier_background",
			"retired_soldier_background"
		];
		this.m.UIDescription = "A small wooden keep in the dry steppe";
		this.m.Description = "This small wooden keep looks wide over the dry steppe and offers shade for weary soldiers.";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_01";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_01_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_01_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/stronghold_01.png";
		this.m.Sprite = "world_stronghold_01";
		this.m.Lighting = "world_stronghold_01_light";
		this.m.Rumors = this.Const.Strings.RumorsSteppeSettlement;
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
			local r = this.Math.rand(1, 3);

			if (r == 1)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
			}
			else if (r == 2)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));
			}
			else if (r == 3)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/kennel_building"));
			}
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/beekeeper_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Hills
			], [], 1);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/gatherers_hut_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Swamp,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 2);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/beekeeper_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Hills
			], [], 1);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/gatherers_hut_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Swamp,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 2);
		}

		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/fletchers_hut_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Hills
		], []);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/leather_tanner_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Hills
		], []);
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

