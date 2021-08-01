this.dogfighting_event <- this.inherit("scripts/events/event", {
	m = {
		Doghandler = null,
		Wardog = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.dogfighting";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%%doghandler% asks you to enter %wardog% into a local dog fighting circle. That sounds like an awful idea, but the man goes on to explain that a lot of money stands to be made in dogfighting. All the doghandler needs is an ante of two hundred crowns.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, but I\'m going with you.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "That\'s not going to happen.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%townImage%You take a purse of crowns and follow %doghandler% through a wind of darker and darker streets. Soon enough, there isn\'t much to see. Wet cobblestones, licked white by strobes of moonlight, lazily guide you into what depths the city hides from those who prefer the day. Suddenly, a torch flares up and a man\'s face, afloat and disembodied in the dark, speaks out to you.%SPEECH_ON%That dog here for da\'fights?%SPEECH_OFF%%doghandler% nods. The stranger tilts the torch forward.%SPEECH_ON%Alright then. Right this way, gen-teel-men. Watch yer step. All manner of piss goes downhill.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s do this.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "I\'ve changed my mind.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%townImage%Following the man\'s torch through the dark, you come to a building with a sliding portal at its door. The stranger gives the door a pattern of knocks and it pops open as if commanded by the final rap. You are ushered in, leering faces watching from the side as you enter. Immediately, you hear the unsettling din of snarling and barking. This is what you are here for, right?\n\n Stairs lead you to the pits where a crowd huddles around a makeshift arena of dirt and wobbly fenceposts. The action can\'t be seen yet, but off to the side are a pile of dead dogs and beside them sit their killers, eyes wild, blood frothing mouths agape in horrified panting. As two dogs clash in the arena, you glance at %doghandler%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Time to ante up and see what our mutt can do.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "This is bad. Let\'s get out of here.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_47.png[/img]After paying the ante of two hundred crowns, you and %doghandler% take %wardog% inside the arena.\n\nIts eyes dart around and as its shoulder rests against your pantleg, you can feel a quickening heartbeat. Across from you stands your competition: a scummy looking doghandler and a massive beast more wolf than dog. The mutt is missing its bottom lip, displaying a jagged row of teeth that have been chiseled to be deadlier than they already are. Scabs and sores mottle its crooked body, but the musculature of its frame is apparent and %doghandler% whispers that this will be ugly.\n\n %wardog% yips and jabs forward, the mongrel bred with war in him, and with an outstretched hand you unleash your hound just as your opponent does his.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get him, boy!",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 33)
						{
							return "E";
						}
						else if (r <= 66)
						{
							return "F";
						}
						else
						{
							return "G";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(-200);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]200[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_47.png[/img]The two dogs sprint toward one another and cover the small arena in a flash. They collide, their crude bodies wheeling away from one another before their feet plant and charge in for another shot. The opponent\'s dog ducks beneath %wardog% then rises back up, glomming onto the underside of your dog\'s neck.\n\n%doghandler%\'s hands go to his face, his eyes staring out between his fingers. You watch as %wardog% is shaken from side to side. Blood spurts from its nose as it yelps. You can hear the scratch of scissoring, helpless legs as the dog tries to kick across the dirt. The audience jeers and laughs.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I can\'t intervene.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "H" : "I";
					}

				},
				{
					Text = "This needs to stop!",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_47.png[/img]The two dogs sprint across the arena. %wardog% goes high, and its opponent low. You watch in horror as the opponent\'s mutt shoots up from its low stance and clamps its jaws under %wardog%\'s neck. They tumble across the arena and in the violent momentum %wardog%\'s throat is ripped clean out. Blood sprays so fiercely that the audience jumps back to get away. The victorious mongrel returns to its owner and drops a rag of flesh and muscle at his feet.\n\n%wardog% stumbles across the dirt. It retches for breath, its throat puckering and wheezing and gargling. %doghandler% jumps the fence and kneels beside the mutt. He tries to cover the wound, but it\'s no use. The dog stares at you as it dies.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damnit!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				_event.m.Wardog.getContainer().unequip(_event.m.Wardog);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog.getIcon(),
					text = _event.m.Wardog.getName() + " dies."
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_47.png[/img]The two dogs briefly growl before charging. They collide and simultaneously glom onto each other\'s necks, spiraling and wheeling across the arena like some sort of furry and violent pinwheel.\n\n%wardog% drives its opponent into a fence post. You watch as your dog buries its jaws into its opponent\'s face, jamming its teeth through an eye in one bite, and taking a chunk of tongue in another. The defeated mutt is bitten to pieces, literally, and as it falls in defeat your dog commits to a throat-ripping execution.\n\nYour opponent cries out and tries to jump the fence, but the audience reels him back. %doghandler% pats you on the back.%SPEECH_ON%Easy money, no?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It appears the company also has the meanest and baddest dogs.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_47.png[/img]You decide not to intervene, instead letting %wardog%\'s fight, and potential demise, go where it may. The choice is soon rewarded: you watch as your dog gets its hind paws against one of the fenceposts circling the arena. With a good kick it manages to slide itself underneath its combatant and there tear out the dangling testicles in a disgusting display of survivalism. The poor emasculated mongrel, shrieking, wheels around only to put its neck directly into the jaws of %wardog%. The fight ends quickly, and almost mercifully, from there.\n\n You go to collect your reward while %doghandler% hugs the now tail-wagging %wardog%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good boy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_47.png[/img]You don\'t intervene and even have to hold back %doghandler% as the man tries to jump the fence. The two of you can only watch in horror as the fierce mongrel\'s snapping bites tear away at %wardog%\'s face piece by piece. Soon, your dog sinks to the ground, giving up its neck. Bloody tearing follows suit and %wardog% is very quickly a dead dog. Distraught, %doghandler% can only sink to the ground and cover his face.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damnit!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				_event.m.Wardog.getContainer().unequip(_event.m.Wardog);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog.getIcon(),
					text = _event.m.Wardog.getName() + " dies."
				});
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_20.png[/img]You throw your betting ticket into the dirt.%SPEECH_ON%Fark it.%SPEECH_OFF%With a quick leap you jump the fence and run into the arena. %doghandler% is right behind you. The two dogs are still at it, but a swift kick gets them separated. The houndmaster quickly grabs %wardog% and lifts him out of danger. The crowd boos and bottles and glasses start flying in. A man blows a whistle that silences them all. He steps into the arena.%SPEECH_ON%These people paid to see blood. If you are not going to give it to them, then you best find another way to pay. How about two hundred crowns crowns? That or you just go ahead and put that dog back down.%SPEECH_OFF%The crowd is cracking their knuckles and drawing out knives, chains, and other crude weaponry.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take your damn crowns, then. We\'re leaving with our dog.",
					function getResult( _event )
					{
						return "K";
					}

				},
				{
					Text = "The fight will continue.",
					function getResult( _event )
					{
						return "L";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "K",
			Text = "[img]gfx/ui/events/event_20.png[/img]You take out %demand% crowns and hand them over. The crowd boos, but the man in charge blows his whistle again.%SPEECH_ON%Shut it, the lot of ya! The man paid the fee so the man and his dumb dog walk.%SPEECH_OFF%The crowd pipes down. You start to leave, %doghandler% behind you with an unconscious %wardog% strung limply across his arms. A few patrons hiss and spit, but that\'s about the most they do and you\'re perfectly fine with that.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get back to camp...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				this.World.Assets.addMoney(-200);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]200[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "L",
			Text = "[img]gfx/ui/events/event_20.png[/img]You order %doghandler% to put the dog down. His eyes widen.%SPEECH_ON%You can\'t be serious.%SPEECH_OFF%Nodding, you say you are. %wardog%\'s barely awake, snorting between frightened alertness and deadened unconsciousness. When %doghandler% hesitates again, you grab the dog and pull it away. You nod to the crowd, and then to your opponent who unleashes his murderous hound a second time. %wardog%\'s weary, watery eyes look up at you, blink, then close. You put the dog down and your opponent\'s hound descend upon it with bestial fury. You try not to listen to the horrific demise unfolding at your feet.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get back to camp...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Doghandler.getImagePath());
				_event.m.Wardog.getContainer().unequip(_event.m.Wardog);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog.getIcon(),
					text = _event.m.Wardog.getName() + " dies."
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 250)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Doghandler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Wardog = this.m.Doghandler.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
		this.m.Town = town;
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"doghandler",
			this.m.Doghandler.getNameOnly()
		]);
		_vars.push([
			"wardog",
			this.m.Wardog.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"demand",
			"200"
		]);
	}

	function onClear()
	{
		this.m.Doghandler = null;
		this.m.Wardog = null;
		this.m.Town = null;
	}

});

