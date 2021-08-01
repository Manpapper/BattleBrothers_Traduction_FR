this.more_men_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.more_men";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]The entire company - a motley little crew if you say so yourself - enters your tent all at once. A troupe of sellswords appearing in such a fashion is not the friendliest of sights and so for a split-second you think to reach for your sword. But then you notice that none of them have their weapons out nor do they carry the faces of men about to commit a murder. While they don\'t seem to be forming a mutiny to take your head, you keep the thought in mind nonetheless.\n\n You are only further relieved when they don\'t immediately start talking, instead waiting for your words to come first. This is a show of respect, and so the thought of reaching for your sword grows more distant. Crossing your arms over the table, you ask them what is on their minds.\n\n They explain that the company is too thin. Everywhere they go there is danger and the men are now concerned that every new battle shall be their last. Finally, they state their wants outright: if they are going to survive, they\'re going to need more brothers by their side.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'d hire more men if only we could afford it.",
					function getResult( _event )
					{
						if (this.World.Assets.getMoney() >= 3000)
						{
							return "D";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "E" : "F";
						}

						return "E";
					}

				},
				{
					Text = "We\'ll reinforce the company with new men soon - you have my word.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "There is no need to hire men, we\'re doing fine this way.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]You immediately stand up and rap the table with your knuckles.%SPEECH_ON%The best of minds truly must think alike for I have already set aside some crowns for hiring new brothers!%SPEECH_OFF%The anxious, almost sad faces on the men slowly begin to change. They smile and nod and say things like \'alright\' and \'that\'s good.\' When they turn to leave, you notice they\'ve got daggers sheathed behind their backs.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Time to hire new men.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Unfortunately, you just don\'t agree.%SPEECH_ON%You are some of the finest soldiers I\'ve ever seen. I don\'t think you have anything to fear. Our enemies fear for their own lives when they see you!%SPEECH_OFF%But your words don\'t go over well. One man leans forward with an arm behind his back, but another man claps a hand on his shoulder and quickly shakes his head. He only looks at you and says.%SPEECH_ON%This is most concerning news, sir, but we shall carry on.%SPEECH_OFF%When they turn to leave, you notice the clasp on one man\'s sheathed dagger has been unlatched.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That could be a problem...",
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
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(this.Math.rand(1, 3), "Lost confidence in your leadership");

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
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Fanning your arms out and pressing forth a smile that couldn\'t sell water to a thirsty man, you lie.%SPEECH_ON%We\'ve simply not the coffers to take on more men.%SPEECH_OFF%The men don\'t take it well. One immediately turns around and exits the tent, a wake of curses and swears in the wake of his leaving. Another brother momentarily reaches behind his back. You glance at your sword again. He sees you doing this, and then puts his hands back where you can see them. Finally, he nods.%SPEECH_ON%We\'ll do as told, sir. For now.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That could be a problem...",
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
					bro.worsenMood(this.Math.rand(1, 6), "Was lied to and lost confidence in your leadership");
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]When you let the men know that you\'ve not enough crowns on hand to hire more men, they nod.%SPEECH_ON%We thought you might say that. So here\'s our suggestion, and we don\'t say this lightly, but each of us will give you part of what we saved up for retirement so that you may hire others. And you\'ll pay us back with our wages.%SPEECH_OFF%You quickly glance up, the suggestion seemingly coming out of nowhere.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This is the way we shall do it then - thank you all for your sacrifice.",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "That won\'t be necessary.",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_05.png[/img]You let the men know that you\'ve not the crowns to take on more sellswords. They collectively sigh and nod.%SPEECH_ON%That\'s alright, sir. T\'was only a suggestion. As always, we shall march on your orders.%SPEECH_OFF%The men turn and leave, a little slouched over and quieter than before.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Things will pick up for the company, I\'m sure.",
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
					if (this.Math.rand(1, 100) <= 20)
					{
						bro.worsenMood(1, "Lost confidence in your leadership");

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
			ID = "G",
			Text = "[img]gfx/ui/events/event_05.png[/img]You get up and shake the hands of each man. While you loudly state that you wish it didn\'t come to this, you are secretly beaming at the fact you now have more crowns at your disposal.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s go hire some more men for the company!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(1000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 1000 + "[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.getBaseProperties().DailyWage += 3;
					bro.getSkills().update();
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_daily_money.png",
						text = bro.getName() + " is now paid " + bro.getDailyCost() + " crowns a day"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_05.png[/img]You look the men over. They are solemn creatures, not the ones you last saw grinning and laughing over their latest victory or triumph. While you can\'t yet afford to get them more men, there really is no need to cut their pay.%SPEECH_ON%I appreciate the selflessness and bravery it must\'ve took to suggest such a thing, but I cannot possibly consider myself a man of honor and grant you this request. Your savings shall remain untouched.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I appreciate the offer, nontheless.",
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
					if (this.Math.rand(1, 100) <= 20)
					{
						bro.improveMood(1.0, "Gained confidence in your leadership");

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
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.lone_wolf" || this.World.Assets.getOrigin().getID() == "scenario.gladiators")
		{
			return;
		}

		if (this.World.getTime().Days <= 10)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() == 1 || brothers.len() > 5)
		{
			return;
		}

		this.m.Score = 10;
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

