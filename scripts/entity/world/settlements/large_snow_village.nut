this.large_snow_village <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"Tondersted",
			"Jarlsted",
			"Lydersted",
			"Bolasted",
			"Ravested",
			"Hellested",
			"Hornsted",
			"Hejsted",
			"Sommersted",
			"Brammingsted",
			"Vardested",
			"Norrested",
			"Grimsted",
			"Ognasted",
			"Eidsted",
			"Gersted",
			"Asested",
			"Gunnsted",
			"Hammarsted",
			"Arsasted",
			"Rollarsted",
			"Skagensted",
			"Harkensted",
			"Agersted",
			"Svarrested",
			"Ovarsted"
		]);
		this.m.DraftList = [
			"apprentice_background",
			"beggar_background",
			"bowyer_background",
			"brawler_background",
			"brawler_background",
			"brawler_background",
			"caravan_hand_background",
			"gambler_background",
			"cultist_background",
			"daytaler_background",
			"daytaler_background",
			"farmhand_background",
			"gravedigger_background",
			"graverobber_background",
			"killer_on_the_run_background",
			"mason_background",
			"messenger_background",
			"militia_background",
			"militia_background",
			"militia_background",
			"peddler_background",
			"flagellant_background",
			"poacher_background",
			"poacher_background",
			"poacher_background",
			"ratcatcher_background",
			"tailor_background",
			"thief_background",
			"vagabond_background",
			"wildman_background",
			"wildman_background",
			"wildman_background",
			"witchhunter_background",
			"adventurous_noble_background",
			"bastard_background",
			"disowned_noble_background",
			"disowned_noble_background",
			"raider_background",
			"raider_background",
			"sellsword_background",
			"swordmaster_background"
		];

		if (this.Const.DLC.Unhold)
		{
			this.m.DraftList.push("beast_hunter_background");
		}

		this.m.UIDescription = "A large city sheltering travelers and traders from snow and cold";
		this.m.Description = "A large city far up north. Traders, travelers and adventurers come here for shelter from snow and storms.";
		this.m.UIBackgroundCenter = "ui/settlements/townhall_03_snow";
		this.m.UIBackgroundLeft = "ui/settlements/bg_houses_03_left_snow";
		this.m.UIBackgroundRight = "ui/settlements/bg_houses_03_right_snow";
		this.m.UIRampPathway = "ui/settlements/ramp_01_cobblestone";
		this.m.UISprite = "ui/settlement_sprites/townhall_03.png";
		this.m.Sprite = "world_townhall_03";
		this.m.Lighting = "world_townhall_03_light";
		this.m.Rumors = this.Const.Strings.RumorsSnowSettlement;
		this.m.Culture = this.Const.World.Culture.Northern;
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

		if (this.Math.rand(1, 100) <= 50 || this.Const.World.Buildings.Barbers == 0)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/barber_building"));
		}
		else
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/training_hall_building"));
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_building"));
		}
		else
		{
			this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_building"));
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

		if (this.Math.rand(1, 100) <= 50)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/blast_furnace_location", [
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Snow
			], [], 1, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/ore_smelters_location", [
				this.Const.World.TerrainType.Snow
			], [], 1, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/blast_furnace_location", [
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Snow
			], [], 1, true);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/ore_smelters_location", [
				this.Const.World.TerrainType.Snow
			], [], 1, true);
		}

		this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/trapper_location", [
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Tundra,
			this.Const.World.TerrainType.Snow
		], []);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/hunters_cabin_location", [
			this.Const.World.TerrainType.Snow
		], [], 1, false, true);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/surface_copper_vein_location", [
			this.Const.World.TerrainType.Hills,
			this.Const.World.TerrainType.Snow
		], [], 1, true);
	}

});

