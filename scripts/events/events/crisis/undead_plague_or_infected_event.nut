this.undead_plague_or_infected_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.undead_plague_or_infected";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]You come across a group of peasants sitting by the edge of the path. Men, women, children. Dirtied clothes, muddied boots, sores on their skin. A few carry wounds shaped like bitemarks. The eldest of the party speaks.%SPEECH_ON%Please, sir, do you have any food or water to give us?%SPEECH_OFF%He seems to see you eyeing the pustules and bitemarks. He shakes his head.%SPEECH_ON%Oh, don\'t mind those. Simple fox huntin\' gone awry. We could just use a bit of help and then we can be on our way.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We can spare a bit of food.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
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
					Text = "This isn\'t our problem.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "You\'ll only make the undead ranks swell. Better we finish you now.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_59.png[/img]You command these sickened souls to be well - by commanding your men to kill them all. The elder leads the women and children away while the men rise up to stand their ground. One, wavering on green and peeling legs, points at you.%SPEECH_ON%What a saint you are ya prick. I hope I do come back from the dead. I hope my corpse kills the lot of you ya farkin\' savages.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I look forward to killing you twice, then.",
					function getResult( _event )
					{
						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.PeasantsArmed, this.Math.rand(50, 100), this.Const.Faction.Enemy);
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
			Text = "[img]gfx/ui/events/event_59.png[/img]You tell %randombrother% to hand out some food and supplies. The elder thanks you and says he\'ll speak highly of the %companyname% wherever he goes. A few of the men seem relieved that you didn\'t ask something awful of them.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We do what we can.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local food = this.World.Assets.getFoodItems();

				for( local i = 0; i < 2; i = ++i )
				{
					local idx = this.Math.rand(0, food.len() - 1);
					local item = food[idx];
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You lose " + item.getName()
					});
					this.World.Assets.getStash().remove(item);
					food.remove(idx);
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_29.png[/img]You tell %randombrother% to hand out some food and supplies. The elder thanks you and says he\'ll speak highly of the %companyname% wherever he goes. Taking a piece of bread, you squat beside a sickly child and the father holding him. But when you hold the loaf out, the child turns its head up and bites into his father\'s neck. Any peasant healthy enough to stand does so and runs off. The rest... well, the rest shamble to their feet, faces pale, jaws slacked, eyes glowing red with furious hunger. You quickly order the mercenaries into formation.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No good deed goes unpunished.",
					function getResult( _event )
					{
						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Peasants, this.Math.rand(10, 30), this.Const.Faction.PlayerAnimals);
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.ZombiesLight, this.Math.rand(60, 90), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
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
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local food = this.World.Assets.getFoodItems();

		if (food.len() < 3)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = currentTile.getDistanceTo(t.getTile());

			if (d <= 4)
			{
				return;
			}
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

