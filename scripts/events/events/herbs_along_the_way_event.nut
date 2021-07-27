this.herbs_along_the_way_event <- this.inherit("scripts/events/event", {
	m = {
		Volunteer = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.herbs_along_the_way";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%While heading toward your destination, %volunteer% runs up to you with a bundle of herbs in hand. Now you know this fool knows nothing about plants or wildlife, but he seems rather persistent in wanting to try them out. Something about \'hearing\' of magical powers to be found in the essence of herbs. This talk gets the attention of a few others in the company. Soon, a number of them are asking to try out the \'medicine\' for the good of their brothers.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "They look good, any volunteer to try them?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "C" : "B";
					}

				},
				{
					Text = "{Better not try our luck. | You fools will only poison yourselves.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%It appears that the herbs are not just harmless, but rather even proactive in taking care of some nagging issues with the men. %volunteer%\'s cold seems to have lifted, and the stomach pains of %otherguy% have abated. After trying some yourself, you see a splinter wiggle its way out of your thumb. Amazing!",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Amazing!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 12);
				this.World.Assets.addMedicine(amount);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_medicine.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Medical Supplies"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_18.png[/img]From one end comes vomit and from the other shite. It appears the herbs were not worth a try after all. %volunteer% bravely elected himself ready to chow down on the mystery plants and, suffice it to say, the proportions which you are seeing come out of him are definitely mystical in that strange, \'can the body really hold that much?\', sort of way.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ewww.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Volunteer.getSkills().add(effect);
				this.List = [
					{
						id = 10,
						icon = effect.getIcon(),
						text = _event.m.Volunteer.getName() + " is sick"
					}
				];
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

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.Swamp)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getHitpoints() > 20 && !bro.getSkills().hasSkill("injury.sickness") && !bro.getSkills().hasSkill("trait.bright") && !bro.getSkills().hasSkill("trait.hesitant"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Volunteer = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = 10;

			do
			{
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];

				if (bro.getID() != this.m.Volunteer.getID())
				{
					this.m.OtherGuy = bro;
				}
			}
			while (this.m.OtherGuy == null);
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		local currentTile = this.World.State.getPlayer().getTile();
		local image;

		if (currentTile.Type == this.Const.World.TerrainType.Swamp)
		{
			image = "[img]gfx/ui/events/event_09.png[/img]";
		}
		else
		{
			image = "[img]gfx/ui/events/event_25.png[/img]";
		}

		_vars.push([
			"volunteer",
			this.m.Volunteer.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
		_vars.push([
			"image",
			image
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Volunteer = null;
		this.m.OtherGuy = null;
	}

});

