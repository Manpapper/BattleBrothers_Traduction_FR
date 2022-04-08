this.anatomist_wants_skull_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Thief = null,
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_wants_skull";
		this.m.Title = "On the road...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_16.png[/img]{You come to a remote village to find a few of its peoples crouched before a large, bleached skull decoratively set on a lectern. Passing peasants pause and profess faith to it. As you get closer, you realize the skull itself is extraordinary: a long, thick forehead juts out from the top, its brow quite dominant and ridged, and the jaw of it, still intact, carries enormous and sharp teeth, most of which are in a state of disorder, as if in any ordinary head closing such a mouth would be a danger to itself. What it very well may be is a Nachzehrer\'s skull. Naturally, with this strange skeletal sight before you, you hope to turn the company away before-%SPEECH_ON%We should take that for studying.%SPEECH_OFF%Sighing, you turn to see %anatomist% standing there, ogling the skull. You correct him, saying instead that what he really means is he intends to steal it. The anatomist stares at you.%SPEECH_ON%The vocabulary needn\'t matter, when the studying is done, it will be of better use in our hands than theirs, that much is clear.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, take it.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "I don\'t think so.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "What\'s our thief %thief% have to say?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "That skull looks like our wildman, %wildman%.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Sighing, you agree to the anatomist\'s fancies, but you tell him that it will be he who does the stealing, if it is he who wishes to do the studying. The man doesn\'t even hesitate and heads off, eyes narrowed to the bony item central to his scientific fancy. You\'re not going to be responsible for the mayhem that goes down if he is caught so you leave him to it, returning instead to count inventory while keeping your ears perked for sounds of religion wrecking chaos. A few moments later, %anatomist% returns, a fat skull cradled under an arm and a bit of sweat on his brow.%SPEECH_ON%It\'s a Nachzehrer\'s skull and should be of great value to our studies.%SPEECH_OFF%Curious, you ask him how it was that he managed to get the skull in the first place. %anatomist% raises an eyebrow.%SPEECH_ON%You weren\'t watching? I thought the endeavor was quite impressive, but alas so impressive that I believe telling it second hand will make you susceptible to believing me to tell a tall tale. A fable, if you will. Just know that we should probably get out of here soon. Perhaps sooner than soon, and quicker than quick. Do you understand?%SPEECH_OFF%A din of shouting grows in the distance. The anatomist wipes his brow and turns and walks away. The back of his shirt is clawed apart and there are little darts or arrows sticking out of his back - and those distant shouts are getting louder.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hmm.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired an unusual skull to study");
				_event.m.Anatomist.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Anatomist.getName() + " suffers light wounds"
				});
				local resolveBoost = this.Math.rand(1, 3);
				local initiativeBoost = this.Math.rand(1, 3);
				_event.m.Anatomist.getBaseProperties().Bravery += resolveBoost;
				_event.m.Anatomist.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Initiative"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You tell %anatomist% he can take the skull. He stares at you for a time, then says he thought you were the one that was going to do it. You tell him there\'s no way you\'re taking a skull from local peasants who worship said skull. If he wishes to do the studying, then it is he who should do the stealing. %anatomist% draws a hand to his chest.%SPEECH_ON%I\'m a man of science, and no ordinary scribe, I could not deign myself to a task of such lowness. It requires a man of knowhow, a man who understands the grit and grime of daily life, to steal this skull.%SPEECH_OFF%The anatomist clenches a fist, so certain that his speech is not an insult to you, and his eyes staring off with determined ferocity that could only be vicarious at best.%SPEECH_ON%What the fark you two strangers talkin\' about?%SPEECH_OFF%You both turn around to see a peasant holding a pitchfork, and as a few more join him he motions toward you.%SPEECH_ON%These fellas were aimin\' to steal the skull!%SPEECH_OFF%You hold your hands out, explaining that- before you finish, %anatomist% turns and sprints away. Thinking fast, you call him a thief and promise to have his head, making a grand show of drawing out your sword and waving it at the peasants. You pretend to accidentally drop a purse of crowns, turning the peasants\' anger into greed, and giving you enough time to escape.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get out of here.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-100);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]100[/color] Crowns"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_65.png[/img]{Sighing, you agree to the idea of stealing the skull. Before you can say anything more, %thief% the thief appears. He comes up chewing grass and walking with swagger.%SPEECH_ON%So you wanna steal something, hm? Just point at whatcha need and I\'ll go and fetch it for you. Is it gold? A weapon?%SPEECH_OFF%%anatomist% points at the skull. The thief stares at it for a time before turning back.%SPEECH_ON%Oh, uh, alright.%SPEECH_OFF%The thief and would be skull stealer wanders off. You go and count inventory, giving him time to do his job. He later returns with the skull in tow, as well as a bevy of weapons and armor which you know he didn\'t buy. As you stare at the clearly lifted goods, the man shrugs.%SPEECH_ON%What? I had to make it worth my time.%SPEECH_OFF%The anatomist takes the skull away without saying a word, carrying it off while staring into its emptied eyesockets as though it were a lover, muttering that many things will be learned from its vacant stare. The thief does the same, but instead with a satchel of crowns and other goodies, himself muttering that he\'ll finally be able to afford two whores at the same time, an apparent long held dream of his. You take the weapons and armor to inventory, and in the distance you hear the wailing of peasants looking for the relic.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A win\'s a win.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired an unusual skull to study");
				_event.m.Thief.improveMood(1.0, "Successfully stole from the peasantry");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				if (_event.m.Thief.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Thief.getMoodState()],
						text = _event.m.Thief.getName() + this.Const.MoodStateEvent[_event.m.Thief.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(100, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+100[/color] Experience"
				});
				local initiativeBoost = this.Math.rand(2, 4);
				_event.m.Thief.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Thief.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Thief.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Initiative"
				});
				local item;
				local weaponList = [
					"militia_spear",
					"militia_spear",
					"militia_spear",
					"shortsword",
					"falchion",
					"light_crossbow"
				];
				local itemAmount = this.Math.rand(1, 2);

				for( local i = 0; i < itemAmount; i = ++i )
				{
					item = this.new("scripts/items/weapons/" + weaponList[this.Math.rand(0, weaponList.len() - 1)]);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + item.getName()
					});
					this.World.Assets.getStash().add(item);
				}

				local armorList = [
					"leather_tunic",
					"leather_tunic",
					"thick_tunic",
					"thick_tunic",
					"padded_surcoat",
					"padded_leather"
				];
				itemAmount = this.Math.rand(1, 2);

				for( local i = 0; i < itemAmount; i = ++i )
				{
					item = this.new("scripts/items/armor/" + armorList[this.Math.rand(0, armorList.len() - 1)]);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + item.getName()
					});
					this.World.Assets.getStash().add(item);
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Thief.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]{You decide that if the anatomists can make some grand use of the skull, then you\'ll abide by giving them the chance to study it. The question is how does one go about stealing a hideous skull from a group so insane they\'d worship it? Almost as if on cue, %wildman% the wildman appears, chowing down on a handful of worms. His nature-rinsed face and cruelly shaped skull seem almost kin to the monstrosity which resides on the village\'s town center lectern. %anatomist% snaps his fingers and claims to have an idea. He pulls the wildman forward, and the two walk straight toward the village\'s beloved skull.\n\nThe anatomist pushes the wildman before the praying folk, and claims that they have murdered one who is cousin to his being. He states that by stealing the skull of his kin, they have doomed him to a life of being cursed. The crowd is horrified, not realizing the error of their ways. The wildman eats another worm. You continue to watch as the anatomist picks up the skull, lofts it over his head, and says that with this he may finally heal %wildman% of what ails him, and through him also lift any curses which have befallen the village itself. By this point the crowd is arisen, taken to the anatomist like a tentpole priest, and they clap as he leaves, cheering the theft as it were, the skull lofted above his head. The two men return to you. %anatomist% grins.%SPEECH_ON%To study the body, one shouldn\'t forget to study the mind, and in studying the mind, one shouldn\'t forget to study minds, plural! For many minds put together are a creature to study in and of themselves.%SPEECH_OFF%The anatomist walks off. A group of peasants approach carrying goods of all sorts. They throw them at the feet of %wildman% in apology. The wildman eats another worm.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hmm, alright.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired an unusual skull to study");
				_event.m.Wildman.improveMood(1.0, "Helped " + _event.m.Anatomist.getName() + " acquire an unusual skull");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				if (_event.m.Wildman.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}

				local initiativeBoost = this.Math.rand(1, 3);
				_event.m.Anatomist.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Initiative"
				});
				_event.m.Wildman.addXP(75, false);
				_event.m.Wildman.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Wildman.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+75[/color] Experience"
				});
				local food;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					food = this.new("scripts/items/supplies/cured_venison_item");
				}
				else if (r == 2)
				{
					food = this.new("scripts/items/supplies/pickled_mushrooms_item");
				}
				else if (r == 3)
				{
					food = this.new("scripts/items/supplies/roots_and_berries_item");
				}

				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				local goods;
				r = this.Math.rand(1, 2);

				if (r == 1)
				{
					goods = this.new("scripts/items/trade/cloth_rolls_item");
				}
				else if (r == 2)
				{
					goods = this.new("scripts/items/trade/peat_bricks_item");
				}

				this.World.Assets.getStash().add(goods);
				this.List.push({
					id = 10,
					icon = "ui/items/" + goods.getIcon(),
					text = "You gain " + goods.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local thief_candidates = [];
		local wildman_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.thief")
			{
				thief_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.wildman")
			{
				wildman_candidates.push(bro);
			}
		}

		if (thief_candidates.len() > 0)
		{
			this.m.Thief = thief_candidates[this.Math.rand(0, thief_candidates.len() - 1)];
		}

		if (wildman_candidates.len() > 0)
		{
			this.m.Wildman = wildman_candidates[this.Math.rand(0, wildman_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() > 0)
		{
			this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Score = 5 + anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getNameOnly() : ""
		]);
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Thief = null;
		this.m.Wildman = null;
	}

});

