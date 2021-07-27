this.juggler_tempts_fate_event <- this.inherit("scripts/events/event", {
	m = {
		Juggler = null,
		NonJuggler = null
	},
	function create()
	{
		this.m.ID = "event.juggler_tempts_fate";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%juggler% the light-footed, swift-handed juggler is going around asking the brothers to throw him some knives. It appears that he is looking to show off his act.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s see what you can do!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "C" : "Fail1";
					}

				},
				{
					Text = "That\'s not what I\'m paying you for.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.getFlags().add("juggler_tempted_fate");
			}

		});
		this.m.Screens.push({
			ID = "Fail1",
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonjuggler% throws a knife across the campground. The blade turns in the sun and you see a strobe of reflected light beam across the juggler\'s eyes. He blinks just long enough for the weapon to sheathe itself in his shoulder. He blinks again, just long enough for the pain to start kicking in. Within a moment, %juggler% is bowled over, clutching his wound in howling pain. A few men tend to him while others can only laugh.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s got to hurt!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local injury = _event.m.Juggler.addInjury([
					{
						ID = "injury.injured_shoulder",
						Threshold = 0.25,
						Script = "injury/injured_shoulder_injury"
					}
				]);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Juggler.getName() + " suffers " + injury.getNameOnly()
					}
				];
				_event.m.Juggler.worsenMood(1.0, "Failed his act and injured himself");

				if (_event.m.Juggler.getMoodState() < this.Const.MoodState.Neutral)
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
			ID = "Fail2",
			Text = "[img]gfx/ui/events/event_05.png[/img]The axe %juggler% asked for is picked up and heaved toward him. It spins at an awkward angle as if the man who threw it intentionally sent it wobbling in indeterminate ways. Not expecting this, the juggler adjusts to try and catch the haywire axe handle, but the weapon smashes into one of the daggers and cuts across his shoulder. He falls to the ground in an instant, a shower of knives falling all around him. While some men tend to his wounds, other can\'t help but be delighted in his suffering.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Is he alright?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local injury = _event.m.Juggler.addInjury(this.Const.Injury.Accident4);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Juggler.getName() + " suffers " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "Fail3",
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonjuggler% picks up the requested flail and, after a moment\'s hesitation, lofts it toward %juggler%. Mid-flight, the chain of the weapon wraps around the handle. The juggler seems to adjust himself for it, but at the last moment the chain unfurls, whipping back around with deadly intent. You see the man\'s eyes flare open as he sees a calamity he can\'t stop from coming. The flail crashes through his maelstrom of metal and clips him in the face. Knocked out cold, he spins on his feet and collapses to the ground. A falling dagger penetrates his leg and the axe cuts tumbles right into his hip. The men gasp in horror and soon every one of them gets up and rushes to his aid.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Is he alive?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local injury = _event.m.Juggler.addInjury(this.Const.Injury.BluntHead);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Juggler.getName() + " suffers " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]You sit down and let the men throw %juggler% a few knives and daggers. They come in and at all shapes and sizes, and from all angles, but he catches them with ease and starts tossing them up into the air, their revolutions glinting and sparkling in the sunlight. Being that each weapon carries a different weight, you\'re impressed by how able he is to keep them all going in seamless unison.\n\n Of course, that couldn\'t just be the end of it. With one hand alternately waving the men on in between juggles, he asks for someone to throw him an axe.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This should be interesting!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "D" : "Fail2";
					}

				},
				{
					Text = "That\'s enough.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 10)
					{
						bro.improveMood(1.0, "Felt entertained");

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
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonjuggler% gets up and heaves an axe into the orbit of %juggler%\'s incredible act. The juggler\'s ring of dangerous weaponry seems to eat the axe in an instant, the weapon simply joining the rest of the knives and daggers in a seamless transition. The men clap and cheer, though a few are seen grinning as though they are waiting for this deck of incredibly sharp cards to come crashing down.\n\n But this isn\'t the end of the act, apparently. This time not waving anybody on, but simply focusing on the swooshing, swishing weaponry swirling about him, the juggler asks for a flail. Someone stands up.%SPEECH_ON%Did he say a flail?%SPEECH_OFF%The juggler stamps his foot.%SPEECH_ON%Yes, a flail! Throw me a flail!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Impossible and yet... I want to see it!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "E" : "Fail3";
					}

				},
				{
					Text = "That\'s it. End this now.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.getBaseProperties().Bravery += 1;
				_event.m.Juggler.getBaseProperties().MeleeSkill += 1;
				_event.m.Juggler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Juggler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Juggler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Maîtrise de Mêlée"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 20)
					{
						bro.improveMood(1.0, "Felt entertained");

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
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]A flail is retrieved and lobbed toward %juggler%. Everyone grimaces as the flail snakes and twirls and undulates toward the spinning storm of weaponry the juggler calls his \'act.\' But, just like the axe, it is quickly absorbed into the maelstrom of metal. Louder than ever, the men get to their feet to cheer and clap. A few sigh in relief, wiping sweat from their brow, while others can only grin and clap, being rather disappointed that nothing spectacularly awful didn\'t happen, but impressed nonetheless.",
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
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.getBaseProperties().Bravery += 2;
				_event.m.Juggler.getBaseProperties().RangedDefense += 2;
				_event.m.Juggler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Juggler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Détermination"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Juggler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Ranged Defense"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 30)
					{
						bro.improveMood(1.0, "Felt entertained");

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
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local juggler_candidates = [];
		local nonjuggler_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.juggler")
			{
				if (!bro.getFlags().has("juggler_tempted_fate"))
				{
					juggler_candidates.push(bro);
				}
			}
			else if (bro.getBackground().getID() != "background.slave")
			{
				nonjuggler_candidates.push(bro);
			}
		}

		if (juggler_candidates.len() == 0 || nonjuggler_candidates.len() == 0)
		{
			return;
		}

		this.m.Juggler = juggler_candidates[this.Math.rand(0, juggler_candidates.len() - 1)];
		this.m.NonJuggler = nonjuggler_candidates[this.Math.rand(0, nonjuggler_candidates.len() - 1)];
		this.m.Score = juggler_candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"juggler",
			this.m.Juggler.getNameOnly()
		]);
		_vars.push([
			"nonjuggler",
			this.m.NonJuggler.getName()
		]);
	}

	function onClear()
	{
		this.m.Juggler = null;
		this.m.NonJuggler = null;
	}

});

