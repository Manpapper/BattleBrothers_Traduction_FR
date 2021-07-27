this.mountain_running_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.mountain_running";
		this.m.Title = "In the mountains...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_42.png[/img]Climbing and barreling through the ups and downs of the mountain range has tested the men as well as any foe. While the company is a little worse for the wear, they have been made better by the rigors and trials of the harsh landscape - %dude% most of all.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s all worth it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bro = _event.m.Dude;
				this.Characters.push(bro.getImagePath());
				local stamina = this.Math.rand(1, 3);
				bro.getBaseProperties().Stamina += stamina;
				bro.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] Max Fatigue"
				});
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

		local brothers = this.World.getPlayerRoster().getAll();
		this.m.Dude = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

