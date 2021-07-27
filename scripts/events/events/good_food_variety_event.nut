this.good_food_variety_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.good_food_variety";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_61.png[/img]{You watch as the men chow down on plates about as colorful as the men\'s personalities. Supplying the company with such a diverse stock of food has raised their spirits as good as any victory! | A hot meal is what any man needs, but a hot meal, with a couple of sides and entrees? Well, that\'s something else entirely! Your purchases of diverse foods has the men gleefully chowing down and feeling good about life. | Food as diverse as any nobleman\'s - or close enough, anyway. That\'s what you have supplied the company and the men are supremely appreciative as they chow down.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Enjoy.",
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
					if (bro.getSkills().hasSkill("trait.spartan"))
					{
						continue;
					}
					else if (bro.getSkills().hasSkill("trait.gluttonous") || bro.getSkills().hasSkill("trait.fat"))
					{
						bro.improveMood(2.0, "Very much appreciated the food variety");
					}
					else
					{
						bro.improveMood(1.0, "Appreciated the food variety");
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local hasBros = false;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.spartan"))
			{
				continue;
			}

			hasBros = true;
			break;
		}

		if (!hasBros)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local food = [];

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (food.find(item.getID()) == null)
				{
					food.push(item.getID());
				}
			}
		}

		if (food.len() < 4)
		{
			return;
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

