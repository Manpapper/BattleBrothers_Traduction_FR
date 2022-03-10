this.swordmaster_teaches_event <- this.inherit("scripts/events/event", {
	m = {
		Student = null,
		Teacher = null
	},
	function create()
	{
		this.m.ID = "event.swordmaster_teaches";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]On entend la voix d\'un vieil homme qui donne des ordres à voix basse.%SPEECH_ON% Le pied mène, le corps suit. Encore.%SPEECH_OFF%Vous trouvez %swordmaster% le maître d\'épée et %swordstudent% s\'entraînant dans un champ. L\'aîné secoue la tête à la plus récente démonstration d\'épée.%SPEECH_ON%Le pied mène, le corps suit. Encore une fois!%SPEECH_OFF%L\'élève pratique ce qu\'on lui enseigne. En hochant la tête, le maître d\'armes aboie un autre ordre.%SPEECH_ON%Maintenant faites le en sens inverse. Le pied recule, le corps suit. Ne recule pas avec ton esprit. Laisse tes pieds réfléchir pour toi. L\'instinct, c\'est la survie ! Penser, c\'est mourir ! Bougez comme si le monde l\'exigeait. Si le vent souffle, es-tu plus rapide que les feuilles qui entendent son appel ? Je vois. Bien... tu apprends. Maintenant... encore.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maintenant, fais-en bon usage.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				this.Characters.push(_event.m.Student.getImagePath());
				local meleeDefense = this.Math.rand(1, 4);
				_event.m.Student.getBaseProperties().MeleeDefense += meleeDefense;
				_event.m.Student.getSkills().update();
				_event.m.Student.getFlags().add("taughtBySwordmaster");
				_event.m.Student.improveMood(0.5, "A appris de " + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(1.0, "A fait apprendre à " + _event.m.Student.getName() + " quelque chose");
				this.List = [
					{
						id = 17,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.Student.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeDefense + "[/color] de Defense à Distance"
					}
				];

				if (_event.m.Teacher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Teacher.getMoodState()],
						text = _event.m.Teacher.getName() + this.Const.MoodStateEvent[_event.m.Teacher.getMoodState()]
					});
				}

				if (_event.m.Student.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Student.getMoodState()],
						text = _event.m.Student.getName() + this.Const.MoodStateEvent[_event.m.Student.getMoodState()]
					});
				}
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

		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 4 && (bro.getBackground().getID() == "background.swordmaster" || bro.getBackground().getID() == "background.old_swordmaster"))
			{
				teacher_candidates.push(bro);
			}
		}

		if (teacher_candidates.len() < 1)
		{
			return;
		}

		local student_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && !bro.getFlags().has("taughtBySwordmaster") && (bro.getBackground().getID() == "background.squire" || bro.getBackground().getID() == "background.bastard" || bro.getBackground().getID() == "background.adventurous_noble" || bro.getBackground().getID() == "background.disowned_noble" || bro.getBackground().getID() == "background.regent_in_absentia"))
			{
				student_candidates.push(bro);
			}
		}

		if (student_candidates.len() < 1)
		{
			return;
		}

		this.m.Student = student_candidates[this.Math.rand(0, student_candidates.len() - 1)];
		this.m.Teacher = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
		this.m.Score = teacher_candidates.len() * 4;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"swordstudent",
			this.m.Student.getName()
		]);
		_vars.push([
			"swordmaster",
			this.m.Teacher.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Student = null;
		this.m.Teacher = null;
	}

});

