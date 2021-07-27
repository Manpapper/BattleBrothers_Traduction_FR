this.broken_cart_event <- this.inherit("scripts/events/event", {
	m = {
		Injured = null
	},
	function create()
	{
		this.m.ID = "event.broken_cart";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_55.png[/img]While marching down the road, you find a man with a broken cart by the side of the path. By the wagon there is a donkey standing idle and as defeated as a donkey can look. The trader looks a little better than that and your appearance seems to have scared him. He rears up, backing away momentarily.%SPEECH_ON%Have you come to take my things? If so, you needn\'t kill me. Take what you want.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Men, take everything we can use from the cart!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Let us help you get your cart on the road again.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C";
					}

				},
				{
					Text = "We have no time for this.",
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
			Text = "[img]gfx/ui/events/event_55.png[/img]You disarm the man from his fears and order a few of the %companyname%\'s finest to get the wagon back on the road. They make short work of it, the trader looking rather impressed by their efficiency. With his wares back on the road, he offers a few tokens of gratitude right off the wagon itself. These provisions will be useful in the days to come.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Farewell.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveStuff(1);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_55.png[/img]The merchant is scared in your presence, but you quickly disarm him of his fears. A few brothers are ordered to get the cart back onto the path. They do it as fast as hardy men can, but when it\'s over one of them cries out and doubles over.\n\nThe trader, eyes wide with renewed horror, quickly offers you some provisions as a token of his gratitude. Maybe he thinks you\'ll punish him for the injuries? Regardless, the supplies will be a welcome addition for the days to come.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I hope it was worth it.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Injured.getImagePath());
				local injury = _event.m.Injured.addInjury(this.Const.Injury.Helping);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Injured.getName() + " suffers " + injury.getNameOnly()
					}
				];
				this.List.extend(_event.giveStuff(1));
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_55.png[/img]You order the men to search the cart and take what they can. %randombrother% draws his sword and looks ready to slay the donkey, the animal looking stupidly at its own mortality in the reflection of the blade. The merchant cries out and you hold your hand out, staying the execution.%SPEECH_ON%Leave the draught animal where it stands.%SPEECH_OFF%The trader offers meager thanks as a line of your men walk behind him, his very goods in their hands.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Store everything, we\'re moving on.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveStuff(3);
			}

		});
	}

	function giveStuff( _mult )
	{
		local result = [];
		local gaveSomething = false;

		if (this.Math.rand(1, 100) <= 50)
		{
			gaveSomething = true;
			local food = this.new("scripts/items/supplies/bread_item");
			this.World.Assets.getStash().add(food);
			result.push({
				id = 10,
				icon = "ui/items/" + food.getIcon(),
				text = "You gain " + food.getName()
			});
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			gaveSomething = true;
			local amount = this.Math.rand(1, 10) * _mult;
			this.World.Assets.addArmorParts(amount);
			result.push({
				id = 10,
				icon = "ui/icons/asset_supplies.png",
				text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Tools and Supplies."
			});
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			gaveSomething = true;
			local amount = this.Math.rand(1, 5) * _mult;
			this.World.Assets.addMedicine(amount);
			result.push({
				id = 10,
				icon = "ui/icons/asset_medicine.png",
				text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Medical Supplies."
			});
		}

		if (!gaveSomething)
		{
			local food = this.new("scripts/items/supplies/bread_item");
			this.World.Assets.getStash().add(food);
			result.push({
				id = 10,
				icon = "ui/items/" + food.getIcon(),
				text = "You gain " + food.getName()
			});
		}

		return result;
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( b in brothers )
		{
			if (!b.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(b);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Injured = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 9;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Injured = null;
	}

});

