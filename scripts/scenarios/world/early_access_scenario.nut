this.early_access_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.early_access";
		this.m.Name = "Nouvelle Compagnie";
		this.m.Description = "[p=c][img]gfx/ui/events/event_80.png[/img][/p][p]Après des années à couvrir votre épée de sang pour un salaire ridicule, vous avez enfin assez de couronnes pour commencer votre propre compagnie de mercenaire. Trois mercenaires avec lesquels vous avez combattu côte à côte dans le Mur de Bouclier vous ont rejoint.\n\n[color=#bcad8c]Un début rapide dans le monde, sans avantages ou de désavantages particuliers.[/color][/p]";
		this.m.Difficulty = 1;
		this.m.Order = 10;
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
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"companion_1h_background"
		]);
		bros[0].getBackground().m.RawDescription = "{Vous avez sauvé la vie de %name% lors d'une bataille contre des brigands, et il a rendu la pareille lors d'une embuscade dans une ruelle par des voleurs. Étant donné que les criminels ordinaires sont quelques niveaux en dessous des brigands, vous plaisantez souvent avec lui en disant qu'il est encore un peu en retard dans la dette de 'sauver les fesses de l'autre'.}";
		bros[0].setPlaceInFormation(3);
		bros[1].setStartValuesEx([
			"companion_2h_background"
		]);
		bros[1].getBackground().m.RawDescription = "{Quoi qu'il en soit de mal avec %name%, vous espérez qu'il ne le répare jamais. Un personnage avec un goût particulier pour la bagarre, la débauche, le jeu, le chant, les combats de chiens, la poursuite des jupons, le lavage étrange de la vaisselle, les vomissements et, bien sûr, la boisson, il a toujours été un cadeau à avoir autour. Il se trouve également être un excellent combattant en son propre droit.}";
		bros[1].setPlaceInFormation(4);
		bros[2].setStartValuesEx([
			"companion_ranged_background"
		]);
		bros[2].getBackground().m.RawDescription = "Vous avez croisé la route de %name% à plusieurs reprises avant qu'il ne rejoigne la compagnie. La première fois, vous étiez tous deux de simples ouvriers. La deuxième fois, vous étiez des mercenaires. Et maintenant, c'est la troisième fois avec lui qui rejoint votre compagnie. Si tout se passe bien, il restera enfin cette fois-ci et vous trouverez tous deux les richesses que vous recherchez.";
		bros[2].setPlaceInFormation(5);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 400;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern())
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
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.IntroTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.early_access_scenario_intro");
		}, null);
	}

});

