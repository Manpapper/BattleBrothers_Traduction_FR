this.traveler_south_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.traveler_south";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Vous rencontrez un homme qui erre dans le désert avec une famille de jeunes hommes à ses côtés. Il vous accueille autour d\'un feu de camp et vous demande si vous voulez entendre des histoires du désert et du sud en général.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Heureux de vous rejoindre au feu de camp.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Non, gardez vos distances.",
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
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]{L\'homme poursuit en parlant de l\'Ancien Empire - du moins de ce qu\'il en sait.%SPEECH_ON%Il est difficile de dire exactement ce qu\'il était, vous savez ? Et il est difficile de dire exactement ce qui l\'a précédé. J\'ai eu un aperçu des bibliothèques de %randomcitystate% et j\'ai été plutôt étonné de ce que j\'ai pu trouver. Vous savez quels sont les textes les plus anciens que nous ayons ? Les textes anciens. Tu sais sur quoi ces textes anciens écrivent ? D\'autres textes anciens. Nous n\'avons aucune idée de l\'époque à laquelle nous vivons. Nous existons juste dans l\'ici et maintenant, et peut-être qu\'un jour dans le futur notre progéniture découvrira que nous sommes le mystère, et ceux qui étaient des mystères pour nous... Il cisaille ses doigts dans l\'air...%SPEECH_OFF%Il fait disparaître le feu de camp avec un tisonnier de fer.%SPEECH_ON%Il dit que les Ifrits sont des manifestations de la cruauté de l\'homme. Quand nous sommes mauvais les uns envers les autres, il y a une force, une force invisible, contre laquelle nous faisons pression. Quand nous attaquons et massacrons sur une plus grande échelle, cette force est pliée à travers la couture entière, mais quand nous faisons le mal contre un individu, à des fins si horribles, c\'est quand cette force se brise. Un trou est fait, et de ce trou sort une correction. Une correction que nous appelons l\'Ifrit. Une correction qui cherche à faire amende honorable, en réparant littéralement ces forces invisibles avec les cadavres de ceux qui ont osé les ouvrir en premier lieu.%SPEECH_OFF%L\'homme met le tisonnier de fer de côté. Il sourit sombrement.%SPEECH_ON%C\'est ce qu\'on dit, en tout cas.%SPEECH_OFF% Malgré son âge avancé, il croise les jambes avec la souplesse et l\'agilité d\'un jeune homme. Il s\'est sans doute assis devant de nombreux feux de camp. Il parle aussi chaleureusement que les flammes devant vous.%SPEECH_ON% J\'ai passé de nombreux étés sur ces sables. Mais mes fils, à qui j\'ai survécu, je dois dire tristement, demanderaient-ils, comment continuons-nous à lire l\'heure d\'une saison à l\'autre ? À quel repère indiquons-nous les années ? Un doigt ridé est levé, et il pointe plus haut. Il vous fait un clin d\'œil.%SPEECH_ON%Les étoiles. Elles tournent dans le ciel selon des motifs que l\'on peut reconnaître si l\'on est prêt à prêter attention. J\'imagine aussi que ces étoiles peuvent être des êtres d\'un autre éther, un autre lieu inimaginable. Peut-être quelque part où nous irons quand nous mourrons, mais ce ne sont que des ouï-dire, bien sûr, et juste entre nous, voyageurs rêveurs, d\'accord ? Il sent la boisson et la boit à nouveau avant de la poser et de s\'étirer.%SPEECH_ON%Vous savez, j\'attends avec impatience la fin de mon chemin doré. Cela a été bon pour moi, toutes ces années, mais je peux dire que je marche entre les garrots de ce monde horrible et plus tôt je pourrai partir, mieux ce sera. J\'ai l\'impression que si je reste trop longtemps dans le coin, le monde va découvrir que je me suis échappé, reçu à la main, et que je m\'en suis sorti avec une belle vie alors que j\'étais censé souffrir. Il hausse les épaules. L\'instinct. Vous l\'avez aussi, Mercenaire, je n\'en doute pas. Après tout, comment faites-vous pour aller si loin quand d\'autres, comme vous, s\'enfoncent dans la terreur, l\'horreur et, finalement, la mort ? Il y a un Gardien quelque part dans ce monde, un grand comptable, peut-être est-ce le Doreur, peut-être est-ce autre chose, mais la vie n\'est pas faite pour être éternellement bonne. A un moment donné, éventuellement, il y aura un grand, un mauvais moment.%SPEECH_OFF% | Une fois que vous vous êtes installés, le vieil homme se penche en arrière comme si vous étiez un vieil ami et commence à parler.%SPEECH_ON%Il est intéressant pour moi de vous voir ici, Mercenaire, habillé dans les regalia du brigandage pour ainsi dire. Voilà des hommes simples en des temps simples. Mais je suppose que vous êtes aussi conscient que moi d\'un passé bien plus important. Le sentiment qu\'il y a eu une longue, longue période d\'événements qui nous ont précédés. Vous acquiescez. Cela semble évident. L\'homme acquiesce aussi. %SPEECH_ON%C\'est bien. Cela montre une nature curieuse de votre côté, même juste en reconnaissant qu\'il y a eu beaucoup de choses qui ont marché sur ces sables avant nous deux. Beaucoup... beaucoup ne prennent même pas cela en considération. Ils vivent dans l\'ici et maintenant. D\'une certaine manière, je les envie. Comment ce doit être d\'exister en tant que soi-même et seulement soi-même avec le monde entier sous vos pieds.%SPEECH_OFF% Il s\'allonge et regarde le ciel.%SPEECH_ON% Je pense que la plupart des gens ne croient pas vraiment qu\'ils vont mourir.%SPEECH_OFF% Vous vous asseyez et le vieil homme se penche en arrière avec un livre à la main qui est à la fois un parchemin et une reliure. Il lit, levant de temps en temps les yeux. Vous n\'avez aucune idée s\'il parle à partir du texte ou si sa nature est capable de tenir deux études différentes en même temps.%SPEECH_ON%Vous savez comment l\'Ancien Empire a été abattu ? On dit que c\'était une grande explosion de la terre elle-même.%SPEECH_OFF%Il imite avec ses mains une explosion des sables.%SPEECH_ON%Un volcan. Mais cela semble beaucoup trop simple, n\'est-ce pas ? Un volcan qui anéantit tout l\'empire?%SPEECH_OFF% Vous remarquez que le meilleur compagnon que vous avez pourrait être estropié par une petite entaille à l\'arrière de ses talons. Ne pouvant plus marcher correctement, tourner, pivoter ou mettre du poids sur ses pieds, il s\'effondrerait de bas en haut. Le vieil homme vous regarde fixement. %SPEECH_ON%Hmm, c\'est peut-être vrai alors. Peut-être que ce volcan a anéanti le peu d\'emprise que cet empire avait sur son propre contrôle. Après cela... qui sait ce qui s\'est passé. Le chaos, sans doute. Vous vous asseyez et l\'homme commence à parler presque immédiatement. J\'ai entendu des rumeurs d\'un culte qui circule. Quelque chose à propos de Davkul. Eh bien, je dirai ceci : ils sont sérieux à ce qu\'il paraît. %SPEECH_OFF%Vous lui demandez s\'il a des connaissances au-delà des rumeurs. Il hausse les épaules.%SPEECH_ON%Ce n\'est qu\'un culte de la mort et il ne vient pas d\'ici. En tout cas, vous n\'entendrez jamais un sudiste admettre que cette création de Davkul a commencé ici. Non, non, ça doit être ces vauriens du nord qui ont eu l\'idée d\'un dieu de la mort aussi horrible. Vous comprenez qu\'il n\'est pas vraiment impliqué dans ce sujet et qu\'il l\'a seulement lancé pour voir votre réponse. | Vous vous asseyez et l\'homme commence à parler immédiatement. Une des natures étranges du désert est qu\'il peut à la fois préserver et effacer toutes choses. Comprenez-vous ce que je veux dire ? Si vous deviez mourir, les sables vous avaleraient entièrement, mais vous, votre corps, ne disparaîtrait jamais vraiment. Il serait submergé. Si nous devions commencer à nous frayer un chemin dans le désert autour de nous, nous trouverions sûrement des corps et des trésors et certains disent même des villes entières.%SPEECH_OFF% Vous écartez cette idée, mais l\'homme lève un doigt.%SPEECH_ON%Tsk tsk tsk, ne soyez pas si dédaigneux, mercenaire. C\'est un monde affamé et, que mon chemin soit doré, il est tout à fait possible que toutes ces villes que nous connaissons aujourd\'hui aient bientôt disparu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Que votre chemin soit toujours doré.",
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

		if (currentTile.SquareCoords.Y >= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				return;
			}
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

