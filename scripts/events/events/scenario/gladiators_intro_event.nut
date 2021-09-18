this.gladiators_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.gladiators_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Tuer un homme devrait être une affaire simple, mais l\'inconnu endurcit la chair : les meurtriers surpris dans la rue, s\'étouffant, les bras tendus, les mains serrées, criant pourquoi leurs victimes ne meurent pas. Le domaine maternel se défait, frappant son mari avec le fer à repasser, encore et encore, et pourtant il respire encore longtemps après que les flammes se soient éteintes. Un Vizir qui s\'ennuie et ne comprend pas pourquoi ses tortionnaires se débattent avec un criminel, l\'homme fou qui se moque d\'eux alors qu\'ils coupent les appendices les plus importants.\n\nMais pour un gladiateur, un homme n\'est pas seulement un homme, c\'est un manieur d\'armes. Épées, haches, lances, tridents, et plus encore. Une fois que vous avez passé toutes ces défenses manifestes, il n\'est plus que de la chair très familière, et l\'éliminer n\'est pas une question de lutte, mais de divertissement. Du divertissement ! La compétition avec chaque once de peau dans le jeu, et la délectation des foules. Ce sont les choses que vous aimez. Laissez les philosophes s\'épancher sur la nature de la vie et de la mort des choses. Quand vous plongez une épée dans le cou d\'un imbécile, non seulement le sang jaillit de votre lame, mais la foule se réjouit de votre exploit ! C\'est le son le plus merveilleux du monde ! Et les femmes qui viennent après, si chaudes et ennuyées qu\'elles n\'attendent même pas que tu nettoies les entrailles avant de te sauter dessus ? Glorieux.\n\nMais ça devient ennuyeux, aussi. Combien de combats cela fait-il ? Vous ne pouvez pas compter. Combien de défis ? Vous ne pouvez même pas en citer un seul. Pas un seul ! %g1%, %g2%, et %g3% sont tous d\'accord : vous êtes juste trop bon. Et ils sont plutôt bons aussi, pour être honnête. Mais vous êtes tous les quatre d\'accord : vous allez quitter les arènes et forger un esprit de champion dans le monde entier.\n\nLes gladiateurs ont un penchant pour l\'opulence, en particulier pour les bains parfumés et les bijoux qui portent leur nom, alors préparez-vous à payer une somme conséquente pour chacun d\'entre eux afin de financer leur style de vie somptueux en dehors du confort des villes-États. Et il en sera ainsi. Vos trois compagnons de combat solides, mais pas de tous les temps, feront étalage de leurs prouesses martiales, et vous devrez relever un nouveau défi : apprendre à gérer des guerriers (qui ne sont pas à votre niveau) et leurs besoins.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça devrait être facile.",
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
		this.m.Title = "The Gladiators";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"g1",
			brothers[0].getName()
		]);
		_vars.push([
			"g2",
			brothers[1].getName()
		]);
		_vars.push([
			"g3",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});

