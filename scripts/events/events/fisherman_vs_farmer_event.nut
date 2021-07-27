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
			Text = "[img]gfx/ui/events/event_26.png[/img]%farmhand% and %fisherman% are having a bit of an arm-wrestling contest. It\'s all in good fun, having apparently been borne out of an argument on whether fishermen or farmers are more important or whose food is best, that which walks the land or that which swims the oceans. With a long, salty belch, and singing with praise for some long-lost whale, the fisherman puts the last of his strength into the bout and pins %farmhand%\'s arm. Both men get up and clap one another on the shoulders.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "None of us are born a mercenary.",
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
				_event.m.Fisherman.improveMood(1.0, "Bonded with " + _event.m.Farmer.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Fisherman.getMoodState()],
					text = _event.m.Fisherman.getName() + this.Const.MoodStateEvent[_event.m.Fisherman.getMoodState()]
				});
				_event.m.Farmer.improveMood(1.0, "Bonded with " + _event.m.Fisherman.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Farmer.getMoodState()],
					text = _event.m.Farmer.getName() + this.Const.MoodStateEvent[_event.m.Farmer.getMoodState()]
				});

				if (_event.m.Fisherman.getTitle() == "")
				{
					local titles = [
						"the Strong",
						"the Proud",
						"the Fisherman",
						"the Armwrestler",
						"Fishes"
					];
					_event.m.Fisherman.setTitle(titles[this.Math.rand(0, titles.len() - 1)]);
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = _event.m.Fisherman.getNameOnly() + " is now known as " + _event.m.Fisherman.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]%farmhand% and %fisherman% are having a bit of an arm-wrestling contest. It\'s all in good fun, having apparently been borne out of an argument on whether fishermen or farmers are more important or whose food is best or some such thing. With a long retelling of the history of his fathers tilling the soils of the land, %farmhand% puts the last of his strength into pinning %fisherman%\'s arm. Both men get up and clap one another on the shoulders.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "None of us are born a mercenary.",
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
				_event.m.Fisherman.improveMood(1.0, "Bonded with " + _event.m.Farmer.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Fisherman.getMoodState()],
					text = _event.m.Fisherman.getName() + this.Const.MoodStateEvent[_event.m.Fisherman.getMoodState()]
				});
				_event.m.Farmer.improveMood(1.0, "Bonded with " + _event.m.Fisherman.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Farmer.getMoodState()],
					text = _event.m.Farmer.getName() + this.Const.MoodStateEvent[_event.m.Farmer.getMoodState()]
				});

				if (_event.m.Farmer.getTitle() == "")
				{
					local titles = [
						"the Strong",
						"the Proud",
						"the Farmhand",
						"the Armwrestler",
						"Weeds"
					];
					_event.m.Farmer.setTitle(titles[this.Math.rand(0, titles.len() - 1)]);
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = _event.m.Farmer.getNameOnly() + " is now known as " + _event.m.Farmer.getName()
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

