this.anatomist_demonology_book_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_demonology_book";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Vous trouvez %anatomist% en train de parcourir un livre de couleur rouge. Il ferme le livre et soupire.%SPEECH_ON%En tant qu\'anatomiste, je suis obligé de penser que les monstres, comme vous, les profanes, les appelleriez, n\'apparaissent pas simplement pour le plaisir de se montrer. Au contraire, tout a un but. En un sens, et grâce aux anciens dieux, nous pouvons croire que ces éléments ont en réalité un but divin. Pourtant, certains de mes pairs ont trouvé des ossements de créatures qui n\'ont jamais été vues en chair et en os. Il semble que ces entités aient entièrement disparu. Une question s\'impose : ces preuves impliquent-elles que nous-mêmes disparaîtrons un jour? Une réponse affirmative à cette question suggère donc que les divinités ci-dessus n\'ont pas une très grande influence sur nous. Nous évoluons sous le regard de simples coïncidences. Une idée terrible, en effet.%SPEECH_OFF%Curieux, vous demandez à quoi ressemblaient ces mystérieux monstres. L\'anatomiste ouvre le livre rouge et vous montre un dessin.%SPEECH_ON%Ils ressemblent beaucoup aux humains, mais sont plus grands, avec une corpulence certaine au niveau du cou et des épaules. Les crânes portent ces encoches, semblables à celles des cornes, et les colonnes vertébrales ont des vertèbres supplémentaires, dont trois près du sommet s\'élargissent, comme si elles s\'accrochaient à quelque chose, quelque chose qui s\'étendrait loin du corps. Vous voyez? Ici? Le dos est presque comme un manteau osseux.%SPEECH_OFF%Intéressant. Vous demandez à l\'anatomiste s\'il a déjà vu un de ces squelettes, il répond par la négative. Il dit qu\'il ne l\'a vu que dans le texte. Vous lui demandez s\'il a payé pour ce texte et il vous répond que oui. Vous lui demandez si la notion de vieux monstres bizarres n\'était pas un simple argument de vente pour qu\'il achète un livre rempli de conneries. L\'anatomiste réfléchit un moment. Il hoche la tête et convient qu\'il est probable qu\'il a acheté un faux. Sa colère augmente de seconde en seconde et il jette soudainement le tome dans le feu de camp, s\'engageant à poursuivre des études plus concrètes à l\'avenir. Il vous remercie de lui avoir ouvert les yeux sur ces sottises.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne croyez pas tout ce que vous lisez.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.worsenMood(0.5, "Wasted time reading a sham demonology book");
				_event.m.Anatomist.improveMood(1.0, "You helped him realize his demonology book was a farce");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

