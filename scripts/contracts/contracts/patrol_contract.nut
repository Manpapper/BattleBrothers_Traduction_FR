this.patrol_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location1 = null,
		Location2 = null,
		NextObjective = null,
		Dude = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.patrol";
		this.m.Name = "Patrouille";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnceDiscovered = true;
		this.m.DifficultyMult = 1.0;
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

		local settlements = clone this.World.FactionManager.getFaction(this.m.Faction).getSettlements();
		local i = 0;

		while (i < settlements.len())
		{
			local s = settlements[i];

			if (s.isIsolatedFromRoads() || !s.isDiscovered() || s.getID() == this.m.Home.getID())
			{
				settlements.remove(i);
				continue;
			}

			i = ++i;
		}

		this.m.Location1 = this.WeakTableRef(this.getNearestLocationTo(this.m.Home, settlements, true));
		this.m.Location2 = this.WeakTableRef(this.getNearestLocationTo(this.m.Location1, settlements, true));
		this.m.Payment.Pool = 750 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Count = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Count = 0.75;
			this.m.Payment.Completion = 0.25;
		}
		else
		{
			this.m.Payment.Count = 1.0;
		}

		local maximumHeads = [
			20,
			25,
			30,
			35
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		this.m.Flags.set("HeadsCollected", 0);
		this.m.Flags.set("StartDay", 0);
		this.m.Flags.set("LastUpdateDay", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				this.Contract.m.BulletpointsObjectives = [
					"Patrouillez la route jusqu\'à " + this.Contract.m.Location1.getName(),
					"Patrouillez la route jusqu\'à " + this.Contract.m.Location2.getName(),
					"Patrouillez la route jusqu\'à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.BulletpointsObjectives.push("Revenez dans les %days% prochains jours");

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
				this.Flags.set("EnemiesAtWaypoint1", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2));
				this.Flags.set("EnemiesAtWaypoint2", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2) + (this.Flags.get("EnemiesAtWaypoint1") ? 0 : 50));
				this.Flags.set("EnemiesAtLocation3", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2) + (this.Flags.get("EnemiesAtWaypoint2") ? 0 : 100));
				this.Flags.set("StartDay", this.World.getTime().Days);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed"))
				{
					this.Flags.set("IsBetrayal", this.Math.rand(1, 100) <= 75);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 10)
					{
						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.Flags.set("IsCrucifiedMan", true);
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
				this.Contract.m.Location1.getSprite("selection").Visible = true;
				this.Contract.m.Location2.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.NextObjective = this.Contract.m.Location1;
				this.Contract.m.BulletpointsObjectives = [
					"Patrouillez la route jusqu\'à " + this.Contract.m.Location1.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("Soyez payé pour chaque tête que vous récupérez sur la route (%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("Revenez dans les %days% prochains jours");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Location1))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint1"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint1", false);
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Location2",
			function start()
			{
				this.Contract.m.Location1.getSprite("selection").Visible = false;
				this.Contract.m.Location2.getSprite("selection").Visible = true;
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.NextObjective = this.Contract.m.Location2;
				this.Contract.m.BulletpointsObjectives = [
					"Patrouillez la route jusqu\'à " + this.Contract.m.Location2.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("Soyez payé pour chaque tête que vous récupérez sur la route (%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("Revenez dans les %days% prochains jours");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Location2))
				{
					this.Contract.setScreen("Success2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint2"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint2", false);
					}
				}

				if (this.Flags.get("IsCrucifiedMan") && !this.TempFlags.get("IsCrucifiedManShown") && this.World.State.getPlayer().getTile().HasRoad && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsCrucifiedManShown", true);
					this.Contract.setScreen("CrucifiedA");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsCrucifiedManWon"))
				{
					this.Flags.set("IsCrucifiedManWon", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("CrucifiedE_AftermathGood");
					}
					else
					{
						this.Contract.setScreen("CrucifiedE_AftermathBad");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);

				if (_combatID == "CrucifiedMan")
				{
					this.Flags.set("IsCrucifiedManWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.Location1.getSprite("selection").Visible = false;
				this.Contract.m.Location2.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.NextObjective = this.Contract.m.Home;
				this.Contract.m.BulletpointsObjectives = [
					"Patrouillez la route jusqu\'à " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("Soyez payé pour chaque tête que vous récupérez sur la route (%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("Revenez dans les %days% prochains jours");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("HeadsCollected") != 0)
					{
						this.Contract.setScreen("Success3");
					}
					else
					{
						this.Contract.setScreen("Success4");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint3"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint3", false);
					}
				}

				if (this.Flags.get("IsCrucifiedMan") && !this.TempFlags.get("IsCrucifiedManShown") && this.World.State.getPlayer().getTile().HasRoad && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsCrucifiedManShown", true);
					this.Contract.setScreen("CrucifiedA");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsCrucifiedManWon"))
				{
					this.Flags.set("IsCrucifiedManWon", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("CrucifiedE_AftermathGood");
					}
					else
					{
						this.Contract.setScreen("CrucifiedE_AftermathBad");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);

				if (_combatID == "CrucifiedMan")
				{
					this.Flags.set("IsCrucifiedManWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% tend une main ferme vers une de ses chaises. Vous prenez place.%SPEECH_ON% La région n\'est pas sûre. Les commerçants se plaignent de brigands et d\'autres menaces le long de la route.%SPEECH_OFF%Il baisse les yeux, se massant les tempes.%SPEECH_ON%Comme tous mes hommes sont actuellement occupés, j\'ai besoin de vous pour patrouiller la région. Voyagez jusqu\'à %location1%, continuez jusqu\'à %location2% et revenez ici dans les %days%jours. Si vous rencontrez des menaces, assurez-vous de vous en occuper. Je ne vais pas vous payer pour une balade dans les bois, mercenaire. Le paiement sera accordé par tête que vous me rapporterez.%SPEECH_OFF% |%employer% chantonne au-dessus d\'une carte, ses yeux papillonnent comme ceux d\'un faucon au-dessus de souris en fuite. Il semble incapable de se concentrer. %SPEECH_ON% C\'est là que se trouvent mes hommes. Ici. Là. Là-bas. Cette partie de la carte ? Elle n\'a même pas de nom, mais ils sont là aussi. Là où ils ne sont pas, c\'est ici, et ici. Et c\'est là que tu interviens, mercenaire. %SPEECH_OFF%Il fait une pause pour vous regarder. %SPEECH_ON% J\'ai besoin que vous patrouilliez les territoires vers %location1% et ensuite vers %location2%. Tuez tout ceux qui pensent que la route leur appartient. Je suis sûr que vous connaissez bien ce genre de personnes. Mais je ne te paie pas pour te promener, mercenaire. Rapporte-moi toutes les têtes que tu ramasseras dans les  %days% jours qui suivent et je te paierai pour chacune.%SPEECH_OFF% | %employer% prend une gorgée de vin et rote. %SPEECH_ON%Je n\'ai pas l\'habitude de demander à des mercenaires de faire des patrouilles pour moi, mais la plupart de mes hommes sont actuellement occupés ailleurs. C\'est une tâche assez simple : il suffit d\'aller à %location1% puis à %location2%, et de revenir ici dans %days%jours. Sur la route, tuez tout homme ou bête qui pourrait représenter un danger pour les habitants de ces contrées. Mais n\'oubliez pas de récupérer leurs têtes : Je vous paierai au trophée, pas au nombre de kilomètres parcourus.%SPEECH_OFF% | %employer% sourit sournoisement. %SPEECH_ON%Et si je vous donnais une tâche où vous n\'êtes pas seulement payé pour la réaliser, mais aussi pour le nombre de têtes que vous pouvez collecter ? Cette perspective vous intéresse-t-elle ? Parce qu\'en ce moment, j\'ai besoin que les terres à %location1% et %location2% soient surveillées. Vous vous promenez, abattez des choses par-ci par-là, puis revenez me voir dans les %days% jours avec les têtes que vous aurez collectées. Je vous paierai pour celles que vous aurez récoltées. Fais-moi savoir ce que tu en penses.%SPEECH_OFF% | L\'employeur pose un doigt sur une carte.%SPEECH_ON% J\'ai besoin que tu ailles ici.%SPEECH_OFF% Il traîne le doigt vers un autre endroit.%SPEECH_ON% Et puis ici. Une longue patrouille. Tuez tout ceux qui pensent posséder les routes et qui ne portent pas le nom de %noblehousename%. Assurez-vous de prendre leurs têtes, cependant. Je ne vous paierai pas pour prendre des vacances. Je vous paierai pour chaque trophée que vous me rapporterez à votre retour dans les %days% jours.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "De combien parle-t-on ?",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "C\'est trop de marche à mon goût.",
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
			ID = "CrucifiedA",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_02.png[/img]%randombrother% revient vers vous avec un rapport de reconnaissance. %SPEECH_ON%Des hameaux brûlés. Un homme mort coupé en deux au niveau du ventre. Les jambes manquantes. Son chien était juste étendu là. Il ne voulait pas partir. Impossible de l\'emmener nulle part. On a trouvé un âne mort dans les arbres. Une lance sortait du sabot.%SPEECH_OFF%Il fait une pause, réfléchit, puis claque des doigts.%SPEECH_ON%Oh ! J\'allais oublier. Il y a un homme crucifié de l\'autre côté de la colline, là-bas. Mais il était vivant. Il criait beaucoup, mais je suis resté à l\'écart. La douleur d\'un inconnu est une affaire délicate.%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Oui. Allons voir ce crucifié.",
					function getResult()
					{
						return "CrucifiedB";
					}

				},
				{
					Text = "Rien d\'exploitable. Bon rapport.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsCrucifiedMan", false);
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedB",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_02.png[/img]Vous décidez de vous aventurer en bas et de voir le crucifié. Vous êtes au sommet d\'une colline voisine et vous regardez ses versants. C\'est à peu près ce que disait le mercenaire. Il y a un homme crucifié en bas de la colline. Il est suspendu et faible, mais même d\'ici vous pouvez entendre ses cris qui résonnent de temps en temps. %randombrother% demande ce qu\'il faut faire.",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "On va le descendre.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return "CrucifiedC";
						}
						else
						{
							return "CrucifiedD";
						}
					}

				},
				{
					Text = "C\'est clairement un piège. Attendons.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "CrucifiedE";
						}
						else
						{
							return "CrucifiedF";
						}
					}

				},
				{
					Text = "On s\'en va. Il y a quelque chose qui cloche.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedC",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_02.png[/img]Vous n\'êtes pas sûr de pouvoir dormir la nuit en sachant que vous avez laissé ce pauvre bougre à un destin aussi horrible. Vous et la compagnie commencez à descendre la colline. Ce n\'est pas un sauvetage particulièrement rapide car vous êtes toujours inquiet des embuscades, mais rien ne se passe. L\'homme crucifié sourit quand vous vous approchez. %SPEECH_ON% Descendez moi et je me battrai pour vous jusqu\'à la fin de mes jours, je vous le promets!%SPEECH_OFF%Les mercenaires font levier avec leurs armes sous les clous et dégagent l\'homme. Il glisse le long du poteau de bois dans les bras de quelques mercenaires qui le déposent doucement au sol. Entre deux gorgées d\'eau, il parle.%SPEECH_ON%Les peaux vertes m\'ont fait ça. J\'étais le dernier de mon village et je suppose qu\'ils ont pensé à s\'amuser un peu plutôt que de me planter une hache dans la tête. Je commençais à préférer cette dernière solution jusqu\'à ce que vous arriviez. Je ne suis pas au mieux de ma forme, monsieur, mais avec le temps je me remettrai et je jure par mon nom, dont je suis le tout dernier, que je me battrai pour vous jusqu\'à la mort ou la dernière victoire !%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Peu d\'hommes ont pu survivre à de telles horreurs. Bienvenue dans la compagnie.",
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
					Text = "Cette compagnie n\'a pas de place pour vous.",
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
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVillageBackgrounds);
				this.Contract.m.Dude.getBackground().m.RawDescription = "Vous avez descendu %name% le crucifié du support de son exécution juste à temps. Il a prêté allégeance à votre camp jusqu\'à la fin de ses jours ou jusqu\'à la dernière de vos victoires.";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.getSkills().removeByID("trait.disloyal");
				this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
				this.Contract.m.Dude.setHitpoints(1);

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

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedD",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_67.png[/img]Dormir la nuit serait un peu moins difficile si vous laissiez ce pauvre bougre derrière vous. Vous dirigez la compagnie vers le bas de la colline, en partie pour le sauver et pour préserver votre santé mentale. Le crucifié commence à esquisser un sourire à votre approche.%SPEECH_ON%Merci, étranger ! Merci merci merci merci... %SPEECH_OFF%Il est interrompu par le \'thunk\' écœurant d\'un javelot qui perfore sa poitrine et s\'enfonce dans les planches de bois sur lesquelles il est crucifié. Vous vous retournez à temps pour voir des peaux vertes se précipiter hors des buissons voisins. Bon sang, c\'était un piège depuis le début ! Aux armes !",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Aux armes!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_goblins_03"
						];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(90, 110), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]Vous décidez d\'attendre. Alors que vous êtes assis et que vous écoutez les gémissements de l\'homme mourant se calmer lentement dans le silence, %randombrother% vous attrape par l\'épaule et vous indique un peu plus loin. Il y a des brigands qui se dirigent vers le crucifié. Ils arrivent et discutent un moment. Un homme sort un poignard et commence à le planter dans les orteils de l\'homme mourant. Ses gémissements ne sont plus silencieux. Un des brigands se retourne en riant. Il s\'arrête. Il dit quelque chose. Il vous pointe du doigt. On vous a vu ! Avant que ces trous du cul puissent se mettre en formation, vous ordonnez au %companyname% de charger !",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "CrucifiedMan";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_bandits_03"
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.BanditRaiders, this.Math.rand(90, 110), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE_AftermathGood",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]De façon surprenante, l\'homme crucifié est toujours vivant. Après la bataille. Il vous appelle d\'une voix rauque qui ne transmet aucun mot, mais un simple gémissement signifiant : \"S\'il vous plaît, aidez-moi\". Les frères le descendent. Il s\'évanouit à la seconde où il touche le sol, puis se réveille en sursaut et vous attrape par la main.%SPEECH_ON%Merci, étranger. Merci beaucoup. Les orcs... ils sont venus... et puis des brigands ont pillé les restes... mais vous, vous êtes différent. Merci ! Je n\'ai rien d\'autre à faire dans ce monde que de me battre contre ceux qui m\'ont tout pris. Je suis %crucifiedman%, le dernier de mon nom, et si vous m\'en faites l\'honneur, je vous promets mon épée jusqu\'au jour de ma mort ou de votre dernière victoire.%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Peu d\'hommes ont pu survivre à de telles horreurs. Bienvenue dans l\'entreprise.",
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
					Text = " Cette compagnie n\'est pas un refuge pour vous.",
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
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVillageBackgrounds);
				this.Contract.m.Dude.getBackground().m.RawDescription = "Vous avez descendu %name% le crucifié du support de son exécution juste à temps. Il a prêté allégeance à votre camp jusqu\'à la fin de ses jours ou jusqu\'à la dernière de vos victoires..";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.getSkills().removeByID("trait.disloyal");
				this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
				this.Contract.m.Dude.setHitpoints(1);

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

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE_AftermathBad",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Les brigands éliminés, vous allez voir si le crucifié est encore en vie. Il n\'a pas survécu. N\'ayant rien sur son corps qui vaille la peine d\'être pris, vous pillez les brigands et remettez le %companyname% sur le chemin.",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Repose en paix.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedF",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_02.png[/img]Vous décidez d\'attendre. Le mourant continue de se consumer. Ses cris deviennent un peu plus silencieux, ce qui est agréable pour les oreilles, mais mauvais pour l\'âme des hommes. Au bout d\'un moment, %randombrother% se lève et suggère que la compagnie descende. La probabilité que quelqu\'un reste dans les parages pour une embuscade est en effet assez faible. Vous et la compagnie descendez la colline au pas de course et arrivez à l\'homme crucifié. Il a le menton sur la poitrine, les yeux entrouverts, une écume de salive et de sang s\'écoulant de ses lèvres. N\'ayant rien sur lui qui vaille la peine d\'être pris, vous ordonnez au %companyname% de reprendre le chemin.",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Repose en paix.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && !bro.getBackground().isCombatBackground())
					{
						bro.worsenMood(0.5, "Vous avez laissé un homme crucifié mourir d\'une mort lente.");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À %location1%...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Vous atteignez %location1% et demandez aux hommes de faire une pause. Pendant qu\'ils se reposent, vous comptez les provisions et vous assurez que tout est en ordre. Assez rapidement, vous remettez la compagnie en marche. | Vous vous arrêtez à %location1%, la première étape de la patrouille, et vous permettez aux hommes de se reposer un moment. Vous avez encore de la route devant vous, vous estimez que c\'est le bon moment pour vous de vous réapprovisionner. | La première étape de la patrouille est terminée. Vous devez maintenant passer à la suivante. Vous en informez les hommes et ils gémissent. Vous les informez également que vous ne les payez pas pour râler, mais ils grognent tout autant. | Vous atteignez le premier point de la patrouille et ordonnez aux hommes de prendre cinq minutes pendant que vous comptez les provisions. La patrouille n\'est terminée qu\'au tiers. Vous vous demandez si vous ne devriez pas faire le plein d\'équipement avant de repartir. | Vous atteignez %location1% sain et sauf pour l\'essentiel.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "On continue.",
					function getResult()
					{
						this.Contract.setState("Location2");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Location1, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À %location2%...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%location2% est juste là où elle était censée être. Vous demandez aux hommes de se reposer et de récupérer pendant que vous préparez la dernière étape de la patrouille. | La patrouille vous conduit à la %location2% qui vous reçoit avec le même mépris et la même suspicion, qu\'on donne à n\'importe quel mercenaire. Il vous reste encore une étape du voyage à parcourir, alors peut-être qu\'il serait bon de vous approvisionner ici. | Les hommes se répartissent dans les tavernes de %location2%. Vous faites simplement le point sur vos provisions et vous vous demandez si se réapprovisionner est une bonne idée. En jetant un coup d\'œil aux lumières tamisées d\'un établissement, vous vous demandez également si un petit verre ne ferait pas de mal non plus. | En arrivant à %location2%, %randombrother% suggère que la compagnie prenne quelques provisions pour le voyage de retour vers %employeur%. Tu y avais déjà pensé, mais tu laisses au mercenaire la satisfaction d\'avoir eu l\'idée lui-même.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "We move on.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Location2, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Votre Retournez chez %employer% qui vous accueille avec curiosité. Il compte les couronnes mais, avant de vous les donner, il vous demande combien de \"têtes\" vous avez collectées pendant votre voyage. Après avoir indiqué %killcount% de tués, il pince les lèvres et hoche la tête.%SPEECH_ON% C\'est satisfaisant.%SPEECH_OFF% L\'homme verse quelques couronnes dans une sacoche et vous  la remet. | En retournant chez %employer%, vous trouvez l\'homme assis confortablement dans un énorme fauteuil, comme s\'il avait besoin de tout cet espace pour asseoir sa noblesse, son opulence et sa fierté.\n\n Vous parlez de la patrouille, comment vous avez tué %killcount% fois sur la route. Vous mettez l\'accent sur les meurtres, car c\'est pour cela que vous êtes payé. %employer% acquiesce et demande à un de ses hommes de jeter des couronnes dans une sacoche et de vous la remettre. | %employer% se tient près d\'une fenêtre, buvant du vin et semblant reluquer quelques femmes qui jardinent en bas. Sans se tourner vers vous, il vous demande combien de personnes vous avez tué pendant votre voyage.%SPEECH_ON%%killcount%.%SPEECH_OFF% Le noble glousse.%SPEECH_ON%Vous donnez l\'impression que c\'est si facile.%SPEECH_OFF%Encore sans regarder, il claque des doigts. Un homme apparaît sur le côté avec une sacoche à la main. Vous la prenez avant de partir. | L\'employeur lit des papiers en vous accueillant. Il est curieux de savoir combien de victimes vous avez abattues pendant votre patrouille. Vous indiquez %killcount%, ce à quoi il répond en fredonnant et en prenant une petite note sur l\'un des papiers. Il hoche la tête, ouvre d\'un coup de pied un coffre à côté de lui et commence à mettre des couronnes dans une bourse. Il vous la remet, puis, sans même lever les yeux, vous demande de sortir. |Il y a une fête à la demeure de %employer%. Vous vous faufilez dans la foule ivre d\'opulence pour atteindre l\'homme. Il crie par-dessus la musique et le bruit, demandant combien vous en avez abattu pendant votre patrouille. C\'est étrange, mais crier que vous avez tué %killcount% ne semble avoir aucun effet sur les fêtards. Haussant les épaules, %employer% se retourne et part, se glissant dans la foule des participants. Vous essayez de le poursuivre, mais un homme vous coupe la route en vous écrasant une sacoche sur la poitrine.%SPEECH_ON%Votre paiement, mercenaire. Maintenant, s\'il vous plaît, allez à la porte. Les gens commencent à vous remarquer et ils ne sont pas venus ici pour se sentir mal à l\'aise.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Assez de marche pour aujourd\'hui.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Patrolled the realm");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});

				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Home, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Vous revenez chez %employer% les mains vides. Il te jauge, observant tout particulièrement ton manque de scalps.%SPEECH_ON%Vraiment ? Pas de problème du tout ? %SPEECH_OFF% Tu ne bouges pas. L\'homme pince les lèvres et hausse les épaules.%SPEECH_ON%Ah merde, bien...%SPEECH_OFF% Il te regarde et manque de s\'étouffer de rire.%SPEECH_ON%Intéressant, je suppose.%SPEECH_OFF% | %employer% te regarde de haut en bas.%SPEECH_ON% Où sont les têtes, mercenaire ? Tu n\'as sûrement pas oublié de les ramasser...?%SPEECH_OFF% Tu expliques que tu n\'as rien trouvé pendant la patrouille. L\'homme lève un sourcil.%SPEECH_ON% Rien du tout ? Bon sang... et bien... au revoir.%SPEECH_OFF%. |Vous Retournez chez %employer% les mains vides. Il regarde votre manque de... marchandise.%SPEECH_ON%C\'est quoi ça ? Où sont les têtes que je devrais vous payer ? %SPEECH_OFF%Haussant les épaules, vous expliquez qu\'il n\'y a pas eu de problème pendant la patrouille. %employer%qui prenait une gorgée de vin manque de s\'étouffer en entendant cette nouvelle.%SPEECH_ON%Attendez, vraiment ? Je veux dire, je suppose que c\'est bien et tout, mais bon sang... je ne m\'attendais pas à ça. Je, euh, suppose que toi non plus.%SPEECH_OFF%Vous vous regardez fixement. Un oiseau roucoule pour combler le silence. L\'homme boit son vin à petites gorgées et regarde par la fenêtre. %SPEECH_ON%So... temps intéressant aujourd\'hui, hein ? %SPEECH_OFF%Vous roulez les yeux.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Assez de marche pour aujourd\'hui.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictory);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Patrolled the realm");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Contract.m.Payment.getOnCompletion() > 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Vous avez pris beaucoup trop de temps pour terminer la patrouille dont vous aviez la charge. Considérez que le contrat a échoué. | Un homme au service de %employer% s\'approche avec un document. Il indique que votre patrouille devait être rapide, et non une joyeuse petite promenade pour vous-même. Considérez que le contrat a échoué. | Qu\'essayiez-vous de faire, collecter autant de têtes que possible ? Il est douteux que votre employeur  %employer% croit à une telle supercherie. Il y a une raison pour laquelle il ne vous a donné que quelques jours pour accomplir cette tâche. Considérez-la comme ratée.}",
			Image = "",
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Maudit soit ce contrat!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Wandered off while tasked to patrol");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function addKillCount( _actor, _killer )
	{
		if (_killer != null && _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			return;
		}

		if (this.m.Flags.get("HeadsCollected") >= this.m.Payment.MaxCount)
		{
			return;
		}

		if (_actor.getXPValue() == 0)
		{
			return;
		}

		if (_actor.getType() == this.Const.EntityType.GoblinWolfrider || _actor.getType() == this.Const.EntityType.Wardog || _actor.getType() == this.Const.EntityType.Warhound || _actor.getType() == this.Const.EntityType.SpiderEggs || this.isKindOf(_actor, "lindwurm_tail"))
		{
			return;
		}

		if (!_actor.isAlliedWithPlayer() && !_actor.isAlliedWith(this.m.Faction) && !_actor.isResurrected())
		{
			this.m.Flags.set("HeadsCollected", this.m.Flags.get("HeadsCollected") + 1);
		}
	}

	function spawnEnemies()
	{
		if (this.m.Flags.get("HeadsCollected") >= this.m.Payment.MaxCount)
		{
			return false;
		}

		local tries = 0;
		local myTile = this.m.NextObjective.getTile();
		local tile;

		while (tries++ < 10)
		{
			local tile = this.getTileToSpawnLocation(myTile, 7, 11);

			if (tile.getDistanceTo(this.World.State.getPlayer().getTile()) <= 6)
			{
				continue;
			}

			local nearest_bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(tile);
			local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
			local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(tile);
			local nearest_barbarians = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(tile) : null;
			local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(tile) : null;

			if (nearest_bandits == null && nearest_goblins == null && nearest_orcs == null && nearest_barbarians == null && nearest_nomads == null)
			{
				this.logInfo("aucune base ennemie trouvée");
				return false;
			}

			local bandits_dist = nearest_bandits != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local goblins_dist = nearest_goblins != null ? nearest_goblins.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local orcs_dist = nearest_orcs != null ? nearest_orcs.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local barbarians_dist = nearest_barbarians != null ? nearest_barbarians.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local nomads_dist = nearest_nomads != null ? nearest_nomads.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local party;
			local origin;

			if (bandits_dist <= goblins_dist && bandits_dist <= orcs_dist && bandits_dist <= barbarians_dist && bandits_dist <= nomads_dist)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Brigands", false, this.Const.World.Spawn.BanditRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Brigand Hunters", false, this.Const.World.Spawn.BanditRoamers, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}

				party.setDescription("Une bande de brigands rudes et coriaces s\'attaquant aux faibles.");
				party.setFootprintType(this.Const.World.FootprintsType.Brigands);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

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
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_bandits;
			}
			else if (goblins_dist <= bandits_dist && goblins_dist <= orcs_dist && goblins_dist <= barbarians_dist && goblins_dist <= nomads_dist)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Goblin Raiders", false, this.Const.World.Spawn.GoblinRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Goblin Scouts", false, this.Const.World.Spawn.GoblinScouts, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}

				party.setDescription("Une bande de gobelins malicieux, petits mais rusés et à ne pas sous-estimer.");
				party.setFootprintType(this.Const.World.FootprintsType.Goblins);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 30);

				if (this.Math.rand(1, 100) <= 75)
				{
					local loot = [
						"supplies/strange_meat_item",
						"supplies/roots_and_berries_item",
						"supplies/pickled_mushrooms_item"
					];
					party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
				}

				if (this.Math.rand(1, 100) <= 33)
				{
					local loot = [
						"loot/goblin_carved_ivory_iconographs_item",
						"loot/goblin_minted_coins_item",
						"loot/goblin_rank_insignia_item"
					];
					party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
				}

				origin = nearest_goblins;
			}
			else if (barbarians_dist <= goblins_dist && barbarians_dist <= bandits_dist && barbarians_dist <= orcs_dist && barbarians_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).spawnEntity(tile, "Barbarians", false, this.Const.World.Spawn.Barbarians, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("Une bande de barbare tribales.");
				party.setFootprintType(this.Const.World.FootprintsType.Barbarians);
				party.getLoot().Money = this.Math.rand(0, 50);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 5);
				party.getLoot().Ammo = this.Math.rand(0, 30);

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bone_figurines_item");
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bead_necklace_item");
				}

				local r = this.Math.rand(2, 5);

				if (r == 2)
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
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_barbarians;
			}
			else if (nomads_dist <= barbarians_dist && nomads_dist <= goblins_dist && nomads_dist <= bandits_dist && nomads_dist <= orcs_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).spawnEntity(tile, "Nomads", false, this.Const.World.Spawn.NomadRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("Une bande de pillards du désert s\'attaquant à tous ceux qui tentent de traverser les mers de sable.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/dates_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/rice_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/dried_lamb_item");
				}

				origin = nearest_nomads;
			}
			else
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orc Marauders", false, this.Const.World.Spawn.OrcRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orc Scouts", false, this.Const.World.Spawn.OrcScouts, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}

				party.setDescription("Une bande d\'orcs menaçants, à la peau verte et dépassant n\'importe quel homme.");
				party.setFootprintType(this.Const.World.FootprintsType.Orcs);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Ammo = this.Math.rand(0, 10);
				party.addToInventory("supplies/strange_meat_item");
				origin = nearest_orcs;
			}

			party.getSprite("banner").setBrush(origin.getBanner());
			party.setAttackableByAI(false);
			party.setAlwaysAttackPlayer(true);
			local c = party.getController();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.State.getPlayer());
			c.addOrder(intercept);
			this.m.UnitsSpawned.push(party.getID());
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location1",
			this.m.Location1.getName()
		]);
		_vars.push([
			"location2",
			this.m.Location2.getName()
		]);
		_vars.push([
			"killcount",
			this.m.Flags.get("HeadsCollected")
		]);
		_vars.push([
			"noblehousename",
			this.World.FactionManager.getFaction(this.m.Faction).getNameOnly()
		]);
		_vars.push([
			"days",
			5 - (this.World.getTime().Days - this.m.Flags.get("StartDay"))
		]);
		_vars.push([
			"crucifiedman",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Location1 != null)
			{
				this.m.Location1.getSprite("selection").Visible = false;
			}

			if (this.m.Location2 != null)
			{
				this.m.Location2.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Location1 == null || this.m.Location1.isNull() || !this.m.Location1.isAlive())
			{
				return false;
			}

			if (this.m.Location2 == null || this.m.Location2.isNull() || !this.m.Location2.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			if (this.World.FactionManager.getFaction(this.m.Faction).getSettlements().len() < 3)
			{
				return false;
			}

			return true;
		}
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Location1 != null && !this.m.Location1.isNull() && _tile.ID == this.m.Location1.getTile().ID)
		{
			return true;
		}

		if (this.m.Location2 != null && !this.m.Location2.isNull() && _tile.ID == this.m.Location2.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Location1 != null)
		{
			_out.writeU32(this.m.Location1.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Location2 != null)
		{
			_out.writeU32(this.m.Location2.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local location1 = _in.readU32();

		if (location1 != 0)
		{
			this.m.Location1 = this.WeakTableRef(this.World.getEntityByID(location1));
		}

		local location2 = _in.readU32();

		if (location2 != 0)
		{
			this.m.Location2 = this.WeakTableRef(this.World.getEntityByID(location2));
		}

		this.contract.onDeserialize(_in);
	}

});

