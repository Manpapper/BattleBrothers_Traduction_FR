this.trader_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.trader_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_95.png[/img]The corpses are abuzz with flies and %ch1% stands amidst the swarm like he built the deathly totem which brought their presence. He turns to you.%SPEECH_ON%Greenskins did this one. No man can hew a head in half like that, and no sane man would stack them in such a manner. And there\'s goblin poison on them arrow tips.%SPEECH_OFF% %ch2% nods.%SPEECH_ON%Yesterday we find that merchant hanged by brigands, now this. The roads are getting too dangerous for a wagon carrying shine. Now, I ain\'t saying my swordhand ain\'t worth its weight in salt, but with just the two of us on duty we\'re throwing dice by the hour. Sir, you should look into hiring more guard.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ah, we\'ll be fine.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "We\'ll hire more guards and then some!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_95.png[/img]You shake your head.%SPEECH_ON%No. What we\'ll be doing is fighting back and then some. I aim to hire sellswords to fit a company of making, and if your swordhands want to earn a steady keep, you two can be the first.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Onwards, now, we have wares to sell!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_95.png[/img]You shake your head.%SPEECH_ON%We\'re hardly making a profit as is. I can\'t spare the coin to hire any more guards. Not unless we find a new profitable trade route, that is. And I aim to do just that!%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Onwards, now, we have wares to sell!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Trading Caravan";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"ch1",
			brothers[0].getName()
		]);
		_vars.push([
			"ch2",
			brothers[1].getName()
		]);
	}

	function onClear()
	{
	}

});

