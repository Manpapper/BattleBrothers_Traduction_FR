this.civilwar_warnings_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_warnings";
		this.m.Title = "Sur le chemin...";
		this.m.Cooldown = 3.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_76.png[/img]Vous croisez un inconnu sur le chemin. Il vous regarde d\'un regard d\'acier, une troupe de moutons et de chiens oisifs à ses côtés.%SPEECH_ON%Mmm, Vous vous préparez à vous battre pour %noblehouse%, n\'est-ce pas ? Je l\'entends et les autres familles du royaume se disputent. Je ne sais pas pourquoi. Sachez juste qu\'ils viendront chez moi et demanderont, \'%randomname%, pourquoi ne viens-tu pas te battre pour nous, sinon on te pendra, et je dirai \'d\'accord\', parce qu\'un noble tas d\'or-cupide ruinant mon année fait partie de la vie, et la vie n\'est tout simplement pas juste.%SPEECH_OFF% | [img]gfx/ui/events/event_91.png[/img]Une femme se tient au bord de la route de la compagnie pendant que vous passez devant. Elle regarde votre emblème de haut en bas.%SPEECH_ON%Hmph, je ne reconnais pas celui-là. Je suppose que les nobles feront bientôt appel à vos services.%SPEECH_OFF%Vous demandez ce qu\'elle veut dire. Elle hausse les épaules.%SPEECH_ON%D\'après ce que j\'entends, les pompeux pissants sont fous d\'un mariage royal qui a mal tourné. Beaucoup de bruit sur la façon dont cela signifie la guerre ou une telle merde. Ces nobles se chamaillent toujours à propos de quelque chose, c\'est une question de temps jusqu\'à ce qu\'ils croisent le fer ou qu\'ils nous demandent, pauvres gens, de le faire pour eux.%SPEECH_OFF% | [img]gfx/ui/events/event_17.png[/img]Un vieil homme assis et fumant une pipe regarde votre compagnie avec un regard vague.%SPEECH_ON%Mercenaires, hein ? Il y aura beaucoup de bon travail pour vous dans les prochains jours.%SPEECH_OFF%Vous demandez ce qu\'il veut dire. Il nettoie sa pipe, la faisant claquer contre ses cuisses.%SPEECH_ON%Ohh, vous savez. Les nobles qui portent des plumes sont de nouveau des paons. La guerre approche, cela ne fait aucun doute - je ne peux pas laisser tout ce beau temps se perdre.%SPEECH_OFF% | [img]gfx/ui/events/event_75.png[/img]Un messager passe par le chemin, sa sacoche se vidant.%SPEECH_ON%Ah, je n\'ai plus de nouvelles, mais j\'ai des rumeurs si ça vous intéresse .%SPEECH_OFF%Vous hochez la tête. Il sourit.%SPEECH_ON%C\'est tout à fait ça. Maintenant, parfois les nobles m\'appellent pour me donner des papiers à envoyer. Parfois, mon petit doigt écoute leurs conversations. Et ce qu\'il entend, c\'est beaucoup de discours sur l\'armée, beaucoup de discours sur \"nous devons les conquérir, ces connards\". Donc, merde, vous devriez vous attendre à de bonnes affaires très bientôt.%SPEECH_OFF% | [img]gfx/ui/events/event_97.png[/img]%SPEECH_ON%Psst. Psst ! Hé !%SPEECH_OFF%Vous vous retournez pour voir un garçon sortir la tête d\'un buisson. Il vous sourit.%SPEECH_ON%Hey, j\'ai quelque chose à dire. Il y a une guerre qui approche.%SPEECH_OFF%Ce petit avorton sournois n\'est pas en haut de votre liste de choses à faire. Vous lui demandez comment il sait cela. Il sourit à nouveau.%SPEECH_ON%Je vais chercher de l\'eau pour un homme qui porte des culottes de soie. Il a dit : « Je peux te donner des bonbons ou te donner à réfléchir. » J\'ai dit, dis-moi quelque chose de bien. Il a dit, \'la noblesse va se battre.\' Alors c\'est ce que je te dis.%SPEECH_OFF%Le gamin fait une pause.%SPEECH_ON%Dites, vous n\'auriez pas de bonbons , voulez-vous? Hé... hé !%SPEECH_OFF%Vous repoussez la tête du gamin dans les buissons. | [img]gfx/ui/events/event_75.png[/img]Un vieil homme et une jeune fille à la peau claire vous rencontrent sur la route. Elle tord une tresse de cheveux sur une épaule, jetant un coup d\'oeil à quelques-uns de vos plus beaux hommes avec des yeux plissés. Avant de passer, elle vous demande si vous allez vous battre pour %noblehouse% ou %noblehouse2%.%SPEECH_ON%Ils disent qu\'un prince s\'est enfui avec une princesse, que c\'était une question d\'amour. N\'est-ce pas rêveur ?%SPEECH_OFF%Vous haussez les épaules. Le vieil homme s\'arrête et crache.%SPEECH_ON%Ne dérange pas les mercenaires avec tes fantasmes, femme. Désolé, mercenaire, elle a ces idées dans la tête et je ne sais pas d\'où. Les maisons parlent de guerre, mais ce n\'est certainement pas à cause d\'un prince caracolant ou d\'un voleur de princesse. L\'économie! C\'est le problème. Les accords commerciaux de longue date s\'effondrent, tout comme le papier sur lequel ils ont été écrits. Laissez-moi vous dire, j\'étais là quand ils...%SPEECH_OFF%Le vieux traîne sa rengaine. Vous avez de loin préféré l\'histoire de la dame, aussi ridicule que cela puisse paraître. | [img]gfx/ui/events/event_75.png[/img]Vous tombez sur un homme assis au sommet d\'un panneau. Il serre les cordes d\'un luth et teste les sons.%SPEECH_ON%Mmhmm, c\'était mieux, n\'êtes-vous pas d\'accord ? Acquiescez simplement.%SPEECH_OFF%Acquiesçant, vous demandez à l\'homme ce qu\'il fait. Il saute du panneau et atterrit bras et jambes comme un bouffon à la fin de son numéro.%SPEECH_ON%Entraînement ! La guerre arrive, j\'ai moi-même entendu parler des rumeurs, et avec la guerre vient un besoin de... de... de... allez, tu peux le faire, du divertissement ! C\'est vrai! Et tout appel pour les plaisirs nocturnes est un appel pour moi - et à plus d\'un titre, laissez-moi vous le dire.%SPEECH_OFF%Il pirouette et sourit. Vous n\'avez jamais vu un homme avec un sourire plus blanc et vous avez une forte envie de le noircir chèrement. Le ménestrel caracole sur le chemin.%SPEECH_ON%Ne vous inquiétez pas, mercenaire, avec les nobles qui se battent entre eux, il ne manquera jamais de travail pour les hommes de vos, euh, talents. B\'jour !%SPEECH_OFF% | [img]gfx/ui/events/event_16.png[/img]De plus en plus, vous croisez des paysans et des marchands murmurant sur une guerre entre les maisons nobles. Votre esprit en tant que mercenaire vous demande de quel côté vous envisagez de porter votre bannière. Si ces rumeurs sont vraies, alors %companyname% est susceptible de faire beaucoup d\'argent sur la misère causée entre les pompeux bien-nés. | [img]gfx/ui/events/event_45.png[/img]Vous croisez plusieurs joueurs sur la route. Ils ont placé des petits drapeaux représentant toutes les familles nobles du pays. Le bookmaker prend des notes et regarde son parchemin.%SPEECH_ON%Maintenant, rappelez-vous, les résultats de cette guerre entre maisons ne seront pas évidents avant un certain temps. Enfer, la plupart d\'entre vous seront conscrits. Mais tous ceux qui survivront me reviendront dans un an. À partir de là, nous verserons l\'argent à ceux qui parieront sur la maison noble gagnante. Marché conclu ?%SPEECH_OFF%Les paysans au visage tordu et à la mâchoire béante haussent les épaules.%SPEECH_ON%Cela me semble être un marché !%SPEECH_OFF%Le bookmaker sourit, une incisive dorée scintillant très légèrement.%SPEECH_ON%Génial !%SPEECH_OFF%Il prend les paris dans une sacoche et des provisions pour la route, très probablement pour ne plus jamais revenir. Vraiment dommage dans quel genre d\'absurdité les gueux s\'embarquent. | [img]gfx/ui/events/event_75.png[/img]Au cours de vos voyages, vous entendez sans cesse une rumeur particulièrement intéressante : les maisons nobles se positionnent pour la guerre.Si c\'est vrai, %companyname% pourrait gagner beaucoup d\'argent, en particulier si vous choisissez un côté gagnant. | [img]gfx/ui/events/event_23.png[/img]Paysan après paysan, ils racontent la même histoire ces derniers temps. En fait, ils semblent le répéter chaque fois que vous les rencontrez...\n\n Guerre. La guerre est sur leurs lèvres. Les maisons nobles se chamaillent sur quelque chose dont vous ne vous souciez point, mais ce que cela signifie, c\'est la guerre, et guerre veut dire des couronnes pour une épée à louer, et les couronnes sont bonnes, donc la guerre est bonne. Si ces rumeurs sont vraies, %companyname% devrait soigneusement évaluer ses options et choisir une maison noble à soutenir dans le conflit à venir. | [img]gfx/ui/events/event_80.png[/img]Vous avez remarqué que des recruteurs pour les maisons nobles sont en marche, retirant de jeunes hommes frais de leurs maisons. La conscription n\'est pas inhabituelle, mais généralement, vous avez toujours besoin des gars pour cultiver les champs. Si les nobles laissent cela aux femmes, cela signifie que quelque chose d\'autre et d\'une plus grande importance, sans aucun doute une guerre qui se prépare. %companyname% devrait se préparer au pire - enfin, au pire pour tout le monde. Une guerre entre riches connards est le meilleur moment pour être un mercenaire !}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est bon à savoir.",
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
		if (this.World.FactionManager.getGreaterEvilType() == this.Const.World.GreaterEvilType.CivilWar && this.World.FactionManager.getGreaterEvilPhase() == this.Const.World.GreaterEvilPhase.Warning)
		{
			local playerTile = this.World.State.getPlayer().getTile();

			if (!playerTile.HasRoad)
			{
				return;
			}

			if (this.Const.DLC.Desert && playerTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
			{
				return;
			}

			local towns = this.World.EntityManager.getSettlements();

			foreach( t in towns )
			{
				if (t.isSouthern())
				{
					continue;
				}

				if (t.getTile().getDistanceTo(playerTile) <= 4)
				{
					return;
				}
			}

			this.m.Score = 80;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"noblehouse",
			nobles[0].getName()
		]);
		_vars.push([
			"noblehouse1",
			nobles[0].getName()
		]);
		_vars.push([
			"noblehouse2",
			nobles[1].getName()
		]);
	}

	function onClear()
	{
	}

});

