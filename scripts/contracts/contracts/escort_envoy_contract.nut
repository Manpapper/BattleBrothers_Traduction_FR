this.escort_envoy_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.escort_envoy";
		this.m.Name = "Escort Envoy";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local settlements = this.World.EntityManager.getSettlements();
		local candidates = [];

		foreach( s in settlements )
		{
			if (s.getID() == this.m.Home.getID())
			{
				continue;
			}

			if (!s.isDiscovered() || s.isMilitary())
			{
				continue;
			}

			if (s.getOwner() == null || s.getOwner().getID() == this.getFaction())
			{
				continue;
			}

			if (s.isIsolated() || !this.m.Home.isConnectedTo(s) || this.m.Home.isCoastal() && s.isCoastal())
			{
				continue;
			}

			candidates.push(s);
		}

		this.m.Destination = this.WeakTableRef(candidates[this.Math.rand(0, candidates.len() - 1)]);
		local distance = this.getDistanceOnRoads(this.m.Home.getTile(), this.m.Destination.getTile());
		this.m.Payment.Pool = this.Math.max(250, distance * 7.0 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local titles = [
			"the Envoy",
			"the Emissary"
		];
		this.m.Flags.set("EnvoyName", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.m.Flags.set("EnvoyTitle", titles[this.Math.rand(0, titles.len() - 1)]);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * this.Math.rand(75, 150) * 0.01));
		this.m.Flags.set("EnemyName", this.m.Destination.getOwner().getName());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Escortez %envoy% %envoy_title% à " + this.Contract.m.Destination.getName() + " %direction%"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsShadyDeal", true);
					}
				}

				local envoy = this.World.getGuestRoster().create("scripts/entity/tactical/humans/envoy");
				envoy.setName(this.Flags.get("EnvoyName"));
				envoy.setTitle(this.Flags.get("EnvoyTitle"));
				envoy.setFaction(1);
				this.Flags.set("EnvoyID", envoy.getID());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Destination.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Arrival");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsShadyDeal"))
				{
					if (!this.Flags.get("IsShadyDealAnnounced"))
					{
						this.Flags.set("IsShadyDealAnnounced", true);
						this.Contract.setScreen("ShadyCharacter1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.World.State.getPlayer().getTile().HasRoad && this.Math.rand(1, 1000) <= 1)
					{
						local enemiesNearby = false;
						local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

						foreach( party in parties )
						{
							if (!party.isAlliedWithPlayer)
							{
								enemiesNearby = true;
								break;
							}
						}

						if (!enemiesNearby && this.Contract.getDistanceToNearestSettlement() >= 6)
						{
							this.Contract.setScreen("ShadyCharacter2");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("EnvoyID"))
				{
					this.World.getGuestRoster().clear();
				}
			}

		});
		this.m.States.push({
			ID = "Waiting",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Attendez autour de " + this.Contract.m.Destination.getName() + " jusqu\'à ce que %envoy% %envoy_title% ait terminé"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = true;
			}

			function update()
			{
				this.World.State.setUseGuests(false);

				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && this.Time.getVirtualTimeF() >= this.Flags.get("WaitUntil"))
				{
					this.Contract.setScreen("Departure");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Escortez %envoy% %envoy_title% de nouveau à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				this.World.State.setUseGuests(true);

				if (this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("EnvoyID"))
				{
					this.World.getGuestRoster().clear();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer%\'s got a man standing beside him. You can hardly see his face and when you shift your head to get a better look, he does the same to make sure you don\'t.%SPEECH_ON%Please, mercenary. This is %envoy%. You don\'t need to see him. I just need for you to get him to %objective%. He\'s going there to convince them that our cause is one worth joining. Of course, %enemynoblehouse% won\'t be happy about that, so discretion is of some import.%SPEECH_OFF%You nod, understanding the intricacies of politics between the houses.%SPEECH_ON%Good, mercenary. Now, are you interested?%SPEECH_OFF% | A man, seemingly stepping out of the shadows of %employer%\'s room, comes toward you with his hand jetted forth. You shake it and he introduces himself.%SPEECH_ON%I\'m %envoy% in the employ of %employer% here. We\'ve...%SPEECH_OFF%%employer% steps in.%SPEECH_ON%I need you to guard this man to %objective%. That\'s %enemynoblehouse% territory, obviously, so some secrecy is necessary here. That\'s where you step in. You just need to make sure this man gets there. After that, bring him back and you\'ll get paid. Does that suit your field of work and expertise?%SPEECH_OFF% | %employer% slaps a scroll into your chest.%SPEECH_ON%There\'s a man, an envoy, standing outside my door. His name is %envoy% and he\'s destined to go to %objective% to convince them to join us.%SPEECH_OFF%Taking the scroll, you inquire about the obvious issue at hand: that\'s %enemynoblehouse%\'s fiefdom. %employer% nods.%SPEECH_ON%Yes, it is. Hence why you\'re here and not one of my bannermen. No need to start a war, right? I just need you to get %envoy% there and bring him back. If you\'re interested, let\'s talk numbers then you can give that there scroll to the envoy and be on your way.%SPEECH_OFF% | Looking at a map, %employer% asks if you\'re into politics. You shrug and he nods.%SPEECH_ON%I figured as much. Well, unfortunately, I got something political for you to do. I need you to guard an envoy by the name of %envoy%. He\'s going to %objective% to... well, do tasks of a political nature, convincing the people there to join us, nothing to lose sleep over. Obviously, that\'s not our territory which is why I\'m hiring a faceless man such as yourself. No offense.%SPEECH_OFF%You wave it off. %employer% continues.%SPEECH_ON%Well, if you\'re interested, just get the man there and bring him back. Sounds easy enough, right? You don\'t even have to do any talking!%SPEECH_OFF% | %employer%\'s studies a map, most particularly the colors that indicate where his borders are in comparison to %enemynoblehouse%. He slams his fist on their side of the territories.%SPEECH_ON%Alright, mercenary. I need some sturdy men to guard %envoy%, an envoy of mine. He\'s going to %objective% which, if you know your politics, is not under my control.%SPEECH_OFF%You nod, letting the nobleman know that you understand the implications of what he is asking.%SPEECH_ON%You get him there, he does the talking, and then you bring him back. As far as you\'re concerned, you\'re just a bannerless grunt following him around, got it? So if you\'re interested, let\'s talk payment, shall we?%SPEECH_OFF% | %employer% tosses a scrap of beaten-up paper onto his table, clearly a scroll of bad news.%SPEECH_ON%My daughters are being married off, but I don\'t have enough taxable territories to adequately give them the celebrations they deserve.%SPEECH_OFF%You don\'t care about this and suggest the man get to the point.%SPEECH_ON%Alright, alright. Bullshit aside, I need you to guard an envoy of mine, %envoy%, to %objective%. He\'s going to try and convince them to come under our banner. Now, that little place is %enemynoblehouse%\'s territory and it\'s safe to assume they won\'t be happy to know we\'re footing about their parts. Hence why I am hiring you, faceless sellsword, to be the caretaker of my envoy.%SPEECH_OFF%The man folds his hands into his lap.%SPEECH_ON%Does this little gambit interest you? All you have to do is get him there and back. Easy payday, easy!%SPEECH_OFF% | Reading a scroll, %employer% begins to laugh and then seems unable to stop himself from grinning.%SPEECH_ON%Good news, sellsword! The people of %enemynoblehouse% no longer seem content with their rule!%SPEECH_OFF%You raise an eyebrow and nod facetiously. Scooting his chair up to his desk and perusing a map laid across it, the man continues.%SPEECH_ON%The better news is that I have an envoy by the name of %envoy% going to %objective% today to do some... talking. Obviously, the roads are laden with skeevy thieves and the lords of %enemynoblehouse% are ever skeevier, so this man needs some protection! That\'s where you come in. All you have to do is get him there and back.%SPEECH_OFF% | %employer%\'s got a man standing beside him. He shakes your hand and introduces himself as %envoy%, an envoy of sorts. You inquire as to the import of the man and %employer% is quick to explain.%SPEECH_ON%He\'s going to %objective% - a fiefdom of %enemynoblehouse%\'s, if you don\'t know. We may be able to persuade the people there to come under our rule. Now that you know this man and his mission, surely you understand why I have you here and not one of my bannermen.\n\nI need you to get this man to %objective% and then, when he\'s finished with what he must do, bring him back. After that, you get paid. Are you in?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons argent. | How much is this worth to you? | What will the pay be?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{You\'ll have to find protection elsewhere. | Ce n\'est pas le type de travail que nous recherchons.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Arrival",
			Title = "At %objective%",
			Text = "[img]gfx/ui/events/event_20.png[/img]{You\'ve made it to %objective%. %envoy% %envoy_title% goes into a building, quietly shutting the door behind him. You jack a boot against the wall and wait for him to return. A few peasants come and go. Birds chirp. Been awhile since you paid attention to their songs.\n\nThis could take a while, it seems. Perhaps you should make use of the time by stocking up on supplies for the journey back? | The envoy dips into a council building in %objective%. You got him there safely, now it\'s just time for him to do the rest. For a time, you listen to the talk, leaning against one of the windows and soaking it in. The man\'s got a quick tongue and he\'s rallying the men to his cause better than you and a few swords ever could. The envoy sees you through the window and subtly waves you off. You duck away and wait for him to finish. | A few well-dressed men welcome you into %objective%. They ask %envoy%  %envoy_title% if you\'re with him. He nods and passes a quick whisper to the councilmen. They nod in return and soon all the men dip away into a local pub. You wait outside. Perhaps you should use the time to stock up on supplies for the journey back? | %employer%\'s suspicions that %objective% might turn to his cause appear to be true: the people here are already out in the streets in a great mob. A row of guards stands outside a large building and push back with their spears turned aside. One wealthy man leans out of a window trying to disperse the crowd with words, but their ears are too stuffed with anger. %envoy% slips through the crowds with ease and meets a few councilmen wearing cloaks. They slip into a nearby building and you wait outside. | %objective%\'s looking rather down - peasants in the street, either angry about something or lazy about nothing. Neither\'s a good sign of a healthy community. %envoy%  %envoy_title% walks into a local pub where a group of huddled men cautiously greet him. He waves you off and so you stand outside and wait for him to finish up.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Don\'t take forever. | We\'ll stick around.}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(20, 60) * 1.0);
				this.Contract.setState("Waiting");
			}

		});
		this.m.Screens.push({
			ID = "Departure",
			Title = "At %objective%",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Some time passes before the envoy comes back out. You ask if he had any trouble to which he says no. Time to Retournez à %employer%. | The door opens and the envoy steps out. He tells you to lead the way home. | Soon enough the envoy is back out. He tells you his business is done and that he needs to get back to %employer%. | %envoy% returns to you in a hurry. He tells you that they need to get back to %employer% as soon as possible. | When the envoy returns he says it was a good talk and that you need to get him back to %employer% as soon as possible.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Finally, let\'s get moving! | What took you so long?}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter1",
			Title = "At %townname%",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Just as you\'re leaving town, a man in a cloak comes and talks to you. He keeps his face in the shade of his shawl, all you see are his teeth now and again and the nob of a pointy chin.%SPEECH_ON%When the time comes, will you look the other way, mercenary?%SPEECH_OFF%Before you can answer, he is gone. | While preparing to leave town, a man bumps into you. He doesn\'t apologize, instead he peers out from beneath a long, black cloak.%SPEECH_ON%There will come a time you have to make a decision. Stay and fight, or leave and live to see another day. Gold will follow you on the second road, a shovel will bury you on the first...%SPEECH_OFF%You reach out to grab the man, but he simply steps back, being absorbed into a rush of laymen that just happened to be scurrying by. | As you get ready to leave %townname%, a man in a dark cloak comes to your side. He doesn\'t look at you, just talks.%SPEECH_ON%My benefactor expected you. %employer% was wise to hire you. However, you have a choice and when the time comes... what path will you walk?%SPEECH_OFF%You tell the man to take his omens elsewhere. | A man in black cuts you off as you leave %employer%\'s presence. He glances over your shoulders, then whispers.%SPEECH_ON%%employer%\'s paying you well, but I know someone who\'ll pay even better. Look the other way when the time comes...%SPEECH_OFF%The stranger takes a step back and slips behind a door. When you open it to give chase, he\'s gone. Only a kitchen hand is standing there, looking as if {he\'d | she\'d} seen nothing at all. | With %employer%\'s task in hand, you get ready to head on out. While prepping the supplies, a stranger in a cloak approaches. They talk as if they have gravel in their throat.%SPEECH_ON%Many birds are watching you, sellsword. Take your next steps carefully. You still have a chance to get out of this. When the time comes, we merely ask that you step aside.%SPEECH_OFF%You draw your sword to threaten the man, but he dips away, his fluttering cloak slipping into a crowd of peasants who seem alarmed at your sudden arming.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{This could get interesting... | Looks like trouble is brewing.}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter2",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{While on your way, a group of armed men emerge seemingly out of nowhere to stand in your way. Amongst them is the shady figure you\'d seen earlier. They announce their intention to take the envoy off your hands. In return, you\'ll get a large sum of money - %bribe% crowns.\n\nOtherwise, well, they\'ll have to take him by force... | You\'re just getting into the swing of things - listening to the envoy\'s banter, ignoring it, wishing he\'d just go off into the woods alone to never return - when suddenly a group of armed men surprise you. Standing with them is the stranger that met you earlier. They state that the envoy must be handed over. In return, you\'ll get the sum of %bribe% crowns. If you refuse, well, they\'ll just go ahead and use more violent methods.\n\nAs you mull your options the envoy is, for once, completely silent. | Marching on the road, a group of armed men come out to stop you. You recognize the stranger from earlier is standing with them. They ask you hand over the envoy, gesturing toward a very large satchel of crowns, the sum of %bribe% crowns they claim. They\'re also gesturing toward their weapons, suggesting they\'ve come prepared to use other means in case you refuse.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Why bleed for crowns when you offer them freely? We have a deal.",
					function getResult()
					{
						return "ShadyCharacter3";
					}

				},
				{
					Text = "If you want him, come and get him.",
					function getResult()
					{
						return "ShadyCharacter4";
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Flags.set("IsShadyDeal", false);
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter3",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{As you mull the thought over, the envoy comes to your side, whispering.%SPEECH_ON%Surely you won\'t let them take me, right? %employer% is paying you good money to ensure my safety.%SPEECH_OFF%You nod, putting a hand on the man\'s shoulder as you whisper back.%SPEECH_ON%You\'re right. He is. But they\'re paying me more.%SPEECH_OFF%With that, you push the man forward. He protests, but it is cut short on the end of a sword. Blood splatters to the ground and when the blade is drawn out a pile of guts follow it. The mysterious stranger hands you a satchel of promised crowns.%SPEECH_ON%Thank you for your business, sellsword.%SPEECH_OFF% | You stare at the envoy and then to the mysterious men, nodding toward them. He clutches your shirt, pleading.%SPEECH_ON%No, you can\'t! You promised %employer% that I would be safe!%SPEECH_OFF%You hand the man off. They slit his throat in an instant and he falls to his knees, fingers wrapped around his wound as blood spews forth. The killers kick him around, the envoy slowly going still as a bunch of men laugh his way into the next world. A satchel lands in your hands and the man who put it there claps you on the shoulder.%SPEECH_ON%Thank you for your cooperation, sellsword. You truly live up to your title.%SPEECH_OFF% | You glance at the envoy and shake your head.%SPEECH_ON%I am a sellsword, and my price is what it is.%SPEECH_OFF%The envoy cries out, but a man walks up with a small crossbow and fires a bolt between his eyes, the rod of it sticking out the back of his head, wrapped in unspooled brain matter. The mysterious man throws you a satchel of crowns.%SPEECH_ON%What was this to all parties involved, a pity, or good graces?%SPEECH_OFF%You count the crowns and answer.%SPEECH_ON%It was both until your man there added some carpentry to the envoy\'s skull. Now it\'s just good graces.%SPEECH_OFF%The mysterious man smiles wryly.%SPEECH_ON%What a pity. I personally like a diversity of opinion. It adds drama, as they say.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Easy crowns. | Everybody wins.}",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", true);
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to protect an envoy");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.updateAchievement("NeverTrustAMercenary", 1, 1);
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter4",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_50.png[/img]{You push the envoy behind you with one arm while the other draws out your sword. The mysterious man nods and slowly fades behind his own battle line.%SPEECH_ON%\'Tis a shame, but my business here must still be pursued. I\'m sure you understand.%SPEECH_OFF% | The mysterious man stretches an arm out, the hand\'s fingers curling as if to reel the envoy away from you. Instead, you push the envoy back behind your battleline. The stranger nods instantly.%SPEECH_ON%Understandable. But not pursuable. We both have our benefactors, sellsword. You must be loyal to yours and I to mine. Let the best of us remain standing to reward those who put their faith in our hands.%SPEECH_OFF% | The envoy pleads with you, but you tell him to shut up before turning back toward the outfit of killers.%SPEECH_ON%The envoy walks out of here alive.%SPEECH_OFF%Nodding, the mysterious stranger simply fades behind his battleline.%SPEECH_ON%I understand. Business is business, and for now, that business must be pursued.%SPEECH_OFF%His men step forward, drawing their swords.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Mercs";
						p.Entities = [];
						p.Parties = [];
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer%, the envoy alongside you.%SPEECH_ON%Ah, sellsword, I see you did as I asked. And you, envoy...?%SPEECH_OFF%%envoy% dips forward and whispers into the nobleman\'s ears. He leans back, nodding.%SPEECH_ON%Good, good. Let\'s talk... Oh, and mercenary, your pay is waiting for you outside. Just ask one of the guards.%SPEECH_OFF%The two men turn and walk away. You go out into the hall and a burly man is there to hand you a satchel of %reward_completion% crowns. | Returning to %employer%, the envoy leaves your side and quickly - and quietly - tells the man some news. %employer% nods, giving away nothing about what said news was, and then snaps his finger at a nearby guard. The armed man steps forward and hands you a satchel. By the time you take it and look up, the nobleman and envoy are gone. | Having kept %envoy% safe, the envoy thanks you for your services. %employer% is not so amicable, instead ignoring you to talk to secretive emissary. While you stand around for pay, a guard sneaks up and slams a wooden chest into your arms.%SPEECH_ON%It\'s %reward_completion% crowns. You can count it if you want.%SPEECH_OFF% | You learn little of what %employer%\'s sneaky little delegate was doing in that town. The envoy and employer greet and immediately talk, huddling close and keeping their voices low. When you step forward to inquire about pay, a guard intercepts you, shoving a satchel into your arms. %reward_completion% crowns are there, as promised. Having no interest in politics, you don\'t stick around long to see what those two men are up to. | %employer% welcomes you with open arms.%SPEECH_ON%Ah, you kept %envoy% safe!%SPEECH_OFF%He hugs the envoy, but only shakes your hand, crossing it with a purse of crowns at the same time.%SPEECH_ON%I knew I could trust you, mercenary. Now, please...%SPEECH_OFF%He gestures toward the door. You depart, leaving the two men to talk.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Crowns well earned.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Safely escorted an envoy");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "After the battle",
			Text = "[img]gfx/ui/events/event_60.png[/img]{The envoy didn\'t make it. %employer% can accept losses here and there, but he\'s not going to be happy about this. Try not to fail him again. | Sadly, %envoy% %envoy_title% is dead at your feet. What a terrible fate for a man promised safety! Oh well. Going into the future, it\'d be best to not keep failing %employer%. | Well, would you look at that: the envoy is dead. Your only job was to keep that man breathing. Now, he\'s not doing that. You needn\'t talk to %employer% to know he won\'t be happy about this. | You promised to keep the envoy safe from harm. It\'s hard to get anymore harmed than being outright dead, so it appears you failed quite spectacularly at this here task. | Guard the envoy. Just keep the envoy alive. The envoy must survive. Hey, I\'m an envoy, I\'m too important to die!\n\n These words must have fallen on deaf ears because the envoy is indeed dead. | It\'s hard to keep a man alive when the world wants him dead. Sadly, %envoy% %envoy_title% did not make his journey. %employer% is unlikely to be happy about this lost soul.}",
			Image = "",
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Damn this!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to protect an envoy");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
		_vars.push([
			"envoy",
			this.m.Flags.get("EnvoyName")
		]);
		_vars.push([
			"envoy_title",
			this.m.Flags.get("EnvoyTitle")
		]);
		_vars.push([
			"enemynoblehouse",
			this.m.Flags.get("EnemyName")
		]);
		_vars.push([
			"direction",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())] : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Destination.getSprite("selection").Visible = false;
			this.m.Home.getSprite("selection").Visible = false;
			this.World.State.setUseGuests(true);
			this.World.getGuestRoster().clear();
		}
	}

	function onIsValid()
	{
		if (this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			local settlements = this.World.EntityManager.getSettlements();
			local hasPotentialDestination = false;

			foreach( s in settlements )
			{
				if (!s.isDiscovered() || s.isMilitary() || s.isIsolated())
				{
					continue;
				}

				if (s.getOwner() == null || s.getOwner().getID() == this.getFaction())
				{
					continue;
				}

				hasPotentialDestination = true;
				break;
			}

			if (!hasPotentialDestination)
			{
				return false;
			}

			return true;
		}
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && _tile.ID == this.m.Destination.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local dest = _in.readU32();

		if (dest != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(dest));
		}

		this.contract.onDeserialize(_in);
	}

});

