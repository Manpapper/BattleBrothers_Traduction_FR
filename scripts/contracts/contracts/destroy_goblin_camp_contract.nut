this.destroy_goblin_camp_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.destroy_goblin_camp";
		this.m.Name = "Détruire Camp Goblin";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.World.State.getPlayer().getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
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
					"Détruisez " + this.Flags.get("DestinationName") + " %direction% de %origin%"
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
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.GoblinRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 20 && this.World.Assets.getBusinessReputation() > 1000)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsAmbush", true);
						}
					}
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsBetrayal"))
					{
						if (this.Flags.get("IsBetrayalDone"))
						{
							this.Contract.setScreen("Betrayal2");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("Betrayal1");
							this.World.Contracts.showActiveContract();
						}
					}
					else
					{
						this.Contract.setScreen("SearchingTheCamp");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsAmbush"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Ambush");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = null;
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GoblinRaiders, 50 * this.Contract.getScaledDifficultyMult(), this.Contract.m.Destination.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
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
					this.Contract.setScreen("Success1");
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
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_61.png[/img]{%employer% est en train de lire un parchemin quand vous entrez. Il vous fait signe de partir, pensant peut-être que vous n\'êtes qu\'un serviteur. Vous faites tinter votre fourreau contre le mur. L\'homme lève les yeux, puis laisse rapidement tomber ses papiers.%SPEECH_ON%Ah, mercenaire ! C\'est bon de vous voir. J\'ai un problème spécifique pour un homme de vos... talents.%SPEECH_OFF%Il fait une pause comme s\'il attendait votre réaction. Comme vous n\'en avez pas, il continue maladroitement.%SPEECH_ON%Oh oui, bien sûr, la tâche. Il y a des gobelins %direction% de %origin% qui ont pris pied dans la région. Je me serais bien occupé de ça avec quelques chevaliers, mais il s\'avère que \"tuer des gobelins\" est indigne de ces hommes. Balivernes, je dis. Je pense qu\'ils ne veulent tout simplement pas mourir des mains de ces petites merdes. L\'honneur, le courage, tout ça.%SPEECH_OFF%Il sourit et lève la main.%SPEECH_ON%Mais ce n\'est pas indigne de vous, tant que le salaire est bon, n\'est-ce pas ?%SPEECH_OFF% | %employer% crie sur un homme lui disant son bureau. Quand il se calme, il vous salue gentiment.%SPEECH_ON%Putain de merde, c\'est bon de vous voir. Avez-vous la moindre idée de la difficulté à convaincre vos hommes \"loyaux\" d\'aller tuer quelques gobelins ?%SPEECH_OFF%Il crache et s\'essuie la bouche sur sa manche.%SPEECH_ON%Apparemment, ce n\'est pas la plus noble des tâches. Quelque chose à propos de ces petites merdes qui ne se battent jamais à la loyale. Vous pouvez croire ça ? Des hommes qui me disent à moi, un noble de haute naissance, ce qui est \"noble\" ou pas. Eh bien, c\'est comme ça de toute façon, mercenaire. J\'ai besoin que vous alliez %direction% de %origin% et que vous chassiez des gobelins qui ont établi un camp. Pouvez-vous faire ça pour moi ?%SPEECH_OFF% | %employer% dégaine et rengaine une épée. Il semble se regarder dans le reflet de la lame avant de la retirer à nouveau.%SPEECH_ON%Les paysans me harcèlent à nouveau. Ils disent que des gobelins campent à un endroit appelé %location% %direction% de %origin%. Je n\'ai aucune raison de ne pas les croire après qu\'un jeune garçon ait été amené à mes pieds aujourd\'hui, une fléchette empoisonnée dans le cou.%SPEECH_OFF%Il fait claquer l\'épée dans son fourreau.%SPEECH_ON%Êtes-vous disposé à vous occuper de ce problème pour moi ?%SPEECH_OFF% | Le visage rouge, un %employer% ivre fait claquer une tasse lorsque vous entrez dans son bureau.%SPEECH_ON%Mercenaire, c\'est ça ?%SPEECH_OFF%Son garde regarde et hoche la tête. Le noble rit.%SPEECH_ON%Oh. Bien. Plus d\'hommes à envoyer à la mort.%SPEECH_OFF%Il fait une pause avant d\'éclater de rire.%SPEECH_ON%Je plaisante, quelle plaisanterie, hein ? On a un problème avec des gobelins %direction% de %origine%. J\'ai besoin que vous alliez vous occuper d\'eux, êtes-vous -hic- prêt pour cela ou dois-je demander à quelqu\'un d\'autre de creuser sa propre... Je veux dire...%SPEECH_OFF%Il se tait avec un autre verre. | %employer% compare deux parchemins quand vous entrez.%SPEECH_ON%Mes ordres rencontrent quelques problèmes ces jours-ci. C\'est dommage, mais je suppose que c\'est une bonne affaire pour vous maintenant que je ne peux pas me permettre d\'envoyer mes soi-disant \"loyaux\" chevaliers n\'importe où.%SPEECH_OFF%Il jette les papiers de côté et crispe ses mains sur sa table.%SPEECH_ON%Mes espions rapportent que des gobelins ont établi un camp à un endroit qu\'ils appellent %location% %direction% de %origin%. J\'ai besoin que vous y alliez et fassiez ce que mes chevaliers refusent de faire.%SPEECH_OFF% | %employer% rompt le pain quand vous entrez, mais il ne le partage pas. Il trempe les deux bouts dans un gobelet de vin et se bourre la bouche. Il parle, mais c\'est plus des miettes que des mots.%SPEECH_ON%Content de vous voir, mercenaire. J\'ai quelques gobelins %direction% de %origin% qui ont besoin d\'être chassés. J\'enverrais bien mes chevaliers s\'occuper d\'eux, mais ils sont, euh, un peu plus importants et moins remplaçables. Je suis sûr que vous comprenez.%SPEECH_OFF%Il parvient à fourrer le reste du pain dans son horrible gueule. Pendant un moment, il s\'étouffe, et pendant un moment, vous envisagez de fermer la porte et de laisser les choses se terminer ici et maintenant. Malheureusement, ses angoisses attirent l\'attention d\'un garde qui se jette sur lui et lui assène un coup de poing dans la poitrine, répandant ainsi le danger dans toute sa gloire gluante et presque assassine. | Lorsque vous trouvez %employer%, il est en train de renvoyer quelques chevaliers, les chassant par la porte avec quelques malédictions. Votre présence semble cependant le calmer momentanément. %SPEECH_ON%Mercenaire ! C\'est bon de vous voir ! Mieux vaut vous que ces soi-disant \"hommes\".%SPEECH_OFF%Il s\'assied et se sert un verre. Il en prend une gorgée, la fixe du regard, puis la boit d\'un trait.%SPEECH_ON%Mes hommes fidèles refusent d\'aller affronter les gobelins qui ont campé %direction% de %origin%. Ils parlent d\'embuscades, de poison, tout ça...%SPEECH_OFF%Il a de plus en plus de mal à parler.%SPEECH_ON%Eh bien... -hic-, vous savez tout ça, non ? Et vous savez ce que je vais demander ensuite, non ? Bien - bien sûr que vous le savez, -hic-, j\'ai besoin que vous me donniez un autre verre ! Ha, je plaisante. Allez tuer ces gobelins, voulez-vous ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combattre des Gobelins ne sera pas gratuit. | J\'imagine que vous allez payer chère pour ça. | Parlons argent.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | Nous avons d\'autres obligations.}",
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
			ID = "Ambush",
			Title = "Approaching the camp...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{Vous entrez dans le camp des gobelins et vous le trouvez vide. Mais vous vous doutez bien que vous venez de tomber dans un piège. À ce moment-là, les maudits peaux-vertes surgissent de partout autour de vous. Avec le cri de guerre le plus fort que vous puissiez pousser, vous ordonnez aux hommes de se préparer au combat ! | Les gobelins vous ont dupés ! Ils ont quitté le camp et ont fait demi-tour, vous encerclant. Préparez les hommes avec prudence, car il ne sera pas facile de s\'échapper de ce piège. | Vous auriez dû vous en douter : vous êtes tombés dans un piège de gobelins ! Ils ont placé leurs soldats tout autour tandis que la compagnie reste planter là au milieu comme une bande de moutons à l\'abattoir !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Attention !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Alors que vous terminez le dernier gobelin, vous êtes soudain accueilli par un groupe d\'hommes lourdement armés. Leur lieutenant s\'avance, les pouces accrochés à une ceinture soutenant une épée.%SPEECH_ON%Eh bien, eh bien, vous êtes vraiment stupide. %employer% n\'oublie pas facilement - et il n\'a pas oublié la dernière fois que vous l\'avez trahi. Considérez ceci comme un petit... retour de faveur.%SPEECH_OFF%Soudain, tous les hommes derrière le lieutenant se mettent en marche. Armez-vous, c\'était une embuscade ! | En nettoyant le sang des goblins sur votre épée, vous apercevez soudain un groupe d\'hommes qui se dirige vers vous. Ils portent la bannière de %employer% et sortent leurs armes. Vous réalisez que vous avez été piégé au moment où les hommes commencent à charger. Ils vous ont laissé combattre les gobelins en premier, les salauds ! On les aura ! | Un homme apparemment venu de nulle part vient vous saluer. Il est bien armé, bien protégé et apparemment très heureux, il sourit d\'un air penaud en s\'approchant.%SPEECH_ON%Bonsoir, mercenaires. Bon travail sur ces peaux vertes, hein ?%SPEECH_OFF%Il fait une pause pour laisser son sourire s\'effacer.%SPEECH_ON%%employer% vous envoie ses salutations.%SPEECH_OFF%À ce moment-là, un groupe d\'hommes surgit des côtés de la route. C\'est une embuscade ! Ce maudit noble vous a trahi ! | Un groupe d\'hommes armés portant les couleurs de %faction% arrive derrière vous, le groupe se déplaçant en éventail pour entourer votre compagnie. Leur chef vous jauge.%SPEECH_ON%Je vais prendre plaisir à arracher cette épée de tes mains froides et mortes.%SPEECH_OFF%Vous haussez les épaules et demandez pourquoi vous avez été trahi.%SPEECH_ON%%employer% n\'oublie pas ceux qui le trahissent ou trahissent la faction. C\'est à peu près tout ce que vous avez besoin de savoir. Ce n\'est pas comme si ce que je disais ici vous servira quand vous serez mort.%SPEECH_OFF%Aux armes, donc, car c\'est une embuscade ! | Vos hommes parcourent le camp des gobelins et ne trouvent pas âme qui vive. Soudain, des hommes aux couleurs de %faction% apparaissent derrière vous, le lieutenant du groupe s\'avançant avec de mauvaises intentions. Il a un tissu brodé avec le sigle de %employer%.%SPEECH_ON%Dommage que ces peaux vertes n\'aient pas pu vous achever. Si vous vous demandez pourquoi je suis ici, c\'est pour collecter une dette que vous devez à %employer%. Vous aviez promis une tâche bien faite. Vous n\'avez pas pu tenir votre promesse. Maintenant, vous mourez.%SPEECH_OFF%Vous dégainez votre épée et pointez sa lame vers le lieutenant.%SPEECH_ON%On dirait que %employer% est sur le point de voir une autre promesse brisée.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prenez les armes !",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Betrayal";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 140 * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Vous essuyez votre épée sur votre pantalon et la rengainez rapidement. Les embusqueurs gisent morts, embrochés dans telle ou telle pose grotesque. %randombrother% s\'approche et demande ce qu\'il faut faire maintenant. Il semble que %faction% ne soit plus en très amicale. | Vous frappez le corps mort d\'un embusqué du bout de votre épée. On dirait que %faction% ne va plus être très amicale à partir de maintenant. Peut-être que la prochaine fois, quand j\'accepterai de faire quelque chose pour ces gens, je le ferai vraiment. | Eh bien, si rien d\'autre, ce qui peut être retenu de cela c\'est de ne pas accepter une tâche que vous ne pouvez pas terminer. Les habitants de ces terres ne sont pas particulièrement amicaux envers ceux qui ne tiennent pas leurs promesses... | Vous avez trahi %faction%, mais il ne faut pas s\'attarder là-dessus. Ils vous ont trahis, c\'est ce qui est important maintenant ! Et à l\'avenir, vous devrez vous méfier d\'eux et de tous ceux qui portent leur bannière. | %employer%, à en juger par les hommes de main morts à vos pieds, semble ne plus être heureux avec vous. Si vous deviez deviner, c\'est à cause de quelque chose que vous avez fait dans le passé - trahison, échec, retour de bâton, coucher avec la fille d\'un noble ? Tout se tient quand on essaie d\'y penser. Ce qui est important maintenant, c\'est que ce fossé entre vous deux ne sera pas facilement comblé. Vous feriez mieux de vous méfier des hommes de %faction% pendant un certain temps.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tant pis pour le paiement...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SearchingTheCamp",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_83.png[/img]{Après avoir tué le dernier des gobelins, vous jetez un coup d\'œil à leur campement. Ils ont l\'air d\'être dur genre festifs- des tas de babioles et d\'instruments, qui pourraient tous servir d\'armes se trouve dans ce camp. Il suffirait de les tremper dans le pot géant de poison qui se trouve au milieu des ruines. Vous le renversez et dites aux hommes de se préparer à retourner voir %employer%, votre employeur. | Les gobelins se sont bien battus, mais vous avez réussi à les tuer tous. Leur camp étant en feu, vous ordonnez aux hommes de se préparer à retournez voir %employer% avec la bonne nouvelle. | Les peaux vertes ont livré un sacré combat, mais votre compagnie a fait mieux. Les derniers gobelins tués, vous jetez un coup d\'oeil autour de leur campement en ruine. Il semble qu\'ils n\'étaient pas totalement seuls - il y a des preuves que d\'autres gobelins se sont enfuis pendant que le combat se déroulait. Peut-être une famille ? Des enfants ? Peu importe, il est temps de retournez voir %employer%, l\'homme qui vous a engagé. | Ah, c\'était un bon combat. %employer% s\'attendra à en entendre parler maintenant. | Il n\'est pas étonnant que les hommes ne souhaitent pas combattre les gobelins, ils livrent un combat bien supérieur à leur stature. Dommage qu\'on ne puisse pas mettre leur esprit dans un homme, mais c\'est peut-être mieux qu\'une telle férocité soit contenue dans de si petits êtres !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps d\'aller chercher notre paie.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous entrez dans le bureau de %employer% et déposez quelques têtes de gobelins sur le sol. Il les regarde.%SPEECH_ON%Huh, ils sont en fait beaucoup plus gros que ce que disent les scribes.%SPEECH_OFF%En quelques mots, vous signalez la destruction du campement des peaux-vertes. Le noble acquiesce en se frottant le menton.%SPEECH_ON%Excellent. Votre paie, comme promis.%SPEECH_OFF%Il vous remet une sacoche de %reward_completion% couronnes. | %employer% jette des pierres à un chat capricieux quand vous entrez. Il vous jette un coup d\'œil, donnant à la pauvre créature la plus petite opportunité de s\'échapper par une fenêtre. Le noble le chasse à l\'aide de quelques pierres, manquant heureusement chacune d\'entre elles.%SPEECH_ON%C\'est bon de vous revoir, mercenaire. Mes espions m\'ont déjà parlé de vos exploits. Voici votre salaire, comme convenu.%SPEECH_OFF%Il fait glisser un coffre en bois contenant %reward_completion% couronnes sur sa table. | %employer% est en train de décortiquer des noix quand vous revenez. Il jette les coquilles sur le sol, tout en baillant et en grinçant des dents quand il parle.%SPEECH_ON%Oh, c\'est bon de vous revoir. Je suppose que vous avez réussi, n\'est-ce pas ?%SPEECH_OFF%Vous soulevez quelques têtes de gobelins, chacune étant attachée à une bande unique. Ils se tordent et fixent la pièce et les uns les autres. L\'homme lève sa main.%SPEECH_ON%S\'il vous plaît, nous sommes des gens respectables ici. Posez ça autre part.%SPEECH_OFF%Vous haussez les épaules et les remettez à %randombrother% qui attend dans le hall. %employer% fait le tour de sa table et vous tend une sacoche.%SPEECH_ON%%reward_completion% couronnes, comme convenu. Bon travail, mercenaire.%SPEECH_OFF% | %employer% rit quand il vous voit arriver avec les têtes de gobelin.%SPEECH_ON%Bon sang, mercenaire, ne ramènez pas ça ici. Donne-les aux chiens.%SPEECH_OFF%Il est un peu ivre. Vous ne savez pas s\'il est ravi que vous ayez réussi ou s\'il est juste naturellement joyeux avec un peu d\'alcool dans le sang.%SPEECH_ON%Votre paiement était -hic- %reward_completion% couronnes, non ?%SPEECH_OFF%Vous pensez à \"modifier\" les détails, mais un garde à l\'extérieur regarde la discussion et secoue la tête. Eh bien, on dirait que c\'était %reward_completion% couronnes alors. | Quand vous retournez voir %employer%, il a une femme sur ses jambes. En fait, elle est penchée en avant et %employer% à la main est en l\'air. Ils vous regardent tous les deux en faisant une pause, puis elle se précipite sous sa table et il se redresse.%SPEECH_ON%Mercenaire ! C\'est bon de vous voir ! Je suppose que vous avez réussi à détruire ces peaux vertes, n\'est-ce pas ?%SPEECH_OFF%La pauvre femme se cogne la tête sous le bureau, mais vous essayez de ne pas y prêter attention en informant l\'homme du succès de l\'expédition. Il frappe dans ses mains, cherche à se lever, puis se ravise.%SPEECH_ON%Si vous le voulez bien, votre paiement de %reward_completion% couronnes est sur l\'étagère derrière moi.%SPEECH_OFF%Il sourit maladroitement alors vous le récupérez.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Destroyed a goblin encampment");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Origin.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/greenskins_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
			}
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

			if (this.m.Origin.getOwner().getID() != this.m.Faction)
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

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

