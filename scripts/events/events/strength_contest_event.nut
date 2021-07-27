this.strength_contest_event <- this.inherit("scripts/events/event", {
	m = {
		Strong1 = null,
		Strong2 = null
	},
	function create()
	{
		this.m.ID = "event.strength_contest";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] %strong1% and %strong2% - the strongest men in the outfit by some measure - are apparently undertaking something of a competition to see who is the better. You watch as they carry enormous stones from one side of an ad hoc competitive ground to the other. Then they take turns seeing how far they can throw these very stones. And then they roll the stones up a nearby hill. And then they see who can completely bury a stone the fastest.\n\nAll in all, there are a lot of heavy stones being jostled about and by the end of the festive affair both men are completely exhausted. Even without a winner, the time-honored tradition of moving rocks around to no real end has improved the men\'s morale.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We are but simple creatures.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Strong1.getImagePath());
				this.Characters.push(_event.m.Strong2.getImagePath());
				_event.m.Strong1.getFlags().increment("ParticipatedInStrengthContests", 1);
				_event.m.Strong2.getFlags().increment("ParticipatedInStrengthContests", 1);
				_event.m.Strong1.getBaseProperties().Stamina += 1;
				_event.m.Strong1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Strong1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Max Fatigue"
				});
				_event.m.Strong2.getBaseProperties().Stamina += 1;
				_event.m.Strong2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Strong2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Max Fatigue"
				});
				_event.m.Strong1.improveMood(1.0, "Bonded with " + _event.m.Strong2.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Strong1.getMoodState()],
					text = _event.m.Strong1.getName() + this.Const.MoodStateEvent[_event.m.Strong1.getMoodState()]
				});
				_event.m.Strong2.improveMood(1.0, "Bonded with " + _event.m.Strong1.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Strong2.getMoodState()],
					text = _event.m.Strong2.getName() + this.Const.MoodStateEvent[_event.m.Strong2.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.strong") && !bro.getSkills().hasSkill("trait.bright"))
			{
				if (!bro.getFlags().has("ParticipatedInStrengthContests") || bro.getFlags().get("ParticipatedInStrengthContests") < 2)
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Strong1 = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Strong2 = null;
		this.m.Score = candidates.len() * 5;

		do
		{
			this.m.Strong2 = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		while (this.m.Strong2 == null || this.m.Strong2.getID() == this.m.Strong1.getID());
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"strong1",
			this.m.Strong1.getName()
		]);
		_vars.push([
			"strong2",
			this.m.Strong2.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Strong1 = null;
		this.m.Strong2 = null;
	}

});

