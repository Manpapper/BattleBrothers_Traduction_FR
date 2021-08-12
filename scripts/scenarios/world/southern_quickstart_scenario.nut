this.southern_quickstart_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.southern_quickstart";
		this.m.Name = "Mercenaires du Sud";
		this.m.Description = "[p=c][img]gfx/ui/events/event_156.png[/img][/p][p]Vous et votre petit groupe de mercenaires avez fait le sale travail d\'un petit marchand pendant des années, et pourtant vous avez à peine ce qu\'il faut pour vous différencier de brigands. Vous souhaitez vous agrandir plus que ça. Vous voulez plus. Et le Gilder vous révèlera la voie.\n\n[color=#bcad8c]Un début rapide dans la partie Sud du monde, sans advantages ou de désavantages particuliers.[/color][/p]";
		this.m.Difficulty = 1;
		this.m.Order = 11;
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 3; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.improveMood(1.5, "Joined a mercenary company");

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"companion_1h_southern_background"
		]);
		bros[0].getBackground().m.RawDescription = "{%name% was once in a Vizier\'s elite vanguard. A pitched battle saw his entire legion annihilated and himself buried underneath their bodies. He was abandoned to the desert and survived by means that even to this day he will not tell you. But his unerring loyalty to you speaks more than any war story ever could.}";
		bros[0].setPlaceInFormation(3);
		bros[1].setStartValuesEx([
			"companion_2h_southern_background"
		]);
		bros[1].getBackground().m.RawDescription = "{If loyalty was gold, %name% might be the wealthiest man to stand beneath the Gilder\'s eye. You found the man being ambushed in an alley. Helping him fight off the thieves, he swore allegiance to you for one year. And it has been many since. Despite getting his ass kicked at first sight, %name% is a very formidable fighter when not getting bushwhacked.}";
		bros[1].setPlaceInFormation(4);
		bros[2].setStartValuesEx([
			"companion_ranged_southern_background"
		]);
		bros[2].getBackground().m.RawDescription = "{You\'re not entirely sure of %name%\'s past, only that his path has not had as much shine as one would hope. He says he\'s filled many roles, but the army won\'t have him, and the city guard won\'t have him, and the women certainly won\'t have him, so he\'s taken the life as a Crownling. He thinks a glorious and hastened death will bring him to the Gilder\'s eye so he can ask Him why exactly He\'s treated his life so harshly. When he\'s not moping about, %name% can be cheerful and funny. Just keep him away from drinks and priests.}";
		bros[2].setPlaceInFormation(5);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 400;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(13);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.southern_quickstart_scenario_intro");
		}, null);
	}

});

