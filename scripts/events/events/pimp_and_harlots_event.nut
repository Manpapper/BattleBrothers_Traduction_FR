this.pimp_and_harlots_event <- this.inherit("scripts/events/event", {
	m = {
		Payment = 0
	},
	function create()
	{
		this.m.ID = "event.pimp_and_harlots";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_85.png[/img]While on the march, you come across a woman standing off the side of the road. She\'s standing at the head of a donkey-pulled wagon. Seeing you, she claps her hands and yells out some order. Within moments, wenches pour out the back of the wagon and line up before you. They\'re poorly dressed and, if this is some act, poorly rehearsed. Most look like they\'d rather be somewhere else which is ordinary of any womanfolk stuck out in the sticks. You ask the \'leader\' of this group what she\'s doing. She grins ear to ear.%SPEECH_ON%I am a merchant of flesh, a profiteer of good poundings. These, here, are my wares.%SPEECH_OFF%She swings her arms to the prostitutes. They straighten up, or loosen up, and feign interest in you and your men. The pimp nods.%SPEECH_ON%So, what say we help take the edge off, hm? Been a long day, no? For that many men, I\'d wager it\'d cost you a low %cost% crowns.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "You got a deal!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "How about you just hand over your valuables instead?",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "No, thanks.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]Despite the protests of some of your men, you decline the pimp\'s offer. She shrugs.%SPEECH_ON%Damn, I knew I should have invested in little boys. Well, suit yerself.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "There\'ll be entertainment in the next town.",
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
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.worsenMood(0.75, "You refused to pay for harlots");

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
			Text = "[img]gfx/ui/events/event_85.png[/img]The womenfolk press forward, some winking lazily, some with lazy eyes winking wonkily. It\'s a sorry lot of wenches, but the men could use a bit of reprieve. You accept the pimp\'s price and the men sort out the rest, ducking into bushes and a variety of other cover. While they get some action, the pimp sidles up next to you.%SPEECH_ON%Thanks for not robbing us.%SPEECH_OFF%You shrug and say that\'s still on the table. She shrugs, too.%SPEECH_ON%I know, but I don\'t think you will. Me and you, we are a lot alike. You fight for food, we fuck for it.%SPEECH_OFF%Curious, you ask if she still \'fucks\' for her food. She laughs.%SPEECH_ON%Only when I need to. This \'leadership\' role is a pretty nice gig. Do you still \'fight\' for yours?%SPEECH_OFF%You just give her the truth.%SPEECH_ON%I\'ve killed many, many people.%SPEECH_OFF%She sidles up real close now and goes low with a hand.%SPEECH_ON%Well then.%SPEECH_OFF%Well then indeed.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Worth it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Payment);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Payment + "[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Enjoyed himself with harlots");

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

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_07.png[/img]You agree to the offer. The pimp and her harlots come forward, swarming into your ranks like a bunch of salacious snakes. Mere moments after most of your men have their pants down, a group of bandits step out of the bushes. You grab your sword, the actual bladed one, and naked-leggedly remove a thief\'s head from his shoulder and stab another through the chest. More robbers come forward, weapons out ready for combat, but the pimp jumps between everyone.%SPEECH_ON%Whoa! No one else needs to die here!%SPEECH_OFF%Some of your men still don\'t even realize what the hell is going on which is as good a sign as any that this wench has gotten the drop on you. That said, the %companyname% is still a force of nature, pants or no pants, and the pimp recognizes this. She scolds the hired hands.%SPEECH_ON%I thought I told you morons to not attack if the Johns appear dangerous. Don\'t they look farkin\' dangerous? Goddam. Look, sellsword. I\'ll take double the offer and leave you be. Just double the offer and we\'ll go.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Alright, deal.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "No deal.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_07.png[/img]You\'re not going to risk your men and agree to her terms. Taking the money, she nods.%SPEECH_ON%Most men would have let their pride take over there, but you know how to keep your men safe. A smart sellsword is rare these days and your men should be happy to have you as their leader.%SPEECH_OFF%As the robbers and harlots leave, %randombrother% walks up groaning.%SPEECH_ON%Well shit. I\'m so warmed up I could split a wench in half.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Didn\'t need to know that.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Payment * 2);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Payment * 2 + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_06.png[/img]You don\'t say no deal so much as show it. Sword still in hand, you swing it back up and slash the pimp\'s face. As she stares at you in disbelief, you reverse the sword swing and cleave her head clean off. The men, trousers down, grab their gear and start to fight. A few harlots brandish daggers and get some stabs in, but they are quickly killed off. Most of the prostitutes are harmless, but get butchered in the confusion and chaos.\n\nThe robbers, who probably weren\'t expecting actual combat, say farewell to their short, shitty lives. When it\'s all said and done, there\'s a good twenty bodies spread over the field and most mercenaries did not come out the other side unharmed. You try and salvage what you can from the field.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Probably should avoid fighting with our pants down.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/weapons/dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/bludgeon");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(100, 300);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " suffers " + injury.getNameOnly()
						});
					}
					else
					{
						local injury = bro.addInjury(this.Const.Injury.PiercingBody);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " suffers " + injury.getNameOnly()
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_07.png[/img]You think the offer over, then realize these are just a bunch of women out in the middle of nowhere. With a solid back hand, you send the pimp to the ground. She rubs her cheek and says roughhousing will cost extra. You nod.%SPEECH_ON%Yeah, it\'ll cost you everything you got. Men, take it all.%SPEECH_OFF%The pimp asks if this is a robbery and you nod. The second you make your intentions clear, a group of armed men step out of some nearby bushes. The pimp gets up and rubs her cheek.%SPEECH_ON%I\'m still willing to part on neutral terms here, sellsword. A good slap ain\'t no problem in this business. It\'s expected, even, but so are robbers and murderers and rapists. Now, if you wish to keep on doing what you want, I\'m gonna sic those men on you to do what I need, which is keep me and mine safe.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Alright, we\'ll step off.",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Those guards are pathetic. Attack!",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_64.png[/img]Looking at the guards, and at your men who you don\'t wish to lose over this bullshit, you nod.%SPEECH_ON%Smart lady. Alright. There\'s no need for bloodshed.%SPEECH_OFF%The pimp sighs in relief.%SPEECH_ON%Glad we could come to an agreement. I\'m afraid my previous offer is off the table. I\'m sure you understand.%SPEECH_OFF%Sheathing your sword, you say that you do. A couple of the brothers spit and shake their heads. They think they missed out on a good lay because of your aggression here.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Can\'t you tell they were going to rob us anyway?",
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
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(1.0, "Missed out on a good lay because of you");

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
			ID = "I",
			Text = "[img]gfx/ui/events/event_60.png[/img]These \'guards\' ain\'t shit. You order your men to attack. The fight is a brief flurry of action. The harlot\'s hired hands act as though they didn\'t expect to see actual combat.\n\n With the combat over, you see that the wagon\'s still here, but the pimp and her prostitutes are gone. They must have made their leave during the fight. They even took the donkey, that lucky ass.\n\n Your men raid the wagon. While taking anything that\'s not nailed down, %randombrother% hears a knocking noise. He searches the bottom of the cart and pulls on a cord, dropping a slat of wood down which rolls a man completely covered in black leather. You pull back the mask covering his face. He sucks in a breath.%SPEECH_ON%Th-thank you! By the old gods, I thought they\'d have me in there forever!%SPEECH_OFF%You ask who he is. He spits the leather scraps out of his mouth.%SPEECH_ON%Gimp.%SPEECH_OFF%Just \'Gimp\'? He nods.%SPEECH_ON%Yessir. Hey, those are some nice weapons you got there. Sleek armor, too. Hm. My master is gone, so...%SPEECH_OFF%You shake your head.%SPEECH_ON%Go to the closest town and get yourself cleaned up, stranger.%SPEECH_OFF%He nods.%SPEECH_ON%As you wish, master.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Yes, yes. Go.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/weapons/dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/bludgeon");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(100, 300);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " suffers " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " suffers light wounds"
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 10)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() <= 3)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 50 * brothers.len() * 2 + 500)
		{
			return;
		}

		this.m.Payment = 50 * brothers.len();
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cost",
			this.m.Payment
		]);
	}

	function onClear()
	{
		this.m.Payment = 0;
	}

});

