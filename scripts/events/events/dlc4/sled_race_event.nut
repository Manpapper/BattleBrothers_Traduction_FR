this.sled_race_event <- this.inherit("scripts/events/event", {
	m = {
		Sledder = null,
		Fat = null,
		Blind = null
	},
	function create()
	{
		this.m.ID = "event.sled_race";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]{Alors que la neige et les vents violents s\'abattent sur votre visage, il semble presque miraculeux qu\'il y ait quelqu\'un sur cette montagne qui vous fasse signe de descendre. Mais il est là, un gars barbu avec deux traîneaux à la main. Il crie pour savoir si vous êtes intéressés par une course.%SPEECH_ON%Le premier à fendre ces deux pierres en forme de bite gagne!%SPEECH_OFF%Vous demandez ce qu\'il y a en jeu. Quand il vous regarde comme un chien à qui on parle dans la mauvaise langue, vous demandez ce que vous pariez. Il rit.%SPEECH_ON%Il n\'y a pas de pari! C\'est juste pour le plaisir!%SPEECH_OFF%Pas de problème. Peut-être que l\'un de la compagnie %companyname% aimerait essayer?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Que quelqu\'un s\'avance et le fasse!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Fat != null)
				{
					this.Options.push({
						Text = "On dirait que %fat% est volontaire.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Blind != null)
				{
					this.Options.push({
						Text = "On dirait que %shortsighted% est volontaire.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Options.push({
					Text = "Nous avons des choses plus importantes à faire.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_143.png[/img]{%sledder% prend l\'un des traîneaux de l\'homme des montagnes.%SPEECH_ON%Je serais plus rapide que vous pour séparer ces bites.%SPEECH_OFF%Tout le monde lève un sourcil quand il pose le traîneau. Il cale ses bottes contre l\'avant et le fait basculer vers le bord de la colline.%SPEECH_ON%Quand vous voulez.%SPEECH_OFF%Le montagnard donne le signal de départ, les deux hommes dévalent la neige en un instant. Vous n\'êtes pas sûr que votre mercenaire ait joué petit bras, mais l\'homme des montagnes tourne soudainement sur le côté et renverse son traîneau, il roule dans la poudreuse dans un fracas de barbe et de membres. Pendant ce temps, %sledder% s\'offre une victoire sans difficulté. La compagnie applaudit la victoire et le porte sur ses épaules en haut de la montagne. Si le mercenaire a triché, cela ne se voit pas sur le visage du montagnard, il est juste heureux d\'avoir couru.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sledder.getImagePath());
				_event.m.Sledder.getBaseProperties().Initiative += 1;
				_event.m.Sledder.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Sledder.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Initiative"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			Text = "[img]gfx/ui/events/event_143.png[/img]{%sledder% prend le traîneau de l\'homme des montagnes.%SPEECH_ON%Je vous battrai à ces bites en temps voulu.%SPEECH_OFF%Tout le monde lève un sourcil quand il pose le traîneau. Il cale ses bottes contre l\'avant et le fait basculer vers le bord de la colline.%SPEECH_ON%C\'est quand vous voulez.%SPEECH_OFF%L\'homme des montagnes donne le signal du départ et les deux hommes dévalent la neige en un instant. Des blocs de poudreuses tombent dans leur sillage et il semble que %sledder% va gagner jusqu\'à ce qu\'il se trompe d\'angle et percute l\'un des rochers. Le traîneau se brise en morceaux, l\'épée passe au-dessus de la pierre et atterrit mollement dans la neige. En riant, la compagnie se précipite pour l\'aider et le remet sur pied. Il a des framboises sur lui et quelque chose fait \"clic\", mais il survivra. L\'homme des montagnes applaudit.%SPEECH_ON%Vous m\'avez presque eu, mais vous êtes censé fendre les bites, pas les monter!%SPEECH_OFF%Pleurant de rire, vos hommes sont en train de se rouler par terre.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ouch.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sledder.getImagePath());
				local injury = _event.m.Sledder.addInjury(this.Const.Injury.Mountains);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Sledder.getName() + " souffre de " + injury.getNameOnly()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Sledder.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_08.png[/img]{%fat%, l\'homme le plus gros de la compagnie, décide d\'essayer. Vous appréciez sa prise de risque - étant donné son poids, il est probable qu\'il dévalera le flanc de la montagne. L\'homme des montagnes accepte volontiers le défi, fixe les règles de base et lance la course proprement dite. Les deux hommes se frayent un chemin dans la neige avec aisance et, comme vous le pensiez, le gros fonce dans la poudreuse comme un éclair dans un nuage. Mais il ne semble pas ralentir. Il passe juste entre les deux rochers, signant sa victoire. Le problème, c\'est qu\'il est incapable de saisir les rênes ou de ralentir. Il franchit un escarpement et c\'est à peu près la dernière fois que vous le voyez. Le montagnard grimace et court vers la colline.%SPEECH_ON%Il est vivant! Un peu amoché, mais vivant!%SPEECH_OFF%Bien que vous soyez très inquiet, vous vous retournez pour voir que toute la compagnie est pliée en deux ou à genoux, morte de rire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nom d\'une pipe!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fat.getImagePath());
				local injury = _event.m.Fat.addInjury(this.Const.Injury.Mountains);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Fat.getName() + " souffre de " + injury.getNameOnly()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Fat.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_143.png[/img]{%shortsighted% se porte volontaire pour faire la course avec l\'homme des montagnes. Vous êtes réticent à l\'idée de le laisser faire, étant donné la mauvaise vue du mercenaire, mais il est plutôt assidu en la matière. Lorsqu\'il s\'accroupit sur le traîneau et prend les rênes, on ne peut s\'empêcher de remarquer qu\'il louche déjà vers le bas de la pente, comme s\'il ne pouvait distinguer un flanc de montagne d\'une grange rouge.%SPEECH_ON%Prêt!%SPEECH_OFF%L\'homme des montagnes fixe les règles et lance la course. Presque immédiatement, le mercenaire bigleux dévie de sa route. Heureusement, il n\'est même pas à pleine vitesse quand il percute une formation rocheuse la tête la première. Le traîneau se brise comme une tomate contre un pilori et l\'homme s\'écrase contre la pierre. Vous vous précipitez à son secours et le remettez sur pied, mais à cet instant, vous marchez sur quelque chose de métallique. Un coffre au trésor ! Vous dites à la compagnie d\'apporter à l\'homme une aide appropriée pendant que vous déterrez ce que vous pouvez.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les aveugles guident les voyants.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Blind.getImagePath());
				local injury = _event.m.Blind.addInjury(this.Const.Injury.Mountains);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Blind.getName() + " souffre de " + injury.getNameOnly()
				});
				local item = this.new("scripts/items/loot/ancient_gold_coins_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_fat = [];
		local candidates_blind = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.fat"))
			{
				candidates_fat.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.short_sighted"))
			{
				candidates_blind.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Sledder = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_fat.len() != 0)
		{
			this.m.Fat = candidates_fat[this.Math.rand(0, candidates_fat.len() - 1)];
		}

		if (candidates_blind.len() != 0)
		{
			this.m.Blind = candidates_blind[this.Math.rand(0, candidates_blind.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sledder",
			this.m.Sledder.getNameOnly()
		]);
		_vars.push([
			"fat",
			this.m.Fat ? this.m.Fat.getNameOnly() : ""
		]);
		_vars.push([
			"shortsighted",
			this.m.Blind ? this.m.Blind.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Sledder = null;
		this.m.Fat = null;
		this.m.Blind = null;
	}

});

