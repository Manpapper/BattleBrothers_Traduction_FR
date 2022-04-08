this.anatomist_vs_asthmatic_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Asthmatic = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_asthmatic";
		this.m.Title = "During camp...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You come up on %anatomist% the anatomist talking to %asthmatic%, a man who is notoriously bad at the simple act of breathing. Almost on cue, the man comes to you with a request. He says that the anatomist has a means to possibly heal his poor lungs. %anatomist% nods.%SPEECH_ON%It is but a small procedure, albeit painful. This daring subject - excuse me, this daring animal - goodness, excuse me, this daring patient has steadied himself of that challenge and is ready to take it on in full. With your say so, I may begin the process and have it done in no time at all.%SPEECH_OFF%You\'re not sure about this, but it would be nice if %asthmatic% could stop wheezing in the middle of the night like some rabbit having the life squeezed out of it.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do it, but be careful.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Do it, and use whatever means necessary.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "No, I won\'t risk his life on this.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You okay the procedure and the two disappear for a time. Not long after, %asthmatic% the man with lungs like a dead dog being stepped on comes to you with a wide grin. He stands straight, puffs out his chest, and takes a long, deep breath, his body swelling like a toad, his cheeks puffing, then he slowly, slowly lets the air out. There is no wheeze. There is no scratch in the throat. His face does not get red. His arms slacken, yet he does not become dizzy.%SPEECH_ON%That anatomist got me patched up just right. He is but a miracle on legs.%SPEECH_OFF%The man turns around, revealing a series of holes in his flesh which suck and pucker as he breathes. %anatomist% comes around cleaning some strange metal utensil. He shakes his head.%SPEECH_ON%At least one of us is satisfied with the results as they have arrived.%SPEECH_OFF%You\'re not sure why the anatomist is upset, but you do get a glance at one of his texts which reveals an operation of lung-removal via scalpel and spoon. Surely that wasn\'t what he did to %asthmatic%. Surely.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Surely...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Asthmatic.getSkills().removeByID("trait.asthmatic");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_22.png",
					text = _event.m.Asthmatic.getName() + " is no longer Asthmatic"
				});
				_event.m.Asthmatic.addHeavyInjury();
				this.List.push({
					id = 11,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Asthmatic.getName() + " suffers heavy wounds"
				});
				_event.m.Asthmatic.improveMood(1.0, "Is no longer asthmatic");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 11,
						icon = this.Const.MoodStateIcon[_event.m.Asthmatic.getMoodState()],
						text = _event.m.Asthmatic.getName() + this.Const.MoodStateEvent[_event.m.Asthmatic.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You okay the procedure. %asthmatic% turns around to tell the anatomist, who promptly sticks a metal prong deep into the man\'s chest. The man winces and yelps, his fingers curling as though to grasp the pain itself. He reels backward as %anatomist% holds the utensil like a shank. As the anatomist steps forward for another stab, you jump forward and stop him. He looks at you with confusion.%SPEECH_ON%This is part of the process, do you not understand? Now, I must continue with the puncturing. We will put eight more holes into him.%SPEECH_OFF%%asthmatic% screams, rather undignified in his protest of the process. You tell the anatomist that this is over. He sighs, lowering the tool.%SPEECH_ON%Anything of import requires pain, sellsword. Whether it is you acquiring heads to sell for crowns, or myself, pursuing a cure. If pain were not a critical element, we would not be upsetting the natural order in our own ways.%SPEECH_OFF%You tell him to shut his mouth and that it\'s over. He sighs and walks away, cleaning the utensil with a rag. %asthmatic% wheezes a thanks to you for intervening.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Just take it easy for a bit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Asthmatic.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Asthmatic.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Asthmatic.worsenMood(0.5, "Was injured by a madman");

				if (_event.m.Asthmatic.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 11,
						icon = this.Const.MoodStateIcon[_event.m.Asthmatic.getMoodState()],
						text = _event.m.Asthmatic.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 11,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You think why not just go full donkey and take the experimental route? %asthmatic% agrees.%SPEECH_ON%If this is going to hurt, might as well make it worth my while.%SPEECH_OFF%As the two leave to a tent, a part of you considers watching. Another part realizes you probably don\'t have the stomach for it, whatever it is, and also that you don\'t want your presence alone to interfere with the anatomist\'s work. That said, it actually does not take long for the two to reemerge. %asthmatic% stands up straight, breathing in long and heavy, and then letting it all out in one smooth breath.%SPEECH_ON%I have never felt better.%SPEECH_OFF%He says, then shakes %anatomist%\'s hand. The healed man walks off. %anatomist% cleans his hands off.%SPEECH_ON%Unfortunately, there were a few complications. Let me see, what do we have...%SPEECH_OFF%The anatomist unfurls a scroll with hastily written notes, some of which are covered in blood. You read...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oh. Oh no.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Asthmatic.getSkills().removeByID("trait.asthmatic");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_22.png",
					text = _event.m.Asthmatic.getName() + " is no longer Asthmatic"
				});
				local trait = this.new("scripts/skills/traits/iron_lungs_trait");
				_event.m.Asthmatic.getSkills().add(trait);
				this.List.push({
					id = 11,
					icon = trait.getIcon(),
					text = _event.m.Asthmatic.getName() + " gains Iron Lungs"
				});
				local new_traits = [
					"scripts/skills/traits/bloodthirsty_trait",
					"scripts/skills/traits/brute_trait",
					"scripts/skills/traits/cocky_trait",
					"scripts/skills/traits/deathwish_trait",
					"scripts/skills/traits/dumb_trait",
					"scripts/skills/traits/gluttonous_trait",
					"scripts/skills/traits/impatient_trait",
					"scripts/skills/traits/irrational_trait",
					"scripts/skills/traits/paranoid_trait",
					"scripts/skills/traits/spartan_trait",
					"scripts/skills/traits/superstitious_trait"
				];
				local num_new_traits = 2;

				while (num_new_traits > 0 && new_traits.len() > 0)
				{
					local trait = this.new(new_traits.remove(this.Math.rand(0, new_traits.len() - 1)));

					if (!_event.m.Asthmatic.getSkills().hasSkill(trait.getID()))
					{
						_event.m.Asthmatic.getSkills().add(trait);
						this.List.push({
							id = 12,
							icon = trait.getIcon(),
							text = _event.m.Asthmatic.getName() + " gains " + trait.getName()
						});
						num_new_traits = num_new_traits - 1;
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You tell %anatomist% no. The anatomist purses his lips and makes some eggheaded argument about the value of medicine and science, and you tell him about the value of a sellsword who doesn\'t have some fool goofing around with his lungs.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Yeah yeah, go cry into your textbooks.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
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
		local anatomistCandidates = [];
		local asthmaticCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.asthmatic"))
			{
				asthmaticCandidates.push(bro);
			}
		}

		if (asthmaticCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Asthmatic = asthmaticCandidates[this.Math.rand(0, asthmaticCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * asthmaticCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"asthmatic",
			this.m.Asthmatic.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Asthmatic = null;
	}

});

