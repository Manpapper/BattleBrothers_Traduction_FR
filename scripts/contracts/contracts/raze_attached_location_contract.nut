this.raze_attached_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Settlement = null
	},
	function setSettlement( _s )
	{
		this.m.Flags.set("SettlementName", _s.getName());
		this.m.Settlement = this.WeakTableRef(_s);
	}

	function setLocation( _l )
	{
		this.m.Destination = this.WeakTableRef(_l);
		this.m.Flags.set("DestinationName", _l.getName());
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = 0.85;
		this.m.Type = "contract.raze_attached_location";
		this.m.Name = "Détruire Location";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		local s = this.World.EntityManager.getSettlements()[this.Math.rand(0, this.World.EntityManager.getSettlements().len() - 1)];
		this.m.Destination = this.WeakTableRef(s.getAttachedLocations()[this.Math.rand(0, s.getAttachedLocations().len() - 1)]);
		this.m.Flags.set("PeasantsEscaped", 0);
		this.m.Flags.set("IsDone", false);
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.getDifficultyMult() * this.getReputationToPaymentMult();

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
					"Rasez " + this.Flags.get("DestinationName") + " près de " + this.Flags.get("SettlementName")
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
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Peasants, this.Math.rand(90, 150));

					if (this.Math.rand(1, 100) <= 25)
					{
						this.Flags.set("IsMilitiaPresent", true);
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Militia, this.Math.min(300, 80 * this.Contract.getScaledDifficultyMult()));
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
					this.Contract.m.Destination.setFaction(this.Const.Faction.Enemy);
					this.Contract.m.Destination.setAttackable(true);
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsDone"))
				{
					if (this.Flags.get("IsBetrayal"))
					{
						this.Contract.setScreen("Betrayal2");
					}
					else
					{
						this.Contract.setScreen("Done");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onEntityPlaced( _entity, _tag )
			{
				if (_entity.getFlags().has("peasant") && this.Math.rand(1, 100) <= 75)
				{
					_entity.setMoraleState(this.Const.MoraleState.Fleeing);
					_entity.getBaseProperties().Bravery = 0;
					_entity.getSkills().update();
					_entity.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_retreat_always"));
				}

				if (_entity.getFlags().has("peasant") || _entity.getFlags().has("militia"))
				{
					_entity.setFaction(this.Const.Faction.Enemy);
					_entity.getSprite("socket").setBrush("bust_base_militia");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Contract.m.Destination.getTroops().len() == 0)
				{
					this.onCombatVictory("RazeLocation");
					return;
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsBetrayal"))
					{
						this.Contract.setScreen("Betrayal1");
					}
					else if (this.Flags.get("IsMilitiaPresent"))
					{
						this.Contract.setScreen("MilitiaAttack");
					}
					else
					{
						this.Contract.setScreen("DefaultAttack");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.Contract.m.Destination.getPos());
					p.CombatID = "RazeLocation";
					p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[this.Contract.m.Destination.getTile().Type];
					p.Tile = this.World.getTile(this.World.worldToTile(this.World.State.getPlayer().getPos()));
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.Template[0] = "tactical.human_camp";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
					p.LocationTemplate.CutDownTrees = true;
					p.LocationTemplate.AdditionalRadius = 5;
					p.PlayerDeploymentType = this.Flags.get("IsEncircled") ? this.Const.Tactical.DeploymentType.Circle : this.Const.Tactical.DeploymentType.Edge;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
					p.Music = this.Const.Music.CivilianTracks;
					p.IsAutoAssigningBases = false;

					foreach( e in p.Entities )
					{
						e.Callback <- this.onEntityPlaced.bindenv(this);
					}

					p.EnemyBanners = [
						"banner_noble_11"
					];
					this.World.Contracts.startScriptedCombat(p, true, true, true);
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (_actor.getFlags().has("peasant"))
				{
					this.Flags.set("PeasantsEscaped", this.Flags.get("PeasantsEscaped") + 1);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RazeLocation")
				{
					this.Contract.m.Destination.setActive(false);
					this.Contract.m.Destination.spawnFireAndSmoke();
					this.Flags.set("IsDone", true);
				}
				else if (_combatID == "Defend")
				{
					this.Flags.set("IsDone", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "RazeLocation")
				{
					this.Flags.set("PeasantsEscaped", 100);
				}
				else if (_combatID == "Defend")
				{
					this.Flags.set("IsDone", true);
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
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				this.Contract.m.Destination.setFaction(this.Contract.m.Destination.getSettlement().getFaction());
				this.Contract.m.Destination.clearTroops();
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("PeasantsEscaped") == 0)
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Math.rand(1, 100) >= this.Flags.get("PeasantsEscaped") * 10)
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Failure1");
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
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_61.png[/img]{%employer% remonte ses manches de soie et fait craquer ses articulations.%SPEECH_ON%J\'espère pouvoir vous confier une affaire des plus délicates car ma famille ne peut être liée à ce que je vais vous dire.%SPEECH_OFF%Vous acquiescez comme si on demandait souvent à un mercenaire de garder un secret. L\'homme continue.%SPEECH_ON%La ville de %settlementname% est trop faible pour se protéger et le peuple réclame une protection contre les brigands. Nous, la maison de %noblehousename%, sommes les seuls à pouvoir réellement offrir la sécurité qu\'ils recherchent. Malheureusement, le conseil local est trop aveugle pour le voir. Ils sont convaincus qu\'ils peuvent protéger leur peuple eux-mêmes. Prouvons-leur qu\'ils ont tort.\n\n Je veux que vous réduisiez en cendres %location% proche de %settlementname% et que vous tuiez les paysans qui s\'y trouvent. Faites croire que ce sont des brigands qui ont fait ça. Je suis sûr que vous connaissez leur travail. Et maintenant...%SPEECH_OFF%%employer% se penche vers vous.%SPEECH_ON%...Laissez-moi être très clair et j\'ai besoin que vous écoutiez très attentivement. Il ne doit y avoir aucun survivant qui puisse dire qui les a vraiment attaqués. Aucun ! Vous comprenez ? Bien. Retournez me voir une fois la tâche accomplie.%SPEECH_OFF% | %employer% fixe une pile de parchemins avant de les faire tomber de sa table avec colère dans un ouragan de papier.%SPEECH_ON%Les conseillers municipaux de %settlementname% pensent pouvoir protéger leur petite ville des brigands, mais je sais qu\'ils ne le peuvent pas. Je sais qu\'ils ont besoin de ma protection ! Et je l\'ai offerte à un prix si raisonnable...%SPEECH_OFF%Il se calme juste assez longtemps pour vous regarder.%SPEECH_ON%Je sais. Je sais ce qu\'il faut faire. Vous... vous êtes familier avec les faits et gestes des brigands, non ? Bien sûr. Alors que diriez-vous... d\'aller à %location% en dehors de %settlementname% et... de faire ce qu\'un brigand fait. Bien sûr, faites en sorte que ça ait l\'air d\'être le fait de brigands... Après ça, la ville va sûrement me demander de les protéger ! Et alors ils seront en sécurité !%SPEECH_OFF% | %employer% a les mains crispées, le bout des mains appuyé sur son front. Il laisse échapper un long soupir.%SPEECH_ON%J\'ai essayé de traiter avec ces gens de %settlementname% depuis quelques années maintenant, mais je commence à penser que je vais devoir prendre des mesures drastiques pour obtenir ce que je veux. Le conseil municipal ne veut pas me payer pour protéger leur village car ils pensent pouvoir le faire eux-mêmes. Ils disent qu\'ils sont à l\'abri du danger depuis un certain temps maintenant. Et si... ils ne l\'étaient pas ? Et si vous alliez là-bas, habillé en brigand bien sûr, et que vous leur appreniez que sans l\'aide de %noblehousename% personne n\'est à l\'abri ! Bien sûr, vous ne devez parler à personne de notre petite conversation ici... Qu\'en dites-vous, mercenaire ?%SPEECH_OFF% | %employer% regarde par la fenêtre pendant que vous vous installez sur un siège.%SPEECH_ON%Debout, mercenaire. Je n\'aime pas chuchoter, ça m\'oblige à élever la voix et avec ce que je vais vous dire, je ne pense pas vouloir faire ça.%SPEECH_OFF%Vous vous levez et tendez l\'oreille.%SPEECH_ON%%settlementname% a refusé mon offre de protection. Ils ont décidé de faire cavalier seul. Non seulement ils ne paient pas %noblehousename%, mais ils salissent notre nom. Si ce village refuse notre protection, que feront les autres ? J\'ai besoin que vous vous fassiez passer pour un brigand, que vous alliez là-bas et que vous leur appreniez ce que c\'est que de vivre dans ce monde sans %noblehousename% à vos côtés ! Bien sûr, la discrétion est de la plus haute importance. Rien de ce que j\'ai dit ici ne doit sortir de cette pièce.%SPEECH_OFF% | %employer% est en train de frotter une pomme à vif, éplucher la peau avec l\'ongle de son pouce.%SPEECH_ON%Mon père avait l\'habitude de me dire que si vous n\'avez pas un nom qui suscite le respect rien que par sa prononciation, alors vous n\'avez pas de nom du tout. Malheureusement, %settlementname% ne respecte pas le nom de %noblehousename%. Ils ont refusé mes offres de protection et ont insulté ma famille. Je veux que vous leur rendiez la monnaie de leur pièce. Je veux que vous alliez là-bas, non pas comme des mercenaires mais comme des brigands, et que vous leur montriez ce qui se passe dans un monde sans la protection de %noblehousename%. Bien sûr, vous devez être minutieux, mercenaire. Vous ne devez parler à personne de ce que nous avons dit dans cette pièce.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons argent. | De combien de Couronnes parle-t-on? | Quel sera le salaire ? | Pour le bon prix, tout peut être fait.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne fait pas parti de notre travail. | Ce n\'est pas pour %companyname%.}",
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
			ID = "DefaultAttack",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_16.png[/img]{Vous atteignez %location%. Les paysans sont dehors, comme vous le pensiez. Ce sera comme harponner des poissons dans un tonneau. Maintenant, la seule question est : comment voulez-vous approcher ? | %location% est un peu plus sereine que vous ne le pensiez. Quelques paysans se promènent, balançant des faucilles et des houes tout en plaisantant sur ceci ou cela. Vous les entendez hurler de rire pour une blague. Quel dommage que le reste de leur journée ne soit pas aussi drôle. | Vous passez à travers de hautes herbes pour avoir une bonne vue de %location%. Quelques paysans se promènent, complètement inconscients de la destruction qui rôde dans l\'herbe juste à l\'extérieur de leur petit hameau. Balayant la zone du regard, vous commencez à préparer votre prochaine action. | %location% est calme, un peu trop calme pour un lieu destiné à être détruit. Vous secouez la tête devant la cruauté de ce monde, mais vous vous rappelez que c\'est un travail pour lequel vous allez être bien payé. Cela rend les choses un peu plus faciles. | Tuer des paysans n\'a jamais été votre fort. Non pas que vous ne pouviez pas le faire, mais la simplicité du geste vous a toujours déplu. Comme tuer un chien sans pattes, ou marcher sur une grenouille aveugle. Mais personne ne vous a jamais payé cher pour endormir un chien. Quelle ironie que ces paysans auraient été plus en sécurité en tant que bâtards qu\'en tant qu\'humains.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Encerclez-les !",
					function getResult()
					{
						this.Flags.set("IsEncircled", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "Attaquer d\'un côté !",
					function getResult()
					{
						this.Flags.set("IsEncircled", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MilitiaAttack",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Vous atteignez %location% et dites immédiatement à vos hommes de patienter et de se baisser. Les paysans sont devant vous, mais la milice aussi. Cela ne faisait pas partie de l\'accord et vous devez réévaluer la situation en conséquence. | Alors que vous approchez de %location%, %randombrother% revient vers vous avec un rapport de reconnaissance. Apparemment, il n\'y a pas que des paysans là-bas. Quelques miliciens sont dans la région. Si vous faites cela, vous allez devoir les combattre aussi. Que faire maintenant ? | La Milice ! Ils ne faisaient pas du tout partie du plan ! Si vous allez de l\'avant, vous devrez vous occuper d\'eux avec les paysans. Il est temps de bien réfléchir à tout cela... | Qu\'est-ce que c\'est ? Vous voyez des miliciens qui marchent autour de %location%. Maintenant, vous allez devoir vous battre pour de vrai si vous voulez accomplir votre tâche. | Alors que vous vous préparez à attaquer %location%, %randombrother% vous fait remarquer quelque chose au loin. En plissant les yeux, vous apercevez ce qui ressemble à des miliciens. Cela ne faisait pas partie de l\'accord ! Vous pouvez quand même passer à l\'attaque, mais il y aura de la résistance...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Encerclez-les !",
					function getResult()
					{
						this.Flags.set("IsEncircled", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "Attaquer d\'un côté !",
					function getResult()
					{
						this.Flags.set("IsEncircled", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Done",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_02.png[/img]{Le massacre a été un succès. Vous prenez des torches et laissez la place à des ruines fumantes. | Une odeur de cuivre flotte dans l\'air tandis que vous enjambez et contournez les corps des paysans. Vous hochez la tête pour admirer votre travail, puis regardez %randombrother% et donnez l\'ordre.%SPEECH_ON%Brûlez tout.%SPEECH_OFF% | Ils se sont un peu plus battus que prévu, mais vous les avez finalement tous tués. Ou, du moins, vous l\'espérez. Ne voulant pas faire les choses à moitié, vous mettez le feu à tous les bâtiments en vue. | Vous avez apporté la ruine à %location%. Ses habitants ont été tués, et ses bâtiments incendiés. Un bon travail de tous les jours pour un mercenaire. | Les morts sont partout et l\'odeur fraîche et douce de leur mort tourne déjà au vinaigre. N\'étant pas du genre à vous attarder sur une odeur nauséabonde, vous mettez rapidement %location% en feu et partez. | ...et ainsi la  \"résistance\" est mise à terre. Quelques corps ici, quelques uns là. Vous espérez les avoir tous eus. Il ne reste plus qu\'à tout réduire en cendres et à partir. | Eh bien, c\'est pour cela que vous êtes venu ici. Vous avez quelques hommes qui exhibent les cadavres d\'une manière que vous trouvez \"informative\", et ensuite quelques autres mercenaires incendient tous les bâtiments en vue.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous en avons fini ici.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-5);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Settlement, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Betrayal1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Vous arrivez à %location% et vous êtes accueilli par un groupe d\'hommes lourdement armés. L\'un d\'entre eux s\'avance, les pouces enfoncés dans une ceinture qui tient une épée.%SPEECH_ON%Eh bien, eh bien, vous êtes vraiment stupide. %employer% n\'oublie pas facilement - et il n\'a pas oublié la dernière fois que vous avez trahi %faction%. Considérez ceci comme un petit... retour de baton.%SPEECH_OFF%Soudain, tous les hommes derrière l\'homme chargent en avant. Armez-vous, c\'est une embuscade ! | Vous entrez dans %location%, mais les villageois semblent préparés : vous voyez des fenêtres se fermer et des portes claquer. Au moment où vous allez donner l\'ordre à la compagnie de commencer le massacre, un groupe d\'hommes sort de derrière un bâtiment.\n\nIls sont... considérablement plus armés qu\'un groupe de non-professionnels. En fait, ils portent la bannière de %employer%. Vous réalisez que vous avez été piégé au moment où les hommes commencent à charger et vous aboyez rapidement un ordre pour que vos hommes s\'arment. | Un homme vous attend sur la route juste à l\'extérieur de la %location%. Il est bien armé, bien protégé, et apparemment très heureux, souriant d\'un air penaud en vous approchant.%SPEECH_ON%Bonsoir, mercenaires. %employer% vous envoie ses salutations.%SPEECH_OFF%À ce moment-là, un groupe d\'hommes surgit des côtés de la route. C\'est une embuscade ! Ce maudit noble vous a trahi ! | Vous mettez le pied dans %location%, mais tout ce qui vous accueille est une rafale de vent solitaire qui gémit entre de vieux bois. Pensant vous être fait avoir, vous sortez votre épée.%SPEECH_ON%Bien vu.%SPEECH_OFF%La voix vient d\'un bâtiment, et un homme en sort, dégainant une lame de sa propre main. Une suite d\'hommes armés portant les couleurs de %faction% le suit au pas de course, leur groupe se déployant pour dévisager votre compagnie.%SPEECH_ON%Je vais prendre plaisir à arracher cette épée de votre poigne froide.%SPEECH_OFF%Vous haussez les épaules et demandez pourquoi vous avez été piégé.%SPEECH_ON%%employer% n\'oublie pas ceux qui le trahissent, lui ou sa famille. C\'est à peu près tout ce que vous devez savoir. Ce n\'est pas comme si ce que je disais ici vous servira quand vous serez mort.%SPEECH_OFF%Aux armes, alors, car c\'est une embuscade ! | %location% est vide. Vos hommes parcourent les bâtiments et ne trouvent pas âme qui vive. Soudain, quelques hommes se pressent sur la route derrière vous, le chef du groupe s\'avançant avec de mauvaises intentions. Il a un tissu brodé avec le sigle de %employer%.%SPEECH_ON%C\'est bien calme, n\'est-ce pas ? Si vous vous demandez pourquoi je suis là, c\'est pour payer une dette à %faction%. Vous aviez promis une tâche bien faite. Vous n\'avez pas pu tenir votre promesse. Vous allez mourir.%SPEECH_OFF%Vous dégainez votre épée et pointez la lame vers le chef ennemi.%SPEECH_ON%On dirait que %faction% est sur le point de voir une autre promesse brisée.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.CombatID = "Defend";
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[this.Contract.m.Destination.getTile().Type];
						p.Tile = this.World.getTile(this.World.worldToTile(this.World.State.getPlayer().getPos()));
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 150 * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Vous essuyez votre épée sur votre pantalon et la rengainez rapidement. Les embusqueurs gisent morts, embrochés dans telle ou telle pose grotesque. %randombrother% s\'approche et demande ce qu\'il faut faire maintenant. Il semblerais que %faction% ne soit plus en bons termes avec la compagnie. | Vous frappez le corps mort d\'un embusqueur du bout de votre épée. On dirait que %faction% ne va pas être en très bons termes avec vous à partir de maintenant. La prochaine fois, quand vous accepterez de faire quelque chose pour ces gens, faites-le vraiment. | Eh bien, si rien d\'autre, ce qui peut être appris de cela est de ne pas accepter une tâche que vous ne pouvez pas terminer. Les habitants de ces terres ne sont pas particulièrement amicaux envers ceux qui ne tiennent pas leurs promesses... | Vous avez trahi %faction%, mais il ne faut pas s\'attarder là-dessus. Ils vous ont trahis, c\'est ce qui est important maintenant ! Et à l\'avenir, vous devrez vous méfier d\'eux et de tous ceux qui portent leur bannière. | %employer%, à en juger par les hommes de main morts à vos pieds, semble ne plus être satisfait de vous. Si vous deviez deviner, c\'est à cause de quelque chose que vous avez fait dans le passé - trahison, échec, retour de bâton, coucher avec la fille d\'un noble ? Tout se tient quand on essaie d\'y réfléchir. Ce qui est important maintenant, c\'est que ce fossé entre vous deux ne sera pas facilement comblé. Vous feriez mieux de vous méfier des hommes de %faction% pendant un certain temps.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Qu\'ils soient maudits !",
					function getResult()
					{
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_61.png[/img]{Vous retournez voir %employer% et lui annoncez la nouvelle. Il s\'assied et acquiesce.%SPEECH_ON%Tous ?%SPEECH_OFF%Vous regardez autour de vous.%SPEECH_ON%Vous avez entendu quelqu\'un en parler ?%SPEECH_OFF%%employer% sourit et secoue la tête.%SPEECH_ON%Seulement des nouvelles d\'un événement terrible, bien sûr. Maudits brigands.%SPEECH_OFF%Il claque des doigts et un homme sort apparemment de l\'obscurité pour vous payer votre récompense. | %employer% accueille votre retour en vous offrant un verre. Il sourit chaleureusement pour un homme qui vient d\'ordonner le massacre de paysans.%SPEECH_ON%La nouvelle circule que %location% a été réduite en cendre.%SPEECH_OFF%Vous acquiescez.%SPEECH_ON%Des brigands, hein ?%SPEECH_OFF%%employer% sourit. Il vous tend une sacoche de couronnes.%SPEECH_ON%Des brigands en effet.%SPEECH_OFF% | Avec %location% détruit, vous retournez à dire à %employer% la nouvelle. Il y a quelques habitants à ses côtés, alors vous lui annoncez que des \"brigands\" ont attaqué l\'endroit. Il acquiesce, inquiet, mais d\'un habile tour de passe-passe, il te glisse une sacoche de couronnes. Il se tourne ensuite vers les habitants et dit qu\'il faut faire quelque chose pour régler le problème des brigands... | Vous racontez vos succès à %employer%. Il sourit, puis appelle une foule de roturiers à lui. Il annonce que des \"brigands\" ont détruit %location% et qu\'il va devoir augmenter les impôts pour faire face à ce nouveau problème. Lorsqu\'il a fini de parler, il se retourne et glisse une sacoche de couronnes dans votre manteau. | Vous entrez dans la maison de %employer%. Il y a une femme à ses côtés qui sanglote. Quand vous le regardez, il secoue la tête. En hochant la tête, vous lui parlez des \"nouvelles\".%SPEECH_ON%Hum... les brigands... ont détruit %location%.%SPEECH_OFF%%employer% acquiesce solennellement.%SPEECH_ON%Oui, oui, je sais. La veuve ici présente m\'a tout raconté. Des nouvelles tragiques. Très tragiques.%SPEECH_OFF%L\'un des employés de l\'homme vous remet une sacoche de couronnes en partant.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Un salaire honnête pour un travail honnête. | Les affaires sont les affaires.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess);
						this.World.Contracts.finishActiveContract();
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
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_61.png[/img]{Vous entrez dans %townname% pour trouver un certain nombre de paysans familiers se tenant autour de %employer%. Craignant qu\'ils ne vous reconnaissent, vous restez hors de vue. Ils crient que des brigands ont détruit %location%. %employer% a l\'air inquiet.%SPEECH_ON%Vraiment ? Oh, c\'est affreux ! Je vais m\'en occuper. N\'ayez crainte, je vais vous protéger !%SPEECH_OFF%Au moment où l\'homme termine, un de ses gardes vous glisse une sacoche de couronnes. | Vous entrez dans la demeure de %employer% pour trouver un certain nombre de paysans ensanglantés autour de son bureau. Vous restez caché pendant qu\'ils terminent leur conversation et partent. %employer% vous fait signe d\'entrer.%SPEECH_ON%Des brigands. Ils ont dit que les brigands l\'ont fait. Parfait. Votre paiement est dans le coin de la pièce.%SPEECH_OFF% | %employer% salue votre retour avec un sourire.%SPEECH_ON%Il y avait des survivants.%SPEECH_OFF%Il rejette votre inquiétude.%SPEECH_ON%Ils pensent que des brigands sont responsables. Un simple raid par des vagabonds. Vous n\'avez rien à craindre. Votre paiement...%SPEECH_OFF%Il fait glisser une sacoche sur son bureau. Vous la prenez et acquiescez.%SPEECH_ON%C\'est un plaisir de faire affaire avec vous.%SPEECH_OFF% | %employer% pose un parchemin sur son bureau lorsque vous entrez.%SPEECH_ON%Vous avez laissé certains d\'entre eux en vie ! Mais... ça va aller. Ils pensent que des brigands sont responsables.%SPEECH_OFF%Vous mettez une main sur la poignée de votre épée et jetez un coup d\'œil à l\'un des gardes de %employer%.%SPEECH_ON%J\'attends toujours d\'être payé en totalité.%SPEECH_OFF%%employer% fait un signe de la main vers son bureau où se trouve une sacoche.%SPEECH_ON%Bien sûr. Mais la prochaine fois que je vous demande de faire quelque chose, j\'attends de vous que vous le fassiez entièrement, compris ?%SPEECH_OFF% | Une foule de paysans a encerclé %employer%. Vous vous demandez brièvement s\'ils sont sur le point de lyncher l\'homme, mais au lieu de cela, il les fait partir. Alors qu\'il les regarde tourner au coin de la rue, il explique qu\'il s\'agit de survivants de %location%. Avant que vous ne puissiez dire un mot de plus, l\'homme rejette votre inquiétude.%SPEECH_ON%Ils pensent toujours que les brigands sont responsables, mais je ne suis pas heureux de ce résultat. Ça aurait pu très mal tourner pour nous. Pour moi, je veux dire.%SPEECH_OFF%Vous acquiescez et demandez s\'il veut que vous tuiez ces quelques survivants, juste pour être sûr. %employer% secoue la tête.%SPEECH_ON%Non, pas besoin de ça. Voici votre paiement comme promis, mercenaire. La prochaine fois, cependant, assurez-vous de suivre mes ordres.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Un salaire honnête pour un travail honnête. | Les affaires sont les affaires.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictory);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Fulfilled a contract");
						this.World.Contracts.finishActiveContract();
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
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{En entrant dans la demeure de %employer% il se retourne et pose sur sa table un dessin.%SPEECH_ON%Vous reconnaissez cette personne ?%SPEECH_OFF%Vous le ramassez. Le visage esquissé ressemble remarquablement au vôtre. %employer% se penche en arrière.%SPEECH_ON%Ils savent que quelqu\'un vous a engagé pour attaquer cet endroit. Foutez le camp d\'ici avant que mes hommes ne vous écrasent.%SPEECH_OFF% | %SPEECH_ON%Survivants ! Survivants ! Qu\'est-ce que j\'ai dit, \"pas de survivants\", je crois que j\'ai dit ça, non ?%SPEECH_OFF%Vous hochez la tête alors que %employer% froisse ses mains contre son bureau.%SPEECH_ON%Alors pourquoi diable des paysans viennent-ils ici en criant que des mercenaires ont pris d\'assaut leur maison ? Les morts ne parlent pas, mais qui le fait ? Qui parle, mercenaire ?%SPEECH_OFF%Vous vous levez.%SPEECH_ON%Survivants.%SPEECH_OFF%%employer% pointe vers la porte.%SPEECH_ON%Bien. Maintenant, dégagez de ma vue.%SPEECH_OFF% | Vous hochez la tête lorsque %employer% vous annonce la nouvelle : quelques paysans se sont échappés et ont fait courir le bruit qu\'il s\'agissait de \"tueurs à gages\" pour détruire %location%. Mais vous vous demandez...%SPEECH_ON%On peut garder tout l\'équipement qu\'on a trouvé ?%SPEECH_OFF%%employer% rit.%SPEECH_ON%Vous pouvez garder ce que vous voulez, mais vous ne verrez pas une seule couronne sortir de mes poches. Sortez d\'ici, mercenaire.%SPEECH_OFF% | Malheureusement, il semble que quelques paysans aient survécu au massacre. Ils ont raconté à %employer% des détails très particuliers, à savoir que des hommes bien armés et mal intentionnés ont détruit %location%. Pas des brigands, mais des mercenaires. Vous étiez censé les tuer tous, sans laisser de survivants, mais maintenant... eh bien, maintenant vous n\'êtes pas payé. | %employer% est assis en face de vous, il serre le poing, son visage devient rouge. Il demande comment il va pouvoir augmenter les impôts pour protéger les gens des brigands si tout le monde pense que les mercenaires ont été engagés pour détruire %location%. Vous demandez ce qu\'il veut dire et l\'homme est très franc avec vous : quelques paysans ont survécu, espèce d\'idiot. Laisser des survivants ne faisait pas partie de la description du travail, il me semble, et maintenant le paiement de %employer% fera pas partie de votre trésorerie.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Ils ne nous accueilleront pas à %settlementname%...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail);
						this.Contract.m.Destination.getSettlement().getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Raided " + this.Flags.get("DestinationName"));
						this.World.Contracts.finishActiveContract();
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
			"settlementname",
			this.m.Flags.get("SettlementName")
		]);
		_vars.push([
			"noblehousename",
			this.World.FactionManager.getFaction(this.m.Faction).getNameOnly()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setFaction(this.m.Destination.getSettlement().getFaction());
				this.m.Destination.setOnCombatWithPlayerCallback(null);
				this.m.Destination.setAttackable(false);
				this.m.Destination.clearTroops();
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.World.FactionManager.isGreaterEvil())
		{
			return false;
		}

		if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isActive())
		{
			return false;
		}

		if (this.m.Settlement == null || this.m.Settlement.isNull())
		{
			return false;
		}

		return true;
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

		if (this.m.Settlement != null && !this.m.Settlement.isNull())
		{
			_out.writeU32(this.m.Settlement.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local dest = _in.readU32();

		if (dest != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(dest));
		}

		local settlement = _in.readU32();

		if (settlement != 0)
		{
			this.m.Settlement = this.WeakTableRef(this.World.getEntityByID(settlement));
		}

		this.contract.onDeserialize(_in);
	}

});

