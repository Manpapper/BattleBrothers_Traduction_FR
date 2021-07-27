this.fish_caught_event <- this.inherit("scripts/events/event", {
	m = {
		Fisherman = null
	},
	function create()
	{
		this.m.ID = "event.hunt_food";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]{While stopped near a river of water, it appears %fisherman% went out to practice his old trade and netted a few fish! | You\'ve come to a body of water and stopped to talk to a few locals about the surrounding land. %fisherman% the once-fisherman took that opportunity to go catch a few salmon and other river-running critters. | While marching near a river, %fisherman% the once-fisherman managed to run along the banks and collect a bucketful of crawdads! Boiled in a pot, they make for some good eats.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s fish tonight!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fisherman.getImagePath());
				local food = this.new("scripts/items/supplies/dried_fish_item");
				this.World.Assets.getStash().add(food);
				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + food.getAmount() + "[/color] Fish"
					}
				];
				_event.m.Fisherman.improveMood(0.5, "Has caught some fish");

				if (_event.m.Fisherman.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Fisherman.getMoodState()],
						text = _event.m.Fisherman.getName() + this.Const.MoodStateEvent[_event.m.Fisherman.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Shore)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.fisherman")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Fisherman = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = candidates.len() * 15;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fisherman",
			this.m.Fisherman.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Fisherman = null;
	}

});

