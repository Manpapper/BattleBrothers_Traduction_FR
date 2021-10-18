this.medium_snow_fort <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Tonderhovel",
			"Horngard",
			"Grimhaug",
			"Hellehovel",
			"Kalkhovel",
			"Lydersgard",
			"Homsgard",
			"Sommersholm",
			"Brammingholm",
			"Vardegard",
			"Norreholm",
			"Birkehovel",
			"Donnersgard",
			"Tanghaug",
			"Helvikholm",
			"Torvaholm",
			"Skjoldgard",
			"Eidsvikholm",
			"Halshovel",
			"Gerholm",
			"Gunnholm",
			"Asengard",
			"Hammargard",
			"Vikeholm",
			"Skandergard",
			"Gunhall",
			"Asaholm",
			"Grimmarsholm",
			"Hjalsgard",
			"Kungenshovel",
			"Wallhovel"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"houndmaster_background",
			"brawler_background",
			"brawler_background",
			"cultist_background",
			"daytaler_background",
			"gravedigger_background",
			"mason_background",
			"messenger_background",
			"militia_background",
			"miner_background",
			"monk_background",
			"ratcatcher_background",
			"refugee_background",
			"vagabond_background",
			"vagabond_background",
			"wildman_background",
			"wildman_background",
			"wildman_background",
			"witchhunter_background",
			"adventurous_noble_background",
			"deserter_background",
			"disowned_noble_background",
			"raider_background",
			"retired_soldier_background"
		];
		this.m.UIDescription = "This stone keep shelters a garrison from the snow";
		this.m.Description = "This stone-built keep offers protection both from the cold and any invaders.";
		this.m.UIBackgroundCenter = "ui/settlements/stronghold_02_snow";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_02_left_snow";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_02_right_snow";
		this.m.UIRampPathway = "ui/settlements/ramp_01_planks";
		this.m.UISprite = "ui/settlement_sprites/stronghold_02.png";
		this.m.Sprite = "world_stronghold_02";
		this.m.Lighting = "world_stronghold_02_light";
		this.m.Rumors = this.Const.Strings.RumorsSnowSettlement;
		this.m.Culture = this.Const.World.Culture.Northern;
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

			if (r == 1)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/tavern_building"));
			}
			else if (r == 2)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_building"));
			}
			else if (r == 3)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/kennel_building"));
			}
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

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/ore_smelters_location", [
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Hills
			], 1, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/blast_furnace_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [
				this.Const.World.TerrainType.Tundra
			], 1, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/ore_smelters_location", [
				this.Const.World.TerrainType.Snow,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Tundra
			], [
				this.Const.World.TerrainType.Hills
			], 1, true);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/blast_furnace_location", [
				this.Const.World.TerrainType.Tundra,
				this.Const.World.TerrainType.Hills
			], [
				this.Const.World.TerrainType.Tundra
			], 1, true);
		}

		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/hunters_cabin_location", [
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Hills
		], [], 2, false, true);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/trapper_location", [
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Hills
		], [], 2);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/workshop_location", [
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Hills
		], [], 1, true);
	}

});

