this.greenskins_investigation_event <- this.inherit("scripts/events/event", {
	m = {
		Noble = null,
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_investigation";
		this.m.Title = "At %town%...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_31.png[/img]While you restock your inventory and give the men some rest, the lord of the castle, %nobleman%, calls for you. He says that there is a goblin loose in the castle and he wants you to track it down.%SPEECH_ON%I\'d ask my men, but they couldn\'t find their own arses even if they ate their eyes and shat them out.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "We shall search the pantry.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B1";
						}
						else
						{
							return "B2";
						}
					}

				},
				{
					Text = "We shall search the halls.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "E1";
						}
						else
						{
							return "E2";
						}
					}

				},
				{
					Text = "We shall search the armory.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "H1";
						}
						else
						{
							return "H2";
						}
					}

				},
				{
					Text = "We have no time for favors.",
					function getResult( _event )
					{
						_event.m.NobleHouse.addPlayerRelation(-5.0, "Denied " + _event.m.Noble.getName() + " a favor");
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_31.png[/img]You search the pantry, opening the door to shelves upon shelves of foodstuffs from cheeses to salted meats to vegetables which dangle from wall hooks. Wickerwork carboys tempt you, but just as you reach out to get a taste a shape darts across your peripheral. You turn, blade in hand, and stab the goblin just as it lunges toward you with a broken bottle. It dies instantly and makes quite a mess of the floor, ruining a couple bags of flour. The greenskin killed, you calmly drag it to %nobleman%. The nobleman puts his hands to his hips.%SPEECH_ON%Most impressive, sellsword, but did you have to drag it all the way here? My servants will have to scrub the floor for weeks!%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "That was easy. ",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Did a favor for " + _event.m.Noble.getName());
				local food = this.new("scripts/items/supplies/wine_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain Wine"
				});
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_31.png[/img]You go down to the pantry and open the door. Inside, you find shelves upon shelves of foods and goods. There also happens to be a man and woman having a good shag in the corner. They yelp like a couple of pups and cover themselves, the man using a wet flour bag, the woman strategically angling herself behind a shelf of melons. The man clears his throat.%SPEECH_ON%Please, sir, do not tell %nobleman%.%SPEECH_OFF%You were not even aware that this was the nobleman\'s wife, but now it\'s good to know. The man offers a deal.%SPEECH_ON%Look, I\'m just a stable boy. I can\'t offer you gold or nothing like that, but a famous jouster is staying here for a week and I can nab you his shield. It\'s a right pretty thing and you\'ll love it, I promise. All I ask is that you don\'t tell the lord!%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Your lord will hear of this. ",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Your secret is safe with me. ",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_31.png[/img]This seems as good of a time as any to develop a steady relationship with %townname%, and the best way to go about doing that is absolutely ruining this relationship you\'ve stumbled upon. You return to %nobleman%\'s room and report your findings. His face goes red, his knuckles a stark white.%SPEECH_ON%I figured. I figured. I farkin\' figured! But the stable boy? I will not be so insulted!%SPEECH_OFF%He snaps his finger to his guards.%SPEECH_ON%Bring me tongs and a blacksmith\'s fire. Take my \'wife\' to the tower. I\'ll deal with her later. And you, sellsword, thank you for bringing this news to me. As for the goblin, it\'s been found and taken care of. You need not worry about that no longer.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Truly a savage cockblocking.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Did a favor for " + _event.m.Noble.getName());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_31.png[/img]You decide not to tell the nobleman of what is wife is up to. The two lovebirds get dressed and hurry out of the pantry, the stable boy pausing to tell you he\'ll have that shield ready when you leave the castle. In the meantime, you report to the lord who stays you with a hand.%SPEECH_ON%Ah, you need not worry yourself any longer, sellsword. The goblin was found in the stables. One of the horses kicked it clear across the barn! I\'ll have to reward the stable boy on the soldiering abilities of his steeds!%SPEECH_OFF%Hmm, of course.\n\n When you leave the castle, the stable boy is there, a suspiciously shield-shaped sack in his hands.%SPEECH_ON%Here, take this. Hurry. And thanks again, sellsword.%SPEECH_OFF%You tell him it\'d be best if he kept it in his pants from now on. He shakes his head.%SPEECH_ON%Nah. She\'s worth it. See you later, sellsword.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Some men just never learn.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/shields/faction_heater_shield");
				item.setFaction(_event.m.NobleHouse.getBanner());
				item.setVariant(2);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E1",
			Text = "[img]gfx/ui/events/event_31.png[/img]You investigate the halls to see if the little green runt is footing about. Walking down a hallway, you hear the cry of two women come from a nearby room. You draw your sword and barge in. A scribe and treasurer are standing atop a desk while a little goblin jumps up and down to try and knife their ankles. You casually walk in and stab the greenskin through the chest and loft it up like a skewered squirrel. The men calm down and thank you for your work. You nod.%SPEECH_ON%Anytime, ladies.%SPEECH_OFF%They clear their throats and offers nervous smiles. You head on back to %nobleman% and get your pay.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "That was easy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Did a favor for " + _event.m.Noble.getName());
				this.World.Assets.addMoney(100);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You earn [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E2",
			Text = "[img]gfx/ui/events/event_31.png[/img]You figure the halls are as good a place as any to start your search. No more than a few twists and turns later do you hear a disturbing noise coming from the treasury. Drawing your blade, you ease up next to the door and then shoulder it open, leveling your weapon at whatever may stand on the other side. Instead of a goblin, you find a young and old man who jump in a fright, each with trousers well dropped, and there\'s a tub of slopped butter on the desk against which they had been leaning. The room smells... awful.\n\n Dressing themselves, the younger fellow states that he is the treasurer while the elder informs you of his position as scribe. The treasurer quickly offers you a good deal of coin to keep silent about these delicate matters. You laugh.%SPEECH_ON%I won\'t be falling for that trick. If I take that coin, you simply run along to your lord and tell him I stole it, no? What better way to protect yourself than to ensure my execution?%SPEECH_OFF%The treasurer retreats and the scribe steps forward. He is an elderly man who smells of arse and candlewax.%SPEECH_ON%In my repository, I have many things which are owned by me, not my lord. These items might be of great interest to you. Potions, drinks, goods which a fighting man such as yourself could make use of. And... and I\'ll throw in a wardog! A local houndmaster owes me a favor and now is as good of a time as any to call upon it!%SPEECH_OFF%The scribe laughs nervously as you mull the idea over. If you turned them in, who knows what may happen. Sodomites bother you none, but there are lords across the realm who consider such fornications to be abhorrent. If %nobleman% is such a fellow, you might gain favor by \'rooting\' these men out.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "The lord of the castle will decide your fates.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Your secret is safe with me.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_31.png[/img]You close the closet door and hurry to %nobleman%. You explain to the nobleman what you\'ve seen. When you finish, he states that the goblin had been found drowning in a sewage stream and has been put out of its misery.%SPEECH_ON%As for the sodomites, yes, what of it? Have you looked around? A fort is a nonsensical place to the urges of a man. Swingin\' dicks as far as the eye can see and nowhere to put them. Do I like it? No, of course not. Absolutely disgusting nonsense, truly. But if I punished every instance of this behavior I\'d be left with a bunch of scarecrows and farm animals, and I can\'t even be sure of the latter.%SPEECH_OFF%He waves you off.%SPEECH_ON%The goblin\'s been taken care of, sellsword, I\'ve little else to speak to you about. However, if you could, please inform the servants that the room in which you found them needs cleaning. I care not to look over taxes in a smog of shite.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
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
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_31.png[/img]You decide to keep their secret under the pretense that the scribe will give you what he has promised. The old man nods as you leave.%SPEECH_ON%I will find you in the courtyard, sellsword, with everything that you are owed. Your silence on this matter is most appreciated.%SPEECH_OFF%When you return to %nobleman%, he explains that the goblin had been found and taken care of. Seeing as how you weren\'t responsible, he sends you off without pay.\n\n Outside, the scribe does in fact meet you. He\'s got a leash in one hand and a sack in the other. He hands them both over.%SPEECH_ON%Once again, my thanks, sellsword.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "I should learn more secrets.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				local item;
				item = this.new("scripts/items/accessory/poison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/accessory/antidote_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/accessory/berserker_mushrooms_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "H1",
			Text = "[img]gfx/ui/events/event_31.png[/img]If you were a goblin in a castle of people wanting to kill you, where would you go? Putting yourself in the mind of the runt, you come to the conclusion that the armory would be as good a place as any to start your search. When you get there, you do find an apprentice standing outside and trying to hold the door shut. He yells that the goblin is inside and has already killed the blacksmith. Drawing your blade, you tell the apprentice to stand aside.\n\n The second he does, the door bursts open and a goblin, shaped like a scarecrow built out of broken buckets, shambles out, armored head-to-toe, a shield and spear clumsily stationed at its front. Ignoring the absurdity of what is being seen, you strike through the clutter and pierce the beast\'s skull, instantly killing it. When you withdraw your sword, all the armor and weapons fall away as though you\'d just slain an apparition holding them up.\n\n The apprentice quickly shakes your hand before falling to his knees, weeping over the loss of the blacksmith. With no time for tears, you take the goblin\'s head and return to %nobleman% for your pay.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "That was easy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Did a favor for " + _event.m.Noble.getName());
				this.World.Assets.addMoney(100);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You earn [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "H2",
			Text = "[img]gfx/ui/events/event_31.png[/img]Well, if you were a tiny dwarf in a hostile fortress the first place you\'d go is the armory. When you get there, you don\'t find any goblin, but instead there\'s a kid drawing a dagger out of a man who is face down on the floor. The murderer drops his weapon and holds his hands up.%SPEECH_ON%I had no choice! No choice at all!%SPEECH_OFF%You ask the kid who he and the dead man are. He quickly explains.%SPEECH_ON%I\'m the apprentice and this is... was the blacksmith. Now, this had to be done. Had to! You\'ve no idea what horrors this man has put upon me! Every time I errored, he punished me as though I was a kingslaying cretin! See this?%SPEECH_OFF%He sweeps a length of hair out of the way, revealing the bulbous scars of burns. Letting go of the hair, he holds up a hand with a grotesque pinky that rests at a right angle, and the other hand which has no pinky at all. He starts taking a boot off, but you stop him, getting the point. The apprentice clasps his hands together, his pinky sticking out like a haughty highborn sipping wine.%SPEECH_ON%You\'re after the goblin, right? Just tell them the goblin did it! I\'ll... look, I\'m not much of an armorer, but I can forge a sword like nobody\'s business and I will forge you the absolute best that I can do. Just keep this secret between us, that\'s all I ask.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Such a crime can\'t go unpunished!",
					function getResult( _event )
					{
						return "I";
					}

				},
				{
					Text = "Your secret is safe with me.",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_31.png[/img]You close the door and lock it, ensuring that the murderer will not be able to flee. As the apprentice screams and bangs against the door, you return to the nobleman.\n\n %nobleman% listens to your report and nods.%SPEECH_ON%Mmhmm, yes. The blacksmith is not the first to fall by that boy\'s hand - we\'ve had a series of murders here, but have never been able to find the culprit. Many believed it him on account of his bashing his hands with hammers and putting his face to a torch. The stable boy even saw him cut the cock off a rat. He was a disturbed fellow, but now you\'ve given us definitive proof of his doings. Well done, sellsword! The goblin you were after has already been taken care of, but this... this is far better than hunting down some greenskin. Consider your payment doubled!%SPEECH_OFF%The nobleman snaps his fingers at his scribe and starts uttering orders, ostensibly issuing a writ of execution. He goes into incredible detail about the logistics of the matter: horses, ropes, blades, tongs, hot fires, a litany of horrors to keep bored soldiers entertained for hours.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Very good.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Did a favor for " + _event.m.Noble.getName());
				this.World.Assets.addMoney(200);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You earn [color=" + this.Const.UI.Color.PositiveEventValue + "]200[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_31.png[/img]You close the door and lock it, ensuring that the murderer will not be able to flee. As the apprentice screams and bangs against the door, you return to the nobleman.\n\n %nobleman% listens to your report and nods.%SPEECH_ON%Mmhmm, yes. The blacksmith is not the first to fall by that boy\'s hand - we\'ve had a series of murders here, but have never been able to find the culprit. Many believed it him on account of his bashing his hands with hammers and putting his face to a torch. The stable boy even saw him cut the cock off a rat. He was a disturbed fellow, but now you\'ve given us definitive proof of his doings. Well done, sellsword! The goblin you were after has already been taken care of, but this... this is far better than hunting down some greenskin. Consider your payment doubled!%SPEECH_OFF%The nobleman snaps his fingers at his scribe and starts uttering orders, ostensibly issuing a writ of execution. He goes into incredible detail about the logistics of the matter: horses, ropes, blades, tongs, hot fires, a litany of horrors to keep bored soldiers entertained for hours.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Very good.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				local item = this.new("scripts/items/weapons/arming_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestTown;

		foreach( t in towns )
		{
			if (!t.isAlliedWithPlayer())
			{
				continue;
			}

			if (!t.isMilitary() || t.isSouthern() || t.getSize() < 2)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 4)
			{
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Noble = this.m.NobleHouse.getRandomCharacter();
		this.m.Town = bestTown;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"nobleman",
			this.m.Noble.getName()
		]);
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Noble = null;
		this.m.Town = null;
	}

});

