this.desert_sand_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.desert_sand";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Un désert est une terre hostile aux intrus. Même si votre équipement supporte le poids de cette hostilité naturelle : une partie du matériel a été usée par les sables eux-mêmes. Un nettoyage et un affûtage seront nécessaires pour maintenir la qualité de l\'équipement du %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cet endroit déteste vraiment tout.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

					if (item != null && item.getCondition() > 1 && this.Math.rand(1, 100) <= 15)
					{
						item.setCondition(this.Math.max(1, item.getCondition() - item.getConditionMax() * this.Math.rand(10, 25) * 0.01));
					}

					item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

					if (item != null && item.getCondition() > 1 && this.Math.rand(1, 100) <= 15)
					{
						item.setCondition(this.Math.max(1, item.getCondition() - item.getConditionMax() * this.Math.rand(10, 25) * 0.01));
					}

					item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

					if (item != null && item.getCondition() > 1 && this.Math.rand(1, 100) <= 15)
					{
						item.setCondition(this.Math.max(1, item.getCondition() - item.getConditionMax() * this.Math.rand(10, 25) * 0.01));
					}

					item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

					if (item != null && item.getCondition() > 1 && this.Math.rand(1, 100) <= 15)
					{
						item.setCondition(this.Math.max(1, item.getCondition() - item.getConditionMax() * this.Math.rand(10, 25) * 0.01));
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert || this.World.Retinue.hasFollower("follower.scout"))
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
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

