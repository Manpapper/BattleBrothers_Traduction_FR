this.large_farming_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Weidemark",
			"Hemmelmark",
			"Kochenland",
			"Altenstadt",
			"Schnellmark",
			"Neumark",
			"Freistadt",
			"Weissenstadt",
			"Muhlstadt",
			"Grunmark",
			"Ivenstadt",
			"Grafenstadt",
			"Konigsland",
			"Dreigrafen",
			"Koppelstadt",
			"Varelmark",
			"Hageland",
			"Dulmen",
			"Wiesenmark",
			"Heuland",
			"Auenmark",
			"Kornstadt",
			"Konigsheim",
			"Wedelmark",
			"Albstadt",
			"Kammersmark",
			"Adelsland",
			"Heldenland",
			"Dinkelsmark",
			"Schwanstadt",
			"Grunhain"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"beggar_background",
			"beggar_background",
			"butcher_background",
			"caravan_hand_background",
			"gambler_background",
			"daytaler_background",
			"daytaler_background",
			"farmhand_background",
			"farmhand_background",
			"farmhand_background",
			"farmhand_background",
			"historian_background",
			"juggler_background",
			"militia_background",
			"militia_background",
			"miller_background",
			"miller_background",
			"miller_background",
			"minstrel_background",
			"minstrel_background",
			"peddler_background",
			"ratcatcher_background",
			"refugee_background",
			"servant_background",
			"shepherd_background",
			"tailor_background",
			"vagabond_background",
			"adventurous_noble_background",
			"bastard_background",
			"hedge_knight_background",
			"raider_background",
			"retired_soldier_background",
			"sellsword_background",
			"squire_background",
			"swordmaster_background"
		];
		this.m.UIDescription = "A large city thriving on trade and agriculture";
		this.m.Description = "A large city surrounded by lush green meadows, orchards and fields. Food stocks are usually filled to the brim.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_03";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_03_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_03_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_cobblestone";
		this.m.UISprite = "ui/settlement_sprites/townhall_03.png";
		this.m.Sprite = "world_townhall_03";
		this.m.Lighting = "world_townhall_03_light";
		this.m.Rumors = this.Const.Strings.RumorsFarmingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
		this.m.Size = 3;
		this.m.HousesType = 3;
		this.m.HousesMin = 3;
		this.m.HousesMax = 5;
		this.m.AttachedLocationsMax = 6;
	}

	function onBuild()
	{
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));

		if (this.Const.World.Buildings.Fletchers == 0)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/fletcher_building"));
		}
		else if (this.Math.rand(1, 100) <= 50)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
		}

		if (this.Math.rand(1, 100) <= 70)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/wool_spinner_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Plains
			], 1, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/brewery_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Plains
			], 1, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wool_spinner_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Plains
			], 1, true);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/brewery_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Plains
			], 1, true);
		}

		if (this.Math.rand(1, 100) <= 70)
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

		this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/wheat_fields_location", [
			this.Const.World.TerrainType.Plains
		], [], 2);
		this.buildAttachedLocation(this.Math.rand(0, 2), "scripts/entity/world/attached_location/orchard_location", [
			this.Const.World.TerrainType.Plains
		], [], 1);
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

