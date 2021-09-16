this.miner_fresh_air_event <- this.inherit("scripts/events/event", {
	m = {
		Miner = null
	},
	function create()
	{
		this.m.ID = "event.miner_fresh_air";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{%miner% the miner sucks in great gulps of breath and then lets them out in long, albeit a little wheezy exhales. He nods to himself as though satisfied by something everyone does. It seems some folks are easily pleased. But he does explain himself.%SPEECH_ON%You know I spent years in the dank and dark of the mines, breathing in the dust and the metals. I think being surface side this long has been a fortune of its own, a treasure I didn\'t know was out here for the taking. Thank you, captain, cause I wouldn\'t be here right now if it weren\'t for you.%SPEECH_OFF%You nod and thank him for the kind words.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "There\'s a fresh breeze coming from the sea.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Miner.getImagePath());
				_event.m.Miner.improveMood(1.0, "Happy to have a new life surface-side");

				if (_event.m.Miner.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Miner.getMoodState()],
						text = _event.m.Miner.getName() + this.Const.MoodStateEvent[_event.m.Miner.getMoodState()]
					});
				}

				local stamina = this.Math.rand(3, 6);
				_event.m.Miner.getBaseProperties().Stamina += stamina;
				_event.m.Miner.getSkills().update();
				_event.m.Miner.getFlags().add("fresh_air");
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Miner.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] Max Fatigue"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
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
			if (bro.getLevel() > 3 && bro.getBackground().getID() == "background.miner" && !bro.getFlags().has("fresh_air"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Miner = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"miner",
			this.m.Miner.getName()
		]);
	}

	function onClear()
	{
		this.m.Miner = null;
	}

});

