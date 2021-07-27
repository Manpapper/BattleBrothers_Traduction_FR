this.caravan_hand_cart_event <- this.inherit("scripts/events/event", {
	m = {
		CaravanHand = null
	},
	function create()
	{
		this.m.ID = "event.caravan_hand_cart";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_55.png[/img]You come across the once-caravan hand, %caravanhand%, finicking with the company wagon. He\'s nailing a slat of board to the bed and using pins to put it on a roller. The board can then drop down into the belly of the wagon with a little bit of a pull and switch. Rather ingenious. This will allow you to load more onto the wagon.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nicely done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.CaravanHand.getImagePath());
				this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 9);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "You gain inventory space"
				});
				_event.m.CaravanHand.improveMood(1.0, "Improved the company\'s cart");

				if (_event.m.CaravanHand.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.CaravanHand.getMoodState()],
						text = _event.m.CaravanHand.getName() + this.Const.MoodStateEvent[_event.m.CaravanHand.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.Ambitions.getAmbition("ambition.cart").isDone() && this.World.Retinue.getInventoryUpgrades() == 0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.caravan_hand")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.CaravanHand = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"caravanhand",
			this.m.CaravanHand.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.CaravanHand = null;
	}

});

