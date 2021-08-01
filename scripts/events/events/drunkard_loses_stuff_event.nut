this.drunkard_loses_stuff_event <- this.inherit("scripts/events/event", {
	m = {
		Drunkard = null,
		OtherGuy = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.drunkard_loses_stuff";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]While taking inventory last night, %drunkard% had a little too much to drink and ended up losing %item%!\n\nYou\'ve had him brought to you and the man, swaying on his feet, still reeks of alcohol. He hiccups as he tries to explain himself, but the best he can do is collapse to the ground in a drunken heap. The man laughs and laughs, but you see nothing funny about this. %otherguy% asks what you want to do with him.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Everybody makes mistakes.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Latrine duty for a month!",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "If he won\'t put down the drink I\'ll force him to. Get the whip.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "D" : "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Item.getIcon(),
					text = "Vous perdez " + this.Const.Strings.getArticle(_event.m.Item.getName()) + _event.m.Item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]The drunkard falls onto his back, staring aimlessly at the sky. You see tears in his eyes and he covers his face, trying to hide his shame. There is something about him and his past that you do not know, perhaps something that led him to the drink in the first place. You can\'t possibly punish a man for what he cannot control.",
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
				this.Characters.push(_event.m.Drunkard.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]You grab a shovel, a bucket, and a crusty bit of wool wrapped around a stick.%SPEECH_ON%Latrine duty. One month.%SPEECH_OFF%The drunkard looks at you and with wide eyes makes something of a plead.%SPEECH_ON%Sir, please. I -hic- don\'t... the men, sir, they -hic-...%SPEECH_OFF%You hold your hand up, stopping him. The man sways as he tries to stand straight. Cracking your knuckles, you explain the other option.%SPEECH_ON%If you do not wish to have these duties, then we can expedite your punishment by the whip. Which would you prefer?%SPEECH_OFF%Amazingly, the drunkard actually spends a few moments thinking it over, his eyebrows rising and falling and a grimace passing from side of his mouth to the other with a stream of realizations that there\'s no way out of it. Finally, he submits to the smellier of the two options. Quite shocked to see the choice even took any time at all, you begin to wonder just how bad the company\'s diet has gotten.",
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
				this.Characters.push(_event.m.Drunkard.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_38.png[/img]The man was driven to the drink, so you plan to drive it out of him. You order a flogging. A few battle brothers drag the drunk away. He is hiccupping and moaning, his head bouncing aloll as he is seemingly unaware of what is going on. They string him up beneath a tree and shred the clothes off his back. After a few lashings, the drunkard wakes up to his punishment and begins crying out uncontrollably. He begs for mercy in a tongue blurred by drink and pain, like a man fighting for freedom from a nightmare. One thing is for certain: he\'ll never make this mistake again.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'ll teach him.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
				_event.m.Drunkard.addLightInjury();
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Drunkard.getName() + " receives an injury"
					}
				];
				_event.m.Drunkard.getSkills().removeByID("trait.drunkard");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_29.png",
					text = _event.m.Drunkard.getName() + " is no longer a drunkard"
				});
				_event.m.Drunkard.worsenMood(2.5, "Was flogged on your orders");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Drunkard.getMoodState()],
					text = _event.m.Drunkard.getName() + this.Const.MoodStateEvent[_event.m.Drunkard.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Drunkard.getID())
					{
						continue;
					}

					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7)
					{
						continue;
					}

					bro.worsenMood(1.0, "Appalled by your order to have " + _event.m.Drunkard.getName() + " flogged");

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
			ID = "E",
			Text = "[img]gfx/ui/events/event_38.png[/img]The man was driven to the drink, so you plan to drive it out of him. You order a flogging. A few men drag the drunk away. He is hiccupping and moaning, his head bouncing aloll as he is seemingly unaware of what is going on. They string him up beneath a tree and shred the clothes off his back. After a few lashings, the drunkard wakes up to his punishment and begins crying out uncontrollably. He begs for mercy in a tongue blurred by drink and pain, like a man fighting for freedom from a nightmare.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'ll teach him.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
				_event.m.Drunkard.addLightInjury();
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Drunkard.getName() + " receives an injury"
					}
				];
				_event.m.Drunkard.worsenMood(2.5, "Was flogged on your orders");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Drunkard.getMoodState()],
					text = _event.m.Drunkard.getName() + this.Const.MoodStateEvent[_event.m.Drunkard.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Drunkard.getID())
					{
						continue;
					}

					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7 || bro.getBackground().getID() == "background.flagellant")
					{
						continue;
					}

					bro.worsenMood(1.0, "Appalled by your order to have " + _event.m.Drunkard.getName() + " flogged");

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
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.drunkard"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local items = this.World.Assets.getStash().getItems();
		local hasItem = false;

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Legendary))
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Weapon) || item.isItemType(this.Const.Items.ItemType.Shield) || item.isItemType(this.Const.Items.ItemType.Armor) || item.isItemType(this.Const.Items.ItemType.Helmet))
			{
				hasItem = true;
				break;
			}
		}

		if (!hasItem)
		{
			return;
		}

		this.m.Drunkard = candidates[this.Math.rand(0, candidates.len() - 1)];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Drunkard.getID())
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.OtherGuy = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
		local items = this.World.Assets.getStash().getItems();
		local candidates = [];

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Legendary) || item.isIndestructible())
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Weapon) || item.isItemType(this.Const.Items.ItemType.Shield) || item.isItemType(this.Const.Items.ItemType.Armor) || item.isItemType(this.Const.Items.ItemType.Helmet))
			{
				candidates.push(item);
			}
		}

		this.m.Item = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.World.Assets.getStash().remove(this.m.Item);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"drunkard",
			this.m.Drunkard.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
		_vars.push([
			"item",
			this.Const.Strings.getArticle(this.m.Item.getName()) + this.m.Item.getName()
		]);
	}

	function onClear()
	{
		this.m.Drunkard = null;
		this.m.OtherGuy = null;
		this.m.Item = null;
	}

});

