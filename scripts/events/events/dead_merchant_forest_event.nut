this.dead_merchant_forest_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.dead_merchant_forest";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Alors que vous marchez dans la forêt, vous tombez sur un corps qui se balance sur une branche. Il semble qu\'il soit là depuis assez longtemps pour que même les mouches aient eu leur compte. %randombrother% remarque des chaussures en daim pointues sur les pieds du cadavre.%SPEECH_ON%Ça m\'a l\'air d\'être un marchand, monsieur.%SPEECH_OFF%Vous acquiescez et le faites descendre. En regardant de plus près, vous constatez que les yeux ont été creusés et que des tatouages ont été dessinés sur sa poitrine. Étant donné que vous trouvez encore des couronnes sur le corps, il s\'agit probablement de l\'œuvre de sauvages non civilisés effrayés par un étranger.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reposez en paix.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(30, 150);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d < 10)
			{
				nearTown = true;
				break;
			}
		}

		if (nearTown)
		{
			return;
		}

		this.m.Score = 5;
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

