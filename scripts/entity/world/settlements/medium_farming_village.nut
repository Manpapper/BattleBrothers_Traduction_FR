this.medium_farming_village <- this.inherit("scripts/entity/world/settlement", {
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
			"Schnellen",
			"Neudorf",
			"Freidorf",
			"Durbach",
			"Weissenhaus",
			"Muhlenheim",
			"Grunfelde",
			"Ivendorf",
			"Weidenau",
			"Grafenheide",
			"Hermannshof",
			"Koppeldorf",
			"Meiding",
			"Varel",
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
			"Bitterfeld"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"beggar_background",
			"butcher_background",
			"gambler_background",
			"daytaler_background",
			"daytaler_background",
			"farmhand_background",
			"farmhand_background",
			"farmhand_background",
			"juggler_background",
			"messenger_background",
			"militia_background",
			"militia_background",
			"miller_background",
			"miller_background",
			"minstrel_background",
			"ratcatcher_background",
			"refugee_background",
			"servant_background",
			"tailor_background",
			"vagabond_background",
			"retired_soldier_background"
		];
		this.m.UIDescription = "A prospering village surrounded by fertile land";
		this.m.Description = "A prospering village surrounded by fertile land. The market is usually filled with all kinds of fresh food.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_02";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_02_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_02_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/townhall_02.png";
		this.m.Sprite = "world_townhall_02";
		this.m.Lighting = "world_townhall_02_light";
		this.m.Rumors = this.Const.Strings.RumorsFarmingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.IsMilitary = false;
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
		local r = this.Math.rand(1, 2);

		if (r == 1 || this.Const.World.Buildings.Barbers == 0)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));
		}
		else if (r == 2)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
		}

		if (this.Math.rand(1, 100) <= 70)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/wool_spinner_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Plains
			]);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/brewery_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Plains
			], 1);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wool_spinner_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Plains
			]);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/brewery_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Plains
			], 1);
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
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/wooden_watchtower_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], [], 3, true);
	}

});

