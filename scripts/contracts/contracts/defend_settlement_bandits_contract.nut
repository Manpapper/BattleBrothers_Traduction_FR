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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% regarde par la fenêtre. Il vous fait signe de le rejoindre.%SPEECH_ON%Regardez ces gens.%SPEECH_OFF%Il y a une foule de gens en bas, qui se plaignent de ceci ou de cela.%SPEECH_ON%Des brigands parcourent ces régions depuis un certain temps maintenant et les gens pensent qu'ils sont sur le point de nous attaquer en grand nombre.%SPEECH_OFF%L'homme ferme les rideaux et va allumer une bougie. Il parle au-dessus d'elle, son souffle faisant vaciller la flamme.%SPEECH_ON%On a besoin de vous pour nous protéger, mercenaire. Si vous pouvez arrêter ces brigands, vous serez grassement payé. Êtes-vous intéressé ?%SPEECH_OFF% | Quelques paysans errent à l'extérieur des couloirs de la salle. On peut entendre leurs hurlements et ils sont d'un ton nerveux. %employer% se verse un verre et le sirote d'une main tremblante.%SPEECH_ON%Je vais être clair avec vous, mercenaire. Nous avons beaucoup, beaucoup de rapports indiquant que des brigands sont sur le point d'attaquer cette ville. Si vous voulez savoir, ces rapports sont arrivés par le biais de femmes et d'enfants morts. Clairement, nous n'avons aucune raison de douter du sérieux de ces rapports. Donc, la question est, allez-vous nous protéger ?%SPEECH_OFF% | %employer% regarde des papiers sur son bureau. Vous prenez un siège et demandez ce qu'il veut.%SPEECH_ON%Bonjour, mercenaire. Nous avons un problème dont je pense que vous allez... exceller à vous occuper.%SPEECH_OFF%Vous lui demandez d'être franc avec vous et il va droit au but.%SPEECH_ON%Des brigands ont brûlé quelques maisons et masures à l'extérieur de la ville. Les nouvelles disent qu'ils préparent une attaque plus importante et plus violente. J'ai besoin de vous ici pour les arrêter. Pensez-vous pouvoir accomplir cette tâche ?%SPEECH_OFF% | %employer% fixe son étagère, dos à vous. Il parle d'un ton sombre.%SPEECH_ON%C'est dommage que peu de gens puissent les lire. Peut-être que nos problèmes disparaîtraient s'ils le pouvaient. Ou peut-être qu'ils ne feraient qu'empirer.%SPEECH_OFF%Il secoue la tête et se retourne.%SPEECH_ON%Il y a une bande de brigands qui va bientôt nous attaquer. J'ai besoin de vous, mercenaire, pour les arrêter. Mes livres ne le feront pas. Si le salaire est bon, et je vous promets qu'il le sera, êtes-vous partant ?%SPEECH_OFF% | %employer% a deux papiers en main. Il y a des visages dessinés dessus.%SPEECH_ON%On a attrapé ces deux-là l'autre jour. On les a pendus et on a brûlé les restes.%SPEECH_OFF%Vous haussez les épaules.%SPEECH_ON%Félicitations ?%SPEECH_OFF%L'homme n'est pas très amusé.%SPEECH_ON%Maintenant, nous avons appris que leurs amis brigands viennent pour se venger ! Et, oui, nous avons besoin de votre aide pour les repousser. Êtes-vous intéressé ?%SPEECH_OFF% | Vous vous installez dans la chambre de %employer%, prenez un siège, frottez vos mains sur le cadre en bois. C'est un bon chêne. Un arbre qui vaut la peine de s'y asseoir.%SPEECH_ON%Content que vous soyez à l'aise, mercenaire, mais moi pas du tout. Nous avons beaucoup, beaucoup d'avertissements qu'un grand groupe de brigands est sur le point d'attaquer notre ville. Nous sommes à court de moyens de défense, mais pas à court de couronnes. Évidemment, c'est là que vous intervenez. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% frappe une tasse contre le mur. Elle s'éparpille, tourne et virevolte, des taches de vin parsèment votre joue.%SPEECH_ON%Vagabonds ! Brigands ! Maraudeurs ! Ça n'en finit jamais !%SPEECH_OFF%Il vous tend distraitement une serviette.%SPEECH_ON%Maintenant, j'apprends qu'un grand groupe de ces voyous va venir brûler cette ville ! Eh bien, j'ai quelque chose en réserve pour eux : vous. Qu'en dites-vous, mercenaire ? Acceptez-vous de nous défendre ?%SPEECH_OFF% | On peut entendre quelques femmes en deuil gémir juste à l'extérieur de la chambre de %employer%. Il se tourne vers vous.%SPEECH_ON%Vous entendez ça ? C'est ce qui arrive quand les brigands viennent ici. Ils volent, ils violent, et ils assassinent.%SPEECH_OFF%Vous acquiescez. C'est, après tout, la façon de faire du brigand.%SPEECH_ON%Maintenant, certains paysans de l'arrière-pays disent que les voyous se préparent à un assaut massif sur notre village. Vous devez faire quelque chose pour nous aider, mercenaire. Heh, bien sûr quand je dis \"devez\". Ce que je veux vraiment dire, c'est que nous allons vous payer pour nous aider...%SPEECH_OFF%}",
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
					Text = "{J'ai bien peur que vous allez devoir vous débrouiller seul. | Nous avons d\'autres importants problèmes à régler. | Je vous souhaite bonne chance, mais nous ne participerons pas à cela.}",
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{Alors que vous quittez %employer% avec un refus, vous sortez et trouvez une foule de paysans debout. Chacun d'entre eux tient dans ses mains une sorte de curiosité, le genre de richesse que les laïcs peuvent se procurer du mieux qu'ils peuvent : des poulets, des colliers bon marché, des vêtements usés, du matériel de forgeron rouillé, la liste des objets est longue. Une personne fait un pas en avant, un poulet sous chaque bras.%SPEECH_ON%S'il vous plaît ! Vous ne pouvez pas partir ! Vous devez nous aider !%SPEECH_OFF%%randombrother% rires, mais vous devez admettre que les pauvres gens savent comment tirer une corde sensible ou deux. Peut-être que vous devriez rester et aider après tout ? | Lorsque vous quittez %employer%, vous sortez pour trouver une femme debout avec sa progéniture courant autour et entre ses jambes et un bébé qui lui suce le téton.%SPEECH_ON%Mercenaire, s'il te plaît, vous ne devez pas nous laisser comme ça ! Cette ville a besoin de vous ! Les enfants ont besoin de vous !%SPEECH_OFF%Elle marque une pause, puis abaisse l'autre côté de sa chemise, révélant une tentation plutôt salace et séduisante.%SPEECH_ON%J'ai besoin de vous...%SPEECH_OFF%Vous levez la main, à la fois pour l'arrêter et pour essuyer votre front soudainement en sueur. Peut-être qu'aider ces deux, euh, pauvres gens ne serait pas si mal après tout ? | Alors que vous vous apprêtez à quitter %townname%, un petit chiot court vers vous en aboyant et en léchant vos bottes. Un enfant encore plus petit est à sa poursuite, pratiquement sur le bout de sa queue. L'enfant se jette sur le cabot et enroule ses bras autour de sa fourrure nappée.%SPEECH_ON%Oh {Marley | Yeller | Jo-Jo}, Je t'aime tellement !%SPEECH_OFF%Une image de brigands massacrant l'enfant et son animal de compagnie vous traverse l'esprit. Vous avez mieux à faire que de jouer au shérif et au gendarme contre de vulgaires voleurs, mais le chien continue de lécher le visage du garçon et l'enfant semble si heureux.%SPEECH_ON%Haha ! Nous allons vivre pour toujours et à jamais, n'est-ce pas ? Pour toujours et à jamais !%SPEECH_OFF%Bordel de merde. | Un homme s'approche de vous alors que vous quittez la maison de %employer%.%SPEECH_ON%Monsieur, j'ai entendu que vous avez refusé l'offre de cet homme. C'est une honte, c'est tout ce que je voulais dire. Je pensais qu'il y avait beaucoup d'hommes bons dans ce monde, mais je suppose que j'avais tort. Bonne chance pour votre voyage, et j'espère que vous prierez pour nous lors de vos déplacements.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_29.png[/img]{Alors que vous montez la garde, un paysan fou arrive en courant vers vous. Il est bouche bée, hors d'haleine. Les mains sur les genoux, il vomit presque les mots :%SPEECH_ON%Les morts... ils arrivent !%SPEECH_OFF%En regardant par-dessus lui, vous voyez en effet une foule de créatures plutôt pâles qui s'agitent au loin. | Pas de brigands ici, mais des morts-vivants ! Alors que vous attendez que les voyous et les mécréants déboulent dans la ville, vous apercevez au contraire une grande foule de créatures ambulantes qui se dirige vers vous. Ce n'est pas parce que la cible change que le contrat change aussi - préparez-vous ! | Les cloches d'alarme sonnent depuis la chapelle de la ville. Vous les écoutez en regardant l'horizon. Elles continuent à sonner. Un habitant se tient à vos côtés.%SPEECH_ON%Un... deux... trois... quatre...%SPEECH_OFF%Il commence à transpirer. Puis ses yeux s'écarquillent lorsque les cloches sonnent une dernière fois.%SPEECH_ON%C'est... c'est impossible.%SPEECH_OFF%Vous demandez de quoi il a peur. Il recule.%SPEECH_ON%Les morts marchent à nouveau sur la terre !%SPEECH_OFF%Super, juste quand vous pensiez qu'un contrat allait être facile. | Gémissant, grognant, les morts-vivants s'avancent. Il n'y a pas de brigands ici - peut-être que ces créatures immondes les ont mangés - mais le contrat n'est pas caduc : protéger la ville !}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Le combat est terminé et les hommes se reposent dans un répit bienvenu. %employer%vous attendra en ville. | La bataille terminée, vous examinez les cadavres éparpillés sur le terrain. C'est un spectacle horrible, mais pour une raison quelconque, cela vous donne de l'énergie. Les affreuses monticules de morts ne font que vous rappeler la vitalité que vous devez encore céder à ce monde horrible. Des gens comme %employer% devraient venir voir ça, mais il ne le fera pas, alors vous devrez aller le voir à sa place. | La chair et les os sont éparpillés dans le champ, à peine discernables d'une personne à l'autre. Des buses noires tournent dans le ciel, des halos d'ombres en chevrons ondulant au-dessus des morts, les oiseaux attendant que les personnes en deuil aient quitté les lieux. %randombrother% vient à vos côtés et demande s'ils doivent entamer le voyage de retour pour aller voir %employer%. Vous laissez derrière vous la vue du champ de bataille et acquiescez. | Une sorte de ruine paisible est faite de morts. Comme si c'était leur état naturel, raidis et à jamais perdus, et que toute leur vie n'était qu'une crise fugace d'un accident finalement arrivé à son terme. %randombrother% s'approche et vous demande si vous allez bien. Vous n'êtes pas sûr, pour être honnête, et répondez simplement qu'il est temps d'aller voir %employer%. | Des hommes difformes et des cadavres tordus jonchent le sol, car la bataille ne donne aux morts aucune souveraineté sur la façon dont ils trouvent le repos final. Les têtes sans corps ont l'air plus paisibles, car dans la bataille, aucun homme ou bête n'a le temps de vraiment trancher un cou, cela ne vient que par le plus rapide et le plus tranchant des coups de lame. Une partie de vous espère partir avec de cette façon immédiate, mais une autre partie espère que vous aurez la chance de faire tomber votre tueur avec vous.\n\n %randombrother% vient à vos côtés et demande des ordres. Vous vous détournez du terrain et dites à  %companyname% de se préparer à retourner voir %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous retournons à l'hôtel de ville !",
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
			Text = "[img]gfx/ui/events/event_30.png[/img]De la fumée emplit l'air, de la fumée et l'odeur caustique du bois qui brûle, des réserves de nourriture qui brûlent. Les habitants de %townname% ont mis tous leurs espoirs dans l'embauche de %companyname%, une erreur fatale.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ça ne s'est pas passé comme prévu...",
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
			Text = "[img]gfx/ui/events/event_80.png[/img]{Alors que vous vous préparez à défendre %townname%, la milice locale s'est ralliée à votre cause. Elle se soumet à vos ordres, demandant seulement que vous l'envoyiez là où vous pensez qu'elle sera la plus utile. | Il semble que la milice locale ait rejoint la bataille ! Un groupe d'hommes en loques, mais qui sera néanmoins utile. Maintenant la question est, où les envoyer ? | La milice de %townname% a rejoint le combat ! Bien qu'il s'agisse d'une bande d'hommes mal armés, ils sont impatients de défendre leur maison et leur taudis. Ils se soumettent à votre commandement, en espérant que vous les enverrez là où on a le plus besoin d'eux. | Vous n'êtes pas seul dans ce combat ! La milice de %townname% vous a rejoint. Ils sont impatients de se battre et vous demandent où ils seront le plus utiles.}",
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
					Text = "Allez défendre l'hôtel de ville de %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), home.getName() + " Militia", false, this.Const.World.Spawn.Militia, home.getResources() * 0.7);
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
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), home.getName() + " Militia", false, this.Const.World.Spawn.Militia, home.getResources() * 0.7);
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
			Text = "[img]gfx/ui/events/event_80.png[/img]Maintenant que vous avez décidé de prendre certains des habitants sous votre commandement, ils vous demandent comment ils doivent s'armer pour la bataille à venir.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prenez des arcs, vous tirerez depuis l'arrière.",
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
			Text = "[img]gfx/ui/events/event_80.png[/img]{The fighting over, one of the militiamen that helped in the defense comes to you personally, bending low and offering his sword.%SPEECH_ON%Sir, my time with the town of %townname% is at an end. But the prowess of the %companyname% is truly an amazing sight. If you would permit it, sir, I would love to fight alongside you and your men.%SPEECH_OFF% | With the battle over, one of the militiamen from %townname% states that he will gladly come and fight for the %companyname%. Partly because he was most impressed with the mercenary band\'s fighting, and partly because being conscripted into the town\'s defense is neither financially or physically healthy.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Welcome to the %companyname%!",
					function getResult()
					{
						return 0;
					}

				},
				{
					Text = "This is no place for you.",
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
			Text = "[img]gfx/ui/events/event_30.png[/img]{While keeping watch for the brigands, a peasant comes up telling you that a group of the thugs attacked nearby, taking off with a group of hostages. You shake your head in disbelief. How were they able to sneak in and do this? The layman shakes his head, too.%SPEECH_ON%I thought y\'all were supposed to help us. Why didn\'t you do anything?%SPEECH_OFF%You ask if the brigands have gone far. The peasant shakes his head. Looks like you still have a shot to get them back. | A man wearing rags and carrying a broken pitchfork sprints up to your company. He drops and wails at your feet.%SPEECH_ON%The brigands attacked! Where were you? They killed people... burned some... and... and they took some prisoner! Please, go save them!%SPEECH_OFF%You eye %randombrother% and nod.%SPEECH_ON%Get the men ready. We need to chase these thugs down before they escape entirely.%SPEECH_OFF% | You have your eyes peeled to the horizons, looking for any sight or sound of vagabond or vagathief. Suddenly, %randombrother% comes to you with a woman by his side. She tells a story that the thugs have already attacked, killing a great number of peasants and those they didn\'t kill they made off with. The mercenary nods.%SPEECH_ON%Looks like they snuck past us, sir.%SPEECH_OFF%You\'ve only one choice now - go get those people back! | Stationing yourself close to %townname%, you anticipate the brigands\' attack. You thought this would be easy, but the sudden arrival of a crazed layman says otherwise. The peasant explains that the marauders have already ambushed the outskirts. They slaughtered everyone they could, then made off with a few men, women, and children. The man, either drunk or in shock, slurs his pleas.%SPEECH_ON%Get... get them back, would ya?%SPEECH_OFF% | Keeping watch, a few angry peasants take the roads, storming toward you in a swirl of mob anger.%SPEECH_ON%I thought we were paying you to protect us! Where were you!%SPEECH_OFF%They are covered in blood. Some are half-clothed. A woman hangs a breast, too angry to care about the indecency. You ask the group what it is they are talking about. A man, clutching a cane close to his chest, explains that the raiders and thugs had already attacked, taking to a nearby hamlet. They slaughtered everything in sight then, with their bloodlust satiated, took as many prisoners as they could.\n\nYou nod.%SPEECH_ON%We\'ll get them back.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s get them!",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Sheathing your sword, you order %randombrother% to go free the prisoners. A litany of bewildered peasants are freed from leather leashes, chains, and dog cages. They thank you for your timely arrival, and for the violence you brought to the brigand. | The brigands are slaughtered to a man. You set your men out to go rescue every peasant they can find. Each one comes together, hugging and crying, mad with happiness that they have survived this horrifying ordeal. | After killing the last brigand around, you tell the company to go around freeing the hostages the vagabonds had taken. Each one comes to you in turn, some kissing your hand, others your feet. You only tell them to get back to %townname% as you will do yourself.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Looks like this is over.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping3",
			Title = "Near %townname%",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Unfortunately, the brigands got away with the hostages. May the gods be with those sorry souls now. | You couldn\'t do it - you couldn\'t save those poor peasants. Now only the gods know what will happen to them. | Sadly, the marauders got away with their human cargo in tow. Those poor folks will have to fend for themselves now. The stories you hear, however, tell you they will not fare well at all. | The brigands got away, their prisoners alongside with them. You\'ve no idea what will happen to those people now, but you know it isn\'t good. Slavery. Torture. Death. You\'re not sure which is the worst.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{They won\'t like that in %townname%... | Maybe they can be bought back...}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer% looking rightfully smug.%SPEECH_ON%Work\'s done.%SPEECH_OFF%He nods, tipping a goblet of wine while not necessarily offering it.%SPEECH_ON%Yes. The town is eternally grateful for your help. They are also... monetarily grateful.%SPEECH_OFF%The man gestures toward the corner of the room. You see a satchel of crowns there.%SPEECH_ON%%reward% crowns, just as we had agreed. Thanks again, sellsword.%SPEECH_OFF% | %employer% welcomes your return with a glass of wine.%SPEECH_ON%Drink up, sellsword, you\'ve earned it.%SPEECH_OFF%It tastes... particular. Haughty, if that could be a flavor. Your employer swings around his desk, taking a gleefully happy seat.%SPEECH_ON%You managed to protect the town just as you had promised! I am most impressed.%SPEECH_OFF%He nods, tipping his goblet toward a wooden chest.%SPEECH_ON%MOST impressed.%SPEECH_OFF%You open the chest to find a bevy of golden crowns. | %employer% welcomes you into his room.%SPEECH_ON%I watched from my window, you know? Saw it all. Well, most of it. The good parts, I suppose.%SPEECH_OFF%You raise an eyebrow.%SPEECH_ON%Oh, don\'t give me that look. I don\'t feel bad for enjoying what I saw. We\'re alive, right? Us, the good guys.%SPEECH_OFF%The other eyebrow goes up.%SPEECH_ON%Well... anyway, your payment, as promised.%SPEECH_OFF%The man hands over a chest of %reward% crowns. | When you Retournez à %employer% you find his room has almost been packed up, everything ready to move and go. You raise a bit of humorous concern.%SPEECH_ON%Getting ready to go somewhere?%SPEECH_OFF%The man\'s settled down into his chair.%SPEECH_ON%I had my doubts, sellsword. Can you blame me? For what it\'s worth, you shouldn\'t need doubt my ability to pay.%SPEECH_OFF%He sways a hand across his desk. On the corner is a satchel, lumpy and bulbous with coins.%SPEECH_ON%%reward% crowns, as promised.%SPEECH_OFF% | %employer% raises from his chair when you enter. He bows, somewhat incredulously, but also earnestly. He tips his head toward the window where the din of happy peasants murmurs.%SPEECH_ON%You hear that? You\'ve earned that, mercenary. The people here love you now.%SPEECH_OFF%You nod, but the love of the common man is not what brought you here.%SPEECH_ON%What else have I earned?%SPEECH_OFF%%employer% smiles.%SPEECH_ON%A man on point. I bet that\'s what gives you your... edge. Of course, you\'ve also earned this.%SPEECH_OFF%He heaves a wooden chest onto his desk and unlatches it. The shine of gold crowns warms your heart. | %employer%\'s staring out his window when you enter. He\'s almost in a dreamstate, head bent low to his hand. You interrupt his thoughts.%SPEECH_ON%Thinking of me?%SPEECH_OFF%The man chuckles and playfully clutches his chest.%SPEECH_ON%You are truly the man of my dreams, mercenary.%SPEECH_OFF%He crosses the room and takes a chest from the bookshelf. He unlatches it as he sets it on the table. A glorious pile of gold crowns stare you in the face. %employer% grins.%SPEECH_ON%Now who is dreaming?%SPEECH_OFF% | %employer%\'s at his desk when you enter.%SPEECH_ON%I saw a good deal of it. The killing, the dying.%SPEECH_OFF%You take a seat.%SPEECH_ON%Hope you enjoyed the show. Viewing\'s ain\'t free, though.%SPEECH_OFF%The man nods, taking a satchel and handing it over.%SPEECH_ON%I\'d pay for an encore, but I\'m not sure %townname% wants that.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{The %companyname% will make good use of this. | Payment for a hard day\'s work.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Defended the town against brigands");
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
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% welcomes your return with a point out his window.%SPEECH_ON%You see that? There, in the distance.%SPEECH_OFF%You join his side. He asks.%SPEECH_ON%What is it that you see?%SPEECH_OFF%There\'s smoke on the horizon. You let him know that\'s what you see.%SPEECH_ON%Right, smoke. I didn\'t hire you to let the brigands make smoke, understand? Of course... most of the town is still upright...%SPEECH_OFF%He heaves a satchel into your chest.%SPEECH_ON%Good work, sellsword. Just... not good enough.%SPEECH_OFF% | You Retournez à %employer%, he looks a mix of happy and sad, somewhere between drunk and straight. This is not the look you want to see.%SPEECH_ON%You did good, sellsword. Word has it you laid those brigands utterly flat. Word also has it that they burned parts of our outskirts.%SPEECH_OFF%You nod. Not worth lying about what you can\'t cover up.%SPEECH_ON%You\'ll be getting paid, but you have to understand that it takes money to rebuild those areas. Obviously, the crowns for that will be coming out of your pockets...%SPEECH_OFF% | %employer%\'s slouched in his seat when you return.%SPEECH_ON%Most in %townname% are happy, but a few are not. Can you guess which of those aren\'t?%SPEECH_OFF%The brigands did manage to destroy a few parts of the outskirts, but this here was rhetorical question.%SPEECH_ON%I need funds to help rebuild the territories those marauders managed to get their hands on. I\'m sure you understand, then, why you\'ll be receiving less pay...%SPEECH_OFF%You shrug. It is what it is. | %employer%\'s at his bookshelf. He takes a book, spinning around and opening it all in one move. He lays it across his table.%SPEECH_ON%There\'s numbers there. I\'m sure you can\'t read them, but here\'s what they say: the brigands managed to destroy parts of this town and now I need crowns to help rebuild. Unfortunately, I don\'t have that many crowns on hand to do this. I\'m sure you understand this predicament.%SPEECH_OFF%You nod and state the obvious.%SPEECH_ON%It\'s coming out of my pay.%SPEECH_OFF%The man nods and slides an open hand across his desk, drawing your attention to a satchel. There\'s no point in arguing about pay. You take the sack and make your leave.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{That\'s just half of what we agreed to! | It is what it is...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Defended the town against brigands");
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer% looking rightfully smug.%SPEECH_ON%Work\'s done.%SPEECH_OFF%He nods, tipping a goblet of wine while not necessarily offering it.%SPEECH_ON%Yes. The town is eternally grateful for your help. They are also... monetarily grateful.%SPEECH_OFF%The man gestures toward the corner of the room. You see a satchel of crowns there.%SPEECH_ON%%reward% crowns, just as we had agreed. Thanks again, sellsword. Oh and, uh, a shame about those peasants...%SPEECH_OFF% | %employer% welcomes your return with a glass of wine.%SPEECH_ON%Drink up, sellsword, you\'ve earned it.%SPEECH_OFF%It tastes... particular. Haughty, if that could be a flavor. Your employer swings around his desk, taking a gleefully happy seat.%SPEECH_ON%You managed to protect the town just as you had promised! I am most impressed.%SPEECH_OFF%He nods, tipping his goblet toward a wooden chest.%SPEECH_ON%MOST impressed.%SPEECH_OFF%You open the chest to find a bevy of golden crowns.%SPEECH_ON%A shame about the peasants that got taken. I\'ve made adjustments accordingly...%SPEECH_OFF% | %employer% welcomes you into his room.%SPEECH_ON%I watched from my window, you know? Saw it all. Well, most of it. The good parts, I suppose.%SPEECH_OFF%You raise an eyebrow.%SPEECH_ON%Oh, don\'t give me that look. I don\'t feel bad for enjoying what I saw. We\'re alive, right? Us, the good guys.%SPEECH_OFF%The other eyebrow goes up.%SPEECH_ON%Well... anyway, your payment, as promised. I heard word that a few peasants were taking away. I made some deductions. That money will be going to the survivors.%SPEECH_OFF%The man hands over a chest of %reward% crowns. | When you Retournez à %employer% you find his room has almost been packed up, everything ready to move and go. You raise a bit of humorous concern.%SPEECH_ON%Getting ready to go somewhere?%SPEECH_OFF%The man\'s settled down into his chair.%SPEECH_ON%I had my doubts, sellsword. Can you blame me? For what it\'s worth, you shouldn\'t need doubt my ability to pay.%SPEECH_OFF%He sways a hand across his desk. On the corner is a satchel, lumpy and bulbous with coins.%SPEECH_ON%A couple crowns shorter than promised. You know what will happen to those peasants the brigands ran off with? Yeah, I reduced your pay for a reason.%SPEECH_OFF% | %employer% raises from his chair when you enter. He bows, somewhat incredulously, but also earnestly. He tips his head toward the window where the din of happy peasants murmurs.%SPEECH_ON%You hear that? You\'ve earned that, mercenary. The people here love you now.%SPEECH_OFF%You nod, but the love of the common man is not what brought you here.%SPEECH_ON%What else have I earned?%SPEECH_OFF%%employer% smiles.%SPEECH_ON%A man on point. I bet that\'s what gives you your... edge. Of course, you\'ve also earned this. Well, a little less. Nasty business about those peasants you let the brigands run off with, no?%SPEECH_OFF%He heaves a wooden chest onto his desk and unlatches it. The shine of gold crowns warms your heart. | %employer%\'s staring out his window when you enter. He\'s almost in a dreamstate, head bent low to his hand. You interrupt his thoughts.%SPEECH_ON%Thinking of me?%SPEECH_OFF%The man chuckles and playfully clutches his chest.%SPEECH_ON%You are truly the man of my dreams, mercenary.%SPEECH_OFF%He crosses the room and takes a chest from the bookshelf. He unlatches it as he sets it on the table. A glorious pile of gold crowns stare you in the face. %employer% flashes a grin, but it fades as quick as it was to come.%SPEECH_ON%A little lighter than what you were expecting? The surviving families of those peasants you let get carried away by brigands will be getting that share. I\'m sure you understand.%SPEECH_OFF% | %employer%\'s at his desk when you enter.%SPEECH_ON%I saw a good deal of it. The killing, the dying.%SPEECH_OFF%You take a seat.%SPEECH_ON%Hope you enjoyed the show. Viewing\'s ain\'t free, though.%SPEECH_OFF%The man nods, taking a satchel and handing it over.%SPEECH_ON%I\'d pay for an encore, but I\'m not sure %townname% wants that. Of course, those poor folks who got taken away by those raiders don\'t want what they got.%SPEECH_OFF%You glance into the sack and notice that it\'s a few crowns lighter than expected.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{That\'s just half of what we agreed to! | It is what it is...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Defended the town against brigands");
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
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% welcomes your return with a point out his window.%SPEECH_ON%You see that? There, in the distance.%SPEECH_OFF%You join his side. He asks.%SPEECH_ON%What is it that you see?%SPEECH_OFF%There\'s smoke on the horizon. You let him know that\'s what you see.%SPEECH_OFF%Right, smoke. I didn\'t hire you to let the brigands make smoke, understand? Of course... most of the town is still upright...%SPEECH_OFF%He heaves a satchel into your chest.%SPEECH_ON%Good work, sellsword. Just... not good enough. And a shame about those poor peasants you let those damned brigands run off with.%SPEECH_OFF% | You Retournez à %employer%, he looks a mix of happy and sad, somewhere between drunk and straight. This is not the look you want to see.%SPEECH_ON%You did good, sellsword. Word has it you laid those brigands utterly flat. Word also has it that they burned parts of our outskirts.%SPEECH_OFF%You nod. Not worth lying about what you can\'t cover up.%SPEECH_ON%You\'ll be getting paid, but you have to understand that it takes money to rebuild those areas. And what of those poor people you let the raiders kidnap? Their families are going to want help, too. Obviously, the crowns for that will be coming out of your pockets...%SPEECH_OFF% | %employer%\'s slouched in his seat when you return.%SPEECH_ON%Most in %townname% are happy, but a few are not. Can you guess which of those aren\'t?%SPEECH_OFF%The brigands did manage to destroy a few parts of the outskirts, but this here was rhetorical question.%SPEECH_ON%I need funds to help rebuild the territories those marauders managed to get their hands on. I also need crowns to help the survivors of those peasants you failed to save. I\'m sure you understand, then, why you\'ll be receiving less pay...%SPEECH_OFF%You shrug. It is what it is. | %employer%\'s at his bookshelf. He takes a book, spinning around and opening it all in one move. He lays it across his table.%SPEECH_ON%There\'s numbers there. I\'m sure you can\'t read them, but here\'s what they say: the brigands managed to destroy parts of this town and now I need crowns to help rebuild. Unfortunately, I don\'t have that many crowns on hand to do this. I\'m sure you understand this predicament.%SPEECH_OFF%You nod and state the obvious.%SPEECH_ON%It\'s coming out of my pay. And those peasants you let the brigands run off with? They have families. Survivors. They\'ll be getting a share of our \'agreement,\' too.%SPEECH_OFF%The man nods and slides an open hand across his desk, drawing your attention to a satchel. There\'s no point in arguing about pay. You take the sack and make your leave.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{That\'s just half of what we agreed to! | It is what it is...}",
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
			Text = "[img]gfx/ui/events/event_30.png[/img]{When you enter %employer%\'s room, he tells you to close the door behind you. Just as the latch clicks, the man slams you with a stream of obscenities which you couldn\'t hope to keep track of. Calming down, his voice - and language - Retournez à some level of normalcy.%SPEECH_ON%Every bit of our outskirts were destroyed. What is it, exactly, did you think I was paying you for? Get out of here.%SPEECH_OFF% | %employer%\'s slamming back goblets of wine when you enter. There\'s the din of angry peasants squalling outside his window.%SPEECH_ON%Hear that? They\'ll have my head if I pay you, sellsword. You had one job, one job! Protect this town. And you couldn\'t do it. So now you could do one thing and it comes free: get the hell out of my sight.%SPEECH_OFF% | %employer% clasps his hands over his desk.%SPEECH_ON%What is it, exactly, are you expecting to get here? I\'m surprised you returned to me at all. Half the town is on fire and the other half is already ash. I didn\'t hire you to produce smoke and desolation, sellsword. Get the hell out of here.%SPEECH_OFF% | When you Retournez à %employer%, he\'s holding a mug of ale. His hand his shaking. His face is red.%SPEECH_ON%It\'s taking everything in me to not throw this in your face right now.%SPEECH_OFF%Just in case, the man finishes the drink in one big gulp. He slams it on his desk.%SPEECH_ON%This town expected you protect them. Instead, the brigands swarmed the outskirts like they were taking a goddam leisure trip! I\'m not in the business of giving marauders a good time, sellsword. Get the farkin\' hell out of here!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Damn this peasantfolk! | We should have asked for more payment in advance... | Damnit!}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to defend the town against brigands");
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
			Text = "[img]gfx/ui/events/event_30.png[/img]{When you enter %employer%\'s room, he tells you to close the door behind you. Just as the latch clicks, the man slams you with a stream of obscenities which you couldn\'t hope to keep track of. Calming down, his voice - and language - Retournez à some level of normalcy.%SPEECH_ON%Every bit of our outskirts were destroyed. People were even taken to the old gods know what ends! What is it, exactly, did you think I was paying you for? Get out of here.%SPEECH_OFF% | %employer%\'s slamming back goblets of wine when you enter. There\'s the din of angry peasants squalling outside his window.%SPEECH_ON%Hear that? They\'ll have my head if I pay you, sellsword. You had one job, one job! Protect this town. And you couldn\'t do it. Hell, you couldn\'t even save those poor peasants thatgot kidnapped! So now you could do one thing and it comes free: get the hell out of my sight.%SPEECH_OFF% | %employer% clasps his hands over his desk.%SPEECH_ON%What is it, exactly, are you expecting to get here? I\'m surprised you returned to me at all. Half the town is on fire and the other half is already ash. Survivors tell me that their family members were even kidnapped! Do you know what happens to those taken by raiders? I didn\'t hire you to produce smoke and desolation, sellsword. Get the hell out of here.%SPEECH_OFF% | When you Retournez à %employer%, he\'s holding a mug of ale. His hand his shaking. His face is red.%SPEECH_ON%It\'s taking everything in me to not throw this in your face right now.%SPEECH_OFF%Just in case his rage gets the best of him, the man finishes the drink in one big gulp. He slams it on his desk.%SPEECH_ON%This town expected you protect them. Instead, the brigands swarmed the outskirts like they were taking a goddam leisure trip! I\'m not in the business of giving marauders a good time, sellsword. Get the farkin\' hell out of here!%SPEECH_OFF% | %employer% laughs when you step into his room.%SPEECH_ON%The outskirts are destroyed. The people of %townname% are in an uproar, at least those alive to be angry in the first place, that is. And what\'s more? You let a few of our townspeople get taken by these monsters!%SPEECH_OFF%The man shakes his head and points his hand to the door.%SPEECH_ON%I don\'t know what you expected me to pay you for, but it wasn\'t this.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Damn this peasantfolk! | We should have asked for more payment in advance... | Damnit!}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to defend the town against brigands");
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

