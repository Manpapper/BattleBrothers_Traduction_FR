this.cultist_origin_flock_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_flock";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%joiner%, un dévot errant de Davkul, est venu rejoindre %companyname%. La compagnie se rassemble autour de lui, il fait un signe de tête, on lui rend la pareille, et comme ça, il est avec vous. | %joiner%, un homme en haillons, mais en armure dans les ombres de Davkul, a rejoint %companyname%. | Un homme du nom de %joiner% vous montre son dévouement à Davkul, une série de rites spirituels façonnés sur son crâne comme d'horribles cicatrices. Il est accueilli dans %companyname%. | %joiner% a traqué la compagnie pendant un moment avant de vous approcher directement. Il est un défenseur de la cause de Davkul, et avec cela son argument a été fait. L'homme se joint à la compagnie. | Davkul veille sûrement sur vous alors qu'un homme du nom de %joiner% rejoint %companyname%. Il a déclaré qu'il n'avait qu'un seul but et c'était de vous trouver et de s'assurer que ce monde voit tout ce qui l'attend. | %joiner% dit qu'il a vu les ombres vaciller derrière votre corps comme si elles étaient \"de flamme\". Il déclare qu'il se ralliera à votre cause car Davkul a sûrement intégré en vous un aspect de l'obscurité et de l'infini. | %joiner% marche à vos côtés. Il dit que vous êtes un aspect des ténèbres de Davkul et que des yeux éternels veillent sur l'ensemble de votre groupe. %companyname% le prend sous ses nombreuses ailes ombragées. | %joiner% trouve %companyname% en marche et rejoint ses rangs comme s'il n'était pas un étranger. Personne ne dit un mot et vous le dirigez simplement vers sa tente | En montrant sa tête balafrée, %joiner% déclare qu'il est à la hauteur de l'objectif de Davkul. Vous acquiescez et lui souhaitez la bienvenue dans %companyname%. | En marchant dans l'ombre de Davkul, vous étiez sûr de trouver des hommes comme %joiner%. Il a envie de rejoindre la compagnie, notamment parce que vous en êtes le commandant, et surtout parce qu'il pense que Davkul vous a choisi. | %joiner% s'associe à la compagnie et il n'y a guère de raisons de le faire. Lorsqu'on lui demande d'où il vient, il hausse les épaules et parle de Davkul tout en faisant un signe de tête complice dans votre direction.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oui, rejoins-nous.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cultist_background"
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"joiner",
			this.m.Dude.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

