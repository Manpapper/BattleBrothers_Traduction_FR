this.destroy_orc_camp_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.destroy_orc_camp";
		this.m.Name = "Détruire le Camp d\'Orcs";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.m.Origin.getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}
		else if (r == 3)
		{
			this.m.Payment.Completion = 0.5;
			this.m.Payment.Count = 0.5;
		}

		local maximumHeads = [
			20,
			25,
			30
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
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

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.OrcRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Flags.set("HeadsCollected", 0);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 5)
					{
						this.Flags.set("IsSurvivor", true);
					}
					else if (r <= 15 && this.World.Assets.getBusinessReputation() > 800)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsOrcsAgainstOrcs", true);
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
					if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
					else if (this.Flags.get("IsBetrayal"))
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
				if (this.Flags.get("IsOrcsAgainstOrcs"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("OrcsAgainstOrcs");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "OrcAttack";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						p.IsAutoAssigningBases = false;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.OrcRaiders, 150 * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "OrcAttack";
					p.Music = this.Const.Music.OrcsTracks;
					this.World.Contracts.startScriptedCombat(p, true, true, true);
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

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID == "OrcAttack" || this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.World.State.getPlayer().getTile().getDistanceTo(this.Contract.m.Destination.getTile()) <= 1)
				{
					if (_actor.getFaction() == this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID())
					{
						this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
					}
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
		this.importScreens(this.Const.Contracts.NegotiationPerHead);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_61.png[/img]{%employer% souffle et expire.%SPEECH_ON%Bordel de merde.%SPEECH_OFF%Il va à sa fenêtre, et regarde à l\'extérieur.%SPEECH_ON%J\'ai organisé un tournoi de joute récemment et il y a eu une petite controverse. Maintenant, aucun de mes chevaliers ne combattra pour moi jusqu\'à ce que ce soit réglé.%SPEECH_OFF%Vous demandez si vous voulez des mercenaires pour régler un conflit entre nobles. L\'homme éclate de rire.%SPEECH_ON%Par les dieux, non, roturier. J\'ai besoin que vous vous occupiez de quelques peaux vertes qui campent %direction% de %origine%. Ils terrorisent la région depuis un moment maintenant et j\'aimerais que vous leur rendiez la pareille. Est-ce que ça vous intéresse, ou dois-je aller parler à une autre épée à louer ?%SPEECH_OFF% | %employer% met ses pieds sur sa table.%SPEECH_ON%Des avis sur les peaux vertes, mercenaire ?%SPEECH_OFF%Vous secouez la tête pour dire non. L\'homme incline la tête.%SPEECH_ON%Intéressant. La plupart disent qu\'ils ont peur, ou que ce sont des brutes qui peuvent couper un homme en deux. Mais vous... vous êtes différent. Ça me plaît. Que diriez-vous d\'aller %direction% de %origin% vers un endroit que les gens du coin ont surnommé %location% ? Nous y avons repéré un large groupe d\'orcs qu\'il faut disperser.%SPEECH_OFF% | Un chat est sur la table de %employer%. Il le caresse, le félin se froisse pour le griffer, mais soudain, il siffle, mord l\'homme et sort en courant par la porte par laquelle vous venez de passer. %employer% se dépoussière.%SPEECH_ON%Putain d\'animaux. Un moment ils t\'aiment, le suivant, eh bien...%SPEECH_OFF%Il suce une goutte de sang provenant de son pouce. Vous lui demandez si vous devez revenir pour qu\'il puisse se soigner.%SPEECH_ON%Très drôle, mercenaire. Non, ce que je veux que vous fassiez, c\'est aller %direction% de %origine% et vous attaquer à un groupe de peaux vertes qui habitent ces régions. Il faut qu\'ils soient détruits, dispersés, n\'importe quel mot, du moment qu\'ils sont partis. Est-ce que ça ressemble à quelque chose que vous pourriez faire pour nous ?%SPEECH_OFF% | %employer% enroule un parchemin en expliquant sa situation difficile.%SPEECH_ON%Une dispute parmi la noblesse m\'a fait perdre de bons combattants. Malheureusement, une bande de peaux-vertes a choisi ce moment précis pour venir dans ces régions. Ils campent %direction% de %origin%. Je ne peux pas mettre de l\'ordre dans la maison tout en étant attaqué par ces maudites choses, alors j\'espère que cela vous intéressera, mercenaire...%SPEECH_OFF% | %employer% vous regarde de haut en bas.%SPEECH_ON%Vous êtes assez en forme pour affronter une peau verte ? Et vos hommes ?%SPEECH_OFF%Vous hochez la tête et prétendez que ce n\'est pas plus compliqué que de récupérer un chat dans un arbre. %employer% sourit.%SPEECH_ON%Bien, parce que j\'en ai repéré un paquet %direction% de %origine%. Allez là-bas et détruisez-les. C\'est assez simple, non ? Ça doit intéresser un homme de votre... confiance.%SPEECH_OFF% | %employer% s\'occupe de ses chiens, leur donnant à chacun un repas pour lequel certains paysans tueraient. Il tapote ses mains de la graisse de la viande.%SPEECH_ON%Mon chef a fait ça, vous pouvez le croire ? Horrible. Dégoûtant.%SPEECH_OFF%Vous hochez la tête comme si vous pouviez comprendre dans quel monde vit cet homme où il est normal de donner de la bonne nourriture à des chiens. %employer% pose ses coudes sur sa table.%SPEECH_ON%Bref, les gens qui nous livrent de la viande disent que les peaux vertes tuent leurs vaches. Apparemment, un camp a été repéré %direction% de %origin%. Si vous êtes intéressés, j\'aimerais que vous alliez là-bas et que vous les détruisiez tous.%SPEECH_OFF% | Vous trouvez %employer% en train de regarder des parchemins. Il lève les yeux vers vous et vous propose une chaise.%SPEECH_ON%Content que vous soyez là, mercenaire. J\'ai un problème avec les peaux vertes dans le coin, ils ont établi leur camp %direction% d\'ici.%SPEECH_OFF%Il abaisse l\'un des parchemins.%SPEECH_ON%Et je ne peux pas me permettre d\'envoyer mes propres hommes. Les chevaliers sont plutôt... irremplaçables. Vous, par contre, vous êtes parfait pour ce travail. Qu\'en dites-vous ?%SPEECH_OFF% | Alors que vous entrez dans le bureau de %employer%, un groupe d\'hommes sort. Ce sont des chevaliers, leurs fourreaux cliquettent juste sous leurs vêtements. %employer% vous accueille.%SPEECH_ON%Ne vous inquiétez pas pour eux. Ils se demandent juste ce qui est arrivé au dernier homme que j\'ai engagé.%SPEECH_OFF%Vous levez un sourcil. L\'homme l\'ignore.%SPEECH_ON%Oh, ne me donnez pas cette merde, mercenaire. Vous connaissez le business aussi bien que moi, parfois vous n\'êtes pas à la hauteur et vous savez que cela signifie...%SPEECH_OFF%Vous ne dites rien, mais après une pause, vous lui faites un signe de tête.%SPEECH_ON%Bien, content que vous compreniez. Si vous voulez savoir, j\'ai des peaux vertes %direction% de %origine%. Ils ont installé un camp qui, je suppose, n\'a pas bougé depuis la dernière fois que j\'y ai envoyé des hommes. Êtes-vous intéressé à les débusquer pour moi ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combattre des orcs ne sera pas gratuit. | J\'imagine que vous allez payer chère pour ça. | Parlons argent.}",
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
			ID = "OrcsAgainstOrcs",
			Title = "Avant l\'attaque...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Alors que vous ordonnez à vos hommes d\'attaquer, ils tombent sur un certain nombre d\'orcs... qui se battent entre eux ? Les peaux vertes semblent être divisées, et elles règlent leurs différends en se divisant en deux. C\'est une démonstration macabre de violence. Lorsque vous vous dites qu\'il faut les laisser se battre, deux des orcs se dirigent vers vous, et bientôt, tous les orcs vous regardent. Bon, pas de fuite maintenant... aux armes ! | Vous ordonnez à %companyname% d\'attaquer, pensant avoir l\'effet de surprise sur les orcs. Mais ils sont déjà armés ! Et... ils se battent entre eux ?\n\n Un orc coupe un autre orc en deux, et un autre écrase la tête d\'un autre. Cela semble être une sorte de conflit entre clans. Dommage que vous n\'ayez pas attendu un peu plus longtemps pour que ces brutes règlent leurs différends, maintenant c\'est chacun pour soi ! | Les orcs se battent entre eux ! C\'est une sorte de mêlée de peau verte à laquelle vous avez pris part. Orc contre orc contre homme, quel spectacle à voir ! Rassemblez les hommes et vous pourrez peut-être sortir vivant de ce trou à rats. | Par les dieux, les orcs sont plus nombreux que vous ne pouviez l\'imaginer ! Heureusement, ils semblent s\'entretuer. Vous ne savez pas s\'il s\'agit de clans séparés ou si c\'est juste la version des peaux vertes d\'une bagarre d\'ivrognes. Quoi qu\'il en soit, vous êtes au milieu de tout ça maintenant !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{Alors que vous terminez le dernier orc, vous êtes soudainement surpris par un groupe d\'hommes lourdement armés. Leur lieutenant s\'avance, les pouces accrochés à une ceinture soutenant une épée.%SPEECH_ON%Eh bien, eh bien, vous êtes vraiment stupide. %employer% n\'oublie pas facilement - et il n\'a pas oublié la dernière fois que vous avez trahi %faction%. Considérez ceci comme un petit... retour de faveur.%SPEECH_OFF%Soudainement, tous les hommes derrière le lieutenant chargent en avant. Armez-vous, c\'était une embuscade ! | En nettoyant le sang d\'orc sur votre épée, vous apercevez soudain un groupe d\'hommes qui se dirige vers vous. Ils portent la bannière de %faction% et sortent leurs armes. Vous réalisez que vous avez été piégé au moment où les hommes commencent à charger. Ils vous ont laissé combattre les orcs en premier, les salauds ! Il fallait bien leur laisser une longueur d\'avance ! | Un homme apparemment venu de nulle part vient vous saluer. Il est bien armé, bien protégé et apparemment très heureux, il sourit d\'un air penaud en s\'approchant.%SPEECH_ON%Bonsoir, mercenaires. Bon travail sur ces peaux vertes, hein ?%SPEECH_OFF%Il fait une pause pour laisser son sourire s\'effacer.%SPEECH_ON%%employer% vous envoie ses salutations.%SPEECH_OFF%À ce moment-là, un groupe d\'hommes surgit des côtés de la route. C\'est une embuscade ! Ce maudit noble vous a trahi ! | La bataille est à peine terminée qu\'un groupe d\'hommes armés portant les couleurs de %faction% arrive derrière vous, le groupe se déploie pour dévisager votre compagnie. Leur chef vous jauge.%SPEECH_ON%Je vais prendre plaisir à arracher cette épée de votre poigne froide.%SPEECH_OFF%Vous haussez les épaules et demandez pourquoi vous avez été piégé.%SPEECH_ON%%employer% n\'oublie pas ceux qui le trahissent, lui ou sa maison. C\'est à peu près tout ce que vous devez savoir. Ce n\'est pas comme si ce que je disais ici vous servira quand vous serez mort.%SPEECH_OFF%Aux armes, c\'est une embuscade ! | Vos hommes parcourent le camp orc et ne trouvent pas âme qui vive. Tout à coup, quelques inconnus apparaissent derrière vous, le lieutenant du groupe s\'avançant avec de mauvaises intentions. Il a un tissu brodé du sigle de %employer%.%SPEECH_ON%Dommage que ces orcs n\'aient pas pu vous achever. Si vous vous demandez pourquoi je suis ici, c\'est pour payer une dette à %faction%. Vous aviez promis une tâche bien faite. Vous n\'avez pas pu tenir votre promesse. Maintenant, vous mourez.%SPEECH_OFF%Vous dégainez votre épée et pointez sa lame vers le lieutenant.%SPEECH_ON%On dirait que %faction% est sur le point de voir une autre promesse brisée.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
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
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 140 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Vous essuyez votre épée sur votre pantalon et la rengainez rapidement. Les embusqueurs gisent morts, embrochés dans telle ou telle pose grotesque. %randombrother% s\'approche et demande ce qu\'il faut faire maintenant. Il semble que %faction% ne soit plus en très bons termes avec vous. | Vous frappez le corps mort d\'un embusqué du bout de votre épée. On dirait que %faction% ne va plus être en bons termes avec vous à partir de maintenant. La prochaine fois, quand vous accepterez de faire quelque chose pour ces gens, vous le ferez vraiment. | Eh bien, si rien d\'autre, ce qui peut être appris de cela est de ne pas accepter une tâche que vous ne pouvez pas terminer. Les habitants de ces terres ne sont pas particulièrement amicaux envers ceux qui ne tiennent pas leurs promesses... | Vous avez trahi %faction%, mais il ne faut pas s\'attarder là-dessus. Ils vous ont trahis, c\'est ce qui est important maintenant ! Et à l\'avenir, vous devrez vous méfier d\'eux et de tous ceux qui portent leur bannière. | %employer%, à en juger par les bannerets morts à vos pieds, semble ne plus être heureux avec vous. Si vous deviez deviner, c\'est à cause de quelque chose que vous avez fait dans le passé - trahison, échec, retour de bâton, coucher avec la fille d\'un noble ? Tout se tient quand on essaie d\'y réfléchir. Ce qui est important maintenant, c\'est que ce fossé entre vous deux ne sera pas facilement comblé. Vous feriez mieux de vous méfier des hommes de %faction% pendant un certain temps.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tout ça pour un paiement...",
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
			Text = "[img]gfx/ui/events/event_32.png[/img]{La bataille terminée, vous fouillez le camp des orcs. Parmi les ruines, vous trouvez ce qui semble être une armure lourde et des armes humaines dans un état inutilisable. Malheureusement, vous ne trouvez pas ceux à qui elles ont peut-être appartenu. | Avec les orcs tués, vous jetez un coup d\'oeil autour de leur camp. C\'est plein de merde. Littéralement, il y a de la merde partout. Ces maudites choses ne connaissent rien à la propreté. %randombrother% se dandine, essuyant sa botte sur un piquet de tente.%SPEECH_ON%Monsieur, devons-nous avancer ou continuer à chercher... ?%SPEECH_OFF%Vous en avez vu, et senti, assez. | Le camp des orcs est un terrain vague rempli de toutes sortes de dépravations. On peut sentir leur sexe et leurs déchets. Ce n\'est pas étonnant qu\'ils soient si belliqueux, car ils ne connaissent même pas le début de ce qu\'un homme civilisé peut comprendre. | Le camp des orcs est détruit, mais vous prenez un moment pour fouiller dans les ruines. Au milieu de la fosse cendrée d\'un feu de camp, vous trouvez quelques cadavres humains. A en juger par leurs armes, ils semblent avoir été des mercenaires comme vous. Dommage... qu\'aucun de leurs équipements ne soit utile maintenant qu\'ils ont tous brûlé. | Quelques-uns de vos mercenaires marchent dans les ruines du camp orc. Ils fouillent les restes, trouvant telle ou telle bibelot inutilisable. %randombrother% rengaine son épée sanglante.%SPEECH_ON%Rien du tout ici, monsieur.%SPEECH_OFF%Vous acquiescez et préparez les hommes pour retourner voir %employer%. | La bataille terminée, vous vous promenez dans le camp, à la recherche de quelque chose d\'utile. Vous ne trouvez rien que vous puissiez prendre, mais vous trouvez une pile de chevaliers morts. Leurs visages pâles, vermoulus et couverts d\'asticots suggèrent qu\'ils étaient là depuis longtemps. Qui sait ce que les orcs faisaient avec eux.}",
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
			ID = "Volunteer1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_32.png[/img]{La bataille est terminée, mais vous entendez encore des cris. Vous dites à %randombrother% de la fermer, car il est quelque peu prédisposé aux grognements ou aux jappements aléatoires, mais il secoue la tête et dit que ce n\'est pas lui. A ce moment-là, un homme enchaîné sort d\'un tas de cendres qui était le camp des orcs.%SPEECH_ON%Bonsoir, messieurs ! Je crois que vous m\'avez libéré.%SPEECH_OFF%Il s\'avance en titubant, un nuage de cendres s\'éparpillant derrière lui.%SPEECH_ON%Je suis très reconnaissant, évidemment, et j\'aimerais vous rendre la pareille. Vous êtes des mercenaires, n\'est-ce pas ? Si oui, j\'aimerais me battre pour vous.%SPEECH_OFF%Il ramasse une lame sur le sol et la fait tourner dans sa main, la manipulant comme si elle était à lui depuis sa naissance. Une offre intéressante qui vient de devenir plus intéressante... | En nettoyant votre lame, une voix s\'élève d\'une tente orque effondrée.%SPEECH_ON%Messieurs, vous avez réussi !%SPEECH_OFF%Vous regardez un homme souriant émerger.%SPEECH_ON%Vous m\'avez libéré ! Et je voudrais vous rendre ce service en vous offrant ma main !%SPEECH_OFF%Il tend sa main, fait une pause, puis la retire.%SPEECH_ON%Je veux dire me battre pour vous ! J\'aimerais me battre pour vous, monsieur ! Si vous pouvez faire tout ça, alors je suis en bonne compagnie, non ?%SPEECH_OFF%Hmm, une offre intéressante. Vous lui lancez une arme et il l\'attrape avec facilité. Il en fait tourner la poignée, la faisant tourner d\'une main sur l\'autre avant d\'essayer de la ranger dans un fourreau invisible.%SPEECH_ON%Mon nom est %dude_name%.%SPEECH_OFF% | Un homme en armure en lambeaux et cabossée vient vers vous en sprintant. Ses bras sont attachés derrière son dos.%SPEECH_ON%Vous avez réussi ! Je n\'arrive pas à y croire ! Désolé, laissez-moi expliquer mon immodestie. J\'ai été capturé par les orcs il y a un jour alors que nous essayions de prendre le camp. Je pense qu\'ils étaient sur le point de me mettre à la broche quand vous êtes arrivé. J\'ai profité du premier moment pour m\'enfuir, mais maintenant je vois que vous et votre groupe méritez peut-être d\'être rejoints.%SPEECH_OFF%Vous demandez à l\'homme d\'aller droit au but. Il le fait.%SPEECH_ON%J\'aimerais me battre pour vous, monsieur. J\'ai de l\'expérience, j\'ai été dans l\'armée du seigneur, mercenaire, et... bien d\'autres choses.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Bienvenue dans la compagnie !",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Vous devrez aller chercher votre chance ailleurs.",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVeteranBackgrounds);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getTitle() == "")
				{
					this.Contract.m.Dude.setTitle("le Survivant");
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous retournez voir %employer% et lui rapportez vos faits et gestes. Il vous fait signe.%SPEECH_ON%Oh s\'il vous plaît, mercenaire. Je suis déjà au courant. Vous ne pensez pas que j\'ai des espions dans ces régions ?%SPEECH_OFF%Il fait un geste vers une sacoche posée sur le coin de sa table. Vous la prenez et l\'homme vous fait un signe du poignet.%SPEECH_ON%Cela devrait être un remerciement suffisant, maintenant s\'il vous plaît hors de ma vue.%SPEECH_OFF% | Vous montrez à %employer% la tête d\'un orc. Il la regarde, puis vous regarde.%SPEECH_ON%Intéressant. Dois-je en déduire que vous avez fait ce que je vous ai demandé ?%SPEECH_OFF%Vous acquiescez. L\'homme sourit et vous tend un coffre en bois avec %reward% couronnes à l\'intérieur.%SPEECH_ON%Je savais que je pouvais vous faire confiance, mercenaire.%SPEECH_OFF% | %employer% vous regarde fixement quand vous revenez.%SPEECH_ON%J\'ai entendu parler de ce que vous avez fait.%SPEECH_OFF%Il y a un ton étrange dans sa voix, un ton qui vous fait rapidement passer en revue tout ce que vous avez fait au cours de la semaine passée. Était-ce une femme noble à... Non, ça ne peut pas être ça.%SPEECH_ON%Les orcs sont morts. Bon travail, mercenaire.%SPEECH_OFF%Il vous glisse une sacoche de %reward% couronnes et une vague de soulagement vous envahit alors. | Vous entrez dans la chambre de %employer% et prenez un siège, en vous versant une tasse de vin. Le noble vous transperce du regard.%SPEECH_ON%J\'ose dire que c\'est un délit de dégaine, de pendaison si je me sens bien, de brûlure si je ne le suis pas.%SPEECH_OFF%Vous finissez votre verre et vous frappez la tête d\'un orque sur la table de l\'homme. La tasse bascule et roule sur le côté. %employer% recule, puis se calme.%SPEECH_ON%Ah, oui, un verre bien mérité. Ce n\'était pas mon meilleur vin, de toute façon. %randomname%, mon garde, vous attend dehors. Il aura les %reward% couronnes de récompense dont nous avions convenu.%SPEECH_OFF% | Vous soulevez la tête d\'un orque pour la montrer à %employer%. La gueule verte s\'ouvre, sa langue traîne entre des dents que l\'on pourrait prendre pour des défenses. %employer% hoche la tête et fait un geste de la main.%SPEECH_ON%S\'il vous plaît, ayez pitié de mes rêves et emportez-les.%SPEECH_OFF%Vous faites ce qu\'on vous dit. L\'homme secoue la tête.%SPEECH_ON%Comment je vais pouvoir dormir ces prochains jours avec des choses comme ça à trimballer ? Quoi qu\'il en soit, vous avez %reward% couronnes qui vous attendent déjà dehors avec un de mes gardes. Merci pour votre travail, mercenaire.%SPEECH_OFF% | Vous entrez dans le bureau de %employer% pour le trouver en train de regarder un dessin sur un parchemin. Il vous regarde fixement, le bord du papier se repliant vers l\'arrière.%SPEECH_ON%Ma fille se prend pour une artiste, vous pouvez le croire ?%SPEECH_OFF%Il vous montre le parchemin. C\'est un dessin assez bien fait d\'un homme qui ressemble étrangement à %employer%. Le personnage dessiné fait face à un bourreau. %employer% rit.%SPEECH_ON%Une fille stupide.%SPEECH_OFF%Il froisse les parchemins et les jette à côté.%SPEECH_ON%Quoi qu\'il en soit, mes espions m\'ont déjà parlé de votre réussite. Voici votre paiement comme convenu.%SPEECH_OFF%}",
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
						this.World.Assets.addMoney(this.Contract.m.Reward);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Détruit un campement orc");
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
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() + this.Flags.get("HeadsCollected") * this.Contract.m.Payment.getPerCount();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
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
		_vars.push([
			"dude_name",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"reward",
			this.m.Reward
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

