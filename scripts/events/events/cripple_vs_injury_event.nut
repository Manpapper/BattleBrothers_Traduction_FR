this.cripple_vs_injury_event <- this.inherit("scripts/events/event", {
	m = {
		Cripple = null,
		Injured = null
	},
	function create()
	{
		this.m.ID = "event.cripple_vs_injury";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]The recent battle left %injured% with a horrific and permanent injury. As he sits glumly about the campfire, %cripple% the cripple takes a seat next to him.%SPEECH_ON%So here you sit, bummed out about something that don\'t matter. Look at me. Just look at me! Look at where I am! I\'ve lost that which can\'t be returned, but did I dwell on it? No. I pressed on. I joined the %companyname%. Because that, that injury right there, that\'s gone and done. This up here...%SPEECH_OFF%The cripple taps the side of his head.%SPEECH_ON%Up here is what can be made anew. Up here is where you can think, yeah, that happened, but I\'m still a man and I\'m still in this. If the world wants me dead, it\'ll have to take all the pieces I got to give because I\'m not giving up until the last of me is gone!%SPEECH_OFF%%injured% nods and his mood already seems infinitely improved.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quite the spirit on that man.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cripple.getImagePath());
				this.Characters.push(_event.m.Injured.getImagePath());
				_event.m.Injured.improveMood(1.0, "Spirits lifted by " + _event.m.Cripple.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Injured.getMoodState()],
					text = _event.m.Injured.getName() + this.Const.MoodStateEvent[_event.m.Injured.getMoodState()]
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

		local cripple_candidates = [];
		local injured_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cripple")
			{
				cripple_candidates.push(bro);
			}
			else if (bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury))
			{
				foreach( n in bro.getMoodChanges() )
				{
					if (n.Text == "Suffered a permanent injury")
					{
						injured_candidates.push(bro);
						break;
					}
				}
			}
		}

		if (cripple_candidates.len() == 0 || injured_candidates.len() == 0)
		{
			return;
		}

		this.m.Cripple = cripple_candidates[this.Math.rand(0, cripple_candidates.len() - 1)];
		this.m.Injured = injured_candidates[this.Math.rand(0, injured_candidates.len() - 1)];
		this.m.Score = (cripple_candidates.len() + injured_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cripple",
			this.m.Cripple.getNameOnly()
		]);
		_vars.push([
			"injured",
			this.m.Injured.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cripple = null;
		this.m.Injured = null;
	}

});

