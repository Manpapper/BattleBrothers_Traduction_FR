this.early_access_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.early_access_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_80.png[/img]Vous vous imprégnez de l\'air frais du matin. Alors que le soleil se lève lentement, un nouveau chapitre de votre vie commence. Après des années à ensanglanter votre épée pour un maigre salaire, vous avez économisé assez de couronnes pour créer votre propre compagnie de mercenaires. Vous êtes accompagné de %bro1%, %bro2% et %bro3%, avec qui vous avez déjà combattu côte à côte dans le mur de boucliers. Vous êtes leur commandant maintenant, le chef de %companyname%.\n\nLorsque vous parcourez les terres, vous devez recruter de nouveaux hommes dans les villages et les villes pour remplir vos rangs. Beaucoup de ceux qui proposent leurs services n\'ont jamais pris d\'arme auparavant. Peut-être sont-ils désespérés, peut-être sont-ils avides du rapide butin de la guerre. La plupart d\'entre eux mourront sur le champ de bataille. Mais ne vous découragez pas. Telle est la vie de mercenaire, et le prochain village aura toujours de nouveaux hommes désireux de prendre un nouveau départ dans la vie.\n\nLes terres sont dangereuses en ce moment. Les voleurs et les pillards sont en embuscade le long des routes, les bêtes sauvages rôdent dans les forêts sombres et les tribus d\'orcs s\'agitent au-delà des frontières de la civilisation. Des rumeurs parlent même de magie noire à l\'œuvre, de morts qui sortent de leurs tombes et qui marchent à nouveau. Les occasions de gagner de l\'argent ne manquent pas, que ce soit en acceptant des contrats que vous trouverez dans les villages et les villes de tout le pays, ou en vous aventurant seul pour explorer et faire des raids. Ils vivent et meurent pour %companyname% maintenant.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Huzzah!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The " + this.World.Assets.getName();
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"bro1",
			brothers[0].getName()
		]);
		_vars.push([
			"bro2",
			brothers[1].getName()
		]);
		_vars.push([
			"bro3",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});

