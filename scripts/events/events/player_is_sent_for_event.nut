this.player_is_sent_for_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.player_is_sent_for";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]{Votre compagnie semble avoir attiré l\'attention d\'un messager sur la route. %SPEECH_ON%{Messieurs, %settlement% %direction% a un besoin urgent d\'aide et a demandé à tous les hommes capables, particulièrement ceux qui vendent des épées, de venir l\'aider. | Ah, %companyname%, exactement le genre que je cherchais. %settlement% %direction% demande de l\'aide pour un problème. Si vous cherchez du travail, je parie que vous allez dans cette direction. Et n\'oubliez pas de dire que c\'est moi qui vous envoie, ça me rapporte deux couronnes de plus. | Hé, messieurs les mercenaries, %settlement% %direction% a besoin de vos services. Je vous suggère d\'aller dans cette direction si vous cherchez du travail. | Vous cherchez du travail ? Vous n\'avez pas l\'air d\'avoir de but, alors laissez-moi vous dire que %settlement% %direction% a du travail pour vous. | Ah, un mercenaire sans rôle dans ce monde ? Malheur à vous. Eh bien, %settlement% non loin d\'ici a quelque chose pour vous. Je vous suggère de vous y rendre. | Je suis ici pour vous dire que %settlement% cherche des travailleurs. Pas des ouvriers, attention. Je m\'adresse à vous pour une raison. Emmenez vos épées et vos tueurs là-bas si vous voulez de la bonne monnaie. | Hé, vous devriez savoir que %settlement% recherche des hommes de votre genre. Trouvez votre chemin et vous aurez peut-être un nouveau travail. | Vous cherchez du travail ? Alors allez à %settlement% %direction%, ce n\'est un mystère pour personne qu\'ils recherchent des hommes comme vous.}%SPEECH_OFF%En remerciant le coursier, vous vérifiez vos cartes pour voir si ça vaut le coup de faire le voyage.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un travail rémunéré, vous dites ?",
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (this.World.Contracts.getActiveContract() != null)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearestTown;
		local nearestDist = 9000;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = t.getTile().getDistanceTo(currentTile) + this.Math.rand(0, 10);

			if (d < nearestDist && t.isAlliedWithPlayer() && this.World.FactionManager.getFaction(t.getFaction()).getContracts().len() != 0)
			{
				nearestTown = t;
				nearestDist = d;
			}
		}

		if (nearestTown == null)
		{
			return;
		}

		this.m.Town = nearestTown;

		if (this.World.getTime().Days <= 10)
		{
			this.m.Score = 30;
		}
		else
		{
			this.m.Score = 10;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"settlement",
			this.m.Town.getName()
		]);
		_vars.push([
			"direction",
			this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Town.getTile())]
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

