this.arena_tournament_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.arena_tournament";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_97.png[/img]Deux enfants se précipitent sur votre chemin, l\'un brandissant un bouclier en jouet, l\'autre le plantant avec une vraie fourche. Vous saisissez l\'équipement agricole et l\'éloignez d\'un coup sec, ce à quoi l\'enfant s\'écrie qu\'ils ne font que s\'amuser. Le plus âgé des deux explique qu\'ils sont simplement excités par le prochain tournoi de gladiateurs. Ils disent que %town% organise une série de matchs en arène et que la récompense est importante. Très intéressant. À l\'aide de la fourche, tu fais sortir les enfants de la route et tu lances l\'outil de l\'autre côté. | [img]gfx/ui/events/event_97.png[/img]Vous trouvez deux garçons qui essaient d\'attraper un chien dans un filet. Le chien s\'amuse à bouger de gauche à droite, mais ils finissent par le prendre au piège. Le cabot, presque immédiatement résigné à son sort, se couche. Vous pensez qu\'ils vont dépecer et manger l\'animal, mais les garçons le laissent simplement partir pour recommencer le jeu. Lorsqu\'on leur demande, ils expliquent que certains gladiateurs de %town% utilisent des filets pour combattre. Mais ce qui est plus intéressant, c\'est qu\'ils déclarent également qu\'une grande série de jeux de gladiateurs est en cours et qu\'apparemment, il y a un gros prix pour le vainqueur. | [img]gfx/ui/events/event_92.png[/img]Un messager portant des spartiate arrive sur la route, vous jette un parchemin et sprint à toute vitesse en l\'espace de quelques secondes. Vous dépliez le papier pour trouver une annonce : %town% accueille un tournoi de jeux de gladiateurs. Le vainqueur d\'une série de combats gagnera un prix, ainsi que l\'adoration et la célébrité, bien sûr. | [img]gfx/ui/events/event_34.png[/img]Vous trouvez un homme accroupi au bord de la route. Il est à moitié nu et, à en juger par l\'état de ses vêtements ici et là, il ne s\'est pas déshabillé lui-même. Il explique qu\'il se rendait à %town% pour participer aux jeux de gladiateurs, mais qu\'un groupe de voyous l\'a volé. Peu intéressé par ses malheurs, vous vous renseignez sur ces jeux. Il explique qu\'il s\'agit d\'une série de combats, comme un tournoi, et que le gagnant remporte un gros prix. L\'homme secoue la tête.%SPEECH_ON%Suppose que le seul prix que j\'ai obtenu est de me faire botter le cul. Hey, tu as l\'air d\'avoir besoin d\'aide, que dirais-tu de...%SPEECH_OFF%Vous vous éloignez, en vous demandant si vous allez ou non chercher %town% et son arène festive.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Intéressant.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y >= this.World.getMapSize().Y * 0.6)
		{
			return;
		}

		local town;
		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.hasSituation("situation.arena_tournament"))
			{
				town = t;
				break;
			}
		}

		if (town == null)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 50;
	}

	function onPrepare()
	{
		this.m.Town.getSituationByID("situation.arena_tournament").setValidForDays(5);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

