this.education_event <- this.inherit("scripts/events/event", {
	m = {
		DumbGuy = null,
		Scholar = null
	},
	function create()
	{
		this.m.ID = "event.education";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_15.png[/img]Au cours de vos voyages, %scholar% s\'est intéressé aux lacunes intellectuelles de %dumbguy%. %scholar_short% dit qu\'avec un peu de temps, il pourrait apprendre à cet homme une chose ou deux. %dumbguy_short% peut mettre un pied devant l\'autre - et parfois avec beaucoup d\'assurance - mais vous pensez que ses aptitudes s\'arrêtent là. De plus, %scholar_short% a déjà été facilement frustré par le passé. Enseigner au frère stupide pourrait n\'être qu\'un exercice pour gonfler son propre ego.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyez ce que vous pouvez lui apprendre.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "B" : "C";
					}

				},
				{
					Text = "Laisse %dumbguy% tranquille.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_15.png[/img]{Vous croisez %scholar% et %dumbguy% qui fixent un morceau de terre. Le long de la toile brune, vous voyez que %scholar_short% a dessiné des formes géométriques, des lettres, des chiffres et ce qui ressemble à des constellations. Il semble qu\'ils soient là depuis des heures maintenant.\n\nUn bâton d\'enseignement à la main, %scholar% montre du doigt l\'un des amas d\'étoiles et demande à savoir ce que c\'est. %dumbguy%, avec une expression douloureuse, devine un mouton. %scholar% casse le bâton d\'enseignement en deux et jette de la terre sur ses dessins. C\'est un cheval ! Un cheval ! %scholar% soupire lourdement avant de s\'en aller d\'un air dépité. Personnellement, vous pensiez que c\'était un crabe. | Vous trouvez %scholar% debout devant %dumbguy%. Compte les coléoptères, ne les écrase pas, dit le savant avec exaspération. %dumbguy% regarde ses mains pleines de coléoptères où {des fragments de carapaces d\'insectes | des carapaces d\'anciens insectes} parsèment sa chair. Il acquiesce, compréhensif, et se met à arracher les pattes des scarabées. %scholar% laisse échapper une série de jurons que vous n\'aviez jamais entendus de votre vie. | Vous trouvez %scholar% et %dumbguy% qui se crient dessus. Il semble qu\'ils soient dans une impasse. %dumbguy_short% dit qu\'il ne se soucie pas qu\'il soit idiot, et %scholar_short% soutient que tout homme devrait être instruit. Il semble que %dumbguy_short% préfère être laissé seul car il montre son dos à %scholar_short% en s\'éloignant. Je suppose que c\'est la fin de la leçon pour les deux hommes. | Vous trouvez %dumbguy% accroupi près d\'un ruisseau, se regardant dans le reflet miroitant. Il doit être là depuis un moment maintenant car il montre des signes de coups de soleil. Vous lui demandez si tout va bien, ce à quoi il répond qu\'il n\'arrive pas à suivre les enseignements de %scholar% et que %scholar% a failli devenir fou aujourd\'hui avant d\'abandonner l\'experience. Vous expliquez à %dumbguy% qu\'il n\'a pas besoin d\'être intelligent, il doit juste savoir manier l\'épée et tirer à l\'arc. C\'est pour cela que vous l\'avez engagé, après tout. L\'homme essaie de cacher un sourire, mais l\'eau courante le trahit. Vous le ramenez au camp où vous dites à %scholar% de se reposer un peu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Pourquoi n\'apprends-tu pas ? ! | L\'ignorance est une bénédiction.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());
				_event.m.Scholar.worsenMood(2.0, "N\'a pas réussi à faire apprendre quelque chose à " + _event.m.DumbGuy.getName());

				if (_event.m.Scholar.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List = [
						{
							id = 10,
							icon = this.Const.MoodStateIcon[_event.m.Scholar.getMoodState()],
							text = _event.m.Scholar.getName() + this.Const.MoodStateEvent[_event.m.Scholar.getMoodState()]
						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_15.png[/img]{Vous rencontrez %dumbguy% qui réfléchit devant un ensemble de pièces de monnaie sur une table. Vous lui demandez ce qu\'il fait et il vous répond qu\'il essaie de savoir combien il doit économiser pour sa retraite. D\'abord, vous êtes surpris qu\'il sache ce que signifie le mot retraite. Et puis, il sait compter ? On dirait que vous devez une pinte à %scholar%. | Vous trouvez %dumbguy% assis sur une souche alors qu\'il écrit sur un parchemin. Lorsque vous lui demandez ce qu\'il fait, il répond qu\'il écrit une lettre. Lorsque vous lui demandez à qui elle est adressée, l\'homme lève les yeux au ciel avec un sourire coupable et vous demande si cela a de l\'importance. À ce moment-là, vous apercevez %scholar% au loin, les bras croisés, un air de satisfaction sur le visage.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fascinant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());
				_event.m.Scholar.improveMood(2.0, "A appris quelque chose à " + _event.m.DumbGuy.getName());
				_event.m.DumbGuy.getSkills().removeByID("trait.dumb");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_17.png",
					text = _event.m.DumbGuy.getName() + " n\'est plus idiot"
				});

				if (_event.m.Scholar.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Scholar.getMoodState()],
						text = _event.m.Scholar.getName() + this.Const.MoodStateEvent[_event.m.Scholar.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local dumb_candidates = [];
		local scholar_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.dumb"))
			{
				dumb_candidates.push(bro);
			}
			else if ((bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.historian") && !bro.getSkills().hasSkill("trait.hesitant"))
			{
				scholar_candidates.push(bro);
			}
		}

		if (dumb_candidates.len() == 0 || scholar_candidates.len() == 0)
		{
			return;
		}

		this.m.DumbGuy = dumb_candidates[this.Math.rand(0, dumb_candidates.len() - 1)];
		this.m.Scholar = scholar_candidates[this.Math.rand(0, scholar_candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dumbguy",
			this.m.DumbGuy.getName()
		]);
		_vars.push([
			"dumbguy_short",
			this.m.DumbGuy.getNameOnly()
		]);
		_vars.push([
			"scholar",
			this.m.Scholar.getName()
		]);
		_vars.push([
			"scholar_short",
			this.m.Scholar.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.DumbGuy = null;
		this.m.Scholar = null;
	}

});

