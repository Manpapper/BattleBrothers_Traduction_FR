this.man_in_forest_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.man_in_forest";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]While traipsing between the trees, a man suddenly emerges from one of the bushes. Twigs and brush are all twisted up in his sweat swept hair. He rears up at the sight of you.%SPEECH_ON%Please, no more.%SPEECH_OFF%You raise your hand to calm him then ask what is going on. The stranger takes a step back.%SPEECH_ON%Please, no more!%SPEECH_OFF%He turns and runs off, thrashing his way back from whence he came. %randombrother% hurries to your side.%SPEECH_ON%Should we follow him?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Follow him, quick!",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 45)
						{
							return "B";
						}
						else if (r <= 90)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "He\'s not our concern. Let him go.",
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
			Text = "[img]gfx/ui/events/event_50.png[/img]You follow the man into the thicket. His muddy footsteps aren\'t hard to track, his ungraceful retreat leaving much evidence. But suddenly, they disappear. The man exited into a clearing and then his tracks are gone. You hear a whistle above you. Looking up, you see the man sitting on a branch. He waves.%SPEECH_ON%Howdy, strangers.%SPEECH_OFF%He glances across the clearing. Men are approaching and they are well armed. The man in the tree snorts.%SPEECH_ON%Goodbye, strangers.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BanditTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.BanditDefenders, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
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
			Text = "[img]gfx/ui/events/event_25.png[/img]The man\'s tracks lead away in the hurry that so frightfully forced him out of your sight. A scared man such as he is not hard to find, unfortunately he\'s not scared anymore, because all you find of him is thoroughly eviscerated corpse.\n\nA slight growl vibrates the nearby bushes. You look over to see slick, black fur slowly stepping out from behind a tree. You yell to the men to arm themselves.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Direwolves, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_25.png[/img]The frightened man was not hard to find. You spot him curled up at the base of a tree. He\'s clutching something to his chest as though he were seeking warmth from it on a cold night. The man himself, however, is dead. You pry the item from his glomming grasp.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What\'s this?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/named/named_dagger");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.SnowyForest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		this.m.Score = 7;
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

