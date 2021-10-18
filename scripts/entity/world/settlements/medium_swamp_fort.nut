this.medium_swamp_fort <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Schwarzburg",
			"Moosburg",
			"Pfuhlburg",
			"Moorburg",
			"Furthburg",
			"Stakenburg",
			"Kolkburg",
			"Torfburg",
			"Krautburg",
			"Birkenburg",
			"Brunnburg",
			"Kaltenburg",
			"Grunburg",
			"Suhlburg",
			"Brookburg",
			"Muckenburg",
			"Egelburg",
			"Dunkelburg",
			"Nebelburg",
			"Bruchburg",
			"Morastburg",
			"Froschburg",
			"Schlammburg",
			"Brackenburg",
			"Molchburg",
			"Teichburg",
			"Fennburg",
			"Riedburg",
			"Schlickburg",
			"Senkburg",
			"Rohrburg",
			"Marschburg",
			"Schilfburg"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"houndmaster_background",
			"beggar_background",
			"butcher_background",
			"cultist_background",
			"gravedigger_background",
			"hunter_background",
			"messenger_background",
			"militia_background",
			"militia_background",
			"monk_background",
			"flagellant_background",
			"ratcatcher_background",
			"wildman_background",
			"witchhunter_background",
			"witchhunter_background",
			"adventurous_noble_background",
			"bastard_background",
			"deserter_background",
			"disowned_noble_background",
			"raider_background",
			"retired_soldier_background"
		];
		this.m.UIDescription = "A stone keep controlling routes through the swamps";
		this.m.Description = "A stone keep controlling routes through and access to the surrounding swamps and marshes.";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_02";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_02_left";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_02_right";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/stronghold_02.png";
		this.m.Sprite = "world_stronghold_02";
		this.m.Lighting = "world_stronghold_02_light";
		this.m.Rumors = this.Const.Strings.RumorsSwampSettlement;
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
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));

		if (this.Const.World.Buildings.Kennels == 0)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/kennel_building"));
		}
		else
		{
			local r = this.Math.rand(1, 3);

			if (r == 1 || this.Const.World.Buildings.Kennels == 0)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/kennel_building"));
			}
			else if (r == 2)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
			}
			else if (r == 3)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
			}
		}

		if (this.Math.rand(1, 100) <= 40)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/mushroom_grove_location", [
				this.Const.World.TerrainType.Swamp
			], [], 1);
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
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/mushroom_grove_location", [
				this.Const.World.TerrainType.Swamp
			], [], 1);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/pig_farm_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Swamp
			]);
		}

		if (this.Math.rand(1, 100) <= 70)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/stone_watchtower_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [], 4, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/fortified_outpost_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 2, true);
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
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/fortified_outpost_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [], 2, true);
		}

		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/leather_tanner_location", [
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Snow,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], []);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/herbalists_grove_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.AutumnForest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], []);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/workshop_location", [
			this.Const.World.TerrainType.Plains,
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra
		], []);
	}

});

