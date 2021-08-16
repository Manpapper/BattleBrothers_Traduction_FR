this.kids_and_dead_merchant_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight = null
	},
	function create()
	{
		this.m.ID = "event.kids_and_dead_merchant";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]Vous trouvez un enfant portant une chaîne plutôt opulente autour du cou. La chaîne est si lourde qu\'il a la tête penchée en avant, mais cette petite lutte n\'efface pas le large sourire de son visage. %randombrother% pousse le gamin et prend le collier.%SPEECH_ON% Où as-tu eu ça?%SPEECH_OFF% Le gamin crie, essayant de récupérer son trésor, mais il lui manque environ un mètre et un bon saut.%SPEECH_ON%Hey, c\'est à moi ! Rends-le moi !%SPEECH_OFF%Un autre enfant arrive en montrant une bague si grosse qu\'elle lui pince deux doigts à la fois. D\'accord. C\'en est assez. La compagnie se déploie et finit par trouver un marchand mort dans les hautes herbes près d\'un arbre. Son visage est violacé et déchiqueté par des os brisés. Il semble qu\'il ait été lapidé à mort. Un groupe d\'environ quarante ou cinquante jeunes surgit de la limite des arbres, chacun jonglant avec une pierre à la main. Leur chef, un petit avorton aux cheveux roux et aux bras plein de tatouages, demande ce que vous voulez. Vous lui dites que vous allez prendre les biens du marchand. Le chef se met à rire.%SPEECH_ON%Ohh, C\'est vrai? Je te donne dix secondes pour repenser à ce choix, oui que je le ferai, monsieur!%SPEECH_OFF%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On prend la marchandise.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.HedgeKnight != null)
				{
					this.Options.push({
						Text = "Tu as quelque chose à dire, %hedgeknight%?",
						function getResult( _event )
						{
							return "HedgeKnight";
						}

					});
				}

				this.Options.push({
					Text = "Reculez, les gars.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_97.png[/img]Malgré la force militaire miniature qui se dresse devant vous, vous avez l\'ordre de prendre la marchandise. Le petit garçon chargé de l\'opération lance un cri de guerre qui tient plus du chat mourant que de l\'épervier plongeur.%SPEECH_ON%Descendez-les ! Lancez ! Lancez ! Lanceeezzzz ! %SPEECH_OFF%A son commandement, la foule d\'enfants commence à lancer des pierres depuis la cime des arbres. Les mercenaires se regroupent, tenant leurs boucliers en une formation semblable à une tortue, et avancent lentement. C\'est un drôle de mouvement, mais la compagnie parvient à saisir les marchandises du marchand et à s\'éloigner, tout en se faisant bombarder de toutes parts. Le petit chef vous fait un signe du poing. Vous lui faites un doigt d\'honneur et reprenez le chemin où vous regardez attentivement les marchandises du marchand. %randombrother%  fixe les récompenses tout en se frottant une plaie sur le front.%SPEECH_ON% Bon sang, mec. J\'ai vu des armées loin d\'être aussi féroces. Je pleure pour les futurs hommes qui devront croiser le fer avec ces garçons et ces filles.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ces petits bâtards nous en ont fait voir de toutes les couleurs.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(50, 200);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " souffre de " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " souffre de blessures légères"
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "HedgeKnight",
			Text = "[img]gfx/ui/events/event_35.png[/img]%hedgeknight% s\'avance et brandit son arme. Il la brandit vers tous les enfants. %SPEECH_ON%Ah, alors vous voulez être des petits bandits ou des héros ou une merde du genre ? Bien, c\'est bien. C\'est très bien. Mais je vais regarder pour voir qui jettera la première pierre. Celui, ou celle, qui le fera découvrira ce qui se passe quand je suis en colère. Et après que vous ayez tous regardé, je vous tuerai tous. Et je suivrai vos petites empreintes jusqu\'à votre maison, je trouverai vos proches et je leur casserai la tête. Le chevalier errant s\'arrête pour regarder autour de lui.%SPEECH_ON% Alors, lequel d\'entre vous jettera la première pierre ?%SPEECH_OFF%Le gamin en charge de cette armée miniature lève la main et parle.%SPEECH_ON%Laissons les partir. Nous avons mieux à faire que de nous disputer avec ces voyageurs. %SPEECH_OFF%Hé, c\'est une sage décision. Avec un tel sens de l\'humour, le bougre roux pourrait un jour mener à la fortune une compagnie. Mais ce jour est le vôtre. Vous prenez les biens du marchand et vous partez.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Des petites bites.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(50, 200);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] Couronnes"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_hedgeknight = [];

		foreach( b in brothers )
		{
			if (b.getBackground().getID() == "background.hedge_knight")
			{
				candidates_hedgeknight.push(b);
			}
		}

		if (candidates_hedgeknight.len() != 0)
		{
			this.m.HedgeKnight = candidates_hedgeknight[this.Math.rand(0, candidates_hedgeknight.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight != null ? this.m.HedgeKnight.getNameOnly() : ""
		]);
		_vars.push([
			"hedgeknighfull",
			this.m.HedgeKnight != null ? this.m.HedgeKnight.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight = null;
	}

});

