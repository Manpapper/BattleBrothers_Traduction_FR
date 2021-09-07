this.retired_soldier_tale_event <- this.inherit("scripts/events/event", {
	m = {
		Soldier = null
	},
	function create()
	{
		this.m.ID = "event.retired_soldier_tale";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%retiredsoldier% est assis autour du feu de camp à raconter des histoires de guerre. S\'il ment, c\'est simplement pour embellir les choses, car les cicatrices sur son corps disent des vérités inesthétiques. Avec chaque histoire, les hommes deviennent plus captivés, enhardis et prêts à retourner sur le terrain et à forger leurs propres histoires.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tuer des hommes, ça fait de belles histoires autour d\'un feu de camp.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Soldier.getImagePath());
				_event.m.Soldier.improveMood(0.25, "A raconté une de ses histoires de guerre");

				if (_event.m.Soldier.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Soldier.getMoodState()],
						text = _event.m.Soldier.getName() + this.Const.MoodStateEvent[_event.m.Soldier.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Soldier.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "S\'est senti encouragé par les histoires de guerre de " + _event.m.Soldier.getName());

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
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.retired_soldier")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Soldier = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"retiredsoldier",
			this.m.Soldier.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Soldier = null;
	}

});

