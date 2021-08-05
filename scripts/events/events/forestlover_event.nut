this.forestlover_event <- this.inherit("scripts/events/event", {
	m = {
		Forestlover = null
	},
	function create()
	{
		this.m.ID = "event.forestlover";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img] {%forestlover% lève les yeux vers la canopée de la forêt, sa main s\'amusant à jouer avec les chutes de lumière. Il vous regarde.%SPEECH_ON%J\'avais l\'habitude de jouer dans ces forêts quand j\'étais enfant.%SPEECH_OFF%Vous acquiescez, puis vous vous demandez à haute voix.%SPEECH_ON%Je croyais que tu étais né en dehors de %randomtown% ?%SPEECH_OFF%La main de %forestlover% tombe et il fixe le sol.%SPEECH_ON%Oh oui, c\'est vrai. Bon, on devrait se bouger alors, non ?%SPEECH_OFF%Avant que vous ne puissiez en dire plus, l\'homme au visage rouge continue son chemin. | Vous trouvez que %forestlover% semble être de meilleure humeur ces derniers temps. Il s\'avère que ces forêts lui sont familières et un retour à leur verdure fait rayonner l\'homme d\'une chaleureuse nostalgie. | Bien que vous ayez traversé de nombreuses forêts, le paysage sauvage de celle-ci vous a impressionné. Nul doute que le %forestlover% aime ce retour au domaine épais des arbres. | Des arbres, aux troncs gras et aux membres robustes, s\'élèvent au-dessus de vous. %forestlover% semble être hypnotisé par leur hauteur. Vous trouvez que l\'homme sourit tout le temps ces derniers temps, comme si un retour à la forêt était un retour à des temps meilleurs.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est bien pour lui..",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Forestlover.getImagePath());
				_event.m.Forestlover.improveMood(1.0, "A aimé être dans une forêt");

				if (_event.m.Forestlover.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Forestlover.getMoodState()],
						text = _event.m.Forestlover.getName() + this.Const.MoodStateEvent[_event.m.Forestlover.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.lumberjack")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Forestlover = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = candidates.len() * 10;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"forestlover",
			this.m.Forestlover.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Forestlover = null;
	}

});

