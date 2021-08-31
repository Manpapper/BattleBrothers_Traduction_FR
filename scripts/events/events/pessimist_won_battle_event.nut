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
			Text = "[img]gfx/ui/events/event_64.png[/img]Toujours aussi déprimant, %pessimist% se morfond, se complaisant dans la victoire aussi bien que n\'importe quel pessimiste. Il jette une main dédaigneuse.%SPEECH_ON% Nous avons goûté à la victoire et qu\'en est-il ? Notre victoire a été leur défaite, alors il se peut très bien qu\'un jour la victoire de quelqu\'un d\'autre se fasse à nos dépens, ne voyez-vous pas ? Ne mettons pas la charrue devant les bœufs, de peur que les ombres du lendemain ne nous surprennent pendant que nous nous prélassons dans cette lumière soi-disant glorieuse.%SPEECH_OFF% Quelques mercenaires lui disent d\'arrêter de faire le con, mais son réalisme brutal tempère le zèle des autres.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le pire avec les pessimistes, c\'est qu\'ils ont souvent raison.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Pessimist.getImagePath());
				_event.m.Pessimist.worsenMood(0.5, "Est pessimiste malgré une récente victoire");

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
						bro.worsenMood(0.4, "Tempéré par le pessimiste de " + _event.m.Pessimist.getName());

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

