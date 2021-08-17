this.miner_atop_world_event <- this.inherit("scripts/events/event", {
	m = {
		Miner = null
	},
	function create()
	{
		this.m.ID = "event.miner_atop_world";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_42.png[/img]La compagnie marche vers les montagnes, que %randombrother% appelle poétiquement les \"seins du royaume\". Les nuages commencent à passer à hauteur des yeux et l\'air devient si fin qu\'on a l\'impression de respirer à travers une paille. La neige crisse sous les pieds et les vents violents menacent de transformer vos yeux en glaçons. Malgré les escarpements et les crevasses dangereuses à traverser, %miner% le mineur semble plutôt heureux d\'être aussi haut.%SPEECH_ON%C\'est comme si nous étions au sommet du monde ! N\'est-ce pas merveilleux ? %SPEECH_OFF%Il a du mal à respirer, mais le mineur est trop heureux pour s\'en soucier. Des années à creuser profondément dans la terre ont rendu ce renversement de perspective d\'autant plus merveilleux.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au moins, quelqu\'un s\'amuse.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Miner.getImagePath());
				_event.m.Miner.improveMood(2.0, "A apprécié la vue du haut d\'une montagne");

				if (_event.m.Miner.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Miner.getMoodState()],
						text = _event.m.Miner.getName() + this.Const.MoodStateEvent[_event.m.Miner.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
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
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.miner")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Miner = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"miner",
			this.m.Miner.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Miner = null;
	}

});

