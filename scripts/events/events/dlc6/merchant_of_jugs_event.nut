this.merchant_of_jugs_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.merchant_of_jugs";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_171.png[/img]{A lone merchant approaches with a wagon pulled by a camel. Large jugs rattle against one another in the bed of his cart, with ropes of dried moss hanging between the lids of each one. He rears up on the camel and swings his legs to one side of the animal\'s withers, tapping his own boot with a jockey switch.%SPEECH_ON%Hello there, travelers, I pray that your road to the coin has been gilded well. Mine has, though I\'m afraid we have seemingly crossed paths at a time when my peculiar shines rank in rare number. I\'ve but a few goods left, all of the drinking sort. 50 crowns per jug. Interested?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll take all the jugs for 150 crowns.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "For 50 crowns, we\'ll just take one.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "We\'re good.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_171.png[/img]{You exchange for everything he\'s got to which the merchant happily obliges. When he leaves, his camels are barren and seem to have a skip in their step after carrying a load for so long. The drink in the jugs is a mixture of water and other additives which will ensure good, long lasting taste. A refreshing beverage to have in an otherwise hellish wasteland.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "How refreshing!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-150);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]150[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				for( local i = 0; i < 3; i = ++i )
				{
					foreach( bro in brothers )
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							bro.improveMood(1.0, "Had a most refreshing drink");

							if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_171.png[/img]{The merchant nods and you exchange crowns for one of the jugs. Despite only having a single jug of the drink, it will provide a refreshing respite from the hellish heat of the desert.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "How refreshing!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-50);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]50[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Had a most refreshing drink");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 150)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

