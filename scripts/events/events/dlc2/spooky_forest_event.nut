this.spooky_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Brave = null,
		Lumberjack = null
	},
	function create()
	{
		this.m.ID = "event.spooky_forest";
		this.m.Title = "During camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]While camping in the woods, %randombrother% calls you out of the command tent. You ask what it is he wants and he pushes a finger to his lips in a silent shush. He points up a tree which grows tall into the evening darkness. You hear cracks as though something were making a nest out of branches whole. The noisemaker only pauses to snort and chortle in a quick tittering of guttural chirps, like a bird crying for help from the belly of a snake. When you look back down, the men are staring at you, looking for an idea as to what to do about this event.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s just some animal. Get back to doing your jobs.",
					function getResult( _event )
					{
						return "WalkOff";
					}

				},
				{
					Text = "Better safe than sorry. We\'ll cut down the tree.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "CutdownGood";
						}
						else
						{
							return "CutdownBad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Lumberjack != null)
				{
					this.Options.push({
						Text = "%lumberjack%, you know well how to bring down trees. Do it.",
						function getResult( _event )
						{
							return "Lumberjack";
						}

					});
				}

				if (_event.m.Brave != null)
				{
					this.Options.push({
						Text = "%bravebro%, you\'re the bravest of the lot. Go see what this is about.",
						function getResult( _event )
						{
							return "Brave";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Lumberjack",
			Text = "[img]gfx/ui/events/event_25.png[/img]You order %lumberjack% the lumberjack to bring the tree down. He nods and gets to work, using a host of tools available, not all of which are axes. He plies the wood open in a divot on one side and jams the gaps with the helves of weapons and then goes to the other side and chops away at its trunk. He works with the sort of speed you\'d love to see on the battlefield. It\'s the sort of authenticity one rarely sees in life, a man home at his work, his eyes settled on modeling an undeniable future, his hands hardly assigned to the task so much as born for it.%SPEECH_ON%Ay-yo!%SPEECH_OFF%He yells out and the tree is felled. It cracks and slumbers down the heft and tilts into the forest where its long stock falls through the wickets and slams the ground so hard it seems to ache the very earth. Drawing your sword, you go to investigate the felled treetop. You find a pair of Nachzehrers there, smashed flat, teeth skittered to the forest floor like capless shrooms. The company\'s fear is settled by the grisly sight.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "So that mystery is solved.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lumberjack.getImagePath());
				local item = this.new("scripts/items/misc/ghoul_teeth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Brave",
			Text = "[img]gfx/ui/events/event_25.png[/img]%bravebro%, the ever brave sellsword, clambers up the tree with speed not to be erred by fear or reluctance. You\'d think they spotted a fair maiden up in those parts the way he\'s going. It isn\'t long until he\'s gone, though the scratch \'n\' scratch of his noisy ascent is unmistakable. Finally you hear him returning, the clutter of his descent coming in stops and starts as he finds safe footing. You see him break back into view, the soles of his boots first to appear like butter trays dangling in the dark. His shadowy silhouette follows, sliding ever downward until he makes a last leap to the earth. He intentionally buckles at the knees and rolls back against the tree trunk with his tired hands limp across his knees.%SPEECH_ON%T\'was a black bear head deep in a honeycomb, but the beast been dead at least two days. I saw a group of bats skitter on out when I approached, I think they was eating its insides. This tumbled on out when they fled.%SPEECH_OFF%He turns and throws a sword upon the ground. It\'s covered in sticky honey and pinestraw, but otherwise looks like a remarkable blade.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s see that blade.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brave.getImagePath());
				local item = this.new("scripts/items/weapons/arming_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain an " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "CutdownGood",
			Text = "[img]gfx/ui/events/event_25.png[/img]You order the company to chop the tree down. They get to the task, though there\'s little experience in doing it and the end result is a frantic run for safety as the trunk comes barreling down in an unexpected direction. A very frightened black bear bolts off the treetop. It has a honeycomb for a snout and huffs its way into the dark of the forest.\n\n No one is crushed, but the chaos and debris leaves a few of the men worse for the wear.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, that was a worthwhile endeavour...",
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
					if (bro.getSkills().hasSkill("trait.swift") || bro.getSkills().hasSkill("trait.sure_footed") || bro.getSkills().hasSkill("trait.lucky") || bro.getSkills().hasSkill("trait.quick"))
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 20)
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
			ID = "CutdownBad",
			Text = "[img]gfx/ui/events/event_25.png[/img]You order the men to cut the tree down. %randombrother% starts in with a heavy thwack. He plants a foot on the trunk to wrench the tool free and that\'s about the last you see of him as he goes flying away. A tree branch swings back into view with a long groan emanating from the trunk as though some ancient wood were being felled inside its very body. You watch as the wood cracks loose of the soil and uproots itself. Emerald eyes flare and widen, their stare blinkered by the twists of falling leaves.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What the hell!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.Entities = [];
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Schrats, this.Math.rand(90, 110), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
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
			ID = "WalkOff",
			Text = "[img]gfx/ui/events/event_25.png[/img]You can\'t be bothered by such trivial nonsense. It\'s likely to be a lynx or an eagle of some sort. If it\'s worse, it\'ll come on down and the company will deal with it then. This line of thinking doesn\'t sit well with some of the men.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s just some animal...",
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
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.worsenMood(0.5, "Concerned that you didn\'t act on a possible threat");

						if (bro.getMoodState() <= this.Const.MoodState.Neutral)
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 15)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_lumberjack = [];
		local candidates_brave = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.lumberjack")
			{
				candidates_lumberjack.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.brave") || bro.getSkills().hasSkill("trait.fearless"))
			{
				candidates_brave.push(bro);
			}
		}

		if (candidates_lumberjack.len() != 0)
		{
			this.m.Lumberjack = candidates_lumberjack[this.Math.rand(0, candidates_lumberjack.len() - 1)];
		}

		if (candidates_brave.len() != 0)
		{
			this.m.Brave = candidates_brave[this.Math.rand(0, candidates_brave.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"lumberjack",
			this.m.Lumberjack ? this.m.Lumberjack.getNameOnly() : ""
		]);
		_vars.push([
			"bravebro",
			this.m.Brave ? this.m.Brave.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Lumberjack = null;
		this.m.Brave = null;
	}

});

