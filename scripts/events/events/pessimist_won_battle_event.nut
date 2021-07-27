this.pessimist_won_battle_event <- this.inherit("scripts/events/event", {
	m = {
		Pessimist = null
	},
	function create()
	{
		this.m.ID = "event.pessimist_won_battle";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]Ever the downer, %pessimist% mopes around, wallowing in victory as good as any pissy pessimist could. He throws a dismissive hand out.%SPEECH_ON%We have tasted victory and what of it? Our victory was their defeat, so it very well may be that one day someone else\'s victory is going to come at our expense, don\'t you see? Let us not put the cart in front of the horse lest the shadows of morrow sneak upon us whilst we bask in this supposedly glorious light.%SPEECH_OFF%A few sellswords tell him to stop being such a prick, but his brunt realism tempers the zeal of others.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The worst part about pessimists is that they\'re usually right.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Pessimist.getImagePath());
				_event.m.Pessimist.worsenMood(0.5, "Is pessimistic despite a recent victory");

				if (_event.m.Pessimist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Pessimist.getMoodState()],
						text = _event.m.Pessimist.getName() + this.Const.MoodStateEvent[_event.m.Pessimist.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Pessimist.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50 && !bro.getSkills().hasSkill("trait.optimist"))
					{
						bro.worsenMood(0.4, "Tempered by " + _event.m.Pessimist.getName() + "\'s pessimism");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
		if (this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1)
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 20.0)
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
			if (bro.getSkills().hasSkill("trait.pessimist") && !bro.getSkills().hasSkill("trait.dumb") && bro.getBackground().getID() != "background.slave" && bro.getLifetimeStats().Battles >= 1)
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Pessimist = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"pessimist",
			this.m.Pessimist.getName()
		]);
	}

	function onClear()
	{
		this.m.Pessimist = null;
	}

});

