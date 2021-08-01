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
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous voyiez une ombre à vos pieds. Quand vous vous retournez, %brawler% se tient là avec un regard plutôt distant. Il fait craquer ses articulations pendant un long moment avant de demander s\'il peut entraîner %noncom%. Vous demandez pourquoi. Le bagarreur vous regarde de haut.%SPEECH_ON%Parce qu\'il est faible.SPEECH_OFF%Hmmm, c\'est suffisant.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons voir combien de temps vous pouvez le faire durer.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Endurcissez-le, d\'accord?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Montre-lui comment se battre.",
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
				_event.m.Brawler.improveMood(0.25, "A endurci " + _event.m.Student.getName());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img]%brawler% et %noncom% se trouvent dans de la boue, les mains enveloppées dans du tissu et des feuilles, pour rembourrer les poings et les empêcher de se blesser à chaque coup de poing. Le bagarreur fait se déplacer son apprenti dans le sens inverse des aiguilles d\'une montre le long du cercle de combat, l\'entraîneur le frappe ou lui donne des coups de pied à chaque fois qu\'il passe. Les hommes sont couverts de sueur pendant qu\'ils s\'entraînent. Quand %noncom% commence à ralentir, %brawler% le frappe comme un jockey le ferait avec un cheval paresseux.\n\nAprès une heure, le %brawler% se retire et invite son apprenti à l\'attaquer. Comme on pouvait s\'y attendre, l\'attaque est sans précision et pitoyable. De longs coups de poing ont lancés sans aucune énergie. Le bagarreur esquive et s\'écarte de la trajectoire, repoussant chaque tentative de coup avec un contre coup de son invention.%SPEECH_ON%Tu vois ce qui se passe quand tu es fatigué ? C\'est pourquoi nous devons nous entraîner. Même les hommes les plus habiles et les plus mortels ne valent rien sans endurance et sans jambes endurcies.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je suis fatigué rien qu\'en regardant.",
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
					text = _event.m.Student.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + skill + "[/color] de Fatigue Maximum"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]Le bagarreur fait %noncom% se tenir complètement immobile. Il tourne autour de l\'homme, faisant craquer ses articulations en le jaugeant. Finalement, il laisse ses intentions être connues.%SPEECH_ON%Je vais te battre jusqu\'à ce que tu craques.%SPEECH_OFF%Un moment est accordé à l\'apprenti pour qu\'il comprenne ce qui va se passer. Il aspire une grande bouffée d\'air et fait un signe de tête. %brawler% ne perd pas de temps et envoie un coup en plein dans la poitrine de l\'apprenti. Il se renverse et reçoit plusieurs coups de pied dans l\'épaule jusqu\'à ce qu\'il se relève.\n\nLe bagarreur continue à tourner en rond et à donner des coups. Chaque coup n\'est pas lancé avec conviction : la plupart sont destinés à infliger de la douleur, mais aucun coups n\'est donné pour causer des dommages irréversibles. Le bagarreur, s\'il le voulait, pourrait tuer cet homme à mains nus, mais ce n\'est pas le but de cet entraînement. Vous réalisez que ce mode de \"durcissement\" est probablement le même que le bagarreur à eu un moment ou à un autre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce qui ne vous tue pas vous rend plus fort.?",
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
					text = _event.m.Student.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + skill + "[/color] de Points de Vie"
				});
				_event.m.Student.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Student.getName() + " souffre de blessures légères"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_06.png[/img]%brawler%, le bagarreur aux mains lourdes et à l\'allure brutale, est penché les bras en croisés, et %noncom% se tient à côté, essayant d\'imiter la posture. Le bagarreur se baisse et passe derrière %noncom%, il passe ses deux mains autour de la taille de l\'homme et le soulève dans les airs avant de le jeter sur le dos. %brawler% s\'éloigne, fait craquer ses articulations et dit à %noncom% de se lever.%SPEECH_ON%Tu dois être prêt pour deux choses : quand je j\'attaque par le bas, quand je j\'attaque par le haut.%SPEECH_OFF%%noncom% se dépoussière puis se plaint un peu.%SPEECH_ON%Comment puis-je faire les deux ?%SPEECH_OFF%Le bagarreur ignore la question et demande simplement à l\'homme de l\'attaquer. %noncom% oblige, il arrive avec une attaque par le haut avec son poing. %brawler% dévie le coup avec une roulade avant de lancer un contre croisé qui fait tourner %noncom% sur ses pieds. Le boxeur fait à nouveau craquer ses articulations et crache.%SPEECH_ON%La pratique. C\'est comme ça. Maintenant, relève-toi et recommence.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Peut-être qu\'il deviendra un vrai mercenaire après tout.",
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
					text = _event.m.Student.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + attack + "[/color] de Maîtrise de Mêlée"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Student.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + defense + "[/color] de Maîtrise à Distance"
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

