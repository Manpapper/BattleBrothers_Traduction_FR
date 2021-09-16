this.march_wear_and_tear_event <- this.inherit("scripts/events/event", {
	m = {
		Tailor = null,
		Other = null,
		Vagabond = null,
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.march_wear_and_tear";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Marching all around the world has put some wear and tear on the men. Whenever a mercenary takes off a boot you can see the blood seeping through his sock. They\'ve accumulated sores and boils. One man peels the flesh off his toe and says he regrets doing that and you nod. All in all, this is the price to pay for being on the road so much.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Suck it up.",
					function getResult( _event )
					{
						return "End";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Tailor != null)
				{
					this.Options.push({
						Text = "Maybe we can fashion some fresh wrappings from what we\'ve got?",
						function getResult( _event )
						{
							return "Tailor";
						}

					});
				}

				if (_event.m.Vagabond != null)
				{
					this.Options.push({
						Text = "You\'ve traveled the world, %travelbro%. Suggestions?",
						function getResult( _event )
						{
							return "Vagabond";
						}

					});
				}

				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "Wait. %streetrat%, you look like you have something to say?",
						function getResult( _event )
						{
							return "Thief";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "End",
			Text = "%terrainImage%{The next stop ain\'t far. You hope the men can keep it together until they get there. What bandages you have are applied as necessary.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Put your boots back on.",
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
					if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.messenger")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}

				local amount = brothers.len();
				this.World.Assets.addMedicine(-amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Medical Supplies."
				});
			}

		});
		this.m.Screens.push({
			ID = "Tailor",
			Text = "%terrainImage%{%tailor% the tailor rubs his chin with two fingers. He finally points them forward.%SPEECH_ON%I\'ve got it. Gentlemen, give me every scrap of unused or trashy clothing you have. Every article you got. Hand it over. There you go. Yes, that\'s absolutely trash, %otherbrother%. Your favorite shirt? By the gods, just give it to me already. Thank you.%SPEECH_OFF%The tailor collects armfuls of discarded clothing and gets to work with his scissors. He slices and dices and pauses. He pauses a lot, always unsure of his work. But finally he presents the results. A pile of fresh socks and enough left over scraps to furnish some extra bandages. He\'s also wearing a surprisingly flashy new garb that you\'ve no clue how he created.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Now that\'s a magician if I\'ve ever see one.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Tailor.getImagePath());
				_event.m.Tailor.improveMood(1.0, "Fashioned himself something nice from cloth scraps");

				if (_event.m.Tailor.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tailor.getMoodState()],
						text = _event.m.Tailor.getName() + this.Const.MoodStateEvent[_event.m.Tailor.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();
				local amount = brothers.len();
				this.World.Assets.addMedicine(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Medical Supplies."
				});
			}

		});
		this.m.Screens.push({
			ID = "Vagabond",
			Text = "%terrainImage%{When it comes to walking the earth, %travelbro% is longer in the tooth than anyone. He laughs at the plight of his fellow sellswords.%SPEECH_ON%Ah, now this is what I\'m talking about! Nevermind the pain, men, embrace the soreness!%SPEECH_OFF%The company collectively tells him to stuff it, but the roadman happily wiggles his toes around. You didn\'t even realize he had his boots off before that, his feet are so calloused you thought the bony figures but folds of leather!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Put your damn boots back on.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Vagabond.getImagePath());
				_event.m.Vagabond.improveMood(1.0, "Enjoyed life on the road");

				if (_event.m.Vagabond.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Vagabond.getMoodState()],
						text = _event.m.Vagabond.getName() + this.Const.MoodStateEvent[_event.m.Vagabond.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.messenger")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}

				local amount = brothers.len();
				this.World.Assets.addMedicine(-amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Medical Supplies."
				});
			}

		});
		this.m.Screens.push({
			ID = "Thief",
			Text = "%terrainImage%{%thief% the thief sidles up to you. Stepping away and putting your hands in your pockets, you ask what he wants. He smirks and answers.%SPEECH_ON%Alright I\'ll be honest with you, captain. Last time we stopped in town I helped myself to a blind peacemaker\'s wares. What? I\'d a sore tooth. No reason to pay to fix what the old gods gave me. Anyway, I fixed my tooth. See? What a smile, right? But then I thought I felt some aches, man, aches all over the place! So I visited the peacemaker again and...%SPEECH_OFF%You interrupt the man and ask just how much he stole. He produces a sack of medicinal goods. He proudly puts his hands to his hips and stare out at the world with his crooked grin.%SPEECH_ON%Suffice it to say I ain\'t hurtin\' no more.%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What were were fighting about again?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addMedicine(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]-" + amount + "[/color] Medical Supplies."
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		if (this.World.Assets.getMedicine() < brothers.len())
		{
			return;
		}

		local candidates_tailor = [];
		local candidates_vagabond = [];
		local candidates_thief = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.tailor")
			{
				candidates_tailor.push(bro);
			}
			else
			{
				candidates_other.push(bro);

				if (bro.getBackground().getID() == "background.thief")
				{
					candidates_thief.push(bro);
				}
				else if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.messenger")
				{
					candidates_vagabond.push(bro);
				}
			}
		}

		if (candidates_tailor.len() != 0 && candidates_other.len() != 0)
		{
			this.m.Tailor = candidates_tailor[this.Math.rand(0, candidates_tailor.len() - 1)];
			this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		}

		if (candidates_vagabond.len() != 0)
		{
			this.m.Vagabond = candidates_vagabond[this.Math.rand(0, candidates_vagabond.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"tailor",
			this.m.Tailor != null ? this.m.Tailor.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"travelbro",
			this.m.Vagabond != null ? this.m.Vagabond.getName() : ""
		]);
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Tailor = null;
		this.m.Other = null;
		this.m.Vagabond = null;
		this.m.Thief = null;
	}

});

