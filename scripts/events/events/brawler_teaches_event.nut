this.brawler_teaches_event <- this.inherit("scripts/events/event", {
	m = {
		Brawler = null,
		Student = null
	},
	function create()
	{
		this.m.ID = "event.brawler_teaches";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]A shadow crosses over you from behind. When you look back, %brawler% is standing there with a rather distant look in his eyes. He cracks his knuckles in one long staccato before asking if he can train up %noncom%. You ask why. The brawler looks down at you.%SPEECH_ON%Because he is weak.%SPEECH_OFF%Hmmm, good enough.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "See how long you can keep him going.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Toughen him up, will you?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Show him how to brawl.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.Characters.push(_event.m.Student.getImagePath());
				_event.m.Brawler.getFlags().add("brawler_teaches");
				_event.m.Student.getFlags().add("brawler_teaches");
				_event.m.Brawler.improveMood(0.25, "Has toughened up " + _event.m.Student.getName());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img]%brawler% and %noncom% are found in a mudpit with their hands wrapped in cloth and leaves, padding for the knuckles and to keep them from cutting one another with every punch. The brawler has his trainee bouncing counter-clockwise along the ring of the fighting circle, punching the air as he goes, and with his trainer hitting or kicking him every time he passes by. The men glisten with sweat as they work. When %noncom% begins to slow, %brawler% hits him as though a jockey would a sluggish horse.\n\n After an hour of this, %brawler% steps back and invites his trainee to attack him. Predictably, the assault is aimless and pitiful. Long, looping punches are thrown with no energy behind them. The brawler ducks and weaves out of the way, punching every attempted strike with a counter-punch of his own.%SPEECH_ON%See what happens when you are tired? This is why we must train. Even the most able and deadly are worth nothing without air in their lungs and fresh legs beneath them.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'m getting tired just watching this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.Characters.push(_event.m.Student.getImagePath());
				local skill = this.Math.rand(2, 4);
				_event.m.Student.getBaseProperties().Stamina += skill;
				_event.m.Student.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Student.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + skill + "[/color] Max Fatigue"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]The brawler has %noncom% stand completely still. He circles about the man, cracking his knuckles as he sizes him up. Finally, he lets his intentions be known.%SPEECH_ON%I am going to beat you until you break.%SPEECH_OFF%A moment is given to the trainee to acknowledge what is about to happen. He sucks in a great gulp of breath and then nods. %brawler% wastes no time wheeling a bola punch right into the man\'s chest. He bowls over at which point he is kicked in the shoulder repeatedly until he stands back up.\n\nThere the brawler continues to circle and deliver blows. Not every strike is thrown with conviction: most are meant to inflict pain, but not what could be called irreversible damage. The brawler, if he wanted to, could kill this man with his bare fists, but that is not the purpose of this training. You realize that this mode of \'toughening up\' probably happened to the brawler himself at some point or another.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What doesn\'t kill you makes you stronger?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.Characters.push(_event.m.Student.getImagePath());
				local skill = this.Math.rand(2, 4);
				_event.m.Student.getBaseProperties().Hitpoints += skill;
				_event.m.Student.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Student.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + skill + "[/color] Hitpoints"
				});
				_event.m.Student.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Student.getName() + " suffers light wounds"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_06.png[/img]%brawler% the heavy-handed-rough-and-tumble brawler is found leaning over, his arms fenced out before himself in a defensive posture, and %noncom% is standing adjacent, trying to mimic the stance. The brawler drops his body low and shoots in under %noncom%\'s arms, there wrapping both hands around the man\'s waist and lifting him up in the air before dumping him on his back. %brawler% steps away, cracking his knuckles and telling %noncom% to get up.%SPEECH_ON%You need to be ready for two things: me coming in low, and me coming in high.%SPEECH_OFF%%noncom% dusts himself off then complains a little.%SPEECH_ON%How can I possibly do both?%SPEECH_OFF%The brawler ignores the question and simply asks the man to attack him. %noncom% obliges, coming in high with a hurled fist. %brawler% deflects the blow with a shoulder-roll before throwing a cross-counter that has %noncom% spinning on his feet. The fist-fighter cracks his knuckles again and spits.%SPEECH_ON%Practice. That\'s how. Now get back up and let\'s go again.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maybe he\'ll shape up to be a real mercenary after all.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.Characters.push(_event.m.Student.getImagePath());
				local attack = this.Math.rand(1, 2);
				local defense = this.Math.rand(1, 2);
				_event.m.Student.getBaseProperties().MeleeSkill += attack;
				_event.m.Student.getBaseProperties().MeleeDefense += defense;
				_event.m.Student.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Student.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + attack + "[/color] Maîtrise de Mêlée"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Student.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + defense + "[/color] Maîtrise à Distance"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_brawler = [];
		local candidates_student = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("brawler_teaches"))
			{
				continue;
			}

			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.brawler")
			{
				candidates_brawler.push(bro);
			}
			else if (bro.getLevel() < 3 && !bro.getBackground().isCombatBackground())
			{
				candidates_student.push(bro);
			}
		}

		if (candidates_brawler.len() == 0 || candidates_student.len() == 0)
		{
			return;
		}

		this.m.Brawler = candidates_brawler[this.Math.rand(0, candidates_brawler.len() - 1)];
		this.m.Student = candidates_student[this.Math.rand(0, candidates_student.len() - 1)];
		this.m.Score = (candidates_brawler.len() + candidates_student.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brawler",
			this.m.Brawler.getNameOnly()
		]);
		_vars.push([
			"noncom",
			this.m.Student.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Brawler = null;
		this.m.Student = null;
	}

});

