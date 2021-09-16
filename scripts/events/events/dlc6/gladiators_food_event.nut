this.gladiators_food_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator = null
	},
	function create()
	{
		this.m.ID = "event.gladiators_food";
		this.m.Title = "During camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_155.png[/img]{The Gladiators demand better food.%SPEECH_ON%I\'m sorry, \'captain\', but what would you have me do with this?%SPEECH_OFF%%gl% holds up a loaf of bread.%SPEECH_ON%Where\'s the meat? Look at it. LOOK. At it. Who made this? A baker? You want me to a baker\'s loaf? I want to eat that which fights back. Does bread fight back? I don\'t think so.%SPEECH_OFF%It seems the Gladiators might be far from the arena, but not far from the coddled treatment the chefs there gave day in and day out. Perhaps you should seek a variety of high quality food to keep them quelled. | %SPEECH_START%Where is the good stuff, huh?%SPEECH_OFF%%gl% holds up a piece of a meal. It is stringy and flops around in his hand.%SPEECH_ON%This is not the food of gladiators, it is the food of wimps!%SPEECH_OFF%He turns and throws the food and it slaps against the side of the company wagon where it unsticks and then curls over like an upside down hook.%SPEECH_ON%We demand good food, captain! None of this gamey shit.%SPEECH_OFF%You should probably look into getting the gladiators food that is more to their standards. | %SPEECH_START%Where\'s the wine? Where are the delicatessens!%SPEECH_OFF%%gl% takes his plate of food and throws it like a disc. It goes impressively far, bits of food spraying off in a cone of caloric debris.%SPEECH_ON%I demand delicatessens, captain! Where are my delicatessens?%SPEECH_OFF%It seems the gladiators require food of finer qualities.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You cost me a fortune already!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
					{
						bro.worsenMood(1.5, "Demands better food");

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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasExquisiteFood = false;

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getRawValue() >= 85)
				{
					hasExquisiteFood = true;
					break;
				}
			}
		}

		if (hasExquisiteFood)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Gladiator = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 40;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gl",
			this.m.Gladiator != null ? this.m.Gladiator.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Gladiator = null;
	}

});

