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
			Text = "[img]gfx/ui/events/event_05.png[/img] %spartan% has always been a bit tight with how much he eats. You\'re not sure if it\'s part of some religious rite, a sense of duty, or he\'s just not a big eater. Regardless, the lack of food has weakened the man and you find him barely able to sit upright on a log. You\'ve got a bowl of meat and corn in hand, wondering if maybe you should offer it to him.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ll leave you be.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "B" : "C";
					}

				},
				{
					Text = "Eat up, fool!",
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
			Text = "[img]gfx/ui/events/event_05.png[/img] You decide that the man has probably been through this before and decide to leave him be. A few moments later, you catch him walking and talking just fine. In fact, he gets around pretty well for a man who eats so lightly!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To each his own.",
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
			Text = "[img]gfx/ui/events/event_05.png[/img] The man\'s done this before, he can do it again. You turn around to go eat your meal elsewhere, only to hear the man crumple to the ground. He\'s completely passed out and appears to have hit his head on the way down.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What in the seven hells is wrong with you?",
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
							text = _event.m.Spartan.getName() + " suffers light wounds"
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
							text = _event.m.Spartan.getName() + " suffers " + injury.getNameOnly()
						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img] You order the man to eat. He resists, but you remind him that it is an \'order\', not a request. The sellsword does as told, eating rather gingerly from your bowl. He complains that he does not wish to eat anymore, but you order him to finish the meal. In time, whatever ailed him seems lifted. Energy returns to his eyes and he gets up with a good spring in his step. Unfortunately, he does not care for being told to break his personal codes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Don\'t make me repeat this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Spartan.getImagePath());
				_event.m.Spartan.worsenMood(1.0, "Forced to eat against his beliefs");

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
			Text = "[img]gfx/ui/events/event_05.png[/img] Ordering the man to eat, the man does as told. At first, he seems rather reluctant, but after a few bites he dives into the bowl, engorging himself in juices and flecks of corn dot his cheeks. He is almost mad with delight. You\'ve reminded him of just how good food can be. Personally, you thought the meat was a little overcooked.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Don\'t make me repeat this.",
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
						text = _event.m.Spartan.getName() + " is no longer spartan"
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

