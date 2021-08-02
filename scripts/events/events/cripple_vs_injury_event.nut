this.cripple_vs_injury_event <- this.inherit("scripts/events/event", {
	m = {
		Cripple = null,
		Injured = null
	},
	function create()
	{
		this.m.ID = "event.cripple_vs_injury";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]La récente bataille a laissé %injured% avec une blessure horrible et permanente. Alors qu\'il est assis d\'un air sombre autour du feu de camp, %cripple% l\'infirme prend place à côté de lui.%SPEECH_ON%Alors tu es là, assis, déprimé par quelque chose qui n\'a pas d\'importance. Regarde-moi. Regarde-moi juste ! Regarde où je suis ! J\'ai perdu ce qui ne peut pas être rendu, mais est-ce que je m\'y suis attardé ? Non. J\'ai continué. J\'ai rejoint %companyname%. Parce que ça, cette blessure juste là, c\'est du passé. Ça, là-haut...%SPEECH_OFF%L\'infirme se tape le côté de la tête.%SPEECH_ON%C\'est ici que tout peut être reconstruit. C\'est ici qu\'on peut se dire, oui, c\'est arrivé, mais je suis toujours un homme et je suis toujours dans le coup. Si le monde veut ma mort, il devra prendre tous les morceaux que j\'ai à donner parce que je n\'abandonnerai pas jusqu\'à ce qu\'il ne reste plus rien de moi !%SPEECH_OFF%%injured% acquiesce et son humeur semble déjà s\'être améliorée.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cet homme a un sacré esprit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cripple.getImagePath());
				this.Characters.push(_event.m.Injured.getImagePath());
				_event.m.Injured.improveMood(1.0, "Moral remonté par " + _event.m.Cripple.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Injured.getMoodState()],
					text = _event.m.Injured.getName() + this.Const.MoodStateEvent[_event.m.Injured.getMoodState()]
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

		local cripple_candidates = [];
		local injured_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cripple")
			{
				cripple_candidates.push(bro);
			}
			else if (bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury))
			{
				foreach( n in bro.getMoodChanges() )
				{
					if (n.Text == "Suffered a permanent injury")
					{
						injured_candidates.push(bro);
						break;
					}
				}
			}
		}

		if (cripple_candidates.len() == 0 || injured_candidates.len() == 0)
		{
			return;
		}

		this.m.Cripple = cripple_candidates[this.Math.rand(0, cripple_candidates.len() - 1)];
		this.m.Injured = injured_candidates[this.Math.rand(0, injured_candidates.len() - 1)];
		this.m.Score = (cripple_candidates.len() + injured_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cripple",
			this.m.Cripple.getNameOnly()
		]);
		_vars.push([
			"injured",
			this.m.Injured.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cripple = null;
		this.m.Injured = null;
	}

});

