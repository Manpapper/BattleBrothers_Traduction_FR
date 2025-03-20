this.defend_settlement_bandits_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Reward = 0,
		Kidnapper = null,
		Militia = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_settlement_bandits";
		this.m.Name = "Défendre la Colonie";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 700 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Defendez %townname% et ses alentours contre les groupes de pillards"
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
				local nearestBandits = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getSettlements());
				local nearestZombies = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements());

				if (nearestZombies.getTile().getDistanceTo(this.Contract.m.Home.getTile()) <= 20 && nearestBandits.getTile().getDistanceTo(this.Contract.m.Home.getTile()) > 20)
				{
					this.Flags.set("IsUndead", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 20)
					{
						this.Flags.set("IsKidnapping", true);
					}
					else if (r <= 40)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsMilitia", true);
						}
					}
					else if (r <= 50 || this.World.FactionManager.isUndeadScourge() && r <= 70)
					{
						if (nearestZombies.getTile().getDistanceTo(this.Contract.m.Home.getTile()) <= 20)
						{
							this.Flags.set("IsUndead", true);
						}
					}
				}

				local number = 1;

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					number = number + this.Math.rand(0, 1);
				}

				if (this.Contract.getDifficultyMult() >= 1.1)
				{
					number = number + 1;
				}

				local locations = this.Contract.m.Home.getAttachedLocations();
				local targets = [];

				foreach( l in locations )
				{
					if (l.isActive() && !l.isMilitary() && l.isUsable())
					{
						targets.push(l);
					}
				}

				number = this.Math.min(number, targets.len());
				this.Flags.set("ActiveLocations", targets.len());

				for( local i = 0; i != number; i = ++i )
				{
					local party;

					if (this.Flags.get("IsUndead"))
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Zombies, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
					else
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Bandits, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}

					party.setAttackableByAI(false);
					local c = party.getController();
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					local t = this.Math.rand(0, targets.len() - 1);

					if (i > 0)
					{
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(4.0 * i);
						c.addOrder(wait);
					}

					local move = this.new("scripts/ai/world/orders/move_order");
					move.setDestination(targets[t].getTile());
					c.addOrder(move);
					local raid = this.new("scripts/ai/world/orders/raid_order");
					raid.setTime(40.0);
					raid.setTargetTile(targets[t].getTile());
					c.addOrder(raid);
					targets.remove(t);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0 || this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyGone = true;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 1200.0)
						{
							isEnemyGone = false;
							break;
						}
					}

					if (isEnemyGone)
					{
						if (this.Flags.get("HadCombat"))
						{
							this.Contract.setScreen("ItsOver");
							this.World.Contracts.showActiveContract();
						}

						this.Contract.setState("Return");
						return;
					}
				}

				if (!this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyHere = false;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 700.0)
						{
							isEnemyHere = true;
							break;
						}
					}

					if (isEnemyHere)
					{
						this.Flags.set("IsEnemyHereDialogShown", true);

						foreach( id in this.Contract.m.UnitsSpawned )
						{
							local p = this.World.getEntityByID(id);

							if (p != null && p.isAlive())
							{
							}
						}

						if (this.Flags.get("IsUndead"))
						{
							this.Contract.setScreen("UndeadAttack");
						}
						else
						{
							this.Contract.setScreen("DefaultAttack");
						}

						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsKidnapping") && !this.Flags.get("IsKidnappingInProgress") && this.Contract.m.UnitsSpawned.len() == 1)
				{
					local p = this.World.getEntityByID(this.Contract.m.UnitsSpawned[0]);

					if (p != null && p.isAlive() && !p.isHiddenToPlayer() && !p.getController().hasOrders())
					{
						local c = p.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
						c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(true);
						this.Contract.m.Kidnapper = this.WeakTableRef(p);
						this.Flags.set("IsKidnappingInProgress", true);
						this.Flags.set("KidnappingTooLate", this.Time.getVirtualTimeF() + 60.0);
						this.Contract.setScreen("Kidnapping1");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Kidnapping");
					}
				}

				if (this.Flags.get("IsMilitia") && !this.Flags.get("IsMilitiaDialogShown"))
				{
					this.Flags.set("IsMilitiaDialogShown", true);
					this.Contract.setScreen("Militia1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

		});
		this.m.States.push({
			ID = "Kidnapping",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Sauvez les prisonniez qui sont enlevés",
					"Retournez à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Kidnapper == null || this.Contract.m.Kidnapper.isNull() || !this.Contract.m.Kidnapper.isAlive())
				{
					if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() <= 5.0)
					{
						this.Flags.set("IsKidnapping", false);
						this.Contract.setScreen("Kidnapping2");
					}
					else
					{
						this.Contract.setScreen("Kidnapping3");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (this.Contract.m.Kidnapper.isHiddenToPlayer() && this.Time.getVirtualTimeF() > this.Flags.get("KidnappingTooLate"))
				{
					this.Contract.setScreen("Kidnapping3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
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
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(true);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local locations = this.Contract.m.Home.getAttachedLocations();
					local numLocations = 0;

					foreach( l in locations )
					{
						if (l.isActive() && !l.isMilitary() && l.isUsable())
						{
							numLocations = ++numLocations;
						}
					}

					if (numLocations == 0 || this.Flags.get("ActiveLocations") - numLocations >= 2)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Failure2");
						}
						else
						{
							this.Contract.setScreen("Failure1");
						}
					}
					else if (this.Flags.get("ActiveLocations") - numLocations >= 1)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Success4");
						}
						else
						{
							this.Contract.setScreen("Success2");
						}
					}
					else if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
					{
						this.Contract.setScreen("Success3");
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
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% regarde par la fenêtre. Il vous fait signe de le rejoindre.%SPEECH_ON%Regardez ces gens.%SPEECH_OFF%Il y a une foule de gens en bas, qui se plaignent de ceci ou de cela.%SPEECH_ON%Des brigands parcourent ces régions depuis un certain temps maintenant et les gens pensent qu\'ils sont sur le point de nous attaquer en grand nombre.%SPEECH_OFF%L\'homme ferme les rideaux et va allumer une bougie. Il parle au-dessus d\'elle, son souffle faisant vaciller la flamme.%SPEECH_ON%On a besoin de vous pour nous protéger, mercenaire. Si vous pouvez arrêter ces brigands, vous serez grassement payé. Êtes-vous intéressé ?%SPEECH_OFF% | Quelques paysans errent à l\'extérieur des couloirs de la salle. On peut entendre leurs hurlements et ils sont d\'un ton nerveux. %employer% se verse un verre et le sirote d\'une main tremblante.%SPEECH_ON%Je vais être clair avec vous, mercenaire. Nous avons beaucoup, beaucoup de rapports indiquant que des brigands sont sur le point d\'attaquer cette ville. Si vous voulez savoir, ces rapports sont arrivés par le biais de femmes et d\'enfants morts. Clairement, nous n\'avons aucune raison de douter du sérieux de ces rapports. Donc, la question est, allez-vous nous protéger ?%SPEECH_OFF% | %employer% regarde des papiers sur son bureau. Vous prenez un siège et demandez ce qu\'il veut.%SPEECH_ON%Bonjour, mercenaire. Nous avons un problème dont je pense que vous allez... exceller à vous occuper.%SPEECH_OFF%Vous lui demandez d\'être franc avec vous et il va droit au but.%SPEECH_ON%Des brigands ont brûlé quelques maisons et masures à l\'extérieur de la ville. Les nouvelles disent qu\'ils préparent une attaque plus importante et plus violente. J\'ai besoin de vous ici pour les arrêter. Pensez-vous pouvoir accomplir cette tâche ?%SPEECH_OFF% | %employer% fixe son étagère, dos à vous. Il parle d\'un ton sombre.%SPEECH_ON%C\'est dommage que peu de gens puissent les lire. Peut-être que nos problèmes disparaîtraient s\'ils le pouvaient. Ou peut-être qu\'ils ne feraient qu\'empirer.%SPEECH_OFF%Il secoue la tête et se retourne.%SPEECH_ON%Il y a une bande de brigands qui va bientôt nous attaquer. J\'ai besoin de vous, mercenaire, pour les arrêter. Mes livres ne le feront pas. Si le salaire est bon, et je vous promets qu\'il le sera, êtes-vous partant ?%SPEECH_OFF% | %employer% a deux papiers en main. Il y a des visages dessinés dessus.%SPEECH_ON%On a attrapé ces deux-là l\'autre jour. On les a pendus et on a brûlé les restes.%SPEECH_OFF%Vous haussez les épaules.%SPEECH_ON%Félicitations ?%SPEECH_OFF%L\'homme n\'est pas très amusé.%SPEECH_ON%Maintenant, nous avons appris que leurs amis brigands viennent pour se venger ! Et, oui, nous avons besoin de votre aide pour les repousser. Êtes-vous intéressé ?%SPEECH_OFF% | Vous vous installez dans le bureau de %employer%, prenez un siège, frottez vos mains sur le cadre en bois. C\'est un bon chêne. Un arbre qui vaut la peine de s\'y asseoir.%SPEECH_ON%Content que vous soyez à l\'aise, mercenaire, mais moi pas du tout. Nous avons beaucoup, beaucoup d\'avertissements qu\'un grand groupe de brigands est sur le point d\'attaquer notre ville. Nous sommes à court de moyens de défense, mais pas à court de couronnes. Évidemment, c\'est là que vous intervenez. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% frappe une tasse contre le mur. Elle s\'éparpille, tourne et virevolte, des taches de vin parsèment votre joue.%SPEECH_ON%Vagabonds ! Brigands ! Maraudeurs ! Ça n\'en finit jamais !%SPEECH_OFF%Il vous tend distraitement une serviette.%SPEECH_ON%Maintenant, j\'apprends qu\'un grand groupe de ces voyous va venir brûler cette ville ! Eh bien, j\'ai quelque chose en réserve pour eux : vous. Qu\'en dites-vous, mercenaire ? Acceptez-vous de nous défendre ?%SPEECH_OFF% | On peut entendre quelques femmes en deuil gémir juste à l\'extérieur de le bureau de %employer%. Il se tourne vers vous.%SPEECH_ON%Vous entendez ça ? C\'est ce qui arrive quand les brigands viennent ici. Ils volent, ils violent, et ils assassinent.%SPEECH_OFF%Vous acquiescez. C\'est, après tout, la façon de faire du brigand.%SPEECH_ON%Maintenant, certains paysans de l\'arrière-pays disent que les voyous se préparent à un assaut massif sur notre village. Vous devez faire quelque chose pour nous aider, mercenaire. Heh, bien sûr quand je dis \"devez\". Ce que je veux vraiment dire, c\'est que nous allons vous payer pour nous aider...%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combien est prêt à payer %townname% pour leur sécurité? | Ça devrait valoir une bonne quantité de couronnes pour vous, non ?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{J\'ai bien peur que vous allez devoir vous débrouiller seul. | Nous avons d\'autres importants problèmes à régler. | Je vous souhaite bonne chance, mais nous ne participerons pas à cela.}",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							this.World.Contracts.removeContract(this.Contract);
							return 0;
						}
						else
						{
							return "Plea";
						}
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Plea",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Alors que vous quittez %employer% avec un refus, vous sortez et trouvez une foule de paysans debout. Chacun d\'entre eux tient dans ses mains une sorte de curiosité, le genre de richesse que les laïcs peuvent se procurer du mieux qu\'ils peuvent : des poulets, des colliers bon marché, des vêtements usés, du matériel de forgeron rouillé, la liste des objets est longue. Une personne fait un pas en avant, un poulet sous chaque bras.%SPEECH_ON%S\'il vous plaît ! Vous ne pouvez pas partir ! Vous devez nous aider !%SPEECH_OFF%%randombrother% rires, mais vous devez admettre que les pauvres gens savent comment tirer une corde sensible ou deux. Peut-être que vous devriez rester et aider après tout ? | Lorsque vous quittez %employer%, vous sortez pour trouver une femme debout avec sa progéniture courant autour et entre ses jambes et un bébé qui lui suce le téton.%SPEECH_ON%Mercenaire, s\'il te plaît, vous ne devez pas nous laisser comme ça ! Cette ville a besoin de vous ! Les enfants ont besoin de vous !%SPEECH_OFF%Elle marque une pause, puis abaisse l\'autre côté de sa chemise, révélant une tentation plutôt salace et séduisante.%SPEECH_ON%J\'ai besoin de vous...%SPEECH_OFF%Vous levez la main, à la fois pour l\'arrêter et pour essuyer votre front soudainement en sueur. Peut-être qu\'aider ces deux, euh, pauvres gens ne serait pas si mal après tout ? | Alors que vous vous apprêtez à quitter %townname%, un petit chiot court vers vous en aboyant et en léchant vos bottes. Un enfant encore plus petit est à sa poursuite, pratiquement sur le bout de sa queue. L\'enfant se jette sur le cabot et enroule ses bras autour de sa fourrure nappée.%SPEECH_ON%Oh {Marley | Yeller | Jo-Jo}, Je t\'aime tellement !%SPEECH_OFF%Une image de brigands massacrant l\'enfant et son animal de compagnie vous traverse l\'esprit. Vous avez mieux à faire que de jouer au shérif et au gendarme contre de vulgaires voleurs, mais le chien continue de lécher le visage du garçon et l\'enfant semble si heureux.%SPEECH_ON%Haha ! Nous allons vivre pour toujours et à jamais, n\'est-ce pas ? Pour toujours et à jamais !%SPEECH_OFF%Bordel de merde. | Un homme s\'approche de vous alors que vous quittez la maison de %employer%.%SPEECH_ON%Monsieur, j\'ai entendu que vous avez refusé l\'offre de cet homme. C\'est une honte, c\'est tout ce que je voulais dire. Je pensais qu\'il y avait beaucoup d\'hommes bons dans ce monde, mais je suppose que j\'avais tort. Bonne chance pour votre voyage, et j\'espère que vous prierez pour nous lors de vos déplacements.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = false,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Merde, on ne peut pas laisser ces gens mourir. | Bien, bien, nous ne quitterons pas %townname%. Parlons du paiement, au moins.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Je suis sûr que vous allez vous en sortir. Laissez nous passer. | Je ne vais pas risquer %companyname% pour sauver quelques paysans affamés.}",
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
			ID = "UndeadAttack",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Alors que vous montez la garde, un paysan fou arrive en courant vers vous. Il est bouche bée, hors d\'haleine. Les mains sur les genoux, il vomit presque les mots :%SPEECH_ON%Les morts... ils arrivent !%SPEECH_OFF%En regardant par-dessus lui, vous voyez en effet une foule de créatures plutôt pâles qui s\'agitent au loin. | Pas de brigands ici, mais des morts-vivants ! Alors que vous attendez que les voyous et les mécréants déboulent dans la ville, vous apercevez au contraire une grande foule de créatures ambulantes qui se dirige vers vous. Ce n\'est pas parce que la cible change que le contrat change aussi - préparez-vous ! | Les cloches d\'alarme sonnent depuis la chapelle de la ville. Vous les écoutez en regardant l\'horizon. Elles continuent à sonner. Un habitant se tient à vos côtés.%SPEECH_ON%Un... deux... trois... quatre...%SPEECH_OFF%Il commence à transpirer. Puis ses yeux s\'écarquillent lorsque les cloches sonnent une dernière fois.%SPEECH_ON%C\'est... c\'est impossible.%SPEECH_OFF%Vous demandez de quoi il a peur. Il recule.%SPEECH_ON%Les morts marchent à nouveau sur la terre !%SPEECH_OFF%Super, juste quand vous pensiez qu\'un contrat allait être facile. | Gémissant, grognant, les morts-vivants s\'avancent. Il n\'y a pas de brigands ici - peut-être que ces créatures immondes les ont mangés - mais le contrat n\'est pas caduc : protéger la ville !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DefaultAttack",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_07.png[/img]Les brigands sont en vue ! Préparez-vous au combat et protégez la ville !",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ItsOver",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Le combat est terminé et les hommes se reposent dans un répit bienvenu. %employer%vous attendra en ville. | La bataille terminée, vous examinez les cadavres éparpillés sur le terrain. C\'est un spectacle horrible, mais pour une raison quelconque, cela vous donne de l\'énergie. Les affreuses monticules de morts ne font que vous rappeler la vitalité que vous devez encore céder à ce monde horrible. Des gens comme %employer% devraient venir voir ça, mais il ne le fera pas, alors vous devrez aller le voir à sa place. | La chair et les os sont éparpillés dans le champ, à peine discernables d\'une personne à l\'autre. Des buses noires tournent dans le ciel, des halos d\'ombres en chevrons ondulant au-dessus des morts, les oiseaux attendant que les personnes en deuil aient quitté les lieux. %randombrother% vient à vos côtés et demande s\'ils doivent entamer le voyage de retour pour aller voir %employer%. Vous laissez derrière vous la vue du champ de bataille et acquiescez. | Une sorte de ruine paisible est faite de morts. Comme si c\'était leur état naturel, raidis et à jamais perdus, et que toute leur vie n\'était qu\'une crise fugace d\'un accident finalement arrivé à son terme. %randombrother% s\'approche et vous demande si vous allez bien. Vous n\'êtes pas sûr, pour être honnête, et répondez simplement qu\'il est temps d\'aller voir %employer%. | Des hommes difformes et des cadavres tordus jonchent le sol, car la bataille ne donne aux morts aucune souveraineté sur la façon dont ils trouvent le repos final. Les têtes sans corps ont l\'air plus paisibles, car dans la bataille, aucun homme ou bête n\'a le temps de vraiment trancher un cou, cela ne vient que par le plus rapide et le plus tranchant des coups de lame. Une partie de vous espère partir avec de cette façon immédiate, mais une autre partie espère que vous aurez la chance de faire tomber votre tueur avec vous.\n\n %randombrother% vient à vos côtés et demande des ordres. Vous vous détournez du terrain et dites à  %companyname% de se préparer à retourner voir %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous retournons à l\'hôtel de ville !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ItsOverDidNothing",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_30.png[/img]De la fumée emplit l\'air, de la fumée et l\'odeur caustique du bois qui brûle, des réserves de nourriture qui brûlent. Les habitants de %townname% ont mis tous leurs espoirs dans l\'embauche de %companyname%, une erreur fatale.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ça ne s\'est pas passé comme prévu...",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia1",
			Title = "À %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Alors que vous vous préparez à défendre %townname%, la milice locale s\'est ralliée à votre cause. Elle se soumet à vos ordres, demandant seulement que vous l\'envoyiez là où vous pensez qu\'elle sera la plus utile. | Il semble que la milice locale ait rejoint la bataille ! Un groupe d\'hommes en loques, mais qui sera néanmoins utile. Maintenant la question est, où les envoyer ? | La milice de %townname% a rejoint le combat ! Bien qu\'il s\'agisse d\'une bande d\'hommes mal armés, ils sont impatients de défendre leur maison et leur taudis. Ils se soumettent à votre commandement, en espérant que vous les enverrez là où on a le plus besoin d\'eux. | Vous n\'êtes pas seul dans ce combat ! La milice de %townname% vous a rejoint. Ils sont impatients de se battre et vous demandent où ils seront le plus utiles.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Mettez-vous en ligne, vous serez sous mon commandement.",
					function getResult()
					{
						return "Militia2";
					}

				},
				{
					Text = "Allez défendre l\'hôtel de ville de %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), "Milice de " + home.getName(), false, this.Const.World.Spawn.Militia, home.getResources() * 0.7, this.Contract.getMinibossModifier());
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("Des hommes courageux qui défendent leur foyer au péril de leur vie. Des fermiers, des artisans, des ouvriers - mais pas un seul vrai soldat.");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(home.getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "Go and defend the outskirts of %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), "Milice de " + home.getName(), false, this.Const.World.Spawn.Militia, home.getResources() * 0.7, this.Contract.getMinibossModifier());
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("Des hommes courageux qui défendent leur foyer au péril de leur vie. Des fermiers, des artisans, des ouvriers - mais pas un seul vrai soldat.");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local locations = home.getAttachedLocations();
						local targets = [];

						foreach( l in locations )
						{
							if (l.isActive() && !l.isMilitary() && l.isUsable())
							{
								targets.push(l);
							}
						}

						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(targets[this.Math.rand(0, targets.len() - 1)].getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "Allez vous cacher quelque part et restez hors de notre chemin.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia2",
			Title = "À %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]Maintenant que vous avez décidé de prendre certains des habitants sous votre commandement, ils vous demandent comment ils doivent s\'armer pour la bataille à venir.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prenez des arcs, vous tirerez depuis l\'arrière.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				},
				{
					Text = "Prends une épée et un bouclier, vous allez vous battre au front.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				},
				{
					Text = "Armez-vous comme vous voulez.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia;

							if (this.Math.rand(0, 1) == 0)
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							}
							else
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							}

							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MilitiaVolunteer",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Le combat terminé, un des miliciens qui a aidé à la défense vient vers vous personnellement, se baissant et offrant son épée.%SPEECH_ON%Monsieur, mon séjour dans la ville de %townname% touche à sa fin. Mais les prouesses de %companyname% sont vraiment un spectacle étonnant. Si vous le permettez, monsieur, j\'aimerais me battre à vos côtés et à ceux de vos hommes.%SPEECH_OFF% | Une fois la bataille terminée, l\'un des miliciens de %townname% déclare qu\'il viendra volontiers se battre pour %companyname%. D\'une part parce qu\'il a été très impressionné par les combats du groupe de mercenaires, et d\'autre part parce qu\'être enrôlé dans la défense de la ville n\'est ni sain financièrement ni physiquement.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bienvenue dans %companyname% !",
					function getResult()
					{
						return 0;
					}

				},
				{
					Text = "Ce n\'est pas un endroit pour toi.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping1",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Alors que vous surveillez les brigands, un paysan vient vous dire qu\'un groupe de malfrats a attaqué à proximité, s\'enfuyant avec un groupe d\'otages. Vous secouez la tête, incrédule. Comment ont-ils pu se faufiler et faire ça ? Le paysan secoue lui aussi la tête.%SPEECH_ON%Je croyais que vous deviez nous aider. Pourquoi n\'avez-vous rien fait ?%SPEECH_OFF%Vous demandez si les brigands sont allés loin. Le paysan secoue la tête. On dirait que vous avez encore une chance de les récupérer. | Un homme en haillons, portant une fourche cassée, s\'élance vers votre compagnie. Il se laisse tomber et gémit à vos pieds.%SPEECH_ON%Les brigands ont attaqué ! Où étiez-vous ? Ils ont tué des gens... brûlé certains... et... et ils en ont fait prisonniers ! S\'il te plaît, allez-les sauver !%SPEECH_OFF%Vous regardez %randombrother% et hochez la tête.%SPEECH_ON%Préparez les hommes. Nous devons pourchasser ces voyous avant qu\'ils ne s\'échappent complètement.%SPEECH_OFF% | Vous avez les yeux rivés sur l\'horizon, à l\'affût du moindre signe ou bruit de vagabond ou de vagabonde. Soudain, %randombrother% vient vers vous avec une femme à ses côtés. Elle raconte que les malfrats ont déjà attaqué, tué un grand nombre de paysans et qu\'ils se sont enfuis avec ceux qu\'ils n\'ont pas tués. Le mercenaire acquiesce.%SPEECH_ON%On dirait qu\'ils se sont faufilés entre nous, monsieur.%SPEECH_OFF%Vous n\'avez plus qu\'un seul choix maintenant : aller chercher ces gens ! | En vous postant près de %townname%, vous anticipez l\'attaque des brigands. Vous pensiez que ce serait facile, mais l\'arrivée soudaine d\'un laïc fou vous dit le contraire. Le paysan explique que les maraudeurs ont déjà tendu une embuscade dans les faubourgs. Ils ont massacré tous ceux qu\'ils pouvaient, puis se sont enfuis avec quelques hommes, femmes et enfants. L\'homme, soit ivre, soit en état de choc, marmonne ses supplications.%SPEECH_ON%Ramenez... ramenez-les, voulez-vous ?%SPEECH_OFF% | En faisant le guet, quelques paysans en colère prennent les routes, se précipitant vers vous dans un tourbillon de colère collective.%SPEECH_ON%Je croyais qu\'on vous payait pour nous protéger ! Où étiez-vous ?%SPEECH_OFF%Ils sont couverts de sang. Certains sont à moitié vêtus. Une femme a un sein qui pend, trop en colère pour se soucier de l\'indécence. Vous demandez au groupe de quoi il s\'agit. Un homme, serrant une canne contre sa poitrine, explique que les pillards et les voyous ont déjà attaqué, se rendant dans un hameau voisin. Ils ont massacré tout ce qu\'ils voyaient puis, leur soif de sang assouvie, ont fait le plus de prisonniers possible.\n\nVous acquiescez.%SPEECH_ON%On va les récupérer.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Allons les chercher !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Rengainant votre épée, vous ordonnez à %randombrother% d\'aller libérer les prisonniers. Une litanie de paysans ahuris sont libérés des laisses de cuir, des chaînes et des cages à chiens. Ils vous remercient de votre arrivée opportune, et de la violence que vous avez apportée au brigand. | Les brigands sont massacrés jusqu\'au dernier. Vous envoyez vos hommes sauver tous les paysans qu\'ils peuvent trouver. Chacun se rassemble, s\'embrasse et pleure, fou de bonheur d\'avoir survécu à cette horrible épreuve. | Après avoir tué le dernier brigand dans les parages, vous dites à la compagnie de faire le tour pour libérer les otages que les vagabonds avaient pris. Chacun vient vers vous tour à tour, certains vous baisant la main, d\'autres les pieds. Vous leur dites seulement de retourner à %townname% comme vous le ferez vous-même.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On dirait que c\'est fini.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping3",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Malheureusement, les brigands se sont enfuis avec les otages. Que les dieux soient avec ces pauvres âmes maintenant. | Vous n\'avez pas pu le faire - vous n\'avez pas pu sauver ces pauvres paysans. Maintenant, seuls les dieux savent ce qui va leur arriver. | Malheureusement, les maraudeurs se sont enfuis avec leur cargaison humaine à la traîne. Ces pauvres gens vont devoir se débrouiller seuls maintenant. Les histoires que vous entendez, cependant, vous disent qu\'ils ne s\'en sortiront pas bien du tout. | Les brigands se sont enfuis, leurs prisonniers avec eux. Vous n\'avez aucune idée de ce qui va arriver à ces gens maintenant, mais vous savez que ce n\'est pas bon. Esclavage. Torture. La mort. Vous n\'êtes pas sûr de ce qui est le pire.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Ils n\'apprécieront pas cela à %townname%... | Peut-être qu\'ils peuvent être rachetés...}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous retournez voir %employer% avec un air légitimement suffisant.%SPEECH_ON%Le travail est terminé.%SPEECH_OFF%Il fait un signe de tête, en inclinant un gobelet de vin sans nécessairement l\'offrir.%SPEECH_ON%Oui. La ville est éternellement reconnaissante pour votre aide. Ils sont aussi... reconnaissants financièrement.%SPEECH_OFF%L\'homme fait un geste vers le coin de la pièce. Vous y voyez une sacoche de couronnes.%SPEECH_ON%%reward% couronnes, comme nous l\'avions convenu. Merci encore, mercenaire.%SPEECH_OFF% | %employer% accueille votre retour avec un verre de vin.%SPEECH_ON%Buvez, mercenaire, vous l\'avez mérité.%SPEECH_OFF%Il a un goût... particulier. Hautain, si on peut appeler ça un goût. Votre employeur fait le tour de son bureau et s\'assied joyeusement.%SPEECH_ON%Vous avez réussi à protéger la ville comme vous l\'aviez promis ! Je suis très impressionné.%SPEECH_OFF%Il acquiesce, en faisant basculer son gobelet vers un coffre en bois.%SPEECH_ON%Impressionnant.%SPEECH_OFF%Vous ouvrez le coffre pour trouver une ribambelle de couronnes d\'or. | %employer% vous accueille dans sa chambre.%SPEECH_ON%Je regardais de ma fenêtre, vous savez ? J\'ai tout vu. Enfin, presque tout. Les bonnes parties, je suppose.%SPEECH_OFF%Vous levez un sourcil.%SPEECH_ON%Oh, ne me regardez pas comme ça. Je ne me sens pas mal d\'avoir apprécié ce que j\'ai vu. On est en vie, non ? Nous, les gentils.%SPEECH_OFF%L\'autre sourcil se lève.%SPEECH_ON%Eh bien... de toute façon, votre paiement, comme promis.%SPEECH_OFF%L\'homme vous remet un coffre de %reward% couronnes. | Lorsque vous retournez voir %employer%, vous constatez que sa chambre a presque été empaquetée, tout est prêt à être déplacé et à partir. Vous vous inquiétez un peu avec humour.%SPEECH_ON%Vous vous préparez à aller quelque part ?%SPEECH_OFF%L\'homme s\'installe dans son fauteuil.%SPEECH_ON%J\'avais des doutes, mercenaire. Pouvez-vous me blâmer ? Pour ce que ça vaut, vous n\'avez pas à douter de ma capacité à payer.%SPEECH_OFF%Il passe une main sur son bureau. Sur le coin se trouve une sacoche, bosselée et gonflée de pièces de monnaie.%SPEECH_ON%%reward% couronnes, comme promis.%SPEECH_OFF% | %employer% se lève de sa chaise lorsque vous entrez. Il s\'incline, un peu incrédule, mais aussi avec sérieux. Il penche la tête vers la fenêtre où on entend le murmure des paysans heureux.%SPEECH_ON%Vous entendez ça ? Vous l\'avez mérité, mercenaire. Les gens ici vous aiment maintenant.%SPEECH_OFF%Vous acquiescez, mais l\'amour du commun des mortels n\'est pas ce qui vous a amené ici.%SPEECH_ON%Qu\'est-ce que j\'ai gagné d\'autre ?%SPEECH_OFF%%employer% sourit.%SPEECH_ON%Un homme qui ne perd pas le nord. Je parie que c\'est ce qui vous donne votre... tranchant. Bien sûr, vous l\'avez aussi mérité.%SPEECH_OFF%Il soulève un coffre en bois sur son bureau et le déverrouille. L\'éclat des couronnes d\'or vous réchauffe le cœur. | %employer% regarde par la fenêtre quand vous entrez. Il est presque dans un état de rêve, la tête baissée sur sa main. Vous interrompez ses pensées.%SPEECH_ON%Vous pensez à moi ?%SPEECH_OFF%L\'homme rigole et se serre la poitrine.%SPEECH_ON%Vous êtes vraiment l\'homme de mes rêves, mercenaire.%SPEECH_OFF%Il traverse la pièce et prend un coffre sur l\'étagère. Il le déverrouille en le posant sur la table. Un glorieux tas de couronnes d\'or vous regarde en face. %employer% sourit.%SPEECH_ON%Qui rêve maintenant ?%SPEECH_OFF% | %employer% est à son bureau quand vous entrez.%SPEECH_ON%J\'en ai vu une bonne partie. Les meurtres, les morts.%SPEECH_OFF%Vous prenez un siège.%SPEECH_ON%J\'espère que vous avez apprécié le spectacle. Le visionnage n\'est pas gratuit, cependant.%SPEECH_OFF%L\'homme acquiesce, prend une sacoche et vous la remet.%SPEECH_ON%Je paierais bien pour un encore, mais je ne suis pas sûr que %townname% le veuille.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{%companyname% en fera bon usage. | Le paiement d\'une journée de dur labeur.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "A défendu la ville contre les brigands");
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% accueille votre retour en pointant du doigt sa fenêtre.%SPEECH_ON%Vous voyez ça ? Là-bas, au loin.%SPEECH_OFF%Vous le rejoignez. Il demande.%SPEECH_ON%Qu\'est-ce que vous voyez ?%SPEECH_OFF%Il y a de la fumée à l\'horizon. Vous lui faites savoir que c\'est ce que vous voyez.%SPEECH_ON%Oui, de la fumée. Je ne vous ai pas engagé pour que les brigands fassent de la fumée, compris ? Bien sûr... la plupart de la ville est encore debout...%SPEECH_OFF%Il soulève une sacoche jusqu\'à votre poitrine.%SPEECH_ON%Bon travail, mercenaire. Juste... pas assez bon.%SPEECH_OFF% | Vous retournez voir %employer%, il a l\'air d\'un mélange de bonheur et de tristesse, quelque part entre l\'ivresse et la sobriété. Ce n\'est pas le regard que vous voulez voir.%SPEECH_ON%Vous avez bien fait, mercenaire. On dit que vous avez mis ces brigands complètement à terre. On dit aussi qu\'ils ont brûlé une partie de notre périphérie.%SPEECH_OFF%Vous acquiescez. Ça ne vaut pas la peine de mentir sur ce que vous ne pouvez pas cacher.%SPEECH_ON%Vous serez payé, mais vous devez comprendre qu\'il faut de l\'argent pour reconstruire ces zones. Évidemment, les couronnes pour cela sortiront de vos poches...%SPEECH_OFF% | %employer% est avachi dans son siège quand vous revenez.%SPEECH_ON%La plupart des habitants de %townname% sont heureux, mais quelques-uns ne le sont pas. Pouvez-vous deviner lesquels ne le sont pas ?%SPEECH_OFF%Les brigands ont réussi à détruire quelques parties de la périphérie, mais c\'était une question rhétorique.%SPEECH_ON%J\'ai besoin de fonds pour aider à reconstruire les territoires sur lesquels ces maraudeurs ont réussi à mettre la main. Je suis sûr que vous comprenez, alors, pourquoi vous recevrez moins de salaire...%SPEECH_OFF%Vous haussez les épaules. Ainsi soit-il. | %employer% est devant son étagère. Il prend un livre, tourne sur lui-même et l\'ouvre d\'un seul geste. Il le pose sur sa table.%SPEECH_ON%Il y a des chiffres là. Je suis sûr que vous ne pouvez pas les lire, mais voici ce qu\'ils disent : les brigands ont réussi à détruire une partie de la ville et j\'ai maintenant besoin de couronnes pour aider à la reconstruire. Malheureusement, je n\'ai pas beaucoup de couronnes en main pour le faire. Je suis sûr que vous comprenez cette situation difficile.%SPEECH_OFF%Vous hochez la tête et affirmez l\'évidence.%SPEECH_ON%C\'est prélevé sur mon salaire.%SPEECH_OFF%L\'homme acquiesce et fait glisser sa main sur son bureau, attirant votre attention sur une sacoche. Il n\'y a pas lieu de discuter du salaire. Vous prenez la sacoche et vous partez.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{C\'est juste la moitié de ce que nous avions convenu ! | C\'est toujours ça...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "A défendu la ville contre les brigands");
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous retournez voir %employer% avec un air légitimement suffisant.%SPEECH_ON%Le travail est terminé.%SPEECH_OFF%Il fait un signe de tête, en inclinant un gobelet de vin sans nécessairement l\'offrir.%SPEECH_ON%Oui. La ville vous est éternellement reconnaissante pour votre aide. Ils sont aussi... reconnaissants financièrement. %SPEECH_OFF%L\'homme fait un geste vers le coin de la pièce. Vous y voyez une sacoche de couronnes.%SPEECH_ON%%reward% couronnes, comme convenu. Merci encore, mercenaire. Oh et, euh, dommage pour ces paysans...%SPEECH_OFF% | %employer% accueille votre retour avec un verre de vin.%SPEECH_ON%Buvez, mercenaire, vous l\'avez mérité.%SPEECH_OFF%Il a un goût... particulier. Hautain, si on peut appeler ça un goût. Votre employeur fait le tour de son bureau et s\'assied joyeusement.%SPEECH_ON%Vous avez réussi à protéger la ville comme vous l\'aviez promis ! Je suis très impressionné.%SPEECH_OFF%Il acquiesce, en faisant basculer son gobelet vers un coffre en bois.%SPEECH_ON%Impressionnant.%SPEECH_OFF%Vous ouvrez le coffre pour trouver une ribambelle de couronnes d\'or.%SPEECH_ON%Une honte pour les paysans qui ont été pris. Je me suis permis de faire des ajustements en conséquence...%SPEECH_OFF% | %employer% vous accueille dans sa chambre.%SPEECH_ON%Je regardais de ma fenêtre, vous savez ? J\'ai tout vu. Enfin, presque tout. Les bonnes parties, je suppose.%SPEECH_OFF%Vous levez un sourcil.%SPEECH_ON%Oh, ne me regardez pas comme ça. Je ne me sens pas mal d\'avoir apprécié ce que j\'ai vu. On est en vie, non ? Nous, les gentils.%SPEECH_OFF%L\'autre sourcil se lève.%SPEECH_ON%Eh bien... de toute façon, votre paiement, comme promis. J\'ai entendu dire que quelques paysans s\'étaient fait enlevés. J\'ai fait quelques déductions. Cet argent ira aux survivants.%SPEECH_OFF%L\'homme vous remet un coffre de %reward% couronnes. | Lorsque vous retournez voir %employer%, vous constatez que sa chambre a presque été emballée, tout est prêt à être déplacé et à partir. Vous vous inquiétez un peu avec humour.%SPEECH_ON%Vous vous préparez à aller quelque part ?%SPEECH_OFF%L\'homme s\'installe dans son fauteuil.%SPEECH_ON%J\'avais des doutes, mercenaire. Pouvez-vous me blâmer ? Pour ce que ça vaut, vous n\'avez pas à douter de ma capacité à payer.%SPEECH_OFF%Il passe une main sur son bureau. Sur le coin se trouve une sacoche, bosselée et gonflée de pièces de monnaie.%SPEECH_ON%Quelques couronnes de moins que promis. Vous savez ce qui arrivera des paysans avec lesquels les brigands se sont enfuis ? Oui, j\'ai réduit votre salaire pour une raison.%SPEECH_OFF% | %employer% se lève de sa chaise lorsque vous entrez. Il s\'incline, un peu incrédule, mais aussi avec sérieux. Il penche la tête vers la fenêtre où murmure le vacarme des paysans heureux.%SPEECH_ON%Vous entendez ça ? Vous l\'avez mérité, mercenaire. Les gens ici vous aiment maintenant.%SPEECH_OFF%Vous acquiescez, mais l\'amour du commun des mortels n\'est pas ce qui vous a amené ici.%SPEECH_ON%Qu\'est-ce que j\'ai gagné d\'autre ?%SPEECH_OFF%%employer% sourit.%SPEECH_ON%Un homme qui ne perd pas le nord. Je parie que c\'est ce qui vous donne votre... tranchant. Bien sûr, vous l\'avez aussi mérité. Enfin, un peu moins. Une sale affaire à propos de ces paysans avec lesquels vous avez laissé les brigands s\'enfuir, non ?%SPEECH_OFF%Il soulève un coffre en bois sur son bureau et le déverrouille. L\'éclat des couronnes d\'or vous réchauffe le cœur. | %employer% regarde par la fenêtre quand vous entrez. Il est presque dans un état de rêve, la tête baissée sur sa main. Vous interrompez ses pensées.%SPEECH_ON%Vous pensez à moi ?%SPEECH_OFF%L\'homme rigole et se serre la poitrine.%SPEECH_ON%Vous êtes vraiment l\'homme de mes rêves, mercenaire.%SPEECH_OFF%Il traverse la pièce et prend un coffre sur l\'étagère. Il le déverrouille en le posant sur la table. Une glorieuse pile de couronnes d\'or vous regarde en face. %employer% affiche un sourire, mais il s\'efface aussi vite qu\'il était venu.%SPEECH_ON%Un peu plus léger que ce que vous attendiez ? Les familles survivantes de ces paysans que vous avez laissé se faire emporter par les brigands recevront cette part. Je suis sûr que vous comprenez.%SPEECH_OFF% | %employer% est à son bureau quand vous entrez.%SPEECH_ON%J\'en ai vu une bonne partie. Les meurtres, les morts.%SPEECH_OFF%Vous prenez un siège.%SPEECH_ON%J\'espère que vous avez apprécié ce spectacle. Le visionnage n\'est pas gratuit, cependant.%SPEECH_OFF%L\'homme acquiesce, prend une sacoche et vous la remet.%SPEECH_ON%Je paierais bien pour un encore, mais je ne suis pas sûr que %townname% le veuille. Bien sûr, ces pauvres gens qui ont été enlevés par ces voleurs ne veulent pas ce qu\'ils ont eu.%SPEECH_OFF%Vous jetez un coup d\'œil dans le sac et remarquez qu\'il est plus léger de quelques couronnes que prévu.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{C\'est juste la moitié de ce que nous avions convenu ! | C\'est toujours ça...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "A défendu la ville contre les brigands");
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% accueille votre retour en pointant du doigt sa fenêtre.%SPEECH_ON%Vous voyez ça ? Là-bas, au loin.%SPEECH_OFF%Vous le rejoignez. Il demande.%SPEECH_ON%Qu\'est-ce que vous voyez ?%SPEECH_OFF%Il y a de la fumée à l\'horizon. Vous lui faites savoir que c\'est ce que vous voyez.%SPEECH_ON%Oui, de la fumée. Je ne vous ai pas engagé pour que les brigands fassent de la fumée, compris ? Bien sûr... la plupart de la ville est encore debout...%SPEECH_OFF%Il soulève une sacoche jusqu\'à votre poitrine.%SPEECH_ON%Bon travail, mercenaire. Juste... pas assez bon. Et une tristesse pour ces pauvres paysans que vous avez laissé se faire kidnapper par ces maudits brigands.%SPEECH_OFF% | Vous retournez voir %employer%, il a l\'air d\'un mélange de bonheur et de tristesse, quelque part entre l\'ivresse et la sobriété. Ce n\'est pas le regard que vous voulez voir.%SPEECH_ON%Vous avez bien fait, mercenaire. On dit que vous avez mis ces brigands complètement à terre. On dit aussi qu\'ils ont brûlé une partie de notre périphérie.%SPEECH_OFF%Vous acquiescez. Ça ne vaut pas la peine de mentir sur ce que vous ne pouvez pas cacher.%SPEECH_ON%Vous serez payé, mais vous devez comprendre qu\'il faut de l\'argent pour reconstruire ces zones. Et qu\'en est-il de ces pauvres gens que vous avez laissé kidnapper par les raiders ? Leurs familles vont vouloir de l\'aide, aussi. Évidemment, les couronnes pour cela sortiront de vos poches...%SPEECH_OFF% | %employer% est avachi dans son siège quand vous revenez.%SPEECH_ON%La plupart des habitants de %townname% sont heureux, mais quelques-uns ne le sont pas. Pouvez-vous deviner lesquels ne le sont pas ?%SPEECH_OFF%Les brigands ont réussi à détruire quelques parties de la périphérie, mais c\'était une question rhétorique.%SPEECH_ON%J\'ai besoin de fonds pour aider à reconstruire les territoires sur lesquels ces maraudeurs ont réussi à mettre la main. J\'ai également besoin de couronnes pour aider les survivants de ces paysans que vous n\'avez pas réussi à sauver. Je suis sûr que vous comprenez, alors, pourquoi vous recevrez moins de salaire...%SPEECH_OFF%Vous haussez les épaules. Ainsi soit-il. | Il est devant son étagère. Il prend un livre, tourne sur lui-même et l\'ouvre d\'un seul geste. Il le pose sur sa table.%SPEECH_ON%Il y a des chiffres là. Je suis sûr que vous ne pouvez pas les lire, mais voici ce qu\'ils disent : les brigands ont réussi à détruire une partie de la ville et j\'ai maintenant besoin de couronnes pour aider à la reconstruire. Malheureusement, je n\'ai pas beaucoup de couronnes en main pour le faire. Je suis sûr que vous comprenez cette situation difficile.%SPEECH_OFF%Vous hochez la tête et affirmez l\'évidence.%SPEECH_ON%C\'est prélevé sur mon salaire.%SPEECH_OFF%%employer% acquiesce et répond %SPEECH_ON%Oui, et ces paysans avec lesquels vous avez laissé les brigands s\'enfuir ? Ils ont des familles. Des survivants. Ils auront une part de notre \"accord\", eux aussi.%SPEECH_OFF%L\'homme acquiesce et fait glisser une main sur son bureau, attirant votre attention sur une sacoche. Il n\'y a pas lieu de discuter du salaire. Vous prenez la sacoche et vous partez.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{C\'est juste la moitié de ce que nous avions convenu ! | C\'est toujours ça...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(0);
						this.World.Contracts.finishActiveContract();

						if (this.Flags.get("IsUndead") && this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Lorsque vous entrez dans le bureau de %employer%, il vous demande de fermer la porte derrière vous. Au moment où le loquet s\'enclenche, l\'homme vous assène un flot d\'obscénités que vous ne pouvez espérer suivre. Se calmant, sa voix - et son langage - reviennent à un certain niveau de normalité.%SPEECH_ON%Toute notre périphérie a été détruite. Vous pensiez que je vous payais pour quoi, exactement ? Sortez d\'ici.%SPEECH_OFF% | %employer% renverse les gobelets de vin quand vous entrez. Il y a le vacarme des paysans en colère qui crient derrière sa fenêtre.%SPEECH_ON%Vous entendez ça ? Ils auront ma tête si je vous paie, mercenaire. Vous aviez un travail, un travail ! Protéger cette ville. Et vous n\'avez pas pu le faire. Donc maintenant, vous pouvez faire une chose et c\'est gratuit : dégagez de ma vue.%SPEECH_OFF% | %employer% croise les mains sur son bureau. %SPEECH_ON%Qu\'est-ce que vous espérez obtenir ici, exactement ? Je suis surpris que vous soyez revenu me voir. La moitié de la ville est en feu et l\'autre moitié est déjà en cendres. Je ne t\'ai pas engagé pour produire de la fumée et de la désolation, mercenaire. Foutez le camp d\'ici.%SPEECH_OFF% | Quand vous retournez voir %employer%, il tient une chope de bière. Sa main tremble. Son visage est rouge.%SPEECH_ON%Je fais tout ce qui est en mon pouvoir pour ne pas vous jeter ça à la figure.%SPEECH_OFF%Juste au cas où, l\'homme finit la boisson d\'un seul trait. Il le fait claquer sur son bureau.%SPEECH_ON%Cette ville s\'attendait à ce que vous les protégiez. Au lieu de cela, les brigands ont envahi les faubourgs comme s\'ils faisaient un putain de voyage d\'agrément ! Ce n\'est pas mon métier de faire passer du bon temps aux maraudeurs, mercenaire. Foutez le camp d\'ici !%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Maudit soit ce paysan ! | Nous aurions dû demander un paiement plus important à l\'avance... | Merde !}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "N\'a pas réussi à défendre la ville contre les brigands");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Lorsque vous entrez dans le bureau de %employer%, il vous demande de fermer la porte derrière vous. Au moment où le loquet s\'enclenche, l\'homme vous assène un flot d\'obscénités que vous ne pouvez espérer suivre. Se calmant, sa voix - et son langage - reviennent à un certain niveau de normalité.%SPEECH_ON%Toute notre périphérie a été détruite. Des gens ont même été emmenés dans des lieux que seuls les anciens dieux connaissent ! Pour quoi, exactement, pensiez-vous que je vous payais ? Sortez d\'ici.%SPEECH_OFF% | %employer% renverse les gobelets de vin quand vous entrez. Il y a le vacarme des paysans en colère qui crient derrière sa fenêtre.%SPEECH_ON%Vous entendez ça ? Ils auront ma tête si je vous paie, mercenaire. Vous aviez un travail, un travail ! Protéger cette ville. Et vous n\'avez pas pu le faire. Bon sang, vous n\'avez même pas pu sauver ces pauvres paysans qui ont été kidnappés ! Alors maintenant, vous ne pouvez faire qu\'une chose, et c\'est gratuit : dégagez de ma vue.%SPEECH_OFF% | %employer% croise les mains sur son bureau. %SPEECH_ON%Qu\'est-ce que vous espérez obtenir ici, exactement ? Je suis surpris que vous soyez revenu me voir. La moitié de la ville est en feu et l\'autre moitié est déjà en cendres. Les survivants me disent que des membres de leur famille ont même été kidnappés ! Savez-vous ce qui arrive à ceux qui sont pris par les pillards ? Je ne vous ai pas engagé pour produire de la fumée et de la désolation, mercenaire. Foutez le camp d\'ici.%SPEECH_OFF% | Quand vous retournez voir %employer%, il tient une chope de bière. Sa main tremble. Son visage est rouge.%SPEECH_ON%Je fais tout ce qui est en mon pouvoir pour ne pas vous jeter ça à la figure.%SPEECH_OFF%Juste au cas où sa rage prendrait le dessus, l\'homme finit le verre d\'un trait. Il le fait claquer sur son bureau.%SPEECH_ON%Cette ville s\'attendait à ce que vous les protégiez. Au lieu de cela, les brigands ont envahi les faubourgs comme s\'ils faisaient un putain de voyage d\'agrément ! Ce n\'est pas mon métier de faire passer du bon temps aux maraudeurs, mercenaire. Foutez le camp d\'ici !%SPEECH_OFF% | %employer% rit quand vous entrez dans sa chambre.%SPEECH_ON%Les faubourgs sont détruits. Les habitants de %townname% sont en colère, du moins ceux qui sont encore en vie pour être en colère. Et quoi encore ? Vous avez laissé quelques-uns de nos habitants se faire prendre par ces monstres !%SPEECH_OFF% L\'homme secoue la tête et pointe la main vers la porte. %SPEECH_ON% Je ne sais pas pourquoi vous vouliez que je vous paie, mais ce n\'était pas pour ça.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Maudit soit ce paysan ! | Nous aurions dû demander un paiement plus important à l\'avance... | Merde !}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "N\'a pas réussi à défendre la ville contre les brigands");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			local s = this.new("scripts/entity/world/settlements/situations/raided_situation");
			s.setValidForDays(4);
			this.m.SituationID = this.m.Home.addSituation(s);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;

			if (this.m.Kidnapper != null && !this.m.Kidnapper.isNull())
			{
				this.m.Kidnapper.getSprite("selection").Visible = false;
			}

			if (this.m.Militia != null && !this.m.Militia.isNull())
			{
				this.m.Militia.getController().clearOrders();
			}

			this.World.getGuestRoster().clear();
		}
	}

	function onIsValid()
	{
		local nearestBandits = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getSettlements());
		local nearestZombies = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements());

		if (nearestZombies.getTile().getDistanceTo(this.m.Home.getTile()) > 20 && nearestBandits.getTile().getDistanceTo(this.m.Home.getTile()) > 20)
		{
			return false;
		}

		local locations = this.m.Home.getAttachedLocations();

		foreach( l in locations )
		{
			if (l.isUsable() && l.isActive() && !l.isMilitary())
			{
				return true;
			}
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.m.Flags.set("KidnapperID", this.m.Kidnapper != null && !this.m.Kidnapper.isNull() ? this.m.Kidnapper.getID() : 0);
		this.m.Flags.set("MilitiaID", this.m.Militia != null && !this.m.Militia.isNull() ? this.m.Militia.getID() : 0);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
		this.m.Kidnapper = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("KidnapperID")));
		this.m.Militia = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("MilitiaID")));
	}

});

