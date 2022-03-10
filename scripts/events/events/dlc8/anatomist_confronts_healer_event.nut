this.anatomist_confronts_healer_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Monk = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_confronts_healer";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]{You come into %townname% to find a white bearded and eloquent elder helping a family with their ill child. To you, this sight isn\'t anything unusual. To %anatomist% the Anatomist, however, some great offense is at hand. So quick is his walk across the road to the elder that you jump in front of him, sensing that whatever it is he aims to do might reflect poorly on the %companyname% as a whole. %anatomist% stands up straight.%SPEECH_ON%Excuse me, this man is dispensing poor medical advice. He needs to be corrected.%SPEECH_OFF%Mindful of the natives, you warn him that it can be unwise to try and wedge yourself in on local customs, of which an elder is almost assuredly the spearpoint of. He might be and likely is of even greater import as well, such as overseeing the local militia. The anatomist, however, is rather diligent about the task, and seeks to weaponize his own knowledge and use it even if it tears the local politic apart.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Go on and correct him then.",
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

				},
				{
					Text = "It\'s not worth upsetting the locals.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "%monk%, can you talk some sense into him?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]{You think it over for a time, and decide to let the anatomist do as he pleases. Stepping aside, you turn to watch the goings on, hoping that this won\'t be an event to tarnish the %companyname%\'s name any more than this quack already seems determined to do. %anatomist% sidles next to the old man and they look at each other for a moment, and a few peasants stare over as well. The anatomist pops a squat and asks the old man if he knows that the information he is giving out is incorrect.\n\nSurprisingly, the old man is receptive to the occasion, and the two sit and talk for a long while. Instead of being offended by some outsider\'s input, the townspeople are equally enthralled by any knowledge he might have. There\'s some disagreements about trivial matters, but %anatomist% himself is so warmed by the reception that he handwaves them away and even lies and says those matters are still yet to be medically settled. By the time it is all over, the anatomist hands off some notes to the old man, and the village in turn give him a bevy of treats and goods as thanks.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That went well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Gave medical advice to a receptive audience");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(100, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+100[/color] Experience"
				});
				local food;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					food = this.new("scripts/items/supplies/cured_venison_item");
				}
				else if (r == 2)
				{
					food = this.new("scripts/items/supplies/pickled_mushrooms_item");
				}
				else if (r == 3)
				{
					food = this.new("scripts/items/supplies/roots_and_berries_item");
				}

				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_141.png[/img]{You think it over for a time, and decide to let the anatomist do as he pleases. Stepping aside, you turn to watch the goings on, hoping that this won\'t be an event to tarnish the %companyname%\'s name any more than these quacks already seem determined to do. %anatomist% sidles next to the old man and they look at each other for a moment, and a few peasants stare over as well. The anatomist pops a squat and asks the old man if he realizes he is a charlatan. You put your head in your hands. The old man stands up and pushes the anatomist backward.%SPEECH_ON%And who the fark are you, huh? A traveler with a toolbox of fancy vocabulary, huh?%SPEECH_OFF%The anatomist holds his hands out and plainly explains himself to be an intelligent, very well educated man from- before he can even finish, a peasant comes over and decks him, knocking him right into the mud. The %companyname% jumps in to save the anatomist and in the scuffle a few more blows are exchanged, but thankfully that\'s where it ends. You get %anatomist% back into your ranks and order everyone to settle down before the sellswords-side of the %companyname% is drawn out into the open for all the laity to see. The elder nods and says he wishes not to invite the militia to these affairs. It seems everyone barely escaped a far more gruesome affair. %anatomist% only looks at the blood coming out of his nose and ponders if anyone has been counting time to see how long it takes to coagulate.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn fool.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Had his medical advice rejected");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Anatomist.getName() + " suffers light wounds"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 10)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%anatomist% moves to get past you, but you put your hand to him and hold him where he is. You explain that correcting locals on their own customs and beliefs is dangerous ground to trod on, and as a sellsword you\'re already distrusted and seen in a bad light. The last thing you need is a few embers blown onto the drywood that is villager traditions. The anatomist protests, but you holdfast. If he wants to go around correcting everyone and everything, he can return to the schools or universities from which he came. Eventually, %anatomist% slinks off. You glance back at the town elder just in time to see him bite the head off a frog and pour its blood into a bowl for future divinations.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get on on the road.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied the chance to correct improper medical practice");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_40.png[/img]{As %anatomist% tries to move past you, %monk% the monk intervenes. He stands by the anatomist and calmly explains that just because someone is wrong needn\'t mean that a foreign party step in and correct them. The loss of face in the public\'s eye is not going to end with the individual being corrected, it will merely bring the light of scrutiny back upon the one doing the criticizing. %anatomist% thinks this over for a time.%SPEECH_ON%Are you telling me that the error here is not in the poor advice being given out, but in the community as a whole being so maligned with falsehoods that an entrance of truth would do not all but stoke a fire to protect what they wrongfully believe?%SPEECH_OFF%The monk purses his lips and shrugs.%SPEECH_ON%Sure.%SPEECH_OFF%The anatomist does not combat it any further and walks off, perhaps mulling over some scientific element to the affair. After he is gone, the monk shakes his head.%SPEECH_ON%I just don\'t want him being an arse and getting the %companyname% in more trouble than it needs to be.%SPEECH_OFF%You agree, and thank the monk for putting it in better words than you ever could.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Thanks, %monk%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(0.5, "Learned something about dealing with the peasantry");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(50, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+50[/color] Experience"
				});
				_event.m.Monk.improveMood(1.0, "Stopped " + _event.m.Anatomist.getName() + " from sullying the company\'s reputation");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				local resolveBoost = this.Math.rand(1, 2);
				_event.m.Monk.getBaseProperties().Bravery += resolveBoost;
				_event.m.Monk.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Monk.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
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
		local anatomistCandidates = [];
		local monkCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				monkCandidates.push(bro);
			}
		}

		if (monkCandidates.len() > 0)
		{
			this.m.Monk = monkCandidates[this.Math.rand(0, monkCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() > 0)
		{
			this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"monk",
			this.m.Monk.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Monk = null;
		this.m.Town = null;
	}

});

