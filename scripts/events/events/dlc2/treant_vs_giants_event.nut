this.treant_vs_giants_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.treant_vs_giants";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_107.png[/img]{%randombrother% wrinkles his calf into a hole in the forest floor and curses with frustration.%SPEECH_ON%For farks sake as if my dogs weren\'t barking enough!%SPEECH_OFF%You turn to tell him to keep it quiet when suddenly you see an unhold scrambling up the forested hillside the company just climbed. Whereas you all struggled to ascend, the giant is hurdling upward and scrambling the incline, leaving small landslides in its wake. Before you can call it out, an enormous tree swerves down from a crowd of its still brethren and clotheslines the giant. A ball of spit zips through the forest breaking branches and brush and the giant slams its back to the forest floor and even at this distance it rumbles the ground beneath your feet. You see more unhold giants coming and more schrats unweaving themselves from the camouflage of the forest to do battle with them. It\'s a schrat against unhold no holds barked brawl!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prepare to attack.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Let\'s get the hell out of here.",
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
			Text = "[img]gfx/ui/events/event_107.png[/img]{You crouch low and order the men to come forward and to do so quickly. They march past like ants as leaves and mats of hair sputter down from above and the violence of the giants claps against your ears like lightning. But you do manage to get out of there and leave the war of the monsters behind.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A close call.",
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
			Text = "[img]gfx/ui/events/event_107.png[/img]{You draw your sword, but %randombrother% puts his hand on your shoulder.%SPEECH_ON%Really, captain?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Yes, really.",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.UnholdBog, 100, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Schrats, 100, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				},
				{
					Text = "On second thought, no.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 25)
			{
				return false;
			}
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

