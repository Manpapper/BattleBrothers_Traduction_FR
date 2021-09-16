this.addict_steals_potion_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.addict_steals_potion";
		this.m.Title = "During camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You go to check the inventory only to find %addict% splayed half-assed into a barrel, all four limbs hanging over the lip. There\'s a number of vials collected onto his belly. He stares at you with dim, reddened eyes, and the sockets holding them are purple as though all the blood had rushed there. You ask what the hell is going on and %addict% only smiles.%SPEECH_ON%Do, uh, do what you must. Er, captain. For I have already won.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I just hope you\'ll heal in time.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "This needs to stop now, %addict%.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 33 ? "C" : "D";
					}

				},
				{
					Text = "Enough. I\'ll have this bloody demon whipped out of you!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Item.getIcon(),
					text = "You lose " + this.Const.Strings.getArticle(_event.m.Item.getName()) + _event.m.Item.getName()
				});
				local items = this.World.Assets.getStash().getItems();

				foreach( i, item in items )
				{
					if (item == null)
					{
						continue;
					}

					if (item.getID() == _event.m.Item.getID())
					{
						items[i] = null;
						break;
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]{You have %addict% taken to an ad-hoc whipping post. He lays limply against the wood, his fingers splayed out and pinching and clenching. He looks like he\'s chasing butterflies, and he carries that absent look when %otherbrother% hides him fierce with the whip.\n\n At first, the whipping does nothing, not even as it snaps across the man\'s back, leaving crescents of crimson. But after a few strikes, he wakes to reality and begins to scream. You come around to face him and ask if he\'ll swallow his addiction. He nods hurriedly. You let him get whipped again, and ask again, and again he nods. Another whipping, another question, another answer. So this goes, until he is broken and whatever ailed him is gone.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get him out of my sight.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				_event.m.Addict.addLightInjury();
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Addict.getName() + " receives an injury"
					}
				];
				_event.m.Addict.getSkills().removeByID("trait.addict");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_29.png",
					text = _event.m.Addict.getName() + " is no longer an addict"
				});
				_event.m.Addict.worsenMood(2.5, "Was flogged on your orders");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Addict.getMoodState()],
					text = _event.m.Addict.getName() + this.Const.MoodStateEvent[_event.m.Addict.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Addict.getID())
					{
						continue;
					}

					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7)
					{
						continue;
					}

					bro.worsenMood(1.0, "Appalled by your order to have " + _event.m.Addict.getName() + " flogged");

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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You pull %addict% out of the barrel and throw him to the ground. He wobbles there as though the earth was a staircase and he was looking down the top step\'s precipice.%SPEECH_ON%Oy, sir, careful, it\'s just down and down!%SPEECH_OFF%At first you think to kick his arse, but relent. You crouch and set down next to the man as he rolls over to stare at the clouds. Time passes, and after a while %addict% purses his lips and you can see clarity has returned to his eyes.%SPEECH_ON%I got a problem, sir.%SPEECH_OFF%You nod and tell him to ease up on the potions, that you can\'t trust him in this state. If he\'s got a problem with being a sellsword, if that\'s why he\'s like this, then that\'s okay, but it is a problem. He purses his lips again and nods.%SPEECH_ON%Thank you, sir. I\'ll do my best to unfark myself and set things straight.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nice talking.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				_event.m.Addict.getSkills().removeByID("trait.addict");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_62.png",
					text = _event.m.Addict.getName() + " is no longer an addict"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You pull %addict% out of the barrel and throw him to the ground. He wobbles there as though the earth was a staircase and he was looking down the top step\'s precipice.%SPEECH_ON%Oy, sir, careful, it\'s just down and down!%SPEECH_OFF%At first you think to kick his arse, but relent. You crouch and set down next to the man as he rolls over to stare at the clouds. After a while he looks over.%SPEECH_ON%You trying to help me?%SPEECH_OFF%You nod and say you are, but %addict% simply smiles and shakes his head.%SPEECH_ON%Ain\'t talking to you, I\'m talking to you!%SPEECH_OFF%He points behind you at the barrel, and by the time you look back the man is up to his feet and charging forward.%SPEECH_ON%Fat sumbitch gon\' be smart with me huh!%SPEECH_OFF%The sellsword tackles the barrel and it splinters from top to bottom and a number of items within spill out and shatter. A few mercenaries rush over and get the man and take him away while you count what\'s been lost.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Goddammit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				local items = this.World.Assets.getStash().getItems();
				local candidates = [];

				foreach( i, item in items )
				{
					if (item == null || item.isItemType(this.Const.Items.ItemType.Legendary) || item.isItemType(this.Const.Items.ItemType.Named))
					{
						continue;
					}

					if (item.isItemType(this.Const.Items.ItemType.Misc))
					{
						candidates.push(i);
					}
				}

				if (candidates.len() != 0)
				{
					local i = candidates[this.Math.rand(0, candidates.len() - 1)];
					this.List.push({
						id = 10,
						icon = "ui/items/" + items[i].getIcon(),
						text = "You lose " + items[i].getName()
					});
					items[i] = null;
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_addict = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.addict"))
			{
				candidates_addict.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_addict.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		local items = this.World.Assets.getStash().getItems();
		local candidates_items = [];

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.getID() == "misc.potion_of_knowledge" || item.getID() == "misc.antidote" || item.getID() == "misc.snake_oil" || item.getID() == "accessory.recovery_potion" || item.getID() == "accessory.iron_will_potion" || item.getID() == "accessory.berserker_mushrooms" || item.getID() == "accessory.cat_potion" || item.getID() == "accessory.lionheart_potion" || item.getID() == "accessory.night_vision_elixir")
			{
				candidates_items.push(item);
			}
		}

		if (candidates_items.len() == 0)
		{
			return;
		}

		this.m.Addict = candidates_addict[this.Math.rand(0, candidates_addict.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Item = candidates_items[this.Math.rand(0, candidates_items.len() - 1)];
		this.m.Score = candidates_addict.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"addict",
			this.m.Addict.getName()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"item",
			this.Const.Strings.getArticle(this.m.Item.getName()) + this.m.Item.getName()
		]);
	}

	function onClear()
	{
		this.m.Addict = null;
		this.m.Other = null;
		this.m.Item = null;
	}

});

