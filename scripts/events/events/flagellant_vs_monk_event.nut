this.flagellant_vs_monk_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.flagellant_vs_monk";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Le feu de camp brille, tordant les visages des hommes en orange vif comme s\'ils étaient eux-mêmes des souches ardente.\n\n C\'est ici que vous trouvez %monk% et %flagellant% en train de discuter. Leur discussion est, au début, banale. Le moine supplie le flagellant de mettre son fouet de côté. Bien que vous ne souhaitiez pas nécessairement intervenir, vous ne pouvez vous empêcher de penser que détruire votre propre corps dans une émission gore n\'est pas la meilleure façon de vivre. Mais le flagellant rétorque alors quelque chose qui vous fait réfléchir tous les deux. C\'est une phrase si bien faite que penser qu\'elle pourrait justifier les habitudes personnelles de l\'homme mais vous chasser cette idée de votre tête aussi vite que possible. La facilité avec laquelle il l\'a prononcée est également troublante. Qu\'une voix si apaisante puisse être si chaudement enveloppée dans ce tas de chair balafré. Qu\'est-ce qui pourrait en être la cause ?\n\n Le moine balbutie un instant, puis pose ses mains sur les épaules du flagellant, le retenant pour qu\'ils ne se quittent pas des yeux. Il chuchote, des mots qui vous chatouillent les oreilles, mais ils ne sont pas prononcés assez fort pour avoir un sens réel. Vous ne pouvez que supposer qu\'ils sont destinés, une fois de plus, à persuader le flagellant de mener une vie meilleure et moins violente.\n\n Mais, à nouveau, le flagellant commence à répondre et ainsi ils continuent à se renvoyer la balle.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est fascinant. Voyons voir où cela nous mène.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Bon, ça suffit. Nous avons du vrai travail à faire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Décidant de laisser les hommes parler, vous vous éloignez un moment.\n\n Lorsque vous revenez, vous trouvez le flagellant assis à côté du moine. Tous deux font des allers-retours sur un tronc d\'arbre, les mains jointes en prière tandis que des murmures de paroles célestes s\'échappent de leurs lèvres. Vous n\'avez aucune envie de vous rapprocher pour entendre ce qu\'ils disent, car c\'est une vision réconfortante en soi. Bien que vous ne sachiez pas quelle est la meilleure façon d\'apaiser les dieux, vous ne pouvez vous empêcher de vous sentir un peu mieux en voyant le flagellant déposer ses outils d\'auto-torture.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Que cet homme puisse vivre en paix maintenant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local background = this.new("scripts/skills/backgrounds/pacified_flagellant_background");
				_event.m.Flagellant.getSkills().removeByID("background.flagellant");
				_event.m.Flagellant.getSkills().add(background);
				_event.m.Flagellant.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Flagellant.getName() + " est maintenant un Flagellant pacifié"
					}
				];
				_event.m.Monk.getBaseProperties().Bravery += 2;
				_event.m.Monk.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] de Détermination"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Décidant de laisser les hommes parler, vous vous éloignez un moment.\n\nQuand vous revenez, le moine est nu et courbé, les larmes aux yeux. Sa forme est frêle, mais son visage est impassible, comme si c\'était ce qu\'il avait toujours voulu. Avec une bouffée d\'air, il se redresse et passe son poignet par-dessus son épaule. Le fouet du flagellant est en main et vous entendez le cuir claquer contre le dos du moine. Il retire l\'outil et le son du verre et des pointes déchirant la chair provoque un bourdonnement dans vos oreilles. Le flagellant lui-même ne dit rien. Il s\'est installé aux côtés du moine. Il regarde la terre, mais il y a à peine une lueur de vie dans ses yeux, bien que vous voyiez certainement le sang de sa vie quitter son dos pendant qu\'il se fait battre.\n\nVous vous éloignez une fois de plus, mais l\'herbe sous vos pieds n\'a pas le même craquement et l\'air porte une odeur de cuivre. De petits claquements de cuir vous suivent tout le long du chemin jusqu\'à votre tente.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'est-ce que je viens de voir ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local background = this.new("scripts/skills/backgrounds/monk_turned_flagellant_background");
				_event.m.Monk.getSkills().removeByID("background.monk");
				_event.m.Monk.getSkills().add(background);
				_event.m.Monk.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Monk.getName() + " est maintenant un moine devenu Flagellant"
					}
				];
				_event.m.Flagellant.getBaseProperties().Bravery += 2;
				_event.m.Flagellant.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Flagellant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] de Détermination"
				});
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

		local flagellant_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.flagellant")
			{
				flagellant_candidates.push(bro);
			}
		}

		if (flagellant_candidates.len() == 0)
		{
			return;
		}

		local monk_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
		}

		if (monk_candidates.len() == 0)
		{
			return;
		}

		this.m.Flagellant = flagellant_candidates[this.Math.rand(0, flagellant_candidates.len() - 1)];
		this.m.Monk = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk.getName()
		]);
		_vars.push([
			"flagellant",
			this.m.Flagellant.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.Flagellant = null;
	}

});

