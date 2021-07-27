this.education_event <- this.inherit("scripts/events/event", {
	m = {
		DumbGuy = null,
		Scholar = null
	},
	function create()
	{
		this.m.ID = "event.education";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_15.png[/img]During your travels, %scholar% has taken some interest in %dumbguy%\'s intellectual shortcomings. %scholar_short% says that, with some time, he could learn the man a thing or two. %dumbguy_short% can put one foot in front of the other - and sometimes quite confidently - but you think that\'s about where his aptitude for all things comes to an end. Not only that, but %scholar_short% has gotten easily frustrated in the past. Teaching the dumb brother might just be an exercise in inflating his own ego.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "See what you can teach him.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "B" : "C";
					}

				},
				{
					Text = "Leave %dumbguy% alone.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_15.png[/img]{You come across %scholar% and %dumbguy% staring at a patch of dirt. Along the brown canvas you see that %scholar_short% has drawn geometric shapes, letters, numbers, and what look like constellations. It appears that they\'ve been at this for hours now. \n\nA teaching stick in hand, %scholar% madly points at one of the star clusters and demands to know what it is. %dumbguy%, with a pained expression, guesses a sheep. %scholar% snaps the teaching stick in half and kicks dirt all over his drawings. It\'s a horse! A horse! %scholar% sighs heavily before marching off to the beat of endless profanity. Personally, you thought it was a crab. | You find %scholar% standing over %dumbguy%. Count the beetles, don\'t smash them, the learned man says with exasperation. %dumbguy% looks down at his beetle-juiced hands where {fragments of insect carapaces | carapaces of once-insects} dot his flesh. He nods, understandingly, and turns to pulling the beetles\' legs off instead. %scholar% lets out a string of swears you\'ve never heard in your life. | You find %scholar% and %dumbguy% yelling at one another. It appears they\'re at a very red-faced crossroads. %dumbguy_short% says he doesn\'t care if he\'s dumb, and the %scholar_short% argues that every man should be learned. Well it appears %dumbguy_short% would prefer to be left to his devices for he shows %scholar_short% his back as he walks away. Guess that\'s the end of the lesson for both men. | You find %dumbguy% squatting beside a creek, staring at himself in the shimmering reflection. He must have been at it for a while now for he\'s showing signs of sunburn. You ask if everything is alright, to which he explains that he is not \'getting it\' with %scholar%\'s teachings, and that %scholar% nearly went mad today before finally giving up on the venture. You explain that %dumbguy% doesn\'t have to be smart, he just needs to know how to swing a sword and shoot a bow. That\'s what you hired him for, after all. The man tries to hide a smile, but the running water betrays him. You take him back to camp where you then tell %scholar% to lay off for a while.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Why will you not learn?! | Ignorance is bliss.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());
				_event.m.Scholar.worsenMood(2.0, "Failed to teach " + _event.m.DumbGuy.getName() + " anything");

				if (_event.m.Scholar.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List = [
						{
							id = 10,
							icon = this.Const.MoodStateIcon[_event.m.Scholar.getMoodState()],
							text = _event.m.Scholar.getName() + this.Const.MoodStateEvent[_event.m.Scholar.getMoodState()]
						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_15.png[/img]{You come across %dumbguy% mulling over a set of coins on a table. You inquire as to what he is doing and he says he\'s trying to figure out how much to save for retirement. First off, you\'re surprised he even knows what the word retirement is. Second off, counting? Looks like you might owe %scholar% a pint. | You find %dumbguy% sitting on a stump as he writes across a scroll. When you ask what he\'s doing, he says he\'s writing a letter. When you ask to whom it is addressed, the man looks up with a sheepish grin and asks, does it matter? Just then, you spot %scholar% in the distance, arms crossed, a look of satisfaction on his face.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fascinating.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());
				_event.m.Scholar.improveMood(2.0, "Taught " + _event.m.DumbGuy.getName() + " quelque chose");
				_event.m.DumbGuy.getSkills().removeByID("trait.dumb");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_17.png",
					text = _event.m.DumbGuy.getName() + " is no longer dumb"
				});

				if (_event.m.Scholar.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Scholar.getMoodState()],
						text = _event.m.Scholar.getName() + this.Const.MoodStateEvent[_event.m.Scholar.getMoodState()]
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

		local dumb_candidates = [];
		local scholar_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.dumb"))
			{
				dumb_candidates.push(bro);
			}
			else if ((bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.historian") && !bro.getSkills().hasSkill("trait.hesitant"))
			{
				scholar_candidates.push(bro);
			}
		}

		if (dumb_candidates.len() == 0 || scholar_candidates.len() == 0)
		{
			return;
		}

		this.m.DumbGuy = dumb_candidates[this.Math.rand(0, dumb_candidates.len() - 1)];
		this.m.Scholar = scholar_candidates[this.Math.rand(0, scholar_candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dumbguy",
			this.m.DumbGuy.getName()
		]);
		_vars.push([
			"dumbguy_short",
			this.m.DumbGuy.getNameOnly()
		]);
		_vars.push([
			"scholar",
			this.m.Scholar.getName()
		]);
		_vars.push([
			"scholar_short",
			this.m.Scholar.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.DumbGuy = null;
		this.m.Scholar = null;
	}

});

