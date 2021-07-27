this.farmer_vs_butcher_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null,
		Farmer = null
	},
	function create()
	{
		this.m.ID = "event.farmer_vs_butcher";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]You find %farmhand% and %butcher% arguing with one another over a piece of meat. The farmhand raises his voice.%SPEECH_ON%The best meat is from the shoulder. That\'s why you cut it off first! And you cut it like this, NOT like this you idiot.%SPEECH_OFF%Also raising his voice, and clenching a fist at his side, the butcher shakes his head.%SPEECH_ON%Why do you even question me? I\'m a farkin\' butcher, yer a pithy peasant! I did this for a living, you did it because you killed a cow grabbing its udder a little too hard, no doubt mistaking it for yer father\'s cock!%SPEECH_OFF%The fighting words kick off a scuffle. Someone gets slashed, someone else\'s nose cratered. The men are separated, but not before the damage is done.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'re both mercenaries now!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				this.Characters.push(_event.m.Farmer.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Butcher.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Butcher.getName() + " suffers " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Butcher.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Butcher.getName() + " suffers light wounds"
					});
				}

				_event.m.Butcher.worsenMood(0.5, "Got in a brawl with " + _event.m.Farmer.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
					text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Farmer.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Farmer.getName() + " suffers " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Farmer.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Farmer.getName() + " suffers light wounds"
					});
				}

				_event.m.Farmer.worsenMood(0.5, "Got in a brawl with " + _event.m.Butcher.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Farmer.getMoodState()],
					text = _event.m.Farmer.getName() + this.Const.MoodStateEvent[_event.m.Farmer.getMoodState()]
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

		local butcher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.butcher")
			{
				butcher_candidates.push(bro);
				break;
			}
		}

		if (butcher_candidates.len() == 0)
		{
			return;
		}

		local farmer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.farmhand")
			{
				farmer_candidates.push(bro);
			}
		}

		if (farmer_candidates.len() == 0)
		{
			return;
		}

		this.m.Butcher = butcher_candidates[this.Math.rand(0, butcher_candidates.len() - 1)];
		this.m.Farmer = farmer_candidates[this.Math.rand(0, farmer_candidates.len() - 1)];
		this.m.Score = (butcher_candidates.len() + farmer_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"farmhand",
			this.m.Farmer.getNameOnly()
		]);
		_vars.push([
			"butcher",
			this.m.Butcher.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Farmer = null;
		this.m.Butcher = null;
	}

});

