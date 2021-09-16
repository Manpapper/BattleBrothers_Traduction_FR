this.dismiss_injured_event <- this.inherit("scripts/events/event", {
	m = {
		Fired = null
	},
	function setFired( _f )
	{
		this.m.Fired = _f;
	}

	function create()
	{
		this.m.ID = "event.dismiss_injured";
		this.m.Title = "Along the way...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]%dismissed%\'s injuries proved too much: the man didn\'t die, but in your mind he might as well have for he was no longer fit for combat. You let him go. While this may have been an altruistic move that spared the sellsword\'s life, the rest of the company doesn\'t see it the same way. All they see is that one injury is all it took for you to cut a man loose. Now they worry that if they get wounded you might do the same to them, like a selfish man ridding himself of a lame horse.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "They\'ll get over it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					if (bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury))
					{
						bro.worsenMood(1.5, "Afraid to be dismissed on account of his injury");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(this.Const.MoodChange.BrotherDismissed, "Lost confidence in the company\'s solidarity");

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
		if (this.World.Statistics.hasNews("dismiss_injured"))
		{
			this.m.Score = 2000;
		}

		return;
	}

	function onPrepare()
	{
		local news = this.World.Statistics.popNews("dismiss_injured");
		this.m.Fired = news.get("Name");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dismissed",
			this.m.Fired
		]);
	}

	function onClear()
	{
		this.m.Fired = null;
	}

});

