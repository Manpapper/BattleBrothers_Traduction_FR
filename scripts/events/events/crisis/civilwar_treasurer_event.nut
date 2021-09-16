this.civilwar_treasurer_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_treasurer";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_72.png[/img]While marching the lands, you come to find a farmer being accosted by a well-to-do looking man. Seeing you, the farmer quickly calls out.%SPEECH_ON%Sir, help me! This treasurer wants to take my crops!%SPEECH_OFF%The treasurer nods, seemingly as though there\'s no crime being committed here.%SPEECH_ON%That is correct. I\'ve been sent from %noblehouse% and I am here to collect food stores for the army. This is our land, and thus our crops.%SPEECH_OFF%The grind of war gets steadily worse... %randombrother% asks what you want to do.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Leave that farmer alone!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "This is none of our business.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Out of the way, both of you. This food is now ours!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_72.png[/img]Although morality has little play in the game of war, you can\'t help but think this poor farmer\'s done nothing wrong. You grab the treasurer by his shirt and press him against a farmhouse. His eyes go wide, as though you just pierced some veil of invincibility.%SPEECH_ON%Just what do you think you\'re doing?%SPEECH_OFF%You loosen your grab, because while this man may not be invincible, his name does have the backing of one.%SPEECH_ON%Tell your men that this farmer had nothing to offer. Crops were bad this season, got it?%SPEECH_OFF%You put one hand on the pommel of your sword. The man glances at it, then quickly nods.%SPEECH_ON%Alright, I got it.%SPEECH_OFF%The farmer thanks you from the bottom of his heart, and also a little by the bottom of his food stores, rewarding you with a few sacks of grains for your help.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "We did some good this day.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "You threatened one of their treasurers");
				this.World.Assets.addMoralReputation(1);
				local food = this.new("scripts/items/supplies/ground_grains_item");
				this.World.Assets.getStash().add(food);
				this.World.Assets.updateFood();
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.farmhand" && this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.25, "You helped a farmer in peril");

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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_72.png[/img]While you feel bad for the farmer, feelings aren\'t exactly worth much when there\'s a great war going on between the noble houses. You choose not to involve yourself. As the treasurer\'s daytalers carry sacks of grain onto a wagon, he comes over to talk.%SPEECH_ON%I\'ll tell the nobility of your, well, noble decision here. You could have caused a stir, but you did not. Thank you, mercenary. The men of our army needed this food more than you can know.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Oh well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "You respected the authority of one of their treasurers");
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_72.png[/img]Initially, it seemed as though there were two options here, but as a sellsword free from the bonds of nobility, responsibility, and well, any sort of social shackle, you choose a third angle: taking the food for you and your men. Both treasurer and farmer protest, but your men draw their blades, which is a quick way to silence any sort of debate.\n\n In total, there\'s really not that much to take and you get the ire of the common man as well as the nobility for the trouble.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "We gotta look out for ourselves first.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "You threatened one of their treasurers");
				this.World.Assets.addMoralReputation(-2);
				local maxfood = this.Math.rand(2, 3);

				for( local i = 0; i < maxfood; i = ++i )
				{
					local food = this.new("scripts/items/supplies/ground_grains_item");
					this.World.Assets.getStash().add(food);
					this.World.Assets.updateFood();
					this.List.push({
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "You gain " + food.getName()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
	}

});

