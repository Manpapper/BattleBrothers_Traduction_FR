this.dead_lumberjack_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.dead_lumberjack";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]La forêt abrite de nombreuses curiosités et des cadavres,  mais ce n\'est pas les choses les plus curieuses. Aussi, lorsque vous tombez sur une bande de bûcherons morts, la seule chose qui pique votre intérêt est la masse d\'un loup-garou tué à côté d\'eux. %randombrother% regarde les traces qui vont et viennent à travers un champ de coupe si brusquement interrompu que certaines haches sont restées taillées dans des troncs d\'arbres. Il crache et hoche la tête.%SPEECH_ON%Pauvres gars. On dirait que des loups-garous les ont violemment attaqués par surprise.%SPEECH_OFF%Demandez aux hommes de récupérer ce qui reste à récupérer et partez.",
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
				local item;

				if (this.Math.rand(1, 100) <= 50)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}
				else
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/werewolf_pelt_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
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

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 7)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
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

