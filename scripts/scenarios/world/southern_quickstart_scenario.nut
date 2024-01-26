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
		bros[0].getBackground().m.RawDescription = "{%name% faisait autrefois partie de la garde d'élite d'un Vizir. Une bataille féroce a vu toute sa légion anéantie et lui-même enseveli sous leurs cadavres. Il a été abandonné dans le désert et a survécu de manière qu'il ne te dira même pas aujourd'hui. Mais sa loyauté infaillible envers toi en dit plus que n'importe quelle histoire de guerre pourrait jamais.}";
		bros[0].setPlaceInFormation(3);
		bros[1].setStartValuesEx([
			"companion_2h_southern_background"
		]);
		bros[1].getBackground().m.RawDescription = "{Si la loyauté était de l'or, %name% pourrait être l'homme le plus riche à se tenir sous l'œil du Gilder. Tu as trouvé l'homme attaqué en embuscade dans une ruelle. En l'aidant à repousser les voleurs, il a juré allégeance pour une année. Et cela fait bien plus depuis. Malgré s'être fait botter le cul à première vue, %name% est un combattant très redoutable quand il n'est pas pris au dépourvu.}";
		bros[1].setPlaceInFormation(4);
		bros[2].setStartValuesEx([
			"companion_ranged_southern_background"
		]);
		bros[2].getBackground().m.RawDescription = "{Tu n'es pas entièrement sûr du passé de %name%, seulement que son chemin n'a pas eu autant d'éclat qu'on l'aurait espéré. Il dit avoir rempli de nombreux rôles, mais l'armée ne le veut pas, la garde de la ville ne le veut pas, et les femmes certainement ne le veulent pas, alors il a choisi la vie en tant que Crownling. Il pense qu'une mort glorieuse et hâtée le conduira sous l'œil du Gilder pour lui demander pourquoi exactement Il a traité sa vie si durement. Quand il ne traîne pas en se plaignant, %name% peut être joyeux et drôle. Il suffit de le tenir éloigné des boissons et des prêtres.}";
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

