this.civilwar_refugees_event <- this.inherit("scripts/events/event", {
	m = {
		AggroDude = null,
		InjuredDude = null,
		RefugeeDude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_refugees";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]{A true war has plenty of living amongst the casualties and this one is no different: going along a path, you find a large group of refugees huddling together. They were washing themselves in a creek when you discovered them, a party half-naked and half-washed and all-terrified. Mostly women and children, a few elders, and a few men who seem ready to lay down their lives for the rest, no matter how fruitless an effort their defense would be. One such man steps forward.%SPEECH_ON%What is it that you want?%SPEECH_OFF%%aggro_bro% approaches you.%SPEECH_ON%Sir, we could take everything they got, but I\'m sure they won\'t give it up willingly.%SPEECH_OFF%%injured_bro% shakes his head.%SPEECH_ON%I\'d say it ain\'t worth it. These people been through enough as it is and they\'ve little left to give the world.%SPEECH_OFF% | You come across a band of refugees. Women, children, elders, and a scattering of wide-eyed men. They\'ve little of value, but they still have things worth taking were you to put in the effort. | Refugees. A band of them stringed along the path in a long and filed row. At the sight of you, the head of the suffering centipede rears to a stop and all the bodies slowly shuffle together into a fearful blob. %aggro_bro% suggests killing them and taking what they got, although what they got doesn\'t appear to be much at all by your measurement.}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Leave those poor folk alone.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.World.Assets.getFoodItems();

				if (food.len() > 2)
				{
					this.Options.push({
						Text = "Share some of our provisions with those poor folk.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.RefugeeDude != null && food.len() > 1)
				{
					this.Options.push({
						Text = "%refugee_bro%, you used to be a refugee. Talk to them?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Options.push({
					Text = "Search them for valuables!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-3);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_59.png[/img]You order your men to take what they can. The refugees reel back in horror and some protest as your brothers file into their ranks. Suddenly, one of the refugees takes a large stone and bashes %injured_bro% over the head with it. Women and children scream and a few other men grab onto the mercenaries, fighting over weapons still sheathed. But the wandering souls haven\'t eaten in days and their weakened bodies are no match for your men. The %companyname% takes what it wants.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Know your place, you fools.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.InjuredDude.getImagePath());
				local injury = _event.m.InjuredDude.addInjury(this.Const.Injury.Accident3);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.InjuredDude.getName() + " suffers " + injury.getNameOnly()
					}
				];
				_event.addLoot(this.List);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_59.png[/img]You order your men to take what they can. The refugees reel back in horror. Women cry out, children, more confused than understanding, do the same. Some tearful men beg that you simply leave. Unfortunately for this band of useless tramps, the %companyname% takes what it wants. Your men freely sift through the crowds, eventually returning with their hauls.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "They know better than to resist.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.addLoot(this.List);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_59.png[/img]{You tell %randombrother% to give the refugees some food. The disconcerted group stares at you incredulously as they\'re handed some bread and a carboy of water. An elderly fellow walks up and shakenly gets to his knees to kiss your feet. You lift the man back up and tell him there is no need for such theatrics. A few of the mercenaries snicker and call you the \'The Dough of Doughs, the Stale Bread King.\' | These people would be easily robbed, but you get the feeling such news wouldn\'t sit kindly when word of it spread about the region. Instead, you order %randombrother% to start handing out food and water. The refugees are annoyingly happy, glomming onto you as though you were a god throwing mana out of your hands. You\'ve just some old food to get rid of. Then again, some say that when the old gods were more human, the men were more divine.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Travel safely.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local food = this.World.Assets.getFoodItems();

				for( local i = 0; i < 2; i = ++i )
				{
					local idx = this.Math.rand(0, food.len() - 1);
					local item = food[idx];
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You lose " + item.getName()
					});
					this.World.Assets.getStash().remove(item);
					food.remove(idx);
				}

				this.World.Assets.updateFood();
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_59.png[/img]You decide to weigh on a man who has personal experience as a refugee: %refugee_bro%.\n\nThe mercenary heads into the sobbing and praying mass of weary travelers. He talks with them for a time and shares some food, his friendly gesticulations and tales of his own past gradually bringing the crowd to his side. You watch as an old man hands him something wrapped in sheepskin with leather thongs swooping beneath. The sellsword bows, shakes the man\'s hand, and returns.\n\nHe throws the sheepskin back to unveil a sword that glints in the light about as sharply as you can imagine it cuts. %refugee_bro% smiles.%SPEECH_ON%Like me mum always said, a bit of friendliness never hurt nobody, but this sword sure will!%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Nice work with the niceties.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				this.Characters.push(_event.m.RefugeeDude.getImagePath());
				local food = this.World.Assets.getFoodItems();
				local item = food[this.Math.rand(0, food.len() - 1)];
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You lose " + item.getName()
				});
				this.World.Assets.getStash().remove(item);
				this.World.Assets.updateFood();
				local r = this.Math.rand(1, 2);
				local sword;

				if (r == 1)
				{
					sword = this.new("scripts/items/weapons/arming_sword");
				}
				else if (r == 2)
				{
					sword = this.new("scripts/items/weapons/falchion");
				}

				this.List.push({
					id = 10,
					icon = "ui/items/" + sword.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(sword.getName()) + sword.getName()
				});
				this.World.Assets.getStash().add(sword);
			}

		});
	}

	function addLoot( _list )
	{
		local r = this.Math.rand(1, 3);
		local food;

		if (r == 1)
		{
			food = this.new("scripts/items/supplies/dried_fish_item");
		}
		else if (r == 2)
		{
			food = this.new("scripts/items/supplies/ground_grains_item");
		}
		else
		{
			food = this.new("scripts/items/supplies/bread_item");
		}

		_list.push({
			id = 10,
			icon = "ui/items/" + food.getIcon(),
			text = "You gain " + food.getName()
		});
		this.World.Assets.getStash().add(food);
		this.World.Assets.updateFood();

		for( local i = 0; i < 2; i = ++i )
		{
			r = this.Math.rand(1, 10);
			local item;

			if (r == 1)
			{
				item = this.new("scripts/items/weapons/wooden_stick");
			}
			else if (r == 2)
			{
				item = this.new("scripts/items/armor/tattered_sackcloth");
			}
			else if (r == 3)
			{
				item = this.new("scripts/items/weapons/knife");
			}
			else if (r == 4)
			{
				item = this.new("scripts/items/helmets/hood");
			}
			else if (r == 5)
			{
				item = this.new("scripts/items/weapons/woodcutters_axe");
			}
			else if (r == 6)
			{
				item = this.new("scripts/items/shields/wooden_shield_old");
			}
			else if (r == 7)
			{
				item = this.new("scripts/items/weapons/pickaxe");
			}
			else if (r == 8)
			{
				item = this.new("scripts/items/armor/leather_wraps");
			}
			else if (r == 9)
			{
				item = this.new("scripts/items/armor/linen_tunic");
			}
			else if (r == 10)
			{
				item = this.new("scripts/items/helmets/feathered_hat");
			}

			this.World.Assets.getStash().add(item);
			_list.push({
				id = 10,
				icon = "ui/items/" + item.getIcon(),
				text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
			});
		}
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_aggro = [];
		local candidates_other = [];
		local candidates_refugees = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().isCombatBackground() || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute"))
			{
				candidates_aggro.push(bro);
			}
			else if (bro.getBackground().getID() == "background.refugee")
			{
				candidates_refugees.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player") && bro.getBackground().getID() != "background.slave")
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_aggro.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.AggroDude = candidates_aggro[this.Math.rand(0, candidates_aggro.len() - 1)];
		this.m.InjuredDude = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_refugees.len() != 0)
		{
			this.m.RefugeeDude = candidates_refugees[this.Math.rand(0, candidates_refugees.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"aggro_bro",
			this.m.AggroDude.getName()
		]);
		_vars.push([
			"injured_bro",
			this.m.InjuredDude.getName()
		]);
		_vars.push([
			"refugee_bro",
			this.m.RefugeeDude != null ? this.m.RefugeeDude.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.AggroDude = null;
		this.m.InjuredDude = null;
		this.m.RefugeeDude = null;
	}

});

