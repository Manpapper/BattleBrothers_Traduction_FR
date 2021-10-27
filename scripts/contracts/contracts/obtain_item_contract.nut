this.obtain_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		RiskItem = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.obtain_item";
		this.m.Name = "Obtention d'Artefact";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", camp.getName());
		local items = [
			"Doigt osseux de Sir Gerhardt",
			"Fiole de Sang de la Sainte Mère",
			"Linceul du Fondateur",
			"Pierre de Sureau",
			"Bâton de la Prévoyance",
			"Sceau du soleil",
			"Disque de la Carte Stellaire",
			"Parchemin des Ancêtres",
			"Almanach Pétrifié",
			"Armoiries de Sir Istvan",
			"Bâton des Moissons d'Or",
			"Brochures du Prophète",
			"Ecrit des Anciens",
			"Sceau du Faux Roi",
			"Flûte du Débauché",
			"Dés de la destinée",
			"Fétiche de la Fertilité"
		];
		local lesitems = [
			"Le Doigt osseux de Sir Gerhardt",
			"La Fiole de Sang de la Sainte Mère",
			"Le Linceul du Fondateur",
			"La Pierre de Sureau",
			"Le Bâton de la Prévoyance",
			"Le Sceau du soleil",
			"Le Disque de la Carte Stellaire",
			"Le Parchemin des Ancêtres",
			"L'Almanach Pétrifié",
			"Les Armoiries de Sir Istvan",
			"Le Bâton des Moissons d'Or",
			"Les Brochures du Prophète",
			"Les Ecrits des Anciens",
			"Le Sceau du Faux Roi",
			"La Flûte du Débauché",
			"Les Dés de la destinée",
			"Le Fétiche de la Fertilité"
		];
		this.m.Flags.set("ItemName", items[this.Math.rand(0, items.len() - 1)]);
		this.m.Flags.set("LeItemName", items[this.Math.rand(0, items.len() - 1)]);
		this.m.Payment.Pool = 500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Obtenez %leItem% à %location%"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				this.Contract.m.Destination.clearTroops();
				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.Contract.m.Destination.m.IsShowingDefenders = false;
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsRiskReward", true);
					local i = this.Math.rand(1, 6);
					local item;

					if (i == 1)
					{
						item = this.new("scripts/items/weapons/ancient/ancient_sword");
					}
					else if (i == 2)
					{
						item = this.new("scripts/items/weapons/ancient/bladed_pike");
					}
					else if (i == 3)
					{
						item = this.new("scripts/items/weapons/ancient/crypt_cleaver");
					}
					else if (i == 4)
					{
						item = this.new("scripts/items/weapons/ancient/khopesh");
					}
					else if (i == 5)
					{
						item = this.new("scripts/items/weapons/ancient/rhomphaia");
					}
					else if (i == 6)
					{
						item = this.new("scripts/items/weapons/ancient/warscythe");
					}

					this.Contract.m.RiskItem = item;
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Obtenez %leItem% à %location% %direction% de %origin%"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.m.IsShowingDefenders = false;
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsRiskReward"))
					{
						this.Contract.setState("Return");
					}
					else
					{
						this.Contract.setScreen("LocationDestroyed");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.TempFlags.get("GotTheItem"))
				{
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsRiskReward"))
					{
						this.Contract.setScreen("RiskReward");
					}
					else
					{
						this.Contract.setScreen("SearchingTheLocation");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
					this.World.Contracts.startScriptedCombat(properties, _isPlayerAttacking, true, true);
				}
			}

			function end()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.Contract.m.Destination.isAlive())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
					this.Contract.m.Destination = null;
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsFailure"))
					{
						this.Contract.setScreen("Failure1");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negotiations",
			Text = "{[img]gfx/ui/events/event_43.png[/img]%employer% vous accueille et vous accompagne vers la place de %townname%. Il y a un groupe de paysans qui s'agite, mais quand ils vous voient arriver, ils se mettent en rang et commencent à parler comme s'ils vous attendaient depuis le début. Ils parlent surtout en termes descriptifs : grand comme un homme ! Des armures comme vous n'en avez jamais vues auparavant ! Des lances aussi tranchantes que la langue d'un colporteur ! Vous levez la main et demandez de quoi ils parlent. %employer% rigole.%SPEECH_ON%Les hommes d'ici disent qu'ils ont vu des choses bizarres dans un endroit appelé %location%, juste %direction% d'ici. Naturellement, ils n'étaient pas là sans raison. Ils cherchaient quelque chose du nom de %item%, une relique précieuse pour la ville car c'est à travers elle que nous prions pour avoir de la nourriture et un abri.%SPEECH_OFF%Un des paysans prend la parole.%SPEECH_ON%Et nous l'avons cherché à sa demande !%SPEECH_OFF%%employer% hoche la tête.%SPEECH_ON%Bien sûr. Et là où ils ont échoué, peut-être pouvez-vous réussir ? Trouvez-moi cette relique et vous serez bien payé pour vos services. Ne faites pas attention à leurs contes de fées. Je suis sûr qu'il n'y a rien à craindre.%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]%employer% vous accueille dans sa chambre et vous verse une tasse d'eau. Il vous la tend avec un sourire penaud.%SPEECH_ON%Je vous proposerais bien un peu de bière ou de vin si j'en avais sur moi, mais vous savez comment sont les choses de nos jours.%SPEECH_OFF%Il prend une gorgée et se racle la gorge.%SPEECH_ON%Bien sûr, ce dont je ne manque pas, c'est de couronnes, sinon nous n'aurions pas cette conversation, non ? J'ai besoin que vous alliez à un endroit appelé %location% %direction% d'ici et que vous récupériez une relique appelée %leItem%. Plutôt simple, non ?%SPEECH_OFF%Vous demandez à quoi sert cette relique. L'homme explique.%SPEECH_ON%Les habitants de la ville le prient. Grâce à elle, ils trouvent la paix, appellent les pluies, baisent leurs chèvres, je m'en fiche. Ils y croient et ça les motive. Rien que pour ça, ça vaut la peine de le récupérer.%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]Vous entrez dans la chambre de %employer% et trouvez l'homme fixant une carte de l'arrière-pays. Il secoue la tête.%SPEECH_ON%Vous voyez cet endroit juste là ? C'est %location%. %townname% vénérait une relique du nom de %item%, mais les habitants disent qu'elle a disparu et, pour une raison quelconque, ils pensent qu'elle est là. Je n'ai pas d'hommes à engager pour aller voir, car les routes sont dangereuses et je ne peux pas me permettre de payer pour un échec, mais vous, mercenaire, semblez être à la hauteur de la tâche. Pourriez-vous aller là-bas et trouver cet objet pour nous ?%SPEECH_OFF% | [img]gfx/ui/events/event_43.png[/img]Vous trouvez %employer% qui parle à un groupe de paysans. En vous voyant, il les fait taire.%SPEECH_ON% Silence, vous tous. Cet homme là peut résoudre notre problème.%SPEECH_OFF% Le paysan vous prend à part.%SPEECH_ON%Mercenaire, nous avons un petit problème. Il y a une relique que je dois trouver, une chose du nom de %item%. Je m'en fous un peu, mais ces gens la vénèrent pour les pluies de printemps et les abris d'hiver. Naturellement, il a disparu. Et pour une raison quelconque, les gens pensent qu'il est parti tout seul dans un endroit appelé %location%. Personne n'ira là-bas, mais vous le ferez, non ? Pour le bon prix, bien sûr.%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]Vous trouvez %employer% en train de parler à un moine druidique vêtu de formes plus familières aux bêtes qu'aux hommes. Des cornes en guise de casque, une peau d'ours en guise d'armure, et des sabots de cerf s'entrechoquant autour de sa poitrine en un collier brutal. C'est un sacré spectacle. En vous voyant, %employer% vous fait signe d'entrer.%SPEECH_ON%Mercenaire ! C'est bon de vous voir...%SPEECH_OFF%Le druide pousse l'homme hors de son chemin à mi-parcours. Il parle avec un flottement dans la voix, comme s'il parlait depuis les profondeurs d'une caverne.%SPEECH_ON%Un mercenaire, ha ! Vous êtes sûrement un homme de foi, non ? Nous, de %townname%, avons perdu %leItem%. Cette relique est d'une grande importance pour nous, car elle nous permet de parler aux anciens dieux et d'obtenir des réponses à nos prières. Il a été volé, d'une manière ou d'une autre, à %location%. Allez-y et récupérez-la.%SPEECH_OFF%Vous jetez un coup d'œil à %employer% qui acquiesce.%SPEECH_ON%Oui, ce qu'il a dit.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Vous avez bien fait de venir nous voir. Parlons paiement. | Parlons argent. | Ça semble assez simple. Quel est le salaire ?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas intéressé. | Nous avons d\'autres importants problèmes à régler. | Je suis sûr que vous trouverez quelqu\'un d\'autre pour faire ça.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "SearchingTheLocation",
			Title = "À %location%",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Vous n'entrez pas dans les ruines, vous grimpez plutôt, boitillant sur les pierres comme une chauve-souris essayant de marcher debout. Arrivé au bas de la pente, vous trouvez ce qui ressemble à des centaines de pots en argile, de vieux chariots plus en copeaux qu'en bois, et des bassins d'eau en métal remplis de boucliers et de lances rouillés. %randombrother% prend une torche et jette sa lueur vers les murs. De grandes peintures murales les longent, de grandes œuvres d'art dépeignant des batailles dont vous n'avez jamais entendu parler. Chaque pas que vous faites semble dévoiler une autre victoire ancienne jusqu'à ce que, finalement, vous arriviez à une carte géante peinte. Là, vous voyez un continent envahi par la domination d'un empire, qui a doré son ventre, noirci ses frontières...\n\n Le %randombrother% s'approche, avec %leItem% en main. Vous acquiescez et lui dites qu'il est temps de partir. Lorsque vous vous retournez tous les deux, il y a un homme debout, une lance dans une main et un bouclier dans l'autre. Une autre silhouette le rejoint, puis une autre, leurs pas frappant le sol de pierre avec une malice métallique. Vous criez au mercenaire de courir et vous abandonnez tous les deux les ruines en vitesse, le claquement d'une marche de la mort sur vos talons.\n\n Dehors, vous vous retournez et ordonnez aux hommes de se préparer à se battre. Avant même que le premier mercenaire ait pu dégainer son épée, un flot de soldats en armure émerge des ruines, s'empile et pointe leurs lances vers vous. Leur lieutenant pointe un doigt pourri et parle d'une voix si grave que les mots pèsent au fond de votre poitrine.%SPEECH_ON%L'Empire se lève. Le Faux Roi doit mourir.%SPEECH_OFF% | Le trou dans les ruines est assez grand pour qu'un seul homme puisse y passer. Vous avez peur que si tout le monde y va en même temps, ils restent coincés et que vous ayez tué %companyname% comme une bande de rats dans un tunnel étroit. Au lieu de cela, vous n'envoyez que %randombrother%, qui sait ce qu'il cherche et qui, vous en êtes sûr qu'il peut se débrouiller tout seul si quelque chose devait arriver.\n\n Quelques minutes plus tard, vous entendez l'homme se débattre pour sortir en rampant - et il semble être très pressé. Il crie à l'aide et vous et quelques autres mercenaires mettez vos mains dans le trou. Il s'accroche et, ensemble, vous le sortez du trou. Il a %leItem%, mais un regard horrifié sur son visage. Il se retourne et se relève précipitamment.%SPEECH_ON%Vite ! Aux armes !%SPEECH_OFF%Pendant que les mercenaires regardent dans le trou pour voir si quelque chose en sort, vous demandez au confrère ce qu'il a vu. Il secoue la tête.%SPEECH_ON%Je ne sais pas, monsieur. C'était un mausolée pour des gens que je n'avais jamais vus avant. Il y avait des armures et des lances partout, et des peintures murales d'un grand empire qui s'étendait sur le monde entier ! Peint du sol au plafond ! Et... et ensuite ils ont commencé à sortir des murs. Je suis sorti de là aussi vite que j'ai pu et...%SPEECH_OFF%Avant même qu'il ne puisse terminer, les décombres où se trouvait le trou commencent à se déplacer. Les pierres roulent et soudain elles éclatent toutes vers l'extérieur, une force malveillante se tenant là - des hommes armés et bien protégés se tenant en formation, les lances sur les boucliers, avançant à pas réguliers. Leur chef pointe directement vers vous.%SPEECH_ON%L'Empire se lève. Le Faux Roi doit mourir.%SPEECH_OFF%Vous n'avez jamais entendu de mots de combat si décidé et préparez immédiatement vos hommes au combat. | Vous vous aventurez dans les ruines avec %randombrother% à vos côtés. %leItem% est assez facile à trouver, si ce n'est un peu trop facile, mais quelque chose d'autre attire votre attention. Il y a des pots éparpillés sur le sol en pierre. Chaque pièce de poterie est un réservoir pour des lances, et des boucliers sont accrochés aux murs sur des crochets qui semblent bien trop anciens et rouillés pour supporter une toile d'araignée et encore moins une pièce de métal. Soudain, %randombrother% vous attrape le bras.%SPEECH_ON%Chef. Des problèmes.%SPEECH_OFF%Il vous montre du doigt les couloirs et vous voyez un homme qui se tient là, ses mouvements sont saccadés et rapides, comme s'il était en train d'enfiler son armure. Soudain, sa tête se lève et vous regarde fixement. Malgré le fait qu'il se tienne si loin, sa voix porte comme s'il parlait juste à côté de vous.%SPEECH_ON%Le Faux Roi ose s'introduire ici ? L'Empire se relèvera, mais vous devez d'abord mourir.%SPEECH_OFF%Ce sont des mots de combat, sans aucun doute, et vous attrapez le mercenaire et vous vous échappez rapidement. Vous n'êtes pas loin avant que les mercenaires ne prennent les armes sans que vous l'ayez ordonné : derrière vous se trouve une formation de soldats en armure que vous n'avez jamais vue auparavant. Ils s'avancent dans une formation ressemblant à une carapace de tortue, serrés les uns contre les autres avec leurs boucliers levés pour protéger l'ensemble de l'unité. D'après ce que vous avez vu dans les ruines, vous ne doutez pas qu'ils sont venus pour vous tuer, vous et le reste de la compagnie ! | Vous entrez dans les ruines et trouvez %leItem% assez facilement. Quand vous vous retournez, un grand homme en armure rustique se tient là, une lance à la main, les orbites vides vous regardant de haut. Il brandit sa lance.%SPEECH_ON%Le Faux Roi doit mourir.%SPEECH_OFF%La lance s'avance. Le %randombrother% bondit et la dévie vers le sol, la pointe de la lance faisant crépiter quelques étincelles sur le sol en pierre. Vous regardez l'homme mort-vivant, un ver qui coule dans son nez. Il parle à nouveau.%SPEECH_ON%Le Faux Roi doit...%SPEECH_OFF%D'un geste rapide, vous dégainez votre épée et coupez la tête de l'ancien mort. Le crâne et le casque qui le porte s'entrechoquent et claquent sur le sol. Avant que vous ne puissiez enquêter, %randombrother% vous attrape et vous dit de courir : d'autres morts-vivants surgissent des murs, se libérant de l'emprise de leur tombeau.\n\n Une fois dehors, vous ordonnez au reste de la compagnie de se mettre en formation. | Vous envoyez quelques hommes dans les ruines pour trouver %leItem%. Ils reviennent tous en vitesse, ce qui est inhabituel car ils ont une forte propension à lambiner et gagner un salaire facile . Heureusement, l'un d'entre eux a la relique en main. Malheureusement, ils ont tous l'air d'avoir vu un fantôme. Ils n'ont pas besoin d'expliquer la source de leur horreur lorsqu'un groupe de morts-vivants rampants et en armure émergent des ruines et pointent leurs lances sur votre compagnie. | En arrivant aux ruines, vous vous attendiez à voir des bandits dans les parages. Au lieu de cela, récupérer %leItem% n'aurait pas pu être plus facile. Du moins, c'est ce que vous pensiez avant qu'une foule de morts-vivants en armure n'émerge en hurlant des choses au sujet d'un \"Faux Roi\" et en demandant votre tête sur un plateau. Aux armes ! | Trouver et récupérer %leItem% était plus facile que prévu. Trouver un groupe de morts-vivants portant des armures rustiques et brandissant des lances dans une formation militaire plus serrée que l'armée la mieux payée du royaume... pas si facile. Aux armes !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux Armes",
					function getResult()
					{
						this.TempFlags.set("GotTheItem", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "LocationDestroyed",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{La bataille terminée, et avec %leItem% entre vos mains, vous dites aux hommes de se préparer pour retourner voir %employer%. Vous ne savez pas exactement qui ou quoi vient de vous attaquer, mais pour l'instant, il est temps d'être payé. | Avec la fin du combat, vous regardez vos attaquants. Ils ont été enveloppés dans une armure que vous ne reconnaissez pas. %randombrother% essaie de faire sortir un des corps de son casque, mais en vain. Il regarde le corps avec incrédulité.%SPEECH_ON%C'est comme si c'était coincé là, ou une partie de lui ou quelque chose comme ça.%SPEECH_OFF%Vous dites aux hommes de s'équiper et de se préparer pour retournez voir %employer%. Peu importe qui sont ces hommes, vous êtes là pour récupérer l'objet et cette partie est terminée. Maintenant, il est temps d'être payé. | Vous avez obtenu %leItem%, mais au prix d'une confrontation avec un mal que vous n'avez jamais vu auparavant. Des hommes blindés, apparemment morts, mais opérant en formations serrées. %randombrother% montre %leItem% et demande ce qu'il faut faire ensuite. Vous informez les hommes qu'il est temps de retourner voir %employer%. | Vous regardez %leItem% et les hommes qui vous ont attaqué pour ça. Ou, du moins, vous pensez qu'ils vous ont attaqué pour ça. Le lieutenant ennemi semble avoir dit quelque chose, mais vous ne vous souvenez pas de ce que c'était. Hé bien, il est temps de retourner voir %employer% et d'être payé. | Vous n'êtes pas tout à fait sûr de ce que vous avez rencontré. %randombrother% vous demande si vous savez ce qu'ils ont dit.%SPEECH_ON%On dirait qu'ils vous désignaient spécifiquement, boss.%SPEECH_OFF%En hochant la tête, vous dites à l'homme que vous n'êtes pas sûr de ce que l'homme blindé a dit, mais cela n'a pas d'importance. Vous avez %leItem% et il est temps de retourner voir %employer% pour votre salaire. | %leItem% est en main, mais à quel prix ? Des hommes étranges, si on peut les appeler ainsi, ont attaqué la compagnie et vous jurez que l'un d'eux vous a spécifiquement désigné, comme si vous aviez commis un crime au-delà de l'espace et du temps. Mais bon. Vous n'êtes pas du genre à vous attarder sur ces choses. Ce que vous cherchez ici, c'est la relique, que vous avez, et un bon salaire qui vous attend chez %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retournons rentre l'objet.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RiskReward",
			Title = "À %location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Vous entrez dans %location% et regardez bien autour de vous. Ce n'est que peu de temps après que %randombrother% vous indique l'objet, la relique assise sur un podium en pierre couvert de mousse et de toiles d'araignées. Il montre également quelque chose d'autre assis à l'autre bout de la pièce : un très beau %risk% orné au corps d'une statue.\n\nLe reste de l'endroit est délabré et semble prêt à s'effondrer juste au-dessus de vos têtes. Ce que %risk% fait là est définitivement discutable. | %leItem% est parfaitement visible, mais il y a autre chose dans la pièce qui retient l'attention. Assis à côté d'une énorme statue, il y a un %risk% très particulier. Bien sûr, on peut se demander ce qu'il fait là, bon sang ! Bien que vous pensiez que vous devriez aller l'attraper, quelque chose vous dit que ce n'est peut-être pas la plus sage des décisions. | Eh bien, vous avez trouvé %leItem%. C'était beaucoup plus facile que vous ne l'imaginiez. Mais il y a autre chose ici, aussi. Vous repérez un %risk% étincelant orné sur une grande statue d'un homme au visage vide. Vous ne savez pas trop ce que fait une statue avec un tel objet, mais il est là. Et il semble avoir toujours été là, ce qui soulève la question : pourquoi ? | %leItem% était facile à trouver, mais alors que vous vous apprêtez à aller chercher la relique des villageois, vous apercevez un %risk% brillant qui orne la statue d'un homme grand et inquiétant. Votre première pensée est d'envoyer un mercenaire pour s'en emparer, mais vous vous demandez ensuite ce qu'il peut bien faire là.} Peut-être que %companyname% devrait s'en tenir à ce qu'il a été chargé de faire ?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prendre juste %leItem%.",
					function getResult()
					{
						return "TakeJustItem";
					}

				},
				{
					Text = "On pourrait aussi bien prendre ce %risk% vu qu'on est là.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "TakeRiskItemBad";
						}
						else
						{
							return "TakeRiskItemGood";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakeJustItem",
			Title = "À %location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]%employer% vous a juste demandé de récupérer %leItem% et c'est exactement ce que vous allez faire. {%randombrother% est d'accord avec cette approche.%SPEECH_ON%Je pense que nous devrions laisser %risk% bien tranquille. Je n'ai jamais vu une preuve plus claire d'un piège que celui-là.%SPEECH_OFF% | Secouant la tête, %randombrother% se moque de votre hésitation.%SPEECH_ON%Tu as peur de cette grosse statue, hein ? J'aurais pensé que vous auriez eu plus de cran que ça, capitaine.%SPEECH_OFF% | Après avoir pris la relique, %randombrother% vous donne un coup de coude sur le côté.%SPEECH_ON%Quelqu'un a peur de la grande méchante statue, hein ? Allez, laisse-moi l'attraper. On peut l'avoir et être dehors en deux secondes !%SPEECH_OFF%Vous rappelez gentiment au mercenaire qui est le responsable, de peur qu'il ne recommence à faire \"des blagues\". | La relique déjà dans votre main, %randombrother% acquiesce simplement.%SPEECH_ON%C'est bien, monsieur. Je dis qu'il faut laisser %risk% bien tranquille. Cette babiole brillante n'est rien d'autre que des ennuis. S'y attaquer reviendrait à courir après une belle femme au milieu de l'océan !%SPEECH_OFF% | %randombrother% jette un regard à %risk% et crache, se raclant la gorge et passant une main sur son visage ébouriffé.%SPEECH_ON%Ouais. Laissons ça tranquille. Si je devais trouver un tas d'or au milieu d'une forêt, je pense que j'y réfléchirais à deux fois avant de m'y précipiter. Même principe ici.%SPEECH_OFF% | %randombrother% est d'accord avec votre décision.%SPEECH_ON%Oui, laissons %risk% tranquille. Rien n'est gratuit dans ce monde, rien. Et certainement rien avec ce genre d'éclat. Non, monsieur.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "C'était assez facile.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TakeRiskItemGood",
			Title = "À %location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Avec %leItem% en main, vous vous dites que vous pourriez aussi bien prendre %risk%. %randombrother% s'y met, libérant soigneusement la statue de la pièce. Une fois que le métal s'est dégagé, l'homme s'arrête, prêt à se faire démolir si la statue s'anime. Au lieu de cela, rien ne se passe. Il rit nerveusement. %SPEECH_ON%Un jeu d'enfant !%SPEECH_OFF%Alors que le soulagement gagne les hommes, vous leur dites de se préparer pour retournez voir %employer%. | En prenant %leItem%, vous regardez %risk% et vous vous dites pourquoi pas. Vous grimpez sur la statue et regardez fixement le visage de l'homme dont elle a pris l'image. Qui que ce soit, il avait des pommettes ciselées et une mâchoire à faire tomber un manteau. En regardant au-delà de ses traits, vous prenez %risk% et le serrez dans vos mains, attendant que quelque chose se passe. Rien ne se passe. %randombrother% rit.%SPEECH_ON%Vous allez dire à cette statue \"Au revoir\" ou non ?%SPEECH_OFF%Vous tapotez la statue sur la tête et descendez. La compagnie devrait retourner voir %employer% maintenant.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "C'était assez facile.",
					function getResult()
					{
						this.Contract.m.RiskItem = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.getStash().add(this.Contract.m.RiskItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.RiskItem.getIcon(),
					text = "Vous recevez " + this.Contract.m.RiskItem.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "TakeRiskItemBad",
			Title = "À %location%",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Vous envoyez %randombrother% en haut de la statue pour récupérer %risk%. Pendant qu'il est là-haut, vous remarquez que la babiole perdue de %employer%% vacille sur le podium. Vous tendez la main dans l'espoir de la stabiliser, mais au lieu de se redresser, elle s'envole entre vos doigts comme de la poussière. Les restes poudreux s'écoulent autour de votre bras comme un serpent fait de brouillard. Vous vous éloignez d'un bond et la fumée se dirige vers la statue, s'enfonçant dans les yeux qui deviennent d'un rouge vif. La pierre se fissure et s'effrite. Le mercenaire saute. Tout autour d'elle, des formes émergent des murs, des statues se brisent pour donner naissance à des hommes à l'allure étrange, vêtus d'armures et portant des lances sur leurs dos.\n\n Vous ordonnez à tout le monde de se préparer au combat ! | Il n'y a pas moyen de refuser quelque chose comme %risk%. Vous grimpez sur le visage de la statue et tendez la main pour l'attraper, mais à la seconde où un morceau de métal touche votre doigt, il y a un grondement et la statue se met à trembler. %randombrother% crie et vous vous retournez. Il pointe du doigt %leItem% qui est en train de se dissoudre sous vos yeux ! Il se transforme en poudre et vous ne pouvez que regarder le nuage de poudre, comme un brouillard qui prend vie, tourbillonner autour de la pièce et passer devant votre visage pour remonter le long du nez de la statue. Ses yeux sont rouges et vous vous éloignez immédiatement. Un mercenaire arrive à vos côtés, son arme déjà sortie.%SPEECH_ON%Capitaine, Capitaine! Regardez !%SPEECH_OFF%Il y a des formes qui émergent des murs ! Des statues qui s'avancent comme des marionnettes à des fils qui pendent des doigts d'un vieil homme. Lentement, chacune se débarrasse de sa carapace de pierre et émerge sous la forme d'un homme à l'allure étrange, en armure et armé d'une lance. Vous ordonnez rapidement à vos hommes de se mettre en formation de combat car ce que vous avez libéré ici ne va pas être amical !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rassemblement !",
					function getResult()
					{
						this.Contract.m.RiskItem = null;
						this.Flags.set("IsFailure", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.getStash().add(this.Contract.m.RiskItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.RiskItem.getIcon(),
					text = "Vous recevez " + this.Contract.m.RiskItem.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% vient à votre rencontre sur la place du village. Vous lui remettez %leItem% et l'homme le berce comme s'il s'agissait d'un enfant qu'il croyait perdu. Après un moment d'étreinte maladroite avec la relique, il la brandit bien haut pour que les habitants de la ville la voient. Ils applaudissent pendant un moment. Trop longtemps, vraiment. Vous devez insister lourdement pour que %employer% revienne à lui pour lui rappeler de vous payer. | Vous trouvez %employer% en train de fouiller dans une porcherie. Il donne des coups de pied aux grosses truies, bien qu'elles semblent plus concentrées sur la nourriture que sur le tapotement de l'orteil en cuir sur leur cul. Vous vous raclez bruyamment la gorge. %employer% se retourne et ses yeux s'écarquillent immédiatement à la vue de la relique. Il saute par-dessus un cochon et prend %leItem%. Il crie aux habitants du village qui se rassemblent et prient les dieux pour leur pitié. Pas un seul ne vous remercie, bien sûr. Vous devez rappeler à %employer% les couronnes qu'il vous doit. Il vous paye et vous partez aussi vite que possible. | Vous trouvez %employer% assis sur la place de la ville, les bras levés vers le ciel, les yeux fermés, la bouche murmurant des prières. Les habitants de la ville sont tous autour de lui, agenouillés et faisant de même. Vous ramassez une pierre et la lancez sur une girouette, le cliquetis et les rotations rustiques attirant l'attention de tous.\n\nVous tenez la relique en l'air pour que tout le monde puisse la voir. %employer% se lève d'un bond et prend %leItem%. Le peuple hurle de joie, annonçant les bonnes choses à venir. On vous remet votre paiement, ce qui, en vérité, est ce que vous considérerez comme une \"bonne chose\".}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Les habitants de la ville semblent être dans un bon esprit maintenant.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "A obtenu " + this.Flags.get("LeItemName"));
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				local reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + reward + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/high_spirits_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Les habitants de %townname% attendent votre retour avec impatience. Dommage, car vous n'avez pas la relique dont ils ont tant besoin. %employer%, voyant votre échec en avance par rapport aux habitants, vous rencontre à l'entrée de la ville et vous parle à voix basse.%SPEECH_ON%Je suppose que vous n'avez pas %leItem%.%SPEECH_OFF%Vous essayez d'expliquer tout ce qui s'est passé, mais il ne semble pas écouter.%SPEECH_ON%Ce n'est pas grave, mercenaire. Je ne peux pas vous payer, évidemment, et les habitants de la ville ne doivent pas entendre parler de votre échec de peur qu'ils ne perdent la tête. Ils dépendent des idoles pour trouver du réconfort dans ce monde. Je vais devoir trouver ma propre solution et, eh bien, prier pour qu'elle fonctionne. Bonne journée à vous.%SPEECH_OFF% | %employer% vous rencontre à côté d'une foule d'oies. Il les nourrit à outrance tandis que, de manière tout à fait désinvolte, un garçon passe de temps en temps et prend simplement l'un des oiseaux pour aller l'abattre. L'homme vous sourit chaleureusement, mais son enthousiasme retombe rapidement.%SPEECH_ON%Je ne vois pas la relique. Ai-je raison de croire que vous ne l'avez pas ?%SPEECH_OFF%Un simple hochement de tête est tout ce que vous donnez comme réponse. Il ouvre les bras, un peu confus.%SPEECH_ON%Alors pourquoi êtes-vous venu ? Les habitants de la ville vous connaissent. Ils savent que vous étiez dehors à la chercher. Vous devriez partir avant qu'ils ne vous voient revenir sans leur idole divine.%SPEECH_OFF% | Vous retournez voir %employer% les mains vides. Il vous prend par le côté et vous murmure.%SPEECH_ON%Et pourquoi êtes-vous venu ? Ne comprenez-vous pas l'importance que ces villageois accordent à l'idole ? Sans elle à vénérer, ils n'ont rien en quoi croire. Les hommes à la foi forte ont besoin d'un endroit où la mettre. S'ils ne peuvent pas le trouver, tout ce qu'ils trouvent, c'est eux-mêmes. Et, comme une brute laide qui se regarde dans un miroir, nous ne devons pas nous précipiter pour voir la colère et la confusion dans le reflet de l'absence de l'idole. Partez, mercenaire, avant que les gens ne voient que vous n'êtes pas revenu avec %leItem%.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Eh bien...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to obtain " + this.Flags.get("ItemName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"item",
			this.m.Flags.get("ItemName")
		]);
		_vars.push([
			"leItem",
			this.m.Flags.get("LeItemName")
		]);
		_vars.push([
			"risk",
			this.m.RiskItem != null ? this.m.RiskItem.getName() : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isAlive())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			return true;
		}
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.RiskItem != null)
		{
			_out.writeBool(true);
			_out.writeI32(this.m.RiskItem.ClassNameHash);
			this.m.RiskItem.onSerialize(_out);
		}
		else
		{
			_out.writeBool(false);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local hasItem = _in.readBool();

		if (hasItem)
		{
			this.m.RiskItem = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
			this.m.RiskItem.onDeserialize(_in);
		}

		this.contract.onDeserialize(_in);
	}

});

