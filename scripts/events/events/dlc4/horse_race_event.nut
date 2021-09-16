this.horse_race_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Fat = null,
		Athletic = null,
		Dumb = null,
		Reward = 0
	},
	function create()
	{
		this.m.ID = "event.horse_race";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{You come across a man holding the reins of a lanky horse whose mangy mane has seen better days. The horse has a grey beard forming and its got dry caliche lips smacking desperately for water. Seeing you, its owner waves.%SPEECH_ON%Come, come! I\'ve a bet to make for those brave and fast enough to think they\'ll win it!%SPEECH_OFF%Curious, you ask what the bet is. The man pats the horse, a plume of dust lifting on the pat and you can see his handprint on the shoulder.%SPEECH_ON%Race m\'horse! Not with another horse, mind, but your humanly legs! If you lose, you give me %reward% crowns. If you win, I\'ll pay you triple. You up for it?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very well. Someone step forward and race that horse!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Athletic != null)
				{
					this.Options.push({
						Text = "Our most athletic man, %athlete%, will race that horse.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				if (_event.m.Fat != null)
				{
					this.Options.push({
						Text = "Our fattest man, %fat%, will race for our enjoyment.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Dumb != null)
				{
					this.Options.push({
						Text = "I can think only of %dumb% to be dim enough to race a horse.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Options.push({
					Text = "No, thanks.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{You nominate %randombrother% to try and see if he can best the beast. The race\'s rules are first to the apple tree and before you can even begin to root for the sellsword the horse smokes him completely. It gets to the finish line and begins fishing the branches for apples. The company is sitting completely silent, but when %randombrother% crosses the finish line in a distant last place they roar with delight as though he just won the keys to the kingdom\'s finest whorehouse. The horse\'s owner laughs.%SPEECH_ON%Don\'t be hard on yerself, kind sir. The fun is in the chance.%SPEECH_OFF%Indeed it seems the spectacle of the man\'s efforts entertained the company.} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It was quite the amusement.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				this.World.Assets.addMoney(-_event.m.Reward);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Reward + "[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Other.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 40)
					{
						bro.improveMood(1.0, "Felt entertained by " + _event.m.Other.getName() + " racing a horse");

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
			Text = "%terrainImage%{%athlete% steps forward. His calves bulge from his socks and he shoulder rolls to loosen up.%SPEECH_ON%Yeah I\'ll race that sorry horse.%SPEECH_OFF%The wager is made and the horse\'s owner directs you to a path. With the race set up, he holds up a pair of wooden tongs held apart, and backwards, by some tine. When he cuts the rope, the tongs snap clap together and start the race. Despite being looking like a wart left in the rain, the horse instantly gets a step on the nimble sellsword. It\'s only halfway down the track does the mercenary\'s stamina seem to put him back in the race, but he ultimately fails at the finish line. The owner claps his hands.%SPEECH_ON%Oh, that was a close one! The closest I\'ve seen!%SPEECH_OFF%You nod and pay the man what he is owed. %athlete% was beaten, but despite that it seems the loss has bettered him in some regard and the company certainly enjoyed the spectacle.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nice try.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Athletic.getImagePath());
				this.World.Assets.addMoney(-_event.m.Reward);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Reward + "[/color] Crowns"
				});
				_event.m.Athletic.getBaseProperties().Stamina += 1;
				_event.m.Athletic.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Athletic.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Max Fatigue"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Athletic.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Felt entertained by " + _event.m.Athletic.getName() + " racing a horse");

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
			ID = "D",
			Text = "%terrainImage%{Feeling rather courageous, you nominate the fattest man in the company to handle the race. %fat% steps forward with an eyebrow raised, asking if you\'re sure about taking him as your horseracing champion. You hold your hand on his shoulder and say he\'s the fattest fark you\'ve ever seen being a sellsword, but that you believe in him. You also believe the horse is a haggard draught animal that\'s on its last legs, but you keep that part to yourself.\n\n The man and horse are put next to each other. An apple tree stands in the distance and the first to it is the winner. With the rules laid out, the race is started. It\'s not an especially close one. %fat% falls behind almost instantly and trundles down the track with his face beet red and huffing breath and the men nearly die laughing at the sight. The fat sellsword and dire horse meet back up at the apple tree and there share the fruits of their labors. You pay the horse\'s owner what he is owed. He smiles as he counts the coin.%SPEECH_ON%Don\'t usually get a show with the race, sir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lose some pounds, would you?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fat.getImagePath());
				this.World.Assets.addMoney(-_event.m.Reward);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Reward + "[/color] Crowns"
				});
				_event.m.Fat.getBaseProperties().Bravery += 1;
				_event.m.Fat.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Fat.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Fat.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Felt entertained by " + _event.m.Fat.getName() + " racing a horse");

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
			ID = "E",
			Text = "%terrainImage%{You elect %dumb%, the company\'s biggest idiot, to be your horse racing champion. The horse\'s owner takes one look at the man and raises an eyebrow.%SPEECH_ON%Well. Alright.%SPEECH_OFF%Rules of the race are clear: first to a distant apple tree is the winner. The man and animal line up on the track. Pretending that he knows what he\'s doing, %dumb% crouches in a tri-pointed stance. The horse owner yells and slaps his beast on the buttocks. %dumb% releases into a nice stride and shockingly gets ahead of the horse, but he\'s unable to handle his speed and tilts into the second lane and collides with the beast. The horse buckles at the knees and flips head over hind and %dumb% somehow ends up in the curve of its loins and on the flip around is catapulted through the air. It\'s a damned sight and one you\'ll surely never see again. The horse gets back to its feet and stares around confused while %dumb%\'s unconscious body flies over the finish line. You turn your palms to the horse owner whose hands are gripping his head.%SPEECH_ON%By the old gods, man, are you not concerned for your sellsword?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "He\'ll be alright. Pay up.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dumb.getImagePath());
				this.World.Assets.addMoney(_event.m.Reward * 3);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _event.m.Reward * 3 + "[/color] Crowns"
				});
				local injury = _event.m.Dumb.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Dumb.getName() + " suffers " + injury.getNameOnly()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 1000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_fat = [];
		local candidates_athletic = [];
		local candidates_dumb = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.fat"))
			{
				candidates_fat.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.athletic"))
			{
				candidates_athletic.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.dumb"))
			{
				candidates_dumb.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_fat.len() != 0)
		{
			this.m.Fat = candidates_fat[this.Math.rand(0, candidates_fat.len() - 1)];
		}

		if (candidates_athletic.len() != 0)
		{
			this.m.Athletic = candidates_athletic[this.Math.rand(0, candidates_athletic.len() - 1)];
		}

		if (candidates_dumb.len() != 0)
		{
			this.m.Dumb = candidates_dumb[this.Math.rand(0, candidates_dumb.len() - 1)];
		}

		this.m.Reward = this.Math.rand(3, 6) * 100;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"randombrother",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"fat",
			this.m.Fat ? this.m.Fat.getNameOnly() : ""
		]);
		_vars.push([
			"athlete",
			this.m.Athletic ? this.m.Athletic.getNameOnly() : ""
		]);
		_vars.push([
			"dumb",
			this.m.Dumb ? this.m.Dumb.getNameOnly() : ""
		]);
		_vars.push([
			"reward",
			this.m.Reward
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Fat = null;
		this.m.Athletic = null;
		this.m.Dumb = null;
		this.m.Reward = 0;
	}

});

