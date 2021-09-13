this.spartan_should_eat_more_event <- this.inherit("scripts/events/event", {
	m = {
		Spartan = null
	},
	function create()
	{
		this.m.ID = "event.spartan_should_eat_more";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] %spartan% a toujours été un peu strict sur la quantité de nourriture qu\'il mange. Vous ne savez pas si cela fait partie d\'un rite religieux, d\'un sens du devoir, ou s\'il n\'est tout simplement pas un gros mangeur. Quoi qu\'il en soit, le manque de nourriture a affaibli l\'homme et vous le trouvez à peine capable de s\'asseoir droit sur une bûche. Vous avez un bol de viande et de maïs à la main et vous vous demandez si vous ne devriez pas le lui offrir.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je vais le laisser tranquille.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "B" : "C";
					}

				},
				{
					Text = "Mange, idiot !",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "D" : "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img] Vous décidez que l\'homme est probablement déjà passé par là et vous décidez de le laisser tranquille. Quelques instants plus tard, vous le surprenez en train de marcher et de parler sans problème. En fait, il se déplace plutôt bien pour un homme qui mange si peu !",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chacun son truc.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img] L\'homme l\'a fait avant, il peut le refaire. Vous vous retournez pour aller manger votre repas ailleurs, seulement vous entendez l\'homme s\'effondrer sur le sol. Il est complètement évanoui et semble s\'être cogné la tête en tombant.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Par les sept enfers, qu\'est-ce qui ne va pas chez toi ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Spartan.addLightInjury();
					this.List = [
						{
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = _event.m.Spartan.getName() + " souffre de blessures légères"
						}
					];
				}
				else
				{
					local injury = _event.m.Spartan.addInjury(this.Const.Injury.Concussion);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.Spartan.getName() + " souffre de " + injury.getNameOnly()
						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img] Vous ordonnez à l\'homme de manger. Il résiste, mais vous lui rappelez que c\'est un\ "ordre\", pas une demande. Le mercenaire s\'exécute et mange avec précaution dans votre bol. Il se plaint qu\'il ne veut plus manger, mais vous lui ordonnez de terminer le repas. Avec le temps, ce qui le rendait malade semble avoir disparu. L\'énergie revient dans ses yeux et il se lève avec un bon élan dans sa démarche. Malheureusement, il n\'aime pas qu\'on lui dise d\'enfreindre ses codes personnels.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne me fais pas répéter ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());
				_event.m.Spartan.worsenMood(1.0, "Forcé de manger contre ses croyances");

				if (_event.m.Spartan.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Spartan.getMoodState()],
						text = _event.m.Spartan.getName() + this.Const.MoodStateEvent[_event.m.Spartan.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img] Ordonnant à l\'homme de manger, celui-ci s\'exécute. Au début, il semble plutôt réticent, mais après quelques bouchées, il plonge dans le bol, s\'engorgeant de jus et des grains de maïs parsèment ses joues. Il est presque fou de joie. Vous lui avez rappelé à quel point la nourriture peut être bonne. Personnellement, vous avez trouvé que la viande était un peu trop cuite.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne me fais pas répéter ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());
				_event.m.Spartan.getSkills().removeByID("trait.spartan");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_08.png",
						text = _event.m.Spartan.getName() + " n\'est plus un spartan"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.spartan") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Spartan = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"spartan",
			this.m.Spartan.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Spartan = null;
	}

});

