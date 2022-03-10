this.ruined_priory_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ruined_priory";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{You come across a monk standing before a priory. The walls of the building have been shattered, slabs of stone splintering out of the foundations, smaller stones turned to powder in the ensuing collapse. He explains that an earthquake shunted the place entirely, breaking chunks off and nearly bringing the whole place to the ground. He sighs.%SPEECH_ON%The worst of it isn\'t just the material damage, the worst of it is that the earthquake shook the faithful themselves, loosening their reserve for the suffering which is inherent in our day to day. They\'ve not yet returned to me, for they fear that the old gods have chosen our grounds as a point of punishment for some heretofore unrealized error.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We have gold. Could you rebuild with 2500 crowns?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "B" : "C";
					}

				},
				{
					Text = "We have tools. I think 40 should be enough?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "D" : "E";
					}

				},
				{
					Text = "This isn\'t our problem.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_40.png[/img]{You pay the monk monies to fix up the priory. He breaks into tears, saying that he did not expect such men of honor to even exist in this world, much less come and meet him personally. The very fact that you are here, and that you are so giving, is surely a sign that the old gods are not punishing him.%SPEECH_ON%Not only will these crowns allow me to rebuild, but such generosity will be seen by the locals as a sign that the old gods are not in fact punishing us! Here, please take this. It just barely survived the rubble, but perhaps you\'ll be able to make more use of it in time than we ever could.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "All in a day\'s work.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(6);
				this.World.Assets.addMoney(-2500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]2500[/color] Crowns"
				});
				local item = this.new("scripts/items/weapons/noble_sword");
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(60, 80) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.improveMood(0.75, "The company helped restore a priory");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "The company helped restore a priory");
					}

					if (bro.getMoodState() > this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 11,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You put your hand on the monk\'s shoulder. He looks back, tears in his eyes, then glances at the purse of crowns you\'re holding out. He takes it and holds it tenderly as though he\'d never been gifted anything in his whole life.%SPEECH_ON%Is this...is this for the priory?%SPEECH_OFF%Nodding, you tell him to use it to rebuild the place. You start to suggest maybe also adding a modest belltower, but just as you start in with the poor architectural references, a man comes screaming down the road, his finger pointing, his feet beating a mean path.%SPEECH_ON%Don\'t trust that rat! He\'s a no good beggar!%SPEECH_OFF%When you look back, the supposed monk who was at the priory steps is already running off, sprinting down the road before jumping through a cut of nettles and disappearing into some brush and trees, money in hand and his cackling in the air. The man coming down the road throws his hands up.%SPEECH_ON%That squirrely wretch has been playing woe is me for weeks now. This here buildin\' is dead and gone, not been occupied since the greenskins wrecked it ten years ago. I know you was just lookin\' to do right, but there are many in this world who see your generosity as a big bullseye to aim for. S\'ry you got scammed, fellas.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fark.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-2500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]2500[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" && this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "The company had its kindness taken advantage of");
					}
					else
					{
						bro.worsenMood(0.75, "The company was duped out of crowns by a charlatan");
					}

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

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_85.png[/img]{You believe the %companyname% has the tools and manpower to complete the task themselves. Smiling, you tell the monk that they will set forth and rectify the rectory. The holy man is beside himself as you and the Oathtakers gather up their equipment and start the fixing. It takes a few hours, but the blood and sweat is worth it. By the time you are finished, a throng of peasants have appeared, and they leave not only with the old gods on their minds, but the %companyname% being carried on their tongues. No doubt many will hear of the Oathtakers for days to come!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "As it should be.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(6);
				this.World.Assets.addBusinessReputation(100);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
				this.World.Assets.addArmorParts(-40);
				this.List.push({
					id = 11,
					icon = "ui/icons/asset_supplies.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]40[/color] Tools and Supplies"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.improveMood(1.0, "Helped repair a damaged priory");
					}
					else
					{
						bro.improveMood(0.75, "Helped repair a damaged priory");
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 11,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_40.png[/img]{You grab the monk and pull him to his feet. You tell him that the %companyname% will repair the priory. He is tearful and happy, though warns that it might be beyond saving. Smiling, you tell him nothing is too great a task for the Oathtakers. A moment later, %randombrother% pushes on the busted wall only for the bottom half to spill inward and the top parts to spill out, promptly burying him in a pile of rubble. The company shouts in horror and goes to pull him out, and as they do the rest of the building collapses, folding unto itself in a stream of powdered stone. %randombrother% is rescued from the debris, albeit with a fair share of injuries.%SPEECH_ON%Well, I suppose it\'s the thought that counts.%SPEECH_OFF%The monk says, scratching the back of his head.%SPEECH_ON%Perhaps the old gods truly did seek to punish us here. But no matter, I think you still did right, and there is dignity in the attempt, is there not? I shall speak well of you, %companyname%.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That could have gone better.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				this.World.Assets.addBusinessReputation(35);
				local brothers = this.World.getPlayerRoster().getAll();
				local injuredBro = brothers[this.Math.rand(0, brothers.len() - 1)];
				injuredBro.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = injuredBro.getName() + " suffers heavy wounds"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_64.png[/img]{You decide that this venture is not yours to have. This choice has a few of the men questioning your leadership. Sure, the Oaths can\'t all be followed at all times, but to not even spare a drop of sweat or ounce of crown to help a holy man and his flock? It is in skipping over the little things, the things that require no effort at all, that a man can find himself spiraling into being an uncaring savage.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Yeah, yeah.",
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
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(0.75, "You refused to help a monk in need");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "You refused to help a monk in need");
					}

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

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Assets.getMoney() < 3000)
		{
			return;
		}

		if (this.World.Assets.getArmorParts() < 40)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

