this.anatomist_ok_with_mutations_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_ok_with_mutations";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Après avoir passé un certain temps avec ses nouvelles malformations, %anatomist% a fini par accepter qui il est maintenant. Il voit ces horribles cicatrices et ces pustules grandissantes comme la preuve qu\'il est sur la bonne voie. D\'une certaine manière, il a raison. Ces étranges changements ont fait de lui un combattant bien supérieur à ce qu\'il était auparavant, ce qui en dit long pour vous qui n\'aviez personnellement aucun espoir de voir ces têtes d\'œufs faire quelque chose de correcte un jour. Les craintes et les inquiétudes qu\'il avait auparavant ont complètement disparu, remplacées par une volonté  de fournir un travail bien fait et plus encore. | %anatomist% a arrêté de se morfondre en pensant à ses cicatrices et à son horrible apparence. Il semble qu\'il ait fait la paix avec lui-même, ou peut-être qu\'il s\'est tellement habitué à l\'odeur épouvantable qui émane de chaque partie de son corps qu\'il ne la remarque plus. Bien que sa puanteur vous fasse presque vomir à chaque fois que vous êtes près de lui, sa vie n\'est plus rongée par l\'ennui. Peut-être pourra-t-il maintenant poursuivre son chemin vertueux vers de nouvelles découvertes scientifiques, ou partir sur un autre chemin. | Il est difficile d\'accepter ce que l\'on est et, malgré la superficialité, il est encore plus difficile de faire la paix avec son apparence. C\'est d\'autant plus vrai lorsque votre apparence n\'est pas le résultat de votre naissance, mais qu\'elle a été façonnée par les actions que vous avez entreprises dans votre vie. Si ce sont vos propres décisions qui vous ont conduit à ce résultat, vous allez devoir assumer pour le reste de votre vie. Vous l\'avez vu de nombreuses fois, en particulier avec les mercenaires qui perdent leurs oreilles, leurs nez, leurs lèvres, et pire encore. Il faut parfois beaucoup de temps à un homme pour faire la paix avec sa nouvelle vie, et %anatomist% n\'était pas différent. Mais il a trouvé la paix. Les horribles cicatrices et mutations dont il a souffert de ses propres actions ont disparu, du moins mentalement. Il est passé à autre chose et est prêt à poursuivre son chemin dans ce monde en tant que personne à la recherche de projets scientifiques... projets qui pourront comporter des risques pour lui-même.  | L\'anatomiste s\'est habitué à ses nouvelles formes. Au début, les réactions de son corps aux potions et aux concoctions qu\'il a ingurgitées étaient si perturbantes qu\'il était devenu une coquille vide. On peut difficilement lui en vouloir, car il avait et a toujours l\'air assez hideux. Mais au bout d\'un moment, on se rend compte que la vie continue, et que si on ne peut rien y faire, on ne peut rien y faire. Et, au final, le but réel de ses choix étaient de répondre aux besoins de recherches scientifiques. Il semble que la vie de %anatomist% ait de nouveau un sens. Il est toujours disgracieux et dégoûtant et vous avez du mal à le regarder, mais au moins il est plus heureux maintenant. | Autrefois frappé par des maladies et des défigurations, %anatomist% l\'anatomiste commence à avoir meilleure mine. En d\'autres termes, il s\'est rendu compte qu\'il ne pouvait pas faire grand-chose pour son apparence physique qui, pour être concis, est toujours quelque chose qui demande du courage et de la volonté pour être regardé. Mais l\'homme s\'est souvenu de la véritable raison pour laquelle il recherchait les concoctions, les mélanges étranges et les teintures qui l\'ont transformé en une monstruosité ambulante et parlante. Cette raison est une question d\'essai scientifique. L\'anatomiste est maintenant un homme plus heureux tant qu\'il peut être tenu à l\'écart du moindre miroir, vous imaginez que cela peut plus ou moins être possible. | L\'habitude de %anatomist% d\'avaler toutes les potions qu\'il concocte lui a finalement coûté cher. Son dernier breuvage a mal tourné, transformant son visage en une pâte charnue, et faisant apparaître sur sa peau toutes sortes de bosses, de bleus, de pustules et de poches. Naturellement, ces changements ont eu un profond impact sur le moral de l\'homme. Mais, finalement, il s\'en est remis. Il est toujours une monstruosité ambulante et parlante dans tous les sens du terme, mais à l\'intérieur, il est en paix, et ce qui compte, c\'est ce qu\'il y a à l\'intérieur. Ou du moins, ça a intérêt à compter, parce que ce qu\'il y a à l\'extérieur, vous pouvez à peine avoir assez de courage pour l\'affronter. | %anatomist% appelle les changements de son corps \"mutations\", ce qui doit être un mot de tête d\'œuf pour dire qu\'il ressemble à une merde. Pendant un moment, son apparence était un frein à sa vie de tous les jours. On peut difficilement le blâmer, il s\'est infligé ces maladies lui-même, ce qui est toujours bien pire que lorsque le monde vous le fait et laisse peu de doutes sur la façon dont vous auriez pu vous en sortir. Heureusement, l\'anatomiste a surmonté sa dépression et son angoisse face à son horrible apparence. Il pourrait même être plus disposé que jamais à continuer d\'absorber ses potions et concoctions. Il ne peut certainement pas être pire qu\'il ne l\'est déjà et, pour dire, même les dames s\'y intéressent, comme lorsqu\'on voit un chien si galeux et décrépit qu\'on ne peut s\'empêcher de le caresser par curiosité. | Après avoir bu un certain nombre de potions douteuses, le corps de %anatomist% a commencé à changer et, comme pour tout homme adulte, le changement à cet âge est rarement une bonne chose. Son visage est devenu défiguré, son corps tacheté de plaies et de cicatrices. Pendant un certain temps, l\'anatomiste a sombré dans une profonde dépression à cause de cette affaire et on s\'est demandé s\'il n\'avait pas été irréversiblement endommagé non seulement à l\'extérieur, mais aussi à l\'intérieur. Heureusement, c\'est le moral d\'un homme qui peut être le plus difficile à briser. %anatomist% a accepté sa nouvelle apparence. Ce n\'est pas comme s\'il pouvait y faire grand-chose, il voit maintenant son changement comme une sorte de rituel qu\'il a réussi à passer grâce à ses recherches scientifiques et qui l\'ont amené sur ces terres en premier lieu. Vous devez juste vous assurer qu\'il n\'est pas la première chose que vous verrez le matin.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Content que vous alliez mieux, %anatomist%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Has come to terms with his mutations");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.getFlags().add("isOkWithMutations");
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && bro.getFlags().has("gotUpsetAtMutations") && !bro.getFlags().has("isOkWithMutations"))
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 10 * anatomistCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

