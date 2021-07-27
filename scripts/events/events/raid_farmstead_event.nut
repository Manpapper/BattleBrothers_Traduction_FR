this.raid_farmstead_event <- this.inherit("scripts/events/event", {
	m = {
		SomeGuy1 = null,
		SomeGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.raid_farmstead";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_72.png[/img]%randombrother% comes to you with a report of your food stocks. He explains that there\'s not much to go around and what bread is on hand could be better used to build a house or slay a man. Most of the fruit is soft to the touch, covered in what appears to be grey fur. All that\'s left otherwise has been thrown into a great stew which the men have aptly named \'crotch broth\'. To be frank, it isn\'t looking good.\n\nHowever, by some fortuitous coincidence, a small farm stands in the distance. The brother doesn\'t come right out and say it, but it is gently suggested that maybe the company could go raid it.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We raid it.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We move on.",
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
			Text = "[img]gfx/ui/events/event_72.png[/img]You head off toward the farm. A few farmhands straighten up in the fields, staring at you as you approach and exchanging glances with one another. A worker baling hay plants his pitchfork in the ground and tents his hands over it. They all watch you with nervous curiosity as you cross the plains, your men not at all trying to hide their want of the passing crops.\n\nWhen you near the homestead, a woman comes out to meet you. She wipes her brow and asks what it is that you want. A few children come out of a nearby home and stand on the porch. They eye you tentatively behind the legs of an older man, possibly the woman\'s father.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Take only what is needed.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Take everything.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Take everything. Kill everyone.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_72.png[/img]You explain to the woman that your men need food. She gasps, but you hold a hand up.%SPEECH_ON%We\'ll only be taking what we need, no more, no less. We don\'t want any trouble, and I know you for sure don\'t want any. Right?%SPEECH_OFF%The woman quickly nods. You turn \'round and order your men to take a few crops, while at the same time the woman raises her voice and tells the farmhands to not try anything stupid. The whole affair lasts about ten minutes before your group is back on the road.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "It had to be done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local food;
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				this.World.Assets.updateFood();
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_72.png[/img]The food here is plentiful. You turn around to your men and tell them to take everything they can. Gasping, the woman steps back and looks about ready to scream. You grab her, bringing a string of cries from the children. A few farmhands grab sickles and pitchforks in turn. You tell her to order the rest of the farmhands to put their weapons on the ground. She obeys, and the farmhands do as told, albeit somewhat reluctantly.\n\nYou hold the woman while your men take what they can. When they\'ve pillaged as much as they can carry, you let her go and order your men to move out.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We deserve as much.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local food;
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				food = this.new("scripts/items/supplies/goat_cheese_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				this.World.Assets.updateFood();
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_30.png[/img]There\'s plenty of food here. And too many witnesses.\n\nYou turn around and give a knowing glance at %someguy1%. He nods back and nocks an arrow. Before the woman can scream, the brother releases the shot and the old man on the porch stumbles backward into the house, followed by a retinue of screaming children. The rest of your company fans out, unsheathing their swords as they run into the fields. A few farmhands try to fight back, but your well-armed band makes short work of them. %someguy2% sprints into the homestead and inside you hear a number of cries that, one by one, disappear until there is silence. You hand the woman off to a few brothers, telling them to just make sure she is dead before you leave. A few other sellswords immediately begin cutting down crops and stealing away items from the home. Before long, you\'re back out on the roads, your stocks now almost full. A few brothers are taking red rags to their wet blades.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "No one left to tell what happened here.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-5);
				local food;
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				food = this.new("scripts/items/supplies/smoked_ham_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				food = this.new("scripts/items/supplies/goat_cheese_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				this.World.Assets.updateFood();

				for( local i = 0; i < this.Math.rand(1, 2); i = ++i )
				{
					local pitchfork = this.new("scripts/items/weapons/pitchfork");
					this.World.Assets.getStash().add(pitchfork);
					this.List.push({
						id = 10,
						icon = "ui/items/" + pitchfork.getIcon(),
						text = "You gain a " + pitchfork.getName()
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.bloodthirsty"))
					{
						bro.improveMood(1.0, "Enjoyed raiding and pillaging");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(1.0, "Was appalled by the company\'s conduct");

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
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Plains && currentTile.Type != this.Const.World.TerrainType.Farmland)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getFood() > 50)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 5)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.bloodthirsty") || !bro.getBackground().isOffendedByViolence())
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local x = 0;
		local y = 0;

		while (x == y)
		{
			x = this.Math.rand(0, candidates.len() - 1);
			y = this.Math.rand(0, candidates.len() - 1);
		}

		this.m.SomeGuy1 = candidates[x];
		this.m.SomeGuy2 = candidates[y];
		this.m.Score = 30;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"someguy1",
			this.m.SomeGuy1.getName()
		]);
		_vars.push([
			"someguy2",
			this.m.SomeGuy2.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.SomeGuy1 = null;
		this.m.SomeGuy2 = null;
	}

});

