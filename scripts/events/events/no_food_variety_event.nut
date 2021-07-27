this.no_food_variety_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.no_food_variety";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]{You find the mercenaries circled around a campfire, except they\'ve no real food to put over the flames. One throws his bowl of soup down. It is such a sludge that it barely moves to spill which is, honestly, quite disgusting. %randombrother% looks at you.%SPEECH_ON%Sir, please, let us get some meat! Or something beyond this shite!%SPEECH_OFF%A bit of variety wouldn\'t hurt, you agree. | %randombrother% comes to you and slams a spoon on your desk. There\'s something on the spoon, but what exactly you can\'t tell. The mercenary leans back, thumbs jacked into his beltline, his chest growing with breath. Then he sighs, for he knows not to behave in such ill-manner in your presence. But he does explain himself.%SPEECH_ON%Sir, the men are complaining about the food. I think it\'d be great for company morale if perhaps we picked up some meats and other goods in the next town. Only a suggestion, of course.%SPEECH_OFF%He quickly leaves. You pick up the spoon and look at whatever is in the scoop of it. That... that can\'t really be what they\'re eating out there, can it? Perhaps some variety wouldn\'t hurt... | %randombrother% approaches with a bowl in hand. He tilts it forward, showing the contents which are colorless and slide ever so slowly down the rim of the bowl. The mercenary shakes his head.%SPEECH_ON%The men are unhappy sir, and myself too, about the dinners we\'ve been eating. A man can only eat the same contents day after day for so long, especially when he knows he can afford so much more. It is only a suggestion, sir, from myself and from all the men, that perhaps we liven up our food stocks so that not every meal is... well, this.%SPEECH_OFF%He sets the bowl down and walks off. | A few of your mercenaries are complaining around a campfire. You stay within earshot, carefully listening as they might say things they wouldn\'t in your presence. Thankfully, it\'s not a mutiny in motion, but instead a series of cooking criticisms. There simply is not enough variety in the company\'s food stocks. They\'re tired of eating the same thing over and over. Perhaps this could be remedied in the next town the %companyname% visits?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, they ain\'t getting cake.",
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
					if (bro.getBackground().isLowborn() || bro.getSkills().hasSkill("trait.spartan"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.gluttonous"))
					{
						bro.worsenMood(1.0, "Has eaten nothing but ground grains for days");
					}
					else
					{
						bro.worsenMood(0.5, "Has eaten nothing but ground grains for days");
					}

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

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 5)
		{
			return;
		}

		if (this.World.State.getEscortedEntity() != null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local hasBros = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() || bro.getSkills().hasSkill("trait.spartan"))
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
		local hasOtherFood = false;

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getID() != "supplies.ground_grains")
				{
					hasOtherFood = true;
					break;
				}
			}
		}

		if (hasOtherFood)
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

