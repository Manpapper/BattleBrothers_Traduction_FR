this.greenskins_trapped_goblin_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_trapped_goblin";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]The company steps through some brush and into a clearing where they find a goblin squatting. It turns toward the company, its breath labored, its eyes somber. You see that there\'s a large bear trap tightly clenching its lower thigh. The greenskin tries a growl, but only manages to cough some blood.\n\n Beside the dying goblin is a man face down in the grass. There\'s something shiny attached to his hip, but you can\'t quite tell what it is. %randombrother% comes to your side.%SPEECH_ON%Could be a trap. A trap within a trap. The rest of his buddies are probably not far. Then again, if we leave, he might get free and tell everyone we were here. What should we do?%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Kill it.",
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
					Text = "Leave it.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 70)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]One way or another, the goblin cannot be allowed to live. You step into the clearing to put it out of its misery and, perhaps, get a glimpse at what treasures the corpse might carry. The greenskin shrinks at the sight of you, snarling and rearing up, the trap wrinkling the chains to which it is attached. %randombrother%, weapon in hand, carefully gets near to the beast and then kills it with a single blow.\n\n With the threat taken care of, you roll the dead man\'s body over and loot everything worth taking.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "One goblin less to worry about. ",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/named/named_dagger");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/rondel_dagger");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/loot/golden_chalice_item");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/loot/silver_bowl_item");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_69.png[/img]This is a war of annihilation and no greenskin can be allowed to live. You step into the field and slay the foul thing. With it out of the way, you roll the dead man\'s body over and loot all that\'s worth taking. Just as you get ready to leave, a gargling growl rumbles from the treeline. %randombrother% takes out his weapon and points.%SPEECH_ON%Nachzehrers!%SPEECH_OFF%Damn! They must have smelled the dying goblin and came to feast. Some of them are already picking their teeth with orc bones...",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "A bit messier than expected...",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Ghouls, this.Math.rand(70, 90), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/named/named_dagger");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/rondel_dagger");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/loot/golden_chalice_item");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/loot/silver_bowl_item");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_25.png[/img]You\'re not going to risk the company over a single measly goblin and a dead man who may or may not have anything valuable. The company gives a wide berth to the clearing and continue on through the forest without any issue.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Best keep the company in shape for bigger threats.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_48.png[/img]You\'re not going to risk the company over a single measly goblin and a dead man who may or may not have anything valuable. The company gives a wide berth to the clearing and continue on through the forest.\n\n No more than five minutes down the road do you hear a thundering of footsteps coming up from the rear. Loud and burly enough that whoever is making it has no fear of being heard. You duck and wait and, unsurprisingly, orcs and goblins come through the trees. One of them is the bastard you\'d left to the bear trap, his leg hurriedly wrapped in linens and leaves.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Damn, the little runt found us!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_goblins_03"
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(70, 90), this.Const.Faction.Enemy);
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
		if (!this.World.FactionManager.isGreenskinInvasion())
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
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 5)
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

