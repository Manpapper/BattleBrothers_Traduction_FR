this.jousting_tournament_event <- this.inherit("scripts/events/event", {
	m = {
		Jouster = null,
		Opponent = "",
		Bet = 0
	},
	function create()
	{
		this.m.ID = "event.jousting_tournament";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%jouster% comes to you with a paper in hand. He slams it on your table and says he wishes to enter. You pick up the scroll, unfurling it to show that a local town is hosting a jousting tournament. The man crosses his arms, awaiting your response.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very well, you may take part in this.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "No, we have more important matters to attend to.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_96.png[/img]You agree to let %jouster% go to the tournament and, wanting to see it for yourself, you go along, too.\n\nThe jousting tourney crackles with energy as you near it. Squires hurry to and fro, carrying great armfulls of armor and weapons, and some step slowly about with enormous lances hefted over their shoulders. Other men brush very regal looking horses, many of which wear breastplates decorated with sigils. In the distance, you listen to brief gallops, heavy hooves stamping roughshod and lumbering and then there\'s a snapping twang of wood on metal and cheers erupt.\n\nAs you look about the festivities, a nobleman walks up and stops you. Weighing a purse in one hand and twisting a piece of broomstraw about the corner of his mouth with the other, he asks if you\'d like to make a wager. You ask what for. He nods, pointing toward %jouster% who is across the mustering point signing himself into the tourney. Apparently he is to face this nobleman\'s own rider, a man by the name of %opponent%.%SPEECH_ON%A little bit of gamesmanship never hurt, no? How does %bet% crowns sound to you? Winner take all, of course.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The bet is on!",
					function getResult( _event )
					{
						_event.m.Bet = 500;
						return "P";
					}

				},
				{
					Text = "I don\'t gamble.",
					function getResult( _event )
					{
						return "P";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "P",
			Text = "[img]gfx/ui/events/event_96.png[/img]You take a seat amongst commoners and noblemen alike. Only the local lord has any separation from the riff-raff, sitting on a heightened row with the likes of his sons, daughters, and various royalty from around the land.\n\n%jouster% is up next, a squire helping lead his horse to one of the jousting lanes. Down the battleline, %opponent% rides onto the field, his horse black, his armor a vibrant purple with gold trimmings and tassels here and there. Both he and %jouster% take up their lances and slap down the faceplates of their helmets.\n\nA barker shouts their names from the royal-box, and then a clergyman says a few words about how this was ordained by the gods and, were anybody here to die today, they\'d sit amongst the greatest of men in the next realm, and be remembered with them in this one. All that said, the two jousters lower their lances and charge before either the barker or priest can even take a seat.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Exciting!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 30 + 5 * _event.m.Jouster.getLevel())
						{
							return "Win";
						}
						else
						{
							return "Lose";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Win",
			Text = "[img]gfx/ui/events/event_96.png[/img]Having never been to such an event, you can\'t help but hold your breath as the two riders barrel down the lanes toward each other. The horses are majestic, their legs in rhythm, their hooves tearing up great clods of earth, their armors glinting sundots across the crowds as they run, altogether leaving in their wake streams of giddy observers and shouting kids and drunks spilling their raised mugs and young princesses gripping their dresses and wantingly brave princes clapping their hands and, not knowing how it even came to be, you yourself are standing and shouting.\n\n %opponent% struggles to keep his aim steady, his lance bobbing up and down, the point of it wobbling in search of a true target.\n\nHe doesn\'t find it.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ohh!",
					function getResult( _event )
					{
						if (_event.m.Bet > 0)
						{
							return "WinBet";
						}
						else
						{
							return "WinNobet";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "WinNobet",
			Text = "[img]gfx/ui/events/event_96.png[/img]%jouster%\'s lance shatters on his opponent\'s chest, a proverbial explosion of sawdust and splinters through which rides a horse with no rider, the jouster having been driven back over his cantle and clear of his saddle altogether, coming facedown on the battleground with nary a move or breath. A roar bursts from the crowd, an uncorked tempest which you are quick to join, drowning your ears in a blistering cacophony, swept up in a time and place you will never forget.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Huzzah!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				_event.m.Jouster.improveMood(2.0, "Won a jousting tournament");

				if (_event.m.Jouster.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Jouster.getMoodState()],
						text = _event.m.Jouster.getName() + this.Const.MoodStateEvent[_event.m.Jouster.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "WinBet",
			Text = "[img]gfx/ui/events/event_96.png[/img]%jouster%\'s lance shatters on his opponent\'s chest, a proverbial explosion of sawdust and splinters through which rides a horse with no rider, the jouster having been driven back over his cantle and clear of his saddle altogether, coming facedown on the battleground with nary a move or breath. A roar bursts from the crowd, an uncorked tempest which you are quick to join, drowning your ears in a blistering cacophony, swept up in a time and place you will never forget.\n\nWhile still celebrating, the nobleman you made a wager with comes over and places a purse into your hand. You wish to say a few words, but before you can he angrily turns and walks off.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Huzzah!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				this.World.Assets.addMoney(_event.m.Bet);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You win [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _event.m.Bet + "[/color] Crowns"
				});
				_event.m.Jouster.improveMood(2.0, "Won a jousting tournament");

				if (_event.m.Jouster.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Jouster.getMoodState()],
						text = _event.m.Jouster.getName() + this.Const.MoodStateEvent[_event.m.Jouster.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Lose",
			Text = "[img]gfx/ui/events/event_96.png[/img]Having never been to such an event, you can\'t help but hold your breath as the two riders barrel down the lanes toward each other. The horses are majestic, their legs in rhythm, their hooves tearing up great clods of earth, their armors glinting sundots across the crowds as they run, altogether leaving in their wake streams of giddy observers and shouting kids and drunks spilling their raised mugs and young princesses gripping their dresses and wantingly brave princes clapping their hands and, not knowing how it even came to be, you yourself are standing and shouting.\n\n%jouster% struggles to keep his aim steady, his lance bobbing up and down, the point of it wobbling in search of a true target.\n\nHe doesn\'t find it.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ohh...",
					function getResult( _event )
					{
						if (_event.m.Bet > 0)
						{
							return "LoseBet";
						}
						else
						{
							return "LoseNobet";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "LoseNobet",
			Text = "[img]gfx/ui/events/event_96.png[/img]%opponent%\'s lance explodes as it lands square on %jouster%\'s chest. The man is bent back in his saddle, a cloud of spinning splinters and powdered wood swirling in his wake. He reaches desperately for his reins. Finding them, you think he\'s recovered, but the bridlebit breaks off and the reins slip free. %jouster% falls backward, tumbling over the mount\'s hindquarters and landing on his feet. Standing he may be, he\'s lost.\n\nThe crowd erupts, clapping fervently to both winner and loser. Rolling his shoulder in a bit of pain, %jouster% clears the field. You find him back at the mustering grounds. He says something was off about his lance, and you mention that his horse\'s bridlebit came loose. Just then, the winner walks by, a retinue of adoring women behind him and a squire leading a rather pompous looking horse. To your surprise, %opponent% and %jouster% shake hands and bid each other congratulations on a well-fought match.",
			Image = "",
			List = [],
			Characters = [],
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
				this.Characters.push(_event.m.Jouster.getImagePath());
				local injury = _event.m.Jouster.addInjury(this.Const.Injury.Jousting);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Jouster.getName() + " suffers " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "LoseBet",
			Text = "[img]gfx/ui/events/event_96.png[/img]%opponent%\'s lance explodes as it lands square on %jouster%\'s chest. The man is bent back in his saddle, a cloud of spinning splinters and powdered wood swirling in his wake. He reaches desperately for his reins. Finding them, you think he\'s recovered, but the bridlebit breaks off and the reins slip free. %jouster% falls backward, tumbling over the mount\'s hindquarters and landing on his feet. Standing he may be, he\'s lost.\n\n The crowd erupts, clapping fervently to both winner and loser. Rolling his shoulder in a bit of pain, %jouster% clears the field. You find him back at the mustering grounds. He says something was off about his lance, and you mention that his horse\'s bridlebit came loose. Just then, the winner walks by, a retinue of adoring women behind him and a squire leading a rather pompous looking horse. To your surprise, %opponent% and %jouster% shake hands and bid each other congratulations on a well-fought match. \n\n The nobleman you made a wager with isn\'t so keen on good sportsmanship. He comes to you rubbing his hands beneath a cheap grin. You begrudgingly pay the man what he is owed.",
			Image = "",
			List = [],
			Characters = [],
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
				this.Characters.push(_event.m.Jouster.getImagePath());
				this.World.Assets.addMoney(-_event.m.Bet);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Bet + "[/color] Crowns"
				});
				local injury = _event.m.Jouster.addInjury(this.Const.Injury.Jousting);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Jouster.getName() + " suffers " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]Telling %jouster% no does not go over well. He goes on a great deal about how much money he could have made at the tournament and how you are robbing him of those crowns. All very interesting complaints, sure, until he turns to you and demands %compensation% crowns, compensation for what he claims are lost earnings.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very well, I shall compensate you.",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "You\'re a mercenary now, not a jouster. Better get used to it.",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_64.png[/img]You stand up and pat %jouster% on the shoulder.%SPEECH_ON%I\'ve no doubt that a man of your skill and prowess would have run clean through the tournament. But I need a man such as yourself here, at camp. You need not prove any lost earnings, I will compensate you for them simply enough.%SPEECH_OFF%The rather diplomatic words calm the man down. He nods and briefly looks as though it would be dishonorable to accept the payment. Not wanting the sellsword to test his resolve any further, or perhaps look a fool or a man of low honor, you order him to take it.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You may leave now.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_64.png[/img]You grab the tournament poster and put it to a candle. While flames eat away the paper, you set some ground rules for %jouster%.%SPEECH_ON%I hired you to be a sellsword, not some nimby-namby jouster. If you want to go off fighting in tournaments, then you can return all your equipment and base pay. Otherwise, get the hell out of my tent.%SPEECH_OFF%This doesn\'t go over especially well, but ultimately the mercenary does only leave your tent and not the whole company altogether.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get back to work!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				_event.m.Jouster.worsenMood(2.0, "Was denied participation in a jousting tournament");

				if (_event.m.Jouster.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Jouster.getMoodState()],
						text = _event.m.Jouster.getName() + this.Const.MoodStateEvent[_event.m.Jouster.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 500)
		{
			return;
		}

		if (this.World.FactionManager.isGreaterEvil())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getLevel() < 4)
			{
				continue;
			}

			if ((bro.getBackground().getID() == "background.adventurous_noble" || bro.getBackground().getID() == "background.disowned_noble" || bro.getBackground().getID() == "background.bastard" || bro.getBackground().getID() == "background.hedge_knight") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Jouster = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
		this.m.Opponent = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)];
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"jouster",
			this.m.Jouster.getName()
		]);
		_vars.push([
			"opponent",
			this.m.Opponent
		]);
		_vars.push([
			"bet",
			500
		]);
		_vars.push([
			"compensation",
			500
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Jouster = null;
		this.m.Opponent = "";
		this.m.Bet = 0;
	}

});

