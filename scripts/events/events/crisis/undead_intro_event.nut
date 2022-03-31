this.undead_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.undead_intro";
		this.m.Title = "Pendant le campement...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_84.png[/img]Vous baissez la tête pour faire une sieste.\n\n Le drap soyeux glisse de votre corps lorsque vous roulez sur le côté. Des oiseaux voltigent devant une élégante fenêtre au cadre en ivoire. Une voix se déverse dans votre oreille, un soupçon d\'arôme que vous n\'avez jamais senti avant de vous sussurer.%SPEECH_ON%Vous êtes réveillé.%SPEECH_OFF%Une femme se retourne, passant un doigt sur votre poitrine avant de remonter et saisissant votre menton. Souple, jolie, le soleil brillant sur son visage lisse et illuminant une paire d\'yeux émeraude. Elle s\'avance pour un baiser. Vous sortez rapidement du lit et regardez frénétiquement autour de vous. Elle saisit les draps et se met à genoux, confuse.%SPEECH_ON%Qu\'est-ce qui ne va pas ? Où vas-tu mon Empereur ?%SPEECH_OFF%En levant les yeux, vous voyez un plafond qui s\'étend si haut que vous pouvez à peine voir les œuvres d\'art qui y ont été peintes de manière exquise. Vous ouvrez une porte et sortez sur un balcon. Des immeubles d\'une hauteur inouïe, des bannières rouges, blanches, dorées, un horizon bardé de formes noires à perte de vue. Des dômes, des fontaines, de grandes arches, des statues si hautes qu\'elles semblent commander les structures en tant que soldats. Au sommet de chaque toit se trouve un jardin plus grand et plus affleurant que tout ce que vous avez vu dans les sources éternelles de la nature elle-même. Soudain, deux hommes surgissent à vos côtés avec des cages de colombes et les laissent sortir. Les oiseaux se dispersent désespérément et juste à ce moment-là, un rugissement éclate en dessous de vous. De grandes foules de gens sautant et agitant des banderoles.%SPEECH_ON%Ils aiment leur empereur.%SPEECH_OFF%La femme parle depuis la porte.%SPEECH_ON%Allez vers eux.%SPEECH_OFF%Vous regardez vers le bas pour voir un flot de soldats marchant au milieu de la route, chaque homme marchant à l\'unisson avec son frère, un claquement de bottes régulier et saccadé.Leurs visages sévères dans leurs heaumes dorés, leurs longues armes d\'hast luisant vers le haut comme s\'ils avaient l\'intention de vaincre leurs ennemis avec l\'opulence même.%SPEECH_ON%Ils partent à la guerre. Affronter le Grand Au-delà, et le vaincre.%SPEECH_OFF%La femme est à vos côtés. Elle vous sourit chaleureusement en vous prenant par le bras. Vous vous sentez prêt à l\'accepter, à cette nouvelle réalité, quelle qu\'elle soit. Vous la prenez par la joue, prêt à tomber dans son étreinte, mais un cri d\'en bas gémit fort et clair sur tout le reste. Vous jetez un coup d\'œil vers le bas pour voir les soldats, autrefois réunis dans une parfaite uniformité, rompre le rang. Au loin, une grande montagne entre en éruption, projetant de grandes rafales de feu rouge et un énorme nuage de cendres chaudes qui se déverse rapidement dans la ville. Les bâtiments se désintègrent, les jardins s\'enflamment et les gens... les gens crient. Ils se détournent, mais il n\'y a pas moyen d\'échapper à la chaleur. Les soldats s\'effondrent et hurlent. Une chaleur fulgurante et brûlante, et bientôt vous voyez les habitants fondre, les soldats devenir des golems de métal, brûlés dans l\'armure même qui était censée les protéger, et les foules sans armure s\'enflammer tout simplement. La femme pleure à vos côtés.%SPEECH_ON%Oh, c\'est horrible ! Horrible! Voudriez-vous le regarder? Mais ça va, tu comprends ? C\'est parfaitement correct. Regardez-moi. Regarde-moi !%SPEECH_OFF%La femme t\'attrape et te fait te retourner. Ses traits autrefois doux se sont durcis en flocons noircis, le haut de sa tête déjà brûlé et chauve, ses dents tombant de gencives dégoulinantes. Pourtant, elle sourit.%SPEECH_ON%Nous nous relèverons,  mon empereur ! Nous... allons... nous relever... à nouveau !%SPEECH_OFF%Son crâne se brise et son corps s\'effondre en un tas d\'os brûlants.\n\n Vous vous réveillez en sursaut pour trouver %randombrother% en train de vous secouer.%SPEECH_ON% Monsieur, réveillez-vous ! Nous avons ici un groupe de réfugiés qui disent que les morts sortent de terre et tuent tout ce qu\'ils voient !%SPEECH_OFF%Le visage de la femme clignote devant vos yeux. Il est horriblement cicatrisé, mais cela ne l\'empêche pas de sourire.%SPEECH_ON%L\'Empire se lève.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La guerre est sur nous.",
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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_undead_start"))
		{
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_undead_start");
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

