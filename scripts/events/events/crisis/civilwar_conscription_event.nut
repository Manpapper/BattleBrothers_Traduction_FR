this.civilwar_conscription_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_conscription";
		this.m.Title = "At %town%";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Soldiers of %noblehouse% are trying to conscript the locals. The peasants, understandably, want no part of the war and are refusing to go willingly. A lieutenant of the bannermen, his men clearly understaffed for this situation, asks you for help. | You come across a throng of peasants shouting down a few soldiers of %noblehouse%. They state that they will not take part in the wars between noble houses.%SPEECH_ON%What have the lords done for us!%SPEECH_OFF%One man asks to the cheers of many. A lieutenant barks back.%SPEECH_ON%He has graced you with his land, so that you and your families may prosper!%SPEECH_OFF%An old man spits back.%SPEECH_ON%Wasn\'t that old cunt\'s land. It wasn\'t nobody\'s land until that fark said so. And why? Because he fooled some armored gits into thinking he was right?%SPEECH_OFF%The crowd cheers ever louder.%SPEECH_ON%You\'ve already taken many from us, so be gone already! If their lives couldn\'t solve your noble squabbling, than what is taking the last of us to do?%SPEECH_OFF%The lieutenant turns to you and asks for help, as though you might be particularly persuasive in getting people to die for causes they could care less about. | A busy throng of peasants is cluttering the roadway that passes through %town%. As you get closer, you realize that a group of bannermen from %noblehouse% are trying to conscript the laymen and, clearly, it is not a fight those people wish to partake in. Not having enough men to handle the situation by himself, the soldiers\' lieutenant turns to you.%SPEECH_ON%Ah, mercenary. Would you please kindly get these runts to come with us? The noblemen will hear of your deed...%SPEECH_OFF% | Seemingly every villager is standing out in the road that snakes through %town%. Pushing your way through the crowd, you come to a small group of bewildered and scared soldiers of %noblehouse%. Their lieutenant has his hands up, a scroll dangling from one.%SPEECH_ON%These are not my orders, but I intend to carry them out!%SPEECH_OFF%A peasant spits.%SPEECH_ON%Yeah, carry them to the grave!%SPEECH_OFF%Seeing you, the lieutenant pleas for your help.%SPEECH_ON%Sellsword! We require soldiers for the great war between noble houses... These... fools, are not following orders. The order of the lords! Help us with this and I will personally ensure that the nobles hear of your work here.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Very well. You need to pull your weight, peasants!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);

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
					Text = "This isn\'t their fight, lieutenant.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);

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
					Text = "This isn\'t our fight at all.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_43.png[/img]{While this is not your fight, and has almost nothing to do with you, you can\'t help but feel that goodwill with the nobles will pay off in the future. With that in mind, you order your men to start rounding up the peasants, separating the young from the old, and the weak from the strong. Seeing as how your men look like they\'d have no inhibitions about cutting down the common folk, the common folk go right along with your orders. The lieutenant plucks a few from this \'batch\' \'and pushes them onto the road. He thanks you greatly for your work and says the nobles will hear of the %companyname%. | Unsheathing your sword, you command the peasants to order themselves from strong to weak. You glance at the lieutenant.%SPEECH_ON%Women?%SPEECH_OFF%He shakes his head. You return to the crowd.%SPEECH_ON%Men only! Strongest to weakest. Get to it.%SPEECH_OFF%With scattered grumbles and meaningless weeping, the laymen follow the order. The lieutenant informs you that the nobles will hear of your doings here.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Glad to be of service.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Helped conscript some peasants");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "Helped conscript their populace");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_60.png[/img]{This isn\'t your war, but you\'ve little doubt that gaining good favor with the nobles will help you down the road. You order your men to start separating the crowd, plucking the strongest from the weak. But the peasants don\'t cooperate - a stone goes spiraling past your face. %randombrother% charges into the crowd and stabs the assailant through the chest. A few laymen retaliate, bringing out pitchforks and torches. The rest of the %companyname% draws weapons and, after a few quick slayings, the crowd settles. You look around for the lieutenant, but he and his men are nowhere to be seen. | Drawing out your sword, you order the village to start lining up, strongest to weakest. Instead, an old man rallies them with poorly timed anti-war sentiments. %randombrother% walks over to the fool and uncorks a punch to silence him right into the mud. Sadly, this only pisses the crowd off more and a great melee breaks out. Your mercenaries are merciless, cutting down anyone who dares stand against the company. After it\'s all said and done there are dead and dying in the mud, all tended to by women with confused and saddened faces, and the lieutenant and his soldiers are nowhere to be seen.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "That went south quick.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Cut down their populace");
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
					{
						candidates.push(bro);
					}
				}

				local numInjured = this.Math.min(candidates.len(), this.Math.rand(1, 3));

				for( local i = 0; i < numInjured; i = ++i )
				{
					local idx = this.Math.rand(0, candidates.len() - 1);
					local bro = candidates[idx];
					candidates.remove(idx);

					if (this.Math.rand(1, 100) <= 50)
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

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_43.png[/img]{You turn to the lieutenant.%SPEECH_ON%This isn\'t our fight, and if you can\'t get a few good men to fight for ya, maybe it isn\'t your fight either. Go home.%SPEECH_OFF%The lieutenant fixes his armor and straightens up.%SPEECH_ON%With or without you, they\'re coming with us.%SPEECH_OFF%Just as he finishes, a stone pangs off his head, knocking him unconscious. Two of his soldiers rush to his side and start pulling him away. One spits your way.%SPEECH_ON%Don\'t think we\'ll forget this.%SPEECH_OFF%You nod at the lieutenant.%SPEECH_ON%Yes, you\'d best remember, because he sure won\'t.%SPEECH_OFF% | The lieutenant crosses his arms as if to say \'well?\'. You shake your head.%SPEECH_ON%Get someone else to muscle peasants. If you can\'t do it yourself, maybe your side isn\'t fit enough to win in the first place?%SPEECH_OFF%He huffs and steps up, meeting his chest with yours. A few peasants approach from all sides, suddenly armed with pitchforks and scythes. The lieutenant glances at your unexpected reinforcements, then back at you. He steps off.%SPEECH_ON%Alright, I suppose that\'s how it\'s going to be. The nobles will hear of your faults here, mercenary.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Go fark yourself.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "Prevented their men from conscripting peasants");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Saved their populace from being conscripted");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]{You tell the lieutenant you\'ll have no part of his roaringly unsuccessful recruiting campaign. He nods and draws his sword, his men following suit.%SPEECH_ON%Alright then, if we won\'t take these gits by the hand, we\'ll take them by the neck. Anyone who denies the right of the lords\' call dies here today.%SPEECH_OFF%The crowd shrinks back with the ruffling of poor clothes and timid murmurs. %randombrother% glances at you.%SPEECH_ON%Sir, should we do something? That peacock over there is gonna get a lot of people killed over his pride.%SPEECH_OFF% | The lieutenant taps his boot.%SPEECH_ON%Well, are you gonna help or not?%SPEECH_OFF%You look at the crowd, barefooted and ragged, though a few strong men stand amongst the weak, like trees beside a frail fence. Turning back to the lieutenant, you shake your head no. He shrugs.%SPEECH_ON%Alright men. We sure as shit aren\'t going back without them. We\'ll go back with their heads if we have to!%SPEECH_OFF%The man draws his sword and soldiers follow suit. The crowd rears back like a cloud of flies shooed %randombrother% comes to your side.%SPEECH_ON%Should we do something? These idiots are outnumbered, but they\'ll no doubt get a lot of people killed as they go to their moronic deaths.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "We stay out of this.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "We help the bannermen!",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "We help the peasants!",
					function getResult( _event )
					{
						return "H";
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
			Text = "[img]gfx/ui/events/event_02.png[/img]The nobles\' war wasn\'t your fight. Wrangling up peasants wasn\'t your fight. And stopping soldiers from slaughtering laymen isn\'t your fight either. You tell the brothers to stand aside.\n\n Predictably, the soldiers charge into the crowd, swords swinging, maces clubbing. A few good laymen go down, having nothing to stop the onslaught, but the sheer number of peasants quickly overwhelms the lieutenant and his men. A couple of children push a hovel\'s chimney over and the rain of stones crushes a soldier into the mud. As the rest of the soldiers pause, a farmer runs up and impales one with a pitchfork and lifts him skyward as though he were a bale of hay. The lieutenant breaks and flees, but he\'s tripped up by a pair of women who descend upon him with shearing knives.\n\n After it\'s all said and done, many villagers and every single soldier is dead. Victorious, the townspeople drag the bannermen into the trees and hang their bodies for further mutilation. The mercenaries thank you for not needlessly getting involved.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Well. Let\'s move out.",
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
			ID = "G",
			Text = "[img]gfx/ui/events/event_94.png[/img]There\'s a choice to be made here - stand with the powerless commoners, or go with the violent ambassadors of those who wield power like the goblet of a drunk wench. Of the two, you figure the latter might serve a greater purpose in the future. You order the %companyname% to stand with the soldiers. It\'s a quick battle, one which ends with the peasants fleeing across the fields and women begging for the wounded to not be executed. Their pleas are not heard.\n\n Cleaning his blade, the lieutenant thanks you for saving him and his men.%SPEECH_ON%That wasn\'t the smartest decision I could have made, but for some reason I knew you\'d step in to help out. Been awhile since I had a good day of killin\'. Thanks, sellsword. The nobles will hear of your deeds here.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Glad to be of service.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Helped their men conscript some peasants");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Cut down their populace");
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
					{
						candidates.push(bro);
					}
				}

				local numInjured = this.Math.min(candidates.len(), this.Math.rand(1, 3));

				for( local i = 0; i < numInjured; i = ++i )
				{
					local idx = this.Math.rand(0, candidates.len() - 1);
					local bro = candidates[idx];
					candidates.remove(idx);

					if (this.Math.rand(1, 100) <= 50)
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

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_87.png[/img]Ah, powerless commoners standing up against the boot of the amoral nobility. You stand with the poorer of the two assholes. As soon as the soldiers clash with the peasants, you order the %companyname% to swoop in behind the bannermen and clean up. Each soldier is swiftly stabbed in the back. You take care of the lieutenant yourself, slicing a dagger across his neck. He turns around, clutching his mortal wound in an attempt to mend the unmendable. Seeing you, his eyes go wide and confused, as though he\'d never expected a sellsword to betray him. He coughs out a surge of crimson and then falls to his knees and backward into the mud.\n\n An elderly man slowly approaches as you clean your blade. He thanks you for saving the village, small it may be, and promises to spread word of your - apparently - \'saintly\' reputation.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Did we do good here?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Killed some of their men");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Saved their populace from being conscripted");
				this.World.Assets.addMoralReputation(4);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 1)
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

		this.m.NobleHouse = bestTown.getOwner();
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
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Town = null;
	}

});

