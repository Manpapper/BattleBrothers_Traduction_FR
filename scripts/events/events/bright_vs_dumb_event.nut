this.bright_vs_dumb_event <- this.inherit("scripts/events/event", {
	m = {
		Dumb = null,
		Bright = null
	},
	function create()
	{
		this.m.ID = "event.bright_vs_dumb";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_15.png[/img]%dumb% is perhaps one of the dumbest individuals you\'ve ever met but, for a brief moment, it does appear that %bright% gets through and teaches him a thing or two about critical thinking and memorization. You watch as the two sit together and look over some scrolls. You\'re not sure where the smart man got such papers, but the unlearning oaf is certainly paying a lot of attention to them.\n\nAs you watch, %dumb% is asking rather deep, profound questions. Questions about the land and its relationship to people, and the sky and its relationship to the birds. You slowly realize the idiot is merely glancing around and describing what he\'s seeing in the sort of \'inquisitive\' language %bright% has taught him - namely by attaching a smarmily-intoned question to the end of every sentence. When the two finish up, %bright% comes to you with a grin.%SPEECH_ON%I think we\'re really getting somewhere with him. He\'s learning, you know? With students like that, all you gotta do is be patient and take your time.%SPEECH_OFF%A little ways away, %dumb% is pounding ants with a rock. You simply nod and let %bright% live out every teacher\'s biggest fantasy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You finally reached him.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bright.getImagePath());
				this.Characters.push(_event.m.Dumb.getImagePath());
				_event.m.Bright.improveMood(1.0, "Taught " + _event.m.Dumb.getName() + " quelque chose");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Bright.getMoodState()],
					text = _event.m.Bright.getName() + this.Const.MoodStateEvent[_event.m.Bright.getMoodState()]
				});
				_event.m.Dumb.improveMood(1.0, "Bonded with " + _event.m.Bright.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Dumb.getMoodState()],
					text = _event.m.Dumb.getName() + this.Const.MoodStateEvent[_event.m.Dumb.getMoodState()]
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

		local dumb_candidates = [];
		local bright_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.dumb"))
			{
				dumb_candidates.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.bright"))
			{
				bright_candidates.push(bro);
			}
		}

		if (dumb_candidates.len() == 0 || bright_candidates.len() == 0)
		{
			return;
		}

		this.m.Dumb = dumb_candidates[this.Math.rand(0, dumb_candidates.len() - 1)];
		this.m.Bright = bright_candidates[this.Math.rand(0, bright_candidates.len() - 1)];
		this.m.Score = (dumb_candidates.len() + bright_candidates.len()) * 2;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dumb",
			this.m.Dumb.getName()
		]);
		_vars.push([
			"dumb_short",
			this.m.Dumb.getNameOnly()
		]);
		_vars.push([
			"bright",
			this.m.Bright.getName()
		]);
		_vars.push([
			"bright_short",
			this.m.Bright.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dumb = null;
		this.m.Bright = null;
	}

});

