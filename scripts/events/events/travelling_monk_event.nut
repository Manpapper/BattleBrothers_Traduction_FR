this.travelling_monk_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.travelling_monk";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A1",
			Text = "[img]gfx/ui/events/event_40.png[/img]You meet a monk on the roads and with him is a donkey-pulled cart, the poor draught animal carrying its head low in mute exhaustion. Broomstraw and virid moss are strung up to one side of the cart, both twisting eagerly in the very winds that dried them, and some pots and pans clatter like rustic windchimes as the modest wares come to a bumbling stop. A barrel totters on the edge of the cart\'s bed and a couple of bees sway to keep up, poking and prodding at its cracks with thirsty curiosity.\n\nThe monk lifts a wool hat up out of his face but the lip of it folds back down over his eyes. He takes it off altogether and passes a sleeve across his brow. Carrying a jolly smile, he seems not at all disturbed by the veritable living armory standing before him.%SPEECH_ON%Evening gents. Don\'t s\'pose yer the kind to march b\'neath a lord\'s banner. Y\'look like sellswords t\'me.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "What is it you carry?",
					function getResult( _event )
					{
						return "A2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_40.png[/img]%SPEECH_ON%Aye, I was thinkin\' you\'d ask. This here is Bessie, a cow\'s name for a donkey\'s arse. Don\'t worry, she won\'t kick ye. She\'s all hawed-out, see? What she carry, well, that\'s beer. For men yonder, so that they may drink to men above. If ye don\'t mind, or if ye don\'t mind m\'business, I\'d like to get on where I be going.%SPEECH_OFF%The monk picks up the reins of his jenny as he readies to start moving.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "How many crowns for a round of beer?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "D";
					}

				},
				{
					Text = "We earned this by keeping the roads safe - take the beer, men!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_40.png[/img]You hold your hand up, stopping the monk before he can get going again. He sighs, slowly lowering the reins out of his hand. Feeling as though he may be getting the wrong impression, you quickly ask if maybe he has beer to spare for your men. You are more than willing to pay. The monk looks back at his stock for a moment, then turns around.%SPEECH_ON%Aye. I give yer men a sip for a crown or two. Don\'t mind the bees \'round the top, they\'ll scurry when you come, but if you scurry when they scurry, they\'ll scurry after ya. Strange little gits.%SPEECH_OFF%You ask the man how much he wants.%SPEECH_ON%I\'d wager ten crowns a head will do. I\'m no business man, though, I might be takin\' advantage of m\'self here.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A round for the whole company!",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "You ask too much.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_40.png[/img]You agree to pay the man what he\'s asked for and he opens his arm in invitation. Your men pop the lid off the cask and dip their cups in. They come to sit in the shade, sipping tankards and exchanging beers. The monk bids you a good farewell and the men all lift their cups to him in a loud, increasingly slurred cheer.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prost!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-10 * this.World.getPlayerRoster().getSize());
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + 10 * this.World.getPlayerRoster().getSize() + "[/color] Crowns"
					}
				];
				this.List.extend(_event.giveTraits(90));
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_40.png[/img]You hold your hand up, stopping the monk before he can get going again. He sighs, slowly lowering the reins out of his hand. Feeling as though he may be getting the wrong impression, you quickly ask if maybe he has beer to spare for your men. You are more than willing to pay. The monk looks back at his stock for a moment, then turns around.%SPEECH_ON%Aye. Damn it to hells if the gods wouldn\'t be happy with yer money crossin\' m\'palms. If ye fight the good fight, then I bid you to take some for free, but not all of it of course.%SPEECH_OFF%You thank the monk for his generosity and order you men to be modest with their drinking. As a few brothers circle around to the cask, the monk throws his hands up.%SPEECH_ON%Don\'t mind the bees \'round the top, they\'ll scurry when you come, but if you scurry when they scurry, they\'ll scurry after ya. Strange little gits.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prost!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveTraits(90);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_40.png[/img]As the cart waddles by, you take the pommel of your sword and bash it against the cask of beer, popping the lid off the top and sending a number of bees into a frenzy. The monk lets go of the reins as he looks back at you.%SPEECH_ON%T\'was afraid you\'d do that.%SPEECH_OFF%The man disappears beneath a punch, his body twisting as he falls to the ground. A few brothers converge on him for some good kicks while others lift the beer and take it to some shade. You dip a mug into the cask for a drink then lift it to the monk writhing on the ground.%SPEECH_ON%Bottom\'s up lads, and let us not forget to thank our generous friend over there!%SPEECH_OFF%The monk turns over, eyes wincing as they rapidly blink. He\'s clutching his back with one hand while using the other to slowly get up. With a bent posture, he takes the reins of the donkey and starts forward. He tries to slip his hat back on but it falls away and he doesn\'t bother to go after it. The man grows small in the distance, blurred by horizon and alcohol alike, and then he is gone.\n\nThe men all lift their cups to you in a loud, increasingly slurred cheer.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prost!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				this.List = _event.giveTraits(66);
			}

		});
	}

	function giveTraits( _chance )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local result = [];

		foreach( bro in brothers )
		{
			if (this.Math.rand(1, 100) <= _chance)
			{
				bro.improveMood(1.0, "Celebrated with the company");

				if (bro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					result.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}
		}

		return result;
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() <= 10 * this.World.getPlayerRoster().getSize() + 250)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = 8;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A1";
	}

	function onClear()
	{
	}

});

