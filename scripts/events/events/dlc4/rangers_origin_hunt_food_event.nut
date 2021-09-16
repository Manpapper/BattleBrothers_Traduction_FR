this.rangers_origin_hunt_food_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.rangers_origin_hunt_food";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]{Being the collection of hunters that you are, it becomes readily apparent that you\'ve entered some fine hunting grounds. %randombrother% suggests the company go for a hunt, though he warns the group should be mindful of just how much they pluck from these bountiful stretches.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s hunt!",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 70)
						{
							return "C";
						}
						else if (r <= 90)
						{
							return "B";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "There\'s time for this later.",
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
			Text = "[img]gfx/ui/events/event_10.png[/img]{The men are ordered to go on a hunt and they take an inch a mile! They shoot and strip and slaughter just about everything breathing animal in range. You\'re wary of this leading to the attention of local nobles, but they are none the wiser. Inventory stores will be brimming!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A good hunt.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain Venison"
				});
				local item = this.new("scripts/items/loot/valuable_furs_item");
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
			Text = "[img]gfx/ui/events/event_10.png[/img]{A few of the men depart on the hunt and return with a couple of kills. You ask if they ran into any trouble and they shake their heads no. Looks like the inventory will see some tasty additions and no nobleman will be any wiser!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A decent hunt.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain Venison"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{An hour or so after sending the men off on a hunt, they return. Except they\'re dragging a bloodied and shredded %bearbrother% back into camp. They report the group had crossed paths with a momma brown bear. Her fight was tremendous, and she only stopped mauling the wounded poacher because one of the men threatened her babies with a torch. You\'re happy the men are all alive, albeit %bearbrother% is going to require a long time to recover.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This mercenary work is dulling our senses.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Hunter.addInjury(this.Const.Injury.Accident3);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Hunter.getName() + " suffers " + injury.getNameOnly()
				});
				this.Characters.push(_event.m.Hunter.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.rangers")
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest && currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Hunter = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bearbrother",
			this.m.Hunter.getName()
		]);
	}

	function onClear()
	{
		this.m.Hunter = null;
	}

});

