this.apprentice_learns_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Teacher = null
	},
	function create()
	{
		this.m.ID = "event.apprentice_learns";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]L\'apprenti %apprentice% est apparemment devenu un pupille de %teacher%. Bien que le maître d\'armes est vieux, il semble désireux d\'aider le jeune homme à devenir un meilleur combattant. L\'apprenti utilise une vraie épée, le maître d\'armes une épée en bois. C\'est dans cette différence assez importante d\'armes choisies que le maître d\'armes montre l\'utilité du positionnement, de la recherche d\'ouvertures et d\'échapper au danger..\n\nMême dans sa vieillesse, l\'homme tourne et tourbillonne, devenant impossible à frapper pour l\'apprenti. Dans un tour particulièrement brillant, le maître d\'armes sent qu\'il est sur le point d\'être frappé, il se rapproche de l\'apprenti et lui marche sur le pied. Lorsque l\'apprenti se penche en arrière pour se donner de l\'espace, son pied ne le suit pas. Le déséquilibre soudain fait tomber l\'apprenti sur le sol, où il lève les yeux pour trouver une épée en bois sur son cou.\n\nVous trouvez l\'homme en train de se retirer la saleté assez souvent, mais il se lève au moins pour continuer. Disons juste qu\'il s\'améliore petit à petit.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien Joué!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local meleeDefense = this.Math.rand(2, 4);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().MeleeDefense += meleeDefense;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.0, "A appris de " + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.5, "A fait apprendre à " + _event.m.Apprentice.getName() + " quelque chose");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Maîtrise de Mêlée"
					},
					{
						id = 17,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.Apprentice.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeDefense + "[/color] Maîtrise à Distance"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]%teacher% le soldat non retraité s\'est pris d\'affection pour %apprentice%. Vous trouvez les deux s\'entraîner dès que possible. Le vieux soldat croit en la valeur de l\'attaque, montrant à l\'apprenti comment tourner une lame, une hache ou une masse de manière à infliger le plus de dégâts possible. Malheureusement, ils utilisent le matériel de la cantine pour se nattre contre des petites poupées. Le jeune homme a certainement mis le bazar dans ces casseroles dans sa quête permanente de devenir un meilleur combattant.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien Joué!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local resolve = this.Math.rand(2, 5);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().Bravery += resolve;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.0, "A appris de " + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.25, "A fait apprendre à " + _event.m.Apprentice.getName() + " quelque chose");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Maîtrise de Mêlée"
					},
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Apprentice.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Détermination"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Il semblerait que %teacher% le vieux mercenaire ait un petit oiseau qui le suit partout : le jeune %apprentice%. Maintenant en compagnie de mercenaires, l\'apprenti doit vouloir apprendre de ceux qui ont beaucoup d\'expérience sur la route pour gagner des couronnes ensanglantés. Pendant qu\'ils s\'entraînent, vous remarquez que le mercenaire met l\'accent sur l\'exercice du corps d\'un garçon. Être plus rapide que son adversaire et avoir plus d\'endurance sont tout aussi importants que de lui planter une lame dans la boîte crânienne. Le garçon sérieux semble de plus en plus robuste, gagnant une vigueur que vous n\'aviez pas remarqué auparavant.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien Joué!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local initiative = this.Math.rand(4, 6);
				local stamina = this.Math.rand(2, 4);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().Initiative += initiative;
				_event.m.Apprentice.getBaseProperties().Stamina += stamina;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.0, "A appris de " + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.25, "A fait apprendre à " + _event.m.Apprentice.getName() + " quelque chose");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Maîtrise de Mêlée"
					},
					{
						id = 17,
						icon = "ui/icons/initiative.png",
						text = _event.m.Apprentice.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] d\'Initiative"
					},
					{
						id = 17,
						icon = "ui/icons/fatigue.png",
						text = _event.m.Apprentice.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] de Fatigue Maximum"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Plusieurs fois, vous avez surpris %apprentice% regarder %teacher% de loin. Le jeune apprenti semble plutôt séduit par la force brute du chevalier errant. Après quelques jours, le chevalier cède et demande au jeune homme de venir discuter avec lui. Vous ne savez pas ce qu\'ils disent, mais maintenant vous avez remarqué qu\'ils s\'entraînent ensemble. Le chevalier errant n\'est pas non plus un gentil entraîneur. Il bat le garçon fréquemment, pour l\'endurcir. Au début, l\'apprenti recule devant chaque coup, mais vous voyez maintenant qu\'il fait preuve d\'un peu plus de détermination face à une telle adversité. Le chevalier errant montre aussi à l\'apprenti comment tuer rapidement et efficacement. On fait peu fi de la défense dans ces discussions, mais qui a besoin de se défendre contre un adversaire mort?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien Joué!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local hitpoints = this.Math.rand(3, 5);
				local stamina = this.Math.rand(3, 5);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().Hitpoints += hitpoints;
				_event.m.Apprentice.getBaseProperties().Stamina += stamina;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.0, "A appris de " + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.25, "A fait apprendre à " + _event.m.Apprentice.getName() + " quelque chose");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Maîtrise de Mêlée"
					},
					{
						id = 17,
						icon = "ui/icons/health.png",
						text = _event.m.Apprentice.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + hitpoints + "[/color] de Points de Vie"
					},
					{
						id = 17,
						icon = "ui/icons/fatigue.png",
						text = _event.m.Apprentice.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] de Fatigue Maximum"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
	}

	function markAsLearned()
	{
		this.m.Apprentice.getFlags().add("learned");
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local apprentice_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() > 3 && bro.getBackground().getID() == "background.apprentice" && !bro.getFlags().has("learned"))
			{
				apprentice_candidates.push(bro);
			}
		}

		if (apprentice_candidates.len() < 1)
		{
			return;
		}

		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 6)
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.swordmaster" || bro.getBackground().getID() == "background.old_swordmaster" || bro.getBackground().getID() == "background.retired_soldier" || bro.getBackground().getID() == "background.hedgeknight" || bro.getBackground().getID() == "background.sellsword")
			{
				teacher_candidates.push(bro);
			}
		}

		if (teacher_candidates.len() < 1)
		{
			return;
		}

		this.m.Apprentice = apprentice_candidates[this.Math.rand(0, apprentice_candidates.len() - 1)];
		this.m.Teacher = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
		this.m.Score = (apprentice_candidates.len() + teacher_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"apprentice",
			this.m.Apprentice.getNameOnly()
		]);
		_vars.push([
			"teacher",
			this.m.Teacher.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.m.Teacher.getBackground().getID() == "background.swordmaster" || this.m.Teacher.getBackground().getID() == "background.old_swordmaster")
		{
			return "A";
		}
		else if (this.m.Teacher.getBackground().getID() == "background.retired_soldier")
		{
			return "B";
		}
		else if (this.m.Teacher.getBackground().getID() == "background.sellsword")
		{
			return "C";
		}
		else
		{
			return "D";
		}
	}

	function onClear()
	{
		this.m.Apprentice = null;
		this.m.Teacher = null;
	}

});

