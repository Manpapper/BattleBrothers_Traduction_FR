this.desert_feet_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.desert_feet";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Marcher à travers les dunes de sable pendant des jours a accumulé beaucoup de sable dans les bottes. Quelques-uns font une pause, vidant leurs chaussures, tandis que d\'autres révèlent que leurs pieds ont été broyés à vif. C\'est un paysage infernal, il semble, peu importe si c\'est le soleil au-dessus ou les sables en dessous, tout est là pour vous avoir.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce sont des vautours qui tournent au-dessus ?",
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
					if (bro.m.Ethnicity == 1)
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.75, "Avait ses pieds broyés par le sable du désert");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert || currentTile.HasRoad || this.World.Retinue.hasFollower("follower.scout"))
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart" || this.World.Assets.getOrigin().getID() == "scenario.manhunters")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local numNortherners = 0;

		foreach( bro in brothers )
		{
			if (bro.m.Ethnicity == 1)
			{
				continue;
			}

			numNortherners = ++numNortherners;
		}

		if (numNortherners < 3)
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

