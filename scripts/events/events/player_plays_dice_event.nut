this.player_plays_dice_event <- this.inherit("scripts/events/event", {
	m = {
		Gambler = null,
		PlayerDice = 0,
		GamblerDice = 0
	},
	function create()
	{
		this.m.ID = "event.player_plays_dice";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_62.png[/img]While relaxing after the day\'s walk, %gambler% comes up to you with a pair of dice and a cup in hand. He asks if you wish to have a little game. The rules are quite simple: you roll the dice from the cup, whoever has the highest numbers wins. It\'s pure chance! The wager will be twenty-five crowns per dice roll.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s play!",
					function getResult( _event )
					{
						_event.m.Gambler.improveMood(1.0, "Has played a game of dice with you");
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "I have no time for this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_62.png[/img]You roll the dice, landing a total of %playerdice%.\n\n%gambler% goes next, rolling a total of %gamblerdice%.\n\n{Well, you lost. The gambler snatches the dice back up - as well as your twenty-five crowns - and aks if you wish to have another go. | The dice were not in your favor and the gambler takes his earnings. He looks up to you, grinning.%SPEECH_ON%Wish to have another go?%SPEECH_OFF% | The numbers are counted up and, alas, you have lost. The gambler asks if you wish to go again. | Lost! But maybe if you roll again... | You lose! A simple roll of the dice, and simple loss. But this one hurts a lot less than which you\'ve seen on the fields of battle. The gambler asks if you wish to have another go. | The gods have shunned you and your silly dice. Losing the game is a minor setback, but your pride costs a little more than twenty-five crowns. Should you roll again? | The odds have betrayed you for a measly twenty crowns. Maybe if you roll again you can win them back? | You watch your dice tumble, seeing for but a moment the winning numbers before it tilts and falls to another side, revealing a losing total. The gambler laughs and asks if you wish to throw again. | Your throw was perfect! How could you lose? He needed just those numbers to win! Shaking your head, you wonder if you should roll again.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s roll again!",
					function getResult( _event )
					{
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "I\'ve had enough for today.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
				this.World.Assets.addMoney(-25);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]25[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_62.png[/img]You roll the dice, landing a total of %playerdice%.\n\n%gambler% goes next, rolling a total of %gamblerdice%.\n\n{You won! The gambler claps his hands.%SPEECH_ON%Beginner\'s luck!%SPEECH_OFF%You cross your arms.%SPEECH_ON%I thought it was all luck?%SPEECH_OFF%The gambler laughs and asks if you wish to test that theory. | The gambler leans back.%SPEECH_ON%Well I\'ll be damned. Let\'s throw again!%SPEECH_OFF% | The gambler leans back.%SPEECH_ON%{Well I\'ll be a horse\'s fartin\' arse | I\'ll be damned if the gods haven\'t turned their backs on me | Now that right there is a poor showin\' of lady luck | I\'d bedded a lady by the name of Luck, what good it\'s done me though | That right there is a misfortune, for me that is | Oy, that\'s a winning roll | I\'ll be a ragamuffin | Son of a gelded horse | Shits on a wet a pig | As damned as a nun on her back | The throw of a master I say | Yer a robber with such a throw and yeah | May %randomtown% join the orcs | And they say a blind squirrel can\'t find a nut | Tickle m\'anus with a rosebush and call me Sally Siegfried}, ya won! Let\'s roll again!%SPEECH_OFF% | You\'ve won! Laughing, you take your earnings and the gambler asks if you wish to have another throw.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s roll again!",
					function getResult( _event )
					{
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "I\'ve had enough for today.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
				this.World.Assets.addMoney(25);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You win [color=" + this.Const.UI.Color.PositiveEventValue + "]25[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_62.png[/img]You roll the dice, landing a total of %playerdice%.\n\n%gambler% goes next, rolling a total of %gamblerdice%.\n\nThe numbers are the same. A tie! Roll again?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s roll again!",
					function getResult( _event )
					{
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "I\'ve had enough for today.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() <= 100)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gambler" || bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.thief" || bro.getBackground().getID() == "background.raider")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Gambler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gambler",
			this.m.Gambler.getName()
		]);
		_vars.push([
			"playerdice",
			this.m.PlayerDice
		]);
		_vars.push([
			"gamblerdice",
			this.m.GamblerDice
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Gambler = null;
		this.m.PlayerDice = 0;
		this.m.GamblerDice = 0;
	}

});

