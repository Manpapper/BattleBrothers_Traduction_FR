this.tree_fort_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.tree_fort";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You come across a group of kids sitting in a treehouse. Eyes glare out of the portholes and around the wooden bastion you can see readied slingshots. As you size up the fort, they draw up the rope ladder and tell you to scram. Curious, you wonder what they might have of value for such an overreaction to a group of men who would almost certainly destroy them.\n\nBeing that kids easily buckle under pressure, you ask if they\'re hiding something. One makes a jerking off motion and tells you to scram, while another kid slugs him on the shoulder and tells him to shut up. Not exactly the answers of kids hiding treats or pastries. They definitely got something valuable up there.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Assault the fort!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "We don\'t have time for this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
				{
					this.Options.push({
						Text = "Oathtakers!",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You order the %companyname% to assault the fort. Unable to climb the tree under threat of rocks and slingshots, you have the men build ladders and throw up ropes of their own. The kids scream and throw down sticks and stones, dishing out an unignorable amount of pain, but not nearly as much as the words they call you, awful things like birdwatchers and pig dicks, the mean little bastards. A few manage to cut the ropes as the men are climbing up, leading to even more injuries. But eventually the sellswords roost the kids out, throwing the children out of the tree with great fervor. No surprise to you, your intuition was entirely correct: the kids had stowed away a few armaments and were stockpiling them in the tree fort. You take the goods and have the fort and the tree it rests on burned.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn kids.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local weapons = [
					"weapons/military_pick",
					"weapons/morning_star",
					"weapons/hand_axe",
					"weapons/reinforced_wooden_flail",
					"weapons/scramasax"
				];
				local item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You punch two fingers forward, ordering the men to assault the tree fort. The kids respond with slingshots and rocks. Pretending the rocks don\'t hurt like a mug, you tell the kids to give up. In return, they call you an inept fool and a witless schemer. These words hurt almost as much as the stones and rocks.\n\nSuddenly, the fort finds reinforcements as a group of more kids join the fray from the adjacent tree\'s branches, the bastards streaming over like sea raiders boarding a ship. The whole assault is going to all the hells in many handbaskets and a few of the men are complaining that the whole affair is simply far too annoying an endeavor to have it be continued. You wonder if they\'re just worried about their pride. Sighing, you order a cease to the assault. The kids laugh and mock you, but it is what it is.%SPEECH_ON%They probably had nothing up there anyway. Not worth the hassle.%SPEECH_OFF%One of the men says. You disagree, but there\'s no point in dwelling on it. The kids rally into a fowl choir and make squawking chicken noises as you march away.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That could have gone better.",
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
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " suffers " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " suffers light wounds"
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_183.png[/img]{You take Anselm\'s skull and hold it up. With a booming voice, you explain the trials and triumphs of Young Anselm, the original Oathtaker. The kids are wowed, looking at one another as you regale them with tale after tale of courage and honor. Eventually, the kids produce a rather extravagant weapon.%SPEECH_ON%We found it in a pond.%SPEECH_OFF%Another kid pushes another.%SPEECH_ON%No, it was in a stone! Remember, I\'m the one who pulled it out!%SPEECH_OFF%The kids fight each other for a time, but eventually a small girl takes the weapon and hurls it out of the tree fort\'s window. Its blade stakes into the ground, the steel warbling as it bends back and forth. She scoffs.%SPEECH_ON%Maybe it\'s for the best that someone else takes this thing, all they do is fight over it!%SPEECH_OFF%You wrap your hand around the sword\'s handle and its steel song hums to a quiet end. You unsheathe it from the earth and thank the kids for their contribution to the quest of the Oathtakers. The kids glance around at each other. One asks another.%SPEECH_ON%Do we have some sorta purpose now?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get back on the road.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/noble_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();
		local foundTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				foundTown = true;
				break;
			}
		}

		if (!foundTown)
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = this.World.getTime().Days <= 25 ? 10 : 5;
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

