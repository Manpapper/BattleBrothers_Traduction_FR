this.optimist_lost_battle_event <- this.inherit("scripts/events/event", {
	m = {
		Optimist = null
	},
	function create()
	{
		this.m.ID = "event.optimist_lost_battle";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_88.png[/img]Despite a recent defeat, %optimist% still sees a bright future for the %companyname%.%SPEECH_ON%Not all of life can be spent standin\', fellas. Sometimes it\'s gotta be spent getting\' back up. But we\'ll never spend it layin\' down forever, I know that much! This company\'s too good for that lollygaggin\' shite.%SPEECH_OFF%The ever optimistic sellsword\'s relentless positivity rubs off on some of the men, raising their spirits and leaving them ready for the tomorrows to come.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A man to go down fighting with.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Optimist.getImagePath());
				_event.m.Optimist.improveMood(0.5, "Is optimistic despite a recent setback");

				if (_event.m.Optimist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Optimist.getMoodState()],
						text = _event.m.Optimist.getName() + this.Const.MoodStateEvent[_event.m.Optimist.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Optimist.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50 && !bro.getSkills().hasSkill("trait.pessimist"))
					{
						bro.improveMood(0.5, "Rallied by " + _event.m.Optimist.getName() + "\'s optimism");

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
		if (this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 2)
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
			if (bro.getSkills().hasSkill("trait.optimist") && bro.getBackground().getID() != "background.slave" && bro.getLifetimeStats().Battles >= 1)
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Optimist = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"optimist",
			this.m.Optimist.getName()
		]);
	}

	function onClear()
	{
		this.m.Optimist = null;
	}

});

