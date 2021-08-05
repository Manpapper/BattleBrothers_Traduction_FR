this.giant_tree_in_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.giant_tree_in_forest";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous passez à travers un mur d\'arbustes et vous vous retrouvez arrêté par un sacré spectacle. L\'appeler un arbre serait insultant. Les arbres qui l\'entourent sont si bas sous leur voisin qu\'ils semblent plier à mi-tronc, jurant fidélité à ce qui est arboricolement suzerain, un domaine ondulé de racines aussi épaisses que n\'importe quel homme, et suffisamment d\'ombre au-dessus pour perdre la notion du temps entre les jours et la nuit.\n\n Vous marchez jusqu\'à la base de l\'énormité et passez une main le long de son écorce, mais vous vous arrêtez, craignant que votre chair ne vienne empiéter sur cette terre sainte, comme un enfant qui tombe en jouant dans l\'église d\'une foule totalement silencieuse. %monk% s\'approche de vous en hochant la tête et en plaçant ses mains derrière son dos.%SPEECH_ON%C\'est un arbre divin. Ses racines traversent la terre et pénètrent dans le royaume des dieux. On dit qu\'ils écoutaient autrefois, mais maintenant... on n\'en est plus si sûrs.%SPEECH_OFF%Vous fixez l\'homme, et sa posture particulièrement détendue, et lui demandez s\'il a peur de l\'arbre. Il vous sourit et secoue la tête.%SPEECH_ON%Je le respecte comme un homme respecte la mer, car les eaux des océans recèlent bien des choses à craindre et pourtant, le marin navigue quand même. Si l\'océan était une bête docile, l\'homme le traiterait-il avec autant d\'amour ?%SPEECH_OFF%",
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
				_event.m.Monk.improveMood(2.0, "A vu un arbre-dieu de ses propres yeux.");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
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

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 6)
			{
				return false;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local monk_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				monk_candidates.push(bro);
			}
		}

		if (monk_candidates.len() == 0)
		{
			return;
		}

		this.m.Monk = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
	}

});

