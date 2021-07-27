this.inadvertently_save_merchant_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.inadvertently_save_merchant";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 130.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%Walking about %townname% with a few sellswords, you turn a corner to find an opulent man surrounded by thieves and bandits. They look over their shoulders and widen their eyes. One nicks the merchant on the cheek.%SPEECH_ON%Alright, we\'ll get you next time ya bastard!%SPEECH_OFF%The scoundrels quickly make their leave. A moment later and the merchant\'s heavily-armed guards appear. Nursing his wound, he starts yelling at them.%SPEECH_ON%What am I paying you for you sorry bastards? The second I get into trouble and you\'re nowhere to be seen? Look at this man here, that\'s who I should be paying! Hey, take this for your troubles, stranger.%SPEECH_OFF%The merchant throws you a satchel of crowns for your \'trouble,\' though all you did was turn a corner and run into a coincidence.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Well, okay.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(25);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]25[/color] Crowns"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() <= 1 || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

