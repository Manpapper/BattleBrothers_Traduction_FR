this.running_around_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.running_around";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Walking, running, fighting, fucking, all good for a man\'s heart. The time spent traveling the land has improved the vitality and vigor of the men. You even caught one of the cheekier mercenaries flexing into pondwater, admiring his own reflection like some smirkin\' wench. | All this running about the land has increased the stamina of the men. One runs in place, holding a finger to his neck. He remarks that his heart rate isn\'t going up at all. Another brother remarks that the guy doesn\'t even know how to count. The running man pauses.%SPEECH_ON%Oh. That\'s right.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s all worth it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bro = _event.m.Dude;
				this.Characters.push(bro.getImagePath());
				local stamina = this.Math.rand(1, 1);
				bro.getBaseProperties().Stamina += stamina;
				bro.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] Max Fatigue"
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
		this.m.Dude = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

