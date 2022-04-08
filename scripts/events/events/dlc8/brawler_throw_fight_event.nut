this.brawler_throw_fight_event <- this.inherit("scripts/events/event", {
	m = {
		Brawler = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.brawler_throw_fight";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Without giving you any heads up, it appears that %brawler% the brawler entered a fighting tournament on his own accord, and he\'s already made it all the way to the final match. He has so easily smashed all his opposition in the first round that he is the heavy favorite to win it all.\n\nHowever, a few very powerful betting brokers are upset that %brawler% has already caused them to lose a ton of money. Knowing that he is with you, they have asked that you tell %brawler% to take a fall and throw the match. In return, you\'ll get a percentage of their winnings, which will no doubt be quite substantial...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You need to take a fall.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "He\'s not taking a fall.",
					function getResult( _event )
					{
						local outcome = this.Math.rand(1, 100);

						if (outcome <= 39 + _event.m.Brawler.getLevel())
						{
							return "D";
						}
						else if (outcome <= 80)
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
					Text = "What? There won\'t be a fight at all!",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img]{You order %brawler% to take a fall. As expected, he resists the idea, but you remind him that you are captain to the company, and while brawling is his business, the fact a third party entered into business with you makes the brawler\'s business your business. He sighs and nods.\n\nWhen the fight occurs, %brawler%, as instructed, takes a few hits then \'sells\' a knockout, spinning away from a weak jab. The crowd roars and the underdog cheers and runs around the fighting pit with his hands raised. After the fight, the betting brokers come and give you %reward% crowns for the fall. One looks over at %brawler%.%SPEECH_ON%Gods damned, man, you could have spurred a riot if anyone had been paying attention. You should look into theater training, cause that winning punch wouldn\'t have harelipped a whore. Next time wait for a cross or solid hook would ya?%SPEECH_OFF%The brawler laughs, but it is forced. He has humiliated himself for a few crowns. Somewhere in %townname% you can hear the townspeople cheering the other fighter\'s name.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "He\'ll get over it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.World.Assets.addMoney(400);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]400[/color] Crowns"
				});
				_event.m.Brawler.worsenMood(0.5, "Was told to throw a fight");
				_event.m.Brawler.worsenMood(2.0, "Lost a fighting tournament");

				if (_event.m.Brawler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]{You order %brawler% to take a fall. As expected, he resists the idea, but you remind him that you are captain to the company, and while brawling is his business, the fact a third party entered into business with you makes the brawler\'s business your business. He sighs and nods.\n\nWhen the fight occurs, %brawler% does as instructed and goes down to a single punch. He stares at you from the floor of the fighting pit, and you see a fire in his eyes. You tell him to stay down, but instead he gets up and promptly destroys the other fighter with a flurry of hooks and uppercuts. He wins the fight and is carried out of the arena by the crowd. You try and hurry after them and see where he went, only to find him in an alleyway beaten to a pulp. He grins up at you.%SPEECH_ON%Them bettin\' brokers weren\'t happy, but fark them. They shoulda bet on my pride.%SPEECH_OFF%He falls unconscious.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ve had quite enough betting for now, myself.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				_event.m.Brawler.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Brawler.getName() + " suffers heavy wounds"
				});
				_event.m.Brawler.worsenMood(0.5, "Was told to throw a fight");
				_event.m.Brawler.improveMood(2.0, "Handily won a fighting tournament");

				if (_event.m.Brawler.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_06.png[/img]{You tell the gambling brokers that %brawler% will fight however he pleases. The brokers, not wanting to cross paths with a sellsword, do not argue the issue any further. They simply leave before you can even bet on your own man. Now knowing there is a fight, though, you go and watch as %brawler% completely smashes down %townname%\'s best brawler. The beatdown was so obviously going to happen that everyone bet on %brawler% and there\'s a run on the gambling brokers. Fights break out and some betters and brokers start smashing each other. There\'s no money made out of the fight, but %brawler% is elated to be the champion of %townname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				local resolve_boost = this.Math.rand(2, 4);
				local initiative_boost = this.Math.rand(2, 4);
				local melee_skill_boost = this.Math.rand(1, 3);
				local melee_defense_boost = this.Math.rand(1, 3);
				_event.m.Brawler.getBaseProperties().Bravery += resolve_boost;
				_event.m.Brawler.getBaseProperties().Initiative += initiative_boost;
				_event.m.Brawler.getBaseProperties().MeleeSkill += melee_skill_boost;
				_event.m.Brawler.getBaseProperties().MeleeDefense += melee_defense_boost;
				_event.m.Brawler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative_boost + "[/color] Initiative"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_skill_boost + "[/color] Melee Skill"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_defense_boost + "[/color] Melee Defense"
				});
				_event.m.Brawler.improveMood(0.5, "Was allowed to fight on his own terms");
				_event.m.Brawler.improveMood(2.0, "Handily won a fighting tournament");

				if (_event.m.Brawler.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_06.png[/img]{You tell the gambling brokers that %brawler% will fight however he pleases. Not wanting to get tangled up with a mercenary captain, they simply nod and back off. As expected, %brawler% wins the fight and it is not even close. He\'s the talk of %townname% and you let him go celebrate with the peasants. A few hours pass, though, and you realize you haven\'t seen him in awhile. You venture into town to find him in an alley with smashed knees, his lead hand has been hammered to a pulp, and his eyes are swollen shut. You shout out to him and run over. He picks his head up off the ground.%SPEECH_ON%Captain? Ayy captain, good to hear your voice. Don\'t worry about me. It was worth it.%SPEECH_OFF%He passes out. You carry him back to the company and consider hunting down the brokers, but you know that they wouldn\'t have done such a thing without first preparing to get the hells out of town afterward.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				local injury = _event.m.Brawler.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Brawler.getName() + " suffers " + injury.getNameOnly()
				});
				injury = _event.m.Brawler.addInjury([
					{
						ID = "injury.broken_knee",
						Threshold = 0.0,
						Script = "injury_permanent/broken_knee_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Brawler.getName() + " suffers " + injury.getNameOnly()
				});
				local initiative_boost = this.Math.rand(2, 4);
				local melee_skill_boost = this.Math.rand(1, 3);
				_event.m.Brawler.getBaseProperties().Initiative += initiative_boost;
				_event.m.Brawler.getBaseProperties().MeleeSkill += melee_skill_boost;
				_event.m.Brawler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative_boost + "[/color] Initiative"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_skill_boost + "[/color] Melee Skill"
				});
				_event.m.Brawler.improveMood(0.5, "Was allowed to fight on his own terms");
				_event.m.Brawler.improveMood(2.0, "Handily won a fighting tournament");

				if (_event.m.Brawler.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_06.png[/img]{You tell the gambling brokers that %brawler% will fight however he pleases. The brokers, not wanting to cross paths with a sellsword, do not argue the issue any further. They simply leave before you can even bet on your own man. Now knowing there is a fight, though, you attend the fight. %brawler% starts the bout throwing hooks left and right with zero regard for his opponent\'s skill. Without a single jab to set it up, his opponent shells up and then screams and throws one desperate hook and %brawler%\'s head twists on a swivel, and he falls to the ground unconscious. The crowd goes wild, at least those who didn\'t just lose a pile of crowns. One of the bettors walks over to you as he counts his money. He grins.%SPEECH_ON%Best go fetch yer boy.%SPEECH_OFF%}",
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
				this.Characters.push(_event.m.Brawler.getImagePath());
				local injury = _event.m.Brawler.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Brawler.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Brawler.improveMood(0.5, "Was allowed to fight on his own terms");
				_event.m.Brawler.worsenMood(2.0, "Got badly beaten in a fighting tournament");

				if (_event.m.Brawler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_64.png[/img]{You shock both parties with an announcement that %brawler% won\'t be fighting at all. The brokers wipe their brows and sigh. They\'ve lost a great deal of money, but at least now there\'s some vague reason to stop the bleeding. As for %brawler%, he is wildly upset with your decision. You explain to him that the %companyname% needs all its fighters in the best shape for actual mercenary work. You can\'t risk his health in some bodunk championship brawl.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "There\'ll be plenty of other opportunities to fight, %brawler%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				_event.m.Brawler.worsenMood(2.0, "Was denied participation in a fighting tournament");

				if (_event.m.Brawler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local brawler_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.brawler" && !bro.getSkills().hasSkill("injury.severe_concussion") && !bro.getSkills().hasSkill("injury.broken_knee"))
			{
				brawler_candidates.push(bro);
			}
		}

		if (brawler_candidates.len() == 0)
		{
			return;
		}

		this.m.Brawler = brawler_candidates[this.Math.rand(0, brawler_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 3 * brawler_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brawler",
			this.m.Brawler.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"reward",
			400
		]);
	}

	function onClear()
	{
		this.m.Brawler = null;
		this.m.Town = null;
	}

});

