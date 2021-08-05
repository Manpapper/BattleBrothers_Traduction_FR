this.noble_vs_lowborn_event <- this.inherit("scripts/events/event", {
	m = {
		Noble = null,
		Lowborn = null
	},
	function create()
	{
		this.m.ID = "event.noble_vs_lowborn";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img] You find the nobleman %nobleman_short% and the rather ragged-looking %lowborn% quarreling over the last piece of food on a spit. Apparently the lowborn got his fork to it first, but the nobleman claimed that his high stature granted him the right to the meat.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sort it out yourselves.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "In the company of sellswords, no man is low or highborn.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "You know the rules of the land, give the noble what he wants.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img] As the two men look to you for guidance, you fold your arms and shrug. They slowly turn back to one another. The other men in the camp stand up and step back, giving room to what is coming. The lowborn draws his dagger first. It is a simple thing with a wooden handle and jagged, unnaturally serrated edges. The nobleman pulls his blade in return, brandishing a metal that curves with the care of a blacksmith\'s mastery. Two golden snakes curl up the handle to bite the pommel. Its wielder grins, saying the riff-raff should learn their place. The lowborn grins like a man who has had no practice doing it.\n\nSurprisingly, both men then chuck the daggers into the stumps upon which they sat and close rank with fists raised, the most equal of fighting grounds. In the ensuing battle the spit is immediately knocked aside and flames fan upward, raining wild embers and the felled food is now flavored with ash and soot.\n\nSeeing their meal ruined, the rest of the company finally puts an end to the combat, pulling the two men apart. They threaten and spit at one another, but after a few minutes everything settles down.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "They\'ll become brothers in battle soon enough.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
				local injury1 = _event.m.Noble.addInjury(this.Const.Injury.Brawl);
				local injury2 = _event.m.Lowborn.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury1.getIcon(),
					text = _event.m.Noble.getName() + " souffre de " + injury1.getNameOnly()
				});
				this.List.push({
					id = 10,
					icon = injury2.getIcon(),
					text = _event.m.Lowborn.getName() + " souffre de " + injury2.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]%nobleman% looks aghast. He slowly lifts his fork from the spit and %lowborn% immediately shovels the last bit of meat into his mouth. The nobleman gets up and heads your way. He straightens before you, bumping his chest into yours as you lock eyes. A few of the men put their hands on their pommels.%SPEECH_ON%{Siding with the lowborn, huh? I fancied you would, being lowborn yourself. Don\'t ever expect to become one of us. You\'re a sellsword for life. Remember that. | You expect to get a piece of land when all this is said and done, yeah? I hope you do, because then I\'ll come and knock and show you how nobles really treat one another.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get out of my sight.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
				_event.m.Noble.worsenMood(2.0, "Was humiliated in front of the company");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]%nobleman% grins as he knocks %lowborn%\'s fork out of the way. The nobleman takes the food for himself as the lowborn gets up and storms toward you. As he nears, some men look ready to draw swords, but you hold a hand out, calming them.%SPEECH_ON%I thought you were one of us, but I guess not. I suppose you think someday you\'ll be one of them, huh? Keep dreaming. As that man would say to me, \'Know your place\'.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get out of my sight.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
				_event.m.Lowborn.worsenMood(2.0, "Was humiliated in front of the company");

				if (_event.m.Lowborn.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Lowborn.getMoodState()],
						text = _event.m.Lowborn.getName() + this.Const.MoodStateEvent[_event.m.Lowborn.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local noble_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 7 && bro.getBackground().isNoble())
			{
				noble_candidates.push(bro);
			}
		}

		if (noble_candidates.len() == 0)
		{
			return;
		}

		local lowborn_candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkill("trait.hesitant") && bro.getBackground().isLowborn() && bro.getBackground().getID() != "background.slave")
			{
				lowborn_candidates.push(bro);
			}
		}

		if (lowborn_candidates.len() == 0)
		{
			return;
		}

		this.m.Noble = noble_candidates[this.Math.rand(0, noble_candidates.len() - 1)];
		this.m.Lowborn = lowborn_candidates[this.Math.rand(0, lowborn_candidates.len() - 1)];
		this.m.Score = noble_candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"nobleman",
			this.m.Noble.getName()
		]);
		_vars.push([
			"nobleman_short",
			this.m.Noble.getNameOnly()
		]);
		_vars.push([
			"lowborn",
			this.m.Lowborn.getName()
		]);
		_vars.push([
			"lowborn_short",
			this.m.Lowborn.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Noble = null;
		this.m.Lowborn = null;
	}

});

