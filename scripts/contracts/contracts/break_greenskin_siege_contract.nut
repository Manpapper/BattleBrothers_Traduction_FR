this.break_greenskin_siege_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Troops = null,
		IsPlayerAttacking = true,
		IsEscortUpdated = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(90, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.break_greenskin_siege";
		this.m.Name = "Briser le siège";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
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
		local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.m.Origin.getTile());
		this.m.Flags.set("OrcBase", nearest_orcs.getID());
		local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.m.Origin.getTile());
		this.m.Flags.set("GoblinBase", nearest_goblins.getID());
		this.m.Payment.Pool = 1500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Voyagez jusqu\'à %objective%",
					"Brisez le siège des Peaux-Vertes"
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
				local okLocations = 0;

				foreach( l in this.Contract.m.Origin.getAttachedLocations() )
				{
					if (l.isActive())
					{
						okLocations = ++okLocations;
					}
				}

				if (okLocations < 3)
				{
					foreach( l in this.Contract.m.Origin.getAttachedLocations() )
					{
						if (!l.isActive() && !l.isMilitary())
						{
							l.setActive(true);
							okLocations = ++okLocations;

							if (okLocations >= 3)
							{
								break;
							}
						}
					}
				}

				local faction = this.World.FactionManager.getFaction(this.Contract.getFaction());
				local party = faction.spawnEntity(this.Contract.getHome().getTile(), this.Contract.getHome().getName() + " Company", true, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush(faction.getBannerSmall());
				party.setDescription("Soldats professionnels au service des seigneurs locaux.");
				this.Contract.m.Troops = this.WeakTableRef(party);
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Medicine = this.Math.rand(0, 5);
				party.getLoot().Ammo = this.Math.rand(0, 30);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/dried_fruits_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/ground_grains_item");
				}

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(this.Contract.getOrigin().getTile());
				c.addOrder(move);
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
				}

				this.World.State.setEscortedEntity(this.Contract.m.Troops);
			}

			function update()
			{
				if (this.Flags.get("IsContractFailed"))
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Company broke a contract");
					this.World.Contracts.finishActiveContract(true);
					return;
				}

				if (this.Contract.m.Troops != null && !this.Contract.m.Troops.isNull())
				{
					if (!this.Contract.m.IsEscortUpdated)
					{
						this.World.State.setEscortedEntity(this.Contract.m.Troops);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Troops.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(this.Const.World.SpeedSettings.FastMult);
					}

					this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.FastMult;
				}

				if ((this.Contract.m.Troops == null || this.Contract.m.Troops.isNull() || !this.Contract.m.Troops.isAlive()) && !this.Flags.get("IsTroopsDeadShown"))
				{
					this.Flags.set("IsTroopsDeadShown", true);
					this.World.State.setCampingAllowed(true);
					this.World.State.setEscortedEntity(null);
					this.World.State.getPlayer().setVisible(true);
					this.World.Assets.setUseProvisions(true);

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(1.0);
					}

					this.World.State.m.LastWorldSpeedMult = 1.0;
					this.Contract.setScreen("TroopsHaveDied");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Origin, 1200))
				{
					if (this.Contract.m.Troops == null || this.Contract.m.Troops.isNull())
					{
						this.Contract.setScreen("ArrivingAtTheSiegeNoTroops");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.m.Troops.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
						this.Contract.setScreen("ArrivingAtTheSiege");
						this.World.Contracts.showActiveContract();
					}

					this.World.State.setCampingAllowed(true);
					this.World.State.setEscortedEntity(null);
					this.World.State.getPlayer().setVisible(true);
					this.World.Assets.setUseProvisions(true);

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(1.0);
					}

					this.World.State.m.LastWorldSpeedMult = 1.0;
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsContractFailed", true);
			}

		});
		this.m.States.push({
			ID = "Running_BreakSiege",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Détruisez tous les engins de siège des Peaux-Vertes",
					"Tuez toutes les Peaux-Vertes autour de %objective%"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null)
					{
						e.getSprite("selection").Visible = true;

						if (e.getFlags().has("SiegeEngine"))
						{
							e.setOnCombatWithPlayerCallback(this.onCombatWithSiegeEngines.bindenv(this));
						}
					}
				}
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0)
				{
					this.Contract.setScreen("TheAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithSiegeEngines( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.Music = this.Const.Music.GoblinsTracks;
				p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
				p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
				p.EnemyBanners = [
					this.World.getEntityByID(this.Flags.get("GoblinBase")).getBanner()
				];
				this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% vous tend un gobelet de vin.%SPEECH_ON%Buvez.%SPEECH_OFF%Vous pouvez presque sentir les mauvaises nouvelles venir juste avec son haleine. Vous avalez le verre d\'un trait et vous faites un signe de tête à l\'homme. Il fait de même.%SPEECH_ON%Les peaux-vertes envahissent la région et on dirait qu\'ils prévoient de prendre %objective%.%SPEECH_OFF%Il se verse un autre verre, le boit, puis s\'en verse un autre.%SPEECH_ON%Si la position tombe, alors je pense que nous pouvons supposer que le reste de la région tombera avec elle. Je ne sais pas si vous êtes au courant de ce qui s\'est passé il y a dix ans la dernière fois que ces monstres sont passés, mais peu de gens ici veulent que cela se reproduise. Maintenant, mes espions me disent que le siège vient juste de commencer et que les peaux vertes n\'ont pas encore amenés toutes leurs forces, ce qui signifie que nous pouvons attaquer maintenant et briser le siège avant que les choses s\'enveniment. Si vous êtes intéressé, ce que j\'espère par les dieux, j\'ai besoin que vous y alliez et que vous brisiez ce siège !%SPEECH_OFF% | Les gardes sont autour de %employer%. Ils n\'ont pas de casque, leurs têtes sont couvertes de sueur, et certains tremblent dans leur armure. %employer%, vous voyant à travers la foule désespérée, vous fait signe d\'avancer.%SPEECH_ON%Sellsword! J\'ai des nouvelles... particulièrement horribles. Vous en avez peut-être déjà entendu parler, mais je vais vous en parler rapidement car le temps presse : les peaux-vertes ont probablement envahi la région et ils menacent de prendre %objective%. Ils en font actuellement le siège, mais les rapports disent que les peaux-vertes n\'ont pas finis de rassembler leurs forces. J\'ai besoin que vous y alliez et que vous les tuiez avant que les choses ne deviennent hors de notre contrôle.%SPEECH_OFF% | %employer% a quelques scribes à ses côtés. Ils chuchotent à tour de rôle, le noble acquiesçant simplement à tout ce qu\'ils disent. Finalement, %employer% tourne son attention vers vous.%SPEECH_ON%Mercenaire, avez-vous déjà brisé un siège avant ? %objective% dans la région est actuellement assiégé par les peaux vertes. Nous n\'avons que peu de temps avant qu\'ils n\'envahissent l\'endroit, et qu\'ils ne prennent toute la région ! Après ça... eh bien, je suis sûr que vous savez ce qui s\'est passé il y a dix ans.%SPEECH_OFF%Les scribes acquiescent à l\'unisson et baissent la tête. %employer% continue.%SPEECH_ON%Alors qu\'en dites-vous, intéressé pour un peu d\'action ?%SPEECH_OFF% | %employer% vous accueille avec un visage inquiet.%SPEECH_ON%On est un peu dans le pétrin, mercenaire, et on a besoin de ton aide ! %objective% a été assiégé par les peaux vertes et je n\'ai pas assez de troupes pour aller le briser le siège tout seul. Mais je pense que vous êtes à la hauteur de la tâche. N\'est-ce pas ? Je paierai généreusement.%SPEECH_OFF% | %employer% est debout, les bras posés sur une table. Ses épaules sont voûtées, comme un corbeau qui regarde sa proie. Il secoue la tête.%SPEECH_ON%Mercenaire, j\'ai besoin de plus de personnes pour aider à lever un siège mené par une armée de peaux vertes qui assiège %objective%. Êtes-vous prêt à le faire ? J\'ai besoin de le savoir maintenant.%SPEECH_OFF% | %employer% se tient debout à votre entrée. La sueur coule sur son visage et il esquisse un sourire désespéré.%SPEECH_ON%Mercenaire ! Je suis si heureux que vous soyez là ! La nouvelle est tombée que les peaux vertes ont assiégé %objective% et j\'ai besoin de votre aide ! Êtes-vous intéressé ou non ? J\'ai besoin d\'une décision rapide.%SPEECH_OFF% | Vous trouvez %employer% profondément enfoncé dans sa chaise, comme s\'il souhaitait que le dossier se referme et l\'exclue de ce monde pour toujours. Il fait un geste paresseux vers une carte sur une table.%SPEECH_ON%Eh bien, aux dernières nouvelles les peaux-vertes sont de retour et elles assiègent %objective%. J\'ai besoin d\'autant d\'hommes que possible pour aller les libérer. Le salaire sera approprié, vous en êtes ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combien ça vaudrait de sauvez %objective% pour vous? | Brisé un siège c\'est quelque chose que la compagnie %companyname% peut faire.}",
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
			ID = "PreparingForBattle",
			Title = "À %townname%...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Vous sortez de chez %employer% et préparez la compagnie. Tout autour de vous, des chevaliers et des soldats courent dans tous les sens. Quelques-uns d\'entre eux sont regroupés autour d\'un saint homme, se préparant silencieusement à la mort.%SPEECH_ON%Il faut réserver.%SPEECH_OFF%%randombrother% dit se joignant à vous. Il vous fait un bon sourire en coin.%SPEECH_ON%Quoi, trop sombre comme blague ?%SPEECH_OFF% | A l\'extérieur de la maison de %employer%, les soldats courent dans tous les sens. Certains entassent des provisions à l\'arrière des chariots, d\'autres affûtent leurs armes, tandis qu\'une poignée d\'écuyers vont et viennent avec de grandes quantités d\'armures. Vous vous dirigez vers vos hommes et leur ordonnez de se préparer. %randombrother% fait un signe de tête en direction de toute cette activité.%SPEECH_ON%Je présume que nous aurons des alliés avec nous cette fois-ci ?%SPEECH_OFF% | Il y a des soldats juste à l\'extérieur de la chambre de %employer%, et il y a des soldats dans les couloirs. Vous passez devant des chambres de femmes et d\'enfants effrayés et de vieillards aveugles qui préféreraient être sourds. À l\'extérieur, vous devez vous battre à travers une foule d\'écuyers grouillant d\'armes et d\'armures. Votre compagnie %companyname% vous attend.%SPEECH_ON%Allons-y. Ces hommes doivent se préparer à se battre, mais nous, on n\'a pas besoin de se préparer, pas vrai les gars ?%SPEECH_OFF% | Quand vous quittez la maison de %employer%, vous trouvez %randombrother% qui vous attend. Il observe les préparatifs de la bataille tout autour : des écuyers qui courent avec des armes et des armures, des hommes qui transportent des provisions dans des chariots, et des hommes saints qui apaisent momentanément les craintes des jeunes hommes. Vous dites à votre mercenaire de se préparer car vous allez suivre ces soldats pour briser le siège. | Vous sortez pour trouver les hommes de %employer% qui se préparent. Ils chargent leur équipement sur des chariots. Les femmes, les enfants et les anciens se tiennent sur le bord du chemin. La compagnie %companyname% se tient prête. Vous vous dirigez vers vos hommes et les informez de la tâche à accomplir. | En sortant, vous trouvez les soldats de %employer% qui se préparent pour la guerre. Les enfants se déchaînent, jouant à la guerre entre eux, riant dans l\'ignorance totale de la réalité. Les femmes, dont certaines ont déjà perdu un ou deux maris, sont beaucoup plus pensives. Vous passez devant le cortège et allez voir votre compagnie %companyname% pour mettre au courant vos hommes des détails de la tâche à accomplir. | Les soldats de %employer% se préparent pour la guerre. Les jeunes sont nerveux, masquant leur peur par un faux courage et des rires réticents. Les vétérans vaquent à leurs occupations, le visage des hommes qui connaissent de vieux amis qui ne sont jamais revenus. Et les fous, les yeux écarquillés et les sanglants, ils sont presque étourdis par la perspective de la guerre qui se prépare. Vous les ignorez tous pour aller informer votre compagnie %companyname% de ce qui se prépare. | En sortant, vous trouvez les soldats de %employer% qui se préparent à marcher. Les armes sont empilées et les hommes les choisissent. C\'est un spectacle étrange et cela montre un manque d\'organisation. Ce n\'est sans doute pas le meilleur des signes, mais vous l\'oubliez pour aller informer votre compagnie %companyname% de son nouveau contrat.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "C\'est parti !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TroopsHaveDied",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Tous les nobles soldats sont morts sur le chemin du siège. Mieux vaut eux que vous. %companyname% poursuit sa route en direction de %objective%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous devons continuer.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiege",
			Title = "Near %objective%...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Vous arrivez enfin au siège. Les peaux vertes entourent %objective% et vous regardez leurs engins de guerre envoyer des pierres enflammées dans les airs. La moitié de la ville semble déjà embrasée et vous voyez de petits points aux figures d\'hommes qui se précipitent pour combattre les incendies. Le lieutenant des soldats nobles vous ordonne d\'aller attaquer les engins de siège. Vous devez ensuite rejoindre les renforts et détruire les peaux vertes qui restent. | %objective% ressemble plus à un énorme feu de joie qu\'à une ville. Vous regardez les engins de siège des peaux-vertes lancer un bombardement rageur, les cieux se remplissant de pierres noires, de vaches mortes et de bois en feu. Le lieutenant des soldats nobles vous ordonne de détruire les engins de siège. Lui et ses hommes attaqueront le cœur de l\'armée des peaux-vertes, puis vous vous rejoindrez pour achever les survivants. | Le siège est toujours en cours, et %objective% résiste encore. Il semble que vous arriviez juste à temps, car les peaux-vertes provoquent une telle destruction avec leurs engins de siège qu\'il pourrait ne plus y avoir de ville du tout dans quelques heures. Voyant cela, le lieutenant des soldats nobles vous ordonne de prendre le flanc et de détruire les armes de siège. Lui et ses hommes attaqueront le coeur de l\'armée des peaux-vertes, puis ensemble vous vous rejoindrez pour massacrer les survivants. | Vous entendez les bombardements avant même de les voir. Le sifflement des tirs de siège parcourt l\'air comme un vent furieux, et le fracas de leur descente est encore plus violente. Finalement, vous atteignez le sommet d\'une colline pour avoir une bonne vue sur %objective%. Le lieu est entouré de sauvages verdoyants dont les engins de siège sont en pleine action, lançant des pierres, des vaches mortes, des paquets de cadavres humains, tout ce que ces salauds peuvent trouver.\n\nLe lieutenant des soldats nobles vient vous voir avec son plan. Vous allez prendre de flanc et attaquer les engins de siège. Lui et ses hommes attaqueront le coeur de l\'armée des peaux-vertes et, une fois l\'attaque réussie, vous vous rejoindrez pour anéantir ce qui reste. | Vous avez trouvé une jeune femme sur la route avec un groupe d\'enfants se serrant les uns contre les autres comme des petits loups dans un hiver brutal. Du sang séché coule sur le côté de sa tête, même si elle le cache bien avec une touffe de cheveux emmêlés. Elle explique que si vous allez à %objective%, vous devez vous dépêcher. Les peaux-vertes ont installé leurs armes de siège et lancent un bombardement furieux. Vous et les soldats nobles avancez, la femme est partie avec une sacoche de pain pour nourrir les enfants.\n\n En haut de la colline suivante, vous avez une vue qui confirme l\'histoire de laréfugiée. Le lieutenant des soldats nobles donne rapidement ses ordres. Vous et votre compagnie %companyname% attaquerez les engins de siège pendant que les soldats attaqueront le cœur de l\'armée des peaux-vertes. Une fois ces tâches accomplies, vous vous rejoindrez pour anéantir les survivants. | Vous et les soldats nobles êtes au sommet de la colline la plus proche de %objective%. La ville est toujours là, mais elle est plus proche d\'un tas de décombres que d\'une ville. Les peaux-vertes ont dû la bombarder avec leurs engins de siège de fortune depuis un certain temps déjà et ils ne semblent pas prêts de s\'arrêter.\n\n Le lieutenant des soldats nobles vous ordonne de flanquer les peaux-vertes et d\'attaquer les armes de siège. Pendant ce temps, les soldats attaqueront le cœur de l\'armée. Une fois les deux tâches accomplies, vous vous rejoindrez et détruirez les quelques survivants restants. | Vous trouvez un vieil homme qui pousse un chariot sur la route. Dans le lit, se trouve un jeune homme aux jambes écrasées. Il s\'est évanoui, ses mains serrant toujours ses genoux brisés. Le vieil homme dit que %objective% est juste là, derrière la colline la plus proche, et que la zone est bombardé par des armes de siège, alors si vous voulez agir, il vaut mieux le faire vite. La compagnie %companyname% et les soldats continuent d\'avancer, laissant le vieil homme avancer à pas de tortue.\n\n L\'ancien ne mentait pas : %objective% brûle et est lentement transformé en décombres par une ribambelle d\'engins de siège sauvages. Voyant cela de ses propres yeux, le lieutenant des soldats nobles concocte rapidement un plan d\'action : la compagnie %companyname% prendra le flanc et attaquera les armes de siège pendant que les soldats s\'attaqueront au gros de l\'armée des peaux-vertes. Une fois les deux tâches accomplies, vous vous rejoindrez et tuerez tout ce qui reste de vivant. | Vous trouvez une horde de chiens sauvages qui courent sur la route. Ils évitent votre groupe, mais vous remarquez qu\'ils ont la queue entre les jambes et la tête basse. Il n\'y a pas de pause dans leur démarche et ils vous dépassent rapidement.\n\n En haut de la colline suivante, vous voyez la cause du chaos : les peaux-vertes bombardent sans relâche %objective% avec des rangées de machines de siège. Le lieutenant des soldats nobles acquiesce et donne rapidement des ordres. La compagnie %companyname% va prendre le flanc et attaquer directement les armes de siège. Lorsque vous aurez terminé, vous ferez demi-tour, vous rejoindrez les soldats et vous continuerez à partir de là.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous au combat !",
					function getResult()
					{
						this.Contract.setState("Running_BreakSiege");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnSiege();
			}

		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiegeNoTroops",
			Title = "Near %objective%...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Vous voyez enfin %objective% et pour le moment ça ne se passe pas très bien. La ville est bombardée par un flot d\'engins de siège des peaux-vertes. Vous ordonnez à votre compagnie %companyname% de se préparer à l\'action : vous allez prendre l\'armée de flanc et attaquer directement les engins. | Tous les nobles soldats étant morts, vous arrivez seul à %objective%. Les peaux-vertes sont toujours à l\'œuvre, bombardant la pauvre ville avec des armes de siège de fortune. Vous décidez que le meilleur plan d\'action est de prendre les sauvages par le flanc et d\'attaquer leurs engins de siège.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous au combat !",
					function getResult()
					{
						this.Contract.setState("Running_BreakSiege");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnSiege();
			}

		});
		this.m.Screens.push({
			ID = "SiegeEquipmentAhead",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Les peaux vertes ont assemblés des armes de siège à proximité. Vous devrez les détruire pour aider à lever le siège ! | Vos hommes repèrent quelques engins de siège à proximité. Les peaux-vertes doivent se préparer pour un assaut ! Vous devez les détruire pour aider à lever le siège !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Allons-y !",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithSiegeEngines(null, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Shaman",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{En vous approchant du camp des gobelins, vous apercevez une silhouette assez unique parmi leurs rangs. C\'est celle d\'un shaman. Vous dites à vos hommes de se préparer de manière appropriée. | Une silhouette assez unique se dresse parmi les gobelins. Vous le voyez aboyer des ordres dans cette langue horrible qu\'ils prennent pour une langue. La chose immonde est enveloppée de plantes étranges et de ce qui semble être un collier d\'os d\'animaux.%SPEECH_ON%C\'est un shaman.%SPEECH_OFF%%randombrother% dit en se joignant à vous.%SPEECH_ON%Je vais alerter le reste des hommes.%SPEECH_OFF% | %randombrother% revient d\'une mission de reconnaissance. Il partage la nouvelle qu\'un chaman gobelin se trouve au sein du groupe de peaux-vertes envahisseur. L\'homme semble plutôt mécontent.%SPEECH_ON%J\'adore tuer des gobs, mais ces connards vont nous donner un vrai mal de tête cette fois.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Allons-y !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Warlord",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Alors que vous vous approchez des peaux-vertes en train de faire le siège, vous identifiez quelque chose qu\'il est presque impossible de manquer : la grande et imposante silhouette d\'un seigneur de guerre orque. L\'armure de la chose immonde brille tandis qu\'il se retourne pour aboyer des ordres dans sa langue orque, stimulant ses compagnons peaux-vertes dans une ferveur violente et frénétique. Vous dites à %randombrother% de transmettre la nouvelle et de préparer les hommes. | En vous approchant du siège, vous reconnaissez la silhouette grande et brutale d\'un chef de guerre orc. Même à cette distance, vous pouvez l\'entendre aboyer des ordres à ses grognards. Ce combat vient de devenir un peu plus intéressant. | Vous vous approchez du camp de siège des peaux-vertes et vous entendez le grognement distinct d\'un chef de guerre orc. Il hurle des ordres dans leur langage dégoûtant et assez fort. Sa présence modifie un peu la tâche à accomplir et vous en informez les hommes. | %randombrother% revient d\'une mission de reconnaissance. Il affirme qu\'il y a un seigneur de guerre orc dans le campement des peaux-vertes. Mauvaise nouvelle, mais mieux vaut le savoir maintenant et se préparer que d\'y aller et d\'être pris par surprise.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Allons-y !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TheAftermath",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{La bataille est terminée, les peaux vertes ont été chassées du champ de bataille. %objective% est sauvé et %employer% en sera très heureux. Vous enjambez les monticules de cadavres, hommes et bêtes confondus, et rassemblez vos hommes pour le retour. | Des corps jonchent le champ de bataille, des nuages de mouches commencent déjà à se rassembler et à s\'affairer. Vous rassemblez vos hommes et préparez un retournez voir %employer% pour votre paiement. | %objective% est sauvé ! Enfin, ce qu\'il en reste. Des soldats et des peaux-vertes, morts et mourants, jonchent le sol à perte de vue. C\'est un spectacle cruel, si récent. Vous ordonnez à votre compagnie %companyname% de se préparer à retournez voir %employer% pour votre paiement. | Des monticules de cadavres empilés sur deux, trois, parfois même quatre corps. Les survivants sont enterrés sous ces morts, à deux mètres en dessous alors qu\'ils sont en surface. C\'est un spectacle horrible, et un spectacle sonore encore pire lorsque les blessés et les mourants appellent à l\'aide. Les repérer dans cette mer de corps, c\'est comme essayer de trouver un marin flottant au dessus d\'un océan sombre. Vous vous détournez de la scène et rassemblez vos hommes. %employer% devrait attendre votre retour avec joie. | La bataille gagnée et terminée, vous regardez les hommes armés de piques parcourir prudemment le terrain. Ils utilisent la distance donnée par l\'arme pour éliminer en toute sécurité les peaux vertes blessées qui traînent encore. Le reste des soldats nobles s\'affaissent sur le sol, buvant de l\'eau et lavant le sang de leur visage. Vous n\'avez pas le temps de vous reposer et rassemblez rapidement vos mercenaires pour retournez voir %employer%. | Le sang souille la terre et vos bottes s\'enfoncent profondément dans la boue. Des cadavres gisent, des corps rendus méconnaissables, des parties de corps détachées et dispersées loin de leurs propriétaires. Des têtes décapitées ici et là, les yeux figés en état de choc. Des flèches brisées, des lances éclatées, des épées abandonnées. Des morceaux d\'armures brisées crissant sous les pieds. C\'était une sacré bataille et elle a certainement laissé assez de traces pour que tout le monde puisse venir et voir.\n\n Avec %objective% sauvé, vous rassemblez lentement votre compagnie %companyname% pour retournez voir %employer% pour votre paiement. | La bataille terminée, les soldatsnobles  ne perdent pas de temps pour décapiter tous les peaux-vertes qu\'ils trouvent. Ils plantent les têtes sur des piques et les élèvent bien haut, reflétant la barbarie des sauvages qu\'ils venaient d\'éliminer. Vous n\'avez pas le temps pour de telles mascarades. %objective% est sauvé et c\'est pour cela que vous serez payé. %companyname% se rassemble rapidement pour retourner voir %employer%. | La bataille terminée, vous traversez prudemment le champ de bataille. Chaque cadavre raconte une histoire sur la façon dont il est apparu. Certains ont été poignardés dans le dos, d\'autres n\'ont plus de tête, leur histoire est ailleurs, d\'autres encore ont été éviscérés et sont retrouvés serrant leurs entrailles avec des expressions choquées d\'avoir été témoins de choses qui ne devaient pas être vues. Rien de nouveau, tout est pareil, juste un endroit différent. Ce qui compte le plus, c\'est que %objective% soit toujours debout. Vous rassemblez votre compagnie %companyname% pour retourner voir %employer% et recevoir votre dû. | %randombrother% vient à vos côtés. Il tient la tête d\'une peau verte, mais la jette rapidement comme si la nouveauté qu\'elle représentait venait de s\'estomper. Il pose ses mains sur ses hanches et regarde le champ de bataille d\'un signe de tête.%SPEECH_ON%Eh bien, c\'était quelque chose.%SPEECH_OFF%Des cadavres, parfois empilés par trois ou quatre, jonchent le sol. Les membres se tordent, les visages sont tendus, le sang coule. Des hommes marchent dans ce bazar, leurs jambes crachent de grandes quantités de sang comme s\'ils marchaient dans un lit de ruisseau. %objective%, aussi brûlant soit-il, se tient toujours au loin et c\'est tout ce qui compte pour vous. %companyname% devrait maintenant retourner voir %employer% pour son paiement. | Le siège a été levé, bien que les peaux vertes ne l\'aient pas abandonné de leur plein gré. Les morts, hommes et bêtes, jonchent la terre à perte de vue. %randombrother% vient à vos côtés. Il soulève une bande de chair verte de son épaule et la chasse comme un chiffon humide.%SPEECH_ON%Un sacré combat, monsieur.%SPEECH_OFF%Vous acquiescez et lui ordonnez de préparer les hommes. %employer% devrait être très heureux d\'apprendre que %objective% a été sauvé.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Victoire !",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous retournez voir %employer% avec quelques-uns de ses lieutenants derrière vous. Ils rapportent la nouvelle et votre employeur acquiesce rapidement et vous remet une grande sacoche de couronnes. Ses lieutenants vous lancent quelques regards jaloux alors que vous prenez congé. | Le siège a été brisé et vous le signalez à %employer%. Il acquiesce et vous donne une sacoche de couronnes.%SPEECH_ON%Ils parleront de vous. Ceux qui ne sont pas encore nés, je veux dire.%SPEECH_OFF% | Vous annoncez à %employer% la nouvelle de la levée du siège. Il se lève et vous serre la main.%SPEECH_ON%Par les vieux dieux, votre service ici aujourd\'hui ne sera jamais oublié !%SPEECH_OFF%Mais dans votre tête, vous vous demandez si cette phrase exacte a été dite à un homme qui, maintenant, n\'est plus qu\'os et poussière. Vous prenez quand même la récompense, laissant l\'héritage et l\'histoire aux philosophes. | %employer% se réjouit de votre retour, se lève rapidement et manque de trébucher sur un de ses chiens.%SPEECH_ON%Mercenaire, j\'ai déjà entendu la grande nouvelle ! Le siège a été levé et vous avez donc mérité une belle récompense !%SPEECH_OFF%Il soulève un lourd coffre sur son bureau. Vous le prenez, en comptant les couronnes, puis vous partez. | %employer% est assis derrière son bureau quand vous entrez.%SPEECH_ON%Entrez, héros. Que doivent-ils inscrire à côté de votre nom ?%SPEECH_OFF%Vous demandez ce qu\'il veut dire.%SPEECH_ON%Un mercenaire, s\'il vous plaît. Ne soyez pas si modeste, ce que vous avez accompli est digne d\'être parlé par les langues de ceux qui ne sont pas encore nés !%SPEECH_OFF%Vous acquiescez.%SPEECH_ON%Oui, bien sûr. C\'est génial et tout. Mais où est mon argent ?%SPEECH_OFF%Les lèvres de votre employeur se pincent. Il acquiesce en retour et vous remet une sacoche.%SPEECH_ON%Un homme aux nombreuses tâches, j\'en suis sûr. Celle-ci n\'est rien pour vous, mais elle signifie beaucoup pour nous !%SPEECH_OFF% | %employer% regarde ses pieds quand vous entrez. Il y a quelqu\'un sous son bureau et il ne fait aucune tentative pour cacher sa maîtresse.%SPEECH_ON%Bienvenue, mercenaire ! Votre paie est dans le coin. Ce coin, là-bas. N\'essaie pas de jeter un coup d\'oeil.%SPEECH_OFF%Vous recevez votre récompense et vous vous dirigez vers la porte. %employer% vous appelle, un pouce fermement planté dans l\'air.%SPEECH_ON%Bon travail, d\'ailleurs.%SPEECH_OFF%Vous acquiescez et partez. | Vous entrez dans le bureau de %employer% avec quelques-uns de ses lieutenants juste derrière vous. L\'homme se lève à la vue de votre groupe, mais fait rapidement signe à ses soldats de sortir. Ils obéissent et partent lentement. Vous secouez la tête.%SPEECH_ON%Ils se sont battus, eux aussi.%SPEECH_OFF%%employer% vous fait signe pour que vous arrêtiez de parler.%SPEECH_ON%Bien sûr qu\'ils l\'ont fait, et ils ont déjà un salaire. Vous, par contre, vous êtes sous contrat et ce contrat a été rempli. D\'ailleurs, c\'est probablement mieux que ces hommes ne voient pas ce que je vous paie de toute façon.%SPEECH_OFF%Vous prenez votre récompense. C\'est certainement un montant qui suscite la jalousie et vous le cachez avant de sortir.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A brisé le siège de " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
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
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Around %objective%",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Vous avez mis trop de temps et maintenant %objective% est en ruine. Les peaux vertes ont envahi les murs avec une stratégie de choc et de peur. Vu l\'odeur qui flotte dans le vent, il suffit de peu pour comprendre que tout le monde à l\'intérieur a été massacré. | %companyname% n\'a pas brisé le siège à temps et maintenant %objective% en a fait les frais. Ils pensaient que vous alliez les sauver, mais au lieu de cela, vous les avez tous laissés tomber. S\'il y a une bonne nouvelle, c\'est que personne n\'a survécu pour se plaindre de votre échec. Votre employeur, %employer%, par contre, c\'est une autre histoire. Le noble sera sans doute furieux de votre inaction. | %objective% a été envahi ! Les orcs ont conduit de terrifiantes machines de guerre jusqu\'aux murs et ont détruit les défenses. Des peaux-vertes meurtrières ont inondé la ville, tuant tout sur leur passage ou les emmenant prisonniers où seuls les dieux savent. Votre employeur, %employer%, est furieux que vous n\'ayez pas fait votre travail ! | Vous n\'avez pas arrivé à %objective% à temps ! Les peaux-vertes ont défoncé les portes d\'entrée et, eh bien, la ville a été anéantie. Étant donné que %employer% vous paie pour le résultat exactement inverse, on peut supposer qu\'il n\'est pas heureux de cette tournure des événements. | Avec vous qui ne faites pas votre travail, %objective% est tombé aux mains des peaux-vertes ! Que les dieux aient pitié de ses citoyens, et ne vous attendez pas à ce que %employer% soit heureux de ce résultat.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "%objective% est tombé.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "N\'a pas réussi à briser le siège de " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnSiege()
	{
		if (this.m.Flags.get("IsSiegeSpawned"))
		{
			return;
		}

		this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));
		local originTile = this.m.Origin.getTile();
		local orcBase = this.World.getEntityByID(this.m.Flags.get("OrcBase"));
		local goblinBase = this.World.getEntityByID(this.m.Flags.get("GoblinBase"));
		local numSiegeEngines;

		if (this.m.DifficultyMult >= 1.15)
		{
			numSiegeEngines = this.Math.rand(1, 2);
		}
		else
		{
			numSiegeEngines = 1;
		}

		local numOtherEnemies;

		if (this.m.DifficultyMult >= 1.25)
		{
			numOtherEnemies = this.Math.rand(2, 3);
		}
		else if (this.m.DifficultyMult >= 0.95)
		{
			numOtherEnemies = 2;
		}
		else
		{
			numOtherEnemies = 1;
		}

		for( local i = 0; i < numSiegeEngines; i = ++i )
		{
			local tile;
			local tries = 0;

			while (tries++ < 500)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 2, originTile.SquareCoords.X + 2);
				local y = this.Math.rand(originTile.SquareCoords.Y - 2, originTile.SquareCoords.Y + 2);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) <= 1)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				if (tile.IsOccupied)
				{
					continue;
				}

				break;
			}

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Siege Engines", false, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(100, 120) * this.getDifficultyMult() * this.getScaledDifficultyMult());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("Une horde de peaux-vertes et leurs engins de siège.");
			local numSiegeUnits = this.Math.rand(3, 4);

			for( local j = 0; j < numSiegeUnits; j = ++j )
			{
				this.Const.World.Common.addTroop(party, {
					Type = this.Const.World.Spawn.Troops.GreenskinCatapult
				}, false);
			}

			party.updateStrength();
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
			party.getSprite("body").setBrush("figure_siege_01");
			party.getSprite("banner").setBrush(goblinBase != null ? goblinBase.getBanner() : "banner_goblins_01");
			party.getSprite("banner").Visible = false;
			party.getSprite("base").Visible = false;
			party.setAttackableByAI(false);
			party.getFlags().add("SiegeEngine");
			local c = party.getController();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
			local wait = this.new("scripts/ai/world/orders/wait_order");
			wait.setTime(9000.0);
			c.addOrder(wait);
		}

		local targets = [];

		foreach( l in this.m.Origin.getAttachedLocations() )
		{
			if (l.isActive() && l.isUsable())
			{
				targets.push(l);
			}
		}

		if (targets.len() == 0)
		{
			foreach( l in this.m.Origin.getAttachedLocations() )
			{
				if (l.isUsable())
				{
					targets.push(l);
				}
			}
		}

		for( local i = 0; i < numOtherEnemies; i = ++i )
		{
			local tile;
			local tries = 0;

			while (tries++ < 500)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 4, originTile.SquareCoords.X + 4);
				local y = this.Math.rand(originTile.SquareCoords.Y - 4, originTile.SquareCoords.Y + 4);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) <= 1)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				break;
			}

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Greenskin Horde", false, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(90, 110) * this.getDifficultyMult() * this.getScaledDifficultyMult());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("Une horde de peaux-vertes en marche vers la guerre.");
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
			party.getSprite("banner").setBrush(orcBase != null ? orcBase.getBanner() : "banner_orcs_01");
			local c = party.getController();
			local raidTarget = targets[this.Math.rand(0, targets.len() - 1)].getTile();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			local raid = this.new("scripts/ai/world/orders/raid_order");
			raid.setTime(30.0);
			raid.setTargetTile(raidTarget);
			c.addOrder(raid);
			local destroy = this.new("scripts/ai/world/orders/destroy_order");
			destroy.setTime(60.0);
			destroy.setSafetyOverride(true);
			destroy.setTargetTile(originTile);
			destroy.setTargetID(this.m.Origin.getID());
			c.addOrder(destroy);
		}

		if (this.m.Troops != null && !this.m.Troops.isNull())
		{
			local c = this.m.Troops.getController();
			c.clearOrders();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.getEntityByID(this.m.UnitsSpawned[this.m.UnitsSpawned.len() - 1]));
			c.addOrder(intercept);
			local guard = this.new("scripts/ai/world/orders/guard_order");
			guard.setTarget(originTile);
			guard.setTime(120.0);
		}

		this.m.Origin.spawnFireAndSmoke();
		this.m.Origin.setLastSpawnTimeToNow();
		this.m.Flags.set("IsSiegeSpawned", true);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.State.setCampingAllowed(true);
			this.World.State.setEscortedEntity(null);
			this.World.State.getPlayer().setVisible(true);
			this.World.Assets.setUseProvisions(true);

			if (!this.World.State.isPaused())
			{
				this.World.setSpeedMult(1.0);
			}

			this.World.State.m.LastWorldSpeedMult = 1.0;

			if (!this.m.Flags.get("IsSiegeSpawned"))
			{
				this.spawnSiege();
			}

			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					e.setAttackableByAI(true);

					if (e.getFlags().has("SiegeEngine"))
					{
						local c = e.getController();
						c.clearOrders();
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(120.0);
						c.addOrder(wait);
					}
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull())
			{
				this.m.Origin.getSprite("selection").Visible = false;
			}

			if (this.m.Home != null && !this.m.Home.isNull())
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
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return false;
		}

		local numAttachments = 0;

		foreach( l in this.m.Origin.getAttachedLocations() )
		{
			if (l.isActive() && l.isUsable())
			{
				numAttachments = ++numAttachments;
			}
		}

		if (numAttachments < 2)
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Troops != null && !this.m.Troops.isNull())
		{
			_out.writeU32(this.m.Troops.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local troops = _in.readU32();

		if (troops != 0)
		{
			this.m.Troops = this.WeakTableRef(this.World.getEntityByID(troops));
		}

		this.contract.onDeserialize(_in);
	}

});

