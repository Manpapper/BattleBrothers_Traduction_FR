this.conquer_holy_site_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.conquer_holy_site";
		this.m.Name = "Conquérir un lieu saint";
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

		this.m.Payment.Pool = 1350 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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
		this.m.Flags.set("Commander", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
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
					"Reprenez %holysite% des païens du Sud",
					"Détruisez ou déroutez les régiments ennemis dans les alentours"
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

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "Pris parti dans la guerre");
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
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.Music = this.Const.Music.OrientalCityStateTracks;
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
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (130 + (this.Flags.get("MercenariesAsAllies") ? 30 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
					p.MapSeed = this.Flags.getAsInt("MapSeed");
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.Music = this.Const.Music.OrientalCityStateTracks;
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (this.Flags.get("IsCounterAttack") ? 110 : 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% est entouré d\'un congrès d\'hommes saints, chacun semblant plus instruit que le précédent sur les intentions et les désirs des anciens dieux. Mais il y a une pensée claire qui traverse la conversation : les sudistes ont pris %holysite% et il doit être récupéré. Le seigneur vous pointe du doigt.%SPEECH_ON%La %companyname% s\'efforcera de mettre fin à ce cauchemar !%SPEECH_OFF%Poussant les prieurs hors du chemin, %employer% s\'approche et sa voix baisse.%SPEECH_ON%Pour le bon prix, bien sûr. J\'ai peu d\'hommes à épargner, mais les terres saintes sont d\'une grande importance pour le peuple et pour moi-même. Vous devez y aller et chasser les païens afin que les anciens dieux ne nous abandonnent pas, avec tous nos échecs.%SPEECH_OFF% | La porte de la chambre de %employer% s\'ouvre violemment et une file d\'hommes saints fait ses adieux. Certains s\'arrêtent pour vous dévisager, aucun d\'eux ne semble heureux de votre présence. %employer% vous fait signe d\'entrer.%SPEECH_ON%Ne vous préoccupez pas de leurs yeux pitoyables et accusateurs, mercenaire. %holysite% a été perdu aux sudistes et cela les a profondément contrariés. Pas que je les blâme, même un râleur comme moi a un faible pour les terres sacrées. Ces prieurs veulent simplement que %holysite% soit repris avec les bonnes couleurs royales, mais hélas, j\'ai engagé mes soldats ailleurs. Vous, cependant, pouvez faire le travail très bien, moyennant une pièce convenable, n\'est-ce pas ?%SPEECH_OFF% | %SPEECH_ON%Les anciens dieux observent sans aucun doute cette pièce, mercenaire.%SPEECH_OFF%%employer% tourne son calice, le vin dégoulinant le long du bord et laissant une lueur violette derrière lui.%SPEECH_ON%Les sudistes ont pris %holysite% et l\'ont sans aucun doute profané entièrement. Je préférerais qu\'un chien trouve un endroit pour pisser sur les terres sacrées plutôt que de regarder l\'un de ces sudistes se tenir dans la prétendue sublimité de leur dieu. Qu\'était-ce, le Gilder ? Quelle foutaise. Allez là-bas et tuez-les tous et ramenez %holysite% à sa place légitime.%SPEECH_OFF% | %employer% se trouve dans son jardin et il est presque agressivement seul. Hommes et femmes autour de la clôture semblent effrayés de même le regarder. Peu vous importe : vous marchez librement. Il fixe une fourmilière écrasée, les insectes s\'affairant pour reconstruire. Le noble soupire.%SPEECH_ON%Il m\'arrive parfois de me demander si les anciens dieux nous regardent de cette manière.%SPEECH_OFF%Vous faites remarquer que vous ne remarquez vraiment les fourmis que lorsqu\'elles mordent. Le noble se lève.%SPEECH_ON%Vous devriez savoir qu\'elles sont bonnes pour le jardin, mercenaire. S\'ils mordent, je suppose que c\'est sans passion. C\'est seulement eux faisant ce qu\'ils savent faire, tout comme ils savent reconstruire quand je renverse leur maison. Tout comme il est que lorsque j\'ai appris que les cafards du sud avaient temporairement envahi %holysite%, j\'ai su, par la voie des anciens dieux, qu\'ils devaient être déracinés et détruits.%SPEECH_OFF%Vous vous attendez à ce que le noble vous compare à une fourmi, mais au lieu de cela, il vous offre une grosse somme de couronnes pour vous rendre dans les terres saintes et en expulser les occupants.%SPEECH_ON%Vous seriez comme une guêpe dans le jardin, peut-être.%SPEECH_OFF%Le noble dit, à quoi vous répondez par un signe de tête stoïque. | %SPEECH_ON%Je ne suis pas adepte de la poterie, mercenaire, donc quand je dis que les farks du sud sont plus bas que la dépravation éclairée par la lune d\'un marchand d\'ânes, sachez que leur intrusion seule m\'a poussé sur la voie du ménestrel.%SPEECH_OFF%Vous songez à informer %employer% qu\'il pourrait vouloir dire \'poésie\', mais d\'une certaine manière, il casse des pots ici. D\'ailleurs, il vous voit sans doute comme quelqu\'un aux pieds d\'argile.%SPEECH_ON%Les sauvages ont pris %holysite% et les rumeurs disent qu\'ils ont même tué tous les \'non-croyants\'. Mes soldats sont dispersés, les champs de bataille sont nombreux comme ils sont. Mais vous êtes disponible. Et vous êtes un avare, c\'est certain, mais je sais aussi que le %companyname% est précisément la sorte de force dont nous avons besoin pour sortir ces bâtards des terres saintes.%SPEECH_OFF%}",

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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Les sudistes se sont postés à l\'intérieur et autour de %holysite%. Avec le temps de leur côté, ils ont érigé une défense solide, mais rien que le %companyname% ne puisse gérer. Vous tirez votre épée et préparez vos hommes pour l\'attaque.}",
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
			 Text = "[img]gfx/ui/events/event_78.png[/img]{%holysite% est déjà assiégé par des hommes portant la bannière de %employerfaction%. À mesure que vous vous rapprochez, un homme vient à votre rencontre à mi-chemin. Il lève la main et la pose sur sa ceinture.%SPEECH_ON%J\'ai entendu dire qu\'ils envoyaient un mercenaire et il semble que vous soyez celui-ci. Le %companyname%, n\'est-ce pas ? Eh bien, je suis %commander%, lieutenant de %employer%. Je me joindrai à vous pour éradiquer ces rats du désert. Je crains, comme vous le faites sans doute, que les anciens dieux ne nous châtient tous si nous ne nous attaquons pas rapidement à cette tâche.%SPEECH_OFF%Le lieutenant crache et passe une main sur son visage hirsute.%SPEECH_ON%Eh bien. Laissons les anciens dieux nous voir tels que nous sommes vraiment, et nous massacrerons ces idiots des dunes de la manière la plus juste.%SPEECH_OFF% | %holysite% est déjà assiégé par des hommes portant la bannière de %employerfaction%. Le leader s\'avance et parle fort.%SPEECH_ON%Le %companyname%, je m\'appelle %commander%, lieutenant dans l\'armée de campagne de %employer%. Je suis venu me joindre à vous, ou devrais-je dire que vous vous joindrez à moi, pour aller à %holysite% et arracher ces immondices du sud de chaque centimètre de l\'endroit. Car les anciens dieux veillent sur nous tous, même sur des mercenaires comme vous, et l\'échec aujourd\'hui nous condamnera sûrement à tous les enfers possibles.%SPEECH_OFF%D\'accord. Vous voulez juste vous assurer, aide ou non, que %employer% vous paiera le montant intégral qui sera dû. | %holysite% est déjà assiégé par des hommes portant la bannière de %employerfaction%. Il semble y avoir un congrès d\'hommes saints et de soldats, et le lieutenant qui dirige la troupe brandit son épée avant de la diriger rapidement vers %holysite%.%SPEECH_ON%Les lèche-bottes du sud partiront, ou nous les convertirons aux enfers des anciens dieux par la grâce de notre acier. Il n\'y a pas d\'autre choix dans cette affaire. Venez donc, mercenaires !%SPEECH_OFF%Il semble que le %companyname% aura de l\'aide dans cette entreprise, bien que vous vous attendiez pleinement à recevoir la totalité de la récompense promise.}",
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
			 Text = "[img]gfx/ui/events/%illustration%.png[/img]{Les défenseurs de %holysite% ont reçu des renforts ! Heureusement, il y a un côté positif : les armes supplémentaires leur ont donné la confiance de quitter les défenses naturelles du site sacré et de venir à votre rencontre sur le champ ouvert. | Vous êtes surpris de voir les défenseurs quitter %holysite% et traverser le champ ouvert. Un rapport d\'exploration rapide indique qu\'ils ont reçu des renforts au cours des derniers jours et sont enhardis par leur nombre seul. D\'une part, leurs rangs profonds sont un peu inquiétants, mais d\'autre part, les affronter sur un terrain égal sera beaucoup plus facile. Bien que, selon votre estimation honnête, c\'est une erreur de leur part de faire face au %companyname% tout court.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Une bataille sur le champ, alors.",
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
			Text = "[img]gfx/ui/events/event_134.png[/img]{À mesure que %holysite% se rapproche, un homme qui ressemble étrangement à vous s\'approche. Il a un payeur et quelques mercenaires à ses côtés.%SPEECH_ON%Bonsoir, capitaine. Je suis %mercenary% de la %mercenarycompany%. Je suis venu dans ces contrées à la recherche de couronnes, tout comme vous. À présent, je parie que ce noble bien gras a mouillé sa plume dans un contrat bien sonore pour vous et vos hommes, mais que diriez-vous de me payer %pay% couronnes et je vous aiderai dans cette petite entreprise ? À moins, bien sûr, que vous ne préfériez que j\'offre mes services à l\'autre côté là-bas.%SPEECH_OFF% | Vous êtes approché par un groupe d\'hommes, dont l\'un a une démarche et une constitution étrangement semblables aux vôtres. Il se présente comme %mercenary%, capitaine de la %mercenarycompany%.%SPEECH_ON%Je pensais que %employer% pourrait envoyer son armée professionnelle pour s\'occuper du changement de mains du site sacré. Je vous avoue, capitaine, que j\'ai aidé ces fous des dunes à prendre possession de ce monument prestigieux en premier lieu. Cependant, pour %pay% couronnes, je suis prêt à aider votre camp à le reprendre. En tant que mercenaire, je suis sûr que vous pouvez voir combien cela serait une bonne affaire pour tous les intéressés.%SPEECH_OFF%}",
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
						Text = "Je crains que nous n\'ayons pas ce genre de couronnes.",
						function getResult()
						{
							return "Mercenaries3";
						}

					});
				}

				this.Options.push({
					Text = "Trouve toi-même du travail, %mercenary%. Nous n\'avons pas besoin d\'aide.",
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
			Text = "[img]gfx/ui/events/event_134.png[/img]{Le capitaine sourit et vous tape sur l\'épaule.%SPEECH_ON%Aaahhh, voilà ! Voilà, l\'esprit noble du mercenaire ! Oui, commandant du %companyname%, partons, pour un court moment, et faisons la guerre ensemble, aussi pour un court moment !%SPEECH_OFF% | Avec l\'accord conclu, le capitaine de la compagnie de mercenaires se glisse à vos côtés. Presque inconfortablement proche, et certainement à portée de son souffle, ce qui n\'est pas apprécié.%SPEECH_ON%Tu sais, des hommes comme nous, des gars comme nous, des potes, nous sommes des potes, non ? Des potes comme nous. On doit rester soudés. Et pour cette bataille ici, on restera soudés.%SPEECH_OFF%Il hoche la tête et vous tape sur l\'épaule.%SPEECH_ON%Après la bagarre, eh bien, j\'espère qu\'on pourra être potes à nouveau un de ces jours, tu vois ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Commencer l\'assaut !",
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
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("MercenaryPay") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries3",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_134.png[/img]{%SPEECH_START%C\'est dommage.%SPEECH_OFF% dit %mercenary% alors qu\'il retourne rapidement aux rangs de la %mercenarycompany%. Il recule droit dans les soldats défendant %holysite%. Ses bras sont grands ouverts et s\'éventent, comme s\'il nageait à contre-courant.%SPEECH_ON%C\'est vraiment dommage, je dis ! Eh bien, capitaine du %companyname%, voyons voir quelle faction a engagé le meilleur mercenaire, hein ?%SPEECH_OFF%Le mercenaire sort son arme, tout comme les soldats du sud à %holysite% derrière lui. Naturellement, vous sortez aussi votre arme. Il est temps de combattre. | %SPEECH_ON%Ouais, ouais, je vois. Eh bien. Je n\'attendais pas grand-chose. Après tout, je suis aussi vendeur d\'épées. Et là, en ce moment...%SPEECH_OFF%Il recule vers sa compagnie, et sa compagnie rejoint les rangs des soldats du sud protégeant %holysite%.%SPEECH_ON%En ce moment, le sud s\'avère être l\'enchérisseur le plus généreux.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{La bataille est terminée, mais un éclat doré au loin attire votre attention. Alors que vous fixez l\'horizon, une troupe de Sudistes apparaît, leur aspect brillant est sans aucun doute destiné à être remarqué. C\'est une contre-attaque ! | Alors que vous rangez votre lame, %randombrother% appelle. Il pointe vers l\'horizon. Une ligne de Sudistes approche, leur armure scintillant, leur démarche assurée. Les contre-attaquants veulent être vus, et ils ont sans doute l\'intention d\'être victorieux...}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{L\'approche des Sudistes est toujours constante.%SPEECH_ON%Ces cafards, ils ne finissent jamais.%SPEECH_OFF%Vous regardez %randombrother% secouer la tête. Il soulève sa botte et fait partir un insecte du bout du pied. Il pose le pied par terre et fait un signe de tête en direction des assaillants.%SPEECH_ON%Ne vous inquiétez pas, capitaine, nous aurons les défenses de %holysite% en parfait état pour ces salauds sauvages.%SPEECH_OFF% | Vous ordonnez aux hommes de défendre le site.%SPEECH_ON%Tenir bon à %holysite%, quel temps pour être en vie.%SPEECH_OFF%%randombrother% dit. Vous hochez la tête et lui dites que vous espérez que cela sera un jour un souvenir pour lui. Il rit et demande comment il pourrait jamais oublier. Un autre mercenaire s\'interpose en disant qu\'il y a une manière très certaine dont il peut oublier, mais vous le coupez et dites aux hommes de se concentrer sur la tâche à accomplir.}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{Les défenses ne semblent pas aussi solides qu\'auparavant. Vous ordonnez au %companyname% de prendre position sur le terrain, là où aucune construction défectueuse ne gênera vos ordres. Le lieutenant sudiste vous salue.%SPEECH_ON%Vous profanez %holysite% avec du sang, pour cela le Gilder Lui-même ne doute pas vous avoir attiré sur le terrain pour mourir comme des hommes dignes. Qu\'avez-vous à dire à cela ?%SPEECH_OFF%Vous tirez votre épée.%SPEECH_ON%Ce n\'était pas mon sang.%SPEECH_OFF%}",

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
			 Text = "[img]gfx/ui/events/%illustration%.png[/img]{Alors que vous rangez votre arme et que la compagnie se met en route pour récupérer ce qu\'elle peut parmi les morts, vous ressentez étrangement que ce n\'est pas la première fois que %holysite% est le théâtre d\'un tel bain de sang. Eh bien, si quelqu\'un doit mourir sur les traces de ses ancêtres, vous êtes heureux que ce ne soit pas vous. Quelques soldats du Nord entrent pour sécuriser le lieu saint alors que vous vous apprêtez à partir pour %employer%. | L\'ennemi est vaincu et %holysite% est reconquis. Une foule de fidèles s\'infiltre lentement, passant près des morts pour se prosterner à l\'endroit le plus sacré. Pas un ne vous remercie. Peu importe, c\'est le travail de %employer%. Un groupe de soldats du Nord vous dépasse en sortant, chacun des combattants vous regardant avec des sourires moqueurs. | Avec la bataille terminée, de petits groupes de fidèles commencent à se rassembler dans les coins de %holysite%. Vous ne savez même pas d\'où viennent ces gens. Ils ne vous dérangent pas, et vous ne les dérangez pas. Ce qui importe maintenant, c\'est que %employer% aura une énorme récompense de couronnes qui vous attendra à votre retour. Dès qu\'un groupe de soldats du Nord passe à côté, vous vous éclipsez.}",
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
			 Text = "[img]gfx/ui/events/%illustration%.png[/img]{%holysite% est tombé aux mains des sudistes. Un mercenaire secoue la tête.%SPEECH_ON%Eh bien. Je soupçonne qu\'ils vont être partout, que ce soit pour briller ou merder.%SPEECH_OFF%En effet. Avec les lieux sacrés perdus, il n\'y aura aucune raison de retourner chez %employer%, à moins que vous ne soyez intéressé par un autre type de spectacle sacré.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Le prieuré de %townname% déborde de plus de paysans que vous n\'en avez jamais vu auparavant. %employer% est dehors sur les marches et vous accueille en posant une main sur votre épaule.%SPEECH_ON%De retour, mercenaire. Vous pourriez être un goujat cherchant sa pièce, mais vous portez la colère des anciens dieux avec vous. %holysite% est là où elle doit être maintenant.%SPEECH_OFF%Le noble claque des doigts quelques fois et quelques moines bedonnants avancent en traînant des coffres de %reward% couronnes. %employer% monte les marches et prend congé.%SPEECH_ON%Je dirai un mot pour vous à la foule, quel était votre nom ? Ah, je suis sûr que vous voulez que la compagnie s\'en attribue le mérite. Je remercierai le %companyname% dans son ensemble.%SPEECH_OFF% | %employer% examine ses cartes de bataille.%SPEECH_ON%C\'est assez amusant que là où j\'envoie mes hommes, je rencontre des échecs, mais quand les anciens dieux s\'en mêlent, je suis incité à engager un mercenaire et je rencontre... la victoire. Avec %holysite% de nouveau entre nos mains, espérons que cela poussera mes hommes à combattre comme le %companyname%. Pour %reward% couronnes, vous avez renvoyé ces crapules du sud aux enfers de leur désert et encouragé l\'effort de guerre dans son ensemble. Je dirais presque que je vous ai sous-payé, mercenaire. Presque.%SPEECH_OFF% | %SPEECH_ON%Quand les éclaireurs sont revenus, la première chose qu\'ils ont faite a été de visiter le prieuré. C\'est ainsi que j\'ai su que vous aviez réussi. Je leur ai également infligé chacun un jour de cachot pour avoir négligé leurs devoirs envers moi.%SPEECH_OFF%%employer% est assis sur un coussin étrange, peut-être obtenu d\'une manière ou d\'une autre pendant ces guerres avec les sudistes. Il fait tourner le vin dans une coupe.%SPEECH_ON%Vos %reward% couronnes vous attendent dehors. Je dois vous demander, lorsque vous étiez là-bas, avez-vous entendu quelque chose ? Peut-être des murmures des anciens dieux ? Peut-être même des murmures de celui qu\'ils appellent, comment était-ce déjà, le Gilder ?%SPEECH_OFF%Vous secouez la tête. Le noble hausse les épaules.%SPEECH_ON%Dommage. On doit se demander ce qu\'il faut pour que les dieux reviennent à nous.%SPEECH_OFF%Vous lui dites que %reward% couronnes dépensées dans une direction particulière seraient un bon début. Le noble sourit malicieusement et vous accorde ce souhait. | %employer% est trouvé avec une jeune femme bronzée, clairement originaire des contrées du sud. Il la regarde de haut en bas.%SPEECH_ON%Les anciens dieux m\'ont envoyé celle-ci, tout comme je suppose qu\'ils vous ont envoyé vous.%SPEECH_OFF%Il bafouille ses mots pendant une seconde et se raclent. Vos victoires à %holysite% ont revigoré les hommes, levant le sort de défaite de leurs épaules. Les moines ont maintenant les fidèles de retour dans leur troupeau, et avec une bonne diligence, nous prouverons notre valeur aux anciens dieux.%SPEECH_OFF%Il repousse la femme et essaie de se lever, mais le coussin est trop profond, peut-être trop confortable. Il reste assis.%SPEECH_ON%Vos %reward% couronnes seront dans le couloir. Faites venir l\'une de mes servantes pour venir chercher cette jeune femme pour des prières au prieuré.%SPEECH_OFF% | Vous trouvez %employer% dans l\'un des temples de la ville, se tenant sous une statue de l\'un des anciens dieux.%SPEECH_ON%J\'avais eu vent de vos succès. La ville était en liesse, et la région dans son ensemble murmure de délice. Ils ne parleront pas de vous, bien sûr, ils parleront de moi.%SPEECH_OFF%Le noble semble plutôt content de lui. Il se retourne et vous tapote l\'épaule.%SPEECH_ON%J\'espère que ces crétins du sud ne vous ont pas trop ennuyé. Mes lieutenants apporteront vos %reward% couronnes. Dites, pensez-vous que %holysite% vaut le détour ? Je n\'y suis jamais allé. En fait, je m\'en fiche. Je suis béni où que mes pieds me mènent.%SPEECH_OFF%Vous serrez les lèvres alors que le noble s\'éloigne.",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Conquis un lieu saint");
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
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + " Company", true, this.Const.World.Spawn.Noble, 170 * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Soldats professionnels au service des seigneurs locaux.");
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
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "Régiment de" + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 140) * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Soldats enrôlés fidèles à leur cité-état.");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
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

