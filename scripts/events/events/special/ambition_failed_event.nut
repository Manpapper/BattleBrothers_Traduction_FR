this.ambition_failed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ambition_failed";
		this.m.Title = "During camp...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%randombrother% grommelle.%SPEECH_ON% Abandonner n'est pas dans les habitudes de cette compagnie, ou du moins je ne le pensais pas.%SPEECH_OFF% Les hommes se sont morfondus aujourd'hui, jurant bruyamment pour rien et marmonnant dans leur verre. Ils sont mécontents que la compagnie n'ait pas atteint l'objectif sur lequel tout le monde s'était mis d'accord.%SPEECH_ON%Certainement, nous pourrions poursuivre cette tâche que nous nous sommes fixée à travers le monde, tout comme nous pourrions passer nos journées à chasser les papillons, mais si ce n'est pas possible, laissons ce malheur derrière nous et passons à ce que nous faisons le mieux : nous battre, boire et dépenser notre argent durement gagné!%SPEECH_OFF%%highestexperience_brother% encourage ses frères d'armes. Ces paroles apaisent quelque peu les hommes et vous êtes soulagé de ne pas avoir de révolte sur les bras. | Alors que vous faites le tour des tentes du camp, %randombrother% s'approche pour se plaindre.%SPEECH_ON%Il me semble me rappeler avoir signé avec une bande de combattants sans pitié. Des hommes qui ne laissaient rien se mettre en travers de leur chemin. Maintenant, %companyname% ressemble plus à une escouade d'enfants fatigués qu'à une force imparable.%SPEECH_OFF%Il fait une pause, se mord les lèvres.%SPEECH_ON%Capitaine, monsieur, je veux dire.%SPEECH_OFF%Vous hochez la tête et continuez votre chemin. De toute évidence, l'homme est contrarié par l'incapacité de la compagnie à atteindre l'objectif que vous avez annoncé aux hommes il y a peu de temps. | Malgré tous vos efforts, vous avez échoué dans la réalisation de votre dernière ambition sur le chemin de la grandeur de la compagnie. Pire encore, les hommes en sont tous parfaitement conscients et semblent plus découragés que vous par cet échec. Les pieds traînent, les têtes sont baissés, les plaintes et le mécontentement sont plus forts que d'habitude. Pourtant, le soleil se lève quand même, et s'inquiéter des échecs des uns et des autres, c'est perdre du temps qu'il vaudrait mieux consacrer à de nouvelles opportunités. Vous savez que les hommes de %companyname% surmonteront ce revers et marcheront vers de plus grandes gloires. Ou mourront en essayant. | Après de nombreux efforts, vous êtes finalement contraint de renoncer à l'ambition que vous avez choisie pour %companyname%. Une compagnie de mercenaires doit faire face à de nombreux revers sur le chemin de la grandeur, mais ce dernier échec a été particulièrement amer pour les hommes. Il serait sage d'obtenir un contrat lucratif ou de leur fournir une autre distraction, peut-être la menace d'une mort imminente pourra les distraire de leur malheur. | Après avoir annoncé aux hommes que la compagnie ne sera pas en mesure de faire ce que vous aviez si fièrement annoncé, les hommes deviennent distants et maussades. Comme des enfants boudeurs, ils se détournent lorsque vous vous approchez et murmurent leurs plaintes lorsque vous avez le dos tourné.%SPEECH_ON%Comment allons-nous devenir célèbres si nous ne finissons pas ce que nous avions commencé ? Je veux être connu partout où nous allons, et que nos boissons soient servies avant que nous passions la porte.%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Tout ne se passe pas comme prévu. | Eh bien... | Les hommes comprendront. | Ça n'arrêtera pas %companyname%. | L'important, c'est que nous allions de l'avant. | De nouveaux défis nous attendent.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(this.Const.MoodChange.AmbitionFailed, "A perdu confiance en votre leardership");

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
		return;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local lowest_hiretime = 100000000.0;
		local lowest_hiretime_bro;
		local highest_hiretime = -9999.0;
		local highest_hiretime_bro;
		local highest_bravery = 0;
		local highest_bravery_bro;
		local lowest_hitpoints = 9999;
		local lowest_hitpoints_bro;

		foreach( bro in brothers )
		{
			if (bro.getHireTime() < lowest_hiretime)
			{
				lowest_hiretime = bro.getHireTime();
				lowest_hiretime_bro = bro;
			}

			if (bro.getHireTime() > highest_hiretime)
			{
				highest_hiretime = bro.getHireTime();
				highest_hiretime_bro = bro;
			}

			if (bro.getCurrentProperties().getBravery() > highest_bravery)
			{
				highest_bravery = bro.getCurrentProperties().getBravery();
				highest_bravery_bro = bro;
			}

			if (bro.getHitpoints() < lowest_hitpoints)
			{
				lowest_hitpoints = bro.getHireTime();
				lowest_hitpoints_bro = bro;
			}
		}

		_vars.push([
			"highestexperience_brother",
			lowest_hiretime_bro.getName()
		]);
		_vars.push([
			"strongest_brother",
			lowest_hiretime_bro.getName()
		]);
		_vars.push([
			"lowestexperience_brother",
			highest_hiretime_bro.getName()
		]);
		_vars.push([
			"bravest_brother",
			highest_bravery_bro.getName()
		]);
		_vars.push([
			"lowesthp_brother",
			lowest_hitpoints_bro.getName()
		]);
		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearest_town_distance = 999999;
		local nearest_town;

		foreach( t in towns )
		{
			local d = t.getTile().getDistanceTo(playerTile);

			if (d < nearest_town_distance)
			{
				nearest_town_distance = d;
				nearest_town = t;
			}
		}

		_vars.push([
			"currenttown",
			nearest_town.getName()
		]);
		_vars.push([
			"nearesttown",
			nearest_town.getName()
		]);
	}

	function onClear()
	{
	}

});

