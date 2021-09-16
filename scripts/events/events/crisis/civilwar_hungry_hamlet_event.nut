this.civilwar_hungry_hamlet_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_hungry_hamlet";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]{While traveling the roads, you come across a small hamlet with, apparently, it\'s entire populace standing outside. Their leader steps forward, hands out, pleading, though with hardly the strength to keep his hands clasped together.%SPEECH_ON%Please, would you help us? We have been without food for almost a week now. We\'re down to eating dirt! You have to understand, we have nothing! The war has ravaged us all.%SPEECH_OFF% | A small hamlet emerges beside your travels, little more than a cursory wink were it not for the large band of villagers standing outside seemingly awaiting you. Their leader steps forward.%SPEECH_ON%Mercenary, I know you are probably not the one to ask for this, but do you have any food to spare? The war has ravaged our crops and the soldiers that roam the land have taken what else there is to take! Please, help us!%SPEECH_OFF% | The roads lead you to a small hamlet. Villagers are squatting outside their hamlets, heads between their knees, looking thin and grey. Children are with them, frail and wiry, yet with the glow of youth still in their eyes. The town\'s leader comes to you personally.%SPEECH_ON%Sir... sellsword? Yes, sellsword. Please, we\'ve been without food for a week now. We\'ve been surviving on our pets, insects... even the dirt. Do you have anything to help us?%SPEECH_OFF% | As your men take a rest beside the road, villagers from a nearby hamlet come to you. They bumble forward, wiry legs shambling them from side to side. The head of the group raises and lowers a hand as though to bless your presence.%SPEECH_ON%Oh sellsword, mercenary, please, do you have anything to eat? We\'ve yet to have a bite in two days! And what we have eaten are things not to be said aloud! The war between nobles has ruined this place, but maybe you can help?%SPEECH_OFF%}",
			Characters = [],
			Options = [
				{
					Text = "Alright, let\'s give those poor folks some food.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(3);
						local r = this.Math.rand(1, 3);

						if (r == 1)
						{
							return "B";
						}
						else if (r == 2)
						{
							return "C";
						}
						else if (r == 3)
						{
							return "D";
						}
					}

				},
				{
					Text = "Find your own way, peasants.",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Against typical mercenary judgment, you elect to give the poor villagers some food. %randombrother% is told to disperse what he can, although obviously not too much. The people are forever grateful, swarming the sellsword as though he was about whisper an immense and unforgettable truth. The leader of the small town says he will spread word of your goodwill. You\'re actually not sure if news of altruism is good for a mercenary band... | Shocking the villagers, you order %randombrother% to hand out some food. Not too much, just enough that these people can eat. And obviously, don\'t give away anything too good!\n\n The leader of the town comes to you, shaking hands clapping your shoulders.%SPEECH_ON%You\'ve no idea what this means to us! All shall hear of the good in the...%SPEECH_OFF%He glances at you and then your banner. You nod.%SPEECH_ON%The %companyname%.%SPEECH_OFF%The man laughs.%SPEECH_ON%Of course! Everyone shall hear of the %companyname%!%SPEECH_OFF%}",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Shall they fare better in the coming days.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.distributeFood(this.List);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Goodness gets the better of you: you order %randombrother% to start handing out food. He complies, but as soon as he starts handing it out, the crowd goes nearly rabid, snatching it from one another. Fiery tempers are quickly fed by the air of empty bellies. The mercenary tries to maintain order, but anything he says only spurs the hungry masses into thinking it\'s all his fault. The violence spills over, ironically spilling all the food into the mud. Your brothers have to draw swords and by the end of it some peasants lay dead while the survivors look at the corpses with cannibalistic eyes.\n\nYou quickly order the %companyname% to move on before this gets any worse. | For some reason, perhaps to sleep better at night, you order %randombrother% to hand out parcels of food. He\'s just getting started on the process when a villager quickly snatches a sack of foods. Another peasant stoves that man\'s head in and takes the sack for himself. This quickly erupts into a total free-for-all and your mercenaries have to draw weapons to protect the rest of the stores. By the end of the scuffle a few laymen lay dead and your brothers are a little marked up. Seeing no reason to hang around, you order the company to get back on the road. The leader who asked for your help is spotted in the distance, staring out at the horizon as a bitter wind curls his thin pantaloons about his shins.}",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "That went south real fast.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.distributeFood(this.List);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_79.png[/img]Well. This world is a terrible place and if you can do a little to relieve it of its horrid nature, why not? You order %randombrother% to start doling out food, but not too much, and nothing that your tastes will miss. But as he goes about the business, a few soldiers waving the %noblehouse% banner show up. They sift through the hungry crowd, taking food and drawing swords whenever someone resists. Their supposed leader speaks out.%SPEECH_ON%This food is needed by the arm of %noblehouse%. Do not resist its seizure.%SPEECH_OFF%You explain to the man that it is in fact your food and you just handed it out.%SPEECH_ON%If it\'s your food, why is it in their hands? Go along, men, take all that you can! And don\'t try anything, sellsword, or there will be violence.%SPEECH_OFF%%randombrother% glances at you as if to say, what should we do?",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "This is our food and we decide what we do with it!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				},
				{
					Text = "That\'s our food, but this ain\'t our fight.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.distributeFood(this.List);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_79.png[/img]The lieutenant turns back to his men, directing them in their thievery. You draw your sword and hobble over, the pain in your side still lingering, but it doesn\'t take much effort to sneak up on a man. With a quick blade about his neck, you call out to the rest of his men.%SPEECH_ON%Is it violence you really want?%SPEECH_OFF%Holding his hands up, the lieutenant squeaks out some words.%SPEECH_ON%Wait, wait, hold on. I think we, uh, made a mistake. This is the wrong village, fellas.%SPEECH_OFF%You nick him with the sword before releasing him. The peasants rejoice as the food goes back to them. No doubt, the nobility will hear of your \'good\' deeds done here, but so will the common man.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Sometimes being stupid feels good.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "You threatened some of their men");
				this.World.Assets.addMoralReputation(3);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_79.png[/img]You grab the lieutenant by the shoulder and pull him close. He grabs you arm and throws you off, going to draw his sword in the same motion. You jump to his side, blocking the draw, and in turn pull a quick dagger and plunge it into his neck. His soldiers come scrambling through the crowd, but your mercenaries cut them down and the peasants finish them off with sheer brutality only hunger can create. The lieutenant slowly slides down from your grip. You stare down at his blackening eyes.%SPEECH_ON%Yes, there will be violence.%SPEECH_OFF%The peasants cheer the results, though you recommend they bury the bodies or, even better, not be here anymore. No doubt an army will wonder where these men went.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "We should also get going.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "You killed some of their men");
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = bro.getName() + " suffers " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_79.png[/img]You inform your men to stand down. The commonfolk wail as their food is taken from them again. It is a horrid cry and many damn you, stating they\'d rather you have never shown up at all than be tortured in this manner. | Giving food is one thing, quarreling with soldiers is another. You inform the soldiers that there will be no fight and that they can carry on. The laymen cry out, begging you to put a stop to it. Some are too weak to say anything, this sudden turn of events having been a bigger blow than any long weeks of hunger.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Sorry...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Assets.addBusinessReputation(-this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company loses renown"
				});
			}

		});
	}

	function distributeFood( _list )
	{
		local food = this.World.Assets.getFoodItems();

		for( local i = 0; i < 2; i = ++i )
		{
			local idx = this.Math.rand(0, food.len() - 1);
			local item = food[idx];
			_list.push({
				id = 10,
				icon = "ui/items/" + item.getIcon(),
				text = "You lose " + item.getName()
			});
			this.World.Assets.getStash().remove(item);
			food.remove(idx);
		}

		this.World.Assets.updateFood();
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local food = this.World.Assets.getFoodItems();

		if (food.len() < 3)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Score = 10;
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
	}

	function onClear()
	{
		this.m.NobleHouse = null;
	}

});

