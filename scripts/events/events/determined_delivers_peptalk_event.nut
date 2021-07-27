this.determined_delivers_peptalk_event <- this.inherit("scripts/events/event", {
	m = {
		Determined = null
	},
	function create()
	{
		this.m.ID = "event.determined_delivers_peptalk";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_58.png[/img]You are beginning to worry that a sort of malaise has fallen upon the men. They sit about the campfire, mindlessly poking sticks into the flames. Each face shows a loss of control, a loss of governance over one\'s own destiny. If a man can\'t know if tomorrow will be better than today, then how is he to keep pushing forward? Just as you are about to address this, %determined% stands up and so despondent is the mood that even the swift motion by itself catches the company\'s attention.%SPEECH_ON%Look at you bunch of sorry sad sacks. Do you think you\'re unique? Do you think you\'re the first to feel like shit? No, of course not. You\'d not be the first to give up, either. To lay down and not rise again. That\'s the easy thing to do. That\'s what the world wants you to do. There\'s enough sonsabitches around, no need in having some sorry asses like yourselves mucking things up if you don\'t want no part and parcel in this punishment we call life.%SPEECH_OFF%Roused by this speech, you see a bit of a glint falling over the company.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The man is right!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Determined.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_58.png[/img]%determined% continues, almost stabbing his thumb into his chest.%SPEECH_ON%I\'m not taking the world\'s shit. I\'m gonna make the world sorry for having me here. I didn\'t ask for no invitation so I ain\'t gonna play nice to this farkin\' party. See you in the next life, men, but until then, let\'s dance in this one!%SPEECH_OFF%A cheer erupts and the men get to their feet, a sense of elation bursting forth as though the ground had them chained all along.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hear, hear!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Determined.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getMoodState() <= this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Inspired by " + _event.m.Determined.getNameOnly() + "\'s speech");

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
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getAverageMoodState() >= this.Const.MoodState.Concerned)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getSkills().hasSkill("trait.determined"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Determined = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"determined",
			this.m.Determined.getName()
		]);
	}

	function onClear()
	{
		this.m.Determined = null;
	}

});

