this.imprisoned_wildman_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Wildman = null,
		Monk = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.imprisoned_wildman";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_41.png[/img]While on the march, you come across a line of stopped wagons. You realize the wagons are cages with each serving a prison to a wild animal. Touring the line of carts, you come to face a variety of beasts. A haunched and mewling black cat launches its mankiller claws through the bars. Jumping away, you back into another cage which violently rattles with a bear\'s roaring. Thankfully, its powerful paws are too fat to fit between the bars. Another cage sizzles with the hissing of snakes.\n\n A man leans back from behind one of the wagons. He\'s got a wild look on his face as though you\'d just caught him getting one off the wrist.%SPEECH_ON%Hey! Who are you? What are you doing here?%SPEECH_OFF%You inform the stranger that you are the captain of the %companyname%. The man straightens up.%SPEECH_ON%Oh, sellswords then! And I thought my luck had up and run off on me! Look, I got a problem that my hired hands refused to help with. They didn\'t care when they didn\'t know better, but the damn cloak fell off the wagon and then they just wouldn\'t shut up about how I wasn\'t paying them enough to transport such goods!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "What do you need help with?",
					function getResult( _event )
					{
						return this.World.Assets.getOrigin().getID() != "scenario.manhunters" ? "B" : "B2";
					}

				},
				{
					Text = "This ain\'t our problem.",
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
			Text = "[img]gfx/ui/events/event_100.png[/img]The animal tamer leads you to a carriage. You immediately see why his hired hands quit: a frenzied and mercurial wildman is sitting inside the cage. Raw wrists bleed against his shackles, signs of attempted escapes. Half-starved, the wildman gnaws on sticks poking out from a tumbleweed of a beard. Seeing this sad sight, you grab the stranger by his shirt and slam him against the wagon.%SPEECH_ON%Does that look like an animal to you?%SPEECH_OFF%The animal tamer grins, ivory for teeth. He explains himself.%SPEECH_ON%Cityfolk have gotten wind of the \'uncivilized\' wildmen and wish to see them up close. I am only fulfilling this new demand as any businessman would. Now, all I need help with is to get that dead body out of the cage.%SPEECH_OFF%He points toward a corpse in the corner of the cage. The wildman rears back, snarling, and goes to protectively sit on the body. The animal tamer shakes his head.%SPEECH_ON%One of my helpers got too close and, well, yeah. I can\'t go into town with that mess in there so I thought maybe you could help me fish it out. I\'ll pay plenty, of course. A pouch of 250 crowns sound good to you? Just reach on in there and yank that garbage out.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Alright, I\'ll send a man in.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "C" : "D";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "We got our own wildman who could help.",
						function getResult( _event )
						{
							return "Wildman";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Our monk seems a little disturbed by this.",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				this.Options.push({
					Text = "I won\'t put the life of my men at risk for this.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_100.png[/img]The animal tamer leads you to a carriage. You immediately see why his hired hands quit: a frenzied and mercurial wildman is sitting inside the cage. Raw wrists bleed against his shackles, signs of attempted escapes. Half-starved, the wildman gnaws on sticks poking out from a tumbleweed of a beard. The animal tamer grins, ivory for teeth.%SPEECH_ON%Cityfolk have gotten wind of the \'uncivilized\' wildmen and wish to see them up close. I am only fulfilling this new demand as any businessman would. Now, all I need help with is to get that dead body out of the cage.%SPEECH_OFF%He points toward a corpse in the corner of the cage. The wildman rears back, snarling, and goes to protectively sit on the body. The animal tamer shakes his head.%SPEECH_ON%One of my helpers got too close and, well, yeah. I can\'t go into town with that mess in there so I thought maybe you could help me fish it out. I\'ll pay plenty, of course. A pouch of 250 crowns sound good to you? Just reach on in there and yank that garbage out.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Alright, I\'ll send a man in.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "C" : "D";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "We got our own wildman who could help.",
						function getResult( _event )
						{
							return "Wildman";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Our monk seems a little disturbed by this.",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				this.Options.push({
					Text = "I won\'t put the life of my men at risk for this.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_100.png[/img]%taskedbro% is the one tasked with cleaning out the wildman\'s corpse-featured terrarium. He rolls up his sleeves and approaches the cage with both hands out.%SPEECH_ON%Whoa there, easy now. Easy!%SPEECH_OFF%The wildman gets up off the dead body and goes to the other side of its habitat. The sellsword easily grabs the boot of the corpse and drags it toward the bars. It slips through with sickening ease, already clumped up in the fashion of discarded wet clothes. Guts and limbs dribble off the edge of the wagon\'s platform. The animal tamer cheers happily.%SPEECH_ON%Thank you so much! And you made it look so easy, too!%SPEECH_OFF%%taskedbro% stares at the dead body with the realization that could have easily been him.%SPEECH_ON%Yeah. You\'re welcome.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, at least we got paid.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				this.World.Assets.addMoney(250);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color] Crowns"
				});
				_event.m.Other.getBaseProperties().Initiative += 2;
				_event.m.Other.getBaseProperties().Bravery += 1;
				_event.m.Other.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/initiative.png",
					text = _event.m.Other.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Initiative"
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/bravery.png",
					text = _event.m.Other.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_100.png[/img]%taskedbro% is tasked with getting the corpse out of the habitat. He approaches the cage like a harlot streetwalking a particularly pious town. When he gets close the bars, he smiles like an old friend.%SPEECH_ON%Hey there buddy. That\'s a nice corpse you got there. A great corpse, truly one of the best I\'ve ever seen. How about I just... take it... out...%SPEECH_OFF%When the mercenary reaches in, the wildman swipes out. It\'s too fast to even see. %taskedbro% slowly turns around. There\'s a black hole where one of his eyes used to be. The wildman squishes the eye between his teeth, a white goop bursting forth like a popped pustule, and it turns into a filmy paste as he chews. The animal tamer throws you a sack of crowns and runs off.%SPEECH_ON%Not liable! I am not liable!%SPEECH_OFF%%taskedbro% passes out as a few vengeful brothers stab the imprisoned wildman to death. All the caged beasts roar up as though you\'d just slain their leader. You quickly order the men away from the caravan before one of its beasts gets free and causes more damage.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What the hell!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury([
					{
						ID = "injury.missing_eye",
						Threshold = 0.0,
						Script = "injury_permanent/missing_eye_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " suffers " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_100.png[/img]You tell this animal tamer that his problems are his own. He shrugs.%SPEECH_ON%Yeah, I don\'t blame ya. You\'re smarter than you look, sellsword.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Uh, thanks.",
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
			ID = "Wildman",
			Text = "[img]gfx/ui/events/event_100.png[/img]If anyone in the party could help talk the caged wildman down, it\'s probably %wildman%. He goes to the cage, stares in. There\'s an exchange of hoots. Your wildman raps the bars with a knuckle, and the prisoner raps back and hoots somberly. Suddenly, %wildman% grabs the animal tamer by the head and drives him into the bars. You go to save the tamer, but the imprisoned wildman soars across the cage with atavistic terror in his eyes. Stepping back for your own safety, you can only watch as this bestial man sets upon the tamer. Both wildmen pull and drag on the man\'s face. The concussed man groggily yells.%SPEECH_ON%I thought we had an agreeeeeemeeeaahh!%SPEECH_OFF%%wildman% corks his thumbs into the man\'s eyes while the imprisoned wildman grips the tamer\'s mouth and pulls down. His head is literally ripped apart by the seams and sinews. A few men vomit as the tamer\'s brains falls out where his tongue should be, a truly awful way of speaking one\'s mind. The \'warden\' taken care of, %wildman% looks at you and at the wildman with a sort of \'can we keep him?\' gesture.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Absolutely disgusting. He\'s perfect.",
					function getResult( _event )
					{
						return "Wildman1";
					}

				},
				{
					Text = "No, he\'s clearly far too dangerous.",
					function getResult( _event )
					{
						return "Wildman2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Wildman1",
			Text = "[img]gfx/ui/events/event_100.png[/img]An outstanding capacity for violence is well-suited to a mercenary band. You agree to take the imprisoned wildman on.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the company.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return "Animals";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"wildman_background"
				]);
				_event.m.Dude.setTitle("the Animal");
				_event.m.Dude.getBackground().m.RawDescription = "%name% was \'saved\' by you during a confrontation with an animal tamer-turned-enslaver. A sense of gratitude and debt overcomes any language barriers: the once imprisoned wildman serves the company loyally for rescuing him.";
				_event.m.Dude.getBackground().buildDescription(true);

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Wildman2",
			Text = "[img]gfx/ui/events/event_100.png[/img]You don\'t think the imprisoned wildman would fit in with the company, but you do set him free nonetheless. He shoots out his cage like a banshee and runs for the tree line. There he stands at a distance hooting and hollering until he runs off again.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I guess that\'s his way of saying thanks.",
					function getResult( _event )
					{
						return "Animals";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_100.png[/img]%monk% the monk steps forth, hands clasped, head borrowed forward. The embodiment of a sermon, the posture of good morals, or misguided ones. He pulls the tamer aside.%SPEECH_ON%The old gods would frown upon what you have done here.%SPEECH_OFF%The animal tamer laughs and leans against the cage, smugly crossing his arms. He states that in the south they consider slavery a part of the natural order. The monk continues.%SPEECH_ON%True, but neither you nor this wildman are kin to their way of life. You wish to enslave him by means of his being an outsider. He does not understand the relationship which makes it especially grievous and improper. My suggestion is to have him work for you and learn from you. Make him a friend and you will have a friend for life-%SPEECH_OFF%The imprisoned wildman\'s hands dart through the bars and digs his fingers into his eyeballs. His face is ripped apart like a loaf of old bread, a couple of coathangers for a jawbone, a tongue lolling like an uprooted snake. %monk% vomits as his face is doused in blood. %otherbrother% shakes his head.%SPEECH_ON%I\'d say he\'d fit right in with the %companyname%...%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Absolutely disgusting. He\'s perfect.",
					function getResult( _event )
					{
						return "Wildman1";
					}

				},
				{
					Text = "No, he\'s clearly far too dangerous.",
					function getResult( _event )
					{
						return "Wildman2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				_event.m.Monk.worsenMood(1.0, "Shaken by the violence he witnessed");

				if (_event.m.Monk.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Animals",
			Text = "[img]gfx/ui/events/event_47.png[/img]Well, the animal tamer is gone and with him there\'s no one left to take care of the beasts. %randombrother% comes up and asks what should be done with them.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let them out.",
					function getResult( _event )
					{
						return "AnimalsFreed";
					}

				},
				{
					Text = "Slaughter them all.",
					function getResult( _event )
					{
						return "AnimalsSlaughtered";
					}

				},
				{
					Text = "Leave them.",
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
			ID = "AnimalsFreed",
			Text = "[img]gfx/ui/events/event_27.png[/img]You feel it just wouldn\'t be right to leave them out here to starve to death and a caged creature no doubt has gamey meat when it comes to harvesting. You decide to let them on out of their cages. Most of these strange creatures make a beeline for the treeline, but two remain behind: a husky dog and a hooded falcon, both seemingly looking for a master.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'ll both fit right in.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/accessory/falcon_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez a " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "AnimalsSlaughtered",
			Text = "[img]gfx/ui/events/event_14.png[/img]It\'d be a crime to leave these animals out here to starve and rot. And it\'d also be a terrible waste of good meat. You have the creatures slaughtered. It\'s an easy, albeit brutal job, stabbing and slicing a bunch of hapless critters and beasts. The bear is the last to go, and it does not go easily. It manages to drag %hurtbro% close for a nasty swipe, but beyond that your men put it to a slow, grisly death. The rest of the wagons are turned over and looted.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Not a bad haul.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				_event.m.Other.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Other.getName() + " suffers light wounds"
				});
				local money = this.Math.rand(200, 500);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
				item = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_wildman = [];
		local candidate_monk = [];
		local candidate_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.wildman")
			{
				candidate_wildman.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (!bro.getSkills().hasSkill("injury.missing_eye"))
			{
				candidate_other.push(bro);
			}
		}

		if (candidate_other.len() == 0)
		{
			return;
		}

		if (candidate_wildman.len() != 0)
		{
			this.m.Wildman = candidate_wildman[this.Math.rand(0, candidate_wildman.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		this.m.Other = candidate_other[this.Math.rand(0, candidate_other.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"wildmanfull",
			this.m.Wildman != null ? this.m.Wildman.getName() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"monkfull",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"hurtbro",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"taskedbro",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.Monk = null;
		this.m.Other = null;
		this.m.Dude = null;
	}

});

