this.religious_peasants_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.religious_peasants";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]Les forêts ont toujours été un refuge pour l\'homme - la nature sauvage d\'où il est venu, la nature sauvage où il souhaite toujours retourner. Et là, vous trouvez un grand nombre d\'hommes, une tribu d\'égarés, insouciants de leurs civilisations disparues, vêtus d\'habits religieux, portant de grands sceaux de foi et des tomes de vérité. Ils sont appauvris, presque au point d\'être décadents, comme de grands rois cherchant à s\'intégrer aux roturiers. Vous vous asseyez et vous les regardez passer en traînant les pieds, en s\'entrechoquant, en faisant tinter des perles de bois creuses, en murmurant dans leur souffle, rauque et sec. Et ils continuent ainsi, sans même prendre la peine de vous regarder.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Voyons voir où ils vont.",
					function getResult( _event )
					{
						if (_event.m.Monk != null)
						{
							local r = this.Math.rand(1, 3);

							if (r == 1)
							{
								return "B";
							}
							else if (r == 2)
							{
								return "C";
							}
							else
							{
								return "F";
							}
						}
						else
						{
							local r = this.Math.rand(1, 2);

							if (r == 1)
							{
								return "B";
							}
							else
							{
								return "C";
							}
						}
					}

				},
				{
					Text = "C\'est probablement mieux de les laisser tranquilles.",
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
			Text = "[img]gfx/ui/events/event_03.png[/img]Curieux, vous appelez les hommes pour leur demander où ils vont. L\'homme de devant se tourne lentement vers vous, ses yeux émergeant de la pénombre d\'un châle enveloppé. Il retire lentement son manteau, révélant une tête marquée par un motif de rites religieux. Tous les hommes derrière lui font lentement de même, comme une rangée de cartes tombant au gré d\'un vent chaotique et fou.%SPEECH_ON%Davkul vous verra dans l\'autre monde!%SPEECH_OFF%L\'un d\'eux crie et ils chargent.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_12.png[/img]{De toute évidence, ce n\'est pas un spectacle ordinaire pour vous, alors, curieux, vous appelez les voyageurs fatigués. Les mots sortent à peine de vos lèvres que toute la file d\'hommes s\'arrête en un instant et se redresse. Leurs manteaux s\'effilochent et tombent de leurs têtes, et leurs tomes, leurs bâtons et leurs importations religieuses tombent dans un fracas uniforme. Les hommes regardent autour d\'eux, les yeux plus vivants que jamais. L\'un d\'eux crie. Puis un autre. Et bientôt, ils crient tous, et certains s\'effondrent sur le sol, se serrant les oreilles comme pour faire taire les hurlements horribles que leurs bouches ont dû émettre, tandis que d\'autres tournent en rond, les bras tendus, suppliant qu\'on leur donne des réponses.\n\n Votre simple parole a apparemment brisé un sort qui était depuis si longtemps au-dessus de leurs têtes qu\'il les avait amenés ici, appauvris, affamés et fous. Petit à petit, ils ont été gouvernés par une puissance supérieure malveillante, et petit à petit, ils ont senti le contrôle de leur vie leur échapper, et avec lui, la santé mentale dont tous les hommes ont besoin pour être eux-mêmes. Malheureusement, vous pouvez difficilement leur demander ce qui leur est arrivé ou qui leur a fait ça, car certains tombent raides morts tandis que d\'autres sprintent nus dans la forêt. | Un tel spectacle suscite des questions, mais à la seconde où vous prononcez un mot, toute la troupe de religieux se redresse brusquement, les vêtements et le matériel s\'entrechoquent avec une telle uniformité qu\'on dirait qu\'une porte a été claquée. Les hommes laissent tomber leurs affaires et se mettent à crier. C\'est un chœur rauque. Ils commencent tous à s\'effondrer, soit en se tordant sur des genoux osseux, soit en se serrant l\'estomac dû à une faim douloureuse.\n\n%randombrother% s\'approche, secouant la tête. %SPEECH_ON% Ont-ils été maudits ? Qu\'est-ce qui a bien pu faire ça?%SPEECH_OFF% Vous n\'aurez jamais de réponse car une minute plus tard, tous les hommes sont morts, ressemblant à des cadavres récemment décongelés des montagnes. Le sort a dû piloter de force leur pèlerinage jusqu\'ici, mettant à rude épreuve le corps humain tout en le maintenant en vie par le simple fil de la malveillance éthérée. Bien qu\'ils soient tous morts, vous ne regrettez pas de les avoir libérés d\'une si horrible malédiction.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Qu\'ils reposent en paix.",
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
					if (bro.getSkills().hasSkill("trait.superstitious") || this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(0.5, "Témoin d\'une horrible malédiction");

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
			ID = "F",
			Text = "[img]gfx/ui/events/event_59.png[/img]Curieux de savoir où vont ces hommes, vous ouvrez la bouche, mais %monk% le moine s\'avance et vous coupe la parole. Il se rend auprès de l\'homme qui se trouve à l\'avant de la troupe et s\'entretient tranquillement avec lui. Il y a beaucoup de hochements de tête, de rires et autres gesticulations d\'hommes qui s\'attardent longtemps sur des choses bien au-delà du domaine humain. Finalement, le moine revient.%SPEECH_ON%Ils sont en pèlerinage et maintenant notre nom voyage avec eux. Beaucoup en entendront parler.%SPEECH_OFF%Vous remerciez le moine pour son travail bien fait.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Nous sommes certainement des âmes damnées, mais ils ne le savent pas...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "La compagnie a gagné en renommée"
				});
				_event.m.Monk.improveMood(1.0, "A aidé à faire connaître la compagnie.");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Monk = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
	}

});

