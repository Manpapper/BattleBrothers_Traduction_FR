this.undead_boy_who_cried_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Refusals = 0
	},
	function create()
	{
		this.m.ID = "event.undead_boy_who_cried";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 140.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{While visiting %townname%, you are called on by a young boy who comes crying that undead are coming to eat his family. You ask how many and he says just one, but that it\'s of deadly stock.%SPEECH_ON%I think it\'s my old babysitter. She was never keen on me. Please, help!%SPEECH_OFF%If it\'s just one wiederganger it should not be that much trouble and you can probably handle it yourself.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Lead us to your house, kid.",
					function getResult( _event )
					{
						return "Accept1A";
					}

				},
				{
					Text = "You\'re on your own, kid.",
					function getResult( _event )
					{
						++_event.m.Refusals;
						return "Refuse" + _event.m.Refusals;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Accept1A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You rush to the boy\'s home and rush through the door. You find his family setting up the dinner table. They look at you as though you were a madman and one asks if they can help you. The boy starts laughing so hard he clenches his stomach and rolls around on the ground. The mother grabs him by the ear. She apologizes as she hands him off to his father for a good whipping.%SPEECH_ON%Sorry, sellsword, we mean no trouble but this boy, well he does as he pleases sometimes.%SPEECH_OFF%Can\'t really fault a boy for being a boy, though this one is definitely a little shite if you\'ve ever seen one. You head back to the markets.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very funny.",
					function getResult( _event )
					{
						return "Accept1B";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
			}

		});
		this.m.Screens.push({
			ID = "Accept1B",
			Text = "[img]gfx/ui/events/event_01.png[/img]{As you peruse a merchant\'s goods, a little voice yells out for you. Turning, you see it\'s that damned kid again. He\'s pointing homeward once more.%SPEECH_ON%Sellsword! One\'s there! I\'m serious! You have to help!%SPEECH_OFF%You ask why he doesn\'t bother one of the townguards and he says that none trust him.%SPEECH_ON%Fetched them on too many lies I \'ave! Please, help! My family is going to be slaughtered!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, alright, let\'s go.",
					function getResult( _event )
					{
						return "Accept2A";
					}

				},
				{
					Text = "You\'re on your own, kid.",
					function getResult( _event )
					{
						++_event.m.Refusals;
						return "Refuse" + _event.m.Refusals;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Accept2A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Sighing, you tell the boy to lead the way. Surprise surprise, you\'ve been made a fool of again. The boy can\'t stop laughing even as his father whips him a good one. The mother, again, apologizes and hands you a small giftbag of goods for your trouble and \'looking out\' for them. You head back to the markets.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That makes up for the trouble.",
					function getResult( _event )
					{
						return "Accept2B";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
				local item = this.new("scripts/items/supplies/roots_and_berries_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Accept2B",
			Text = "[img]gfx/ui/events/event_01.png[/img]{While back in the market, you\'re already expecting that savage little liar to come by. You feign shock when he\'s pulling on your hand. A moment comes by and you see yourself socking him right in the jaw. Of course, that would not look good to those who know naught what is going on so you keep yourself steady.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gee, I wonder how this will turn out.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "Accept3A" : "Accept3B";
					}

				},
				{
					Text = "Run before you get a beating, boy!",
					function getResult( _event )
					{
						++_event.m.Refusals;
						return "Refuse" + _event.m.Refusals;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Accept3A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Warily, you return to the boy\'s home. The second you open the door to see the family enjoying a game of cards you to turn around and grab the kid by his throat and slam him against the wall. You kick the door closed so no one can see. The father gets up and tells you that\'s his son you\'re manhandling. You tell the father to give you the switch used to beat his boy. Cautiously, he does as told. This time, you punish the kid yourself and when you\'re finished he\'s a welted, weeping mess.\n\nYou throw the switch at the crumpled child and tell the parents to pay you for your time, informing them that a \'sellsword never works for free.\'}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Punitive measures had to be taken.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(10);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 10 + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Accept3B",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Warily, you return to the boy\'s home. Opening the door, you turn to the kid and tell him if he\'s lying once again you\'ll... before you can even finish the threat a scream draws your attention to the family. A large, ghoulish figure is terrorizing the mother and the father is using a broom to try and beat it back. You draw your sword, step forward, and cut the wiederganger down. Its head rolls free and splashes into a crockpot while the body crumples and spews black sludge across the floorboards.\n\n You turn to the boy and tell him that you almost didn\'t come for a liar\'s truth will always remain a lie to all others. He nods and thanks you for believing him this time. The parents thank you, too, but with a little more care: a satchel of crowns and goods.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Best throw that crockpot away.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addMoney(25);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 25 + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Refuse1",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You distrust the little runt and tell him to stop playing games. He spits and churns some rocks beneath a boot.%SPEECH_ON%Hell, mister, I was trying to \'ave some fun.%SPEECH_OFF%When he turns to leave, you give him a swift kick in the arse.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damned runt.",
					function getResult( _event )
					{
						return "Accept" + _event.m.Refusals + "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Refuse2",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You tell the boy if he doesn\'t get out of sight you\'ll report him to the guards and have him thrown into the dungeons. He huffs and spits.%SPEECH_ON%Shite, mister, just \'aving a bit of a laugh, that\'s all.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And don\'t come back.",
					function getResult( _event )
					{
						return "Accept" + _event.m.Refusals + "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Refuse3",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You crouch down low so you and the kid can see eye to eye. You ask if he\'s lying. Slowly, he nods. A guard, overhearing this, comes over and grabs the child by his arm.%SPEECH_ON%Oy\', lying again are we? What did I tell you about bothering the travelers, hm? I suppose your father hasn\'t been strong with his switch-hand if yer at it again. Now we\'ll see how you fare in the dungeons!%SPEECH_OFF%The boy is taken away, balling his eyes out as a couple of rusty shackles are slapped on him. This is one of the happiest moments of your life.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Enjoy the dungeon.",
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
			ID = "Refuse3B",
			Text = "[img]gfx/ui/events/event_29.png[/img]{You tell the boy to stuff it. He begs again and, for a moment, it\'s as though something real is behind his lying eyes. But you\'re not buying it. The boy runs off, now asking the guards for help. They also turn him down. A few merchants laugh.%SPEECH_ON%Nobody believes your lies, little runt.%SPEECH_OFF%But a shriek cuts the humor short. A man limps across the street, clutching his neck which is spraying blood between the fingers. He collapses to the ground. A sallow skinned woman chases after, falling to the man\'s body and biting into his leg. Guards rush to the scene and slaughter the dead and dying while the newly orphaned by wails on.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oh.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.FactionManager.getGreaterEvilType() != this.Const.World.GreaterEvilType.Undead || this.World.FactionManager.getGreaterEvilPhase() == this.Const.World.GreaterEvilPhase.NotSet)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

