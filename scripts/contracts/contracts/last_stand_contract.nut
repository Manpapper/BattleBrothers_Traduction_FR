this.last_stand_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.last_stand";
		this.m.Name = "Defend Settlement";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		this.m.Flags.set("ObjectiveName", this.m.Origin.getName());
		this.m.Name = "Defend " + this.m.Origin.getName();
		this.m.Payment.Pool = 1600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Voyagez jusqu\'à %objective% %direction%",
					"Defendez-vous contre les Morts-Vivants"
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
				local r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					this.Flags.set("IsUndeadAtTheWalls", true);
				}
				else if (r <= 70)
				{
					this.Flags.set("IsGhouls", true);
				}

				this.Flags.set("Wave", 0);
				this.Flags.set("Militia", 7);
				this.Flags.set("MilitiaStart", 7);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Origin, 600) && this.Flags.get("IsUndeadAtTheWalls") && !this.Flags.get("IsUndeadAtTheWallsShown"))
				{
					this.Flags.set("IsUndeadAtTheWallsShown", true);
					this.Contract.setScreen("UndeadAtTheWalls");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Origin) && this.Contract.m.UnitsSpawned.len() == 0)
				{
					this.Contract.setScreen("ADireSituation");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wait",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Defendez %objective% contre les Morts-Vivants"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.UnitsSpawned.len() != 0)
				{
					local contact = false;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local e = this.World.getEntityByID(id);

						if (e.isDiscovered())
						{
							contact = true;
							break;
						}
					}

					if (contact)
					{
						if (this.Flags.get("Wave") == 1)
						{
							this.Contract.setScreen("Wave1");
						}
						else if (this.Flags.get("Wave") == 2)
						{
							this.Contract.setScreen("Wave2");
						}
						else if (this.Flags.get("IsGhouls"))
						{
							this.Contract.setScreen("Ghouls");
						}
						else if (this.Flags.get("Wave") == 3)
						{
							this.Contract.setScreen("Wave3");
						}

						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("TimeWaveHits") <= this.Time.getVirtualTimeF())
				{
					if (this.Flags.get("IsGhouls") && this.Flags.get("Wave") == 3)
					{
						this.Flags.set("IsGhouls", false);
						this.Flags.set("Wave", 2);
						this.Contract.spawnGhouls();
					}
					else
					{
						this.Contract.spawnWave();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wave",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Defendez %objective% contre les Morts-Vivants"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null)
					{
						e.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
					}
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.UnitsSpawned.len() == 0)
				{
					if (this.Flags.get("Wave") < 3)
					{
						local militia = this.Flags.get("MilitiaStart") - this.Flags.get("Militia");
						this.logInfo("militia losses: " + militia);

						if (militia >= 3)
						{
							this.Contract.setScreen("Militia1");
						}
						else if (militia >= 2)
						{
							this.Contract.setScreen("Militia2");
						}
						else
						{
							this.Contract.setScreen("Militia3");
						}
					}
					else
					{
						this.Contract.setScreen("TheAftermath");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.Music = this.Const.Music.UndeadTracks;
				p.CombatID = "ContractCombat";

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull() && this.World.State.getPlayer().getTile().getDistanceTo(this.Contract.m.Origin.getTile()) <= 4)
				{
					p.AllyBanners.push("banner_noble_11");

					for( local i = 0; i < this.Flags.get("Militia"); i = ++i )
					{
						local r = this.Math.rand(1, 100);

						if (r < 60)
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/humans/militia",
								Faction = 2,
								Callback = null
							});
						}
						else if (r < 85)
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/humans/militia_veteran",
								Faction = 2,
								Callback = null
							});
						}
						else
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/militia_ranged",
								Faction = 2,
								Callback = null
							});
						}
					}
				}

				this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID == "ContractCombat" && _actor.getFlags().has("militia"))
				{
					this.Flags.set("Militia", this.Flags.get("Militia") - 1);
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

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

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
			"Text = "[img]gfx/ui/events/event_45.png[/img]{Vous trouvez %employer% aidant un jeune noble à viser avec un arc une cible à distance sur un mannequin de paille. Il redresse le dos du garçon et lui ordonne de respirer profondément avant de tirer. L\'archer amateur acquiesce et fait ce qu\'on lui dit. La flèche est décochée. Elle vacille, rebondit sur le sol et tourbillonne, s\'écrasant dans une écurie où quelques chevaux hennissent à la perturbation effrayante. Le noble tape dans le dos du garçon.%SPEECH_ON%Fais-moi confiance, j\'étais pire lors de ma première tentative. Continue comme ça. Je serai de retour dans un moment.%SPEECH_OFF%Le noble s\'approche de vous, secouant la tête et baissant la voix.%SPEECH_ON%Les choses sont graves, mercenaire. Les jeunes ne savent pas des dangers qui guettent ces jours-ci, mais toi, si. Nous avons une colonie, %objective%, juste %direction% d\'ici, qui est cernée par... eh bien, les maux de ce monde. Je n\'ai pas d\'hommes à épargner, mais c\'est là que tu interviens. Va là-bas et sauve le village, et tu seras très bien payé, je te l\'assure !%SPEECH_OFF% | %employer% est retrouvé en train de fixer l\'une de ses épées. Il l\'a dégainée, regardant son visage dans le reflet acéré.%SPEECH_ON%Quand on m\'a appris à utiliser l\'une de ces armes, c\'était destiné aux hommes. Maintenant ? On parle des morts, des peaux-vertes, des bêtes hors mesure !%SPEECH_OFF%Il enfonce l\'épée jusqu\'à la garde, la jette avec le fourreau sur sa table. Il passe sa main dans ses cheveux.%SPEECH_ON%%objective% %direction% d\'ici a besoin de ton aide. Elle est entourée par ces... ces choses ! Je ne sais pas ce qu\'elles sont, seulement qu\'elles tuent et tuent encore ! Je n\'ai pas d\'homme à épargner, mais si tu vas là-bas et aides cette ville, tu seras récompensé très généreusement !%SPEECH_OFF%" | "Vous trouvez %employer% assis entre un abbé et un scribe qui se crient dessus avec des voix de vieux hommes secouant la mâchoire et faisant grincer des dents. Étant donné que les morts se sont levés, les questions de mortalité et de vie après la mort sont devenues furieusement débattues. Le noble se tourne vers vous et se lève d\'un bond. Il se précipite vers vous, l\'argument faisant rage en arrière-plan.%SPEECH_ON%Merci aux vieux dieux que vous soyez ici, mercenaire. Juste %direction% d\'ici, %objective%, est assiégé par une armée d\'horreurs. Des morts-vivants, des créatures immondes, je ne sais pas, je sais seulement que je n\'ai pas les hommes pour protéger la ville moi-même. Allez là-bas et assurez-vous que ces gens sont en sécurité, et je vous paierai bien !%SPEECH_OFF% | Vous trouvez %employer% supervisant un groupe de fossoyeurs abaissant un cercueil dans le sol. Le cercueil est solidement cloué, presque précipitamment : les clous tordent et plient le bois, et il y a des marques d\'éraflures sur les côtés. Vous voyez le noble venir vers vous.%SPEECH_ON%Le résident dudit cercueil a décidé de revenir. Il a tué un enfant et un chien. Il en a presque tué un autre avant que les gardes ne le maîtrisent à nouveau.%SPEECH_OFF%Une éclaboussure de liquide noir jaillit du bas du cercueil. Les fossoyeurs sautent en arrière, laissant tomber la caisse directement dans sa tombe avec un bruit lourd. %employer% secoue la tête.%SPEECH_ON%Avec toutes ces épidémies d\'« morts-vivants », mes forces sont étirées au maximum. Je viens d\'apprendre que %objective% juste %direction% d\'ici est une autre cible. Mercenaire, iriez-vous là-bas et aideriez-vous à la sauver ?%SPEECH_OFF% | Vous trouvez %employer% étudiant une pile de livres dispersés sur son bureau. Il secoue la tête, chaque torsion du cou semble tourner une autre page. Contrarié, il vous fait signe d\'entrer précipitamment.%SPEECH_ON%Ne perdez pas de temps, mercenaire, nous n\'avons pas le temps pour ça. Je vous ai besoin à %objective% %direction% d\'ici. Mes oiseaux me disent qu\'elle est attaquée, plus de ces maudits « morts » qui reviennent à la vie, si c\'est vraiment ainsi qu\'il faut le dire. Êtes-vous intéressé ? La rémunération compensera largement vos efforts.%SPEECH_OFF% | Vous trouvez %employer% surveillant des maçons assemblant des pierres coupées net. Il serre votre main.%SPEECH_ON%On construit un autre monastère, mercenaire, qu\'en pensez-vous ?%SPEECH_OFF%Cela semble bien, mais vous faites remarquer qu\'il y a un autre monastère juste de l\'autre côté de la route. Le noble sourit.%SPEECH_ON%Les morts marchent à nouveau sur terre, il n\'y a pas assez de bancs pour asseoir les gens effrayés. Écoutez, je vous ai appelé ici parce que mes forces sont dispersées à essayer de gérer cette... étrangeté de non-vie. Il y a une ville juste %direction% d\'ici, %objective%, qui a désespérément besoin d\'aide. Mes oiseaux me disent qu\'elle est attaquée, et vous semblez être l\'homme idéal pour la sauver. Pour un prix, bien sûr.%SPEECH_OFF% | %employer%, un trésorier et un commandant discutent. Le trésorier dit qu\'il y a beaucoup de couronnes, mais le commandant déclare brutalement qu\'il n\'y a pas d\'hommes autour avec lesquels payer pour combattre. Vous, comme le diable que vous êtes, entrez dans la pièce et êtes immédiatement interpellé.%SPEECH_ON%Mercenaire ! Vos services sont nécessaires immédiatement ! Nous avons un village %direction% d\'ici, un petit endroit appelé %objective%, qui est attaqué par ces, euh, qu\'est-ce que c\'est ?%SPEECH_OFF%Le commandant se penche vers le noble et chuchote la réponse. Il recule.%SPEECH_ON%Sous l\'attaque des... « morts ». D\'accord. Seriez-vous prêt à y aller et à protéger ces pauvres gens ?%SPEECH_OFF% | Vous finissez par trouver %employer% dans ses écuries. Il met une selle sur un cheval et réalise bientôt que vous gardez vos distances.%SPEECH_ON%Auriez-vous peur, mercenaire ?%SPEECH_OFF%Haussement d\'épaules, vous lui dites que vous n\'avez jamais eu d\'affection pour les bêtes. Le noble hausse les épaules en retour et monte en balançant les jambes par-dessus la selle.%SPEECH_ON%Comme bon vous semble. Mes oiseaux m\'ont parlé des problèmes de %objective%, ces problèmes étant une grande horde de morts-vivants frappant à ses portes, et je ne pense pas qu\'ils livrent du lait à ces habitants. Si vous y allez et aidez à protéger le village, il y aura un solide pécule d\'attente pour vous ici à votre retour.%SPEECH_OFF% | %employer% se trouve à marcher sur les murs de sa fortification. Les gardes autour de lui sont étrangement bien alignés, le dos droit, les yeux attentifs cherchant le danger. Vous le voyez et il vous fait signe de venir. Ensemble, vous regardez entre les créneaux. La terre s\'étend devant vous, d\'énormes forêts réduites à de simples points, des montagnes en pointes de flèches, des oiseaux volant en formations épaisses.%SPEECH_ON%%direction% d\'ici se trouve %objective%. Les messagers m\'ont dit qu\'elle est attaquée par une force incroyable, des morts-vivants pour être exact. Oui, c\'est incroyable. Peu importe ce qui on qui assaille leurs murs, je n\'ai pas les hommes pour le gérer. Mais vous, mercenaire, vos services seraient des plus appropriés ici. Seriez-vous intéressé ?%SPEECH_OFF% | Vous trouvez %employer% marchant sur les murs de sa fortification. Les gardes autour de lui sont étonnamment disciplinés, le dos droit, les yeux attentifs cherchant le danger. Vous le voyez et le noble vous fait signe de vous approcher. Ensemble, vous fixez l\'horizon entre les crénelures. La terre s\'étend devant vous, d\'énormes forêts réduites à de simples points, des montagnes en pointe de flèche, des oiseaux s\'arc-boutant en épaisses formations.%SPEECH_ON%%direction% d\'ici se trouve %objective%. Les messagers m\'ont dit qu\'elle est attaquée par une force incroyable, des morts-vivants pour être exact. Oui, c\'est incroyable. Quoi qu\'il en soit, je n\'ai pas les hommes pour y faire face. Mais vous, mercenaire, vos services seraient des plus appropriés ici. Seriez-vous intéressé ?%SPEECH_OFF% | Vous trouvez %employer% et un scribe maigre fixant un cadavre décapité étendu sur une dalle de pierre. La tête est dans un coin, les yeux inclinés, des tiges d\'acier dépassant de son crâne à moitié sculpté. Vous voyez le noble vous tendre une main accueillante.%SPEECH_ON%Rien à craindre, mercenaire. Comme je suis sûr que vous l\'avez entendu, les morts marchent à nouveau sur terre et cela suscite beaucoup de spéculations sur la raison.%SPEECH_OFF%Le scribe regarde en l\'air, interrompant.%SPEECH_ON%Ou comment...%SPEECH_OFF%Souriant, le noble continue.%SPEECH_ON%Quoi qu\'il en soit, %objective% %direction% d\'ici est attaquée par ces mêmes monstres, euh, anciens humains ? Mais je n\'ai pas les hommes pour envoyer de l\'aide. Vous, en revanche, êtes parfait pour le travail. Seriez-vous prêt à le prendre ?%SPEECH_OFF% | %employer% écoute les chuchotements d\'un scribe lorsque vous entrez dans sa chambre. Le scribe vous jette un regard avec des yeux jaunâtres avant de poursuivre son discours. Lorsqu\'il a fini, les deux hommes acquiescent et l\'aîné s\'en va. Il ne vous regarde même pas en partant. %employer% appelle.%SPEECH_ON%Heureux que vous soyez ici, mercenaire ! Ce sont vraiment des temps difficiles. Mes hommes sont dispersés à travers le pays pour affronter toutes sortes de maux monstrueux. Je suis sûr que vous l\'avez déjà entendu, mais les « morts », ou quoi qu\'ils soient, marchent à nouveau. Et ils attaquent %objective% %direction% d\'ici. Sans hommes à épargner, je compte sur vos services, mercenaire. Accepteriez-vous d\'aider à sauver cette ville ?%SPEECH_OFF% | %employer% écoute les supplications d\'un groupe de paysans. Vous êtes arrivé seulement pour la fin de la conversation alors que le noble les chasse en agitant furieusement. Alors que les laïcs crient, les gardes se serrent pour les escorter dehors, pacifiquement pour l\'instant, violemment s\'ils le souhaitent. Ils sortent sans protester davantage, bien qu\'un paysan vous jette un coup d\'œil et murmure \'aidez-nous\' avant de se détourner. %employer% agite la main.%SPEECH_ON%Eh bien, bon sang, si ce n\'est pas le mercenaire ! Bien à l\'heure, mon ami avide d\'argent. J\'ai une ville %direction% d\'ici, %objective%, qui a désespérément besoin d\'aide. Elle est actuellement, d\'après ce qu\'on dit, assiégée par les morts-vivants. Il y a un gros sac de couronnes qui vous attend ici si vous y allez et aidez à la défendre. Qu\'en dites-vous, hein ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combien cela vaut-il pour vous ? | Nous pouvons défendre %objective% pour le bon prix...}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | J\'ai bien peur que %objective% soit livrée à elle-même.}",
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
			ID = "UndeadAtTheWalls",
			Title = "À %objective%...",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Approchant %objective%, %randombrother% appelle soudainement depuis sa position en tête.%SPEECH_ON%Monsieur, dépêchez-vous !%SPEECH_OFF%Vous vous précipitez vers lui et regardez devant vous. La ville est complètement entourée par une mer pâle de morts-vivants qui gémissent et ondulent ! Le %companyname% devra les traverser s\'il veut entrer. | Un homme court vers le %companyname%. Il tient l\'un de ses bras et une couronne de cramoisi coule sur sa tête. Il crie.%SPEECH_ON%Partez, partez ! Il n\'y a rien pour vous ici, rien que des horreurs !%SPEECH_OFF%%randombrother% jette l\'étranger au sol et tire une arme pour le maintenir à terre. Vous retenez la main du mercenaire pendant que vous regardez devant vous : %objective% est déjà entourée par un grand nombre de morts-vivants. Le %companyname% doit agir rapidement ! | Vous êtes arrivé juste à temps : les murs de %objective% sont déjà sous l\'assaut des morts-vivants ! | En tournant dans un chemin, vous êtes soudainement arrêté. Devant vous, %objective% est entourée d\'une foule de morts-vivants. Plus près de vous, quelques-uns errent étrangement, éloignés de la horde. Le %companyname% devra se frayer un chemin jusqu\'à %objective%! | Les murs de %objective% sont étrangement gris - attendez, ce n\'est pas le bois, ce sont les morts-vivants ! À votre horreur, les pâles monstres attaquent déjà, mais vous avez encore le temps de sauver %objective% et de vous battre pour y entrer. Sortant votre épée, vous commandez au %companyname% de combattre ! | Une formation informe de morts-vivants est déjà à l\'extérieur des murs de %objective%. Vous pouvez voir les têtes des défenseurs dépasser des remparts, essayant de ne pas se faire repérer. Sortant votre épée, vous dites au %companyname% qu\'ils devront se frayer un chemin jusqu\'à la ville. | Quelques morts-vivants sont déjà aux portes de %objective%! Les gardes en haut de la porte vous font signe de la main, mettent un doigt sur leurs lèvres, puis pointent vers le bas. Il semble que les monstrueuses créatures attaquent encore parce qu\'elles ne sont pas au courant ? Vous n\'êtes pas sûr, mais vous savez que le %companyname% n\'a qu\'une seule façon d\'entrer et ce sera par l\'épée ! | Heureusement, vous trouvez %objective% encore debout. Malheureusement, les murs sont battus par une foule de morts-vivants pâles. Le %companyname% devra se frayer un chemin à l\'intérieur !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.spawnUndeadAtTheWalls();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ADireSituation",
			Title = "À %objective%...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Vous trouvez les gardes à l\'intérieur de %objective% avec l\'air de n\'avoir pas dormi depuis des semaines, mais ils sourient. Apparemment, votre passage maladroit à travers leur porte était au moins un peu amusant. | Maladroits et trébuchants, le %companyname% passe enfin par la porte d\'entrée. À l\'intérieur, les gardes sont debout avec un désespoir amusé, ayant l\'air d\'être sortis d\'une bataille horrible pour être témoins d\'une étrange plaisanterie. L\'un d\'eux vous tape sur l\'épaule.%SPEECH_ON%C\'était drôlement amusant à regarder, mercenaire, et mes hommes avaient besoin d\'un peu de réconfort. Merci.%SPEECH_OFF% | En regardant autour de vous, vous voyez que les gardes sont des hommes frêles et osseux veillant sur des villageois qui ont l\'air presque à moitié morts déjà. Les routes boueuses sont jonchées d\'excréments, de déchets et de carcasses d\'animaux. Des femmes et des enfants pleurent devant un cimetière improvisé : une tranchée avec un rouleau de noms inscrits au-dessus, l\'encre fraîchement renouvelée pour une autre addition. | Vous entrez par les portes de %objective% et trouvez quelques gardes debout avec des mains minces repliées sur des lances. Leurs vêtements flottent autour de leurs os comme des rideaux le long d\'une fenêtre ouverte. Le sentiment de faim plane épais dans l\'air, reflété dans les regards gourmands que vous recevez juste pour être ici en bonne santé. L\'un des défenseurs vous salue assez chaleureusement.%SPEECH_ON%Nous sommes fatigués et un peu affamés, mais nous nous en sortirons. Le combat est toujours en nous, ne doutez pas de cela.%SPEECH_OFF% | Lorsque vous entrez par les portes de %objective%, un chien est le premier à vous accueillir, léchant vos jambes et reniflant profondément jusqu\'à votre pantalon. Un homme arrive soudain en hurlant, une massue levée, et bientôt homme et animal glissent sur le chemin boueux, semblant tous deux aboyer. Le chien évite les attaques lentes d\'une foule affamée et disparaît complètement. Un gardien souriant s\'approche, se servant d\'un bâton pour se maintenir en équilibre.%SPEECH_ON%Bonsoir, mercenaire. Les stocks de nourriture sont un peu bas et ce chien-là est une proie juste dans une terre de ventres vides.%SPEECH_OFF%Vous demandez s\'ils peuvent encore se battre et l\'homme rit.%SPEECH_ON%Hell, un combat, c\'est tout ce qu\'il nous reste !%SPEECH_OFF% | En entrant par les portes avant de %objective%, c\'est comme marcher au-delà des voiles de la normalité dans les abîmes des enfers. Les villageois errent sans but, de plus en plus affamés, et les gardes partagent des blagues comme ils le feraient pour de la nourriture, riant douloureusement tout en se tenant le ventre. Le chef de la défense s\'approche. Il est mal rasé, marqué de cicatrices, la mâchoire pendante, les yeux paraissant laborieux avec un regard laborieux. Bien qu\'il se tienne à un pied de distance, on dirait qu\'il vous fixe depuis un autre monde.%SPEECH_ON%Ravi que vous soyez venu, mercenaire. Nous pourrions certainement utiliser votre aide de nos jours.%SPEECH_OFF% | Vous passez à travers les portes de %objective% pour trouver l\'enfer lui-même qui vous attend. Les gardes se tiennent prêts comme des squelettes soutenus par un fou, et les villageois restent immobiles ou allongés dans la poussière, ou penchés la tête la première contre les murs. Des enfants se tiennent au sommet des toits de chaume et fouillent la paille à la recherche d\'insectes. Le lieutenant de la défense vous accueille brutalement.%SPEECH_ON%Merci d\'être venu, mercenaire. Beaucoup d\'entre nous ne pensaient pas que vous le feriez à cause de ceci étant l\'enfer lui-même.%SPEECH_OFF% | Les portes avant de %objective% s\'ouvrent et vous passez à travers. À l\'intérieur, vous trouvez deux gardes traînant un cadavre vers un tas de cadavres en feu. Une femme agrippe les bottes de l\'homme mort, le suppliant de lui permettre de jeter un dernier coup d\'œil. Ils l\'ignorent et le jettent dans le feu, et elle tombe devant le bûcher, s\'affaissant alors que la peau de son mari crépite et éclate. Le lieutenant de la défense vient vers vous. Il vous tape sur l\'épaule.%SPEECH_ON%Content que tu sois là, mercenaire.%SPEECH_OFF% | À travers les portes de %objective%, vous êtes accueilli par un homme qui vous attrape par le col.%SPEECH_ON%Vous avez de la nourriture sur vous ? Hmm ? Je peux le sentir, ou êtes-vous de la nourriture vous-même ?%SPEECH_OFF%Un garde l\'arrache avec l\'extrémité d\'une lance. L\'homme fou s\'agrippe l\'estomac et parle entre le ramassage de poux de ses sourcils et en les mangeant.%SPEECH_ON%Y\'all a amené plus d\'épées ici, mais les épées ne sont pas ce dont nous avons besoin !%SPEECH_OFF%Les gardes emmènent l\'homme alors que le lieutenant s\'approche.%SPEECH_ON%Ne faites pas attention à lui. Il était autrefois un homme plus gras, plus flasque, alors il prend ombrage particulièrement avec les récents événements. Nous avons encore de la nourriture ici, elle doit simplement être rationnée. Vos épées sont très appréciées, mercenaire, et, ne vous méprenez pas, vous les utiliserez bientôt.%SPEECH_OFF% | Vous passez à travers les portes de %objective% et êtes accueilli par l\'odeur de la chair brûlée. Il y a un tas fumant de cadavres, un garde à côté avec un bâton, remuant les cendres comme un chef le ferait dans un chaudron. Les villageois se tiennent à côté des restes calcinés, faisant des rites religieux dans l\'air et essuyant des larmes. Le lieutenant de la ville s\'approche.%SPEECH_ON%Les attaques peuvent venir de n\'importe où. Les morts, ils reviennent, et nous sommes une ville qui souffre. Ce tas ici était une famille. La femme est morte dans la nuit et, à la faveur de l\'obscurité, elle a mangé et mangé et mangé. Nous brûlons tous les corps. Vous devez le faire.%SPEECH_OFF%Le lieutenant vous voit grimacer. Il s\'éclaircit avec un sourire.%SPEECH_ON%Alors, comment va votre journée ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous devons nous préparer à l\'assaut imminent...",
					function getResult()
					{
						this.Flags.set("Wave", 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 8.0);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave1",
			Title = "À %objective%...",
			Text = "[img]gfx/ui/events/event_29.png[/img]{L\'attente est sur le point de vous tuer quand quelque chose d\'autre semble prêt à faire le travail : les morts-vivants ! Les cloches de %objective% se mettent à sonner et les gardes se précipitent à l\'action avec une vivacité inattendue. Vous ordonnez au %companyname% de se préparer au combat. | Alors que vous regardez une partie de cartes entre les frères, les cloches se mettent à sonner. Vous jetez un coup d\'œil au monastère local et voyez la forme maladive d\'un vieil homme qui sonne à s\'en briser le cœur. Les gardes réagissent au son avec une énergie renouvelée. Un crie depuis la tour de guet.%SPEECH_ON%Ils arrivent, aux armes, aux armes !%SPEECH_OFF% | Juste quand vous pensez avoir rejoint les habitants qui se tiennent là à mourir d\'une mort lente, les portes avant s\'ouvrent et un éclaireur traverse à cheval. L\'animal épuisé s\'effondre et glisse dans la boue, son cavalier sautant et roulant libre. Il se lève et crie.%SPEECH_ON%Les morts arrivent ! Il faut se préparer !%SPEECH_OFF% | Un homme au sommet d\'une des tours de guet crie.%SPEECH_ON%Message en approche, surveillez vos têtes !%SPEECH_OFF|Vous regardez en l\'air pour voir une flèche traversant le ciel, vrillant pour descendre juste dans la boue à quelques pieds de vous. Le lieutenant casse un parchemin hors de la flèche. Ses lèvres se pincent de blanc à mesure qu\'il lit, et il jette le papier de côté.%SPEECH_ON%Il est temps de se préparer, mercenaire, les morts arrivent.%SPEECH_OFF%Il se tourne vers ses camarades soldats.%SPEECH_ON%Défenseurs de %objective%! Aux armes !%SPEECH_OFF% | L\'un des gardes crie.%SPEECH_ON%Les portes s\'ouvrent, des réfugiés arrivent !%SPEECH_OFF%Une poignée d\'enfants traverse les portes qui grincent. L\'un explique qu\'une horde d\'hommes pâles arrive. Le lieutenant vous fixe du regard.%SPEECH_ON%Vous feriez bien de préparer vos hommes, mercenaire.%SPEECH_OFF%Les morts-vivants se dirigent dans cette direction, préparez-vous au combat ! | Un éclaireur entre dans %objective% et descend de cheval avec des jambes ensanglantées et une queue manquante. Le cavalier berce un bras sans mains et son visage a été libéré d\'une oreille et d\'un œil. Le lieutenant se précipite et les deux parlent avant que l\'éclaireur ne perde connaissance. Soupirant, le lieutenant se lève.%SPEECH_ON%Les morts attaquent, préparez-vous ! Et abattez cette monture, elle est déjà condamnée !%SPEECH_OFF%Vous hochez la tête et ordonnez au %companyname% de se préparer au combat. Alors que les mercenaires se préparent, un homme en tenue de boucher s\'approche et abat le cheval avec un couperet. Le lieutenant vous tape sur l\'épaule.%SPEECH_ON%Eh bien, au moins maintenant, nous aurons quelque chose de bon à manger si nous surv...%SPEECH_OFF% | Vous vous asseyez à côté du lieutenant. Il rompt le pain.%SPEECH_ON%Cela a été étrangement calme depuis votre arrivée.%SPEECH_OFF%En mordant, vous demandez s\'il suggère que vous êtes un agent double pour les morts. Il rit.%SPEECH_ON%On ne peut jamais être trop sûr de nos jours.%SPEECH_OFF%À ce moment-là, une cloche sonne et les gardes se précipitent sur les murs. Des cris et des hurlements éclatent. Les morts-vivants attaquent !\n\n Le lieutenant lance son casque et vous aide à vous lever.%SPEECH_ON%Il est temps de prouver votre valeur, mercenaire.%SPEECH_OFF% | Un des gardes prend une longue vue enveloppée de cuir et commence à regarder à travers les créneaux du mur. Ses mains commencent à trembler et la longue vue glisse hors des attaches en cuir et se brise contre les pierres. Il pointe et crie.%SPEECH_ON%L-les morts sont là ! À vos armes ! Sonnez l\'alarme !%SPEECH_OFF%Vous regardez par-dessus les murs, mais n\'avez pas besoin d\'une longue vue pour voir la vague de pâleur qui se lève à l\'horizon, enflant et trébuchant. Les morts-vivants attaquent ! | La ville est calme, les crépitements doux et les pops d\'un feu remplissent l\'air étouffé. Vous regardez des hommes brûler un rat sur une broche et commencer à découper des morceaux à partager. Voyant assez, vous montez sur les murs pour trouver le lieutenant des gardes qui regarde l\'horizon avec une lunette. Il l\'abaisse sombrement.%SPEECH_ON%Eh bien, que les diables me prennent, ils arrivent.%SPEECH_OFF%Il vous tend la lunette et vous jetez un coup d\'œil. Une foule de morts-vivants aux yeux poissonneux, au regard déformé, se dirige vers %objective%. Le lieutenant reprend sa lunette.%SPEECH_ON%Il est temps de mériter votre salaire, mercenaire.%SPEECH_OFF% | Le cri d\'une femme vous attire pour regarder par-dessus votre épaule. Vous regardez juste à temps pour voir un homme sauter d\'une tour et se casser le cou à la longueur d\'une corde. Le corps oscille, heurtant et tordant contre les murs de pierre. Le lieutenant des gardes pince les lèvres avec colère et crache.%SPEECH_ON%Bon sang, il était censé surveiller l\'horizon. %randomname%! Monte là-haut, libère-le et prends sa place !%SPEECH_OFF%Un autre garde grogne et fait ce qui lui est dit, mais quand il arrive en haut, il cesse de suivre les ordres. Au lieu de cela, il commence à appeler de manière hystérique.%SPEECH_ON%Sir ! Sir ! Ils arrivent ! Tous ces gens pâles, ils arrivent !%SPEECH_OFF%Le lieutenant crie à ses hommes de se préparer au combat, et vous faites de même. L\'homme se tourne vers vous avec un regard d\'espoir.%SPEECH_ON%Peu importe ce qu\'ils vous paient, j\'espère que vous valez chaque couronne, mercenaire.%SPEECH_OFF% | Un des gardes a été surpris en train de tenter de déserter. Il est à genoux tandis que le lieutenant des gardes marche de long en large avec une appréciation déçue.%SPEECH_ON%Nous ne pouvons pas nous permettre de perdre un homme, et tu choisis de nous faire ça ?%SPEECH_OFF%Un des habitants lance une motte de boue qui vole large, mais l\'intention est claire.%SPEECH_ON%Enterrez-le vivant ! Une bouche de moins à nourrir !%SPEECH_OFF%Juste au moment où les paysans commencent à s\'énerver, la cloche de la ville commence à sonner. Un homme au sommet des tours de guet crie aussi fort qu\'il le peut.%SPEECH_ON%Ils arrivent ! Les morts-vivants, ils sont à l\'horizon !%SPEECH_OFF%Le lieutenant regarde le déserteur.%SPEECH_ON%Tu veux regagner ton honneur, fais-le maintenant. Vas-tu te battre ?%SPEECH_OFF%L\'homme hoche rapidement la tête. Le lieutenant se tourne vers vous, mais vous levez la main.%SPEECH_ON%Pas besoin de poser de telles questions au %companyname%.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Défendre la ville !",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave2",
			Title = "À %objective%...",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Alors que le %companyname% se repose, nettoyant la slough maladive de leurs lames, un autre signal vient de la tour de la cloche. Les morts-vivants attaquent à nouveau ! | Le lieutenant des gardes passe autour pour s\'assurer que ses hommes se reposent et boivent de l\'eau. Juste au moment où il vient vous parler, la cloche de la ville retentit et le guetteur hurle qu\'une autre attaque est en cours ! Vous souriez et tapez sur l\'épaule du lieutenant.%SPEECH_ON%Nous faisons simplement ce que nous sommes censés faire. Rien de plus simple, n\'est-ce pas ?%SPEECH_OFF%Le lieutenant hoche la tête et va préparer ses hommes. | Vous regardez %randombrother% frotter ses lames de chair pâle et de vêtements détrempés.%SPEECH_ON%Par les anciens dieux, ils laissent un sacré désordre.%SPEECH_OFF%À ce moment-là, un guetteur siffle et crie que les morts-vivants attaquent à nouveau ! Le mercenaire jette avec colère une mèche de cerveau hors de son arme.%SPEECH_ON%Juste au moment où je commençais à voir mon reflet !%SPEECH_OFF%Vous aidez l\'homme à se lever, lui tapant sur l\'épaule.%SPEECH_ON%Fais-moi confiance, tu ne manques pas grand-chose.%SPEECH_OFF% | Un des gardes casse un petit pain dur en miettes et commence à distribuer les restes. Un autre garde demande où il l\'a trouvé et l\'homme répond franchement.%SPEECH_ON%Je l\'ai trouvé dans les poches de l\'un de ces morts.%SPEECH_OFF%Les mangeurs recrachent la nourriture et l\'un d\'eux vomit même. Vous regardez les hommes commencer à se battre, mais cela se termine rapidement par le sifflet d\'un guetteur. Le garde au sommet d\'une des tours pointe vers l\'horizon.%SPEECH_ON%Les voilà à nouveau ! En bataille !%SPEECH_OFF%Préparez-vous au combat et essayez de ne pas piller de la nourriture sur les cadavres qui vous voient comme leur déjeuner. | Pendant que vos hommes se reposent et récupèrent, l\'un des guetteurs crie.%SPEECH_ON%Les voilà à nouveau !%SPEECH_OFF%La guerre donne rarement une pause appropriée, surtout les guerres avec les morts-vivants. | Vous voyez %randombrother% essuyer son visage avec de la boue. Il s\'arrête, jetant un coup d\'œil à votre regard.%SPEECH_ON%Bain de boue, monsieur. Vous savez, pour nettoyer le... bain de sang.%SPEECH_OFF%Vous levez les yeux au ciel. À ce moment-là, la cloche de la ville commence à sonner et un guetteur crie, ayant repéré une autre attaque en approche ! Vous dites au mercenaire de finir son "bain" et de se préparer au combat. | Vous trouvez %randombrother% en train de laver des entrailles grises derrière ses oreilles.%SPEECH_ON%Maman a toujours dit de se laver derrière les oreilles, mais je ne pense pas qu\'elle avait prévu ce gâchis !%SPEECH_OFF%Vous lui dites qu\'une bonne mère prévoit tout. L\'homme rit et hoche la tête.%SPEECH_ON%Ouais, elle me gronderait juste et me demanderait d\'où je tire ce gâchis !%SPEECH_OFF%À ce moment-là, l\'un des guetteurs en haut des tours crie que les morts-vivants attaquent à nouveau. Vous vous tournez vers le mercenaire.%SPEECH_ON%Eh bien, il est temps de se salir à nouveau.%SPEECH_OFF% | Vous trouvez l\'un des paysans tailler des lignes dans un mur de pierre. En vous voyant, il s\'explique.%SPEECH_ON%Juste pour compter les morts. Il y en a tellement que je ne peux pas garder leurs noms en ordre, mais je peux compter.%SPEECH_OFF%Vous regardez le long du mur pour voir qu\'il a lentement échangé des noms contre des chiffres.%SPEECH_ON%Nous faisons ce que nous pouvons pour nous souvenir, vous savez ?%SPEECH_OFF%Vous hochez la tête et puis, comme par un signe, les guetteurs crient, annonçant une autre attaque en approche. Le paysan vous attrape par le bras avec un regard suppliant.%SPEECH_ON%Dis-moi ton nom et je le mettrai pour toi si le moment vient.%SPEECH_OFF%Vous arrachez votre bras et fixez l\'homme, le réduisant à une taille plus petite avec un regard furieux.%SPEECH_ON%Je suis un tueur, imbécile, pas ton ami. La seule chose qui sépare ma lame de ton cou, c\'est qui me paie. Si tu me poses encore cette question, je mettrai ton numéro sur ce mur et je le ferai gratuitement, tu as compris ?%SPEECH_OFF%L\'homme hoche la tête. Vous hochez la tête en retour et partez préparer vos mercenaires pour la bataille. | Juste au moment où vous et les hommes vous installez pour vous reposer, les guetteurs crient et la cloche de la ville commence à sonner. Une autre attaque est en cours ! Vous ordonnez au %companyname% de se préparer au combat. | Vous grimpez sur les murs de %objective% et trouvez le lieutenant de la garde. Il soupire.%SPEECH_ON%Ils attaquent. Encore.%SPEECH_OFF%Vous fixez l\'horizon et, en effet, une autre vague est en route. Le lieutenant va chercher ses hommes pour un autre combat et vous faites de même.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Défendre la ville !",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave3",
			Title = "À %objective%...",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Alors que tous les combattants se reposent, l\'un des guetteurs, la voix enrouée, crie, vaincu et abattu.%SPEECH_ON%Encore. Les voilà... encore.%SPEECH_OFF%Le %companyname% doit se lever au défi si %objective% doit survivre ! | Un des gardes fixe un feu, ses mains tremblantes. Il marmonne pour lui-même, mais devient lentement plus fort pour que tout le monde entende.%SPEECH_ON%Ouais, c\'est ce qu\'on va faire ! On peut parlementer ! Faisons un marché avec eux ! Parlons-leur ! Je le ferai, je leur parlerai !%SPEECH_OFF%L\'homme se lève. Quelques-uns essaient de le retenir, mais il échappe à leurs efforts. Il court vers les murs et saute par-dessus. Vous vous précipitez pour voir le fou dérangé sprinter à travers les champs - et droit vers une énorme vague de morts-vivants ! Un autre garde commence à trembler en le regardant.%SPEECH_ON%Par les anciens dieux, il y en a plus ? Comment peut-il y en avoir encore ?%SPEECH_OFF%Vous l\'ignorez et regardez le fou disparaître dans la foule de cadavres. Leurs rangs chancellent pour consommer l\'intrusion avant de continuer, comme un étang pâle frémissant brièvement d\'un rocher. Vous criez à vos hommes.%SPEECH_ON%En bataille, les gars ! Encore dans le feu nous allons !%SPEECH_OFF% | Un des guetteurs repère une autre attaque qui arrive ! L\'homme crie si fort que sa voix se brise et il s\'évanouit. La milice de %objective% est à bout de souffle, espérons que ce soit la dernière des assauts ! | Un guetteur siffle un avertissement que plus de morts-vivants arrivent. Le lieutenant des gardes secoue la tête.%SPEECH_ON%Par les anciens dieux, vont-ils jamais cesser d\'arriver ? Vous gagnez vraiment votre salaire aujourd\'hui, mercenaire.%SPEECH_OFF%Vous pensez à plaisanter sur la façon dont vous devriez gagner plus, mais ce n\'est tout simplement pas le bon moment. À la place, vous hochez la tête et partez préparer le %companyname% pour une autre bataille. | Pendant que vous et le lieutenant des gardes échangez des histoires de guerre, un milicien s\'approche. Vous remarquez que c\'est l\'homme censé surveiller les murs. Il parle franchement.%SPEECH_ON%Messes, ils attaquent encore.%SPEECH_OFF%Et tout de suite, il tourne les talons et marche vers l\'armurerie de la ville. Vous vous levez et aidez le lieutenant à se lever. Il vous tape sur l\'épaule avec un sourire tendu et solennel.%SPEECH_ON%Encore dans la mêlée, hein ?%SPEECH_OFF%Vous ne pouvez que hausser les épaules.%SPEECH_ON%C\'est pour ça qu\'on est là. À la revoyure sur le champ de bataille, lieutenant.%SPEECH_OFF% | Vous fixez par-dessus les murs de %objective% et voyez une autre vague de morts-vivants arriver. Toute l\'excitation des attaques précédentes a disparu. Maintenant, les défenseurs regardent silencieusement les cadavres avancer. Le lieutenant des gardes vient à vos côtés.%SPEECH_ON%Ça a été un honneur de combattre à vos côtés, mercenaire.%SPEECH_OFF%Vous hochez la tête et répondez.%SPEECH_ON%Mmm, l\'honneur, bien sûr.%SPEECH_OFF%Le lieutenant vous fixe.%SPEECH_ON%Tu penses à ta paie, n\'est-ce pas ?%SPEECH_OFF%Hochant à nouveau la tête, vous répondez.%SPEECH_ON%Je pense à ce que ça va acheter : un lit chaud, un repas plus chaud et une fille encore plus chaude.%SPEECH_OFF% | Vous vous tenez sur les murs de %objective% et regardez à l\'horizon. Une autre attaque arrive, mais il n\'y a pas d\'excitation à y faire face. Pas de cris, pas d\'hystérie. Plus maintenant. Cela vient simplement. Une armée informe, gonflée et trébuchante de cadavres, bouillonnant et trébuchant en avant, demandant encore une autre lance. Vous ordonnez au %companyname% de se préparer. %randombrother% ouvre incredulous ses bras, la moitié de son corps couverte des restes dégoulinants des morts-vivants déchirés en morceaux.%SPEECH_ON%Monsieur, je pense qu\'on a compris.%SPEECH_OFF%Les hommes rient et rient, la milice se joignant, et bientôt l\'hilarité remplit l\'air, en partie rejointe par les grognements d\'un mort de plus en plus proche, la folie devenue légion. | %randombrother% se dirige vers un feu de camp, tirant de longs brins d\'entrailles de ses épaules et les lançant loin. Un paysan regarde les viscères comme s\'il était à un grognement d\'estomac de prendre une bouchée. Le mercenaire s\'assoit avec un bruit de plouf inconfortable.%SPEECH_ON%Si je vois encore un cadavre venir vers moi comme si c\'était l\'heure du déjeuner, je vais...%SPEECH_OFF%Avant même qu\'il puisse finir la phrase, un guetteur le long des murs s\'emballe sur une corne, hurlant un avertissement pour que tous entendent. Il la laisse à ses côtés, le visage rouge et hors d\'haleine.%SPEECH_ON%Les... morts... ils attaquent encore !%SPEECH_OFF%Le visage du mercenaire devient soudainement immobile. Il se lève et, sans dire un mot, va lentement s\'armer. | Un fermier se tient aux portes de %objective%. Il se dispute avec ses gardiens.%SPEECH_ON%Laissez-moi sortir ! Vous avez sûrement combattu tous les ennemis et je veux retourner à mes fermes. Sachez que je possède deux vaches !%SPEECH_OFF%L\'homme jette deux doigts en avant au cas où les auditeurs n\'auraient pas compris. Ils haussent les épaules et ouvrent la porte, mais le fermier ne bouge pas. À la place, il recule d\'un pas.%SPEECH_ON%À bien y penser, les vaches peuvent attendre que je rentre chez moi.%SPEECH_OFF%Au-delà des murs, vous voyez une énorme horde de morts-vivants dépasser l\'horizon. Pas un instant plus tard, les signaux d\'alarme sont envoyés et %objective% est occupée par des hommes courant de-ci de-là pour s\'armer pour une autre bataille. | Vous rencontrez le lieutenant des gardes le long des murs. Il partage du pain avec certains des miliciens et vous en offre un morceau. Vous déclinez et demandez ce qui se passe à l\'horizon. Le lieutenant pointe vers le champ.%SPEECH_ON%Oh, pas grand-chose, ils attaquent juste encore.%SPEECH_OFF%Il vous tend une longue-vue. En regardant à travers, vous voyez une énorme foule de cadavres se diriger vers %objective%. Vous baissez le verre et demandez à l\'homme pourquoi il n\'a pas encore donné l\'alerte. Il hausse les épaules.%SPEECH_ON%On donne aux hommes une minute ou deux supplémentaires. Les morts-vivants veulent peut-être nous tuer tous, mais ils ne sont pas pressés, vous savez ?%SPEECH_OFF%Compréhensible. Vous allez de l\'avant et prenez ce pain offert, puis, après une minute ou deux de plus, vous partez préparer le %companyname% pour la bataille. | Un milicien a emmené un mort-vivant derrière les murs. Il l\'a sur la longueur d\'une chaîne, les bras du cadavre coupés. Il y a une longue langue qui pend là où devrait être la bouche. Le lieutenant des gardes descend. Son visage est tellement rouge qu\'il semble qu\'il doit jurer comme un homme qui se noie a besoin de respirer.%SPEECH_ON%Qu\'est-ce que tu fous, putain de merde bâtard de cul d\'enfant de cocu ?%SPEECH_OFF%Le milicien tire sur la chaîne, faisant tomber le mort à terre. Il s\'explique nerveusement.%SPEECH_ON%Peut-être qu\'on peut apprendre quelque chose d\'eux ? Apprendre ce qui les fait marcher, apprendre comment, je ne sais pas, peut-être les ramener ?%SPEECH_OFF%Avant que l\'argument ne continue plus longtemps, un cri éclate parmi les hommes. Un garde en haut de la tour de guet met en garde contre une autre attaque. Se retournant, lame en main, le lieutenant décapite rapidement le mort. Sa tête sans menton roule directement du cou, la langue flottant autour de la base comme un serpent dans un bocal. Le lieutenant tire le milicien par le col.%SPEECH_ON%Ne refais plus jamais cette merde, tu m\'as compris ? Ils sont morts. C\'est tout ce qu\'il y a à dire. Maintenant, attrapez votre putain d\'arme.%SPEECH_OFF%Le %companyname% est déjà prêt, n\'ayant pas besoin de vos ordres. | Vous trouvez le forgeron de la ville en train de marteler les « meilleures » armes de %objective%. Ses bras robustes balancent des marteaux et saisissent des tenailles comme s\'ils étaient faits de bâtons. Il a un lemniscate tatoué sur la courbure de sa main. Les flammes d\'ambre tourbillonnent autour comme des pyrales, il remarque rapidement votre ombre qui se projette follement autour de son atelier à ciel ouvert.%SPEECH_ON%Hé là, mercenaire.%SPEECH_OFF%Vraiment curieux et sincèrement ennuyé, vous demandez comment il va. Il étale de l\'acier et le retourne, répétant le processus.%SPEECH_ON%Ça aurait pu être mieux, naturellement. Ça aurait pu être pire, paraît-il. Comment ça se présente ?%SPEECH_OFF%Le forgeron tourne la lame pour votre évaluation. Avant que vous puissiez répondre, les cloches d\'alarme tintent bruyamment, attirant une agitation d\'hommes se précipitant pour défendre la ville. Les milices commencent à courir, attrapant des armes sur les crochets qui entourent son magasin. Il baisse la lame, riant.%SPEECH_ON%Bah, allez-y et combattez, mercenaire. C\'était une de ces questions rhétoriques de toute façon.%SPEECH_OFF% | Le scribe de %objective% se promène avec un parchemin. Il utilise le dos d\'un serviteur pour écrire ce qu\'il voit. Et vous êtes curieux, dans ce champ de chaos, de savoir ce qu\'il voit ? L\'homme vous répond franchement.%SPEECH_ON%Étude des émotions. Je pense que la tristesse est une maladie et elle se propage ici.%SPEECH_OFF%Une réponse curieuse à une question curieuse exige un deuxième round. Vous vous renseignez sur ses recherches. Il ignore la question et vous regarde de haut en bas.%SPEECH_ON%Selon mes critères, vous êtes en excellente santé, mercenaire. Eh bien, sauf votre corps. Vous portez un boitement comme un chien estropié et vous grimacez lorsque vous tournez à gauche. Facilement remarqué. Mais je vois que la douleur ne vous retient pas. En fait, je dirais que cela... vous stimule. Est-ce que vous réparez quelque chose qui vous a été enlevé ?%SPEECH_OFF%Avant que vous puissiez répondre, ce qui aurait été de lui dire de se taire, les cloches d\'alarme interrompent le son. Les hommes se précipitent à l\'action et se préparent pour la prochaine attaque des morts-vivants. Quand vous vous retournez, le scribe est déjà parti, se tenant dans quelque coin lointain, utilisant sa plume acérée pour écrire furieusement sur le dos de son serviteur grimaçant.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Défendre la ville !",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Vous avez remporté la journée, mais la milice a peut-être perdu la guerre : la garde de la ville a subi tant de pertes que davantage de citoyens emballent leurs affaires pour quitter le village plutôt que de rester et aider à défendre ! | La victoire, mais à quel prix ? Tellement de miliciens ont été tués dans la bataille que personne dans la ville de %objective% ne souhaite prendre leur place !}",
			Image = "",
			List = [],
			Options = [
				{
					 Text = "Une victoire néanmoins.",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 3);
						this.Flags.set("MilitiaStart", 3);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{La bataille a été remportée, mais pas sans pertes. Quelques citoyens de %objective% s\'inscrivent pour aider à défendre la ville tandis que d\'autres préparent leurs affaires pour partir. | Vous avez remporté la journée, mais les morts-vivants vous l\'ont fait payer cher. Bien que certains citoyens acceptent d\'aider la milice, contribuant ainsi à reconstituer ses effectifs, un nombre égal reste à distance et se prépare au pire.}",
Image = "",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Une victoire néanmoins.",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 6);
						this.Flags.set("MilitiaStart", 6);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Quelle victoire ! Non seulement les morts-vivants ont été repoussés, mais le succès a été si impressionnant que de nombreux citoyens de %objective% ont rejoint la milice pour les batailles à venir ! | Les morts-vivants ont été tellement vaincus que de nombreux citoyens de %objective% ont rejoint la milice pour aider lors des batailles à venir !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Victoire !",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 8);
						this.Flags.set("MilitiaStart", 8);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Ghouls",
			Title = "À %objective%...",
			Text = "[img]gfx/ui/events/event_69.png[/img]{En préparation pour le combat, vous remarquez des formes étranges titubant autour des rangs de morts-vivants : des nachzehrers. Ces créatures doivent suivre les hordes pour se nourrir de ce qu\'elles tuent, comme des mouettes suivant un bateau de pêche en mer. | Nachzehrers ! Les créatures immondes sont vues trotter et galoper au milieu des foules de cadavres, les maudites bêtes cherchant sans aucun doute leur prochain repas. | Les morts-vivants laissent beaucoup de morts et de mourants dans leur sillage et, sans surprise, des charognards ont commencé à les suivre. Dans ce cas, ce sont des nachzehrers, les laides bêtes grognant et grognant en anticipant avidement leur prochain repas. | Si vous pillez un garde-manger, les souris ne manqueront pas de venir. Maintenant que les morts-vivants attaquent %objective%, ils ont acquis une suite de charognards dans leur sillage : des nachzehrers.}",
Image = "",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Défendre la ville !",
					function getResult()
					{
						this.Contract.spawnGhouls();
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TheAftermath",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Vous contemplez le champ de bataille. Il est jonché de morts, de mourants, d\'immortels et de mourants immortels. Des hommes, du genre vivant et respirant, marchent dans la boue, achevant tout ce qui ressemble de près ou de loin à une réanimation. Avec la fin du combat et le sauvetage de la ville, %employer% devrait maintenant vous attendre. | La bataille est terminée et la ville est sauvée. Il est temps de retourner chez %employer% pour une sacrée paie. | %objective% ressemble davantage à un cimetière inondé qu\'à n\'importe quelle ville que vous connaissiez. Des cadavres, neufs et anciens, sont étalés sur la terre, le sang et la crasse moisie s\'accumulant autour de chacun. L\'odeur vous rappelle un chien mort que vous avez trouvé le long d\'un ruisseau, les os dégoulinant de décomposition, le corps se faisant dévorer par des écrevisses et des asticots.\n\nLes attaques incessantes ayant enfin cessé, %objective% semble sûre pour le moment. %employer% devrait vous attendre et vous n\'avez aucune raison de ne pas échapper à cet endroit horrible dès que possible. | Eh bien, la ville est sauvée. Les paysans se déplacent sur le champ de bataille avec de longs bâtons, fouillant la terre comme des pélicans sondant une mare aux eaux dangereuses. %randombrother% s\'approche, nettoyant la boue de sa lame, et demande s\'il est temps de Retournez à %employer%. Vous hochez la tête. Plus tôt vous pourrez récupérer votre salaire, mieux ce sera. | La bataille est terminée. Parmi les morts se trouvent des paysans et des miliciens, chacun étant accompagné de survivants venus recouvrir les corps de silhouettes pleurantes. Quant aux morts-vivants morts, eh bien, personne ne s\'en soucie. Ces corps gisent comme s\'ils étaient venus sans but et étaient partis avec une destruction approfondie de tout ce qu\'ils touchaient. La vue de leurs cadavres, et le néant chaotique qu\'ils représentent, est exaspérante. Ne voulant pas rester une seconde de plus, vous informez les hommes de se préparer à Retournez à %employer%. | Vous et le %companyname% êtes victorieux. La ville et ses habitants survivront, pour l\'instant, et vous pouvez Retournez à %employer% pour votre salaire. | Le lieutenant de la garde vous remercie d\'avoir sauvé la ville. Vous mentionnez que la seule raison pour laquelle vous êtes ici est parce que quelqu\'un vous a payé. Il hausse les épaules.%SPEECH_ON%Je remercie les pluies sur lesquelles je n\'ai aucun pouvoir, je vous remercierai mercenaire que vous le vouliez ou non.%SPEECH_OFF% | La bataille est terminée et, heureusement, gagnée. Les cadavres des morts-vivants se répandent sur la terre dans un tel désordre qu\'ils ne semblent guère différents de ceux qui ont erré et traîné il y a seulement quelques heures. Mais les plus récemment expirés ne partagent pas une telle désolation cosmique. Ils sont pris en charge par des femmes en pleurs et des enfants confus. Vous détournez le regard de la scène, ordonnant au %companyname% de préparer son Retournez à %employer%. | Un homme mort est à vos pieds, et à côté de lui un cadavre mort-vivant. C\'est le plus étrange des spectacles, car ils sont également exclus de ce monde, mais il y a encore de la vie dans l\'homme. Le souffle d\'une mémoire récente. Vous l\'avez vu se battre jusqu\'au bout. Une noble façon pour un combattant de partir. Ce cadavre, cependant ? Qu\'en est-il ? Vous vous souviendrez qu\'il arrachait la gorge d\'un homme avec ses dents nues. Peut-être que le cadavre avait un moment au-delà de cet instant, un moment où il avait une famille, un moment où il était simplement un homme bien faisant le bien dans ce monde. Mais une monstruosité déchirant la gorge est tout ce qu\'il est maintenant. Tout ce qu\'il sera rappelé être.\n\nLes attaques incessantes sur %objective% ont enfin cessé, et vous vous précipitez donc pour rassembler la compagnie et préparer un Retournez à %employer% à %townname%. Une bonne paie vaut mieux qu\'un autre moment à regarder cette merde. | Qu\'est-ce qu\'un homme mort ? Et qu\'en est-il d\'un homme mort tué deux fois ? Et qu\'en est-il d\'un homme mort tué se couvrant elles-mêmes des horreurs même qui ont envoyé leurs pères et maris à la mort avec une indifférence exaspérante.\n\n %randombrother% se joint à vous.%SPEECH_ON%Monsieur, les attaques ont cessé et les hommes sont prêts à Retournez à %townname%. Dites simplement un mot.%SPEECH_OFF% | Le lieutenant de la garde vient à votre côté et serre votre main. Le sang séché se fissure et s\'effrite lorsque vous serrez. Il pose ses poings sur ses hanches et fait un signe de tête en direction de la scène.%SPEECH_ON%Vous avez bien fait, mercenaire, et nous n\'aurions pas pu le faire sans vous. J\'aimerais vous offrir plus en guise de remerciement, mais cette ville a besoin de toutes les ressources qu\'elle a pour se reconstruire. J\'espère vraiment que %employer% vous paiera à la hauteur de votre valeur.%SPEECH_OFF%Vous l\'espérez aussi.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous l\'avons fait !",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			"[img]gfx/ui/events/event_04.png[/img]{Vous entrez dans %townname% et trouvez %employer% regardant depuis un balcon. Il vous appelle juste au moment où un garde vous balance un sac de couronnes dans les bras.%SPEECH_ON%Mercenaire ! Tellement content de vous avoir de retour ! Mes petits oiseaux m\'ont déjà beaucoup parlé de vos exploits. J\'espère que vous dépenserez bien ces couronnes !%SPEECH_OFF%Avant que vous puissiez dire quelque chose, l\'homme tourne les talons et part. Le garde qui vous a remis les couronnes est déjà parti également. Des paysans marchent autour de vous comme des poteaux indicateurs pointant vers des endroits où ils n\'iront jamais. | Vous trouvez %employer% giflant et donnant des coups de pied à un enfant, finissant par le propulser dans la saleté d\'un coup de botte rapide dans la poitrine. Vous voyez cela, le noble essuie la sueur de son front et s\'explique.%SPEECH_ON%Cela ne vous concerne pas.%SPEECH_OFF%L\'enfant titube à genoux, une main sur son ventre, l\'autre dessinant du sang de son nez qui coule. Peu à peu, il se lève, chancelant, les yeux clignotant de manière cramoisie. Un serviteur arrive et commence à lui tamponner de l\'eau, mais le noble attrape le chiffon et le lance de côté.%SPEECH_ON%Vous pensez qu\'il apprendra comme ça. Si vous voulez aider quelqu\'un, aidez ce mercenaire. Il lui doit %reward_completion% couronnes. Snap snap.%SPEECH_OFF%Le serviteur hoche la tête et part rapidement. Vous restez un moment, regardant la correction se poursuivre. L\'enfant ne pleure pas ni ne crie, car il y a une attente apprise dans cette punition. Quelques minutes passent quand le serviteur réapparaît soudainement, un sac à la main. Il vous le remet en chuchotant une suggestion sincère de prendre congé. | %employer% est penché sur sa table, les bras tendus longs et raides, la tête baissée alors qu\'il fixe un corbeau mort.%SPEECH_ON%J\'ai trouvé ce corbeau dans mon lit ce matin. Juste là. Mort. Avez-vous une idée de ce que cela signifie ?%SPEECH_OFF%Vous suggérez que c\'était peut-être une blague. Le noble ricane.%SPEECH_ON%Non. Je pense que cela a à voir avec vous, mercenaire. Vous avez bien fait de sauver cette ville, mais peut-être n\'était-il pas censé être sauvé ? Peut-être que c\'est ce que ce corbeau représente. Peut-être que les morts viendront me chercher ensuite, car j\'ai laissé la Mort elle-même impayée.%SPEECH_OFF%Vous utilisez cette déclaration pour introduire lentement la question de votre propre paiement. Malgré ses divagations sauvages, le noble rassemble momentanément ses esprits pour vous payer vos %reward_completion% couronnes. | %employer% écoute un groupe de scribes, étrangement disposés par ordre d\'âge et d\'ancienneté. Les jeunes restent silencieux, le seul bruit qu\'ils font est le grincement de leurs plumes. Les aînés argumentent entre eux, utilisant autant le volume que la raison et la rationalité. Cela semble être une vue commune de nos jours, sans aucun doute les morts sortant de leurs tombes étant une préoccupation pour les hommes de prises philosophiques. Quoi qu\'il en soit, vous rotez bruyamment pour vous présenter, brisant leur conversation avec un aplomb dégoûtant. %employer% rit et vous fait signe d\'entrer.%SPEECH_ON%Ah, mercenaire ! L\'homme qui fait les choses, vient parler avec les hommes qui jacassent simplement ?%SPEECH_OFF%Vous secouez la tête et lui dites que vous êtes là seulement pour la paye. Le noble fait signe de la tête.%SPEECH_ON%Bien sûr. Vous avez bien fait en sauvant cette ville. J\'ai beaucoup entendu parler de vos actes héroïques. %reward_completion% couronnes vous attendent là-bas dans le coin.%SPEECH_OFF%Vous traversez la pièce, vos bottes remplissent soudainement la pièce vide de claquements discrets de cuir sur la pierre. Les scribes se tournent pour vous regarder, murmurant entre eux. Vous prenez un sac, entendant le tintement des couronnes bouger avec un poids des plus bienvenus. Vous partez discrètement, bien que la seconde où la porte se referme derrière vous, les scribes éclatent à nouveau en disputes. | %employer% est avec quelques femmes à ses côtés. Elles lui parlent de leurs pères, maris et frères perdus. Il hoche la tête, attentif, jetant parfois un coup d\'œil au décolleté de la plus jeune fille.%SPEECH_ON%Oui, bien sûr. Absolument horrible. Horrible ! Attendez un moment. Mercenaire !%SPEECH_OFF%Il vous fait signe d\'entrer. Les femmes se séparent à votre arrivée. La plus jeune vous dévisage rapidement, essuyant rapidement les larmes de ses yeux et faisant un peu de toilette juvénile. Le noble voit cela et regarde entre vous et elle.%SPEECH_ON%Hem, oui, euh, vos couronnes sont dans le coin. Vous devez partir. Maintenant. J\'ai des choses à faire.%SPEECH_OFF%Il se lève et indique vos %reward_completion% couronnes, et d\'un geste rapide prend la dame par la main.%SPEECH_ON%Maintenant, jeune demoiselle, vous avez dit que votre mari est mort et que vous n\'avez plus personne dans cette vie ? Absolument personne du tout ?%SPEECH_OFF% | Des chiens déchiquètent quelque chose sur le chemin. Quoi que cela ait pu être, cela avait autrefois de la vie, des os et des organes qui sont depuis longtemps devenus pâles et pourris, bien que la mastication enragée des bâtards suggère qu\'il pourrait aussi bien s\'agir d\'un morceau de steak. %employer% vous salue, des gardes attentifs à ses côtés.%SPEECH_ON%Mes oiseaux me disent que la ville a été sauvée. Vous avez bien fait, mercenaire, mieux que je ne l\'aurais pensé. Votre paiement, comme convenu.%SPEECH_OFF%Il vous tend un sac de %reward_completion% couronnes. Les chiens font une pause, tournant la tête vers vous avec de la chair balançant de leurs dents, des yeux noirs étroits fixant un vide reflétant leur faim. Les gardes baissent leurs lances et les chiens, interprétant cela correctement d\'une manière ou d\'une autre, se retournent lentement vers leur repas. | %employer% est retrouvé assis bas dans sa chaise. Il vous fait signe de manière désespérée d\'entrer dans la pièce.%SPEECH_ON%J\'ai des nouvelles horribles. Ma voyante dit que j\'ai jeté une malédiction sur ma terre et sur mon peuple. C\'est pourquoi les morts se relèvent.%SPEECH_OFF%Vous haussez les épaules et dites gentiment que la voyante raconte des bêtises. Le noble hausse les épaules à son tour.%SPEECH_ON%J\'espère bien. Qu\'avons-nous convenu, %reward_completion% couronnes ?%SPEECH_OFF%Vous êtes tenté de dire que vous avez convenu de plus, mais n\'osez pas contrarier un homme aussi superstitieux. Lorsque vous répondez, il sourit chaleureusement à votre réponse précise.%SPEECH_ON%Bien joué, mercenaire. Vous avez réussi ce test. Je peux devenir fou, mais je ne suis pas quelqu\'un à tromper.%SPEECH_OFF%Vous demandez si votre honnêteté sera récompensée. L\'homme lève un sourcil.%SPEECH_ON%Votre tête est sur vos épaules, n\'est-ce pas ?%SPEECH_OFF%Point pris. | %employer% est trouvé sur son balcon. Vous le rejoignez, bien que des gardes se tiennent très près, vous surveillant attentivement. L\'homme agite son bras vers la ville qui s\'étend en dessous de lui.%SPEECH_ON%Je sais que vous n\'avez pas directement sauvé cette ville, mais, d\'une certaine manière, je pense que vous l\'avez fait. Arrêter les morts-vivants n\'importe où revient à les arrêter ici. Seriez-vous d\'accord ?%SPEECH_OFF%L\'homme ponctue la question avec un sac de %reward_completion% couronnes. Vous prenez la récompense et hochez la tête. Il hoche la tête en retour.%SPEECH_ON%Content que vous soyez d\'accord, car nous pourrions avoir besoin de vos services à nouveau.%SPEECH_OFF% | Vous entrez dans la pièce obscure de %employer%. Il y a des tapis sur les fenêtres et la plupart des bougies ne sont pas allumées. Toute la lumière vacille à côté d\'un scribe debout avec un chandelier, son visage rouge feu souriant derrière les bougies comme un petit diable tenant une trident. Il vous jette un coup d\'œil et pose silencieusement les bougies. Lorsqu\'il recule, c\'est comme s\'il tombait dans une mare noire, son visage désincarné plongeant lentement dans l\'obscurité. Il est toujours là, respirant légèrement, froissant sa cape, mais vous n\'avez rien de lui à voir. %employer% vous fait signe d\'entrer.%SPEECH_ON%Mercenaire ! Par les anciens dieux, vous avez bien fait de sauver cette ville !%SPEECH_OFF%Vous avancez, jetant un coup d\'œil à l\'obscurité qui se déplace, une partie de l\'ombre, une partie de l\'homme. %employer% vous tend un sac. Une dispersion de pièces éclairées par les bougies scintille à travers son ouverture.%SPEECH_ON%%reward_completion% couronnes, comme convenu. Maintenant, je vous prie de partir. J\'ai plus à étudier, plus à apprendre.%SPEECH_OFF%Vous prenez votre récompense et quittez lentement la pièce. En fermant la porte, vous voyez le scribe réapparaître comme un spectre maigre, des mains osseuses tendues à nouveau vers la lumière. | %employer% se trouve dans son bureau. Des gardes se tiennent à tous les coins et un scribe parcourt discrètement les étagères, tirant des parchemins et les replaçant avec une égale ardeur et déception. Vous êtes rapidement invité à entrer et tout aussi rapidement payé par le noble.%SPEECH_ON%Bon travail, mercenaire. Vous êtes déjà un héros dans certaines parties de ces terres. Enfer, peut-être que vous finirez dans l\'un de ces parchemins, à jamais commémoré.%SPEECH_OFF%Vous entendez le scribe pousser un soupir. %employer% fait signe vers la porte.%SPEECH_ON%S\'il vous plaît ? J\'ai d\'immenses choses à étudier, et si peu de temps pour le faire.%SPEECH_OFF% | Vous entrez dans la pièce de %employer% pour trouver l\'homme profondément enfoncé dans sa chaise. Des paysans se disputent de chaque côté de lui, pointant et accusant.%SPEECH_ON%Cet homme est un meurtrier !%SPEECH_OFF%Le prévenu ricane.%SPEECH_ON%Meurtrier ? Ce qui s\'est passé était un accident ! Je pensais qu\'il était l\'un de ces morts-vivants !%SPEECH_OFF%L\'autre homme ricane cette fois-ci.%SPEECH_ON%Mort-vivant ? Il était simplement ivre !%SPEECH_OFF%Les tempéraments montent.%SPEECH_ON%Eh bien, j\'ai entendu grogner ! Ou gémir.%SPEECH_OFF%Votre employeur vous fait signe de manière désespérée.%SPEECH_ON%Mercenaire, bon travail pour avoir sauvé cette ville. Votre paiement.%SPEECH_OFF%Il pousse un sac de %reward_completion% couronnes sur la table. Les paysans font une pause, fixant les pièces qui scintillent hors de son sommet ouvert. Vous prenez le sac, prétendant qu\'il pèse bien trop lourd pour vous.%SPEECH_ON%Ouf, tellement lourd ! Vous messieurs, passez une bonne journée.%SPEECH_OFF% | %employer% vous accueille dans sa pièce.%SPEECH_ON%Mes petits oiseaux me parlent du sauvetage de la ville. Vous avez bien fait, mercenaire, assez bien dans un monde devenu si sombre. Votre paiement de %reward_completion% couronnes, comme convenu.%SPEECH_OFF% | %employer% est debout dehors, regardant vers un cimetière qui a rassemblé pas mal de résidents depuis votre dernière visite. Il vous tend un sac de %reward_completion% couronnes.%SPEECH_ON%Vous avez bien fait, mercenaire. La nouvelle de vos exploits s\'est répandue à travers le pays. Un succès ne nous sauvera pas tous, mais il nous met sur la bonne voie. Si nous devons remporter cette maudite guerre contre les morts, nous avons besoin de tout l\'esprit et de tout l\'espoir que nous pouvons rassembler.%SPEECH_OFF%Prendant votre paiement, vous ajoutez que les mercenaires ont besoin de autant de couronnes que possible. Vous savez, pour garder leurs "esprits" élevés. Le noble sourit.%SPEECH_ON%Je suis sanctimonieux, pas philanthrope. Allez-vous-en d\'ici.%SPEECH_OFF% | Les gardes de %employer% vous emmènent dans sa pièce. Il a quelques parchemins déroulés tout autour de lui. Des plumes cassées jonchent sa table comme si quelqu\'un y avait éclaboussé un oiseau. %employer% vous lance un sac de %reward_completion% couronnes.%SPEECH_ON%Mercenaire ! C\'est bon de voir l\'homme de l\'heure, du jour, de la semaine ! Vous avez bien fait de sauver cette ville.%SPEECH_OFF%Il vous lance un sac de %reward_completion% couronnes.%SPEECH_ON%Une victoire pour maintenir une ville en vie, une victoire de plus pour nous porter jusqu\'au lendemain. Mmm, merci mercenaire.%SPEECH_OFF%Vous prenez votre paiement avec tristesse, faisant signe de la tête et répondant.%SPEECH_ON%Eh bien, c\'est l\'intention qui compte.%SPEECH_OFF%Le noble snappe des doigts.%SPEECH_ON%Exactement !%SPEECH_OFF% | Vous trouvez %employer% affalé profondément dans sa chaise avec une moue encore plus profonde. Ses vêtements scintillent d\'une opulence brillante et les chandeliers semblent valoir plus cher que les serviteurs qui les tiennent. Le grincheux voyant fait signe désespérément de vous approcher. Il parle lentement et sarcastiquement.%SPEECH_ON%Une victoire pour l\'homme. Une victoire de plus pour nous porter jusqu\'au lendemain. Mmm, merci mercenaire.%SPEECH_OFF%Vous avancez lentement, les serviteurs vous dévisagent avec des yeux craintifs. Vous prenez votre paiement et reculez. %employer% vous fait signe de vous éloigner maintenant.%SPEECH_ON%Partez. J\'espère vous revoir, à moins que vous ne soyez mal en point et en corps mort, alors ce serait une honte. Encore une fois, c\'est ainsi que nous allons tous finir, n\'est-ce pas ?%SPEECH_OFF%Vous ne dites rien et prenez congé. Il semble que la guerre contre les morts sans fin ait pesé sur le noble.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective% est sauvé.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Defended " + this.Flags.get("ObjectiveName") + " against undead");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
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
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Autour de %objective%",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Les morts-vivants étaient trop nombreux, et vous avez dû battre en retraite. Malheureusement, une ville entière n\'a pas de telles libertés, et ainsi %objective% a été complètement submergée. Vous n\'êtes pas resté pour voir ce que sont devenus ses citoyens, bien que cela ne prenne pas un génie pour deviner. | La %companyname% a été défaite sur le champ de bataille par les hordes de morts-vivants ! À la suite de votre échec, %objective% est rapidement submergée. Une masse de paysans fuit la ville et ceux trop lents sont ajoutés à la mer de cadavres qui errent. | Vous n\'avez pas réussi à repousser les morts-vivants ! Les cadavres se déplacent lentement au-delà des murs de %objective% et dévorent et tuent tout sur leur passage. En fuyant le champ de bataille, vous voyez le lieutenant des gardes avancer aux côtés de la horde de cadavres.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "%objective% est perdu.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to defend " + this.Flags.get("ObjectiveName") + " against undead");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnWave()
	{
		local undeadBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(this.m.Origin.getTile());
		local originTile = this.m.Origin.getTile();
		local tile;

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 5, originTile.SquareCoords.X + 5);
			local y = this.Math.rand(originTile.SquareCoords.Y - 5, originTile.SquareCoords.Y + 5);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			local navSettings = this.World.getNavigator().createSettings();
			navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
			local path = this.World.getNavigator().findPath(tile, originTile, navSettings, 0);

			if (!path.isEmpty())
			{
				break;
			}
		}

		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(tile, "Undead Horde", false, this.Const.World.Spawn.UndeadArmy, (80 + this.m.Flags.get("Wave") * 10) * this.getDifficultyMult() * this.getScaledDifficultyMult());
		this.m.UnitsSpawned.push(party.getID());
		party.getLoot().ArmorParts = this.Math.rand(0, 15);
		party.getSprite("banner").setBrush(undeadBase.getBanner());
		party.setDescription("A legion of walking dead, back to claim from the living what was once theirs.");
		party.setFootprintType(this.Const.World.FootprintsType.Undead);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		party.setAttackableByAI(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(originTile);
		c.addOrder(attack);
		local destroy = this.new("scripts/ai/world/orders/convert_order");
		destroy.setTime(60.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(originTile);
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function spawnUndeadAtTheWalls()
	{
		local undeadBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getNearestSettlement(this.m.Origin.getTile());
		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).spawnEntity(this.m.Origin.getTile(), "Undead Horde", false, this.Const.World.Spawn.ZombiesOrZombiesAndGhosts, 100 * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.setPos(this.createVec(party.getPos().X - 50, party.getPos().Y - 50));
		this.m.UnitsSpawned.push(party.getID());
		party.getLoot().ArmorParts = this.Math.rand(0, 15);
		party.getSprite("banner").setBrush(undeadBase.getBanner());
		party.setDescription("A legion of walking dead, back to claim from the living what was once theirs.");
		party.setFootprintType(this.Const.World.FootprintsType.Undead);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(15.0);
		c.addOrder(wait);
		local destroy = this.new("scripts/ai/world/orders/convert_order");
		destroy.setTime(90.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(this.m.Origin.getTile());
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function spawnGhouls()
	{
		local originTile = this.m.Origin.getTile();
		local tile;

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 5, originTile.SquareCoords.X + 5);
			local y = this.Math.rand(originTile.SquareCoords.Y - 5, originTile.SquareCoords.Y + 5);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			local navSettings = this.World.getNavigator().createSettings();
			navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
			local path = this.World.getNavigator().findPath(tile, originTile, navSettings, 0);

			if (!path.isEmpty())
			{
				break;
			}
		}

		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(tile, "Nachzehrers", false, this.Const.World.Spawn.Ghouls, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
		this.m.UnitsSpawned.push(party.getID());
		party.getSprite("banner").setBrush("banner_beasts_01");
		party.setDescription("A flock of scavenging nachzehrers.");
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		party.setAttackableByAI(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(originTile);
		c.addOrder(attack);
		local destroy = this.new("scripts/ai/world/orders/convert_order");
		destroy.setTime(60.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(originTile);
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
		_vars.push([
			"direction",
			this.m.Origin == null || this.m.Origin.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Origin.getTile())]
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					e.setAttackableByAI(true);
					e.setOnCombatWithPlayerCallback(null);
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.Origin.hasSprite("selection"))
			{
				this.m.Origin.getSprite("selection").Visible = false;
			}

			if (this.m.Home != null && !this.m.Home.isNull() && this.m.Home.hasSprite("selection"))
			{
				this.m.Home.getSprite("selection").Visible = false;
			}
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(2);
			}
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
	}

});

