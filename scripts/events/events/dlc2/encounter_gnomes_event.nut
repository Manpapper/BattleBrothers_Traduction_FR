this.encounter_gnomes_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.encounter_gnomes";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous donnez une pause aux hommes et décidez de partir vous-même en reconnaissance dans la forêt. À moins de cinq minutes, vous entendez le murmure régulier de chants. Dégainant votre épée, vous grimpez sur un d\'arbre tombé et regardez par-dessus. Vous y voyez une douzaine de ce qui ressemble à des hommes miniatures dansant en cercle. La moitié d\'entre eux sifflent à voix basse tandis que les autres répètent sans cesse un mot que vous n\'avez jamais entendu auparavant. Au centre de l\'absurdité se trouve un champignon et un crapaud à l\'air très ennuyé que, de temps en temps, un homme miniature se précipite et le touche avant de revenir en courant vers le cercle en souriant comme s\'il s\'était échappé d\'un crime coquin.\n\n C\'est trop. Vous avancez en rampant pour mieux voir, mais une branche se casse sous votre poids. Les petits hommes s\'arrêtent instantanément et regardent vers vous comme un troupeau de proies. L\'un d\'eux hurle un charabia et tous s\'éloignent en sautillant, plongeant dans des trous d\'arbres ou dans des buissons. Quand vous rapprochez pour les voir, vous ne trouvez rien. Ils ont complètement disparu. Vous vous rendez à la souche et trouvez le crapaud empalé par une dague et le champignon disparu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Etrange.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 25)
			{
				return false;
			}
		}

		this.m.Score = 10;
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

