this.roaming_beasts_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.roaming_beasts";
		this.m.Name = "Chasse aux Bêtes";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
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
					"Chassez ce qui terrorise " + this.Contract.m.Home.getName()
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

				if (this.Math.rand(1, 100) <= 5 && this.World.Assets.getBusinessReputation() > 500)
				{
					this.Flags.set("IsHumans", true);
				}
				else
				{
					local village = this.Contract.getHome().get();
					local twists = [];
					local r;
					r = 50;

					if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r - 25;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r - 25;
					}

					twists.push({
						F = "IsDirewolves",
						R = r
					});
					r = 50;

					if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_farming_village") || this.isKindOf(village, "medium_farming_village"))
					{
						r = r + 25;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r - 25;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r + 25;
					}

					twists.push({
						F = "IsGhouls",
						R = r
					});

					if (this.Const.DLC.Unhold)
					{
						r = 50;

						if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
						{
							r = r + 100;
						}
						else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
						{
							r = r - 25;
						}
						else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
						{
							r = r - 25;
						}
						else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
						{
							r = r - 50;
						}
						else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
						{
							r = r + 25;
						}

						twists.push({
							F = "IsSpiders",
							R = r
						});
					}

					local maxR = 0;

					foreach( t in twists )
					{
						maxR = maxR + t.R;
					}

					local r = this.Math.rand(1, maxR);

					foreach( t in twists )
					{
						if (r <= t.R)
						{
							this.Flags.set(t.F, true);
						}
						else
						{
							r = r - t.R;
						}
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10);
				local party;

				if (this.Flags.get("IsHumans"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Loups-Garous", false, this.Const.World.Spawn.BanditsDisguisedAsDirewolves, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("A pack of ferocious direwolves on the hunt for prey.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Direwolves, 0.75);
				}
				else if (this.Flags.get("IsGhouls"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Nachzehrers", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("A flock of scavenging nachzehrers.");
					party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Ghouls, 0.75);
				}
				else if (this.Flags.get("IsSpiders"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Nachzehrers", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("A swarm of webknechts skittering about.");
					party.setFootprintType(this.Const.World.FootprintsType.Spiders);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Loups-Garous", false, this.Const.World.Spawn.Direwolves, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("A pack of ferocious direwolves on the hunt for prey.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Direwolves, 0.75);
				}

				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(2);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsHumans"))
					{
						this.Contract.setScreen("CollectingProof");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("CollectingGhouls");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("CollectingSpiders");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("CollectingPelts");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsWorkOfBeastsShown") && this.World.getTime().IsDaytime && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 9000) <= 1)
				{
					this.Flags.set("IsWorkOfBeastsShown", true);
					this.Contract.setScreen("WorkOfBeasts");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsHumans") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					local troops = this.Contract.m.Target.getTroops();

					foreach( t in troops )
					{
						t.ID = this.Const.EntityType.BanditRaider;
					}

					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Humans");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
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
					if (this.Flags.get("IsHumans"))
					{
						this.Contract.setScreen("Success2");
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("Success3");
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("Success4");
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{Pendant que vous attendez que %employer% vous explique pourquoi il a besoin de vos services, vous réfléchissez au silence et à l\'inquiétude qui régnaient dans la colonie à votre arrivée. %employer% élève la voix %SPEECH_ON%Cet endroit est maudit par les dieux et hanté par des bêtes surnaturelles ! Elles viennent dans la nuit avec des yeux rouges brillants et prennent des vies à leur guise. La plupart de notre bétail est mort et je crains qu\'une fois qu\'il n\'y en aura plus, nous serons les prochains à être déchiquetés. L\'autre jour, nous avons envoyé nos meilleurs hommes pour trouver et tuer les bêtes, mais nous n\'avons plus entendu parler d\'eux depuis..%SPEECH_OFF%Il soupire profondément.%SPEECH_ON%Suivez les traces %direction%, traquez et tuez ces créatures pour que nous puissions vivre en paix à nouveau ! Nous ne sommes pas riches, mais nous nous cotisons tous pour payer vos services.%SPEECH_OFF% | %employer% regarde par la fenêtre quand vous le trouvez. Il a un gobelet à la main, et il n\'y a que le silence dehors. Il se tourne vers vous, presque abattu.%SPEECH_ON%Quand vous êtes arrivé ici, avez-vous réalisé à quel point c\'était calme ?%SPEECH_OFF%Vous faites remarquer que c\'est le cas, mais vous êtes un mercenaire. Et vous avez l\'habitude d\'être accueilli ainsi. %employer% acquiesce et prend un verre.%SPEECH_ON%Ah, bien sûr. Malheureusement, ce n\'est pas que les gens ont peur de vous. Pas cette fois-ci. Nous avons été attaqués ces dernières semaines. Des bêtes de quelconque nature sont en liberté, nous ne savons pas ce qu\'elles sont, mais seulement qui elles prennent. Nous avons imploré notre seigneur, bien sûr, mais il n\'a rien fait pour nous aider...%SPEECH_OFF%Son prochain verre est long. Quand il a fini, il se tourne vers vous, une tasse vide à la main.%SPEECH_ON%Voulez-vous aller chasser ces monstres ? S\'il vous plaît, mercenaire, aidez-nous.%SPEECH_OFF% | Lorsque vous le trouvez, %employer% écoute les conversations de quelques paysans. Quand ils vous voient, ils partent rapidement, laissant l\'homme avec une sacoche à la main. Il la brandit.%SPEECH_ON%Il y a des couronnes là-dedans. Des couronnes que ces gens me donnent pour donner à quelqu\'un, n\'importe qui, pour nous aider. Les gens disparaissent, mercenaire, et quand on les retrouve, ils sont... pas seulement morts, mais... déchiquetés. Mutilés. Tout le monde a trop peur pour aller où que ce soit.%SPEECH_OFF%Il fixe le sac, puis vous regarde.%SPEECH_ON%J\'espère que cette tâche vous intéresse.%SPEECH_OFF% | Vous trouvez %employer% en train de lire un parchemin. Il vous lance le papier et vous demande de lire les noms. L\'écriture est compliquée, mais pas autant que les noms eux-mêmes. Vous vous arrêtez et vous vous excusez en disant que vous n\'êtes pas d\'ici. L\'homme hoche la tête et reprend le parchemin.%SPEECH_ON%Ça ira, mercenaire. Si vous vous demandez, il s\'agit des noms des hommes, femmes et enfants qui sont morts la semaine dernière.%SPEECH_OFF%La semaine dernière ? Il y avait beaucoup de noms sur cette liste. L\'homme, semblant vous comprendre, acquiesce d\'un air sombre.%SPEECH_ON%Oui, nous sommes dans une mauvaise passe. Tant de vies perdues. Nous pensons que c\'est l\'oeuvre de créatures immondes, des bêtes au-delà de notre compréhension. Évidemment, nous aimerions que vous alliez les trouver et les détruire. Seriez-vous intéressé par une telle tâche, mercenaire ?%SPEECH_OFF% | %employer% a quelques chiens à ses pieds, tous épuisés, la langue pendante.%SPEECH_ON%Ils ont passé les derniers jours à rechercher des personnes disparues. Des gens qui semblent disparaître dieu sait où.%SPEECH_OFF%Il se penche et caresse l\'un des chiens, le grattant derrière l\'oreille. Normalement, un chien devrait répondre à cela, mais la pauvre bête réagit à peine.%SPEECH_ON%Les gens ne savent pas ce que je sais, c\'est-à-dire que les gens ne font pas que disparaître... ils sont enlevés. D\'horribles bêtes sont en liberté, mercenaire, et j\'ai besoin que vous les poursuiviez. Bon sang, peut-être que vous trouverez même un ou deux habitants de la ville, bien que j\'en doute.%SPEECH_OFF%L\'un des clébards laisse échapper un long souffle fatigué, comme s\'il comprenait. | %employer% a une sacoche à laquelle est attaché un parchemin, mais le nom écrit sur le papier n\'est pas le vôtre. Il le pèse avec soin, les pièces de monnaie s\'enroulent autour de ses doigts, leur tintement et leur tintement s\'atténuent. Il se tourne vers vous.%SPEECH_ON%Vous reconnaissez ce nom ?%SPEECH_OFF%Vous secouez la tête. L\'homme continue.%SPEECH_ON%Il y a une semaine, nous avons envoyé le célèbre %randomnoble% %direction% d\'ici chasser des bêtes immondes qui terrorisent la ville et les fermes environnantes depuis des semaines. Savez-vous pourquoi cette sacoche est restée en ma possession ?%SPEECH_OFF%Vous haussez les épaules et répondez.%SPEECH_ON%Parce qu\'il n\'est pas revenu ?%SPEECH_OFF%%employer% acquiesce et pose la sacoche. Il s\'assied sur le bord de sa table.%SPEECH_ON%Correct. Parce qu\'il n\'est pas revenu. Maintenant, pourquoi pensez-vous que c\'est le cas ? Je pense que c\'est parce qu\'il est mort, mais ne soyons pas si négatifs. Je pense que c\'est parce que les bêtes dehors ont besoin de plus. Je pense qu\'elles ont besoin de quelqu\'un comme vous, mercenaire. Seriez-vous prêt à nous aider maintenant que ce noble a échoué ?%SPEECH_OFF% | %employer% prend un livre de son étagère. Lorsqu\'il le pose sur sa table, de la poussière ou peut-être même des cendres jaillissent. Il l\'ouvre, le feuillette lentement de page en page.%SPEECH_ON%Croyez-vous aux monstres, mercenaire ? Je vous le demande honnêtement, car je crois que vous connaissez plus ce monde que moi.%SPEECH_OFF%Vous acquiescez et dites.%SPEECH_ON%Plus qu\'une simple croyance, oui.%SPEECH_OFF%L\'homme feuillette une autre page. Il lève les yeux vers vous.%SPEECH_ON%Eh bien, nous pensons que des monstres sont venus à %townname%. Nous pensons que c\'est pour ça que des gens disparaissent. Vous comprenez où je veux en venir ? J\'ai besoin que vous trouviez ces \"créatures\"  et que vous les tuiez comme les autres. Êtes-vous intéressé ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Qu\'est-ce que ça vaut pour vous ? | Combien %townname% est prête à payer ? | Parlons salaire.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à notre type de travail. | Je vous souhaite bonne chance, mais nous ne participerons pas à cela.}",
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
			ID = "Humans",
			Title = "Avant l\'attaque...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Ce ne sont pas du tout des bêtes, mais des hommes déguisés en loups ! Après avoir vu le \"vrai\" visage de ce mal, les hommes sont soulagés de savoir que leur ennemi est quelque chose qu\'ils ne connaissent que trop bien. | Alors que vous vous rapprochez des monstres, vous réalisez que ces créatures immondes ne sont pas du tout des bêtes, mais des humains déguisés ! Vous ne savez pas pourquoi ils ont joué à un tel jeu de déguisement, mais ils dégainent leurs armes. En ce qui vous concerne, bête ou homme, ils meurent tous de la même façon. | Vous tombez sur un homme qui enlève une tête de loup de ses épaules. Il vous jette un regard, le déguisement toujours en main, puis le remet rapidement. Vous tirez votre épée.%SPEECH_ON%C\'est un peu tard pour faire semblant.%SPEECH_OFF%Le coup de votre arme fait tomber le masque de l\'homme et il trébuche en arrière. Avant que vous ne puissiez l\'écraser, il s\'enfuit en sprintant vers un groupe d\'hommes tout aussi renfrognés. Ils sortent leurs armes à votre simple vue. Quelle que soit la raison pour laquelle ces idiots jouaient à se déguiser, cela n\'a plus d\'importance maintenant. | Vous tombez sur une bête morte avec quelques flèches plantées dans le dos. Les dégâts ne semblent pas mortels... et lorsque vous faites glisser votre épée sur la crinière de la créature, la tête se détache, révélant un humain en dessous.%SPEECH_ON%Vous avez fait ça ?%SPEECH_OFF%Une voix s\'élève devant vous. Il y a là quelques hommes qui enlèvent leur déguisement : celui des bêtes que vous recherchiez. Celui qui est en tête élève la voix.%SPEECH_ON%Tuez-les ! Tuez-les tous !%SPEECH_OFF%Non, ce sont toujours des bêtes, mais d\'un genre plus doux.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous à attaquer !",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WorkOfBeasts",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Vous tombez sur un cadavre dans l\'herbe. D\'habitude, les morts ne sont pas une surprise, il y a des gens partout alors ce n\'est qu\'une question de temps avant de voir un corps ici et là. Sauf que celui-ci a d\'énormes entailles dans le dos et qu\'il lui manque des organes.\n\n%helpfulbrother% s\'avance.%SPEECH_ON%Les organes ont disparu à cause des loups, ou peut-être même des lapins. Quoi, vous n\'avez jamais entendu parler d\'un lapin vraiment affamé ?%SPEECH_OFF%Il crache et se ronge un ongle.%SPEECH_ON%Quoi qu\'il en soit, les marques, ce n\'est pas le travail d\'un lapin ou d\'un chien de chasse ou autre. C\'est quelque chose... de plus grand... de plus dangereux.%SPEECH_OFF%Vous remerciez l\'homme pour ses observations astucieuses et lui dites de rejoindre les rangs. | Un paysan s\'approche de vous avec ses vêtements en lambeaux. Avec une certaine pudeur, il a les mains qui couvrent son entrejambe.%SPEECH_ON%S\'il vous plaît, messieurs, venez jeter un coup d\'oeil à cette... horreur.%SPEECH_OFF%Lorsque vous lui demandez de quoi il parle, il lève les mains en l\'air et se déhanche sur vous. Il se retourne comme une marionnette et s\'enfuit en courant, en hululant et en hurlant. Une femme s\'approche de vous en place de la folie de l\'homme. Elle a les mains sur sa poitrine.%SPEECH_ON%Il est devenu fou parce que son frère a été déchiqueté par les bêtes.%SPEECH_OFF%Vous vous tournez vers elle, vous attendant à moitié à ce que la dame arrache ses vêtements et fasse vaciller ses formes dans la direction qui lui plaît. Au lieu de cela, elle se contente de vous regarder fixement.%SPEECH_ON%Je sais que %townname% a engagé des hommes pour s\'occuper de ces bêtes et vous avez l\'air d\'un homme de main. S\'il vous plaît, monsieur, protégez-nous de ces maux... et des maux qu\'ils répandent...%SPEECH_OFF% | Vous tombez sur une vache éviscérée, dont la moitié est couchée sur une clôture et l\'autre moitié est éparpillée sur une bonne distance dans l\'herbe, aussi loin que ses entrailles le permettent.\n\nUn fermier s\'approche, en soulevant son chapeau pour se protéger les yeux.%SPEECH_ON%Les bêtes ont fait ça. Je ne les ai pas vues, si vous vous demandez, mais j\'ai entendu ce fiasco avant vous. L\'entendre était suffisant pour que je reste à l\'écart et hors de vue. S\'il vous plaît, si vous êtes ici pour trouver ces créatures, faites-le rapidement car je ne peux pas me permettre de perdre plus de bétail comme ça.%SPEECH_OFF% | Un paysan coupant du bois de chauffage se redresse devant vous.%SPEECH_ON%Par les dieux, c\'est bon de vous voir, messieurs. J\'ai cru entendre que des mercenaires se promenaient à la recherche des bêtes qui terrorisent ces régions.%SPEECH_OFF%Vous lui demandez s\'il a vu quelque chose qui pourrait vous aider. Il pose ses mains sur le pommeau de sa hache.%SPEECH_ON%Je ne peux pas dire que j\'ai des informations, non. Mais j\'ai entendu certaines choses. Je sais qu\'un homme et une femme, pas loin d\'ici, ont été enlevés. Eh bien, ils ont disparu ensemble. On dit qu\'ils sont morts dans les bois maintenant. Accrochés aux arbres, pendus par les tripes, vous voyez ? Ou, attendez, peut-être qu\'ils sont juste partis à pieds pour s\'installer ensemble ! Merde... merde ! Cette fille détestait son père et le gamin n\'était qu\'un moins que rien avec une belle gueule et une langue charmante. Ouais, c\'est logique.%SPEECH_OFF%Il fait une pause, puis vous regarde.%SPEECH_ON%Quoi qu\'il en soit, je suis certain que ces monstres sont encore debout. Gardez l\'oeil ouvert, mercenaire.%SPEECH_OFF% | Une femme sort en courant de sa hutte pour vous arrêter. Presque à bout de souffle, elle vous demande si vous avez vu un garçon. Vous faites non de la tête. Elle lève la main.%SPEECH_ON%Il est grand comme ça. Une tignasse de cheveux bruns. Pas naturellement, mais le gamin aime bien sa boue. Quand il sourit, ses dents sont comme les étoiles, brillantes et éparpillées.%SPEECH_OFF%Vous secouez la tête pour refuser une seconde fois.%SPEECH_ON%Il peut lancer une bonne pierre. Il la lance loin. Je lui ai dit de ne pas montrer sa force quand les hommes du seigneur étaient là, de peur qu\'ils ne le prennent dans l\'armée.%SPEECH_OFF%Elle souffle, en chassant une mèche de cheveux de ses yeux.%SPEECH_ON%Eh bien merde, de toute façon, si vous le voyez, faites-le moi savoir. Aussi, faites attention à l\'obscurité. Des bêtes s\'attaquent aux gens par ici.%SPEECH_OFF%Avant que vous ne puissiez dire quoi que ce soit, la femme ramasse ses vêtements longs et retourne à sa hutte. | Vous rencontrez un homme à genoux devant un chien complètement détruit. Vous vous agenouillez à côté de lui.%SPEECH_ON%Ce sont les bêtes qui ont fait ça ?%SPEECH_OFF%Il secoue la tête pour dire non.%SPEECH_ON%Bon sang, je l\'ai fait. Enfin. Ce satané truc ne va plus m\'empêcher de dormir.%SPEECH_OFF%À ce moment-là, une cabane en face s\'ouvre et un homme en sort en hurlant.%SPEECH_ON%Est-ce que c\'est mon maudit chien, fils de pute ?%SPEECH_OFF%Le tueur de chiens se lève rapidement.%SPEECH_ON%Les bêtes ! Elles sont encore venues hier soir !%SPEECH_OFF%Vous laissez tranquillement la dispute où le chien est étendu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On continue.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingPelts",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{Les bêtes tuées, vous ordonnez aux hommes de prendre leurs peaux comme preuve. Votre employeur, %employer%, devrait être très heureux de les voir. | Après avoir tué les créatures immondes, vous commencez à les dépecer et à les scalper. Les créatures horribles nécessitent des preuves horribles. Votre employeur, %employer%, pourrait ne pas croire que vous avez fait votre travail autrement. | Une fois la bataille terminée, vous demandez aux hommes de commencer à collecter les peaux pour les ramener à %employer%, votre employeur. | Votre employeur, %employer%, pourrait ne pas croire ce qui s\'est passé ici sans preuve. Vous ordonnez aux hommes de commencer à prendre des peaux, des trophées, des scalps, tout ce qui pourrait témoigner de votre victoire ici.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Finissons-en avec ça, nous avons des couronnes à collecter.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingProof",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Vos hommes prennent les déguisements des fous de peur que votre employeur, %employer%, ne croit pas à vos actions ici. | Votre employeur pourrait ne pas croire ce qui se passe ici. Vous ordonnez à vos hommes de récupérer les déguisements. %bro1%, en enlevant le masque d\'un des morts, commence à s\'interroger.%SPEECH_ON%Alors ils se sont déguisés en ce genre de choses pour nous attirer, et maintenant ils sont tous morts. J\'espère qu\'ils ne pensaient pas que c\'était un jeu.%SPEECH_OFF%%bro2% nettoie sa lame dans les plis d\'un des déguisements.%SPEECH_ON%Eh bien, si c\'était un jeu, j\'ai bien aimé y jouer.%SPEECH_OFF% | %randombrother% fait un signe de tête pour les morts.%SPEECH_ON%Il est fort probable que %employer% ne croie pas qu\'un groupe de brigands se déguise en bêtes.%SPEECH_OFF%Approuvant, vous ordonnez aux hommes de commencer à collecter les masques et les déguisements comme preuves. | Vous aurez besoin de preuves à montrer à votre employeur, %employer%. Ce n\'étaient pas les bêtes que vous cherchiez, mais ils portent beaucoup de déguisements que votre employeur serait probablement plus intéressé à voir. L\'un des hommes s\'interroge à voix haute.%SPEECH_ON%Alors, pour quoi jouaient-ils à se déguiser ?%SPEECH_OFF%%bro2% plie certains des déguisements sous son bras en les collectant.%SPEECH_ON%Suicide par cérémonie ? Leur danse et leur amusement ont attiré notre attention, après tout.%SPEECH_OFF%Il ramasse l\'un des déguisements, mais la tête du mort s\'y accroche. Le mercenaire rit en expulsant la tête du mort d\'un coup de pied.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retournons à %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingGhouls",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_131.png[/img]{Le combat terminé, vous marchez vers un Nachzehrer mort et vous vous agenouillez. S\'il n\'y avait pas un mur de dents mal taillées, vous pourriez facilement glisser votre tête dans la gueule surdimensionnée de la bête. Au lieu d\'admirer les défauts dentaires, vous sortez un couteau et sciez sa tête, déchirant la couche de peau extérieure très résistante avant de couper, étonnamment, les muscles et les tendons. Vous relevez la tête et ordonnez à %companyname% de faire de même. %employer% attendra des preuves, après tout. | Le corps mort des Nachzehrers ressemblent plus à des rochers qu\'à des bêtes, ils sont couchés et immobiles. Des mouches s\'accouplent déjà dans leur bouche, semant la vie sur les restes écumeux de la mort. Vous ordonnez à %randombrother% de prendre une tête, car %employer% attend une preuve. | Les Nachzehrers morts sont éparpillés. Vous vous agenouillez à côté de l\'un d\'eux et regardez sa bouche. Ce qui se trouvait dans ses poumons est encore en train d\'en sortir, avec une respiration sifflante. Mettant un tissu sur votre nez, vous utilisez l\'autre main pour couper son cou avec une lame, coupant la tête et la tenant en l\'air. Vous ordonnez à quelques frères de faire de même car %employer% attendra des preuves. | Un Nachzehrer mort est un spécimen intéressant à contempler. On ne peut s\'empêcher de se demander où il se situe dans le cycle de la nature. Il a la forme d\'un homme brut, est musclé comme une bête, et sa tête est noueuse, avec des traits issus des cauchemars d\'un sauvage. Vous ordonnez à %companyname% de commencer à collecter les têtes de ces choses immondes car %employer% voudra sûrement des preuves.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retournons à %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingSpiders",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{Vous ordonnez à vos hommes de parcourir le champ et de ramasser le plus de parties possibles des araignées. Quelques-uns font l\'erreur de toucher les poils des pattes des araignées, ce qui les laisse se gratter et forme rapidement des éruptions cutanées. | Les araignées jonchent le terrain comme elles le feraient dans le coin d\'un grenier. Dans la mort, elles ressemblent à des gants géants fermement serrés les uns contre les autres. Vous demandez aux hommes d\'écarter les pattes pour récolter les preuves des restes des bêtes. | Les mercenaires parcourent le champ, découpant et sciant les restes raides des araignées pour les ramener à %employer%. Même mortes, les araignées sont effroyables, semblant à deux doigts de revenir à la vie et de s\'enrouler autour de l\'animal le plus proche. Leurs traits horribles et leur taille surréaliste n\'empêchent pas certains mercenaires de danser autour d\'elles, de claquer la langue et de siffler, et de s\'attaquer aux phobies de ceux qui sont moins enclins à s\'approcher de ces maudites choses.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retournons à %townname%!",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous retournez voir %employer% et posez l\'une des peaux sur son bureau. Les griffes frappent contre le côté du chêne. L\'homme en soulève une, puis la laisse retomber.%SPEECH_ON%Je vois que vous avez trouvé les bêtes que nous cherchions.%SPEECH_OFF%Vous lui parlez de la bataille. Il semble très content, il sort un petit coffre en bois de son étagère et vous le donne.%SPEECH_ON%%reward_completion% couronnes, comme convenu. Les habitants de %townname% méritent le répit que vous leur avez donné face à de telles horreurs.%SPEECH_OFF% | Quand on entre dans le bureau de %employer%, il recule presque instantanément.%SPEECH_ON%Par l\'enfer des dieux, qu\'avez-vous dans la main, mercenaire ?%SPEECH_OFF%Vous tenez la nuque d\'une peau. Du sang noir s\'écoule du cou et éclabousse le sol.%SPEECH_ON%Une des bêtes que vous cherchiez. Si vous avez besoin de preuves du reste, j\'en ai qui attendent dehors...%SPEECH_OFF%L\'homme lève la main, pour vous arrêter.%SPEECH_ON%Un seul suffit à ma conviction. Très bon travail, mercenaire. Votre paie vous sera versée par %randomname%, un conseiller que vous avez probablement croisé dans les couloirs. Il est assez laid et il vous portera les %reward_completion% couronnes, comme promis.%SPEECH_OFF%L\'homme jette un autre regard sur la bête puis secoue lentement la tête.%SPEECH_ON%Que les morts et leurs survivants trouvent la paix dans la disparition de ces créatures immondes.%SPEECH_OFF% | %employer% accueille votre retour avec un gobelet de vin.%SPEECH_ON%Buvez, tueur de bêtes.%SPEECH_OFF%Vous êtes curieux de savoir comment il est déjà au courant de votre succès. Il rejette votre curiosité.%SPEECH_ON%J\'ai beaucoup d\'yeux et d\'oreilles dans ce pays - pas des espions, bien sûr, mais les gens du peuple ont la langue bien pendue. Je devrais le savoir, j\'en suis un ! Vous avez bien travaillé ce coup-là, mercenaire, alors prenez une gorgée. C\'est un très bon vin.%SPEECH_OFF%C\'est bon. La récompense de %reward_completion% couronnes avec laquelle vous sortez est bien meilleure, cependant. %employer% vous arrête.%SPEECH_ON%Juste pour que vous sachiez, mercenaire, ces bêtes ont tué des bonnes personnes là-bas. Ces gens ont peut-être peur de vous, étant le mercenaire que vous êtes, mais ils vous sont tout de même éternellement reconnaissants.%SPEECH_OFF%Vous pesez les couronnes. Très reconnaissant, oui... | %employer% fait quelques pas en arrière.%SPEECH_ON%Ah, euh, je vois que vous avez tué les bêtes. C\'est une très belle fourrure que vous avez là.%SPEECH_OFF%Vous laissez tomber ce que vous aviez apporté : une épaisse et lourde crinière d\'origine bestiale s\'effondre en un tas de fourrure et de chair. L\'homme, presque trop effrayé pour s\'approcher, vous lance une sacoche.%SPEECH_ON%%reward_completion% couronnes, comme convenu. Je vais aller voir le peuple et leur annoncer votre succès. Enfin, nous pouvons être en paix.%SPEECH_OFF% | %employer% est assis à sa table, les jambes en l\'air dans un coin. Ses yeux fixent le plafond, les coins de son visage sont pincés par des plis flétris. Il vous regarde.%SPEECH_ON%Bienvenue de nouveau. J\'ai été informé de vos faits et gestes... de vos combats contre les monstres.%SPEECH_OFF%Vous acquiescez en cherchant votre récompense. L\'homme vous montre la porte.%SPEECH_ON%%randomname%, un collègue conseiller de %townname%, a votre paiement à l\'extérieur. %reward_completion% couronnes comme convenu. Et les habitants de %townname%, même s\'ils vous craignent, vous remercient pour votre venue ici. Merci, mercenaire.%SPEECH_OFF% | %employer% nourrit un de ses chiens quand vous revenez. Le cabot laisse tomber son os pour renifler ce que vous avez apporté. L\'homme montre la fourrure.%SPEECH_ON%C\'est quoi cette chose immonde ?%SPEECH_OFF%Vous haussez les épaules et la jetez sur sa table. Le chien pointe son nez vers l\'une des griffes, grogne, puis commence à la lécher. %employer% sourit brièvement, puis va vers son étagère, prend un coffre en bois et vous le tend.%SPEECH_ON%%reward_completion% ccouronnes, n\'est-ce pas ? Vous devriez savoir que vous avez apporté la paix aux habitants de %townname%.%SPEECH_OFF%Vous acquiescez.%SPEECH_ON%Leur bonheur se présente-t-il aussi sous forme de couronnes ?%SPEECH_OFF%%employer% fronce les sourcils devant votre humour cupide.%SPEECH_ON%Non, c\'est n\'est pas le cas. Passez une bonne journée, mercenaire.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Débarrasser la ville des loups-garous");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% se réjouit de votre retour.%SPEECH_ON%J\'ai déjà entendu la, je suppose, splendide nouvelle. Je ne peux pas le croire, cependant. Une bande de brigands qui s\'amusent à se déguiser. Des loups dans... des habits de loups ?%SPEECH_OFF%Il vous sourit, s\'attendant à ce que vous riiez de sa blague de mauvais goût. Vous haussez les épaules. Il hausse les épaules aussi.%SPEECH_ON%Ah, bien. Votre paiement, %reward_completion% couronnes, vous attend dehors. Je vais dire aux habitants de %townname% que les monstres qu\'ils craignent ne sont que des hommes.%SPEECH_OFF% | Vous revenez avec les costumes des brigands fous. %employer% fait tourner les déguisements de gauche à droite.%SPEECH_ON%Intéressant. C\'est très bien fait. Je dirais presque que les brigands ont été intelligents sur ce coup.%SPEECH_OFF%Il prend l\'un des masques et semble prêt à l\'essayer, puis s\'arrête, comme s\'il ne devait pas faire ça devant un public. Il le repose et vous sourit.%SPEECH_ON%Enfin, bref, mercenaire... bon travail. Vous aurez %reward_completion% couronnes qui vous attendront dehors auprès d\'un des conseillers de %townname%. Il veillera sur vous. Maintenant, le peuple de %townname% peut enterrer ses morts et être enfin en paix.%SPEECH_OFF% | %employer% est mort de rire à votre révélation.%SPEECH_ON%Des hommes ? Il n\'y avait que des hommes ?%SPEECH_OFF%Vous acquiescez, mais essayez de remettre l\'homme sur les rails.%SPEECH_ON%Ils ont tué beaucoup de paysans et ils étaient toujours dangereux.%SPEECH_OFF%Votre employeur acquiesce.%SPEECH_ON%Bien sûr, bien sûr ! Je ne voulais pas déprécier quoi que ce soit ou qui que ce soit. Ne vous avisez pas d\'assumer des choses sur ce que je dis, mercenaire, ce sont mes amis et voisins qui meurent là-bas ! En tout cas, vous avez fait ce que je vous ai demandé et je vous en suis très reconnaissant.%SPEECH_OFF%Il vous remet une sacoche de couronnes. Vous comptez %reward_completion% à l\'intérieur avant de prendre congé. L\'homme vous rappelle en disant.%SPEECH_ON%Vous comprenez sûrement qu\'on essaie de trouver de l\'humour dans ce monde horrible, non ? Parce que c\'est moi qui suis allé aux funérailles de tous ceux qui ont été tués. Je n\'irai pas dans la tombe avec une tête d\'enterrement, peu importe à quel point cet endroit maudit essaie de me l\'imposer.%SPEECH_OFF% | Vous montrez à %employer% les preuves des brigands malicieux. Il pioche dans les morceaux de déguisements, frottant le sang croûté sous ses doigts.%SPEECH_ON%C\'est bien le sang d\'hommes. Êtes-vous sûr qu\'ils ne s\'amusaient pas juste à faire semblant et que les vrais monstres sont toujours là ?%SPEECH_OFF%Vous pincez les lèvres et expliquez qu\'ils vous ont attaqué avec des armes très réelles pas des jouets. %employer% acquiesce, semblant comprendre, bien qu\'un peu méfiant.%SPEECH_ON%Je suppose que je pourrais juste attendre et voir si les monstres reviennent. S\'ils reviennent, eh bien, un homme trahi fait un excellent monstre en soi, n\'est-ce pas ?%SPEECH_OFF%Vous dites simplement à l\'homme de vous payer et attendez de voir s\'il vous fait confiance. Il acquiesce, vous donne %reward_completion% couronnes et vous laisse partir.%SPEECH_ON%J\'espère vraiment que vous dites la vérité, mercenaire. %townname% aurait bien besoin d\'un répit contre les multiples horreurs qui se déchaînent sans cesse dans ce monde maudit.%SPEECH_OFF% | %employer% passe un doigt le long du bord d\'un déguisement.%SPEECH_ON%La fourrure est douce au toucher. Très authentique...%SPEECH_OFF%Il lève les yeux vers vous.%SPEECH_ON%Je me demande s\'ils ont tué les monstres, et puis... ont décidé de porter leurs peaux ? Mais pourquoi ? Vous pensez qu\'ils étaient maudits ?%SPEECH_OFF%Vous haussez les épaules et répondez.%SPEECH_ON%Tout ce que je peux dire, c\'est qu\'ils avaient l\'apparence de monstres, et la cruauté de ceux-ci aussi. Ils nous ont attaqués et ont payé pour ça. Est-ce que l\'un de vos habitants a repéré des créatures depuis ?%SPEECH_OFF%L\'homme sort une sacoche de %reward_completion% couronnes et la fait glisser vers vous.%SPEECH_ON%Non, ils ne l\'ont pas fait. En fait, ils commencent à s\'aventurer de nouveau dehors. Je ne veux pas dire sur les routes, mais quitter la sécurité de leur porte d\'entrée est un grand pas pour beaucoup ! Vous nous avez apporté la paix, mercenaire, et nous vous en remercions.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Bêtes, hommes... ce qui compte, c\'est les couronnes.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Débarrasser la ville des loups-garous");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous trouvez %employer% en train de faire ses besoins. Il se lève et remonte son pantalon, un serviteur récupére rapidement un seau de là où il était assis. Le pauvre serviteur se précipite hors de la pièce. %employer% montre du doigt la tête du Nachzehrer qui pend de votre main.%SPEECH_ON%C\'est absolument dégoûtant. %randomname%, donnez à cet homme sa paie. %reward% couronnes, c\'est ça ?%SPEECH_OFF% | Vous placez la tête du Nachzehrer sur le bureau de %employer%. Pour une raison quelconque, des fluides s\'écoulent encore de son cou, dégoulinant sur le bureau en chêne et le tachant sans doute. L\'homme se penche en arrière, posant ses doigts sur son ventre.%SPEECH_ON%Nachzehrers? Et quoi d\'autre, des fantômes ?%SPEECH_OFF%L\'homme se moque de lui-même.%SPEECH_ON%Rien n\'est trop difficile pour vous, mercenaire.%SPEECH_OFF%Il claque des doigts et un serviteur arrive, vous remettant une sacoche de %reward% couronnes. | Entre la bataille et la marche jusqu\'à %employer%, la gueule du Nachzehrer s\'est remplie de mouches, sa langue a été remplacée par une boule noire informe et lancinante qui bourdonne plus qu\'elle ne mord. %employer% y jette un coup d\'oeil et met un chiffon sur sa bouche.%SPEECH_ON%Oui, j\'ai compris, enlevez-la, s\'il vous plaît.%SPEECH_OFF%Il fait signe à l\'un de ses gardes de venir et on vous remet une sacoche contenant %reward% couronnes. | %employer% aux yeux d\'acier se penche en avant pour bien voir la tête de Nachzehrer que vous avez apportée.%SPEECH_ON%C\'est une sacrée vue, mercenaire. Je suis heureux que vous me l\'ayez fait découvrir.%SPEECH_OFF%Il se penche en arrière.%SPEECH_ON%Laisse-la sur mon bureau. Peut-être que je peux effrayer les enfants avec. Les petits cons s\'habituent trop aux bijoux, je crois.%SPEECH_OFF%Il claque des doigts et un serviteur vient vous donner %reward% couronnes. | Vous apportez la tête du Nachzehrer à %employer% qui la regarde longuement.%SPEECH_ON%Ça me rappelle quelqu\'un. Je n\'arrive pas à mettre le doigt dessus, et je ne suis pas sûr que je devrais. Excusez-moi, mercenaire, je vous emprunte votre temps sans payer. Serviteur, donne à cet homme son argent !%SPEECH_OFF%Vous êtes récompensé comme promis. | %employer% prend la tête du Nachzehrer et la brandit. Quelques chats miaulants semblent surgir de nulle part et tournent autour de la tête comme le feraient des buses au-dessus de leur proie. Il la jette par la fenêtre et les félins s\'enfuient.%SPEECH_ON%Bon travail, mercenaire. %reward% couronnes, comme promis.%SPEECH_OFF% | Vous posez une tête de Nachzehrer sur la table de %employer%. Il lève les yeux de son assiette, jette un coup d\'œil à la tête, puis à vous.%SPEECH_ON%Je mangeais, mercenaire.%SPEECH_OFF%L\'argenterie s\'entrechoque alors que l\'homme, dégoûté, jette l\'assiette sur le côté. Un serviteur emporte la nourriture, probablement pour essayer de la manger lui-même. %employer% sort une sacoche et la pose sur la table.%SPEECH_ON%%reward_completion% couronnes comme promis.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Débarrasser la ville des nachzehrers");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous entrez dans le bureau de %employer% en portant l\'araignée morte sur votre dos. L\'homme hurle et sa chaise se renverse sur le sol. Il se lève d\'un bond et sort un couteau à beurre de son bureau. Vous jetez l\'araignée morte de votre épaule et elle s\'écrase sur son dos. Le citadin s\'avance lentement. Il plante le couteau à beurre dans une miche de pain et secoue la tête.%SPEECH_ON%Par les vieux dieux, vous avez failli me faire avoir une crise cardiaque.%SPEECH_OFF%En hochant la tête, vous dites à l\'homme qu\'il a fallu plus qu\'une grosse botte pour écraser ces bêtes. Il vous répond par un signe de tête.%SPEECH_ON%Bien sûr, mercenaire, bien sûr ! Votre paiement de %reward_completion% couronnes est juste là dans le coin. Et, s\'il vous plaît, prenez cette chose impie avec vous quand vous partez.%SPEECH_OFF% | Les chats sifflent et s\'enfuient dès que vous entrez dans la chambre de %employer%. Quelques chiens, toujours friands de mystères, courent autour de vos jambes et reniflent la carcasse de l\'araignée, leur nez se fronce et s\'éloigne, mais reviennent toujours pour en redemander. Le citadin est en train d\'écrire des notes et il n\'en croit pas ses yeux. Il pose sa plume d\'oie.%SPEECH_ON%C\'est une araignée géante ?%SPEECH_OFF%Vous acquiescez. Il sourit et reprend sa plume d\'oie.%SPEECH_ON%J\'aurais peut-être dû vous suggérer d\'apporter une très grosse chaussure. Votre paiement de %reward_completion% couronnes est là, dans la sacoche. Allez-y, prenez-la. Tout est là. Et vous pouvez laisser le cadavre. J\'aimerais voir la créature de plus près.%SPEECH_OFF% | Votre employeur organise une fête d\'anniversaire quand vous entrez dans son bureau avec une araignée géante morte et jetez le cadavre sur le sol. Ses poils hérissés sifflent en grattant la pierre et ses huit pattes se balancent à l\'envers comme un meuble d\'horreur et elles s\'écartent sur le côté comme si elles étaient prête à bondir. Le chaos éclate, tout le monde crie et se précipite vers la porte ou la fenêtre ouverte la plus proche, avec des confettis colorés qui tournoient dans leur sillage. Votre employeur se tient seul dans l\'espace vide et pince ses lèvres.%SPEECH_ON%Vraiment, mercenaire, était-ce nécessaire ?%SPEECH_OFF%Vous acquiescez et lui dites que vous avez été embauché parce que c\'était nécessaireet que vous serez payé car c\'est très nécessaire. L\'homme secoue la tête et fait un geste vers le coin de la pièce toiut cela en ayant une fausse queue d\'âne.%SPEECH_ON%Votre sacoche est là-bas avec %reward_completion% couronnes, comme convenu. Maintenant, sortez cette horrible chose d\'ici et dites à ces braves gens que les festivités ne sont pas forcément terminées.%SPEECH_OFF% | Vous ne pensez pas pouvoir faire entrer le cadavre de l\'araignée dans le bureau de %employer%, alors à la place vous le tapez contre sa fenêtre depuis l\'extérieur. Vous entendez un cri horrifié et le bruit des meubles qui tombent. Un instant plus tard, la fenêtre adjacente s\'ouvre. Votre employeur se penche dehors.%SPEECH_ON%Oh ! Très fort, mercenaire, très fort ! Que les vieux dieux vous servent mille ans d\'oisiveté pour celui-là !%SPEECH_OFF%En hochant la tête, vous demandez quel est votre salaire. Il vous lance à contrecœur une sacoche.%SPEECH_ON%Les %reward_completion% couronnes sont là-dedans. Maintenant, prenez cette horrible chose et partez !%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Débarrasser la ville des webknechts");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_helpful = [];
		local candidates_bro1 = [];
		local candidates_bro2 = [];
		local helpful;
		local bro1;
		local bro2;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() && !bro.getBackground().isOffendedByViolence() && !bro.getSkills().hasSkill("trait.bright") && bro.getBackground().getID() != "background.hunter")
			{
				candidates_helpful.push(bro);
			}

			if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_bro1.push(bro);

				if (!bro.getBackground().isOffendedByViolence() && bro.getBackground().isCombatBackground())
				{
					candidates_bro2.push(bro);
				}
			}
		}

		if (candidates_helpful.len() != 0)
		{
			helpful = candidates_helpful[this.Math.rand(0, candidates_helpful.len() - 1)];
		}
		else
		{
			helpful = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro1.len() != 0)
		{
			bro1 = candidates_bro1[this.Math.rand(0, candidates_bro1.len() - 1)];
		}
		else
		{
			bro1 = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro2.len() > 1)
		{
			do
			{
				bro2 = candidates_bro2[this.Math.rand(0, candidates_bro2.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else if (brothers.len() > 1)
		{
			do
			{
				bro2 = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else
		{
			bro2 = bro1;
		}

		_vars.push([
			"helpfulbrother",
			helpful.getName()
		]);
		_vars.push([
			"bro1",
			bro1.getName()
		]);
		_vars.push([
			"bro2",
			bro2.getName()
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

