this.fainthearted_is_shellshocked_event <- this.inherit("scripts/events/event", {
	m = {
		Rookie = null
	},
	function create()
	{
		this.m.ID = "event.fainthearted_is_shellshocked";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]Vous trouvez %fainthearted% penché en avant puis en arrière devant le feu de camp. Son visage est tacheté de sang séché et ses mains tremblent. Quelques frères d\'armes essaient de lui parler, mais aucun ne parvient à le faire parler. Il semble que l\'homme au cœur fragile ait été ébranlé par les horreurs d\'une récente et brutale bataille.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Laissez-le tranquille.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.worsenMood(1.5, "Choqué par les horreurs de la bataille");

				if (_event.m.Rookie.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 2)
		{
			return;
		}

		if (this.World.getTime().Days - fallen[0].Time > 1 || this.World.getTime().Days - fallen[1].Time > 1)
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
			if (bro.getLevel() <= 4 && bro.getSkills().hasSkill("trait.fainthearted") && bro.getPlaceInFormation() <= 17 && bro.getLifetimeStats().Battles >= 1)
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Rookie = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fainthearted",
			this.m.Rookie.getName()
		]);
	}

	function onClear()
	{
		this.m.Rookie = null;
	}

});

