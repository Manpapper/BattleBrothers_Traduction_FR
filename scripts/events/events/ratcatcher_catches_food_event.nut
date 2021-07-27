this.ratcatcher_catches_food_event <- this.inherit("scripts/events/event", {
	m = {
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.ratcatcher_catches_food";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] With rations down to nothing, %ratcatcher% feebly enters your tent, the moans of some hungry men passing by before the flaps close behind him. He explains that he has a resolution to your food problem. You fear to ask what it is, but you\'ve little choice now. The ratchatcher swings a burlap sack onto the table. Some shape of it moves, skittering and bobbing and squealing. The man smashes it with his fist before smiling at you.%SPEECH_ON%Sorry, had a live one there!%SPEECH_OFF%He explains that rat isn\'t the most nutritious of animals, nor the healthiest, but it\'d help the company enough until they can get back to a town or farm. You reluctantly agree to keep your men from starving.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We don\'t have a choice...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				local food = this.new("scripts/items/supplies/strange_meat_item");
				food.setAmount(12);
				this.World.Assets.getStash().add(food);
				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + food.getAmount() + "[/color] Rat Meat"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Ratcatcher.getID())
					{
						continue;
					}

					if (bro.getBackground().isNoble())
					{
						bro.worsenMood(1.0, "Lost confidence in your leadership");
						bro.worsenMood(2.0, "Was served rat for dinner");
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
					else
					{
						local r = this.Math.rand(1, 5);

						if (r == 1 && !bro.getBackground().isLowborn())
						{
							bro.worsenMood(1.0, "Was served rat for dinner");

							if (bro.getMoodState() < this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}
						else if (r == 2 && !bro.getSkills().hasSkill("injury.sickness"))
						{
							local effect = this.new("scripts/skills/injury/sickness_injury");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " is sick"
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() > 15)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
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
			if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Ratcatcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Ratcatcher = null;
	}

});

