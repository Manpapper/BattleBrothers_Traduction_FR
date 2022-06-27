this.fountain_of_youth_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.fountain_of_youth";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_114.png[/img]{Vous vous tenez à l\'orée d\'une clairière et la vue qui s\'offre à vous est incroyable.\n\n Le tronc d\'un corps humain sort de terre comme un arbre élancé, nu, la chair de poule en guise d\'écorce, il continue de monter jusqu\'à ce qu\'il soit deux fois plus grand que vous. Il n\'y a pas de branches. Il n\'y a pas de mains. Il y a, à la place, une série de têtes humaines reliées formant un bouquet là où devrait se trouver la cime de l\'arbre. De gauche à droite, ce sont des bébés dotés d\'une magnifique prestance, sans sexe, des créations difformes du temps, où leurs ombres transforment leurs visages d\'étrangement familiers à étrangement naïfs, tandis qu\'ils regardent fixement comme s\'ils ne savaient pas comment ils sont arrivés là et semblent toujours prêts à vous le demander. Cela vous rappelle une noyade que vous avez observée par hasard, le visage se contorsionnant sous l\'eau courante de la rivière, la chair ne souffrant que de conjectures persistantes quant à ce qui l\'a mise là.\n\n Des chuchotements s\'échappent des arbres. Ils glissent sur le sol comme s\'ils étaient prononcés par les insectes, ils grimpent le long de vos bras jusqu\'à ce qu\'ils vous grattent les oreilles. Ils vous demandent de rester.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons voir ce que c\'est.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "On doit se barrer d\'ici. Rapidement.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_114.png[/img]{En entrant dans la clairière, l\'étrange créature se redresse, balançant sa tête d\'un côté à l\'autre comme un paon qui se prépare à une parade. Ils vous parlent.%SPEECH_ON%Le. Aîné. Oui. Ici. Oui. Lui. Nous. Le connaissons. Lui. Nous. Connaissions.%SPEECH_OFF%Les visages se déforment et se décolorent comme s\'ils étaient ternis par les mots qui sortent de leurs bouches. Lentement, ils se remettent à parler, une panoplie grotesque rythmant une tête après l\'autre.%SPEECH_ON%Buvez. Un peu. Soigner. Tout. Buvez. Tous. Devenir. Un.%SPEECH_OFF%Vous regardez vers le bas pour voir un excédent de terre qui se courbe sur une flaque de la taille d\'une assiette. Il y a un léger filet d\'eau qui s\'écoule de l\'excédent, personne ne sait d\'où vient cette eau. Vous levez les yeux pour voir les visages qui vous regardent, leurs apparences passant de l\'angoisse au bonheur, à la surprise, à la peur puis à la confusion.%SPEECH_ON%Familier. Toujours. Familier. Boire. Un peu. Oui. Non. Bois. Tout.%SPEECH_OFF%En regardant vers le bas, vous sortez votre gourde et faites sauter le bouchon.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je vais juste en prendre un peu.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Je vais tout boire!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_114.png[/img]{Vous vous accroupissez sous l\'arbre grotesque. Les têtes se balancent vers le bas, l\'ombre les accompagnant comme si quelqu\'un posait le couvercle sur un panier. Lorsque vous levez les yeux, elles vous fixent à un mètre de distance, ondulant et toujours en mouvement. Pourtant, l\'une d\'entre elles, tout au bout, est immobile. Son visage prend la forme d\'un vieil homme, le front froncé, les bajoues tendues, les traits âgés toujours plissés comme si la fureur se repliait sur elle-même. Une sphère de ténèbres l\'entoure, la pénombre vibre, comme si la tête regardait depuis un tout autre monde.\n\n Les mains fermes, vous prenez la gourde et en versez le contenu. Vidée, vous la mettez sous l\'excédent dégoulinante et écoutez chaque goutte toucher le fond. Les visages se rapprochent de plus en plus, vous entourant dans un cône de chaos. Au fur et à mesure qu\'ils s\'approchent, vous pouvez entendre le déchirement de leur réalité alors qu\'ils se mettent en place et se désagrègent. La gourde tremble dans votre main comme si une chute d\'eau lui tombait dessus. Vous l\'arrachez de l\'excédent et, en tombant en arrière, vous réalisez que les têtes se sont redressées depuis longtemps. En roulant, vous vous remettez sur pied en rampant et sortez de la clairière en courant. En sécurité, vous vous retournez pour voir que la créature a disparu. Il n\'y a rien du tout. Pas d\'arbre. Pas de fontaine. La gourde, cependant, est toujours là.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il vaut mieux garder ça dans un endroit sûr.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().die();
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/special/fountain_of_youth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_114.png[/img]{Vous jetez la gourde par terre, mettez votre bouche dans la flaque et buvez. Le monde sous la surface de la flaque est vide et silencieux. Vos lèvres bougent, vous avalez, mais il n\'y a rien à boire ici. Vous criez. Il n\'y a rien. Pas même une sensation. Juste une notion de peur, un chatouillement sans moyen de le soulager. Lorsque vous mettez vos mains sur le sol pour essayer de vous retirer, vous constatez que vous ne pouvez pas quitter la flaque.\n\n Des visages pâles apparaissent et disparaissent du vide. Ils sont comme ceux de l\'arbre, inanimés, douloureusement issus du passé, du présent et du futur, les voilà qui s\'approchent, se rassemblent en nombre, bouillonnent et se bousculent, transformant cet enfer noir en un blanc écumeux. À leur approche, vous vous rendez compte que vous n\'avez pas bien regardé. Individuellement, ils ne sont que des visages sans réalité. Pris dans leur ensemble, la grande feuille blanche s\'approche, vous réalisez qu\'ils forment un grand visage: le vôtre. Le visage rit.\n\n En hurlant, vous ressortez de la flaque. %randombrother% vous tient sous son bras, il vous regarde avec inquiétude.%SPEECH_ON%Monsieur, vous allez bien ? Vous faisiez une sieste et votre tête a glissé dans l\'eau.%SPEECH_OFF%Vous levez les yeux, pensant voir l\'arbre grotesque et ses visages horribles. Il n\'est pas là et peu importe combien de fois vous regardez ou à quels endroits, il a totalement disparu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je... ne... comprends pas.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().die();
						}

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

