this.undead_zombie_in_granary_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_zombie_in_granary";
		this.m.Title = "At %town%...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]You come across a man hollering for help, so hysterical that he seems to pay no mind to gaining the attention of armed sellswords who have no allegiance to any house or their laws.%SPEECH_ON%Please! Help me! There\'s a... a corpse! In the granary!%SPEECH_OFF%He thumbs over his shoulder to a large, wooden building. Its front door rattles almost as if on cue. The man loses his mind.%SPEECH_ON%That\'s it! That\'s the monster! Please, go in there and kill it! We can\'t afford to lose all the food in there!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s best to burn that granary down.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "One of my men will go in and handle this.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				},
				{
					Text = "We don\'t have time for this.",
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
			Text = "[img]gfx/ui/events/event_30.png[/img]You grab the man by the shoulders and stare at him as you talk.%SPEECH_ON%We are going to burn down the granary. What food that is in there, are you listening? Listen carefully to what I\'m going to say. The food in there is diseased and should not be eaten. There is nothing to save.%SPEECH_OFF%The peasant, his body shaking as though with a cold, steps out of the way. He squishes his face behind both hands, barely able to watch as two of your sellswords step forward, torches in hand, and set the granary ablaze.\n\nThe door stops rattling for a moment, then picks back up, nearly breaking its hinges. As smoke streams out from its bottom, someone begins crying out.%SPEECH_ON%A joke! A joke! Please, let me out! Aaah, AAAHH!%SPEECH_OFF%%dude% rushes to the door and breaks it down. A little boy runs out, a body for a torch, limbs flailing arches of flame. He settles down on the ground where the mercenaries try to cover him, but it\'s too late. He\'s a smoldering ruin by the time the fire is put out. The peasant man looks absolutely horrified.%SPEECH_ON%I... I had no idea, I thought it... he kept making growling noises.%SPEECH_OFF%You shake your head and tell the company to quickly get back on the road.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, shite.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "You had a boy burned by accident");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
			Text = "[img]gfx/ui/events/event_30.png[/img]The food is no doubt lost to the diseases by now, and the entire building might be infected with evils beyond human measure. Slowly, you explain to the man that you will burn his granary down. He doesn\'t refuse, only hurriedly nods his head.%SPEECH_ON%I know. I didn\'t want to do it myself, I suppose, maybe hanging onto the idea that someone would come along and tell me what I wanted to hear, not what needed to be done.%SPEECH_OFF%A few sellswords set torches to the corners of the granary and it doesn\'t take long at all for the fires to crawl up its walls and roof. But a minute later the entire structure is blazing. When the front door breaks apart, a wiederganger shuffles through the gap, its entire body curling with fire and smoke. It\'s all but blackened bones by now, skin dripping off its skeleton in great, gooey gobs. %dude% cuts its head off with a swift blow. The peasant watches the rest of his building collapse, the glow of the fire shining the tears on his cheek.%SPEECH_ON%Well, I guess that\'s it then. Thank you, sellsword.%SPEECH_OFF%He offers you a modest sum of crowns which you are more than happy to take for your \'services.\'",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gross.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(50);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_79.png[/img]You decide to solve this wiederganger problem as though it were facing you in the field. %dude% kicks the front door down and stabs the first thing he sees. The undead corpse lurches, the momentum bending its body over the blade. And then you see it: blood slowly running down the metal. As the mercenary steps back, the light reveals that the corpse is not an undead body, but a simple boy. He\'s gargling, eyes wide, hands shaking against his wound.%SPEECH_ON%I... I was just playing...%SPEECH_OFF%The sellsword wrenches an arm back and withdraws his weapon. The boy collapses. You turn to the peasant man. He holds his hands up.%SPEECH_ON%I had... I had no idea! He was making noises! He kept, I heard... growling! There was so much growling, I don\'t...%SPEECH_OFF%The man falls to his knees. You look at the boy who is beyond help, his skin going paler by the second as ropes of crimson splurge from his wounds. You shake your head and tell the men to get back on the road before anything bad comes of the scene.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Farking hell.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.worsenMood(2.0, "Killed a little boy by accident");

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_79.png[/img]You send %dude% into the granary to handle it. He claps his shoulders to loosen up.%SPEECH_ON%One dead wiederganger coming right up.%SPEECH_OFF%The sellsword kicks the door in and rushes through. There\'s the din of fighting and a flash of light hits the metal of the mercenary\'s weapon as he works through the darkness and evil. A moment later, he steps back out, wiping sweat from his forehead.%SPEECH_ON%Done. Blood on some of the food, but you can just eat around that.%SPEECH_OFF%You turn to the peasant and hold your hand out. He begrudgingly hands you a small purse of crowns.%SPEECH_ON%Thank you... mercenary.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good job.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(50);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] Crowns"
					}
				];
				_event.m.Dude.improveMood(0.25, "Saved a peasant");

				if (_event.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance > 3)
		{
			return;
		}

		this.m.Town = bestTown;
		this.m.Dude = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
		_vars.push([
			"dude",
			this.m.Dude.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Dude = null;
	}

});

