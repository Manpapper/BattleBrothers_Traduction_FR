this.mason_vs_thief_event <- this.inherit("scripts/events/event", {
	m = {
		Mason = null,
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.mason_vs_thief";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%mason% the mason is stoking the campfire with %thief% standing nearby. The thief is mulling a question over.%SPEECH_ON%Hmm, what was the hardest to break into? Well, vaults were the easiest, let\'s get that out of the way first. I once stole so much from a vault that they tried to hang the locksmith for being so easily defeated by a common thief. They couldn\'t find the locksmith, for you see I\'m no common thief, for the locksmith was me. Ha-ha! To answer your question, a tower is the hardest to break into, especially a tower standing alone.%SPEECH_OFF%Sitting back on his laurels, the mason nods.%SPEECH_ON%Aye, thought you might say so. Towers be built for prisoners of import or items of peculiar fancy. Little more than cages in the sky for creatures with no wings. But one time, a prisoner, some notorious fish thief, did manage an escape. He spent years upon years pulling out strands of his own hair and tying them together until the \'rope\' was long enough for him to throw it out and climb down. They caught him a day later, unfortunately. He did the same trick again a few years later, but that time he roped it half-as-long and simply hanged himself instead.%SPEECH_OFF%%thief% laughs.%SPEECH_ON%That\'s interesting and all, but I\'m a true thief, mason, not a mere robber of fishmongers. My question is how do I get -into- the tower.%SPEECH_OFF%The mason nods.%SPEECH_ON%Simple. Commit a... herring offense.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What a harangue.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Mason.getImagePath());
				this.Characters.push(_event.m.Thief.getImagePath());
				_event.m.Mason.improveMood(1.0, "Bonded with " + _event.m.Thief.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Mason.getMoodState()],
					text = _event.m.Mason.getName() + this.Const.MoodStateEvent[_event.m.Mason.getMoodState()]
				});
				_event.m.Thief.improveMood(1.0, "Bonded with " + _event.m.Mason.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Thief.getMoodState()],
					text = _event.m.Thief.getName() + this.Const.MoodStateEvent[_event.m.Thief.getMoodState()]
				});
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

		local mason_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.mason")
			{
				mason_candidates.push(bro);
				break;
			}
		}

		if (mason_candidates.len() == 0)
		{
			return;
		}

		local thief_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.thief")
			{
				thief_candidates.push(bro);
			}
		}

		if (thief_candidates.len() == 0)
		{
			return;
		}

		this.m.Mason = mason_candidates[this.Math.rand(0, mason_candidates.len() - 1)];
		this.m.Thief = thief_candidates[this.Math.rand(0, thief_candidates.len() - 1)];
		this.m.Score = (mason_candidates.len() + thief_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"mason",
			this.m.Mason.getNameOnly()
		]);
		_vars.push([
			"thief",
			this.m.Thief.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Mason = null;
		this.m.Thief = null;
	}

});

