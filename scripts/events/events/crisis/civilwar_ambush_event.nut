this.civilwar_ambush_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_ambush";
		this.m.Title = "Le long du chemin...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Les forêts cachent beaucoup de choses, étant le milieu naturel de prédateurs et d\'hommes aux intentions plus sauvages. Mais vous le savez bien, et vous savez repérer les ombres les moins naturelles à cet environement. Il ne vous faut pas longtemps pour réaliser qu\'il y a plus que des arbres ici, et d\'un coup de poing rapide dans le feuillage d\'un buisson, vous en sortez un jeune garçon avec un arc. Il crie au secours et les renforts arrivent tels des oiseaux chanteurs sur une jolie mélodie : une douzaine d\'hommes sortent de l\'ombre, mais la compagnie est préparée, dégainant leurs armes et venant se tenir sur un pied d\'égalité.\n\n Un homme âgé s\'avance , en levant les mains.%SPEECH_ON% Attendez, il n\'y a pas besoin de violence ici.%SPEECH_OFF% Il vient vous voir personnellement et d\'un ton assourdit et érudit vous explique ce qui se passe. Le petit groupe de paysans se prépare à tendre une embuscade à une troupe de soldats %noblehouse% qui viendront par ici à tout moment. Il déclare que vous obtiendrez une partie des récompenses si vous les aidez. Si ce n\'est pas le cas, veuillez vous écarter.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Aidons ces paysans.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nous devons avertir les soldats.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Nous n\'avons pas le temps pour cela.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_10.png[/img]Ce sont des paysans, grincheux et ayant l\'air de venir ici chercher des feuilles pour s\'habiller. Mais les arcs fragiles comme le leur sont livrés avec des mains endurcies, bien habituées à envoyer des flèches sans difficultés vers leurs cibles. Ce sont des hommes des forêts. Avec la certitude que cette embuscade se déroulera correctement, vous choisissez de les rejoindre.\n\n Vous n\'avez pas à attendre longtemps pour que les soldats de %noblehouse% commencent à se déplacer là-bas. Ils sont bruyants, odieux, et certains d\'entre eux pètent et se plaignent des champignons qu\'ils ont mangés par erreur.\n\n Un enfant d\'environ la moitié de votre taille lâche le premier coup. La flèche file entre deux branches et le premier éclaireur tombe à genoux. Les feuilles s\'agitent comme si un grand vent était venu - des flèches, invisible à l\'oeil, s\'infiltrent dans la colonne de soldats et elles sont si fidèles à leur objectif que leurs cibles meurent en silence. Quelques soldats parviennent à réduire la distance, levant des épées et des boucliers, mais les %companyname% intervient et les achèvent. Au bout d\'une minute, toute la patrouille a été tuée.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Cela s\'est bien passé. Partageons les marchandises.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_87.png[/img]Vos hommes vont ramasser les cadavres, rejoints par l\'équipe hétéroclite de tueurs. Une bagarre éclate pour savoir qui doit prendre un bouclier. Vous expliquez que la seule raison pour laquelle le bouclier existe pour le partage est parce que vos hommes se sont avancés pour tuer son propriétaire. Le chef du groupe acquiesce. Il demande à votre compagnie de prendre l\'équipement le plus lourd, car vos hommes sont certainement plus à l\'aise pour de telles choses.\n\n Pendant que vous répartissez les marchandises, l\'un des archers s\'avance.%SPEECH_ON%Je pense que l\'un d\'eux s\'est échappé. Il y a des traces, mais il devait être un peu plus intelligent que ses frères morts parce qu\'il les a assez bien couvertes. %SPEECH_OFF% Juste au moment où vous pensiez pouvoir vous en tirer avec quelque chose...",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Sauf pour le gars qui s\'est enfui, ça s\'est plutôt bien passé.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "A tendu une embuscade à certains de leurs hommes");
				this.World.Assets.addMoralReputation(-1);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationFavor, "A aidé dans une embuscade contre" + _event.m.NobleHouse.getName());
				local item;
				local banner = _event.m.NobleHouse.getBanner();
				local r;
				r = this.Math.rand(1, 4);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/arming_sword");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/morning_star");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/military_pick");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/billhook");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous gagnez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				r = this.Math.rand(1, 4);

				if (r == 1)
				{
					item = this.new("scripts/items/shields/faction_wooden_shield");
					item.setFaction(banner);
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/shields/faction_kite_shield");
					item.setFaction(banner);
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/armor/mail_shirt");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/armor/basic_mail_shirt");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous gagnez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_94.png[/img]Vous dites aux paysans que vous ne voulez pas participer à leur guerre, mais vous en resterez néanmoins à l\'écart.\n\n Dès qu\'ils sont hors de vue, vous trouvez les soldats de %noblehouse% et les informez des ennuis qui vont arriver. Le lieutenant ne vous croit pas jusqu\'à ce que vous le meniez proche des paysans et que vous les désigniez ou, plutôt, leurs ombres minces s\'attardant sournoisement derrière telle ou telle branche.\n\n De retour à la troupe, vous organisez un assaut. C\'est assez simple - vous contournez l\'embuscade et remontez par derrière. Les vieillards, les désespérés et les garçons naïfs sont tour à tour tués. Ils ne l\'ont pas vu venir, mais au milieu du chaos, certains se sont presque certainement échappés et ont raconté votre trahison. Vous récupérez quelques marchandises sur le champ de bataille et une somme de bienveillance du lieutenant de %noblehouse%.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Les locaux peuvent en entendre parler, quelle importance ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationFavor, "A sauvé certains de leurs hommes");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationOffense, "A tué certains de leurs hommes");
				local money = this.Math.rand(200, 400);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous gagnez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				local item;
				local r = this.Math.rand(1, 5);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/pitchfork");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/short_bow");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/hunting_bow");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/militia_spear");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/shields/wooden_shield");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous gagnez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();

		if (playerTile.Type != this.Const.World.TerrainType.Forest && playerTile.Type != this.Const.World.TerrainType.LeaveForest && playerTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() >= 3)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance > 10)
		{
			return;
		}

		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates = [];

		foreach( h in nobleHouses )
		{
			if (h.getID() != bestTown.getOwner().getID())
			{
				candidates.push(h);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = bestTown;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Town = null;
	}

});

