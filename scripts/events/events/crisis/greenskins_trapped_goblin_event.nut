this.greenskins_trapped_goblin_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_trapped_goblin";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]La compagnie traverse des broussailles et pénètre dans une clairière où elle trouve un gobelin accroupi. Il se tourne vers vous, son souffle laborieux, ses yeux sombres. Vous voyez qu\'il y a un grand piège à ours serrant fermement sa cuisse. Le Peau-Verte essaie de grogner, mais ne parvient qu\'à cracher du sang.\n\n À côté du gobelin mourant se trouve un homme face contre terre dans l\'herbe. Il y a quelque chose de brillant attaché à sa hanche, mais vous ne pouvez pas vraiment dire ce que c\'est. %randombrother% vient à vos côtés.%SPEECH_ON%Cela pourrait être un piège. Un piège dans un piège. Le reste de ses copains ne sont probablement pas loin. Là encore, si nous partons, il pourrait se libérer et dire à tout le monde que nous étions ici. Que devons-nous faire ?%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Tue le.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Laisse le.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 70)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]D\'une manière ou d\'une autre, le gobelin ne peut pas être laissé en vie. Vous entrez dans la clairière pour le sortir de sa misère et, peut-être, avoir un aperçu des trésors que le cadavre pourrait transporter. Le peau verte se recroqueville à votre vue, grondant et crachant, le piège agitant les chaînes auxquelles il est attaché. %randombrother%, arme à la main, s\'approche prudemment de la bête puis la tue d\'un seul coup.\n\n Une fois la menace géré, vous faites rouler le corps du mort et pillez tout ce qui vaut la peine d\'être pris. ",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Un gobelin de moins à s\'occuper. ",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/named/named_dagger");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/rondel_dagger");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/loot/golden_chalice_item");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/loot/silver_bowl_item");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_69.png[/img]C\'est une guerre d\'anéantissement et aucun Peau-Verte ne peut être autorisé à vivre. Vous entrez sur le terrain et tuez la chose immonde. Puis vous roulez le corps du mort et pillez tout ce qui vaut la peine d\'être pris. Juste au moment où vous vous apprêtez à partir, un grognement gronde depuis la limite des arbres. %randombrother% sort son arme et pointe.%SPEECH_ON%Nachzehrers !%SPEECH_OFF%Merde ! Ils ont dû sentir le gobelin mourant et sont venus se régaler. Certains d\'entre eux se curent déjà les dents avec des os d\'orc...",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Un peu plus brouillon que prévu...",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Ghouls, this.Math.rand(70, 90), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/named/named_dagger");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/rondel_dagger");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/loot/golden_chalice_item");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/loot/silver_bowl_item");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous n\'allez pas risquer la compagnie pour un seul gobelin misérable et un homme mort qui peut ou non avoir quelque chose de précieux. La compagnie contourne largement la clairière et continue sa route à travers la forêt sans encombre.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Mieux vaut garder la compagnie en forme pour des menaces plus importantes.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_48.png[/img]Vous n\'allez pas risquer la compagnie pour un seul gobelin misérable et un homme mort qui peut ou non avoir quelque chose de précieux. La compagnie contourne largement la clairière et continue à travers la forêt.\n\n Pas plus de cinq minutes plus tard sur la route vous entendez un tonnerre de pas venant de l\'arrière. Ce qui en est la cause n\'a pas peur d\'être entendu. Vous vous cachez et attendez et, sans surprise, des orcs et des gobelins traversent les arbres. L\'un d\'eux est le bâtard que vous avez laissé au piège à ours, sa jambe enveloppée à la hâte dans des draps et des feuilles.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Merde, le petit avorton nous cherche !",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_goblins_03"
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(70, 90), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 5)
			{
				return;
			}
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

