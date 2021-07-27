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
			Text = "[img]gfx/ui/events/event_16.png[/img]{Men of the road, %walker1% and %walker2% share stories of their travels with one another. You don\'t really understand what\'s so rich about walking about, but the two men do bond over their tales and that\'s good enough for you. | %walker1% and %walker2% have seen much of the world. They\'ve spent years on the road, and now they\'re telling tales of those years to one another.\n\nTheir appreciation for each other rises, and your appreciation for not listening to boring travel stories also increases. | Most men find the task of walking about to be pretty simple, but men who do little else but walk about find more interest in the affair. Unsurprisingly, %walker1% and %walker2% have come to bond of their tales of... walking around.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We march on.",
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
				_event.m.Walker1.improveMood(1.0, "Bonded with " + _event.m.Walker2.getName());
				_event.m.Walker2.improveMood(1.0, "Bonded with " + _event.m.Walker1.getName());

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

