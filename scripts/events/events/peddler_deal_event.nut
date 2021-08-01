this.peddler_deal_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null
	},
	function create()
	{
		this.m.ID = "event.peddler_deal";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%peddler% comes to you, rubbing the back of his neck and nervously pulling on the front of his shirt. He proposes a plan wherein he goes into town with a handful of goods to peddle around, as he\'s done so often in the past.\n\nOnly problem is that he doesn\'t yet have the goods - he has to buy them from some local in the nearby hinterlands. All he needs now is a bit of money to get him started and help purchase the goods. A sum of 500 crowns all in all. Naturally, as a partner, you will get a cut of the profits once it\'s all said and done.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Count me in!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C";
					}

				},
				{
					Text = "You\'re a mercenary now. Time to leave that old life behind.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_04.png[/img]You hand %peddler% the crowns and off he goes.\n\nA few hours later, the peddler comes running up with a small lockbox in hand. The wily grin on his face is undeniable and he\'s unwittingly fistpumping as he glides to you. When he tries to speak, gasps of breath seize him. You hold your hand out, telling him to take his time. Settling down, the man hands over a heavy purse of coins, stating that it is your cut of the profits.\n\nBefore you can even say anything, the man wheels on his heels and jumps away, giddy with his success.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A pleasure to do business with you.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				local money = this.Math.rand(100, 400);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You earn [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
					}
				];
				_event.m.Peddler.getBaseProperties().Bravery += 1;
				_event.m.Peddler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Peddler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
				_event.m.Peddler.improveMood(2.0, "Made a profit peddling wares");

				if (_event.m.Peddler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peddler.getMoodState()],
						text = _event.m.Peddler.getName() + this.Const.MoodStateEvent[_event.m.Peddler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]%peddler% makes off and you tend to other business for the day.\n\nAs you step out of your tent hours later, you see a slumped shape in the distance, steadily heading your way. It appears to be the peddler. He carries nothing with him but a frown. As he gets closer, you begin to see the bruises that dot his body. He explains that while he managed to purchase the goods from his source, the actual townspeople weren\'t particularly warm to his selling tactics.\n\nWhat money was invested has been lost and %peddler% heads to a tent to nurse his wounds.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "But...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Crowns"
					}
				];
				_event.m.Peddler.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Peddler.getName() + " suffers light wounds"
				});
				_event.m.Peddler.worsenMood(2, "Failed in his plan and lost a large amount of money");

				if (_event.m.Peddler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peddler.getMoodState()],
						text = _event.m.Peddler.getName() + this.Const.MoodStateEvent[_event.m.Peddler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 1000)
		{
			return;
		}

		if (!this.World.State.isCampingAllowed())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 1)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Peddler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Peddler = null;
	}

});

