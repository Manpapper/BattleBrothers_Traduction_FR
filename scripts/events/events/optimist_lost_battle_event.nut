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
			Text = "[img]gfx/ui/events/event_88.png[/img]Malgré une récente défaite, %optimist% voit toujours un brillant avenir pour %companyname%. %SPEECH_ON% La vie ne peut pas toujours être passée debout, les gars. Parfois, il faut la passer à se relever. Mais on ne la passera jamais à se coucher pour toujours, ça je le sais ! Cette compagnie est trop bonne pour toutes ces conneries.%SPEECH_OFF% L\'optimisme sans faille du mercenaire déteint sur certains des hommes, leur remontant le moral et les laissant prêts pour les jours à venir.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un homme avec qui se battre.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Optimist.getImagePath());
				_event.m.Optimist.improveMood(0.5, "Est optimiste malgré un récent revers");

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
						bro.improveMood(0.5, "Rallié par l\'optimisme de " + _event.m.Optimist.getName());

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

