this.runaway_harem_event <- this.inherit("scripts/events/event", {
	m = {
		Citystate = null
	},
	function create()
	{
		this.m.ID = "event.runaway_harem";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_170.png[/img]{You come across a sparse group of nomads arguing with a troop of the Vizier\'s men. Between them is another group of what look like the sort of women that would be in the Vizier\'s harem. As you draw near all sides pause and stare at you. A lieutenant of the Vizier\'s troop waves you off.%SPEECH_ON%This does not concern you, Crownling.%SPEECH_OFF%But, perhaps trying to invite you into the event, the nomads explain: the women consist of \'indebted\', those whose service is owed to another for failures or transgressions. In this case, they owe services to the Vizier. However, they have escaped and the nomads, who find the concept of indebtedness to be heresy, have taken them in.%SPEECH_ON%Hey, Crownling! Don\'t listen to a word of that nomad\'s poison! And nomad, these women come with us, or you ALL die here.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'d rather not get involved in this.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "The women belong to the Vizier.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "The women are free to go wherever they choose.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_170.png[/img]{You draw your sword and tell the Vizier\'s men to get lost, hoping it works because any violence with them will not be without a good amount of bloodshed. Thankfully, they retreat. The lieutenant bows mockingly.%SPEECH_ON%The womenfolk are free, but with their debts to the Gilder left unpaid, they shall burn in pits of burning sand, a hell from which there will never be escape!%SPEECH_OFF%Laughing, you thank him for the imagery. The nomads also thank you, as do the freed harem though it\'s more with their eyes than anything. One nomad hands you a gift of treasures.%SPEECH_ON%We carry these not for us, but for when we occasion upon travelers such as yourself. We do not seek comforts in material things, not in this world. And do not trust that man of the Vizier. He lies. The Gilder shall see us all in sublimity when it is our time to come.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Enjoy your freedom.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addMoney(100);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] Crowns"
					}
				];
				_event.m.Citystate.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "You aided in the escape of a Vizier\'s harem");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_170.png[/img]{You know a good payday when you see one, and by payday you mean an ambassador of a Vizier. Drawing your sword, you jump between the nomads and the women, telling the former to back off and return to the deserts. The nomads draw bows and raise spears, but their leader quiets them.%SPEECH_ON%No, the interloper has intervened in a manner he finds most suitable, and certainly the Gilder has chosen him as an arbiter in this matter for good reason. Take the women, then, and the dispute is settled.%SPEECH_OFF%The Vizier\'s men gather the harem back into their ranks. A heavy bag is brought to you by the lieutenant.%SPEECH_ON%Payment, Crownling. This was not your task, but that does not mean it carries no reward. You have saved these indebted women from the Gilder\'s hellfire. May our generosity be a constant reminder going forward, yes?%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We look forward to further business with your master.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
				this.World.Assets.addMoney(150);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]150[/color] Crowns"
					}
				];
				_event.m.Citystate.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "You helped to return a Vizier\'s harem");
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_170.png[/img]{You shake your head and wish the women the best in the matter, but it\'s resolved before you can even leave: the nomads back off and the Vizier\'s men take them away. When you ask the nomads why they gave up so quick, their leader states that you must have been an arbitrator sent by the Gilder Himself, and if this is what you chose then so be it. Seems the nomads never had a chance at beating those professional soldiers and you were their last hope.}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s the way of things.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
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

		local towns = this.World.EntityManager.getSettlements();
		local bestTown;
		local bestDistance = 9000;

		foreach( t in towns )
		{
			local d = currentTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance < 7)
		{
			return;
		}

		this.m.Citystate = bestTown.getOwner();
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Citystate = null;
	}

});

