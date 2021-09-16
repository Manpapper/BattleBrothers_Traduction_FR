this.alp_nightmare2_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.alp_nightmare2";
		this.m.Title = "During camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
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
						return "E";
					}

				},
				{
					Text = "This needs to stop now, %addict%.",
					function getResult( _event )
					{
						return "D";
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
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]{You have %addict% taken to an ad-hoc whipping post. He lays limply against the wood, his fingers splayed out and pinching and clenching. He looks like he\'s chasing butterflies, and he carries that absent look when %otherbrother% hides him fierce with the whip.\n\n At first, the whipping does nothing, not even as it snaps across the man\'s back, leaving crescents of crimson. But after a few strikes, he wakes to reality and begins to scream. You come around to face him and ask if he\'ll swallow his addiction. He nods hurriedly. You let him get whipped again, and ask again, and again he nods. Another whipping, another question, another answer. Finally, %otherbrother% slackens the whip and coils it.%SPEECH_ON%He\'s dead, sir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What? Let me see!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				this.Characters.push(_event.m.Other.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Addict.getName() + " has died"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Addict.getID() || bro.getID() == _event.m.Other.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_39.png[/img]{You rush forward and go to lift the man\'s head up only for it to be a jug tied to a spear. Stepping back, you bump into %addict% who is sorting the inventory.%SPEECH_ON%Captain, you doing alright?%SPEECH_OFF%Nodding, you ask him how the stores of potions are doing. He grins.%SPEECH_ON%All accounted for. Should I count again?%SPEECH_OFF%You tell him to count something else and head to your tent for a drink. Turning around, a pale figure shifts away from one of the crates. You draw your sword and chase after it only to find a sheet billowing in the wind.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maybe I just need rest.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_39.png[/img]{You pull %addict% out of the barrel and throw him to the ground. He quickly flips around and yells out with perfect clarity.%SPEECH_ON%What the fark, captain?%SPEECH_OFF%It\'s not %addict% at all, but %otherbrother%. Looking away, you see %addict% stropping a blade. A pale figure shifts in the distance, but when you blink it is gone. You pull %otherbrother% to his feet and tell him to keep an eye out for robbers. He nods dutifully, perhaps sensing something is off with you, or perhaps not wanting to confront you for a mistake. You return to your tent for a drink.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Perhaps I should sleep instead.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You leave the man be, but the second you turn away you hear the shatter of glass and the gargle of the man which ruined it. Spinning back, you find %addict% doubled over with strips of flesh for a neck and he\'s picking glass out of an exposed throat. You rush to his aid, putting your hand against the bloodletting and you can feel his throat puckering against your fingers like the mouth of a beached fish. The man collapses to the ground, his full weight, his lifeless weight, his dead weight.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I should have taken action...",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Addict.getName() + " has died"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Addict.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 66)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_39.png[/img]{You bow your head to the earth, feeling such shame that you harken to the days when you gave a shite about the old gods. When you look back up, you find your fingers into a grain sack with its contents spilling all over.%SPEECH_ON%Oy captain, we gotta put those to use.%SPEECH_OFF%Looking over, you see %addict% and a white shadow standing behind him. You rush to your feet, but somewhere in all that hustle the shadow departed. You cannot find it nor any footprint and, not wishing to scare %addict% any further, you tell the sellsword to keep a watchful eye on the perimeter. Yourself, you go to your tent for a drink.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maybe two or three drinks, even.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
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
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.addict"))
			{
				candidates_addict.push(bro);
			}
			else
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
		this.m.Score = 10;
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

