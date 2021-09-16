this.fire_juggler_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Juggler = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.fire_juggler";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 160.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{A fire juggler has the eyes of everyone in a plaza of %townname%. He\'s got a trip-set of torches with bronze handles. His routine goes fairly well, but he does drop a torch at one point which raises some jeers in return. The next act he is to place a board over an open barrel of oil and then juggle the torches, arms out at his sides, except now with five torches instead of three.\n\nIn summary, his next act seems to be one of suicide and he unsurprisingly looks reluctant to follow through with it. But the crowed continues to cheer and jeer, no doubt snorting and huffing like a wolf pressing a deer to the cliffside, and the juggler, wide-eyed looks around for some form of escape.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s see how he does it.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "C" : "D";
					}

				},
				{
					Text = "We need to help him!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Juggler != null && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					this.Options.push({
						Text = "%juggler%, you can juggle, can\'t you help him?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You sigh and step forward, yelling loudly at the juggler, feigning as though you are his manager, telling him he is not to give away the big show quite yet. The crowd quiets down, confused, then jeers at you. A draw of half your sword quiets them, and others murmur word of \'Crownling\', manifesting a series of hisses and boos. But they ultimately disperse. The fire juggler steps down from his theater piece and thanks you repeatedly.%SPEECH_ON%I am not ready, I am not ready, and this you see with an eagle\'s eye, kind stranger! Here, my day\'s earnings, have all of it, for none of it would have meant a crown to me were I to step up there and die!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take care.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(1, 40);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You cross your arms and await the show. The fire juggler swallows hard and gets up on the barrel. He lowers a torch down and one of the villagers lights it, but when the jester pulls the torch up the villager pretends to throw their own fire into the vat of oil. The juggler jerks away momentarily and the crowd laughs as the bemused jester laughs.\n\n But the jester nails the act. All five torches whirl and twirl and a couple of times an ember sputters down and hits the rim of the oil barrel, but he is in control, and the crowd\'s jeers turn to cheers and when he is done they clap and then slowly disperse, going on to the next form of entertainment. One man drops a few crowns in the juggler\'s hands and that\'s that.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bravo!",
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
					if (this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.5, "Was entertained by a fire juggler");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You cross your arms and await the show. The fire juggler swallows hard and gets up on the barrel. He lowers a torch down and one of the villagers lights it, but when the jester pulls the torch up the villager pretends to throw their own fire into the vat of oil. The juggler jerks away momentarily and the crowd laughs as the bemused jester laughs.\n\n When the jester starts his act, he begins with setting himself on fire. Literally the first torch slips his hand and goes right into the vat which launches a plume of flame from which there is no discerning between man and fire aside from the hellish screams. He scrambles off the \'stage\' and the crowd only rears back to point and laugh. When he is dead, his crowns are taken by one of the residents. They lift the gold to the sky, make a passing mention of the Gilded one, then dump the crowns into the flames. His body is left for the dogs. After all is said and done, you kick around in the ashes and find a plate of melted gold. Not exactly of much value, but it\'s gotta be worth something and you take it when no one - not even the dogs - are looking.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gold is gold.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(1, 40);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%juggler%, the company\'s own former juggler, steps forward. He walks up on the \'stage\' which precariously hangs over the vat of oil. The two exchange words, then %juggler% is the one left standing. He performs the act - one he has neither practiced nor seen before - and completes it without issue. The crowd is silent, though. They merely watch, only occasionally glancing at you and the company. When %juggler% finishes he opens his arms wide, but there is no applause.%SPEECH_ON%The Gilded spits on Crownlings, interloper, you dance for no one. And you, fire juggler, what do you have to say for yourself?%SPEECH_OFF%%townname%\'s fire juggler thinks, then turns to you.%SPEECH_ON%I say I am tired of this nonsense, and if the Gilded one so despises us, then I\'ll have him despise me between the ranks of this here company. What say you, captain of the Crownlings, will you take me aboard?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the %companyname%.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "This is no place for you.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"juggler_southern_background"
				]);
				_event.m.Dude.setTitle("the Fire Juggler");
				_event.m.Dude.getBackground().m.RawDescription = "You found %name% on the streets of " + _event.m.Town.getName() + ", ready to put on fiery display of record-breaking fire juggling that could have well cost him his life. Luckily, " + _event.m.Juggler.getName() + " jumped in to perform the act with him, possibly saving his life. Afterwards, %name% finally had enough of his trade and volunteered to join your company.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/fearless_trait");

				foreach( id in trait.m.Excluded )
				{
					_event.m.Dude.getSkills().removeByID(id);
				}

				_event.m.Dude.getSkills().add(trait);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.improveMood(1.0, "Got saved from a possible flaming death by a fellow juggler");
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You nod.%SPEECH_ON%Fireling, Crownling, whatever. You\'re with the %companyname%.%SPEECH_OFF%The crowd hisses again, but you tell them to fuck off, peppering the threat with a flash of your sword just in case they had any problems understanding. %firejuggler%, the fire juggler, thanks you profusely and quickly goes to your ranks where the company welcomes him about as begrudgingly as they do any new recruit. As for %townname%\'s people, they quickly tire of the drama and move on with their lives.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Show\'s over, folks.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
				local meleeSkill = this.Math.rand(1, 3);
				_event.m.Juggler.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Juggler.getSkills().update();
				_event.m.Juggler.improveMood(1.0, "Put on a great display of fire juggling");
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Juggler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Melee Skill"
				});

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You shake your head. The fire juggler lowers his.%SPEECH_ON%Oh. I thought we had a thing here.%SPEECH_OFF%Pursing your lips, you shake your head again.%SPEECH_ON%No...there is no \'thing\' here. I just don\'t want you in my company, no hard feelings. Keep, uh, practicing. You know, with the fire, and the sticks, you\'ll get it someday I\'m sure.%SPEECH_OFF%The fire juggler nods.%SPEECH_ON%Of course. And though you have rejected me, I believe the Gilder has us both just where we are meant to be, and that His intention was not for our paths to cross fruitlessly. I will be sure to speak highly of your company wherever I go!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "May the Gilder\'s path for us both be as good as you hope.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
				local meleeSkill = this.Math.rand(1, 3);
				_event.m.Juggler.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Juggler.getSkills().update();
				_event.m.Juggler.improveMood(1.0, "Put on a great display of fire juggling");
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Juggler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Melee Skill"
				});

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer())
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_juggler = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.juggler")
			{
				candidates_juggler.push(bro);
			}
		}

		if (candidates_juggler.len() != 0)
		{
			this.m.Juggler = candidates_juggler[this.Math.rand(0, candidates_juggler.len() - 1)];
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"juggler",
			this.m.Juggler != null ? this.m.Juggler.getNameOnly() : ""
		]);
		_vars.push([
			"firejuggler",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Juggler = null;
		this.m.Dude = null;
	}

});

