this.southern_quickstart_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.southern_quickstart_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_156.png[/img]{Vous auriez pu rester chez vous. Ne jamais quitter la ville. Passer vos journées à travailler pour un quelconque Vizir. Au lieu de cela, vous avez pris l\'épée, récupéré le peu d\'argent que le Gilder vous a donné, et vous avez créé une bande de mercenaires.\n\nLa vie d\'un trampant vous a mené dans des endroits que la plupart des gens ne voient jamais. En un sens, vous avez ouvert des portes et des avenues par la violence. Mais les années ont lentement fait peser sur votre cou une vérité désagréable : vous êtes à peine au-dessus du statut de brigand. Vous êtes embauché par les gens du coin pour faire des choses simples pour un salaire simple, puis on vous renvoie chez vous. Vous voulez que %companyname% soit plus grande que ça. Vous voulez que votre compagnie soit présentée dans les bureaux du Vizir, vous voulez qu\'elle gagne la gloire qu\'elle mérite, et peut-être même que vous voulez qu\'elle voyage vers le nord, dans des terres lointaines. Bon sang, peut-être que dans le Nord, on traite les mercenaires avec respect !\n\nBien sûr, ce ne sera pas facile. Vous n\'avez que quelques hommes sous la main. Mais ces hommes sont %bro1%, %bro2%, et %bro3%, les meilleurs combattants que vous n\'ayez jamais connus. Avec eux à vos côtés, le monde entier connaîtra %companyname% !}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le Gilder nous révélera le chemin.",
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

