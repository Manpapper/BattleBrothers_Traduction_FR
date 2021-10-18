this.city_state <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.getRandomName([
			"ORIENTAL CITY #1",
			"ORIENTAL CITY #2",
			"ORIENTAL CITY #3"
		]);
		this.m.DraftList = [
			"beggar_southern_background",
			"beggar_southern_background",
			"butcher_southern_background",
			"caravan_hand_southern_background",
			"caravan_hand_southern_background",
			"caravan_hand_southern_background",
			"gambler_southern_background",
			"daytaler_southern_background",
			"daytaler_southern_background",
			"historian_southern_background",
			"peddler_southern_background",
			"peddler_southern_background",
			"servant_southern_background",
			"shepherd_southern_background",
			"shepherd_southern_background",
			"tailor_southern_background",
			"thief_southern_background",
			"disowned_noble_background",
			"sellsword_background",
			"cripple_southern_background",
			"eunuch_southern_background",
			"slave_background",
			"slave_background",
			"slave_southern_background",
			"slave_southern_background",
			"slave_southern_background",
			"slave_southern_background",
			"slave_southern_background",
			"slave_southern_background",
			"slave_southern_background",
			"slave_southern_background",
			"slave_southern_background",
			"slave_southern_background",
			"manhunter_background",
			"manhunter_background",
			"nomad_background",
			"nomad_background",
			"nomad_ranged_background",
			"assassin_southern_background"
		];

		if (this.Const.DLC.Unhold)
		{
			this.m.DraftList.push("beast_hunter_background");
		}

		this.m.UIDescription = "A large and rich city state that thrives on trade at the edge of the desert";
		this.m.Description = "A large and rich city state that thrives on trade at the edge of the desert.";
		this.m.UIBackgroundCenter = "ui/settlements/desert_stronghold_03";
		this.m.UIBackgroundLeft = "ui/settlements/desert_bg_houses_03_left";
		this.m.UIBackgroundRight = "ui/settlements/desert_bg_houses_03_right";
		this.m.UIRampPathway = "ui/settlements/desert_ramp_01_cobblestone";
		this.m.UISprite = "ui/settlement_sprites/citystate_01.png";
		this.m.Sprite = "world_city_01";
		this.m.Lighting = "world_city_01_light";
		this.m.Rumors = this.Const.Strings.RumorsDesertSettlement;
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.IsMilitary = false;
		this.m.Size = 3;
		this.m.HousesType = 4;
		this.m.HousesMin = 4;
		this.m.HousesMax = 6;
		this.m.AttachedLocationsMax = 6;
	}

	function isSouthern()
	{
		return true;
	}

	function onBuild()
	{
		local myTile = this.getTile();
		local tiles = [
			myTile
		];
		local mapGen = this.MapGen.get(this.Const.World.TerrainScript[this.Const.World.TerrainType.Oasis]);
		myTile.Type = this.Const.World.TerrainType.Oasis;

		for( local i = 0; i < 6; i = ++i )
		{
			local nextTile = myTile.getNextTile(i);

			if (nextTile.Type == this.Const.World.TerrainType.Desert)
			{
				tiles.push(nextTile);
			}

			for( local j = 0; j < 6; j = ++j )
			{
				local veryNextTile = nextTile.getNextTile(i);

				if (veryNextTile.Type == this.Const.World.TerrainType.Desert && this.Math.rand(1, 100) <= 66)
				{
					tiles.push(veryNextTile);
				}
			}
		}

		foreach( tile in tiles )
		{
			tile.Type = 0;
			tile.clear();
			mapGen.fill({
				X = tile.SquareCoords.X,
				Y = tile.SquareCoords.Y,
				W = 1,
				H = 1,
				IsEmpty = false
			}, null);
		}

		for( local x = myTile.SquareCoords.X - 3; x < myTile.SquareCoords.X + 3; x = ++x )
		{
			for( local y = myTile.SquareCoords.Y - 3; y < myTile.SquareCoords.Y + 3; y = ++y )
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Mountains)
				{
				}
				else
				{
					tile.clear();
					this.MapGen.get(this.Const.World.TerrainScript[tile.Type]).fill({
						X = x,
						Y = y,
						W = 1,
						H = 1,
						IsEmpty = false
					}, null, 2);
				}
			}
		}

		for( local x = myTile.SquareCoords.X - 3; x < myTile.SquareCoords.X + 3; x = ++x )
		{
			for( local y = myTile.SquareCoords.Y - 3; y < myTile.SquareCoords.Y + 3; y = ++y )
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Mountains)
				{
				}
				else
				{
					this.MapGen.get(this.Const.World.TerrainScript[tile.Type]).fill({
						X = x,
						Y = y,
						W = 1,
						H = 1,
						IsEmpty = false
					}, null, 3);
				}
			}
		}

		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/crowd_oriental_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/marketplace_oriental_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/alchemist_building"));
		local w = 0;
		local a = 0;

		for( local i = 0; i < 2; i = ++i )
		{
			if (this.Const.World.Buildings.Arenas == 0)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/arena_building"));
			}
			else if (this.Const.World.Buildings.WeaponsmithsOriental == 0)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_oriental_building"));
				w = ++w;
			}
			else if (this.Const.World.Buildings.ArmorsmithsOriental == 0)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_oriental_building"));
				a = ++a;
			}
			else if (this.Const.DLC.Unhold && this.Const.World.Buildings.TaxidermistsOriental == 0)
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/taxidermist_oriental_building"));
			}
			else if (w == 0 && (a != 0 || this.Math.rand(1, 100) <= 50))
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/weaponsmith_oriental_building"));
				w = ++w;
			}
			else
			{
				this.addBuilding(this.new("scripts/entity/world/settlements/buildings/armorsmith_oriental_building"));
				a = ++a;
			}
		}

		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/temple_oriental_building"));

		if (this.Math.rand(1, 100) <= 60)
		{
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/stone_watchtower_oriental_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Desert
			], [], 4, true);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/militia_trainingcamp_oriental_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Desert
			], [], 1, true);
		}
		else
		{
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/stone_watchtower_oriental_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Desert
			], [], 4, true);
			this.buildAttachedLocation(1, "scripts/entity/world/attached_location/militia_trainingcamp_oriental_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Desert
			], [], 1, true);
		}

		if (this.m.IsCoastal)
		{
			this.buildAttachedLocation(2, "scripts/entity/world/attached_location/harbor_location", [
				this.Const.World.TerrainType.Shore
			], [
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Shore
			], -1, false, false);
			this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/fishing_huts_oriental_location", [
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Steppe,
				this.Const.World.TerrainType.Desert,
				this.Const.World.TerrainType.Oasis
			], [
				this.Const.World.TerrainType.Shore
			]);
		}

		local settlements = this.World.EntityManager.getSettlements();
		local n = 0;

		foreach( s in settlements )
		{
			if (s.isSouthern())
			{
				n = ++n;

				if (s.getID() == this.getID())
				{
					break;
				}
			}
		}

		this.buildAttachedLocation(this.Math.rand(n == 1 ? 2 : 0, n == 1 ? 2 : 1), "scripts/entity/world/attached_location/incense_dryer_location", [
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Desert,
			this.Const.World.TerrainType.Oasis
		], []);
		this.buildAttachedLocation(this.Math.rand(n == 2 ? 2 : 0, n == 2 ? 2 : 1), "scripts/entity/world/attached_location/silk_farm_location", [
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Desert,
			this.Const.World.TerrainType.Oasis
		], []);
		this.buildAttachedLocation(this.Math.rand(n == 3 ? 2 : 0, n == 3 ? 2 : 1), "scripts/entity/world/attached_location/plantation_location", [
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Desert,
			this.Const.World.TerrainType.Oasis
		], []);
		this.buildAttachedLocation(this.Math.rand(0, 1), "scripts/entity/world/attached_location/dye_maker_oriental_location", [
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Desert,
			this.Const.World.TerrainType.Oasis
		], [
			this.Const.World.TerrainType.Hills
		]);
		this.buildAttachedLocation(this.Math.rand(1, 2), "scripts/entity/world/attached_location/goat_herd_oriental_location", [
			this.Const.World.TerrainType.Steppe,
			this.Const.World.TerrainType.Desert,
			this.Const.World.TerrainType.Oasis
		], []);
	}

});

