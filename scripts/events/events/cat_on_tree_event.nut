this.cat_on_tree_event <- this.inherit("scripts/events/event", {
	m = {
		Archer = null,
		Ratcatcher = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.cat_on_tree";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]You find a boy and girl looking up a tree. The girl throws her hands up.%SPEECH_ON%Alright, stay there until you die! See if I care!%SPEECH_OFF%The boy, spotting you, asks if perhaps you could help them get their cat out of the tree. Looking up, you do see a feline flopped over a branch, basking in the sun.",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				if (_event.m.Archer != null)
				{
					this.Options.push({
						Text = "%archerfull%, try to knock it down with an arrow?",
						function getResult( _event )
						{
							if (this.Math.rand(1, 100) <= 70)
							{
								return "ArrowGood";
							}
							else
							{
								return "ArrowBad";
							}
						}

					});
				}

				if (_event.m.Ratcatcher != null)
				{
					this.Options.push({
						Text = "%ratcatcherfull% has something up his sleeve.",
						function getResult( _event )
						{
							return "Ratcatcher";
						}

					});
				}

				this.Options.push({
					Text = "This really isn\'t our problem.",
					function getResult( _event )
					{
						return "F";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "ArrowGood",
			Text = "[img]gfx/ui/events/event_97.png[/img]%archer% nocks an arrow and sticks his tongue out as he aims up the tree. The girl and boy don\'t seem fond of this idea and clap their hands over their eyes. The archer looses the shot and it cracks against the cat\'s branch, breaking it and sending the cat cartwheeling down the tree like a game of devil sticks. When it hits the ground, the boy and girl lunge on it. They pet it and thank you for your troubles. The girl squeezes the cat warmly.%SPEECH_ON%Finally, we got ourselves something to eat!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wait, what?",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Archer.getBaseProperties().RangedSkill += 1;
				_event.m.Archer.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Maîtrise à Distance"
				});
			}

		});
		this.m.Screens.push({
			ID = "ArrowBad",
			Text = "[img]gfx/ui/events/event_97.png[/img]%archer% readies himself, nocking an arrow and taking aim. The cat purrs as it stares down the line of the shot, rather sublime in its suicidal stance. Closing one eye, the archer lets the arrow fly. There isn\'t much mewling to be had. The cat tumbles down the tree like a game of devil sticks and lands on the ground with an arrow shaft halfway out its head. The girl crouches down and stares at the slinky bit of brain wobbling off the arrowtip. She looks up at you, as though it were you who fired the shot.%SPEECH_ON%That was my friend.%SPEECH_OFF%You tell her you\'re sorry and that she\'ll find more friends. As for the boy, he pockets the bit of brain and slings the cat carcass over his shoulder. He bleakly states.%SPEECH_ON%At least we\'ve somethin\' to eat now.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rest in peace, kitty.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Archer.worsenMood(1.0, "Accidentally shot a little girl\'s pet cat");

				if (_event.m.Archer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer.getMoodState()],
						text = _event.m.Archer.getName() + this.Const.MoodStateEvent[_event.m.Archer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Ratcatcher",
			Text = "[img]gfx/ui/events/event_97.png[/img]%ratcatcher% snaps his fingers.%SPEECH_ON%Oy, I\'veuhplan! You little runts just wait a moment!%SPEECH_OFF%The rat catcher takes a rat out of his pocket you\'d no idea he even had. Chirping his lips like a mewling cat himself, he holds the little rodent up. The cat takes notice, perking its ears.%SPEECH_ON%Yeah that\'s right you pussy, c\'mon down, it\'s lunch time.%SPEECH_OFF%The rat catcher brings the rat to his lips and whispers.%SPEECH_ON%No it\'s not, heheh.%SPEECH_OFF%As the cat descends, %ratcatcher% holds his friend out a little more. It begins to scrape and scuttle against his hands, perhaps not trusting its master to keep it. But the moment the cat lunges for the meal, the rat catcher pockets the rat and snags the cat all in one swift motion. The children clap and cheer as he hands the cat over. Even some of the men are impressed by the fella\'s feline-like reflexes!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Masterfully done!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				_event.m.Ratcatcher.getBaseProperties().Initiative += 2;
				_event.m.Ratcatcher.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Ratcatcher.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Initiative"
				});
				_event.m.Ratcatcher.improveMood(1.0, "Impressed everyone with his swiftness");

				if (_event.m.Ratcatcher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Ratcatcher.getMoodState()],
						text = _event.m.Ratcatcher.getName() + this.Const.MoodStateEvent[_event.m.Ratcatcher.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_97.png[/img]You bluntly tell the kids they should get a dog and make your leave.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The cat doesn\'t wanna be your friend anyway.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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
		local candidates_archer = [];
		local candidates_ratcatcher = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword")
			{
				candidates_archer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates_ratcatcher.push(bro);
			}
		}

		if (candidates_archer.len() == 0 && candidates_ratcatcher.len() == 0)
		{
			return;
		}

		if (candidates_archer.len() != 0)
		{
			this.m.Archer = candidates_archer[this.Math.rand(0, candidates_archer.len() - 1)];
		}

		if (candidates_ratcatcher.len() != 0)
		{
			this.m.Ratcatcher = candidates_ratcatcher[this.Math.rand(0, candidates_ratcatcher.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"archer",
			this.m.Archer != null ? this.m.Archer.getNameOnly() : ""
		]);
		_vars.push([
			"archerfull",
			this.m.Archer != null ? this.m.Archer.getName() : ""
		]);
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher != null ? this.m.Ratcatcher.getNameOnly() : ""
		]);
		_vars.push([
			"ratcatcherfull",
			this.m.Ratcatcher != null ? this.m.Ratcatcher.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Archer = null;
		this.m.Ratcatcher = null;
		this.m.Town = null;
	}

});

