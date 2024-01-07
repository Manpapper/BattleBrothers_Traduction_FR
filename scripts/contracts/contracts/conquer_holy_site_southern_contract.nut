this.conquer_holy_site_southern_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.conquer_holy_site_southern";
		this.m.Name = "Conquer Holy Site";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
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

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();
		local target;
		local targetIndex = 0;
		local closestDist = 9000;
		local myTile = this.m.Home.getTile();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && !this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					local d = myTile.getDistanceTo(v.getTile());

					if (d < closestDist)
					{
						target = v;
						targetIndex = i;
						closestDist = d;
					}
				}
			}
		}

		this.m.Destination = this.WeakTableRef(target);
		this.m.Destination.setVisited(true);
		local b = -1;

		do
		{
			local r = this.Math.rand(0, this.Const.PlayerBanners.len() - 1);

			if (this.World.Assets.getBanner() != this.Const.PlayerBanners[r])
			{
				b = this.Const.PlayerBanners[r];
				break;
			}
		}
		while (b < 0);

		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("DestinationIndex", targetIndex);
		this.m.Flags.set("MercenaryPay", this.beautifyNumber(this.m.Payment.Pool * 0.5));
		this.m.Flags.set("Mercenary", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.m.Flags.set("MercenaryCompany", this.Const.Strings.MercenaryCompanyNames[this.Math.rand(0, this.Const.Strings.MercenaryCompanyNames.len() - 1)]);
		this.m.Flags.set("MercenaryBanner", b);
		this.m.Flags.set("Commander", this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]);
		this.m.Flags.set("EnemyID", target.getFaction());
		this.m.Flags.set("MapSeed", this.Time.getRealTime());
		this.m.Flags.set("OppositionSeed", this.Time.getRealTime());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Reprenez %holysite% des païens du Nord",
					"Détruisez ou déroutez les régiments ennemis dans les alentours"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					this.Flags.set("IsAlliedArmy", true);
				}
				else if (r <= 40)
				{
					this.Flags.set("IsSallyForth", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsMercenaries", true);
				}
				else if (r <= 80)
				{
					this.Flags.set("IsCounterAttack", true);
				}

				if (this.Contract.getDifficultyMult() >= 1.15)
				{
					this.Contract.spawnEnemy();
				}
				else if (this.Contract.getDifficultyMult() <= 0.85)
				{
					local entities = this.World.getAllEntitiesAtPos(this.Contract.m.Destination.getPos(), 1.0);

					foreach( e in entities )
					{
						if (e.isParty())
						{
							e.getController().clearOrders();
						}
					}
				}

				local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

				foreach( n in nobles )
				{
					if (n.getFlags().get("IsHolyWarParticipant"))
					{
						n.addPlayerRelation(-99.0, "A pris parti dans la guerre");
					}
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
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
					this.Contract.m.Destination.setOnEnterCallback(this.onDestinationAttacked.bindenv(this));
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onCounterAttack.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsCounterAttack"))
					{
						this.Contract.setScreen("CounterAttack1");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Contract.isEnemyPartyNear(this.Contract.m.Destination, 400.0))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCounterAttack( _dest, _isPlayerInitiated )
			{
				if (this.Flags.get("IsCounterAttackDefend") && this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.LocationTemplate.ShiftX = -4;
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.MapSeed = this.Flags.getAsInt("MapSeed");
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onDestinationAttacked( _dest )
			{
				if (this.Flags.getAsInt("OppositionSeed") != 0)
				{
					this.Math.seedRandom(this.Flags.getAsInt("OppositionSeed"));
				}

				if (this.Flags.get("IsVictory") || this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					return;
				}
				else if (this.Flags.get("IsAlliedArmy"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AlliedArmy");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
						p.CombatID = "ConquerHolySite";
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner(),
							this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, true, true, true);
					}
				}
				else if (this.Flags.get("IsSallyForth"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("SallyForth");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "ConquerHolySite";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else if (this.Flags.get("IsMercenaries"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Mercenaries1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
						p.CombatID = "ConquerHolySite";
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (130 + (this.Flags.get("MercenariesAsAllies") ? 30 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];

						if (this.Flags.get("MercenariesAsAllies"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.Flags.get("MercenaryBanner"));
						}
						else
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
							p.EnemyBanners.push(this.Flags.get("MercenaryBanner"));
						}

						this.World.Contracts.startScriptedCombat(p, true, true, true);
					}
				}
				else if (this.Flags.get("IsCounterAttack") && this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsCounterAttackDefend"))
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
						p.LocationTemplate.ShiftX = -2;
						p.CombatID = "ConquerHolySiteCounterAttack";
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "ConquerHolySiteCounterAttack";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Attacking");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
					p.CombatID = "ConquerHolySite";
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.Music = this.Const.Music.NobleTracks;
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (this.Flags.get("IsCounterAttack") ? 110 : 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.AllyBanners = [
						this.World.Assets.getBanner()
					];
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];
					this.World.Contracts.startScriptedCombat(p, true, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "ConquerHolySiteCounterAttack")
				{
					this.Flags.set("IsCounterAttack", false);
					this.Flags.set("IsVictory", true);
				}
				else if (_combatID == "ConquerHolySite")
				{
					this.Flags.set("IsVictory", true);
					this.Flags.set("OppositionSeed", this.Time.getRealTime());
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "ConquerHolySite" || _combatID == "ConquerHolySiteCounterAttack")
				{
					this.Flags.set("IsFailure", true);
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

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnEnterCallback(null);
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
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
			Text= "[img]gfx/ui/events/event_162.png[/img]{Vous trouvez %employer% derrière une pile de parchemins. Il est occupé à la tâche d\'écriture, et les hommes saints autour de lui sont tout aussi occupés à prêter attention, veillant à dérober un parchemin dès qu\'il a capturé les dernières paroles du Vizir. L\'homme à l\'importance du griffonnage lève enfin les yeux.%SPEECH_ON%Nous avons un problème avec %holysite% qui est violé par des rats du nord. Je vais essayer de tempérer mes sentiments à ce sujet, car il n\'est pas dans la voie du Gilder de souiller les émotions avec des nuances de fureur. Permettez-moi donc de déclarer clairement que la présence de ces sauvages offense l\'appétit rationnel.%SPEECH_OFF%Le Vizir trempe une plume et retourne à son écriture et à sa parole.%SPEECH_ON%Mais, si le chien aboie, les oiseaux s\'envoleront. J\'ai besoin d\'un chien, Crownling, et d\'un chien qui morde. Emmenez votre compagnie sur la terre sainte et délogez les réprouvés. Si nous sommes d\'accord, alors %reward% couronnes et l\'éclat du Gilder vous attendront à votre retour.%SPEECH_OFF% | %employer% vous accueille avec une chaleur surprenante.%SPEECH_ON%Je savais que c\'était vrai, que le Gilder m\'amènerait un homme d\'une grande importance, un homme de sérieuse puissance. Un Crownling, certes. Mais un guerrier ? Certainement !%SPEECH_OFF%Avant que vous puissiez demander la nature de l\'affaire, le Vizir tient une coupe dorée avec la moitié de la bordure tranchée comme le rebord de la lune.%SPEECH_ON%Notre terre la plus sainte, %holysite%, a été prise par des barbares du nord. Notre monde est menacé d\'obscurité, et pour repousser l\'ombre, nous devons être propices dans nos efforts. Les hommes de mon domaine sont nombreux, mais les terres sous le regard du Gilder s\'étendent loin. J\'ai besoin de soldats comme vous pour aider à revendiquer %holysite%. Car c\'est une partie de cette terre dont le Gilder est suzerain, et le Gilder nous paie tous : %reward% couronnes pour l\'achèvement de la tâche. Avons-nous un accord ?%SPEECH_OFF% | Dans une vision rare, vous trouvez %employer% prosterné sous la sublimité d\'un écusson brillant en forme de soleil. Il chuchote quelques mots pour lui-même, puis se lève, puis chuchote à nouveau, nettoie ses doigts un à un, et se tourne vers vous.%SPEECH_ON%Pendant que mes troupes font des avancées propices ailleurs, %holysite% a été laissé sans défense. Dans ma volonté de gagner cette guerre, j\'ai laissé la porte ouverte aux barbares du nord pour qu\'ils la prennent. Je demande, face à vous, une partie d\'aide extérieure. Le Gilder nous fournira tous le chemin doré, Crownling, et vous n\'êtes pas en dehors de Sa générosité. À travers ma main, vous aurez %reward% couronnes si vous reprenez %holysite% !%SPEECH_OFF% | Une coupe dorée se disperse sur les sols marbrés et le vin éclabousse dans tous les sens. Le Vizir vous crie dessus, un mélange de colère et de besoin.%SPEECH_ON%Enfin, quelqu\'un qui peut être d\'assistance !%SPEECH_OFF%Il chasse quelques assistants et même quelques-uns de ce qui semblent être ses propres lieutenants.%SPEECH_ON%Crownling, %holysite% a été conquise par l\'ordure du nord. J\'ai pleuré à la pensée qu\'ils la pillent, et je pleurerai à nouveau pour chaque jour qu\'ils souillent une des empreintes du Gilder. %reward% couronnes. C\'est la somme qui sera acquise et placée dans vos poches. Une somme importante pour vous, certainement, mais il est vrai ce qu\'on dit, que pour certains, la voie du chemin doré est peut-être plus littérale que pour d\'autres.%SPEECH_OFF% | %employer% est entouré d\'hommes chargés de soie. L\'un porte des lucioles dans une cage à capuchon, les lumières d\'insectes ternes clignotant ici et là. L\'autre a une cage avec les restes d\'un oiseau mort, dépouillé entièrement jusqu\'à l\'os, sauf pour deux plumes qui semblent reproduire l\'intégralité de ce qui étaient autrefois ses ailes. En vous voyant, le Vizir se place entre ces hommes comme on se placerait entre les piliers inébranlables d\'un temple.%SPEECH_ON%Crownling, | vous êtes ici ! Mes éclaireurs ont rapporté que nous avons fait un pas en arrière dans cette guerre contre les chiens du nord. %holysite% a été capturé et, selon les murmures du Gilder, je dois le récupérer pour nous. Non seulement pour mon domaine, mais pour que Sa sublimité puisse supporter la moindre nuance. Vous recevrez %reward% couronnes pour cette entreprise, une somme lourde pour une tâche lourde, n\'est-ce pas !%SPEECH_OFF% | Ordinairement ordonné dans l\'opulence et entouré de prodigues familiers, vous trouvez %employer% agenouillé et habillé de manière quelque peu modeste. Il porte un bandeau avec du noir cordé autour de sa calotte. Le Vizir socialement muet vous parle calmement.%SPEECH_ON%Les païens du nord ont pris %holysite% de nos terres. Je ne les blâme pas pour leurs actions, ils ne savent pas ce qu\'ils font. Par mes mains honnêtes, le Gilder connaîtra mes fautes. Mais l\'échec ne signifie pas la reddition. J\'ai besoin que vous voyagez jusqu\'aux terres saintes et le rameniez dans notre royaume. Pour cela, vous aurez %reward% couronnes placées dans vos coffres.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Je vous fais confiance pour payer très cher une telle attaque. | Nous sommes prêts à faire notre part. | Parlons un peu du paiement.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | C\'est une trop longue marche. | Nous avons des affaires plus urgentes à régler. | On est demandé autre part.}",
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
			ID = "Attacking",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Comme le croyait le Vizir, les nordistes ont pris des positions dans et autour de %holysite%. La plupart des religieux vagabonds sont partis depuis longtemps, ne laissant que la %companyname% et la force adverse. Vous tirez votre épée et ordonnez aux hommes de lancer l\'attaque.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Commencer l\'assaut !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AlliedArmy",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{À mesure que vous approchez de %holysite%, un homme se lève comme sorti de nulle part. Surpris, vous tirez votre arme, mais l\'homme se révèle être un commandant camouflé de %employer%.%SPEECH_ON%Facile, Crownling, vous aurez votre pièce de monnaie. Les oiseaux du Vizir ont informé ma troupe de votre arrivée et je dois dire que vous êtes un peu en retard. Je sais que ce n\'est pas votre guerre, mais, eh bien, je suppose que ce n\'est pas le moment des remontrances. Reclaimons les terres saintes pour le Gilder, et que nos deux chemins soient toujours dorés par sa lumière.%SPEECH_OFF% | %holysite% est en vue quand un homme semble surgir du sol. Il vous demande si vous êtes le commandant de la %companyname%, et une légère pause a dû lui donner la réponse car il parle immédiatement.%SPEECH_ON%Oui, bien sûr que vous l\'êtes. Je suis %commander%, lieutenant de %employer%. Les oiseaux du Vizir vous ont dit que vous pourriez venir. Vous pourriez chasser la pièce, Crownling, mais si nous sommes victorieux aujourd\'hui, le Gilder brillera de tout son éclat sur le chemin de votre lendemain !%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Commencer l\'assaut !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "SallyForth",
			Title = "À %holysite%",
			 Text = "[img]gfx/ui/events/%illustration%.png[/img]{Les défenseurs de %holysite% ont reçu des renforts ! Heureusement, il y a un côté positif : les bras supplémentaires leur ont donné la confiance de quitter les défenses naturelles du site sacré et de vous affronter sur le champ ouvert. | Vous êtes surpris de voir les défenseurs quitter %holysite% et traverser le champ ouvert. Un rapport d\'éclaireurs rapide indique qu\'ils ont reçu des renforts au cours des derniers jours et sont enhardis par leur nombre seul. D\'un côté, leurs rangs profonds sont un peu inquiétants, mais d\'un autre côté, les affronter sur un terrain égal sera beaucoup plus facile. Bien que, selon votre estimation honnête, c\'est leur erreur de faire face à la %companyname% tout court.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Une bataille en plein champ, alors.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries1",
			Title = "À %holysite%",
			 Text = "[img]gfx/ui/events/event_134.png[/img]{À mesure que %holysite% se dessine à l\'horizon, un homme qui ressemble étrangement à vous s\'approche. Il a un payeur et quelques mercenaires à ses côtés.%SPEECH_ON%Bonsoir, capitaine. Je suis %mercenary% de la %compagniedemercenaires%. Je suis venu dans ces terres à la recherche de couronnes, tout comme vous. À présent, je parie que le Vizir a mouillé sa plume dans un contrat solide pour vous et vos hommes, mais que diriez-vous de me payer %pay% couronnes et je vous aiderai dans cette petite entreprise ?%SPEECH_OFF% | Vous êtes approché par un groupe d\'hommes, l\'un d\'entre eux dont la démarche et la constitution semblent étrangement semblables aux vôtres. Il se présente comme %mercenary%, capitaine de la %compagniedemercenaires%.%SPEECH_ON%Je pensais que le Vizir enverrait son armée professionnelle s\'occuper du changement de mains du site sacré. Je vous avoue, capitaine, que j\'ai aidé les nordistes à prendre possession de ce monument prestigieux en premier lieu. Cependant, pour %pay% couronnes, je suis prêt à aider votre camp à le reprendre. En tant que camarade mercenaire, je suis sûr que vous pouvez voir à quel point cela serait une bonne affaire pour tous.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [],
			function start()
			{
				if (this.World.Assets.getMoney() > this.Flags.get("MercenaryPay"))
				{
					this.Options.push({
						Text = "Tu es engagé !",
						function getResult()
						{
							return "Mercenaries2";
						}

					});
				}
				else
				{
					this.Options.push({
						Text = "J\'ai bien peur de ne pas avoir ce genre de pièce.",
						function getResult()
						{
							return "Mercenaries3";
						}

					});
				}

				this.Options.push({
					 Text = "Trouvez votre propre travail, %mercenary%. Nous n\'avons pas besoin d\'aide.",
					function getResult()
					{
						return "Mercenaries3";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries2",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_134.png[/img]{Le capitaine sourit et vous tape sur l\'épaule.%SPEECH_ON%Ah, voilà ! C\'est ça, l\'esprit noble du mercenaire ! Oui, commandant de la %companyname%, partons ensemble, pour un court instant, et combattons côte à côte, aussi pour un court instant !%SPEECH_OFF% | Le marché conclu, le capitaine de la compagnie de mercenaires se rapproche de vous. Presque inconfortablement proche et certainement à portée de son souffle, ce qui est peu apprécié.%SPEECH_ON%Tu sais, des gars comme nous, des potes comme nous, on est des potes, non ? Des potes comme nous. On doit rester solidaires. Et pour ce combat ici, on restera solidaires.%SPEECH_OFF%Il hoche la tête et vous tape sur l\'épaule.%SPEECH_ON%Après le combat, eh bien, j\'espère qu\'on pourra être potes à nouveau un jour, tu vois ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Commencez l\'assaut !",
					function getResult()
					{
						this.Flags.set("MercenariesAsAllies", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("MercenaryPay"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					 Text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("MercenaryPay") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries3",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_134.png[/img]{%SPEECH_START%C\'est dommage.%SPEECH_OFF%%mercenary% dit en faisant rapidement demi-tour vers les rangs de la %mercenarycompany%. Il recule rapidement droit vers les soldats défendant %holysite%. Ses bras sont écartés et s\'ouvrent, comme s\'il nageait à contre-courant.%SPEECH_ON%C\'est vraiment dommage, je dirais ! Eh bien, capitaine de la %companyname%, voyons voir quelle faction a acheté le meilleur mercenaire, hein ?%SPEECH_OFF%Le mercenaire tire son arme, tout comme les soldats du nord autour de lui, et vous faites de même. Il est temps de se battre. | %SPEECH_ON%Oui, oui, je comprends. Eh bien. Je n\'attendais pas grand-chose. Après tout, je vends aussi l\'épée. Et en ce moment...%SPEECH_OFF%Il fait quelques pas en arrière vers sa compagnie, et sa compagnie rejoint les rangs des soldats du nord protégeant %holysite%.%SPEECH_ON%En ce moment, le nord s\'avère être l\'enchérisseur le plus généreux.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					 Text = "Nous nous retrouverons sur le champ de bataille. Commencez l\'assaut !",
					function getResult()
					{
						this.Flags.set("MercenariesAsAllies", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack1",
			Title = "Après la bataille...",
			 Text = "[img]gfx/ui/events/event_78.png[/img]{La bataille est terminée, mais il y a un éclat d\'armure qui scintille au loin. Vous plissez les yeux et vous concentrez sur les silhouettes qui s\'approchent. Peut-être sont-ils les fidèles venus pour remplir le site sacré et - non, ce sont des Nordiens ! C\'est une contre-attaque ! | Alors que vous rangez votre lame, une flèche passe au-dessus de votre tête et frappe le sable avec un bruit étouffé. Vous regardez vers la source et voyez un archer jeune et nerveux se faire gifler à côté de la tête, et à côté de cet homme se trouve tout un contingent de Nordiens ! C\'est une contre-attaque !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous tiendrons bon pour défendre le site !",
					function getResult()
					{
						return "CounterAttack2";
					}

				},
				{
					 Text = "Nous les affronterons en terrain découvert !",
					function getResult()
					{
						return "CounterAttack3";
					}

				},
				{
					 Text = "Nous ne pouvons pas affronter un autre combat. Retraite !",
					function getResult()
					{
						return "Failure";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%SPEECH_START%Juste plus de Nordiens.%SPEECH_OFF%%randombrother% dit. Vous hochez la tête et répondez.%SPEECH_ON%Encore des bûches pour le feu du Gilder.%SPEECH_OFF%Le mercenaire mentionne que le Gilder préfère l\'or à la flamme, mais vous lui dites de se taire et de se préparer à ce qui vient. Les défenses de %holysite% devraient bien servir la compagnie ici. | Vous ordonnez aux hommes de se défendre à l\'intérieur de %holysite%. %randombrother% regarde autour de lui.%SPEECH_ON%Tu te demandes jamais si le dieu ou les dieux qui regardent ça s\'énervent un peu ? Tu sais ? Comme est-ce qu\'on fait un gâchis de leurs casseroles et poêles ?%SPEECH_OFF%Vous le giflez sur le côté de la tête et lui dites de se concentrer.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ralliement !",
					function getResult()
					{
						this.Flags.set("IsCounterAttackDefend", true);
						this.Flags.set("IsVictory", false);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onCounterAttack.bindenv(this.Contract.getActiveState()));
						this.Contract.m.Target = this.WeakTableRef(party);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Vous ordonnez au %companyname% de se rendre sur le terrain. Le lieutenant nordien vous salue d\'un signe de la main et d\'un sourire.%SPEECH_ON%Vous sortez, hein ? Quoi, fatigué de prier ?%SPEECH_OFF%Vous vous retournez et crachez.%SPEECH_ON%On commençait à manquer de place pour enterrer vos corps.%SPEECH_OFF%Le sourire du lieutenant s\'efface et il ordonne une charge. À la bataille !}",
			Image = "",
			List = [],
			Options = [
				{
					 Text = "Chargez !",
					function getResult()
					{
						this.Flags.set("IsCounterAttackDefend", false);
						this.Flags.set("IsVictory", false);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onCounterAttack.bindenv(this.Contract.getActiveState()));
						this.Contract.m.Target = this.WeakTableRef(party);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{En rangeant votre arme et en demandant à la compagnie de récupérer ce qu\'elle peut parmi les morts, vous avez le sentiment étrange que ce n\'est pas la première fois que %holysite% est le théâtre d\'un tel bain de sang. Peu importe, si quelqu\'un doit mourir dans les traces de ses ancêtres, vous êtes content que ce ne soit pas vous. Quelques sudistes arrivent pour sécuriser le lieu saint. Avec eux ici, vous prenez congé, sachant que %employer% accueillera favorablement les nouvelles que vous avez à lui apporter. | L\'ennemi est vaincu et %holysite% est récupéré. Les soldats du Sud remplissent lentement les défenses. Derrière eux coule une foule de fidèles, passant devant les morts pour se prosterner au lieu le plus saint. Aucun d\'eux ne vous remercie. Peu importe, c\'est le travail de %employer%. | Avec la bataille terminée, une petite foule de fidèles commence à se rassembler dans les coins de %holysite%. Vous ne savez même pas d\'où viennent ces gens. Ils ne vous dérangent pas, et vous ne les dérangez pas. Ce qui compte maintenant, c\'est que %employer% aura une énorme réserve de couronnes qui vous attendra à votre retour. En partant, quelques soldats du Sud prennent le poste sans un mot de remerciement non plus.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Victoire !",
					function getResult()
					{
						this.Contract.m.Destination.setFaction(this.Contract.getFaction());
						this.Contract.m.Destination.setBanner(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						this.updateAchievement("NewManagement", 1, 1);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnAlly();
			}

		});
		this.m.Screens.push({
			ID = "Failure",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Vous avez échoué à protéger %holysite% des Nordiens. Il n\'y a aucune raison de rester, et la seule raison de retourner chez %employer% est si vous voulez votre tête sur l\'un des plateaux incrustés d\'or du Vizir.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					 Text = "Désastre !",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to conquer a holy site");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% est assis sous l\'éclat d\'une boule dorée, une énorme pièce de métal comme le soleil avec des chaînes la maintenant depuis le plafond. Elle a dû être érigée pendant votre absence. Lorsque vous avancez, un homme saint vous arrête et secoue la tête. Il dessine un cercle dans l\'air avec sa main, puis touche votre front de son doigt. Souriant, il vous guide chaleureusement vers un autre côté de la pièce où %reward% couronnes ont été empilées soigneusement dans des plateaux en bois.\n\n L\'homme s\'incline, pointe ses mains vers la boule dorée, façonnant ses paumes comme s\'il portait la construction elle-même, et semble ensuite guider sa sublimité sur votre paiement, les pièces crépitant de lumière. Une sorte de tour de passe-passe, mais le salaire est réel alors vous le prenez et partez. | Lorsque vous entrez dans la chambre de %employer%, plusieurs gardes s\'inclinent et se prosternent brièvement avant de se relever. Au loin, le Vizir est assis silencieusement sur un trône entouré d\'hommes saints vêtus de soie. Il semble que vous ne l\'approcherez pas en ce jour, mais un groupe de jeunes garçons vous apporte des plateaux de pièces une à une jusqu\'à ce que vous ayez %reward% couronnes. Le Vizir hoche la tête et tourne la main. Vous prenez le paiement et partez. | Vous entrez dans la grande salle pour trouver %employer% apparemment ensorcelé par un tourbillon de brume dorée. Il se tient sur une plateforme rotative - tournant plutôt brusquement avec l\'aide d\'esclaves presque invisibles sous le plancher lui-même - et il y a des bandes de tissu attachées à ses poignets. Son harem se tient sur le côté, remplissant leurs bouches avec un liquide doré avant de le projeter en brumes éclaboussantes sur leurs lèvres. Après un examen plus attentif, ce n\'est pas aussi glorieux qu\'il y paraissait d\'abord en entrant ici. Heureusement, vous n\'aurez pas droit à un examen plus approfondi : un grand homme en froc religieux vous coupe la route et vous guide vers une table à l\'arrière de la pièce. Elle est garnie de plateaux remplis de pièces, leur totalité étant votre récompense de %reward% couronnes. Avec votre salaire en main, on vous pousse précipitamment hors de la pièce.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Conquered a holy site");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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
	}

	function spawnAlly()
	{
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = ++x )
		{
			for( local y = o.Y + 4; y <= o.Y + 6; y = ++y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}
			}
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "Régiment de" + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, 170 * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Soldats conscrits fidèles à leur cité.");
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 5);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		local r = this.Math.rand(1, 4);

		if (r <= 2)
		{
			party.addToInventory("supplies/rice_item");
		}
		else if (r == 3)
		{
			party.addToInventory("supplies/dates_item");
		}
		else if (r == 4)
		{
			party.addToInventory("supplies/dried_lamb_item");
		}

		local c = party.getController();
		local occupy = this.new("scripts/ai/world/orders/occupy_order");
		occupy.setTarget(this.m.Destination);
		occupy.setTime(10.0);
		c.addOrder(occupy);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(240.0);
		c.addOrder(guard);
		return party;
	}

	function spawnEnemy()
	{
		local cityState = this.World.FactionManager.getFaction(this.getFaction());
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = ++x )
		{
			for( local y = o.Y - 4; y <= o.Y - 3; y = ++y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}
			}
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local f = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyID"));
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + " Company", true, this.Const.World.Spawn.Noble, this.Math.rand(100, 140) * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Soldats professionnels au service des seigneurs locaux.");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
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
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(this.m.Destination.getTile());
		c.addOrder(attack);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		c.addOrder(move);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(999.0);
		c.addOrder(guard);
		return party;
	}

	function onPrepareVariables( _vars )
	{
		local illustrations = [
			"event_152",
			"event_154",
			"event_151"
		];
		_vars.push([
			"illustration",
			illustrations[this.m.Flags.get("DestinationIndex")]
		]);
		_vars.push([
			"holysite",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"pay",
			this.m.Flags.get("MercenaryPay")
		]);
		_vars.push([
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"mercenary",
			this.m.Flags.get("Mercenary")
		]);
		_vars.push([
			"mercenarycompany",
			this.m.Flags.get("MercenaryCompany")
		]);
		_vars.push([
			"commander",
			this.m.Flags.get("Commander")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnEnterCallback(null);
			}

			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHolyWar())
		{
			return false;
		}

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && !this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					return true;
				}
			}
		}

		return false;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && _tile.ID == this.m.Destination.getTile().ID)
		{
			return true;
		}

		return false;
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
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

