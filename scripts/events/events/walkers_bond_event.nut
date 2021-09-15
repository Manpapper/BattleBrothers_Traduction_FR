this.walkers_bond_event <- this.inherit("scripts/events/event", {
	m = {
		Walker1 = null,
		Walker2 = null
	},
	function create()
	{
		this.m.ID = "event.walkers_bond";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_16.png[/img]{Sur la route, %walker1% et %walker2% se racontent des histoires de leurs voyages. Vous ne comprenez pas vraiment ce qu\'il y a de si riche dans le fait de se promener, mais les deux hommes se lient autour de leurs récits et cela vous suffit. | %walker1% et %walker2% ont vu beaucoup de choses dans le monde. Ils ont passé des années sur la route, et maintenant ils se racontent des histoires de ces années. Ils s\'apprécient mutuellement, et vous appréciez également de ne pas écouter des histoires de voyage ennuyeuses. | La plupart des hommes trouvent la tâche de se promener plutôt simple, mais les hommes qui ne font rien d\'autre que de se promener trouvent plus d\'intérêt aux raggots et autres histoires. Sans surprise, %walker1% et %walker2% ont fini par se lier d\'amitié avec leurs histoires de... promenade.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On continue.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Walker1.getImagePath());
				this.Characters.push(_event.m.Walker2.getImagePath());
				_event.m.Walker1.improveMood(1.0, "S\'est lié d\'amitié avec " + _event.m.Walker2.getName());
				_event.m.Walker2.improveMood(1.0, "S\'est lié d\'amitié avec " + _event.m.Walker1.getName());

				if (_event.m.Walker1.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Walker1.getMoodState()],
						text = _event.m.Walker1.getName() + this.Const.MoodStateEvent[_event.m.Walker1.getMoodState()]
					});
				}

				if (_event.m.Walker2.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Walker2.getMoodState()],
						text = _event.m.Walker2.getName() + this.Const.MoodStateEvent[_event.m.Walker2.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
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
			if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.messenger" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.nomad")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Walker1 = candidates[this.Math.rand(0, candidates.len() - 1)];

		do
		{
			this.m.Walker2 = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		while (this.m.Walker2 == this.m.Walker1);

		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"walker1",
			this.m.Walker1.getName()
		]);
		_vars.push([
			"walker2",
			this.m.Walker2.getName()
		]);
	}

	function onClear()
	{
		this.m.Walker1 = null;
		this.m.Walker2 = null;
	}

});

