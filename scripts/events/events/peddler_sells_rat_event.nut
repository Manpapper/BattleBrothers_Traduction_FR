this.peddler_sells_rat_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null,
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.peddler_sells_rat";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%SPEECH_ON%For the last time, no, I won\'t buy a rat.%SPEECH_OFF%You see %ratcatcher% the ratcatcher turn a corner with the skeevy peddler %peddler% on his heels. The salesman throws another pitch.%SPEECH_ON%\'Course you won\'t buy one! You\'re a ratcatcher, why would you buy one? But what if...%SPEECH_OFF%The ratcatcher stops and turns on his heels, planting a firm finger into the peddler\'s chest.%SPEECH_ON%Pet rats don\'t go grow on trees, %peddler%! They\'re born of a different stock! If I need a rat by my side I\'ll find him myself! Now, if you got a rat you need killin\', that\'s a different matter.%SPEECH_OFF%%peddler%\'s eyes fall to the ground, thinking for a moment. Suddenly, his gaze lifts along with his spirits and a pointing finger.%SPEECH_ON%Ah, a goldfish then? Would you buy a goldfish?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Everything in order here.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
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

		local candidates_peddler = [];
		local candidates_ratcatcher = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates_peddler.push(bro);
			}
			else if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates_ratcatcher.push(bro);
			}
		}

		if (candidates_peddler.len() == 0 || candidates_ratcatcher.len() == 0)
		{
			return;
		}

		this.m.Peddler = candidates_peddler[this.Math.rand(0, candidates_peddler.len() - 1)];
		this.m.Ratcatcher = candidates_ratcatcher[this.Math.rand(0, candidates_ratcatcher.len() - 1)];
		this.m.Score = candidates_peddler.len() * candidates_ratcatcher.len() * 3 * 50000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler.getName()
		]);
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Peddler = null;
		this.m.Ratcatcher = null;
	}

});

