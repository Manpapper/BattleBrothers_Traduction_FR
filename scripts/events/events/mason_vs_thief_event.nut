this.mason_vs_thief_event <- this.inherit("scripts/events/event", {
	m = {
		Mason = null,
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.mason_vs_thief";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%mason% le maçon attise le feu de camp avec %thief% qui se tient à proximité. Le voleur réfléchit à une question. %SPEECH_ON%Hmm, qu\'est-ce qui a été le plus difficile à forcer ? Eh bien, les coffres-forts étaient les plus faciles, précisons-le. Une fois, j\'ai tellement volé dans une chambre forte qu\'ils ont voulu pendre le serrurier pour avoir été si facilement battu par un simple voleur. Ils n\'ont pas trouvé le serrurier, car, voyez-vous, je ne suis pas un voleur ordinaire, car le serrurier, c\'était moi. Ha-ha ! Pour répondre à votre question, une tour est la plus difficile à forcer, surtout une tour isolée..%SPEECH_OFF% Assis sur ses lauriers, le maçon acquiesce.%SPEECH_ON%Oui, c\'est ce que je pensais que vous diriez. Les tours sont construites pour les prisonniers ou des articles de fantaisie particulière. Un peu plus que des cages dans le ciel pour des créatures sans ailes. Mais une fois, un prisonnier, un voleur de poisson notoire, a réussi à s\'échapper. Il a passé des années à arracher des mèches de ses propres cheveux et à les attacher ensemble jusqu\'à ce que la \"corde\" soit assez longue pour qu\'il puisse la jeter et descendre. Ils l\'ont attrapé un jour plus tard, malheureusement. Il a refait le même tour quelques années plus tard, mais cette fois-ci, il a attaché la corde à moitié plus moins longue et s\'est simplement pendu à la place.%SPEECH_OFF%%thief% rit.%SPEECH_ON%C\'est intéressant et tout, mais je suis un vrai voleur, maçon, pas un simple voleur de poissons Ma question est de savoir comment entrer dans une tour. Le maçon hoche la tête. Commettez un... vol de poisson. %SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est ballot.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Mason.getImagePath());
				this.Characters.push(_event.m.Thief.getImagePath());
				_event.m.Mason.improveMood(1.0, "S\'est lié à " + _event.m.Thief.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Mason.getMoodState()],
					text = _event.m.Mason.getName() + this.Const.MoodStateEvent[_event.m.Mason.getMoodState()]
				});
				_event.m.Thief.improveMood(1.0, "S\'est lié à " + _event.m.Mason.getName());
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

		local mason_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.mason")
			{
				mason_candidates.push(bro);
				break;
			}
		}

		if (mason_candidates.len() == 0)
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

		this.m.Mason = mason_candidates[this.Math.rand(0, mason_candidates.len() - 1)];
		this.m.Thief = thief_candidates[this.Math.rand(0, thief_candidates.len() - 1)];
		this.m.Score = (mason_candidates.len() + thief_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"mason",
			this.m.Mason.getNameOnly()
		]);
		_vars.push([
			"thief",
			this.m.Thief.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Mason = null;
		this.m.Thief = null;
	}

});

