this.oathtaker_happy_with_company_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.oathtaker_happy_with_company";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{%oathtaker% l\'oathtaker vous rejoint près du feu de camp. Il hoche la tête.%SPEECH_ON%Avec tout le respect que je vous dois, capitaine, je peux dire que c\'est beaucoup demander que d\'exiger d\'un homme qu\'il soit d\'une réelle sincérité. Quand je vous ai connu, je ne pensais pas que vous aviez les couilles pour une telle aventure. Je pensais que la noirceur rampante de ce monde vous ferait dépérir, vous broierait comme du sable sur une pierre. Mais vous êtes là. Vaillant. Respectant les serments, l\'un après l\'autre. Tant mieux pour vous. Je pense que le jeune Anselm serait fier.%SPEECH_OFF%Vous remerciez l\'Oathtaker pour ses paroles chaleureuses.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Heureux que quelqu\'un le reconnaisse.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				_event.m.Oathtaker.getBaseProperties().Bravery += 2;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Oathtaker.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Resolve"
				});
				_event.m.Oathtaker.improveMood(1.0, "Is happy about the company\'s moral compass");

				if (_event.m.Oathtaker.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Assets.getMoralReputation() < 80.0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local oathtaker_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin" && bro.getLevel() >= 5)
			{
				oathtaker_candidates.push(bro);
			}
		}

		if (oathtaker_candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = oathtaker_candidates[this.Math.rand(0, oathtaker_candidates.len() - 1)];
		this.m.Score = 5 * oathtaker_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
	}

});

