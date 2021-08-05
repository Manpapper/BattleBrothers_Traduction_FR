this.fisherman_vs_farmer_event <- this.inherit("scripts/events/event", {
	m = {
		Fisherman = null,
		Farmer = null
	},
	function create()
	{
		this.m.ID = "event.fisherman_vs_farmer";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%farmhand% et %fisherman% se livrent à un petit bras de fer. Apparemment cela fait suite à une dispute où la question était de savoir lesquels sont les plus importants les pêcheurs ou les agriculteurs ou quelle est la meilleure nourriture, celle qui marche sur la terre ou celle qui nage dans les océans. Après avoir émis une longue tirade et chanté les louanges d\'une baleine disparue depuis longtemps, le pêcheur met toutes ses forces dans le combat et bats le bras de %farmhand%. Les deux hommes se relèvent et se tapent sur les épaules.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aucun d\'entre nous n\'est né mercenaire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fisherman.getImagePath());
				this.Characters.push(_event.m.Farmer.getImagePath());
				_event.m.Fisherman.getFlags().increment("ParticipatedInStrengthContests", 1);
				_event.m.Farmer.getFlags().increment("ParticipatedInStrengthContests", 1);
				_event.m.Fisherman.improveMood(1.0, "A noué un lien avec " + _event.m.Farmer.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Fisherman.getMoodState()],
					text = _event.m.Fisherman.getName() + this.Const.MoodStateEvent[_event.m.Fisherman.getMoodState()]
				});
				_event.m.Farmer.improveMood(1.0, "A noué un lien avec " + _event.m.Fisherman.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Farmer.getMoodState()],
					text = _event.m.Farmer.getName() + this.Const.MoodStateEvent[_event.m.Farmer.getMoodState()]
				});

				if (_event.m.Fisherman.getTitle() == "")
				{
					local titles = [
						"le Fort",
						"l\'Homme Fier",
						"le Pêcheur",
						"le Bras de fer"
					];
					_event.m.Fisherman.setTitle(titles[this.Math.rand(0, titles.len() - 1)]);
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = _event.m.Fisherman.getNameOnly() + " est maintenant connu en tant que " + _event.m.Fisherman.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]%farmhand% et %fisherman% se livrent à un petit bras de fer. Apparemment cela fait suite à une dispute où la question était de savoir lesquels sont les plus importants les pêcheurs ou les agriculteurs ou quelle est la meilleure nourriture, celle qui marche sur la terre ou celle qui nage dans les océans. Après avoir longuement raconté l\'histoire de ses ancêtres qui travaillaient la terre, %farmhand% met le dernier de ses forces pour battre le bras de %fisherman%. Les deux hommes se relèvent et se tapent sur les épaules.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aucun d\'entre nous n\'est né mercenaire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Farmer.getImagePath());
				this.Characters.push(_event.m.Fisherman.getImagePath());
				_event.m.Fisherman.getFlags().increment("ParticipatedInStrengthContests", 1);
				_event.m.Farmer.getFlags().increment("ParticipatedInStrengthContests", 1);
				_event.m.Fisherman.improveMood(1.0, "A noué un lien avec " + _event.m.Farmer.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Fisherman.getMoodState()],
					text = _event.m.Fisherman.getName() + this.Const.MoodStateEvent[_event.m.Fisherman.getMoodState()]
				});
				_event.m.Farmer.improveMood(1.0, "A noué un lien avec " + _event.m.Fisherman.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Farmer.getMoodState()],
					text = _event.m.Farmer.getName() + this.Const.MoodStateEvent[_event.m.Farmer.getMoodState()]
				});

				if (_event.m.Farmer.getTitle() == "")
				{
					local titles = [
						"le Fort",
						"l\'Homme Fier",
						"le Fermier",
						"le Bras de fer"
					];
					_event.m.Farmer.setTitle(titles[this.Math.rand(0, titles.len() - 1)]);
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = _event.m.Farmer.getNameOnly() + " est maintenant connu en tant que " + _event.m.Farmer.getName()
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local fisherman_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 4 && bro.getBackground().getID() == "background.fisherman")
			{
				fisherman_candidates.push(bro);
			}
		}

		if (fisherman_candidates.len() == 0)
		{
			return;
		}

		local farmer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 4 && bro.getBackground().getID() == "background.farmhand")
			{
				farmer_candidates.push(bro);
			}
		}

		if (farmer_candidates.len() == 0)
		{
			return;
		}

		this.m.Fisherman = fisherman_candidates[this.Math.rand(0, fisherman_candidates.len() - 1)];
		this.m.Farmer = farmer_candidates[this.Math.rand(0, farmer_candidates.len() - 1)];
		this.m.Score = (fisherman_candidates.len() + farmer_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"farmhand",
			this.m.Farmer.getNameOnly()
		]);
		_vars.push([
			"fisherman",
			this.m.Fisherman.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.Math.rand(0, 1) == 0)
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onClear()
	{
		this.m.Farmer = null;
		this.m.Fisherman = null;
	}

});

