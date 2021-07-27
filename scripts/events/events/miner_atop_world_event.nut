this.miner_atop_world_event <- this.inherit("scripts/events/event", {
	m = {
		Miner = null
	},
	function create()
	{
		this.m.ID = "event.miner_atop_world";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_42.png[/img]The company marches into the mountains, or what %randombrother% poetically referred to as the \'realm\'s tits\'. Clouds start passing at eye-level and the air gets so thin it\'s like you\'re breathing through a straw. Snow crunches underfoot and harsh winds threaten to your eyes into ice cubes. Despite the steep escarpments and dangerous crevasses to cross, %miner% the miner seems rather happy to be this far up.%SPEECH_ON%It\'s like we\'re on top of the world! Isn\'t this wonderful?%SPEECH_OFF%He can hardly breathe for shit, but the miner is too happy to care. Years of digging deep into the earth has made this reversal of perspective all the more wonderful.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, at least someone is enjoying themselves.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Miner.getImagePath());
				_event.m.Miner.improveMood(2.0, "Enjoyed the view from atop a mountain");

				if (_event.m.Miner.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Miner.getMoodState()],
						text = _event.m.Miner.getName() + this.Const.MoodStateEvent[_event.m.Miner.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
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
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.miner")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Miner = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"miner",
			this.m.Miner.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Miner = null;
	}

});

