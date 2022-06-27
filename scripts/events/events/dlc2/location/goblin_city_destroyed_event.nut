this.goblin_city_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.goblin_city_destroyed";
		this.m.Title = "Après le combat";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]{L\'avant-garde gobeline vaincue, vous marchez sur la ville pour la mettre à sac. De petits gobelins sont tués et scalpés ou décapités. D\'autres encore s\'agitent autour de vous comme des fourmis, chacun portant quelque chose au-dessus de sa tête, comme des crânes humains ou des trésors, et l\'un d\'eux s\'élance follement en brandissant un mât avec sa bannière enflammée, un autre danse avec la tête décapitée d\'un loup.D\'autres encore s\'agitent autour de vous comme des fourmis, chacun portant quelque chose au-dessus de sa tête, comme des crânes humains ou des trésors, et l\'un d\'eux s\'élance follement en brandissant un mât avec sa bannière enflammée, un autre danse avec la tête décapitée d\'un loup. Vos hommes retournent les huttes et les baraques, chassent les plus maigres, tout ce qui respire est mis à mort.\n\n Une ancienne forteresse que les gobelins utilisaient comme base est attaquée avec le regard d\'un pillard. Vous entrez vous-même dans les couloirs et y trouvez un gobelin aveugle qui rampe avec une couronne de fémurs humains accrochée à son cou. Les peaux vertes grognent et courent dans votre direction, sentant sans doute votre présence, bien qu\'une expression de détresse sur leurs visages signifie qu\'ils sentent aussi l\'anéantissement de leur peuple. Vous éviscérez la peau verte et la laissez mourir sur le sol en pierre. Vos mercenaires se précipitent vers une salle de conseil remplie de vieillards et les abattent tous dans une frénésie meurtrière qui fait voler les membres, éparpiller les doigts et projeter le sang sur les murs et les tables.\n\n Vous vous dirigez vers l\'extérieur, dans la cour du château. Vous y trouvez un tas d\'humains morts, certains mutilés, d\'autres éviscérés, l\'un d\'eux bourré d\'une torche comme si sa cage thoracique était un brasero. Passé les cadavres, vous repérez les chenils des loups. Vous voyez des cages à loups brûlées, leurs dresseurs jetés à l\'intérieur pour mourir avec leurs bêtes. L\'un des loups est toujours vivant, il s\'élance pour rejoindre la ville avec une cape de flammes en guise de fourrure. Il court de maison en maison en aboyant et en hurlant pour être secouru. Vous regardez les flammes brûler rapidement les huttes en chaume et les cabanes en toit de paille. Avant d\'être vous-même consumé par le brasier, vous ordonnez aux hommes de sortir et regardez l\'endroit brûler. Une fois les sauvages éliminés, vous faites l\'inventaire du butin.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qui est-ce?",
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
			Text = "[img]gfx/ui/events/event_119.png[/img]{Alors que vous comptez le butin, l\'étranger qui a ordonné toute cette opération de chasse aux gobelins réapparaît. On ne peut même pas voir sa couleur car il est complètement recouvert de boyaux de sang de gobelins. Il a quelques scalps en main et une sacoche avec des oreilles et des nez qui ressortent, il y a du sang qui coule par le bas. Il hoche la tête.%SPEECH_ON%Tout va bien, voyageur, tout va bien. Nous a fait ce qu\'il fallait.%SPEECH_OFF%Vous lui demandez s\'il a mis le feu. Il acquiesce.%SPEECH_ON%Les Gobelins organisent leur arrière-garde dans des labyrinthes de murs et de mines. J\'ai fermé leurs issues pour coincer la population entre deux flancs, fermé la sortie, fermé l\'entrée, et mis le feu partout. Ils ont péri rapidement. Je vois que vous vous en êtes bien sortis. Vous pouvez garder le butin. Je n\'en ai pas l\'utilité.%SPEECH_OFF%Il se retourne et s\'en va. Vous criez sur ce guerrier immoral et lui demandez combien il voudrait pour rejoindre la compagnie. Cette fois, il se retourne.%SPEECH_ON%Heh, heh, haha, hahaha ! Voyageur ! Cette blague, ah. Comédie. Délicieuse. Vraiment. Mais mon travail ne sera pas abandonné tant que tous les gobelins n\'auront pas été éliminés.%SPEECH_OFF%D\'accord, chaque homme a son propre but. Mais vous êtes curieux. Vous demandez combien de villes il y a dans le monde.%SPEECH_ON%Vingt-trois, oh, désolé, vous avez demandé combien il y en a en tout ? Vingt-trois que j\'ai détruits, mais qui existent toujours, ah, deux, trois, hmmm. Je dirais quatre mille. Bon voyage, voyageur.%SPEECH_OFF%Cette fois, il part pour de bon. Vous vous retournez vers la compagnie %companyname%. Ils sont d\'un rare consensus: ils souhaiteraient n\'avoir rien entendu de tout cela.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Si peu, hein ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityDestroyed", true);
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

