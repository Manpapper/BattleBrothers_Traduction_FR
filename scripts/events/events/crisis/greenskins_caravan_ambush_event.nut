this.greenskins_caravan_ambush_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_caravan_ambush";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Cresting a small hill, you see a caravan of people along the road. They\'re trundling down the path with pots and pans clinking along the wagon sides, children swinging their legs off the edges, women at the front bidding the draught animals forward with sharp whippings. Men march together, looking at a map and arguing over it, gesticulating in different directions to show a difference in geographic opinion. And then, further up the road, beyond the travelers\' eyes, are a few goblins laying in the grass. %randombrother% sees them, too, and comments.%SPEECH_ON%We\'d best get down there now, sir, before there\'s a slaughter.%SPEECH_OFF%%randombrother2% shrugs.%SPEECH_ON%Or... we let the goblins make their move, then we swoop in and clean up the mess. Easier to fight them when they\'re tangled up, no?%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "We attack now!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We wait for the goblins to attack first, then we charge!",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "We don\'t need to get involved in this. March on!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_48.png[/img]{You won\'t sacrifice these innocent people for tactical advantage! You order the men to attack now. The goblins immediately hear you come and turn face. In the distance, the peasants clear out, seeing the danger ahead. It appears you\'ve saved them, but now you\'ll have to face the goblins in whole!}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GoblinRaiders, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
						_event.registerToShowAfterCombat("AftermathB", null);
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
			ID = "AftermathB",
			Text = "[img]gfx/ui/events/event_83.png[/img]{With the goblins taken care of, the peasants slowly bring their wagons back around. They look at the scene with plenty of awe. One shakes your hand.%SPEECH_ON%By all the old gods, everyone we meet shall hear the name of the %companyname%!%SPEECH_OFF%A few others give you food, kisses, and plenty of thanks.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "It was nothing, honest.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
				this.World.Assets.addMoralReputation(3);
				local food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_60.png[/img]{You order the men to wait for the right moment.\n\n When the peasants march further down the road, the goblins waylaid them with a volley of poison arrows. The arguing men go down, arrows stuck in their chests, muscles stiffening, faces drawn taut as the poison courses through. A few other men grab the reins from their wives and steer the wagons around. Some stand guard, a bunch of pitchfork-carrying farmers for a  rearguard, but they don\'t last long in the face of the dishonorable gobbos. Seeing that the goblins are scattered in their attack, you order the %companyname% to begin its own ambush.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GoblinRaiders, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Peasants, this.Math.rand(40, 50) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.PlayerAnimals);
						_event.registerToShowAfterCombat("AftermathC", null);
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
			ID = "AftermathC",
			Text = "[img]gfx/ui/events/event_83.png[/img]{The scattered remains of the traveling peasants slowly emerge out of the strewn battlefield. An old man shakes your hand.%SPEECH_ON%Thank ye, sir, had you not happened upon us we would have all been green-meat!%SPEECH_OFF%But before he can let your hand go, another, younger man springs over, pointing with a finger.%SPEECH_ON%To hell with that, old man, I saw that bastard up on the hill just watching the whole time! He left us out as bait!%SPEECH_OFF%The old man yanks his hand back.%SPEECH_ON%Well I\'ll be. May you experience all the hells, sellsword!%SPEECH_OFF%Like you give a shite. You tell the old man that anything you find is yours. If they want to protest, they can stick their mouth on the end of a blade for all you care.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Piss off, peasants.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
				this.World.Assets.addMoralReputation(-2);
				local food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				local item = this.new("scripts/items/weapons/pitchfork");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain a " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_75.png[/img]{One way or another, this isn\'t your problem. You quietly leave the scene, though a few brothers are rather disturbed that you left those poor peasants to such a gruesome fate, particularly when the whole realm is trying to survive these green savages.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Get over it.",
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
						bro.worsenMood(1.0, "Disappointed that you avoided battle and let peasants die");

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
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
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
			if (t.getTile().getDistanceTo(currentTile) <= 6)
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

