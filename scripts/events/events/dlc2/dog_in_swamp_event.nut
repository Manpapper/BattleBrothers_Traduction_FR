this.dog_in_swamp_event <- this.inherit("scripts/events/event", {
	m = {
		Helper = null,
		Houndmaster = null,
		Beastslayer = null
	},
	function create()
	{
		this.m.ID = "event.dog_in_swamp";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_09.png[/img]A shrill cry pierces the doldrums of the swamp. You rush forward and find a man thrashing about in the waters, his arms swinging ropes of kudzu. The water is foaming and bubbling and the snout of a dog briefly appears and spends that second barking for help instead of breathing for any momentary extension of life. Seeing you, the dog\'s owner calls out.%SPEECH_ON%Please, help! Something\'s got my dog!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This ain\'t our business.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Men, we\'ve got to help that dog!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							return "GoodEnding";
						}
						else
						{
							return "BadEnding";
						}
					}

				}
			],
			function start( _event )
			{
				local stash = this.World.Assets.getStash().getItems();
				local net = false;

				foreach( item in stash )
				{
					if (item != null && item.getID() == "tool.throwing_net")
					{
						net = true;
						break;
					}
				}

				if (net)
				{
					this.Options.push({
						Text = "Maybe I can use one of our nets to save that dog.",
						function getResult( _event )
						{
							return "Net";
						}

					});
				}

				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "Maybe our houndmaster can help?",
						function getResult( _event )
						{
							return "Houndmaster";
						}

					});
				}

				if (_event.m.Beastslayer != null)
				{
					this.Options.push({
						Text = "%beastslayer%, you\'re used to deal with beasts. Know what this is?",
						function getResult( _event )
						{
							return "BeastSlayer";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "GoodEnding",
			Text = "[img]gfx/ui/events/event_09.png[/img]%helpbro% wades into the swampwater with his arms out and swaying as though he were screwing the lid off a barrel. He lifts the weapon on high and the dog\'s owner nervously watches. A grin crosses the sellsword\'s face.%SPEECH_ON%Gotcha!%SPEECH_OFF%He skewers the swamp water and wrangles up a snake longer than any you\'ve ever seen, the length of it flopping about as the mercenary parades its corpse like a colored rope of a reward. The owner goes for his dog, but it slips out his grasp as though his arms were but another snake and it sprints right to your side. You ask if it\'s his dog at all. He nods, then slowly shakes his head.%SPEECH_ON%I suppose it\'s yer dog now. He\'s a fighter, that one, but he ain\'t nothing at all if not a goddam shite swimmer. I\'d see it a fair trade if I can keep that there snake.%SPEECH_OFF%You nod and make the trade, telling %helpbro% to hand over his newfound trophy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I think I\'ll name you... Swimmer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Helper.getImagePath());
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Swimmer";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "BadEnding",
			Text = "[img]gfx/ui/events/event_09.png[/img]%helpbro% heads to the shoreline and draws his weapon. He wades into the mire like some ale strewn saint departing a crowd before they recognize his face. Such is his struggle that he topples over on top of the dog and disappears into the froth and bubbles of the battle. You rush to his side and pull him ashore, the man covered in moss and his boots wrapped in lily pads and he\'s hacking nasty swamp water and picking out the brine which fermented it. There\'s no sight of the dog, just a slight ripple of water which trails away from the scene. Unnerved, its owner nods.%SPEECH_ON%Appreciate the effort, but it is what it is. The swamp sees to such things because it\'s a swamp and fark this goddam farkin\' place I\'d see this whole shitstain of geographical oddity drained and burned and salted to nothing but a wasteland whole if I could!%SPEECH_OFF%You raise an eyebrow and ask if he lives in the swamp. He takes a long breath and nods.%SPEECH_ON%Yessir. Rent free.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, that was a whorthwile endeavour.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Helper.getImagePath());
				_event.m.Helper.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Helper.getName() + " suffers light wounds"
				});
			}

		});
		this.m.Screens.push({
			ID = "Houndmaster",
			Text = "[img]gfx/ui/events/event_09.png[/img]%houndmaster% the houndmaster rushes forward to help, but the dog the swamp surface goes still. The man slips into the water and feels about. His hands clench and he stares back at the stranger.%SPEECH_ON%I\'m a dog handler at heart. That means I train \'em to not get into this much trouble. But I ain\'t ever would need to train a dog to beware this here bog, which means this sonuvabitch here threw him in there, ain\'t that right?%SPEECH_OFF%The stranger\'s first words are excuses and so the houndmaster batters him. The stranger scissors his legs backwards so awkwardly his pants fall about his ankles and there in his drawers spill an assortment of treasures. The damned fool is a treasure hunter! %houndmaster% draws a weapon and looks ready to murder this man. Screaming, the stranger kicks his pants off and runs off into the swampwoods hooting and pallidly half naked like some potato sack governed by a ghost. Laughing, you crouch to sift through the departed\'s goods, not all of which is shiny.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What a shame. And what a gain!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/loot/silverware_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "BeastSlayer",
			Text = "[img]gfx/ui/events/event_09.png[/img]The slayer of creatures, %beastslayer%, nods and wades into the swamp. He calmly comes to the thrashing water and stands over it, staring into the mire with his eyes tracking left to right as though he were watching carp in clear waters. Finally, he draws a dinner knife and slashes it into the water. Once more. And again. The dog surfaces and it snorts for air. The slayer stabs again and this time the dog runs free and goes between your legs where it huddles wet and whimpering. %beastslayer% holds something in his hand and then lets it go, whatever it is diving across the swamp, the water rippling in its wake.%SPEECH_ON%Nothing but a snake, captain.%SPEECH_OFF%The beast slayer kicks his foot up out of the water and riding his toe is a shiny goblet. He regards the swamp stranger with complete contempt.%SPEECH_ON%Your cowardice has made you a monster, treasure hunter, a right savage that\'d use a dog in place of his own two hands. You\'ve no business in these swamps. When I turn around, you\'d best be gone, got it?%SPEECH_OFF%The beast slayer hands you the goblet and the stranger retreats without delay.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very good.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beastslayer.getImagePath());
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Swimmer";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/loot/golden_chalice_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Net",
			Text = "[img]gfx/ui/events/event_09.png[/img]You fetch a net from the inventory and toss it over the dog. Despite the thrashing, the rim of the net sifts ever so gently into the mire like a child would slowly capture a jittery fly. A few of the sellswords join your side and go into the bog and tighten the ropes then drag the net ashore. The dog\'s legs stick out the bindings every which way and even with its life on the line it stares blankly in some sort of shamed caninity. Whatever held the dog seems to have gotten a sense of danger and releases itself and you watch a slippery green rope unfurl and dive back into the water and it\'s gone in the slightest of ripples.\n\n %randombrother% notes the mutt\'s fit frame and obedient demeanor. Indeed, it already seems unaffected by its brush with death, offering a friendly bark as deposition. You tell the stranger the dog now belongs to the company.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I think I\'ll name you... Swimmer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Swimmer";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "tool.throwing_net")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						stash[i] = null;
						break;
					}
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Swamp)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_houndmaster = [];
		local candidates_beastslayer = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster")
			{
				candidates_houndmaster.push(bro);
			}
			else if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Helper = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_houndmaster.len() != 0)
		{
			this.m.Houndmaster = candidates_houndmaster[this.Math.rand(0, candidates_houndmaster.len() - 1)];
		}

		if (candidates_beastslayer.len() != 0)
		{
			this.m.Beastslayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"helpbro",
			this.m.Helper.getNameOnly()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster ? this.m.Houndmaster.getNameOnly() : ""
		]);
		_vars.push([
			"beastslayer",
			this.m.Beastslayer ? this.m.Beastslayer.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Helper = null;
		this.m.Houndmaster = null;
		this.m.Beastslayer = null;
	}

});

