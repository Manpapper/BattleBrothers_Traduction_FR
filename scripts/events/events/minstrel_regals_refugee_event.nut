this.minstrel_regals_refugee_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Refugee = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_regals_refugee";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img] La compagnie est assise autour du feu lorsque %minstrel% le ménestrel remarque le réfugié, %refugee%, assis tout seul. En un instant, le ménestrel est sur pied, debout sur une souche, et agite les bras en tous sens.%SPEECH_ON%La ville de %refugee% était petite, son lieu pittoresque, et sa nourriture, eh bien, un peu du côté \'bof\'. Mais bon ! Ses habitants étaient grands ! Car ici est assis parmi notre compagnie l\'un de ses membres, le monde est après son esprit, la mort est sur ses talons, et pourtant il est là, et nous n\'avons que des remerciements - et des couronnes ! - à lui offrir ! Tel est le prix de sa compagnie, et nous sommes prêts à le donner.%SPEECH_OFF%Le ménestrel se rassoit et s\'incline devant le réfugié. Tous les membres de %companyname% se lèvent et applaudissent, apportant un rare sourire sur le visage de %refugee%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bravo!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());
				_event.m.Refugee.improveMood(1.0, "A été réconforté par " + _event.m.Minstrel.getName());

				if (_event.m.Refugee.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
						text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
					});
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

		local candidates_minstrel = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(bro);
			}
		}

		if (candidates_minstrel.len() == 0)
		{
			return;
		}

		local candidates_refugee = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.refugee")
			{
				candidates_refugee.push(bro);
			}
		}

		if (candidates_refugee.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.Refugee = candidates_refugee[this.Math.rand(0, candidates_refugee.len() - 1)];
		this.m.Score = (candidates_minstrel.len() + candidates_refugee.len()) * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel.getNameOnly()
		]);
		_vars.push([
			"refugee",
			this.m.Refugee.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.Refugee = null;
	}

});

