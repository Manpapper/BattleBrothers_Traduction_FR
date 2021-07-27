this.religious_peasants_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.religious_peasants";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]The forests have always been a refuge for man - the wilds from whence he came, to the wilds where he always wishes to return. And here you find a great number of men, a tribe of the lost, unconcerned with their departed civilizations, draped in religious habits, and carrying great sigils of faith, and tomes of truth. They\'re impoverished almost to the point of being decadently fashionable, like great kings looking to fit in with commoners. You sit and watch this shuffle by, clinking, clanging, hollow wooden beads rattling, whispers under their breath, raspy and dry. And so they go on, hardly even bothering to look at you.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Let\'s see where they\'re going.",
					function getResult( _event )
					{
						if (_event.m.Monk != null)
						{
							local r = this.Math.rand(1, 3);

							if (r == 1)
							{
								return "B";
							}
							else if (r == 2)
							{
								return "C";
							}
							else
							{
								return "F";
							}
						}
						else
						{
							local r = this.Math.rand(1, 2);

							if (r == 1)
							{
								return "B";
							}
							else
							{
								return "C";
							}
						}
					}

				},
				{
					Text = "Probably best to leave them be.",
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
			Text = "[img]gfx/ui/events/event_03.png[/img]Curious, you call out to the men to ask where they are going. The man in front slowly turns to you, his eyes peering out from the dark of a wrapped shawl. He slowly draws the cloak back, revealing a head scarred in a pattern of religious rites. All the men behind him slowly follow suit, like a row of cards falling by the brush of a chaotic and mad wind.%SPEECH_ON%Davkul shall see you in the next world!%SPEECH_OFF%One of them shouts and they charge.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						this.World.State.startScriptedCombat(properties, false, false, true);
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
			Text = "[img]gfx/ui/events/event_12.png[/img]{Obviously, this isn\'t an ordinary sight for you so, curious, you call out to the weary travelers. Words barely leave your lips before the entire line of men stops in an instant and bolts upright. Their cloaks unravel and droop from their heads, and their tomes and sticks and religious imports fall aside in a uniform clatter. The men look around, wide eyes more alive than ever. One screams. Then another. And soon they are all screaming, and some crumple to the ground, clutching their ears as though to silence the horrid howls their mouths had to give, while others wheel in circles, arms out, begging for answers.\n\n Your mere utterance has seemingly broken a spell that was so long over their heads it had brought them here, impoverished, hungry, and insane. Step by step, they were governed by a malicious higher power, and step by step they felt the control in their lives slip away, and with it the sanity all men require to be themselves. Unfortunately, you can hardly ask them what or who did this to them, for some fall over dead while others make naked sprints into the forest. | A curious sight such as this begs questioning, but the second a word leaves your lips the entire troop of religious men bolt upright, the sudden shuffle of clothes and gear clattering in such uniformity it as if a door was slammed shut. The men drop their things and begin screaming. It is a raspy chorus. They all begin to collapse, either buckling on bony knees or clutching their stomachs in pained hunger.\n\n %randombrother% comes up, shaking his head.%SPEECH_ON%Were they cursed? What could have done this?%SPEECH_OFF%You won\'t ever get an answer for a minute later every single man is dead, looking no better than corpses having recently been thawed out of the mountains. The spell must have forcibly piloted their pilgrimage here, straining the human body while keeping it alive by the mere strand of ethereal malevolence. Although they are all dead, you do not regret freeing them of such a horrid curse.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "May they rest in peace.",
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
					if (bro.getSkills().hasSkill("trait.superstitious") || this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(0.5, "Witnessed a horrible curse");

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
			ID = "F",
			Text = "[img]gfx/ui/events/event_59.png[/img]Curious as to where these men are going, you open your mouth, but %monk% the monk steps forward, cutting you off. He goes to the man in front of the troop and has quiet counsel with him. There is plenty of nodding, hrrumphing, and other gesticulations of men who dwell long on things well beyond the human realm. Eventually, the monk comes back.%SPEECH_ON%They\'re on a pilgrimage and now our name travels with them. Many shall hear of it.%SPEECH_OFF%You thank the monk for a job well done.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "We are for sure damned souls, but they don\'t know that...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
				_event.m.Monk.improveMood(1.0, "Helped spread word about the company");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Monk = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
	}

});

