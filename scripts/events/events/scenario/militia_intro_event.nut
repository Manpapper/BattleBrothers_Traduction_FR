this.militia_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.militia_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Chassez les bandits. Repousser les pilleurs. Piéger les loups qui attaquent les fermes. Tout cela fait partie du travail d\'un milicien. Et si l\'on demande plus, alors il y a simplement plus à répondre. Tout cela pour assurer la sécurité de votre foyer. \n\nLorsqu\'un noble a fait appel à vous, vous et un groupe de combattants avez pris part à une bataille entre des personnes de haut rang. Vous ne connaissiez ni leur nom, ni leur but, seulement le fait qu\'on vous ait appelé, vous et vos hommes, sur le champ de bataille. Et donc vous y êtes allés. Malheureusement, un homme de basse naissance avec une lance et un bouclier n\'est guère plus qu\'un paysan qui a des doutes sur le métier de guerrier. Votre milice a été utilisée pour maintenir en place un contingent de chevaliers ennemis pendant que les archers de ton propre camp faisaient pleuvoir l\'enfer du haut des airs, frappant chevaliers et paysans de la même façon.\n\n Après la bataille, vous et vos hommes avez fui les champs pour de bon. Vous avez pris les armes comme mercenaires et vous vous êtes jurés par un pacte de sang de ne jamais avoir de noble dans votre compagnie. Une bande de mercenaires hétéroclites et c\'est tout.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous sommes nos propres seigneurs.",
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
		this.m.Title = "The Peasant Militia";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"home",
			this.World.Flags.get("HomeVillage")
		]);
	}

	function onClear()
	{
	}

});

