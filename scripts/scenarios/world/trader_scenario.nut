this.trader_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.trader";
		this.m.Name = "Caravane Marchande";
		this.m.Description = "[p=c][img]gfx/ui/events/event_41.png[/img][/p][p]Vous êtes à la tête d\'une petite caravane et avez la plupart de vos couronnes investies dans des biens marchandables. Mais les routes sont devenues dangereuses - Les brigands et les Peaux-Vertes attendent en embuscade, et des rumeurs circulent disant qu\'il y a encore pire là dehors.\n\n[color=#bcad8c]Caravane :[/color] Commencez avec deux caravaniers que vous avez embauchés.\n[color=#bcad8c]Commerçant :[/color] Ayez un bonus de 10% sur vos ventes et achats.\n[color=#bcad8c]Pas un Guerrier :[/color] Commencez sans renom et gagnez les gains de renoms sont à 66%.[/p]";
		this.m.Difficulty = 1;
		this.m.Order = 19;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 2; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.worsenMood(0.5, "Encountered another caravan slaughtered by greenskins");

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"caravan_hand_background"
		]);
		bros[0].getBackground().m.RawDescription = "Daytaler, maçon, meunier, %name% avait tout fait, passant d'une tâche à l'autre sans s'attarder à en faire une véritable vocation. Tu n'étais pas sûr s'il resterait longtemps comme homme de caravane non plus, mais quand on lui a demandé de se tourner vers le travail de mercenaire, il n'a eu aucun problème à accepter...";
		bros[0].setPlaceInFormation(3);
		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.MeleeDefense] = 1;
		talents[this.Const.Attributes.Fatigue] = 1;
		bros[1].setStartValuesEx([
			"caravan_hand_background"
		]);
		bros[1].getBackground().m.RawDescription = "Tu as trouvé %name% jeté hors d'un pub et à première vue, il n'était guère plus qu'un malfaiteur ivre. Mais tu as vu comment il a repoussé trois agresseurs potentiels. Ils ont réussi à lui prendre ses bottes à la fin, c'est sûr, mais ils n'ont pas pu vraiment vaincre son esprit. Impressionné, tu l'as pris comme homme de caravane.";
		bros[1].setPlaceInFormation(4);
		bros[1].m.Talents = [];
		local talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.MeleeDefense] = 1;
		talents[this.Const.Attributes.Hitpoints] = 1;
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/scimitar"));
		this.World.Assets.m.BusinessReputation = 0;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/bread_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/mead_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/wine_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/amber_shards_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/cloth_rolls_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/dies_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/furs_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/trade/salt_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2 + 400;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 8), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 8));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 8), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 8));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 5)
				{
				}
				else if (!tile.HasRoad)
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
		this.World.Assets.updateLook(9);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/retirement_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.trader_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BusinessReputationRate = 0.66;
		this.World.Assets.m.BuyPriceMult = 0.9;
		this.World.Assets.m.SellPriceMult = 1.1;
	}

});

