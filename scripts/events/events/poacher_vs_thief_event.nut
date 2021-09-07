this.poacher_vs_thief_event <- this.inherit("scripts/events/event", {
	m = {
		Poacher = null,
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.poacher_vs_thief";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]Vous sortez de votre tente pour voir %poacher% et %thief% se régaler des histoiresde l\'autre. Vous ne savez pas trop ce qu\'un braconnier et un voleur ont en commun, mais ils ont l\'air de bien s\'amuser. En riant, %poacher% raconte une autre histoire.%SPEECH_ON% Une fois, j\'étais sur les terres de ce noble prétentieux pour chasser ce cerf. Tuer ce satané cerf était la partie facile. Au milieu de la préparation du terrain, j\'entends les sabots battre la terre. Alors j\'ai fait courir une corde le long d\'un arbre, j\'y ai attaché la carcasse, et j\'ai tiré cet l\'animal vers le haut. Pas plus d\'une minute plus tard, badda-badda-badda, voilà le noble avec le shérif et sa suite d\'hommes de loi.%SPEECH_OFF%%thief% lève un sourcil.%SPEECH_ON% C\'était tendu, monsieur.%SPEECH_OFF% Le braconnier acquiesce.%SPEECH_ON% Plus tendu qu\'une vierge en croix. Donc ce noble vient se promener juste en dessous de moi et voit tout le sang. Il commence à aboyer que je sorte et que je me rende. Je n\'avais pas l\'intention de le faire, mais malheureusement, ce satané daim commence à glisser. J\'ai tendu le bras pour l\'attraper et je suppose que la branche n\'en pouvait plus et a cassé. Le noble lève les yeux juste à temps pour se faire éclabousser par le ventre de ce cerf, tandis que je tombe vers une mort certaine jusqu\'à ce que cette maudite corde m\'accroche le pied et me pende à l\'envers devant mes créateurs. Je fais un petit signe de la main, \"Hé les gars, je ne voulais pas faire irruption comme ça.\"%SPEECH_OFF% Le voleur rit, mais son visage est un peu inquiet. Le voleur lui fait signe de partir. %SPEECH_ON%Oh, ils avaient le sens de l\'humour, grâce aux dieux. J\'ai passé six petits mois dans une fosse sombre. Rien de bien méchant, vraiment.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Poacher.getImagePath());
				this.Characters.push(_event.m.Thief.getImagePath());
				_event.m.Poacher.improveMood(1.0, "Bonded with " + _event.m.Thief.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Poacher.getMoodState()],
					text = _event.m.Poacher.getName() + this.Const.MoodStateEvent[_event.m.Poacher.getMoodState()]
				});
				_event.m.Thief.improveMood(1.0, "Bonded with " + _event.m.Poacher.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Thief.getMoodState()],
					text = _event.m.Thief.getName() + this.Const.MoodStateEvent[_event.m.Thief.getMoodState()]
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

		local poacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.poacher")
			{
				poacher_candidates.push(bro);
			}
		}

		if (poacher_candidates.len() == 0)
		{
			return;
		}

		local thief_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.thief")
			{
				thief_candidates.push(bro);
			}
		}

		if (thief_candidates.len() == 0)
		{
			return;
		}

		this.m.Poacher = poacher_candidates[this.Math.rand(0, poacher_candidates.len() - 1)];
		this.m.Thief = thief_candidates[this.Math.rand(0, thief_candidates.len() - 1)];
		this.m.Score = (poacher_candidates.len() + thief_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"poacher",
			this.m.Poacher.getNameOnly()
		]);
		_vars.push([
			"thief",
			this.m.Thief.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Poacher = null;
		this.m.Thief = null;
	}

});

