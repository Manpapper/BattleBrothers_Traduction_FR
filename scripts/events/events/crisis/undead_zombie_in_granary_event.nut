this.undead_zombie_in_granary_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_zombie_in_granary";
		this.m.Title = "À %town%...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]Vous tombez sur un homme qui crie à l\'aide, tellement hystérique qu\'il semble ne pas se soucier d\'attirer l\'attention de mercenaires qui n\'ont aucune allégeance à une maison ou à leurs lois.%SPEECH_ON%S\'il vous plaît ! Aide-moi! Il y a un... un cadavre ! Dans le grenier !%SPEECH_OFF%Il passe le pouce par-dessus son épaule en direction d\'un grand bâtiment en bois. Sa porte d\'entrée claque au bon moment. L\'homme perd la tête.%SPEECH_ON%C\'est lui ! C\'est le monstre ! S\'il vous plaît, allez-y et tuez-le ! Nous ne pouvons pas nous permettre de perdre toute la nourriture qui s\'y trouve !%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il vaut mieux brûler ce grenier.",
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
					Text = "Un de mes hommes entrera et s\'occupera de ça.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
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
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_30.png[/img]Vous attrapez l\'homme par les épaules et le fixez pendant que vous parlez.%SPEECH_ON%Nous allons brûler le grenier. Sauvez de la nourriture, écoutez-vous! Écoutez attentivement ce que je vais dire. La nourriture qui s\'y trouve est malade et ne doit pas être consommée. Il n\'y a rien à sauver.%SPEECH_OFF%Le paysan, le corps tremblant comme de froid, s\'écarte. Il écrase son visage entre ses deux mains, à peine capable de regarder deux de vos mercenaires s\'avancer, torches à la main, et mettre le feu au grenier.\n\nLa porte s\'arrête de cliqueter pendant un moment, puis se relève, brisant presque ses gonds . Alors que de la fumée s\'échappe du fond, quelqu\'un commence à crier.%SPEECH_ON%Une blague ! Une blague! S\'il vous plaît, laissez-moi sortir! Aaah, AAAHH !%SPEECH_OFF%%dude% se précipite vers la porte et la défonce. Un petit garçon s\'épuise, son corps comme une torche, des membres agitant des arcs de flammes. Il s\'installe au sol où les mercenaires tentent de le couvrir, mais il est trop tard. Il est une ruine fumante au moment où le feu est éteint. Le paysan a l\'air absolument horrifié.%SPEECH_ON%Je... Je n\'en avais aucune idée, je le pensais... il n\'arrêtait pas de faire des grognements.%SPEECH_OFF%Vous secouez la tête et dites à la compagnie de reprendre rapidement la route. ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eh bien, merde.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "Vous avez fait brûlé un garçon par accident");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_30.png[/img]La nourriture est sans aucun doute perdue pour les maladies maintenant, et tout le bâtiment pourrait être infecté par des maux au-delà de la mesure humaine. Lentement, vous expliquez à l\'homme que vous allez brûler son grenier. Il ne refuse pas, se contente de hocher la tête rapidement.%SPEECH_ON%Je sais. Je ne voulais pas le faire moi-même, je suppose, peut-être m\'accrocher à l\'idée que quelqu\'un viendrait me dire ce que je voulais entendre, pas ce qu\'il fallait faire. Vous allumez un coin du grenier et il ne faut pas longtemps pour que les incendies se propagent sur ses murs et son toit. Une minute plus tard, toute la structure flamboie. Lorsque la porte d\'entrée s\'effondre, un wiederganger se faufile à travers l\'espace, tout son corps se tordant de feu et de fumée. Ce n\'est plus que des os noircis maintenant, la peau dégoulinant de son squelette en grosses gouttes gluantes. %dude% lui coupe la tête d\'un coup rapide. Le paysan regarde le reste de son silo s\'effondrer, la lueur du feu faisant briller les larmes sur sa joue.%SPEECH_ON%Eh bien, je suppose que c\'est tout alors. Merci, mercenaire.%SPEECH_OFF%Il vous offre une modeste somme de couronnes que vous êtes plus qu\'heureux de prendre pour vos \'services\'",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Efficace",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(50);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous obtenez [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_79.png[/img]Vous décidez de résoudre ce problème de wiederganger. %dude% défonce la porte d\'entrée et poignarde la première chose qu\'il voit. Le cadavre du mort-vivant vacille, l\'élan faisant plier son corps sur la lame. Et puis vous le voyez : le sang coule lentement sur le métal. Alors que le mercenaire recule, la lumière révèle que le cadavre n\'est pas un mort-vivant, mais un simple garçon. Il se gargarise, les yeux écarquillés, les mains tremblantes contre sa blessure.%SPEECH_ON%Je... Je jouais juste...%SPEECH_OFF%Le mercenaire écarte un bras et retire son arme. Le garçon s\'effondre. Vous vous tournez vers le paysan. Il lève les mains.%SPEECH_ON%J\'avais... Je n\'en avais aucune idée ! Il faisait du bruit ! Il a fait du bruit, j\'ai entendu... grogner ! Il y avait tellement de grognements, je ne...%SPEECH_OFF%L\'homme tombe à genoux. Vous regardez le garçon qui est au-delà de toute aide, sa peau devenant plus pâle à la seconde alors que des cordes de cramoisi jaillissent de ses blessures. Vous secouez la tête et dites aux hommes de reprendre la route avant que quelque chose de mauvais n\'arrive.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Putain d\'Enfer",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.worsenMood(2.0, "Tué un petit garçon par accident");

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_79.png[/img]Vous envoyez %dude% dans le grenier pour le gérer. Il étire ses épaules pour se détendre.%SPEECH_ON%Un wiederganger arrive tout droit.%SPEECH_OFF%Le mercenaire défonce la porte et se précipite. Il y a le vacarme des combats et un éclair de lumière frappe le métal de l\'arme du mercenaire alors qu\'il travaille à travers les ténèbres et le mal. Un instant plus tard, il recule, essuyant la sueur de son front.%SPEECH_ON%Terminé. Du sang sur une partie de la nourriture, mais vous pouvez juste manger autour de ça.%SPEECH_OFF%Vous vous tournez vers le paysan et lui tendez la main. Il vous tend à contrecœur une petite bourse de couronnes.%SPEECH_ON%Merci... mercenaire.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon travail.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(50);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous obtenez [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] Couronnes"
					}
				];
				_event.m.Dude.improveMood(0.25, "Sauvé un paysan");

				if (_event.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
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

		if (bestTown == null || bestDistance > 3)
		{
			return;
		}

		this.m.Town = bestTown;
		this.m.Dude = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
		_vars.push([
			"dude",
			this.m.Dude.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Dude = null;
	}

});

