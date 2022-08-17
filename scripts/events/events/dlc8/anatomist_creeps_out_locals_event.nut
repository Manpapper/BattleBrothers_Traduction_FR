this.anatomist_creeps_out_locals_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_creeps_out_locals";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Malgré le bruit des villageois environnants et de leur commerce, %anatomiste% ouvre un livre de dissections et commence à en parcourir le contenu. Si un paysan local n\'est pas en mesure de lire les textes, il peut parfaitement voir les images dégoûtantes dessinées sur les pages: Une documentation lugubre sur les corps éventrés, l\'identification de parties du corps que le paysan ne savait même pas qu\'ils existaient, et un certain nombre de symboles ineptes que tout profane utiliserait pour invoquer ses propres démons. Sans surprise, le paysan s\'intéresse au tome de l\'anatomiste.%SPEECH_ON%Alors vous êtes une sorte de sorcier ou quelque chose comme ça?%SPEECH_OFF%En souriant, %anatomist% se retourne et dit que si le paysan pensait que c\'était un tant soit peu vrai, lui aurait-il vraiment demandé? Le paysan se penche en arrière.%SPEECH_ON%Oh, alors vous êtes un malin, hein? Un petit malin avec un livre pour les idiots.%SPEECH_OFF%%anatomist% regarde le paysan se retourner et partir, puis vous regarde avec un large sourire.%SPEECH_ON%Ce paysan avait une curieuse bosse sur la joue. Il sera mort d\'ici un an. Peut-être deux si la mort est trop généreuse avec lui.%SPEECH_OFF% | %anatomist% entreprend de faire une pause de son voyage et de son statut de mercenaire en s\'asseyant sur une pierre et en ouvrant un livre. Après quelques instants de lecture, une petite fille s\'approche, des fleurs à la main. Elle lui en tend une et lui demande ce qu\'il est en train de lire. L\'anatomiste brandit son livre et le tourne. Elle contemple les dessins macabres de bêtes et de monstres éventrés dont les entrailles étranges sont vidées. Après une pause, elle pousse lentement le livre vers le bas pour fixer l\'anatomiste qui le tient. Elle dit.%SPEECH_ON%Je connais une bête que vous pourriez avoir.%SPEECH_OFF%Vous et l\'anatomiste avez une oreille attentive. La petite fille parle tout bas, comme si elle établissait un plan avec ses copains.%SPEECH_ON%Mon petit frère. Il a deux ans, mais je jure qu\'il a abandonné les anciens dieux et qu\'il est habité par le diable.%SPEECH_OFF%L\'anatomiste acquiesce consciencieusement.%SPEECH_ON%Mais bien sûr. Je mettrai dans mes notes de m\'occuper de cette affaire, et si j\'ai le temps, je trouverai l\'immondice dans votre famille.%SPEECH_OFF%La petite fille remercie une fois de plus l\'anatomiste en lui offrant d\'autres fleurs. L\'%anatomiste% tient les fleurs avec délicatesse, les faisant rouler d\'avant en arrière tandis qu\'il retourne à sa lecture, un petit sourire sur le visage. Vous espérez que le sourire est juste un signe qu\'il est amusé par un enfant, et non qu\'il souhaite réellement voir un garçon impie. | Alors que la compagnie fait une pause, un homme se tient sur le côté du chemin, observant avec curiosité. Il fait un signe de tête.%SPEECH_ON%Vous puez tous la mort, mais il est impossible de vous prendre pour les bouchers ou des bourreaux. Non, c\'est autre chose%SPEECH_OFF%Sans perdre un instant, %anatomist% s\'avance et regarde l\'individu lui faisant face. L\'homme se penche, mais ne recule pas. Le regard perdu de l\'anatomiste se termine par un hochement de tête consciencieux.%SPEECH_ON%Vous avez raison, nous dégageons une odeur nauséabonde, tout comme vous. La nôtre est une question de science, la vôtre, une question de maladie. Cela ressemble à la variole. Laissez-moi voir vos pieds.%SPEECH_OFF%Le paysan décline nerveusement la demande. Il recule tandis que l\'anatomiste s\'avance, les doigts aussi agiles qu\'une araignée, les yeux écarquillés. L\'homme finit par crier et s\'enfuit. %anatomist% se retourne en souriant.%SPEECH_ON%Quel curieux sujet, cet homme. Je crois qu\'il était très, très malade, mais il ne le sait pas encore.%SPEECH_OFF% | Vous croisez un chariot à ciel ouvert transportant un cercueil, suivi d\'une suite de personnes en deuil. %anatomist% s\'extrait de la compagnie et s\'enquiert de la mort de l\'individu. Ils ont dit que c\'était dû à une attaque de bête. Curieux, l\'anatomiste demande quelle sorte de bête serait capable de tuer un homme. Les gens se regardent avant d\'ouvrir le cercueil pour révéler un homme ayant une petite égratignure sur la joue. La blessure est, depuis longtemps, devenue d\'un violet sombre avec des veines vertes et d\'autres décolorations inquiétantes, preuve que sa mort est due à un coup. Un des paysans lève les yeux.%SPEECH_ON%C\'est son chat domestique qui a fait ça. Il l\'a griffé juste là et il n\'y a pas prêté attention. La plaie a vite changée de couleur et il est mort au deux nuits.%SPEECH_OFF%L\'anatomiste échange quelques mots avec les personnes en deuil puis revient vers vous. Il soupire.%SPEECH_ON%C\'était une simple plaie. Tout ce qu\'il avait à faire était de nettoyer la coupure. C\'est malheureux, mais je suis heureux que mes connaissances m\'aident à comprendre le monde réel, même s\'il est trop tard pour les appliquer.%SPEECH_OFF%Vous demandez ce qu\'il est advenu du chat. L\'anatomiste acquiesce et dit qu\'il était dans le cercueil avec sa victime. La \"bête\" féline étant caché là, apparemment inconscient de sa destination finale.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Si seulement il était aussi heureux du travail de mercenaire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 4 * anatomistCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

