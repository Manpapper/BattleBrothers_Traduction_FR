this.greenskins_warnings_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_warnings";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 3.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_49.png[/img]Vous sortez de votre tente et voyez un océan de flammes. Ce qui n\'est pas en feu, est noirci par son passage, ce qui n\'est pas mort, crie alors que les flammes mangent leur chair. Au milieu de la fumée de cette ruine défile un flot d\'orcs costauds, des esclaves humains enchaînés traînés à leurs côtés, un essaim de gobelins fourrageant partout pour se délecter du chaos. Et... %randombrother% ? Le mercenaire vous secoue et ce monde brûlant disparaît en un instant. Tout ce qui reste c\'est l\'épée qui se dresse au-dessus de vous.%SPEECH_ON%Désolé de vous réveiller, monsieur, mais votre literie a pris feu à cause de la bougie usée. Je l\'ai éteint avant qu\'il ne puisse faire du mal. Hé, ça va ?%SPEECH_OFF%Acquiesçant, vous dites à l\'homme de dégager et de préparer les autres pour la prochaine marche . Vous essayez de chasser le souvenir du rêve de votre tête, mais il persiste comme s\'il n\'était pas destiné à être oublié. | [img]gfx/ui/events/event_76.png[/img]Un homme surgit de la limite des arbres à côté du chemin. Il porte des haillons et la moitié de sa joue a été ouverte, sa langue rebondit et n\'a aucune force pour émettre plus que des cris gutturaux et des supplications désespérées. %randombrother% recule rapidement alors que l\'homme essaie de continuer sa route. Vous dégainez votre épée, mais l\'étranger se contente de tomber au sol, le dos parsemé de fléchettes, la peau autour des pointes déjà verte de poison.\n\n La compagnie reste vigilante pendant un certain temps, mais rien d\'autre ne vient. Il y a un consensus sur le fait que cela devait être l\'oeuvre de peaux vertes,bien qu\'il semble qu\'il y ait des preuves que les orcs et les gobelins travaillent de concert... | [img]gfx/ui/events/event_97.png[/img]Un jeune homme passe avec son chien trottant à côté de lui. Il s\'arrête devant la compagnie, tapotant la tête de son petit cabot.%SPEECH_ON%Vous êtes des soldats après les verdâtres ? D\'après ce que j\'entends, les grands sont difficiles à tuer, et les petits sont vraiment rusés.%SPEECH_OFF%Vous demandez à l\'homme d\'où il vient. Il hausse les épaules.%SPEECH_ON%Loin, très loin d\'ici. Je suis un vagabond, messieurs, moi et mon chien. Mais j\'en ai vu beaucoup au cours de mes voyages.%SPEECH_OFF%%randomname% fonce vers l\'avant.%SPEECH_ON%Vous me dites que vous avez vu des orcs et des gobelins travailler ensemble ?%SPEECH_OFF%Le garçon acquiesce.%SPEECH_ON %Ouais! Pourquoi ne le feraient-ils pas ? Heh, eh bien, tu n\'es pas celui que je pensais que tu étais. Que vos journées soient longues, vos nuits courtes et vos rêves aussi longs que vous le souhaitez.%SPEECH_OFF%Il traverse des broussailles. Vous poursuivez, mais lorsque vous traverser de l\'autre côté, le garçon et le chien sont tous les deux partis. | [img]gfx/ui/events/event_94.png[/img]Vous avez entendu les mouches avant de voir le chaos. Un petit taudis, des supports en bois de forme simple, un joli toit de chaume, des pots suspendus à des ficelles, un attrape-rêves tournoyant dans le vent, des carillons en bois pour égayer l\'air, et trois corps mutilés dans l\'herbe, un nuage d\'insectes grouillant sur les cadavres. %randombrother% s\'accroupit devant l\'un d\'eux, poussant un os qui sort du corp.%SPEECH_ON%Ça devait être des orcs. Les traces de pas le portent à croire. %SPEECH_OFF%Vous acquiescez, mais remarquez qu\'il y a quelques fléchettes collées à la porte du taudis. Vous en prenez une et la sentez.%SPEECH_ON%Poison. Il n\'y avait pas que des orcs ici.%SPEECH_OFF%%randombrother% renifle l\'une des fléchettes et hoche la tête.%SPEECH_ON%Oui, orcs et gobelins. Ils travaillent ensemble? J\'espère vraiment que non.%SPEECH_OFF%Ce serait un désastre s\'ils l\'étaient, mais pour l\'instant, vous serez heureux de penser que toutes les preuves ici ne sont que des coïncidences. | [img]gfx/ui/events/event_02.png[/img]Vous regardez votre carte puis regardez la scène devant vous.%SPEECH_ON%Un hameau était censé être ici.%SPEECH_OFF%%randombrother% passe devant, avalant une pomme avec un craquement satisfaisant.%SPEECH_ON%Mmhmm, peut-être faut-il quelques modifications alors, monsieur.%SPEECH_OFF%Le village n\'est rien d\'autre que de la cendre. Ses habitants sont suspendus à des poteaux en bois ou à n\'importe quel arbre encore debout. Les ossements de ceux qui n\'ont pas été pendus sont entassés au milieu de ce qui était probablement la place du village. Fixant le sol, vous voyez des empreintes de pas qui s\'éloignent du carnage. Des petites, des grosses. Gobelins, orcs. %brother% secoue la tête.%SPEECH_ON%Ils ne travaillent sûrement pas ensemble, n\'est-ce pas ?%SPEECH_OFF%Vous haussez les épaules et répondez.%SPEECH_ON%Je suis sûr que les orcs sont passés, puis les gobelins sont venus et ont ramassé les restes, ou peut-être l\'inverse.%SPEECH_OFF%Le mercenaire acquiesce, rassuré par votre explication bien que vous sachiez tous les deux profondément que la suite de pistes n\'est probablement pas une coïncidence. | [img]gfx/ui/events/event_97.png[/img]Vous tombez sur un enfant accroupi au bord d\'un ruisseau. Il utilise un bâton pour dessiner des personnages dans la boue - de petits hommes bâtons avec de grands heaumes à cornes et de petits hommes à côté d\'eux, bien que même les plus petits personnages semblent bien armés et en armure. %randombrother% demande à l\'avorton ce qu\'il fait exactement.%SPEECH_ON% D\'ssine les verdâtres. Je les ai vus beaucoup, comme des rats dans un garde-manger ouvert, dit mon père.%SPEECH_OFF%Vous demandez où il habite. Il montre les pentes boisées d\'une colline voisine.%SPEECH_ON%Là-bas. Vous avez une bonne vue de ce qui s\'en vient. Supposons que vous le ferez aussi à temps.%SPEECH_OFF%Un vieil homme crie après l\'enfant et il obéit, laissant tomber ses outils d\'\art atavique et se dirigeant vers la colline.%SPEECH_ON%Je dois travailler. Les gars, amusez-vous ! Et ne marchez pas sur mes dessins ! %SPEECH_OFF%Maintenant, vous réalisez que les figurines sont des orcs et des gobelins, mais peut-être que l\'enfant ne fait que jouer à la fantaisie. | [img]gfx/ui/events/event_36.png[/img]Vous trouvez un type au bord de la route tenant ses bras contre sa poitrine. Les deux mains semblent manquantes.Il vous fixe et l\'élan le porte en arrière, le pauvre homme tombant à plat et fixant le ciel, le piaffe avec des avant-bras noueux.%SPEECH_ON%Ils travaillent ensemble. Tué... Tué tout le monde. Je ne pouvais pas croire à sa vue. J\'ai toujours dit que s\'ils venaient, je serais prêt, pour l\'un ou l\'autre. Mais ils étaient là. Ensemble.%SPEECH_OFF%Vous demandez de qui ou de quoi il parle. La poitrine de l\'homme se contracte, la douleur rampe sur son visage et il rend son dernier souffle. Un ciel se reflète dans l\'éclat de ses yeux ouverts, voyant tout dans l\'aveuglement de la mort. %randombrother% vérifie le corps, mais il n\'y a rien à prendre. | [img]gfx/ui/events/event_95.png[/img]Un totem de crânes, des peaux de cuir battant des poteaux, chaque tête portant une casquette assez macabre de leur propre fabrication. Le sang tache et remplit le sol. Plus d\'os. Muscles et tendons, choses inutilisées ou non consommées. Terre brûlée où un feu de camp a grandi et dispersé des cendres là où il est mort. %randombrother% fait le tour de la scène, à la recherche d\'indices. Il tient le manche d\'une arme rudimentaire et quelques fléchettes trouvées dans un sac en peau de chèvre.%SPEECH_ON%C\'est trop gros pour la main d\'un homme, et ce sont clairement des flèches gobbo à pointe avec, hmm, oui, du poison . Les peaux-vertes sont sans aucun doute passés par ici et ils l\'ont fait en travaillant ensemble.%SPEECH_OFF%En travaillant ensemble ? C\'est une pensée horrible, mais cela semble être vrai. Les tribus sauvages préparent-elles quelque chose ? | [img]gfx/ui/events/event_71.png[/img]Vous arrivez aux restes brûlés d\'un taudis. Il y a des squelettes sur les décombres, des os déchiquetés et saillants dans ce qui était des poses de désespoir définitif et douloureu. Une serrure se trouve dans un tas de cendres à côté de ce qui aurait dû être la porte, suggérant des personnes enfermées à l\'intérieur, tandis que les étrangers ont simplement brûlé l\'endroit.%SPEECH_ON%Monsieur, vous devriez voir ceci.%SPEECH_OFF%%randombrother% vous fait signe. Il se tient devant un arbre. Il y a un gobelin mort appuyé contre le tronc, les paumes ouvertes, vide, un regard laid sur le visage et une fourche dans la poitrine.Un orc mort est à côté de lui avec une tête de pelle sortant de son crâne. %randombrother% se demande s\'ils se sont entre-tués. Vous l\'espérez, mais leurs blessures mortelles ressemblent beaucoup à celles d\'un humain, et s\'il s\'agissait d\'un humain, il est possible que ces Peaux-Vertes travaillaient ensemble. La pensée vous effraie profondément. | [img]gfx/ui/events/event_59.png[/img]Réfugiés sur la route, un flot d\'entre eux, des femmes avec des bébés emmaillotés et encordés dans le dos, des hommes avec des fourches en guise de cannes, des frères déchaussées effectuant des rites religieux dans les airs avec leurs doigts et des prières dans leur souffle. Vous essayez de leur parler, mais ils s\'éloignent de vous, les yeux écarquillés. Enfin, une personne âgée vous parle doucement.%SPEECH_ON%N\'essayez pas, monsieur, ils en ont trop vu. Les Peaux-Vertes... ils sont venus dans la nuit. Des orcs dans le village, des gobelins à l\'extérieur attendant de tendre une embuscade à tous ceux qui couraient. La milice est massacrée. Seuls nous, les lâches, avons survécu, et même alors seuls les plus rapides d\'entre nous.%SPEECH_OFF%Vous demandez à l\'homme s\'il vient de dire que les gobelins et les orcs travaillaient ensemble. Il hoche la tête et vous tapote l\'épaule.%SPEECH_ON%Oui, je l\'ai fait. Bon voyage, étranger.%SPEECH_OFF% | [img]gfx/ui/events/event_76.png[/img]Un homme habillé pour la frime et le plaisir se tient au bord de la route. Il regarde droit devant lui, les mains sur les côtés, peut-être pour équilibrer un peu trop d\'alcool dans le système. Vous attrapez et faites tourner l\'homme. Son visage bascule vers l\'avant, les orbites vidées, les vrilles de sa vue qui pendent sur ses joues comme des écrevisses pourries. Deux bras sans mains vous frappent les épaules alors qu\'il essaie de vous agripper. Son visage se contorsionne en un cri guttural qui reflète les barbaries qu\'il vient de vivre.\n\n %randombrother% passe rapidement à l\'action et abat l\'homme. L\'étranger tombe en arrière, son manteau de vison fin s\'ouvrant pour montrer un corps nu brutalisé, et maintenant vous réalisez que vous préférez voir les parties d\'un homme plutôt que de les voir manquer. Lorsqu\'il touche le sol, ses mutilations sont sa perte, les coupures et les tranches ouvrant sa chair comme un puzzle se détachent.Ses organes éclatèrent par les interstices, se déployant dans des cordes et des sacs violets. L\'homme crie.%SPEECH_ON%Orcs ! Gobelins ! Orcs ! Gobelins ! Orcs ! Gob... gobelins...%SPEECH_OFF%Son souffle le quitte. Il est mort, merci les anciens dieux. Y a-t-il quelque chose à faire de ses derniers mots ?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est préoccupant...",
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
		if (this.World.FactionManager.getGreaterEvilType() == this.Const.World.GreaterEvilType.Greenskins && this.World.FactionManager.getGreaterEvilPhase() == this.Const.World.GreaterEvilPhase.Warning)
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
	}

	function onClear()
	{
	}

});

