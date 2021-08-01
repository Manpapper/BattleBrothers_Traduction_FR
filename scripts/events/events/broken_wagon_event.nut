this.broken_wagon_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.broken_wagon";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%Vous trouvez un chariot abandonné parmi de grands roseaux. %randombrother% l\'examine et hurle en réponse.%SPEECH_ON%Le chariot est explosé mais je pense qu\'on peut en sauver des parties.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Pas mal.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] d\'Outils et de Provisions."
				});
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

		this.m.Score = 9;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

