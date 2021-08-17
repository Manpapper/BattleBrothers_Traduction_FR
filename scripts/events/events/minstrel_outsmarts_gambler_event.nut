this.minstrel_outsmarts_gambler_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Gambler = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_outsmarts_gambler";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img] %gambler%, l\'homme qui a un problème de jeu, a apparemment fait le tour du camp pour demander aux hommes de jouer au fer à cheval - avec quelques couronnes en jeu, bien sûr. Il semble que %minstrel%, le ménestrel rusé, l\'ait obligé et ait accepté le pari. Il dit qu\'il est plutôt bon au jeu, ce à quoi le joueur répond qu\'il est le meilleur. \n\nLes deux hommes lancent des fers à cheval jusqu\'à ce que leurs bras se fatiguent et que le soleil décline. Personne ne gagne car le jeu ne peut pas finir sur une égalité. Après un autre tour indécis, %minstrel% dit qu\'il va faire un quitte ou doubleen utilisant leur main gauche. %gambler% accepte. Il commence en lançant trois fers à cheval. Les deux premiers se détraquent, mais le troisième parvient à tourner autour de l\'anneau. Il sourit en souhaitant bonne chance au ménestrel. %minstrel% acquiesce et retrousse ses manches. Il tire la langue et ferme les yeux, pour aligner le tir. Ses pieds font des claquettes et juste avant de lancer, il se retourne et dit : %SPEECH_ON% Je devrais probablement vous dire que je suis gaucher.%SPEECH_OFF% Sans même regarder devant lui, le ménestrel lâche son fer à cheval. Le lancer est parfait, atterrissant en plein centre de la mise, et les deux suivants sont lancés si rapidement et si facilement que tous les spectateurs éclatent de rire. Le joueur, lui, ne peut que rester bouche bée, incrédule.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Petit con effronté.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Gambler.getImagePath());
				_event.m.Minstrel.improveMood(1.0, "A été plus malin que " + _event.m.Gambler.getName());

				if (_event.m.Minstrel.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Minstrel.getMoodState()],
						text = _event.m.Minstrel.getName() + this.Const.MoodStateEvent[_event.m.Minstrel.getMoodState()]
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

		local candidates_minstrel = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(bro);
			}
		}

		if (candidates_minstrel.len() == 0)
		{
			return;
		}

		local candidates_gambler = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gambler")
			{
				candidates_gambler.push(bro);
			}
		}

		if (candidates_gambler.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.Gambler = candidates_gambler[this.Math.rand(0, candidates_gambler.len() - 1)];
		this.m.Score = (candidates_minstrel.len() + candidates_gambler.len()) * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel.getNameOnly()
		]);
		_vars.push([
			"gambler",
			this.m.Gambler.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.Gambler = null;
	}

});

