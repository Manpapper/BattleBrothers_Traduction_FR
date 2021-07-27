this.graverobber_vs_gravedigger_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Gravedigger = null
	},
	function create()
	{
		this.m.ID = "event.graverobber_vs_gravedigger";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_28.png[/img]After burying a dead comrade, %gravedigger% pitches his shovel into the earth and grabs %graverobber% by his tunic, driving him backward as he lifts him into the air. Before even a word or threat can be exchanged, the dangling man throws a kick into his attacker\'s groin. They both fall to the ground and immediately start tumbling about in the mud. The muck makes them indistinguishable, but their fit of anger is well heard.\n\nThe gravedigger climbs on top of the graverobber and starts piling mud into his opponent\'s face.%SPEECH_ON%What\'d I tell ya, huh? What\'d I say about thievin\' from those who can\'t see your grimy little hands comin\', huh?%SPEECH_OFF%With a nice little reversal that suggests this isn\'t his first time wrestling in the mud, the graverobber throws his assailant off and clambers atop him. He grabs great big piles of grass and grime and shoves it into the gravedigger\'s face. Bizarrely, the graverobber thinks it\'s time to make his case.%SPEECH_ON%It only be his shoes! It only be his gloves! Dead needn\'t be walkin\' or pickin\' things up, let \'em be mine I say!%SPEECH_OFF% Ah, it appears that the gravedigger and graverobber have come across a mild difference on what goes into the ground and what shant come back out. You let them work through their troubles - there is little harm to be done between the two of them and it is making good entertainment for the rest of the company, anyway.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Just don\'t fall into the grave.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				this.Characters.push(_event.m.Gravedigger.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
				}
				else
				{
					_event.m.Graverobber.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Graverobber.getName() + " suffers light wounds"
					});
				}

				_event.m.Graverobber.worsenMood(0.5, "Got in a brawl with " + _event.m.Gravedigger.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
				}
				else
				{
					_event.m.Gravedigger.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Gravedigger.getName() + " suffers light wounds"
					});
				}

				_event.m.Gravedigger.worsenMood(0.5, "Got in a brawl with " + _event.m.Graverobber.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Gravedigger.getMoodState()],
					text = _event.m.Gravedigger.getName() + this.Const.MoodStateEvent[_event.m.Gravedigger.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 1 || fallen[0].Time != this.World.getTime().Days)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_graverobber = [];
		local candidates_gravedigger = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				candidates_graverobber.push(bro);
			}
			else if (bro.getBackground().getID() == "background.gravedigger")
			{
				candidates_gravedigger.push(bro);
			}
		}

		if (candidates_graverobber.len() == 0 || candidates_gravedigger.len() == 0)
		{
			return;
		}

		this.m.Graverobber = candidates_graverobber[this.Math.rand(0, candidates_graverobber.len() - 1)];
		this.m.Gravedigger = candidates_gravedigger[this.Math.rand(0, candidates_gravedigger.len() - 1)];
		this.m.Score = 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"graverobber",
			this.m.Graverobber.getName()
		]);
		_vars.push([
			"gravedigger",
			this.m.Gravedigger.getName()
		]);
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Gravedigger = null;
	}

});

