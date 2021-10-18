this.medium_swamp_village <- this.inherit("scripts/entity/world/settlement", {
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
			"beggar_background",
			"cultist_background",
			"cultist_background",
			"daytaler_background",
			"daytaler_background",
			"flagellant_background",
			"graverobber_background",
			"historian_background",
			"killer_on_the_run_background",
			"militia_background",
			"militia_background",
			"poacher_background",
			"poacher_background",
			"ratcatcher_background",
			"ratcatcher_background",
			"thief_background",
			"vagabond_background",
			"wildman_background",
			"wildman_background",
			"witchhunter_background",
			"witchhunter_background",
			"adventurous_noble_background",
			"disowned_noble_background",
			"cripple_background"
		];

		if (this.Const.DLC.Unhold)
		{
			this.m.DraftList.push("beast_hunter_background");
		}

		this.m.UIDescription = "A larger settlement surrounded by foul swamps";
		this.m.Description = "A somewhat larger settlement spread out across various dry and firm spots in the swamp.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_02";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_02_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_02_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_02.png";
		this.m.Sprite = "world_townhall_02";
		this.m.Lighting = "world_townhall_02_light";
		this.m.Rumors = this.Const.Strings.RumorsSwampSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
		this.m.Size = 2;
		this.m.HousesType = 2;
		this.m.HousesMin = 2;
		this.m.HousesMax = 3;
		this.m.AttachedLocationsMax = 4;
		this.m.ProduceString = "mushrooms";
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));

		if (this.Const.DLC.Unhold)
		{
			local r = this.Math.rand(1, 3);

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
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));
			}
		}
		else
		{
			local r = this.Math.rand(1, 3);

			if (r <= 2)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
			}
			else if (r == 3)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));
			}
		}

		if (this.Math.rand(1, 100) <= 70)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/herbalists_grove_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Swamp,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.AutumnForest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 2);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Swamp
			]);
		}
		else
		{
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
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Swamp
			]);
		}

		this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/peat_pit_location", [
			this.Const.World.TerrainType.Swamp
		], [], 1);
		this.buildAttachedLocation(this.Math.rand(0, 2), "scripts/entity/world/attached_location/mushroom_grove_location", [
			this.Const.World.TerrainType.Swamp
		], [], 2);
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
		], 3, true);
	}

});

