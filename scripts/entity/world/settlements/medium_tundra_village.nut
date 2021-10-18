this.medium_tundra_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Tonder",
			"Lydersholm",
			"Kravlund",
			"Bola",
			"Ravestad",
			"Alsliv",
			"Hellevad",
			"Heimstad",
			"Hornheim",
			"Jerstal",
			"Hejsager",
			"Kalk",
			"Sommerstad",
			"Horn",
			"Bramming",
			"Varde",
			"Norre",
			"Vistadt",
			"Olbing",
			"Grimstad",
			"Birkeland",
			"Donnerstad",
			"Tangvall",
			"Helvik",
			"Ogna",
			"Norheim",
			"Undheim",
			"Torvastad",
			"Skjold",
			"Eidsvik",
			"Halheim",
			"Gerheim",
			"Asenstad",
			"Gunnheim",
			"Hammar"
		]);
		this.m.DraftList = [
			"beggar_background",
			"bowyer_background",
			"brawler_background",
			"brawler_background",
			"butcher_background",
			"cultist_background",
			"daytaler_background",
			"gravedigger_background",
			"graverobber_background",
			"hunter_background",
			"killer_on_the_run_background",
			"messenger_background",
			"militia_background",
			"minstrel_background",
			"monk_background",
			"peddler_background",
			"poacher_background",
			"tailor_background",
			"thief_background",
			"vagabond_background",
			"wildman_background"
		];
		this.m.UIDescription = "An established village in the rough tundra";
		this.m.Description = "An established village in the rough tundra that is a meeting point for the area.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_02";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_02_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_02_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_02.png";
		this.m.Sprite = "world_townhall_02";
		this.m.Lighting = "world_townhall_02_light";
		this.m.Rumors = this.Const.Strings.RumorsTundraSettlement;
		this.m.Culture = this.Const.World.Culture.Northern;
		this.m.IsMilitary = false;
		this.m.Size = 2;
		this.m.HousesType = 2;
		this.m.HousesMin = 2;
		this.m.HousesMax = 3;
		this.m.AttachedLocationsMax = 4;
		this.m.ProduceString = "pelts";
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));

		if (this.Const.DLC.Unhold)
		{
			local r = this.Math.rand(1, 4);

			if (r == 1 || this.Const.World.Buildings.Taxidermists == 0)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/taxidermist_building"));
			}
			else if (r == 2)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
			}
			else if (r == 3)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
			}
			else if (r == 4)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));
			}
		}
		else
		{
			local r = this.Math.rand(1, 4);

			if (r <= 2)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
			}
			else if (r == 3)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
			}
			else if (r == 4)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));
			}
		}

		if (this.Math.rand(1, 100) <= 70)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/trapper_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Snow
			], [
				this.Const.World.TerrainType.Tundra
			], 2);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/peat_pit_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [], 1);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/trapper_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Snow
			], [
				this.Const.World.TerrainType.Tundra
			], 2);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/peat_pit_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [], 1);
		}

		if (this.Math.rand(1, 100) <= 70)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], []);
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
			], [], 1, false, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], []);
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
			], [], 1, false, true);
		}

		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/surface_iron_vein_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Hills
		]);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/leather_tanner_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Tundra
		], []);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/herbalists_grove_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.SnowyForest,
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

