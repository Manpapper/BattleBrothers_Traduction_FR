this.treant_vs_giants_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.treant_vs_giants";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_107.png[/img]{%randombrother% se froisse le mollet à cause d\'un trou dans le sol et jure de frustration.%SPEECH_ON%Pour l\'amour de Dieu, comme si mes chiens n\'aboyaient pas assez!%SPEECH_OFF%Vous vous retournez pour lui dire de se taire quand, soudain, vous apercevez un géant en train de grimper le long de la colline boisée que la compagnie vient de gravir. Alors que vous avez tous lutté pour monter, le géant se précipite vers le haut et brouille la piste, laissant de petits glissements de terrain dans son sillage. Avant que vous ne puissiez l\'appeler, un énorme arbre s\'écarte d\'une foule de ses congénères immobiles et met le géant à genoux. Une boule de salive traverse la forêt en brisant les branches et les broussailles, le géant plaque son dos contre le sol de la forêt et même à cette distance, le sol gronde sous vos pieds. Vous voyez arriver d\'autres géants et de nombreux schrats enlèvent leur camouflage pour leur livrer bataille. C\'est une bagarre sans merci entre schrat et géants.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Préparez-vous à attaquer.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Partons d\'ici.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_107.png[/img]{Vous vous accroupissez et ordonnez aux hommes de faire de même. Ils défilent comme des fourmis, tandis que des feuilles et des nattes de cheveux tombent d\'en haut. La violence des géants frappe vos oreilles comme un éclair. Mais vous parvenez à sortir de là et les laisser à leur sort.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est pas passé loin.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_107.png[/img]{Vous tirez votre épée, mais %randombrother% pose sa main sur votre épaule.%SPEECH_ON%Vraiment, capitaine?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oui, vraiment.",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.UnholdBog, 100, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Schrats, 100, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				},
				{
					Text = "A la réflexion, non.",
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

		if (this.World.getTime().Days < 20)
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

