this.fake_witchhunter_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.fake_witchhunter";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{You come across a man surrounded by a crowd of angry and drunk peasants. The surrounded man is wearing a black hat and has a crossbow at his side and a finger on the trigger. Nearby stands a pyre with a post in the middle, and tethers missing someone to shackle. The crowd shouts and hollers and through their spit and froth you piece together what had occurred: the town hired a witch hunter and, as one belligerent peasant explains, the hunter found the witch and decided she wasn\'t a witch at all and let her go. The peasant stumbles around almost crying.%SPEECH_ON%And that ain\'t right, it just ain\'t right. We built this pyre and everythin\' to see the fires have her. It just ain\'t right, but we\'ll make it right. Because we sure as hells gonna burn something ain\'t that right!%SPEECH_OFF%The crowd roars. It appears this supposed witch hunter committed one of the worst crimes that is out there: boring the laity.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We have to intervene.",
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

				}
			],
			function start( _event )
			{
				if (_event.m.Witchhunter != null)
				{
					this.Options.push({
						Text = "%witchhunter%, do you know this man?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "This doesn\'t concern us.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_43.png[/img]{You step forward and explain the rules of an agreement, explaining that surely the village hired the man to kill a witch, and if the person they directed him toward was not a witch, then he cannot kill her. If he still went ahead and did so, then he\'d be compelled to act on account of crowns. If he decided not to kill her, and the village rescinded its agreement, then he\'d later be compelled to simply do the bidding of every village to prevent that situation from happening again. Through a series of gentle explanations you show that the village is in danger of displaying for all that it is untrustworthy, and that by the virtue of the example it sets it will only be set upon by charlatans and miscreants with aims on their gold and not on completing a task as asked. And, if anything, the hunter\'s refusal to burn an innocent shows the strength of his character.\n\nWhen you\'re finished, the crowd mostly agrees, but then someone says \'burn him anyway!\' and everyone roars back into a rage. Turning around, though, they find the witch hunter slipped out while you were giving your spiel. The peasants start blaming one another for not keeping an eye on him. Arguments quickly descend into fighting and you make your leave. When you hit the edge of town, you run across the man of the hour. He thanks you with a count of crowns. You find it very unusual that a man would part with money when he could have simply left. He tips his black hat and says he doesn\'t do this witch hunting business for the money.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What a strange man.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(75);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]75[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_141.png[/img]{You step forward shouting and waving your hands. The crowd slowly quiets down and turns around to pay you mind. Using a careful choice of words, you explain that there\'s a commerce to honest dealings, that if one pays crowns to hire someone, and then they turn their back on that someone because of a change of predicaments, then they\'re only setting themselves up to be an untrustworthy village that no one will want to deal with, and before you can finish your spiel someone hurls a rock just over your head and another man runs forward screaming and drives a pitchfork into the witch hunter\'s chest. Total chaos breaks out and you and the %companyname% fend off the rabid peasants and get out of there as fast as you can.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Farkin\' peasants.",
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
			Text = "[img]gfx/ui/events/event_141.png[/img]{%witchhunter% comes forward. He says the man in the black hat is a known fraud in witch hunting circles.%SPEECH_ON%We\'ve been looking for this man for some time as his lies sully the name of our profession. I\'ve long been looking for a chance to get this scalp.%SPEECH_OFF%Before you can say another word, %witchhunter% walks through the crowd and emerges on the other end with one of the peasant\'s pitchforks in hand and promptly drives it through the faux hunter\'s leg. The man bends over screaming. The faux hunter wheels up with the crossbow, but %witchhunter% catches it by the barrel and rides it upward where the shot harmlessly launches into the sky. He yanks the crossbow away, yelling that it does not belong to him, and he announces to the crowd that the man is a charlatan. He throws him to the ground, telling the crowd to do whatever it is they wish. They descend on the liar, though the extent of torture is hard to see through the excited ranks of laity. %witchhunter% returns with the crossbow, turning it one way and another. It is the most incredible weapon you\'ve seen in some time. The witch hunter explains.%SPEECH_ON%This belonged to a guildmaster in the region. We believe this fool murdered him, took his clothes, and has been walking around pretending the part ever since. If his screams disturb you, captain, just remember he has burned countless innocents and stolen countless crowns from the desperate and confused. Fark him.%SPEECH_OFF%You stare over the man and into the crowd. You can just make out the man being hoisted onto the pyre and the early smoke of fires getting their start.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get back on the road.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local item = this.new("scripts/items/weapons/named/named_crossbow");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]{While the goings on of a drunken lynch mob is the preferred form of peasant entertainment, you smell a bit of danger in the air and move the %companyname% to the edge of town. You just never know when these things get out of hand and the laymen start laying hands on everyone in sight.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get out of here.",
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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();
		local foundTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(currentTile) <= 3)
			{
				foundTown = true;
				break;
			}
		}

		if (!foundTown)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getTime().Days <= 25)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_witchhunter = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter" && bro.getLevel() >= 4)
			{
				candidates_witchhunter.push(bro);
			}
		}

		if (candidates_witchhunter.len() != 0)
		{
			this.m.Witchhunter = candidates_witchhunter[this.Math.rand(0, candidates_witchhunter.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
	}

});

